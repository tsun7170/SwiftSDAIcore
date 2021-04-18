//
//  File.swift
//  
//
//  Created by Yoshida on 2021/04/11.
//

import Foundation

extension SDAISessionSchema {
	
	//MARK: (7.4.3)
	public class SdaiRepository: SDAI.Object {
		public init(name: STRING, description: STRING) {
			self.name = name
			self.description = description
			self.contents = SdaiRepositoryContents()
			super.init()
			self.contents.repository = self
		}
		
		public let name: STRING
		public let contents: SdaiRepositoryContents
		public let description: STRING
		public internal(set) var session: Set<SDAI.UnownedReference<SdaiSession>> = []
		
		//swift language binding
		public private(set) static var builtInRepository: SdaiRepository = SdaiRepository(name: "BUILTIN", description: "built-in repository")
	} 
	
	//MARK: (7.4.4)
	public class SdaiRepositoryContents: SDAI.Object {
		public private(set) var models: [SDAIPopulationSchema.STRING: SDAIPopulationSchema.SdaiModel] = [:]
		public private(set) var schemas: [SDAIPopulationSchema.STRING: SDAIPopulationSchema.SchemaInstance] = [:]
		public fileprivate(set) unowned var repository: SdaiRepository!
		
		// swift language binding
		public func add(model: SDAIPopulationSchema.SdaiModel) {
			assert(model.repository == self.repository)
			self.models[model.name] = model
		}
		public func add(schema: SDAIPopulationSchema.SchemaInstance) {
			assert(schema.repository == self.repository)
			self.schemas[schema.name] = schema
		}
	}
}

