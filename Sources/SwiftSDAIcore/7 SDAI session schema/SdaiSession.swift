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
			let active = self.activeModelTable.withLock{ $0 }
			let deleted = self.deletedModels.withLock{ $0 }

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

		public init(
			repositories: [SdaiRepository],
			errorEventCallback: ErrorEventCallback? = nil)
		{
			self.fallbackRepository = SdaiRepository(name: "FALLBACK", description: "session temporary fallback repository")

			self.errorEventCallback = errorEventCallback

			for repository in repositories + [self.fallbackRepository] {
				knownServers[repository.name] = repository
				repository.associate(with: self)
			}
		}

		//MARK: fallback model related
		public func prepareFallBackModels(
			for schemas: some Sequence<SchemaDefinition>,
			transaction: SdaiTransactionRW
		)
		{
			self._fallBackModels = [:]
			for schema in schemas {
				if let model = transaction.createSdaiModel(
					repository: fallbackRepository,
					modelName: schema.name + ".fallback",
					schema: schema)
				{
					let model = transaction.startReadWriteAccess(model: model)
					_fallBackModels[schema] = model
				}
			}
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

		public typealias ErrorEventCallback = @Sendable (_ errorEvent: ErrorEvent,
																					 _ isolation: isolated (any Actor)?) -> Void

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

		private let activeModelTable = Mutex<[SDAIModelID:ModelInfo]>([:])

		internal var activeModelInfos: some Collection<ModelInfo> {
			self.activeModelTable.withLock{ $0.values }
		}

		internal func activeModelInfo(
			for modelID: SDAIModelID
		) -> ModelInfo?
		{
			self.activeModelTable.withLock{ $0[modelID] }
		}


		private let deletedModels = Mutex<Set<SDAIModelID>>([])

		internal func isDeleted(
			modelWithID modelID: SDAIModelID
		) -> Bool
		{
			self.deletedModels.withLock{ $0.contains(modelID) }
		}

		internal func activateNew(
			model: SdaiModel,
			mode: AccessType
		)
		{
			let modelID = model.modelID

			guard self.activeModelInfo(for:modelID) == nil
			else { fatalError("internal logic error") }

			self.activeModelTable.withLock{ $0[modelID] = ModelInfo(instance: model, mode: mode) }
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

			if self.isDeleted(modelWithID: modelID) {
				return nil
			}

			if let modelInfo = self.activeModelInfo(for:modelID) {
				return modelInfo.instance
			}

			return model
		}

		internal func findAndActivateSdaiModel(
			modelID: SDAIModelID
		) -> SdaiModel?
		{
			if self.isDeleted(modelWithID: modelID) {
				return nil
			}

			if let modelInfo = self.activeModelInfo(for:modelID) {
				return modelInfo.instance
			}

			for repo in self.activeServers.values {
				if let model = repo.contents.findSdaiModel(withID: modelID) {
					let info = ModelInfo(instance: model, mode: .readOnly)
					self.activeModelTable.withLock{ $0[modelID] = info }
					return model
				}
			}

			return nil
		}

		internal func closeSdaiModel(
			modelID: SDAIModelID
		)
		{
			guard let modelInfo = self.activeModelInfo(for:modelID)
			else { fatalError("internal logic error") }

			if modelInfo.instance.repository == self.fallbackRepository {
				modelInfo.instance.contents.removeAll()
			}
			else {
				self.activeModelTable.withLock{ $0[modelID] = nil }
			}
		}

		internal func persistAndCloseSdaiModel(
			modelID: SDAIModelID
		)
		{
			guard let modelInfo = self.activeModelInfo(for:modelID),
						modelInfo.mode == .readWrite,
						!self.isDeleted(modelWithID: modelID)
			else { fatalError("internal logic error") }

			let repo = modelInfo.instance.repository
			if repo == self.fallbackRepository { return }

			repo.contents.add(model: modelInfo.instance)

			self.closeSdaiModel(modelID: modelID)
		}

		internal func persistAndCloseAllModels()
		{
			self.commitToDeleteAllModels()

			for modelInfo in self.activeModelInfos {
				let modelID = modelInfo.instance.modelID
				assert( !self.isDeleted(modelWithID: modelID) )

				if modelInfo.instance.repository == self.fallbackRepository { continue }

				switch modelInfo.mode {
					case .readOnly:
						self.closeSdaiModel(modelID: modelID)
					case .readWrite:
						self.persistAndCloseSdaiModel(modelID: modelID)
				}
			}
		}

		internal func persistAndContinueAllModels()
		{
			self.commitToDeleteAllModels()

			for modelInfo in self.activeModelInfos {
				let modelID = modelInfo.instance.modelID

				guard modelInfo.mode == .readWrite else { continue }
				assert( !self.isDeleted(modelWithID: modelID) )

				let repo = modelInfo.instance.repository
				if repo == self.fallbackRepository { continue }

				repo.contents.add(model: modelInfo.instance)

				let newEdition = modelInfo.instance.clone()
				let info = ModelInfo(instance: newEdition, mode: .readWrite)
				self.activeModelTable.withLock{ $0[newEdition.modelID] = info }
			}
		}

		internal func revertAndCloseAllModels()
		{
			for modelInfo in self.activeModelInfos {
				self.closeSdaiModel(modelID: modelInfo.instance.modelID)
			}

			self.deletedModels.withLock{ $0 = [] }
		}

		internal func revertAndContinueAllModels()
		{
			self.deletedModels.withLock{ $0 = [] }

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
				let info = ModelInfo(instance: newEdition, mode: .readWrite)
				activeModelTable.withLock{ $0[newEdition.modelID] = info }
			}
		}

		internal func deleteSdaiModel(
			modelID: SDAIModelID
		)
		{
			guard let modelInfo = self.activeModelInfo(for:modelID),
						!self.isDeleted(modelWithID: modelID),
						modelInfo.instance.repository != self.fallbackRepository
			else { fatalError("internal logic error") }

			self.deletedModels.withLock{ $0.insert(modelID); return }
		}

		internal func commitToDeleteAllModels()
		{
			for modelID in self.deletedModels.withLock({ $0 }) {
				guard let modelInfo = self.activeModelInfo(for:modelID)
				else { fatalError("internal logic error") }

				for schemaInstance in modelInfo.instance.associatedWith {
					let promoted = self.promoteSchemaInstanceToRW(
						schemaInstanceID: schemaInstance.schemaInstanceID)

					promoted.dissociate(from: modelInfo.instance)
				}

				let repo = modelInfo.instance.repository
				repo.contents.remove(model: modelInfo.instance)
				self.activeModelTable.withLock{ $0[modelID] = nil }
			}
			self.deletedModels.withLock{ $0 = [] }
		}

		internal func promoteSdaiModelToRW(
			modelID: SDAIModelID
		) -> SdaiModel
		{
			guard let modelInfo = activeModelInfo(for: modelID),
						!self.isDeleted(modelWithID: modelID)
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

			let info = ModelInfo(instance: promoted, mode: .readWrite)
			self.activeModelTable.withLock{ $0[modelID] = info }

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
