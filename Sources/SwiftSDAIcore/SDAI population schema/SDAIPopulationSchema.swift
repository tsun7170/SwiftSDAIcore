//
//  SDAIPopulationSchema.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/24.
//  Copyright © 2020 Minokamo, Japan. All rights reserved.
//

import Foundation

public enum SDAIPopulationSchema {
	public typealias STRING = String
	public typealias SET = Set
	public typealias LOGICAL = Bool?
	public typealias INTEGER = Int

	
	public class SchemaInstance: SDAI.Object {
		public var name: STRING { abstruct() }
		public var associatedModels: SET<SdaiModel> = []
		public var nativeSchema: SDAIDictionarySchema.SchemaDefinition { abstruct() }
		public var repository: SDAISessionSchema.SdaiRepository { abstruct() }
		public var changeDate: SDAISessionSchema.TimeStamp?
		public var validationDate: SDAISessionSchema.TimeStamp { abstruct() }
		public var validationResult: LOGICAL { abstruct() }
		public var validationLevel: INTEGER = 1
	}
	
	public class SdaiModel: SDAI.Object {
		public var name: STRING { abstruct() }
		public var contents: SdaiModelContents { abstruct() }
		public var underlyingSchema: SDAIDictionarySchema.SchemaDefinition { abstruct() }
		public unowned var repository: SDAISessionSchema.SdaiRepository { abstruct() }
		public var changeDate: SDAISessionSchema.TimeStamp?
		public var mode: SDAISessionSchema.AccessType?
		public var associatedWith: SET<SchemaInstance> { abstruct() }
	}
	
	public class SdaiModelContents: SDAI.Object {
		public typealias EntityInstanceLabel = SDAIParameterDataSchema.STRING
		public typealias EntityName = SDAIDictionarySchema.ExpressId
		
		public var instances: [EntityInstanceLabel : SDAIParameterDataSchema.EntityInstance] = [:]
		public var folders: [EntityName : EntityExtent] = [:]
		public var populatedFolders: [EntityName : EntityExtent] = [:]
		public unowned var ownedBy: SdaiModel { abstruct() }
	}
	
	public class EntityExtent: SDAI.Object {
		public var definition: SDAIDictionarySchema.EntityDefinition { abstruct() }
		public var instances: SET<SDAIParameterDataSchema.EntityInstance> = []
		public unowned var ownedBy: SdaiModelContents { abstruct() }
	}
	
}
