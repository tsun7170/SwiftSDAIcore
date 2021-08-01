//
//  SdaiModel.swift
//  
//
//  Created by Yoshida on 2021/04/11.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAIPopulationSchema {
	
	//MARK: - SdaiModel
	/// ISO 10303-22 (8.4.2)
	/// An SdaiModel is a grouping mechanism consisting of a set of related entity instances based upon a SchemaDefintiion.
	/// # Formal propositions:
  /// UR1: The name shall be unique within the repository containig the SdaiModel.
	public final class SdaiModel: SDAI.Object {
		
		//MARK Attribute definitions:
		/// the identifier for this SdaiModel. The name is case sensitive.
		public let name: STRING
		
		/// the collection mechanism for entity instances within the SdaiModel.
		public let contents: SdaiModelContents
		
		/// the schema that defines the structure of the data that appears in the SdaiModel.
		public let underlyingSchema: SDAIDictionarySchema.SchemaDefinition
		
		/// the repository within which the SdaiModel was created.
		public unowned let repository: SDAISessionSchema.SdaiRepository
		
		/// if present, the creation date or date of most recent modification, including creation or deletion, to an entity instance within the current SdaiModel.
		public internal(set) var changeDate: SDAISessionSchema.TimeStamp
		
		/// if present, the current access mode for the SdaiModel. If not present, the SdaiModel is not open.
		public internal(set) var mode: SDAISessionSchema.AccessType
		
		/// the schema instances with which the SdaiModel has been associated.
		public var associatedWith: AnySequence<SchemaInstance> {
			return AnySequence( _associatedWith.lazy.map{ $0.object } )
		}
		private var _associatedWith: SET<SDAI.UnownedReference<SchemaInstance>> = []
		
		
		/// ISO 10303-22 (10.5.1) Create SDAI-model
		///  
		/// This operation establishes a new SdaiModel within which entity instances can be created and accessed. The new created SdaiModel has no access mode assiciated with it.
		/// - Parameters:
		///   - repository: The repository in which the SdaiModel is to be created.
		///   - modelName: The name of the new SdaiModel.
		///   - schema: The schema upon which the SdaiModel shall be based.
		/// - Returns: The newly created SdaiModel.
		public convenience init(repository: SDAISessionSchema.SdaiRepository, 
								modelName: STRING, 
								schema: SDAIDictionarySchema.SchemaDefinition) {
			self.init(repository: repository,
								modelName: modelName,
								schema: schema,
								contents: SdaiModelContents())
		}
		
		internal init(repository: SDAISessionSchema.SdaiRepository, 
								modelName: STRING, 
								schema: SDAIDictionarySchema.SchemaDefinition,
								contents: SdaiModelContents) {
			self.repository = repository
			self.name = modelName
			self.underlyingSchema = schema
			self.contents = contents
			self.changeDate = Date()
			self.mode = .readWrite
			super.init()
			self.contents.ownedBy = self
			self.repository.contents.add(model:self)
		}
	
		
		//MARK: swift language binding
		public func associate(with schemaInstance: SchemaInstance) {
			_associatedWith.insert(SDAI.UnownedReference(schemaInstance))
		}
		public func dissociate(from schemaInstance: SchemaInstance) {
			_associatedWith.remove(SDAI.UnownedReference(schemaInstance))
		}
		
		
		public class func fallBackModel(for schema:SDAIDictionarySchema.SchemaDefinition) -> SdaiModel { 
			if let model = _fallBackModels[schema] { return model }
			
			let model = SdaiModel(repository: SDAISessionSchema.SdaiRepository.builtInRepository, 
														modelName: schema.name + ".fallback", 
														schema: schema,
														//contents: SdaiFallbackModelContents())
														contents: SdaiModelContents())
			_fallBackModels[schema] = model
			return model
		}
		private static var _fallBackModels: [SDAIDictionarySchema.SchemaDefinition:SdaiModel] = [:]
		
		public var uniqueName: P21Decode.EntityInstanceName { 
			_uniqueName = _uniqueName &- 1
			return _uniqueName
		}
		private var _uniqueName: P21Decode.EntityInstanceName = 0
		
		public func updateChangeDate() {
			self.changeDate = Date()
		}
		
//		public func drainTemporaryPool() {
//			self.contents.drainTemporaryPool()
//		}

	}
	
	//MARK: - SdaiModelContents
	/// ISO-10303-22 (8.4.3)
	/** - An SdaiModelContents contains the entity instances making up an SdaiModel. The entity instances are available in a single collection regardless of entity data type and grouped by entity data type into multiple collections.
	*/
	/** # Informal propositions: 
	IP1: The set SdaiModelContents.instances contains the same entity instances as the union of the set of extents SdaiModelContents.polulatedFolders contains.
	*/
	public final class SdaiModelContents: SDAI.Object {
				
		//MARK: Attribute definitions:
		/// the set of all entity instances in the SdaiModel regardless of entity data type.
		public var instances: AnySequence<SDAIParameterDataSchema.EntityInstance> { 
			return AnySequence( self.allComplexEntities.lazy.map{ $0.entityReferences }.joined() )
		}
		
		/// the set of EntityExtents for all entity types available in the schema corresponding to the SdaiModel. 
		/** - This set contains one member for each EntityDefinition found in the schema goverining the SdaiModel regardless of whether any entity instances of that entity type currently exist.
		*/
		lazy public var folders: [SDAIDictionarySchema.EntityDefinition : EntityExtent] = {
			var result: [SDAIDictionarySchema.EntityDefinition : EntityExtent] = [:]
			for entityDef in ownedBy.underlyingSchema.entities.values {
				result[entityDef] = EntityExtent(entityType: entityDef, modelContent: self)
			}
			return result
		}()
		
		/// a subset of folders, containing the set of EntityExtents for which instances currently exist in the SdaiModel.
		public var populatedFolders: [SDAIDictionarySchema.EntityDefinition : EntityExtent] {
			if ownedBy.mode == .readOnly, let result = _populatedFolders { return result }
			
			var result: [SDAIDictionarySchema.EntityDefinition : EntityExtent] = [:]
			for entityDef in self.instances.lazy.map({ type(of: $0).entityDefinition }) {
				if result[entityDef] == nil {
					result[entityDef] = EntityExtent(entityType: entityDef, modelContent: self)
				}
			}
			if ownedBy.mode == .readOnly { _populatedFolders = result }
			return result
		}
		private var _populatedFolders: [SDAIDictionarySchema.EntityDefinition : EntityExtent]?
		
		
		//MARK: swift language binding
		public fileprivate(set) unowned var ownedBy: SdaiModel!
		
		public func entityExtent<ENT:SDAIParameterDataSchema.EntityInstance>(type: ENT.Type) -> AnySequence<ENT> {
			return AnySequence( self.instances.lazy.compactMap{ $0 as? ENT } )
		}
		
		internal var complexEntities: [P21Decode.EntityInstanceName : SDAI.ComplexEntity] = [:]
		
		public var allComplexEntities: AnySequence<SDAI.ComplexEntity> { 
			return AnySequence(complexEntities.lazy.map({ (name, complex) in complex }))
		}
		
		public func complexEntity(named p21name: P21Decode.EntityInstanceName) -> SDAI.ComplexEntity? {
			return complexEntities[p21name]
		}
		
		public func add(complex: SDAI.ComplexEntity) -> Bool {
			guard self.ownedBy.mode == .readWrite else { return false }
			guard complex.owningModel == self.ownedBy else { return false }
			complexEntities[complex.p21name] = complex
			return true
		}
		
		public func resetCache(relatedTo schemaInstance: SDAIPopulationSchema.SchemaInstance?) {
			for complex in complexEntities.values {
				complex.resetCache(relatedTo: schemaInstance)
			}
		}
		
//		public func drainTemporaryPool() {}
	}
	
	//MARK: - fallback model contents with temporaly entity pool
//	public final class SdaiFallbackModelContents: SdaiModelContents {
//		public private(set) var temporaryEntityPool: [SDAI.ComplexEntity] = []
//		
//		public override func add(complex: SDAI.ComplexEntity) -> Bool {
//			if super.add(complex: complex) { return true }
//			guard complex.owningModel == self.ownedBy else { return false }
//			temporaryEntityPool.append(complex)
//			complex.isTemporary = true
//			return true
//		}
//		
//		public override func drainTemporaryPool() {
//			temporaryEntityPool = []
//		}
//	}
	
}

//MARK: - Entity Extent
extension SDAIPopulationSchema {
	/// ISO 10303-22 (8.4.4)
	/// An EntityExtent groups all instances of an entity data type that exist in an SdaiModel.
	/// - This grouping includes instances of the specified EntityDefinition, instances of all subtypes of the EntityDefinition and instances of other EntityDefinitions resulting from the mapping of the EXPRESS AND and ANDOR constraings as described in annex A which contains the entity data type as a constituent.
	public final class EntityExtent: SDAI.Object {
		init(entityType: SDAIDictionarySchema.EntityDefinition, modelContent: SdaiModelContents ) {
			self.definition = entityType
			self.ownedBy = modelContent
		}
		
		//MARK: Attribute definitions:
		/// the EntityDefinition whose instances are contained in the folder.
		public var definition: SDAIDictionarySchema.EntityDefinition
		
		/// the entity instances contained in the folder.
		public var instances: AnySequence<SDAIParameterDataSchema.EntityInstance> {
			if ownedBy.ownedBy.mode == .readOnly, let result = _instances { return result }
			let result = ownedBy.entityExtent(type: definition.type)
			if ownedBy.ownedBy.mode == .readOnly { _instances = result }
			return result
		}
		private var _instances: AnySequence<SDAIParameterDataSchema.EntityInstance>?
		
		/// the SdaiModelContents owning the EntityExtent.
		public unowned var ownedBy: SdaiModelContents
	}
}

