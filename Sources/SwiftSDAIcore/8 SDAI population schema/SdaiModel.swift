//
//  SdaiModel.swift
//  
//
//  Created by Yoshida on 2021/04/11.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import Synchronization

extension SDAIPopulationSchema {
	
	//MARK: - SdaiModel
	/// ISO 10303-22 (8.4.2) sdai_model
  /// 
	/// An SdaiModel is a grouping mechanism consisting of a set of related entity instances based upon a SchemaDefinition.
  ///
	/// **Formal propositions:**
  /// UR1: The name shall be unique within the repository containing the SdaiModel.
	/// 
	public actor SdaiModel: SDAI.Object, SDAI.CacheHolder, Sendable
	{

		//MARK: Attribute definitions:

		/// the identifier for this SdaiModel. The name is case sensitive.
    nonisolated
		public internal(set) var name: STRING {
			get {
				_name.withLock{ $0 }
			}
			set {
				_name.withLock{ $0 = newValue }
			}
		}
		private let _name = Mutex<STRING>("")

		/// the collection mechanism for entity instances within the SdaiModel.
    nonisolated
		public let contents: SdaiModelContents
		
		/// the schema that defines the structure of the data that appears in the SdaiModel.
    nonisolated
		public let underlyingSchema: SDAIDictionarySchema.SchemaDefinition
		
		/// the repository within which the SdaiModel was created.
    nonisolated
		public unowned let repository: SDAISessionSchema.SdaiRepository
		
		/// if present, the creation date or date of most recent modification, including creation or deletion, to an entity instance within the current SdaiModel.
    nonisolated
		public var changeDate: SDAISessionSchema.TimeStamp {
			self._changeDate.withLock{ $0 }
		}
		private let _changeDate = Mutex<SDAISessionSchema.TimeStamp>(Date())

    nonisolated
		internal func updateChangeDate() {
			self._changeDate.withLock{ $0 = Date() }
		}

		/// if present, the current access mode for the SdaiModel. If not present, the SdaiModel is not open.
    nonisolated
    public var mode: SDAISessionSchema.AccessType? {
      guard let session = SDAISessionSchema.activeSession
      else {
        SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "can not access SDAISessionSchema.activeSession")
        return nil
      }

      if let transaction = session.activeTransaction,
         !transaction.modelsMayBeMutable
      {
        return .readOnly
      }

      guard let modelInfo = session.activeModelInfo(for:self.modelID),
            modelInfo.instance == self
      else { return nil }

      return modelInfo.mode
    }//var

		/// the schema instances with which the SdaiModel has been associated.
    nonisolated
		public var associatedWith: some Collection<SchemaInstance> {
			get {
				var result: [SchemaInstance] = []

				guard let session = SDAISessionSchema.activeSession
        else {
          SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "can not access SDAISessionSchema.activeSession")
          return result
        }

				for repo in session.knownServers.values {
					for instance in repo.contents.schemaInstances {
						guard let instance = session.findLatestEdition(schemaInstance: instance)
						else { continue }

						if let _ = instance.associatedModel(withID: self.modelID) {
							result.append(instance)
						}
					}//instance
				}//repo

				return result
			}
		}

    //MARK: SDAI operations
    /// ISO 10303-22 (10.7.8) Get entity definition
    ///
    /// This operation returns the identifier of an entity_definition from the data dictionary based upon the entity name from the schema upon which the specified sdai_model is based.
    ///
    /// - Parameter entityName: The name of the entity type of interest.
    /// - Returns: The SDAI data dictionary instance of entity_definition from Model.underlying_ schema entities that has entity_definition.name = EntityName.
    ///
    /// defined in: ``SDAIPopulationSchema/SdaiModel``
    ///
    public func getEntityDefinition(entityName: SDAIParameterDataSchema.StringValue) -> SDAIDictionarySchema.EntityDefinition?
    {
      let schema = self.underlyingSchema
      guard let entityDef = schema.entities[entityName]
      else {
        SDAI.raiseErrorAndContinue(.ED_NDEF, detail: "entity with  name[\(entityName)] is not defined.")
        return nil
      }
      return entityDef
    }


		//MARK: swift language binding
		public typealias ComplexEntityID = P21Decode.EntityInstanceName
		public typealias SDAIModelID = UUID

    /// A unique identifier (UUID) for this SdaiModel instance.
    /// This identifier is used to distinguish between different models within the system.
    nonisolated
		public let modelID: SDAIModelID	// for this SdaiModel

		internal init(
			repository: SDAISessionSchema.SdaiRepository,
			modelName: STRING,
			schema: SDAIDictionarySchema.SchemaDefinition
		)
		{
			self.modelID = SDAIModelID()
			self.repository = repository
			self._name.withLock{ $0 = modelName }
			self.underlyingSchema = schema
			self.contents = SdaiModelContents()

			self.contents.fixup(owner: self)
			repository.contents.add(model: self)
		}


		private init(from original: SdaiModel)
		{
			self.modelID = original.modelID
			self.repository = original.repository
			self._name.withLock{ $0 = original.name }
			self.underlyingSchema = original.underlyingSchema
			self.contents = SdaiModelContents()
			self._changeDate.withLock{ $0 = original.changeDate }

			self.contents.fixup(owner: self)
			repository.contents.add(model: self)
		}

    nonisolated
		internal func clone() -> SdaiModel {
			let cloned = SdaiModel(from: self)
			cloned.contents.duplicateContents(from: self.contents)
			return cloned
		}


		
		/// unique temporary name as negative number
    nonisolated
		public var uniqueName: P21Decode.EntityInstanceName {
			return _uniqueName.withLock{ $0 = $0 &- 1; return $0 }
		}
		private let _uniqueName = Mutex<P21Decode.EntityInstanceName>(0)

    /// The fallback model associated with the current `SdaiModel`, if available.
    ///
    /// This property attempts to retrieve a fallback model from the active session,
    /// based on the underlying schema of the current model. A fallback model is used
    /// as an alternative source of schema data if the current model does not provide
    /// certain information. If there is no active session or no fallback model is found,
    /// this property returns `nil`.
    ///
    /// - Returns: An optional `SdaiModel` that serves as a fallback, or `nil` if not available.
    ///
    /// - Note: Accessing this property when there is no active session will trigger
    ///   an error message and return `nil`.
    nonisolated
		public var fallBackModel: SdaiModel? {
			guard let session = SDAISessionSchema.activeSession
      else {
        SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "can not access SDAISessionSchema.activeSession")
        return nil
      }
			let fallback = session.fallBackModel(for: self.underlyingSchema)
			return fallback
		}

		//MARK: SDAI.CacheHolder related
    nonisolated
		public func notifyApplicationDomainChanged(
			relatedTo schemaInstance: SDAIPopulationSchema.SchemaInstance
		) async
		{
      self.terminateCachingTask()
			self.underlyingSchema.notifyApplicationDomainChanged(relatedTo: schemaInstance)
      await self.contents.notifyApplicationDomainChanged(relatedTo: schemaInstance)
		}

    nonisolated
		public func notifyReadWriteModeChanged(
			sdaiModel: SDAIPopulationSchema.SdaiModel
		)
		{
      self.terminateCachingTask()
			self.underlyingSchema.notifyReadWriteModeChanged(sdaiModel: sdaiModel)
			self.contents.notifyReadWriteModeChanged(sdaiModel: sdaiModel)
		}

    //MARK: USEDIN cache related
    internal var cacheFillingTask: Task<Void,Never>?

    internal func addCacheFillingTask(
      session: SDAISessionSchema.SdaiSession,
      operation: @Sendable @escaping ()async->Void ) async
    {
      guard cacheFillingTask == nil else { return }

      cacheFillingTask =
      Task.detached(
        name: "SDAI.USEDIN-\(self.name)_cache_fillings",
        priority: .low)
      {
        await SDAISessionSchema.$activeSession.withValue(session) {
          await operation()
        }
        await self.removeTask()
      }
    }

    private func removeTask() {
      cacheFillingTask = nil
    }

    /// Cancels the current cache filling task, if one is running.
    ///
    /// This method initiates a cancellation of the ongoing cache filling task associated with the model.
    /// The cancellation occurs asynchronously. If no cache filling task exists, this method has no effect.
    ///
    /// - Note: The cancellation process is performed using a detached `Task`, ensuring non-blocking behavior.
    ///         This is typically used to stop background cache updates (such as those related to the USEDIN cache)
    ///         when the application domain or access mode changes.
    nonisolated
    public func terminateCachingTask() {
      Task(name:"SDAI.USEDIN_cache_update_canceller") {
        await cacheFillingTask?.cancel()
      }
    }

    /// Awaits the completion of the current cache filling task, if one is running.
    ///
    /// This asynchronous method suspends execution until the ongoing cache filling task associated
    /// with the model has finished. If there is no cache filling task in progress, this method returns immediately.
    ///
    /// Use this to ensure that background cache update operations (such as those for the USEDIN cache)
    /// have completed before proceeding with subsequent actions that may depend on a consistent or fully-updated model state.
    ///
    /// - Note: This method is intended for internal synchronization purposes and should be awaited when you need to
    ///   guarantee that any in-progress cache population completes before further operations.
    public func toCompleteCachingTask() async {
      await cacheFillingTask?.value
    }

	}//actor


	//MARK: - SdaiModelContents
	/// ISO-10303-22 (8.4.3) sdai_model_contents
  ///
  /// An SdaiModelContents contains the entity instances making up an SdaiModel. The entity instances are available in a single collection regardless of entity data type and grouped by entity data type into multiple collections.
  ///
  /// **Informal propositions:**
  /// IP1: The set SdaiModelContents.instances contains the same entity instances as the union of the set of extents SdaiModelContents.populatedFolders contains.
  ///
  ///
	public final class SdaiModelContents: SDAI.Object, /*SDAI.CacheHolder,*/ Sendable
	{

		//MARK: Attribute definitions:
		/// the set of all entity instances in the SdaiModel regardless of entity data type.
		public var instances: some (Collection<SDAIParameterDataSchema.ApplicationInstance>) {
			return self.allComplexEntities.lazy.map{ $0.entityReferences }.joined()
		}
		
		/// the set of EntityExtents for all entity types available in the schema corresponding to the SdaiModel.
		/// - This set contains one member for each EntityDefinition found in the schema governing the SdaiModel regardless of whether any entity instances of that entity type currently exist.
		nonisolated(unsafe)
		public private(set) var folders: [SDAIDictionarySchema.EntityDefinition : EntityExtent] = [:]

		/// a subset of folders, containing the set of EntityExtents for which instances currently exist in the SdaiModel.
		public var populatedFolders: [SDAIDictionarySchema.EntityDefinition : EntityExtent] {
			return self.folders.compactMapValues { entityExtent in
				if entityExtent.instances.isEmpty { return nil }
				return entityExtent
			}
		}

		
		//MARK: swift language binding
		public unowned var ownedBy: SdaiModel { return _ownedBy! }

		nonisolated(unsafe)
		private var _ownedBy: SdaiModel!

		fileprivate init() {}

		fileprivate func fixup(
			owner: SdaiModel
		)
		{
			self._ownedBy = owner

			for entityDef in self.ownedBy.underlyingSchema.entities.values {
				folders[entityDef] = EntityExtent(entityType: entityDef, modelContent: self)
			}
		}

		fileprivate func duplicateContents(
			from original: SdaiModelContents
		)
		{
			let targetModel = self.ownedBy

			for complex in original.allComplexEntities {
				let _ = SDAI.ComplexEntity(from: complex, targetModel: targetModel)
			}
		}

    /// Returns an array of entity instances of the specified type contained within the `SdaiModelContents`.
    ///
    /// This method filters and converts the complex entities stored in the model contents to instances of the given
    /// `ApplicationInstance` type. It returns all instances that correspond to the specified entity type.
    ///
    /// - Parameter type: The metatype of the `ApplicationInstance` subclass to retrieve.
    /// - Returns: An array of instances of the specified type that are present in the model contents.
    ///
    /// Example usage:
    /// ```
    /// let instances: [MyEntityType] = model.contents.entityExtent(type: MyEntityType.self)
    /// ```
    ///
    /// - Note: This method only includes instances that can be successfully converted to the specified type.
		public func entityExtent<ENT:SDAIParameterDataSchema.ApplicationInstance>(
			type: ENT.Type
		) -> Array<ENT>
		{
      let result = self.allComplexEntities.compactMap{
        type.convert(fromComplex: $0)
      }
      return result
		}

    private typealias LaneNo = Int8

    private func laneNo(_ p21name:P21Decode.EntityInstanceName) -> LaneNo
    {
      LaneNo(p21name & 0b11)
    }

    private let complexEntities0 = Mutex<[P21Decode.EntityInstanceName : SDAI.ComplexEntity]>([:])
    private let complexEntities1 = Mutex<[P21Decode.EntityInstanceName : SDAI.ComplexEntity]>([:])
    private let complexEntities2 = Mutex<[P21Decode.EntityInstanceName : SDAI.ComplexEntity]>([:])
		private let complexEntities3 = Mutex<[P21Decode.EntityInstanceName : SDAI.ComplexEntity]>([:])

    private func setComplexEntities(
      _ complex: SDAI.ComplexEntity?,
      for p21name: P21Decode.EntityInstanceName,
      laneNo: LaneNo)
    {
      switch laneNo {
        case 1:
          complexEntities1.withLock{ $0[p21name] = complex }
        case 2:
          complexEntities2.withLock{ $0[p21name] = complex }
        case 3:
          complexEntities3.withLock{ $0[p21name] = complex }

        default:
          complexEntities0.withLock{ $0[p21name] = complex }
      }
    }

    private func clearComplexEntities()
    {
      complexEntities0.withLock{ $0 = [:] }
      complexEntities1.withLock{ $0 = [:] }
      complexEntities2.withLock{ $0 = [:] }
      complexEntities3.withLock{ $0 = [:] }
    }

    /// Returns a collection containing all `ComplexEntity` instances stored within the `SdaiModelContents`.
    ///
    /// This property aggregates complex entities from multiple internal storage "lanes" to provide a unified view
    /// of all entities currently managed by the model contents. Each complex entity represents a group of related
    /// entity instances as defined by the model's schema.
    ///
    /// - Returns: A collection of all `SDAI.ComplexEntity` objects present in the `SdaiModelContents`.
    ///
    /// - Note: The returned collection is a lazily joined sequence, reflecting the current state of the model contents.
    ///         The order of entities in this collection is not guaranteed.
		public var allComplexEntities: some Collection<SDAI.ComplexEntity> {
      let complex0 = complexEntities0.withLock{ $0.values }
      let complex1 = complexEntities1.withLock{ $0.values }
      let complex2 = complexEntities2.withLock{ $0.values }
      let complex3 = complexEntities3.withLock{ $0.values }

      let joined = [complex0, complex1, complex2, complex3].joined()

			return joined
		}

		public var allComplexEntitiesShuffled: Array<SDAI.ComplexEntity> {
			Array(allComplexEntities).shuffled()
		}

    /// Retrieves a `ComplexEntity` from the model contents by its P21 instance name.
    ///
    /// This method looks up and returns the `SDAI.ComplexEntity` associated with the provided P21 instance name (`p21name`).
    /// Internally, the entities are distributed across separate "lanes" based on a hash of the instance name for concurrent access.
    ///
    /// - Parameter p21name: The P21 instance name (`EntityInstanceName`) of the complex entity to retrieve.
    /// - Returns: The `SDAI.ComplexEntity` matching the specified name, or `nil` if no such entity exists.
    ///
    /// - Note: If a session with an active transaction is present, the method also updates the transaction's internal complex cache
    ///   to reflect the retrieval of the entity. This ensures that subsequent operations within the same transaction are consistent.
		public func complexEntity(
			named p21name: P21Decode.EntityInstanceName
		) -> SDAI.ComplexEntity?
		{
      let laneNo = laneNo(p21name)

      let complex: SDAI.ComplexEntity?
      switch laneNo {
        case 1:
          complex = complexEntities1.withLock{ $0[p21name] }
        case 2:
          complex = complexEntities2.withLock{ $0[p21name] }
        case 3:
          complex = complexEntities3.withLock{ $0[p21name] }

        default:
          complex = complexEntities0.withLock{ $0[p21name] }
      }//switch

      SDAISessionSchema.activeSession?.activeTransaction?
        .updateComplexCache(
          complexID: p21name,
          modelID: self.ownedBy.modelID,
          value: complex)
      
      return complex
		}
		
		internal func add(
			complex: SDAI.ComplexEntity
		) -> Bool
		{
			let targetModel = self.ownedBy

			guard targetModel.mode == .readWrite else {
				SDAI.raiseErrorAndContinue(.MX_NRW(targetModel), detail: "SDAI-model need to be in read-write mode to add complex entity")
				return false
			}
			guard complex.owningModel == targetModel else {
				SDAI.raiseErrorAndContinue(.EI_NVLD(.applicationInstance(complex.entityReferences.first! )), detail: "Invalid owningModel for the ComplexEntity")
				return false
			}

      self.setComplexEntities(
        complex,
        for: complex.p21name,
        laneNo: self.laneNo(complex.p21name))

			return true
		}

    /// Removes the specified `ComplexEntity` from the model contents.
    ///
    /// This method attempts to remove the given complex entity instance from the internal storage of the `SdaiModelContents`.
    /// Removal is only permitted if the owning model is in read-write mode and the complex entity's `owningModel` matches the
    /// model that owns this contents object. If either of these conditions are not met, the removal fails and an appropriate
    /// error is raised.
    ///
    /// - Parameter complex: The `SDAI.ComplexEntity` instance to remove from the model contents.
    /// - Returns: `true` if the entity was successfully removed; `false` if removal was not permitted or preconditions were not met.
    ///
    /// - Note: Removal is prohibited if the model is not in read-write mode or if the `ComplexEntity` does not belong to this model.
    ///   These checks help ensure model consistency and prevent invalid operations during read-only transactions.
		public func remove(
			complex: SDAI.ComplexEntity
		) -> Bool
		{
			guard self.ownedBy.mode == .readWrite else {
				SDAI.raiseErrorAndContinue(.MX_NRW(self.ownedBy), detail: "SDAI-model is not in read-write mode.")
				return false
			}
			guard complex.owningModel == self.ownedBy else {
				SDAI.raiseErrorAndContinue(.EI_NVLD(.applicationInstance(complex.entityReferences.first! )), detail: "Invalid owningModel for the ComplexEntity")
				return false
			}

      self.setComplexEntities(
        nil,
        for: complex.p21name,
        laneNo: self.laneNo(complex.p21name))

			return true
		}

    /// Removes all `ComplexEntity` instances from the model contents.
    ///
    /// This method clears all complex entities stored within the `SdaiModelContents`, effectively resetting the internal
    /// storage and removing every entity group present in the model. It does not modify the entity extent definitions or folders,
    /// but all entity instance associations are erased.
    ///
    /// - Note: This operation is typically used when resetting or reinitializing the model contents. It does not require
    ///   the model to be in a particular access mode, but use with caution as all entity data within this contents object
    ///   will be lost and cannot be recovered.
    ///
    /// - Important: Removing all entities may impact other caches or references dependent on the current model contents.
    ///   Ensure that any required synchronization or invalidation is handled before or after this operation as needed.
		public func removeAll()
		{
      self.clearComplexEntities()
		}

		//MARK: SDAI.CacheHolder related
		public func notifyReadWriteModeChanged(
			sdaiModel: SDAIPopulationSchema.SdaiModel
		)
		{
			for entityExtent in self.folders.values {
				entityExtent.notifyReadWriteModeChanged(sdaiModel: sdaiModel)
			}

			for complex in self.allComplexEntities {
				complex.notifyReadWriteModeChanged(sdaiModel: sdaiModel)
			}
		}


		public func notifyApplicationDomainChanged(
			relatedTo schemaInstance: SDAIPopulationSchema.SchemaInstance
		) async
		{
			if Set(self.ownedBy.associatedWith).contains(schemaInstance) {
				for entityExtent in self.folders.values {
					entityExtent.notifyApplicationDomainChanged(relatedTo: schemaInstance)
				}
			}

			for complex in self.allComplexEntities {
        await complex.notifyApplicationDomainChanged(relatedTo: schemaInstance)
			}
		}

	}//class

}

//MARK: - Entity Extent
extension SDAIPopulationSchema {
	/// ISO 10303-22 (8.4.4) entity_extent
  ///
	/// An EntityExtent groups all instances of an entity data type that exist in an SdaiModel.
	/// - This grouping includes instances of the specified EntityDefinition, instances of all subtypes of the EntityDefinition and instances of other EntityDefinitions resulting from the mapping of the EXPRESS AND and ANDOR constraints as described in annex A which contains the entity data type as a constituent.
	///
	public final class EntityExtent: SDAI.Object, Sendable
	{

		//MARK: Attribute definitions:
		/// the EntityDefinition whose instances are contained in the folder.
		public let definition: SDAIDictionarySchema.EntityDefinition

		/// the entity instances contained in the folder.
		public var instances: some Collection<SDAIParameterDataSchema.ApplicationInstance> {
			let model = self.ownedBy.ownedBy
			let mode = model.mode

			if mode == .readOnly,
				 let result = self._instances.withLock({ $0 })
			{ return result }

			let result = ownedBy.entityExtent(type: definition.type)

			if mode == .readOnly {
				self._instances.withLock{ $0 = result }
			}

			return result
		}

    public func instances<ENT:SDAIParameterDataSchema.ApplicationInstance>(
      of type: ENT.Type) -> some Collection<ENT>
    {
      self.instances.compactMap { $0 as? ENT }
    }

		/// the SdaiModelContents owning the EntityExtent.
		public unowned let ownedBy: SdaiModelContents


		//MARK: swift language binding
		private let _instances =  Mutex<Array<SDAIParameterDataSchema.ApplicationInstance>?>(nil)

		init(
			entityType: SDAIDictionarySchema.EntityDefinition,
			modelContent: SdaiModelContents
		)
		{
			self.definition = entityType
			self.ownedBy = modelContent
		}

		public func notifyReadWriteModeChanged(
			sdaiModel: SDAIPopulationSchema.SdaiModel
		)
		{
			self._instances.withLock{ $0 = nil }
		}

		public func notifyApplicationDomainChanged(
			relatedTo schemaInstance: SDAIPopulationSchema.SchemaInstance
		) {}
	}
}

