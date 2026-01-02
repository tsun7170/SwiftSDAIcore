//
//  SdaiSession.swift
//  
//
//  Created by Yoshida on 2021/04/11.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import Synchronization

extension SDAISessionSchema {
	
	/// task local access is only available within sdai_transactions.
	@TaskLocal
	static var activeSession: SdaiSession? = nil


	/// ISO 10303-22 (7.4.1) sdai_session
	/// 
	/// An SdaiSession represents the information describing an SDAI session at a point in time while the SDAI implementation is active.
	/// It contains information reflecting the state of the session with respect to transactions, errors, event recording, repositories and the data dictionary.
	///
	public final class SdaiSession: SDAI.Object, Sendable
	{
		//MARK: Attribute definitions:
		
		/// the characteristics of the SDAI implementation.
		public let sdaiImplementation: Implementation = Implementation()


		/// a boolean that has the value FALSE if the recording of events is inhibited;
		/// TRUE otherwise.   
		public internal(set) var recordingActive: BOOLEAN {
			get {
				_recordingActive.withLock{ $0 }
			}
			set {
				_recordingActive.withLock{ $0 = newValue }
			}
		}

		private let _recordingActive = Mutex<BOOLEAN>(false)


		/// the list of errors that have resulted from previously executed SDAI operations while event recording was active.
		public var errors: LIST<ErrorEvent> {
			_errors.withLock{ $0 }
		}

		private let _errors = Mutex<LIST<ErrorEvent>>([])

		/// the repositories available to the application in this session.
		/// The presence of particular repositories depends on the specific installation of an SDAI implementation.
		nonisolated(unsafe)
		public private(set) var knownServers: [STRING:SdaiRepository] = [:]


		/// the repositories currently open in the session.
		public var activeServers: [STRING:SdaiRepository] {
			_activeServers.withLock{ $0 }
		}

		private let _activeServers = Mutex<[STRING:SdaiRepository]>([:])

		/// the SdaiModels currently being accessed in the session.
		public var activeModels: SET<SdaiModel> {
			let active = self.activeModelTable
			let deleted = self.deletedModelIDs

			let result = active
				.filter{ !deleted.contains($0.key) }
				.map{ $0.value.instance }
			return SET( result )
		}

		public var activeSchemaInstances: SET<SchemaInstance> {
			let active = self.activeSchemaInstanceTable.withLock{ $0 }
			let deleted = self.deletedSchemaInstances.withLock{ $0 }

			let result = active
				.filter{ !deleted.contains($0.key) }
				.map{ $0.value.instance }
			return SET( result )
		}


		/// if present, the schema instance, based upon the SDAI session schema, with which the SDAI-models constituting the data dictionary are associated.
		/// For SDAI implementations claiming conformance to implementation classes 2 through 6 this attribute shall have a value specified.
		/// - Note: THE CURRENT IMPLEMENTATION DOES NOT SUPPORT DATA DICTIONARY FOR THE SDAI SESSION SCHEMA
		public let dataDictionary: [SDAIDictionarySchema.ExpressId:SchemaDefinition] = [:]


		/// the transaction making access to SDAI-models and schema instances available in the current session.
		nonisolated(unsafe)
		public internal(set) var activeTransaction: SdaiTransaction? = nil






		//MARK: - swift language binding

		internal let fallbackRepository: SdaiRepository

		nonisolated(unsafe)
		private var _fallBackModels: [SchemaDefinition:SdaiModel] = [:]

    nonisolated(unsafe)
    internal private(set) var governingSchema: SchemaDefinition? = nil

		internal init(
			repositories: [SdaiRepository],
			errorEventCallback: ErrorEventCallback?/* = nil*/,
      maxConcurrency: Int/* = ProcessInfo.processInfo.processorCount + 2*/,
      maxCacheUpdateAttempts: Int /*= 1000*/,
      maxUsedinNesting: Int /*= 2*/,
      runUsedinCacheWarming: Bool /*= true*/,
      maxValidationTaskSegmentation: Int /*= 400*/,
      minValidationTaskChunkSize: Int /*= 8*/,
      validateTemporaryEntities: Bool,
    )
		{
			self.fallbackRepository = SdaiRepository(name: "FALLBACK", description: "session temporary fallback repository")

			self.errorEventCallback = errorEventCallback

      self.maxConcurrency = maxConcurrency
      self.maxCacheUpdateAttempts = maxCacheUpdateAttempts

      self.maxUsedinNesting = maxUsedinNesting
      self.runUsedinCacheWarming = runUsedinCacheWarming

      self.maxValidationTaskSegmentation = maxValidationTaskSegmentation
      self.minValidationTaskChunkSize = minValidationTaskChunkSize

      self.validateTemporaryEntities = validateTemporaryEntities

			for repository in repositories + [self.fallbackRepository] {
				knownServers[repository.name] = repository
				repository.associate(with: self)
			}
		}

    //MARK: concurrency related
    public let maxConcurrency: Int
    public let maxCacheUpdateAttempts: Int

    public let maxUsedinNesting: Int
    public let runUsedinCacheWarming: Bool

    public let maxValidationTaskSegmentation: Int
    public let minValidationTaskChunkSize: Int

    public let validateTemporaryEntities: Bool


    public func terminateCachingTasks() {
      for model in activeModels {
        model.terminateCachingTask()
      }
    }

    public func toCompleteCachingTasks() async {
      for model in activeModels {
        await model.toCompleteCachingTask()
      }
    }

		//MARK: fallback model related
		internal func prepareFallBackModels(
			for schemas: some Collection<SchemaDefinition>,
			transaction: SdaiTransactionRW
		)
		{
      guard transaction.owningSession?.activeServers[fallbackRepository.name] == nil
      else { return }
			transaction.owningSession?.open(repository: fallbackRepository)
			
			self._fallBackModels = [:]
			for schema in schemas {
//				debugPrint("creating model[\(schema.name + ".fallback")]")
				if let model = transaction.createSdaiModel(
					repository: fallbackRepository,
					modelName: schema.name + ".fallback",
					schema: schema)
				{
					_fallBackModels[schema] = model
				}
			}

      if schemas.count == 1,
         let theSchema = schemas.first
      { self.governingSchema = theSchema }
      else
      { self.governingSchema = nil }
		}

		public func fallBackModel(
			for schema:SchemaDefinition
		) -> SdaiModel
		{
			guard let model = self._fallBackModels[schema] else {
				SDAI.raiseErrorAndTrap(
					.MO_NEXS,
					detail: "fallback model for schema:\(schema.name) not prepared")
			}
			return model
		}

		//MARK: error event managements
		internal func append(errorEvent: sending ErrorEvent) {
			self._errors.withLock{ $0.append(errorEvent) }
		}

		internal func resetErrors() {
			self._errors.withLock{ $0 = [] }
		}

    public typealias ErrorEventCallback =
    @Sendable (_ errorEvent: ErrorEvent,
               _ isolation: isolated (any Actor)? ) -> Void

		internal let errorEventCallback: ( ErrorEventCallback )?


		//MARK: repository managements
		public func activeServer(
			named name: STRING
		) -> SdaiRepository?
		{
			self._activeServers.withLock{ $0[name] }
		}

		internal func checkRepositoriesOpen(
			relatedTo instance: SchemaInstance
		) -> Bool
		{
			guard let _ = self.activeServer(named:instance.repository.name) else {
				SDAI.raiseErrorAndContinue(.RP_NOPN(instance.repository), detail: "The repository is not open.")
				return false
			}
			for model in instance.associatedModels {
				guard let _ = self.checkRepositoryOpen(relatedTo: model) else { return false }
			}
			return true
		}

		internal func checkRepositoryOpen(
			relatedTo model: SdaiModel
		) -> SdaiRepository?
		{
			guard let repo = self.activeServer(named:model.repository.name) else {
				SDAI.raiseErrorAndContinue(.RP_NOPN(model.repository), detail: "The repository is not open.")
				return nil
			}
			return repo
		}

		internal func _open(
			repository: SdaiRepository
		)
		{
			self._activeServers.withLock{ $0[repository.name] = repository }
		}

		internal func close(
			repository: SdaiRepository
		)
		{
			self._activeServers.withLock{ $0[repository.name] = nil }

			for si in repository.contents.schemaInstances {
				self.closeSchemaInstance(schemaInstanceID: si.schemaInstanceID)
			}

			for model in repository.contents.models {
        self.closeSdaiModel(modelID: model.modelID)
			}
		}

		//MARK: schema_instance managements
		internal struct SchemaInstanceInfo {
			let instance: SchemaInstance
			let mode: AccessType
		}

		private let activeSchemaInstanceTable = Mutex<[SchemaInstanceID:SchemaInstanceInfo]>([:])

		internal var activeSchemaInstanceInfos: some Collection<SchemaInstanceInfo> {
			self.activeSchemaInstanceTable.withLock{ $0.values }
		}

		internal func activeSchemaInstanceInfo(
			for instanceID: SchemaInstanceID
		) -> SchemaInstanceInfo?
		{
			self.activeSchemaInstanceTable.withLock{ $0[instanceID] }
		}


		private let deletedSchemaInstances = Mutex<Set<SchemaInstanceID>>([])

		internal func isDeleted(
			instanceWithID instanceID: SchemaInstanceID
		) -> Bool
		{
			self.deletedSchemaInstances.withLock{ $0.contains(instanceID) }
		}

		internal func activateNew(
			schemaInstance: SchemaInstance
		)
		{
			let schemaInstanceID = schemaInstance.schemaInstanceID

			guard self.activeSchemaInstanceInfo(for: schemaInstanceID) == nil
			else { fatalError("internal logic error") }

			self.activeSchemaInstanceTable.withLock{ $0[schemaInstanceID] =
				SchemaInstanceInfo(instance: schemaInstance, mode: .readWrite) }
		}

		public func findLatestEdition(
			schemaInstance: SDAIPopulationSchema.SchemaInstance
		) -> SDAIPopulationSchema.SchemaInstance?
		{
			let schemaInstanceID = schemaInstance.schemaInstanceID

			if self.deletedSchemaInstances.withLock({ $0.contains(schemaInstanceID) }) {
				return nil
			}

			if let siInfo = self.activeSchemaInstanceInfo(for:schemaInstanceID) {
				return siInfo.instance
			}

			return schemaInstance
		}

		internal func findAndActivateSchemaInstance(
			schemaInstanceID: SchemaInstanceID
		) -> SchemaInstance?
		{
			if self.deletedSchemaInstances.withLock({ $0.contains(schemaInstanceID) }) {
				return nil
			}

			if let siInfo = self.activeSchemaInstanceInfo(for: schemaInstanceID) {
				return siInfo.instance
			}

			for repo in self.activeServers.values {
				if let si = repo.contents.findSchemaInstance(withID: schemaInstanceID) {
					self.activeSchemaInstanceTable.withLock{ $0[schemaInstanceID] = SchemaInstanceInfo(instance: si, mode: .readOnly) }
					return si
				}
			}
			return nil
		}

		internal func closeSchemaInstance(
			schemaInstanceID: SchemaInstanceID
		)
		{
			let isDeleted = self.isDeleted(instanceWithID: schemaInstanceID)

			let wasActive = self.activeSchemaInstanceTable.withLock{ $0.removeValue(forKey: schemaInstanceID) } != nil

			if isDeleted || !wasActive {
				fatalError("internal logic error")
			}
		}

		internal func persistAndCloseSchemaInstance(
			schemaInstanceID: SchemaInstanceID
		)
		{
			guard let siInfo = activeSchemaInstanceInfo(for:schemaInstanceID),
						!self.isDeleted(instanceWithID: schemaInstanceID)
			else { fatalError("internal logic error") }

			if siInfo.mode == .readWrite {
				let repo = siInfo.instance.repository
				repo.contents.add(schemaInstance: siInfo.instance)
			}
			self.closeSchemaInstance(schemaInstanceID: schemaInstanceID)
		}

		internal func persistAndCloseAllSchemaInstances()
		{
			self.commitToDeleteAllSchemaInstances()

			for siInfo in self.activeSchemaInstanceInfos {
				let siID = siInfo.instance.schemaInstanceID
				assert(!self.isDeleted(instanceWithID: siID))

				self.persistAndCloseSchemaInstance(schemaInstanceID: siID)
			}
		}

		internal func persistAndContinueAllSchemaInstances()
		{
			self.commitToDeleteAllSchemaInstances()

			for siInfo in self.activeSchemaInstanceInfos {
				guard siInfo.mode == .readWrite else { continue }

				let repo = siInfo.instance.repository
				repo.contents.add(schemaInstance: siInfo.instance)

				self.activeSchemaInstanceTable
					.withLock{ $0[siInfo.instance.schemaInstanceID] = SchemaInstanceInfo(instance: siInfo.instance, mode: .readOnly) }
			}
		}

		internal func revertAndCloseAllSchemaInstances()
		{
			self.deletedSchemaInstances.withLock{ $0 = [] }
			self.activeSchemaInstanceTable.withLock{ $0 = [:] }
		}

		internal func revertAndContinueAllSchemaInstances()
		{
			self.deletedSchemaInstances.withLock{ $0 = [] }

			for siInfo in self.activeSchemaInstanceInfos {
				guard siInfo.mode == .readWrite else { continue }

				let repo = siInfo.instance.repository
				let siID = siInfo.instance.schemaInstanceID
				guard let original = repo.contents.findSchemaInstance(withID: siID)
				else {
					//in the case of newly created instance
					self.activeSchemaInstanceTable.withLock{ $0[siID] = nil }
					continue
				}

				activeSchemaInstanceTable.withLock{ $0[siID] = SchemaInstanceInfo(instance: original, mode: .readOnly) }
			}
		}


		internal func deleteSchemaInstance(
			schemaInstanceID: SchemaInstanceID
		)
		{
			guard self.activeSchemaInstanceInfo(for: schemaInstanceID) != nil
			else { fatalError("internal logic error") }

			self.deletedSchemaInstances.withLock{ $0.insert(schemaInstanceID); return }
		}

		internal func commitToDeleteAllSchemaInstances()
		{
			for siID in self.deletedSchemaInstances.withLock({ $0 }) {
				guard let siInfo = self.activeSchemaInstanceInfo(for:siID)
				else { fatalError("internal logic error") }

				let repo = siInfo.instance.repository
				repo.contents.remove(schemaInstance: siInfo.instance)
				self.activeSchemaInstanceTable.withLock{ $0[siID] = nil }
			}
			self.deletedSchemaInstances.withLock{ $0 = [] }
		}

		internal func promoteSchemaInstanceToRW(
			schemaInstanceID: SchemaInstanceID
		) -> SchemaInstance
		{
			guard let siInfo = activeSchemaInstanceInfo(for: schemaInstanceID),
						!self.isDeleted(instanceWithID: siInfo.instance.schemaInstanceID)
			else { fatalError("internal logic error") }

			if siInfo.mode == .readWrite { return siInfo.instance }

			let repo = siInfo.instance.repository
			let promoted: SDAIPopulationSchema.SchemaInstance

			if let _ = repo.contents.findSchemaInstance(withID: schemaInstanceID) {
				promoted = siInfo.instance.clone()
			}
			else {
				promoted = siInfo.instance
			}

			activeSchemaInstanceTable.withLock{ $0[schemaInstanceID] = SchemaInstanceInfo(instance: promoted, mode: .readWrite) }

			return promoted
		}

		//MARK: sdai_model managements
		internal struct ModelInfo {
			let instance: SdaiModel
			let mode: AccessType
		}

    private typealias LaneNo = Int

    private func laneNo(_ modelID: SDAIModelID) -> LaneNo
    {
      var hasher = Hasher()
      hasher.combine(modelID)
      let lane = hasher.finalize() & 0b11
      return LaneNo(lane)
    }

    private let activeModelTable0 = Mutex<[SDAIModelID:ModelInfo]>([:])
    private let activeModelTable1 = Mutex<[SDAIModelID:ModelInfo]>([:])
    private let activeModelTable2 = Mutex<[SDAIModelID:ModelInfo]>([:])
		private let activeModelTable3 = Mutex<[SDAIModelID:ModelInfo]>([:])

    private func setActiveModelTable(
      info modelInfo: ModelInfo?,
      for modelID: SDAIModelID,
      laneNo: LaneNo)
    {
      self.activeTransaction?.updateModelCache(
        modelID:modelID, value:modelInfo?.instance)

      switch laneNo {
        case 1:
          self.activeModelTable1.withLock{ $0[modelID] = modelInfo }
        case 2:
          self.activeModelTable2.withLock{ $0[modelID] = modelInfo }
        case 3:
          self.activeModelTable3.withLock{ $0[modelID] = modelInfo }

        default:
          self.activeModelTable0.withLock{ $0[modelID] = modelInfo }
      }
    }

    internal var activeModelIDs: some Collection<SDAIModelID> {
      let info0 = self.activeModelTable0.withLock{ $0.keys }
      let info1 = self.activeModelTable1.withLock{ $0.keys }
      let info2 = self.activeModelTable2.withLock{ $0.keys }
      let info3 = self.activeModelTable3.withLock{ $0.keys }
      let joined = [info0, info1, info2, info3].joined()
      return joined
    }

		internal var activeModelInfos: some Collection<ModelInfo> {
      let info0 = self.activeModelTable0.withLock{ $0.values }
      let info1 = self.activeModelTable1.withLock{ $0.values }
      let info2 = self.activeModelTable2.withLock{ $0.values }
			let info3 = self.activeModelTable3.withLock{ $0.values }
      let joined = [info0, info1, info2, info3].joined()
      return joined
		}

    private var activeModelTable: [SDAIModelID:ModelInfo] {
      let info0 = self.activeModelTable0.withLock{ $0 }
      let info1 = self.activeModelTable1.withLock{ $0 }
      let info2 = self.activeModelTable2.withLock{ $0 }
      let info3 = self.activeModelTable3.withLock{ $0 }

      let merged01 = info0.merging(info1) { _,_ in fatalError("duplicated entries in activeModelTable0 and activeModelTable1") }
      let merged23 = info2.merging(info3) { _,_ in fatalError("duplicated entries in activeModelTable2 and activeModelTable3") }
      let merged = merged01.merging(merged23) { _,_ in fatalError("duplicated entries in merged01 and merged23") }

      return merged
    }

    internal func activeModelInfo(
      for modelID: SDAIModelID
    ) -> ModelInfo?
    {
      let laneNo = self.laneNo(modelID)
      return self.activeModelInfo(for: modelID, laneNo: laneNo)
    }

		private func activeModelInfo(
			for modelID: SDAIModelID,
      laneNo: LaneNo
		) -> ModelInfo?
		{
      let modelInfo: ModelInfo?
      switch laneNo {
        case 1:
          modelInfo = self.activeModelTable1.withLock{ $0[modelID] }
        case 2:
          modelInfo = self.activeModelTable2.withLock{ $0[modelID] }
        case 3:
          modelInfo = self.activeModelTable3.withLock{ $0[modelID] }

        default:
          modelInfo = self.activeModelTable0.withLock{ $0[modelID] }
      }

      self.activeTransaction?.updateModelCache(
        modelID:modelID, value:modelInfo?.instance)

      return modelInfo
		}


    private let deletedModels0 = Mutex<Set<SDAIModelID>>([])
    private let deletedModels1 = Mutex<Set<SDAIModelID>>([])
    private let deletedModels2 = Mutex<Set<SDAIModelID>>([])
		private let deletedModels3 = Mutex<Set<SDAIModelID>>([])

    private func clearDeletedModels()
    {
      deletedModels0.withLock{ $0 = [] }
      deletedModels1.withLock{ $0 = [] }
      deletedModels2.withLock{ $0 = [] }
      deletedModels3.withLock{ $0 = [] }
    }

    private var deletedModelIDs: some Collection<SDAIModelID> {
      let models0 = deletedModels0.withLock{ $0 }
      let models1 = deletedModels1.withLock{ $0 }
      let models2 = deletedModels2.withLock{ $0 }
      let models3 = deletedModels3.withLock{ $0 }

      let joined = [models0, models1, models2, models3].joined()
      return joined
    }

    private var deletedModelLaneIDs: some Sequence<(SDAIModelID,LaneNo)> {
      let models0 = deletedModels0.withLock{ $0 }
      let models1 = deletedModels1.withLock{ $0 }
      let models2 = deletedModels2.withLock{ $0 }
      let models3 = deletedModels3.withLock{ $0 }

      let lanes0 = Array(repeating: LaneNo(0), count: models0.count)
      let lanes1 = Array(repeating: LaneNo(1), count: models1.count)
      let lanes2 = Array(repeating: LaneNo(2), count: models2.count)
      let lanes3 = Array(repeating: LaneNo(3), count: models3.count)

      let joined = [
        zip(models0,lanes0),
        zip(models1,lanes1),
        zip(models2,lanes2),
        zip(models3,lanes3)
      ].joined()

      return joined
    }

    internal func isDeleted(
      modelWithID modelID: SDAIModelID
    ) -> Bool
    {
      let laneNo = self.laneNo(modelID)
      return self.isDeleted(modelWithID: modelID, laneNo: laneNo)
    }

		private func isDeleted(
			modelWithID modelID: SDAIModelID,
      laneNo: LaneNo
		) -> Bool
		{
      guard self.activeTransaction?.mode == .readWrite
      else { return false }

      switch laneNo {
        case 1:
          return self.deletedModels1.withLock{ $0.contains(modelID) }
        case 2:
          return self.deletedModels2.withLock{ $0.contains(modelID) }
        case 3:
          return self.deletedModels3.withLock{ $0.contains(modelID) }

        default:
          return self.deletedModels0.withLock{ $0.contains(modelID) }
      }
		}

		internal func activateNew(
			model: SdaiModel,
			mode: AccessType
    )
		{
			let modelID = model.modelID
      let laneNo =  laneNo(modelID)

      guard self.activeModelInfo(for:modelID, laneNo: laneNo) == nil
      else { fatalError("internal logic error") }

      self.setActiveModelTable(
        info: ModelInfo(instance: model, mode: mode),
        for: modelID,
        laneNo: laneNo)
		}

		internal func startReadOnlyAccess(
			model: SdaiModel
		)
		{
			self.activateNew(model: model, mode: .readOnly)
		}

		public func findLatestEdition(
			model: SdaiModel
		) -> SdaiModel?
		{
			let modelID = model.modelID
      let laneNo = laneNo(modelID)

      if self.isDeleted(modelWithID: modelID, laneNo: laneNo) {
				return nil
			}

      if let modelInfo = self.activeModelInfo(for:modelID, laneNo: laneNo) {
				return modelInfo.instance
			}

			return model
		}

    internal func findAndActivateSdaiModel(
      modelID: SDAIModelID
    ) -> SdaiModel?
    {
      if let model = self.activeTransaction?.lookupModelCache(modelID: modelID) {
        return model
      }

      let laneNo = laneNo(modelID)
      let model = self.findAndActivateSdaiModel(modelID: modelID, laneNo: laneNo)

      return model
    }

    private func findAndActivateSdaiModel(
      modelID: SDAIModelID,
      laneNo: LaneNo
    ) -> SdaiModel?
    {
      if self.isDeleted(modelWithID: modelID, laneNo: laneNo) {
				return nil
			}

      if let modelInfo = self.activeModelInfo(for:modelID, laneNo: laneNo) {
        return modelInfo.instance
			}

			for repo in self.activeServers.values {
				if let model = repo.contents.findSdaiModel(withID: modelID) {
          self.setActiveModelTable(
            info: ModelInfo(instance: model, mode: .readOnly),
            for: modelID,
            laneNo: laneNo)

          return model
				}
			}

			return nil
		}

    internal func closeSdaiModel(modelID: SDAIModelID )
    {
      let laneNo = laneNo(modelID)
      self.closeSdaiModel(modelID: modelID, laneNo: laneNo)
    }

		private func closeSdaiModel(
			modelID: SDAIModelID,
      laneNo: LaneNo
		)
		{
      guard let modelInfo = self.activeModelInfo(for:modelID, laneNo: laneNo)
			else { fatalError("internal logic error") }

			if modelInfo.instance.repository == self.fallbackRepository {
				modelInfo.instance.contents.removeAll()
			}
			else {
        self.setActiveModelTable(info: nil, for: modelID, laneNo: laneNo)
			}

      self.activeTransaction?.updateModelCache(modelID: modelID, value: nil)
		}

    internal func persistAndCloseSdaiModel(
      modelID: SDAIModelID
    )
    {
      let laneNo = self.laneNo(modelID)
      self.persistAndCloseSdaiModel(modelID: modelID, laneNo: laneNo)
    }

		private func persistAndCloseSdaiModel(
			modelID: SDAIModelID,
      laneNo: LaneNo
		)
		{
      guard let modelInfo = self.activeModelInfo(for:modelID, laneNo: laneNo),
						modelInfo.mode == .readWrite,
            !self.isDeleted(modelWithID: modelID, laneNo: laneNo)
			else { fatalError("internal logic error") }

			let repo = modelInfo.instance.repository
			if repo == self.fallbackRepository { return }

			repo.contents.add(model: modelInfo.instance)

      self.closeSdaiModel(modelID: modelID, laneNo: laneNo)
		}

		internal func persistAndCloseAllModels()
		{
			self.commitToDeleteAllModels()

			for modelInfo in self.activeModelInfos {
				let modelID = modelInfo.instance.modelID
        let laneNo = laneNo(modelID)
        assert( !self.isDeleted(modelWithID: modelID, laneNo: laneNo) )

				if modelInfo.instance.repository == self.fallbackRepository { continue }

				switch modelInfo.mode {
					case .readOnly:
            self.closeSdaiModel(modelID: modelID, laneNo: laneNo)
					case .readWrite:
            self.persistAndCloseSdaiModel(modelID: modelID, laneNo: laneNo)
				}
			}
		}

		internal func persistAndContinueAllModels()
		{
			self.commitToDeleteAllModels()

			for modelInfo in self.activeModelInfos {
				let modelID = modelInfo.instance.modelID
        let laneNo = self.laneNo(modelID)

				guard modelInfo.mode == .readWrite else { continue }
        assert( !self.isDeleted(modelWithID: modelID, laneNo: laneNo) )

				let repo = modelInfo.instance.repository
				if repo == self.fallbackRepository { continue }

				repo.contents.add(model: modelInfo.instance)

				let newEdition = modelInfo.instance.clone()
        let newModelID = newEdition.modelID
        let newLaneNo = self.laneNo(newModelID)

        self.setActiveModelTable(
          info: ModelInfo(instance: newEdition, mode: .readWrite),
          for: newModelID,
          laneNo: newLaneNo)
			}
		}

		internal func revertAndCloseAllModels()
		{
			for modelInfo in self.activeModelInfos {
        self.closeSdaiModel(modelID: modelInfo.instance.modelID)
			}

      self.clearDeletedModels()
		}

		internal func revertAndContinueAllModels()
		{
      self.clearDeletedModels()

			for modelInfo in activeModelInfos {
				guard modelInfo.mode == .readWrite else { continue }

				let repo = modelInfo.instance.repository
				let modelID = modelInfo.instance.modelID
				guard let original = repo.contents.findSdaiModel(withID: modelID)
				else {
					// in the case of newly created model
          self.closeSdaiModel(modelID: modelID)
					continue
				}

				assert( repo != self.fallbackRepository )
				let newEdition = original.clone()
        self.setActiveModelTable(
          info: ModelInfo(instance: newEdition, mode: .readWrite),
          for: newEdition.modelID,
          laneNo: self.laneNo(newEdition.modelID))
			}
		}

    internal func deleteSdaiModel(
      modelID: SDAIModelID
    )
    {
      let laneNo = self.laneNo(modelID)
      self.deleteSdaiModel(modelID: modelID, laneNo: laneNo)
    }

		private func deleteSdaiModel(
			modelID: SDAIModelID,
      laneNo: LaneNo
		)
		{
      guard let modelInfo = self.activeModelInfo(for:modelID, laneNo: laneNo),
            !self.isDeleted(modelWithID: modelID, laneNo: laneNo),
						modelInfo.instance.repository != self.fallbackRepository
			else { fatalError("internal logic error") }

      switch laneNo {
        case 1:
          self.deletedModels1.withLock{ $0.insert(modelID); return }
        case 2:
          self.deletedModels2.withLock{ $0.insert(modelID); return }
        case 3:
          self.deletedModels3.withLock{ $0.insert(modelID); return }

        default:
          self.deletedModels0.withLock{ $0.insert(modelID); return }
      }
		}

		internal func commitToDeleteAllModels()
		{
			for (modelID,laneNo) in self.deletedModelLaneIDs {
        guard let modelInfo = self.activeModelInfo(for:modelID, laneNo: laneNo)
				else { fatalError("internal logic error") }

				for schemaInstance in modelInfo.instance.associatedWith {
					let promoted = self.promoteSchemaInstanceToRW(
						schemaInstanceID: schemaInstance.schemaInstanceID)

					promoted.dissociate(from: modelInfo.instance)
				}//for

				let repo = modelInfo.instance.repository
				repo.contents.remove(model: modelInfo.instance)
        self.setActiveModelTable(info: nil, for: modelID, laneNo: laneNo)
			}//for

      self.clearDeletedModels()
		}

    internal func promoteSdaiModelToRW(
      modelID: SDAIModelID
    ) -> SdaiModel
    {
      let laneNo = self.laneNo(modelID)
      return self.promoteSdaiModelToRW(modelID: modelID, laneNo: laneNo)
    }

    private func promoteSdaiModelToRW(
			modelID: SDAIModelID,
      laneNo: LaneNo
		) -> SdaiModel
		{
      guard let modelInfo = activeModelInfo(for: modelID, laneNo: laneNo),
            !self.isDeleted(modelWithID: modelID, laneNo: laneNo)
			else { fatalError("internal logic error") }

			if modelInfo.mode == .readWrite { return modelInfo.instance }

			let repo = modelInfo.instance.repository
			let promoted: SDAIPopulationSchema.SdaiModel

			if let _ = repo.contents.findSdaiModel(withID: modelID)
			{
				promoted = modelInfo.instance.clone()
			}
			else {
				promoted = modelInfo.instance
			}

      assert(promoted.modelID == modelID)

      self.setActiveModelTable(
        info: ModelInfo(instance: promoted, mode: .readWrite),
        for: modelID,
        laneNo: laneNo)

			promoted.notifyReadWriteModeChanged(sdaiModel: promoted)
			return promoted
		}

	}//class

	//MARK: - implementation
	/// ISO 10303-22 (7.4.2) implementation
	/// 
	/// An Implementation represents a software product that provides the functionality defined by an SDAI language binding.   
	public final class Implementation: SDAI.Object, Sendable
	{

		//MARK: Attribute definitions:
		
		/// the name of Implementation assigned by the implementor.
		public let name: STRING = "SwiftSDAIcore"
		
		/// the software version level of the Implementation assigned by the implementor.
		public let level: STRING = "2.0.0"

		/// the version of ISO 10303-22 to which the implementation conforms.
		/// 
		/// The value of this attribute shall follow the registration technique defined in ISO 10303-1: 4.3 and shall be the object identifier for the appropriate version of ISO 10303-22 (see C.1)  
		public let sdaiVersion: STRING = "{ iso standard 10303 part(22) version(0) }"
		
		/// the version of the SDAI language binding supported as specified in the SDAI language binding.
		public let bindingVersion: STRING = "2.0.0"

		/// the implementation class specified in ISO 10303-22 to which the Implementation conforms (see 13.2).
		public let implementationClass: INTEGER = 5 // plus Complete evaluation



		/// the level of transaction supported by the implementation (see 13.1.1).
		public let transactionLevel: INTEGER = 3	// Transactions

		/// the level of expression evaluation supported by the implementation (see 13.1.2).
		public let expressionLevel: INTEGER = 4 // Complete evaluation

		/// the level of event recording supported by the implementation (see 13.1.3). 
		public let recordingLevel: INTEGER = 2 // Recording supported

		/// the level of SCOPE supported by the implementation (see 13.1.4).
		public let scopeLevel: INTEGER = 1 // No SCOPE supported, as ISO 10303-21 does not define SCOPE

		/// the level of domain equivalence supported by the implementation (see 13.1.5).
		public let domainEquivalenceLevel: INTEGER = 1 // No domain equivalence

	}
}
