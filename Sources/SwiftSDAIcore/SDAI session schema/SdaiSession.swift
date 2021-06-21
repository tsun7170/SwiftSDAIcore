//
//  File.swift
//  
//
//  Created by Yoshida on 2021/04/11.
//

import Foundation

extension SDAISessionSchema {
	//MARK: (7.4.1)
	public final class SdaiSession: SDAI.Object {
		public init(repositories:[SdaiRepository]) {
			super.init()
			for repository in repositories + [SdaiRepository.builtInRepository] {
				knownServers[repository.name] = repository
				repository.associate(with: self)
			}
		}
		
		public let sdaiImplementation: Implementation = Implementation()
		public let recordingActive: BOOLEAN = false
		public let errors: LIST<ErrorEvent> = []
		public private(set) var knownServers: [STRING:SdaiRepository] = [:]
		public private(set) var activeServers: [STRING:SdaiRepository] = [:]
		public private(set) var activeModels: SET<SDAIPopulationSchema.SdaiModel> = []
		public var dataDictionary: [SDAIDictionarySchema.ExpressId: SDAIDictionarySchema.SchemaDefinition] { Self.dataDictionary }
//	public let activeTransaction: SET<SdaiTransaction> = []
		
		// swift language binding
		internal static var dataDictionary: [SDAIDictionarySchema.ExpressId: SDAIDictionarySchema.SchemaDefinition] = [:]
		
		// (10.4.4)
		public func closeSession() {
			for repository in knownServers.values {
				repository.dissociate(from: self)
			}
		}
		
		// (10.4.5)
		public func open(repository: SdaiRepository) {
			activeServers[repository.name] = repository
		}
		
		// (10.5.3)
		public func close(repository: SdaiRepository) {
			activeServers[repository.name] = nil
		}
	}
	
	//MARK: (7.4.2)
	public final class Implementation: SDAI.Object {
		public let name: STRING = "SwiftSDAIcore"
		public let level: STRING = "1.0.0"
		public let sdaiVersion: STRING = "{ iso standard 10303 part(22) version(0) }"
		public let bindingVersion: STRING = "1.0.0"
		public let implementationClass: INTEGER = 1 // lowest level of function
		public let transactionLevel: INTEGER = 1	// no transaction
		public let expressionLevel: INTEGER = 4 // complete evaluation
		public let recordingLevel: INTEGER = 1 // no recording
		public let scopeLevel: INTEGER = 1 // no scope
		public let domainEquivalenceLevel: INTEGER = 1 // no domain equivalence		
		
	}
}
