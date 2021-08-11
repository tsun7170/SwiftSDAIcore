//
//  SdaiRepository.swift
//  
//
//  Created by Yoshida on 2021/04/11.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAISessionSchema {
	
	/// ISO 10303-22 (7.4.3) sdai_repository
	/// 
	/// An SdaiRepository represents the identification of a facility where SdaiModels and SchemaInstances can be stored during a session.
	/// - NOTE - This is intended to support the physical location of the SDAI-models and schema instances.
	/// - Formal propositions:
	/// 	- UR1: the name shall be unique within the current session.  
	public final class SdaiRepository: SDAI.Object {
		
		//MARK: Attribute definitions:
		
		/// the name of the SdaiRepository.
		/// The name is case sensitive. 
		public let name: STRING
		
		/// the SDAI-models and schema instances that exist in the repository. 
		public let contents: SdaiRepositoryContents
		
		/// a description of the repository. 
		public let description: STRING
		
		/// the current session.
		/// - INVERSE of SdaiSession.knownServers  
		public var session: AnySequence<SdaiSession> {
			return AnySequence( _session.lazy.map{ $0.object } )
		}
		private var _session: Set<SDAI.UnownedReference<SdaiSession>> = []

		//MARK: swift language binding
		public init(name: STRING, description: STRING) {
			self.name = name
			self.description = description
			self.contents = SdaiRepositoryContents()
			super.init()
			self.contents.repository = self
		}
		
		public func associate(with session: SdaiSession) {
			_session.insert(SDAI.UnownedReference(session))
		}
		public func dissociate(from session: SdaiSession) {
			_session.remove(SDAI.UnownedReference(session))
		}
			
		public private(set) static var builtInRepository: SdaiRepository = SdaiRepository(name: "BUILTIN", description: "built-in repository")
	} 
	
	/// ISO 10303-22 (7.4.4) sdai_repository_contents
	/// 
	/// An SdaiRepositoryContensts identifies the SdaiModels and SchemaInstances that exist within a repository. 
	public final class SdaiRepositoryContents: SDAI.Object {
		
		//MARK: Attribute definitions:
		
		/// the SDAI-models in the repository.
		public private(set) var models: [SDAIPopulationSchema.STRING: SDAIPopulationSchema.SdaiModel] = [:]
		
		/// the schema instances in the repository.
		public private(set) var schemas: [SDAIPopulationSchema.STRING: SDAIPopulationSchema.SchemaInstance] = [:]
		
		/// the repository containing the SDAI-models and schema instances.
		/// - INVERSE of SdaiRepository.contents 
		public fileprivate(set) unowned var repository: SdaiRepository!
		
		//MARK: swift language binding
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

