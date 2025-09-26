//
//  SdaiRepository.swift
//  
//
//  Created by Yoshida on 2021/04/11.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import Synchronization

extension SDAISessionSchema {
	
	/// ISO 10303-22 (7.4.3) sdai_repository
	/// 
	/// An SdaiRepository represents the identification of a facility where SdaiModels and SchemaInstances can be stored during a session.
	/// - NOTE - This is intended to support the physical location of the SDAI-models and schema instances.
	/// - Formal propositions:
	/// 	- UR1: the name shall be unique within the current session.
	///
	public final class SdaiRepository: SDAI.Object, Sendable
	{

		//MARK: Attribute definitions:
		
		/// the name of the SdaiRepository.
		///
		/// The name is case sensitive.
		public let name: STRING
		
		/// the SDAI-models and schema instances that exist in the repository. 
		public let contents: SdaiRepositoryContents
		
		/// a description of the repository. 
		public let description: STRING
		
		/// the current session.
		///
		/// - INVERSE of SdaiSession.knownServers
		public var session: some Collection<SdaiSession> {
			return _sessionSet.withLock { $0 }
		}



		//MARK: swift language binding
		private let _sessionSet = Mutex<Set<SdaiSession>>([])

		internal init(name: STRING, description: STRING)
		{
			self.name = name
			self.description = description
			self.contents = SdaiRepositoryContents()

			self.contents.fixup(owner: self)
		}

		internal func associate(with session: SdaiSession) {
			_sessionSet.withLock { $0.insert(session); return }
		}
		internal func dissociate(from session: SdaiSession) {
			_sessionSet.withLock { $0.remove(session); return }
		}
			
	}//class

	//MARK: - SdaiRepositoryContents
	/// ISO 10303-22 (7.4.4) sdai_repository_contents
	/// 
	/// An SdaiRepositoryContents identifies the SdaiModels and SchemaInstances that exist within a repository.
	///
	public final class SdaiRepositoryContents: SDAI.Object, Sendable
	{
		//MARK: Attribute definitions:
		
		/// the SDAI-models in the repository.
		public var models: some Collection<SdaiModel> {
			modelTable.withLock{ $0.values }
		}

		/// the schema instances in the repository.
		public var schemaInstances: some (Collection<SchemaInstance> & Sendable) {
			schemaInstanceTable.withLock{ $0.values }
		}

		/// the repository containing the SDAI-models and schema instances.
		/// - INVERSE of SdaiRepository.contents
		nonisolated(unsafe)
		public private(set) unowned var repository: SdaiRepository!


		//MARK: swift language binding
		private let modelTable = Mutex<[SDAIModelID:SdaiModel]>([:])

		private let schemaInstanceTable = Mutex< [SchemaInstanceID:SchemaInstance]>([:])

		fileprivate func fixup(owner: SdaiRepository) {
			self.repository = owner
		}

		//MARK: SDAI-model related
		internal func findSdaiModel(
			withID modelID: SDAIModelID
		) -> SdaiModel?
		{
			self.modelTable.withLock{ $0[modelID] }
		}

		internal func findSdaiModel(
			named target: SDAIPopulationSchema.STRING
		) -> SdaiModel?
		{
			for model in self.models {
				if model.name == target {
					return model
				}
			}
			return nil
		}

		internal func add(
			model: SdaiModel
		)
		{
			guard model.repository == self.repository
			else { fatalError("internal logic error")}

			self.modelTable.withLock{ $0[model.modelID] = model }
			model.updateChangeDate()
		}

		internal func remove(
			model: SdaiModel
		)
		{
			guard model.repository == self.repository
			else { fatalError("internal logic error")}

			self.modelTable.withLock{ $0[model.modelID] = nil }
		}

		//MARK: schema instance related
		internal func findSchemaInstance(
			withID siID: SchemaInstanceID
		) -> SchemaInstance?
		{
			self.schemaInstanceTable.withLock{ $0[siID] }
		}

		internal func findSchemaInstance(
			named target: SDAIPopulationSchema.STRING
		) -> SchemaInstance?
		{
			for si in self.schemaInstances {
				if si.name == target {
					return si
				}
			}
			return nil
		}

		internal func add(
			schemaInstance: SchemaInstance
		)
		{
			guard schemaInstance.repository == self.repository
			else { fatalError("internal logic error")}

			self.schemaInstanceTable.withLock{
				$0[schemaInstance.schemaInstanceID] = schemaInstance }

			schemaInstance.updateChangeDate()
		}

		internal func remove(
			schemaInstance: SchemaInstance
		)
		{
			guard schemaInstance.repository == self.repository
			else { fatalError("internal logic error")}

			self.schemaInstanceTable.withLock{
				$0[schemaInstance.schemaInstanceID] = nil }
		}

	}//class
}//SDAISessionSchema

