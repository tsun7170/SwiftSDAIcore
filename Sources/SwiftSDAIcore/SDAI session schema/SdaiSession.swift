//
//  SdaiSession.swift
//  
//
//  Created by Yoshida on 2021/04/11.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAISessionSchema {
	
	/// ISO 10303-22 (7.4.1) sdai_session
	/// 
	/// An SdaiSession represents the information describing an SDAI session at a point in time while the SDAI implementation is active.
	/// It contains information reflecting the state of the session with respect to transactions, errors, event repording, repositories and the data dictionary. 
	public final class SdaiSession: SDAI.Object {
		
		//MARK: Attribute definitions:
		
		/// the characteristics of the SDAI implementation.
		public let sdaiImplementation: Implementation = Implementation()
		
		/// a boolean that has the value FALSE if the recording of events is inhibited;
		/// TRUE otherwise.   
		public let recordingActive: BOOLEAN = false
		
		/// the list of errors that have resulted from previously executed SDAI operations while event recording was active.
		public let errors: LIST<ErrorEvent> = []
		
		/// the repositories available to the application in this session.
		/// The presence of particular repositories depends on the specific installation of an SDAI implementation.  
		public private(set) var knownServers: [STRING:SdaiRepository] = [:]
		
		/// the repositories currently open in the session.
		public private(set) var activeServers: [STRING:SdaiRepository] = [:]
		
		/// the SdaiModels currently being accessed in the session.
		public private(set) var activeModels: SET<SDAIPopulationSchema.SdaiModel> = []
		
		/// if present, the schema instance, based upon the SDAI session schema, with which the SDAI-models constituting the data dictionary are associated.
		/// For SDAI implementations claiming conformance to implementation classes 2 through 6 this attribute shall have a value specified. 
		public var dataDictionary: [SDAIDictionarySchema.ExpressId: SDAIDictionarySchema.SchemaDefinition] { Self.dataDictionary }
		
		//	public let activeTransaction: SET<SdaiTransaction> = []
		
		
		/// ISO 10202-22 (10.4.4) Close session
		/// 
		/// This operation terminates the SDAI session.
		/// Further SDAI operations can be processed only after a subsequent Open session operation.
		/// In implementations supporting transaction level 1 or 2 (see 13.1.1), the implementation shall behave as if the Close repository operation is performed on each repository in session.activeServers.
		/// In an implementation supporting transaction level 3, the implementation shall behave as if the End transaction access and abort operation is performed if a transaction existed in the session followerd by the Close repository operation on each open repository regardless of whether a transaction existed or not. 
		public func closeSession() {
			for repository in knownServers.values {
				repository.dissociate(from: self)
			}
		}
		
		/// ISO 10303-22 (10.4.5) Open repository
		/// 
		/// This operation makes the contents of a repository available for subsequent access.  
		public func open(repository: SdaiRepository) {
			activeServers[repository.name] = repository
		}
		
		/// ISO 10303-22 (10.5.3) Close repository
		/// 
		/// This operation closes an SdaiRepository that has been previously opened.
		/// SDAI-models and schema instances within the repository are no longer available for access.  
		public func close(repository: SdaiRepository) {
			activeServers[repository.name] = nil
		}

		
		//MARK: swift language binding
		
		public init(repositories:[SdaiRepository]) {
			super.init()
			for repository in repositories + [SdaiRepository.builtInRepository] {
				knownServers[repository.name] = repository
				repository.associate(with: self)
			}
		}
		
		internal static var dataDictionary: [SDAIDictionarySchema.ExpressId: SDAIDictionarySchema.SchemaDefinition] = [:]
	}
	
	//MARK:-
	/// ISO 10303-22 (7.4.2) implementation
	/// 
	/// An Implementation represents a software product that provides the functionality defined by an SDAI language binding.   
	public final class Implementation: SDAI.Object {
		
		//MARK: Attribute definitions:
		
		/// the name of Implementation assigned by the implementor.
		public let name: STRING = "SwiftSDAIcore"
		
		/// the software version level of the Implementation assigned by the implementor.
		public let level: STRING = "1.0.0"
		
		/// the version of ISO 10303-22 to which the implementation conforms.
		/// 
		/// The value of this attribute shall follow the registration technique defined in ISO 10303-1: 4.3 and shall be the object identifier for the appropriate version of ISO 10303-22 (see C.1)  
		public let sdaiVersion: STRING = "{ iso standard 10303 part(22) version(0) }"
		
		/// the version of the SDAI language binding supported as specified in the SDAI language binding.
		public let bindingVersion: STRING = "1.0.0"

		/// the implementation class specified in ISO 10303-22 to which the Implementation conforms (see 13.2).
		public let implementationClass: INTEGER = 1 // lowest level of function

		/// the level of transaction supported by the implementation (see 13.1.1). 
		public let transactionLevel: INTEGER = 1	// no transaction

		/// the level of expression evaluation supprted by the implementation (see 13.1.2).
		public let expressionLevel: INTEGER = 4 // complete evaluation

		/// the level of event recording supported by the implementation (see 13.1.3). 
		public let recordingLevel: INTEGER = 1 // no recording
		
		/// the level of SCOPE supported by the implementation (see 13.1.4).
		public let scopeLevel: INTEGER = 1 // no scope
		
		/// the level of domain equivalence supported by the implementation (see 13.1.5).
		public let domainEquivalenceLevel: INTEGER = 1 // no domain equivalence		
		
	}
}
