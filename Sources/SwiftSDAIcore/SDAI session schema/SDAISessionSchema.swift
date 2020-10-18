//
//  SDAISessionSchema.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/24.
//  Copyright © 2020 Minokamo, Japan. All rights reserved.
//

import Foundation

public enum SDAISessionSchema {
	public typealias STRING = String
	public typealias LIST = Array
	public typealias SET = Set
	public typealias BOOLEAN = Bool
	public typealias TimeStamp = Date
	
	public enum AccessType {
		case readOnly, readWrite	
	}
	
	public class SdaiSession: SDAI.Object {
		public let sdaiImplementation: Implementation = Implementation()
		public let recordingActive: BOOLEAN = false
		public let errors: LIST<ErrorEvent> = []
		public var knownServers: SET<SdaiRepository> { abstruct() }
		public var activeServers: SET<SdaiRepository> { abstruct() }
		public var activeModels: SET<SDAIPopulationSchema.SdaiModel> { abstruct() }
		public let dataDictionary: SDAIPopulationSchema.SchemaInstance? = nil
		public let activeTransaction: SET<SdaiTransaction> = []
		
		public var activeSchemaInstance: SDAIPopulationSchema.SchemaInstance { abstruct() }
	}
	
	public class Implementation: SDAI.Object {
		
	}
	
	public class SdaiRepository: SDAI.Object {
		public var name: STRING { abstruct() }
		public var contents: SdaiRepositoryContents { abstruct() }
		public var description: STRING { abstruct() }
		public unowned var session: SdaiSession { abstruct() }
	} 
	
	public class SdaiRepositoryContents: SDAI.Object {
		public var models: SET<SDAIPopulationSchema.SdaiModel> { abstruct() }
		public var schemas: SET<SDAIPopulationSchema.SchemaInstance> { abstruct() }
		public unowned var repository: SdaiRepository { abstruct() }
	}
	
	public class SdaiTransaction: SDAI.Object {
		
	}
	public class ErrorEvent: SDAI.Object {
		
	}
}
