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
	/// ISO 10303-22 (8.4.2)
	/// An SdaiModel is a grouping mechanism consisting of a set of related entity instances based upon a SchemaDefinition.
	/// # Formal propositions:
  /// UR1: The name shall be unique within the repository containing the SdaiModel.
	/// 
	public final class SdaiModel: SDAI.Object, SdaiCacheHolder, Sendable
	{

		//MARK: Attribute definitions:

		/// the identifier for this SdaiModel. The name is case sensitive.
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
		public let contents: SdaiModelContents
		
		/// the schema that defines the structure of the data that appears in the SdaiModel.
		public let underlyingSchema: SDAIDictionarySchema.SchemaDefinition
		
		/// the repository within which the SdaiModel was created.
		public unowned let repository: SDAISessionSchema.SdaiRepository
		
		/// if present, the creation date or date of most recent modification, including creation or deletion, to an entity instance within the current SdaiModel.
		public var changeDate: SDAISessionSchema.TimeStamp {
			self._changeDate.withLock{ $0 }
		}
		private let _changeDate = Mutex<SDAISessionSchema.TimeStamp>(Date())

		internal func updateChangeDate() {
			self._changeDate.withLock{ $0 = Date() }
		}

		/// if present, the current access mode for the SdaiModel. If not present, the SdaiModel is not open.
		public var mode: SDAISessionSchema.AccessType? {
			guard
				let session = SDAISessionSchema.activeSession,
				let modelInfo = session.activeModelInfo(for:self.modelID),
				modelInfo.instance == self
			else { return nil }

			return modelInfo.mode
		}//var

		/// the schema instances with which the SdaiModel has been associated.
		public var associatedWith: some Collection<SchemaInstance> {
			get {
				var result: [SchemaInstance] = []

				guard let session = SDAISessionSchema.activeSession else { return result }

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



		//MARK: swift language binding
		internal typealias ComplexEntityID = P21Decode.EntityInstanceName
		internal typealias SDAIModelID = UUID

		internal let modelID: SDAIModelID	// for this SdaiModel

		internal static let nilModelID: SDAIModelID = SDAIModelID()
		internal static let nilComplexID: ComplexEntityID = 0


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
//			self.changeDate = Date()

			self.contents.fixup(owner: self)
		}


		private init(from original: SdaiModel)
		{
			self.repository = original.repository
			self._name.withLock{ $0 = original.name }
			self.modelID = original.modelID
			self.underlyingSchema = original.underlyingSchema
			self.contents = SdaiModelContents()
			self._changeDate.withLock{ $0 = original.changeDate }

			self.contents.fixup(owner: self)
		}

		internal func clone() -> SdaiModel {
			let cloned = SdaiModel(from: self)
			cloned.contents.duplicateContents(from: self.contents)
			return cloned
		}


		
		/// unique temporary name as negative number
		public var uniqueName: P21Decode.EntityInstanceName {
			return _uniqueName.withLock{ $0 = $0 &- 1; return $0 }
		}
		private let _uniqueName = Mutex<P21Decode.EntityInstanceName>(0)



		//MARK: SdaiCacheHolder related
		public func notifyApplicationDomainChanged(
			relatedTo schemaInstance: SDAIPopulationSchema.SchemaInstance
		)
		{
			self.underlyingSchema.notifyApplicationDomainChanged(relatedTo: schemaInstance)
			self.contents.notifyApplicationDomainChanged(relatedTo: schemaInstance)
		}

		public func notifyReadWriteModeChanged(
			sdaiModel: SDAIPopulationSchema.SdaiModel
		)
		{
			self.underlyingSchema.notifyReadWriteModeChanged(sdaiModel: sdaiModel)
			self.contents.notifyReadWriteModeChanged(sdaiModel: sdaiModel)
		}




	}//class

	//MARK: - SdaiModelContents
	/// ISO-10303-22 (8.4.3)
	/** - An SdaiModelContents contains the entity instances making up an SdaiModel. The entity instances are available in a single collection regardless of entity data type and grouped by entity data type into multiple collections.
	*/
	/** # Informal propositions: 
	IP1: The set SdaiModelContents.instances contains the same entity instances as the union of the set of extents SdaiModelContents.populatedFolders contains.
	*/
	public final class SdaiModelContents: SDAI.Object, SdaiCacheHolder, Sendable
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

		public func entityExtent<ENT:SDAIParameterDataSchema.ApplicationInstance>(
			type: ENT.Type
		) -> Array<ENT>
		{
			let result = self.instances.compactMap{ $0 as? ENT }
			return result
		}
		
		private let complexEntities = Mutex<[P21Decode.EntityInstanceName : SDAI.ComplexEntity]>([:])

		public var allComplexEntities: some Collection<SDAI.ComplexEntity> { 
			return complexEntities.withLock{ $0.values }
		}
		
		public func complexEntity(
			named p21name: P21Decode.EntityInstanceName
		) -> SDAI.ComplexEntity?
		{
			return complexEntities.withLock{ $0[p21name] }
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

			complexEntities.withLock{ $0[complex.p21name] = complex }
			return true
		}

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

			complexEntities.withLock{ $0[complex.p21name] = nil }
			return true
		}

		public func removeAll()
		{
			complexEntities.withLock{ $0 = [:] }
		}

		//MARK: SdaiCacheHolder related
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
		)
		{
			if Set(self.ownedBy.associatedWith).contains(schemaInstance) {
				for entityExtent in self.folders.values {
					entityExtent.notifyApplicationDomainChanged(relatedTo: schemaInstance)
				}
			}

			for complex in self.allComplexEntities {
				complex.notifyApplicationDomainChanged(relatedTo: schemaInstance)
			}
		}


//		public func resetCache(
//			relatedTo schemaInstance: SDAIPopulationSchema.SchemaInstance?
//		)
//		{
//			for complex in allComplexEntities {
//				complex.resetCache(relatedTo: schemaInstance)
//			}
//		}
		
	}
		
}

//MARK: - Entity Extent
extension SDAIPopulationSchema {
	/// ISO 10303-22 (8.4.4)
	/// An EntityExtent groups all instances of an entity data type that exist in an SdaiModel.
	/// - This grouping includes instances of the specified EntityDefinition, instances of all subtypes of the EntityDefinition and instances of other EntityDefinitions resulting from the mapping of the EXPRESS AND and ANDOR constraints as described in annex A which contains the entity data type as a constituent.
	///
	public final class EntityExtent: SDAI.Object, SdaiCacheHolder, Sendable
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

