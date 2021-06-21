//
//  File.swift
//  
//
//  Created by Yoshida on 2021/04/11.
//

import Foundation

extension SDAISessionSchema {
	
	//MARK: (7.4.3)
	public final class SdaiRepository: SDAI.Object {
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
		private var _session: Set<SDAI.UnownedReference<SdaiSession>> = []
		public var session: AnySequence<SdaiSession> {
			return AnySequence( _session.lazy.map{ $0.object } )
		}
		public func associate(with session: SdaiSession) {
			_session.insert(SDAI.UnownedReference(session))
		}
		public func dissociate(from session: SdaiSession) {
			_session.remove(SDAI.UnownedReference(session))
		}
			
		//swift language binding
		public private(set) static var builtInRepository: SdaiRepository = SdaiRepository(name: "BUILTIN", description: "built-in repository")
		
		public func drainTemporaryPool() {
			for model in self.contents.models.values {
				model.drainTemporaryPool()
			}
		}
	} 
	
	//MARK: (7.4.4)
	public final class SdaiRepositoryContents: SDAI.Object {
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

