//
//  SdaiModel.swift
//  
//
//  Created by Yoshida on 2021/04/11.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAIPopulationSchema {
	
	//MARK: (8.4.2)
	public final class SdaiModel: SDAI.Object {
		//MARK: (10.5.1)
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
		
		
		public let name: STRING // (10.7.2)
		public let contents: SdaiModelContents
		public let underlyingSchema: SDAIDictionarySchema.SchemaDefinition
		public unowned let repository: SDAISessionSchema.SdaiRepository
		public internal(set) var changeDate: SDAISessionSchema.TimeStamp
		public internal(set) var mode: SDAISessionSchema.AccessType
		private var _associatedWith: SET<SDAI.UnownedReference<SchemaInstance>> = []
		public var associatedWith: AnySequence<SchemaInstance> {
			return AnySequence( _associatedWith.lazy.map{ $0.object } )
		}
		public func associate(with schemaInstance: SchemaInstance) {
			_associatedWith.insert(SDAI.UnownedReference(schemaInstance))
		}
		public func dissociate(from schemaInstance: SchemaInstance) {
			_associatedWith.remove(SDAI.UnownedReference(schemaInstance))
		}
		
		//MARK: swift language binding
		private static var _fallBackModels: [SDAIDictionarySchema.SchemaDefinition:SdaiModel] = [:]
		
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
		
		private var _uniqueName: P21Decode.EntityInstanceName = 0
		public var uniqueName: P21Decode.EntityInstanceName { 
			_uniqueName -= 1
			return _uniqueName
		}
		
		public func updateChangeDate() {
			self.changeDate = Date()
		}
		
		public func drainTemporaryPool() {
			self.contents.drainTemporaryPool()
		}

	}
	
	
	//MARK: (8.4.3)
	public class SdaiModelContents: SDAI.Object {
				
		public var instances: AnySequence<SDAIParameterDataSchema.EntityInstance> { 
			return AnySequence( self.allComplexEntities.lazy.map{ $0.entityReferences }.joined() )
		}
//		public var folders: [EntityName : EntityExtent] = [:]
//		public var populatedFolders: [EntityName : EntityExtent] = [:]
		public fileprivate(set) unowned var ownedBy: SdaiModel!
		
		public func entityExtent<ENT:SDAIParameterDataSchema.EntityInstance>(type: ENT.Type) -> AnySequence<ENT> {
			return AnySequence( self.instances.lazy.compactMap{ $0 as? ENT } )
		}
		
		//MARK: swift language binding
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
		
		public func resetCache(relatedTo schemaInstance: SDAIPopulationSchema.SchemaInstance) {
			for complex in complexEntities.values {
				complex.resetCache(relatedTo: schemaInstance)
			}
		}
		
		public func drainTemporaryPool() {}
	}
	
	//MARK: - fallback model contents with temporaly entity pool
	public class SdaiFallbackModelContents: SdaiModelContents {
		public private(set) var temporaryEntityPool: [SDAI.ComplexEntity] = []
		
		public override func add(complex: SDAI.ComplexEntity) -> Bool {
			if super.add(complex: complex) { return true }
			guard complex.owningModel == self.ownedBy else { return false }
			temporaryEntityPool.append(complex)
			complex.isTemporary = true
			return true
		}
		
		public override func drainTemporaryPool() {
			temporaryEntityPool = []
		}
	}
	
}
