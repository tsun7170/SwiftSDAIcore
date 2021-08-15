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

		
		/// ISO 10303-22 (10.5.1) Create SDAI-model
		///  
		/// This operation establishes a new SdaiModel within which entity instances can be created and accessed. The new created SdaiModel has no access mode assiciated with it.
		/// - Parameters:
		///   - modelName: The name of the new SdaiModel.
		///   - schema: The schema upon which the SdaiModel shall be based.
		/// - Returns: The newly created SdaiModel.
		public func createSdaiModel( modelName: STRING, schema: SDAIDictionarySchema.SchemaDefinition ) -> SDAIPopulationSchema.SdaiModel {
			let model = SDAIPopulationSchema.SdaiModel(repository: self, modelName: modelName, schema: schema)
			self.contents.add(model: model)
			return model
		}
		
		/// ISO 10303-22 (10.7.1) Delete SDAI-model
		/// 
		/// This operation deletes an SdaiModel along with all of the entity_instances, aggregate_instances and scopes that it contains.
		/// Any subsequent operation using a reference to the SDAI-model or to any of its contents shall behave as if the reference was unset. 
		/// - Parameter model: The SdaiModel to delete.
		/// - Returns: true if operation is successful.
		@discardableResult
		public func deleteSdaiModel(model: SDAIPopulationSchema.SdaiModel) -> Bool {
			guard model.repository == self else { return false }
			for instance in model.associatedWith {
				instance.mode = .readWrite
				guard instance.remove(model: model) else { 
					return false 
				}
			}
			self.contents.remove(model: model)
			model.mode = .deleted
			return true
		}
		
		/// ISO 10303-22 (10.5.2) Create schema instance
		///  
		/// This operation establishes a new schema instance. 
		/// - Parameters:
		///   - name: The name of the new schema instance.
		///   - schema: The schema upon which the schema instance shall be based.
		/// - Returns: The newly created schema instance.
		public func createSchemaInstance( name: STRING, schema: SDAIDictionarySchema.SchemaDefinition) -> SDAIPopulationSchema.SchemaInstance {
			let schemaInstance = SDAIPopulationSchema.SchemaInstance(repository: self, name: name, schema: schema)
			self.contents.add(schema: schemaInstance)
			return schemaInstance
		}
		
		/// ISO 10303-22 (10.6.1) Delete schema instance
		/// 
		/// This operation deletes a schema instance.
		/// If references between two SDAI-models associated with the schema instance existed and there is not another schema instance with both SDAI-models are associated, then the references between the entity instances in those two SDAI-models are invalid (see 10.10.7).  
		/// - Parameter instance: The schema instance to be deleted.
		/// - Returns: true if operation is successful.
		@discardableResult
		public func deleteSchemaInstance(instance: SDAIPopulationSchema.SchemaInstance) -> Bool {
			guard instance.repository == self else { return false }
			self.contents.remove(schema: instance)
			instance.mode = .deleted
			return true
		}
		
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
	
	//MARK: - SdaiRepositoryContents
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
		fileprivate func add(model: SDAIPopulationSchema.SdaiModel) {
			assert(model.repository == self.repository)
			self.models[model.name] = model
		}
		fileprivate func remove(model: SDAIPopulationSchema.SdaiModel) {
			assert(model.repository == self.repository)
			self.models[model.name] = nil
		}
		fileprivate func add(schema: SDAIPopulationSchema.SchemaInstance) {
			assert(schema.repository == self.repository)
			self.schemas[schema.name] = schema
		}
		fileprivate func remove(schema: SDAIPopulationSchema.SchemaInstance) {
			assert(schema.repository == self.repository)
			self.schemas[schema.name] = nil
		}
	}
}

