//
//  File.swift
//  
//
//  Created by Yoshida on 2021/04/11.
//

import Foundation

extension SDAIPopulationSchema {
	
	//MARK: (8.4.2)
	public class SdaiModel: SDAI.Object {
		//MARK: (10.5.1)
		public init(repository: SDAISessionSchema.SdaiRepository, 
								modelName: STRING, 
								schema: SDAIDictionarySchema.SchemaDefinition) {
			self.repository = repository
			self.name = modelName
			self.underlyingSchema = schema
			self.contents = SdaiModelContents()
			self.changeDate = Date()
			super.init()
			self.contents.ownedBy = self
			self.repository.contents.add(model:self)
		}
		
		//MARK: (10.7.1)
//		deinit {
//		}
		
		public let name: STRING // (10.7.2)
		public let contents: SdaiModelContents
		public let underlyingSchema: SDAIDictionarySchema.SchemaDefinition
		public unowned let repository: SDAISessionSchema.SdaiRepository
		public var changeDate: SDAISessionSchema.TimeStamp?
		public var mode: SDAISessionSchema.AccessType?
		public internal(set) var associatedWith: SET<SDAI.UnownedReference<SchemaInstance>> = []
		
		//MARK: swift language binding
		private static var _fallBackModels: [SDAIDictionarySchema.SchemaDefinition:SdaiModel] = [:]
		
		public class func fallBackModel(for schema:SDAIDictionarySchema.SchemaDefinition) -> SdaiModel { 
			if let model = _fallBackModels[schema] { return model }
			
			let model = SdaiModel(repository: SDAISessionSchema.SdaiRepository.builtInRepository, modelName: schema.name + ".fallback", schema: schema)
			_fallBackModels[schema] = model
			return model
		}
		
		private var _uniqueName: P21Decode.EntityInstanceName = 0
		public var uniqueName: P21Decode.EntityInstanceName { 
			_uniqueName -= 1
			return _uniqueName
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
		
		public func add(complex: SDAI.ComplexEntity) {
			assert(complex.owningModel == self.ownedBy)
			complexEntities[complex.p21name] = complex
		}
	}
}
