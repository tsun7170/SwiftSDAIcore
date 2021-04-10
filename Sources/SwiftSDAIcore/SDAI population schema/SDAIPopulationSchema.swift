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

	
	
	//MARK: (8.4.2)
	public class SdaiModel: SDAI.Object {
		public var name: STRING { abstruct() }
		public var contents: SdaiModelContents { abstruct() }
		public var underlyingSchema: SDAIDictionarySchema.SchemaDefinition { abstruct() }
		public unowned var repository: SDAISessionSchema.SdaiRepository { abstruct() }
		public var changeDate: SDAISessionSchema.TimeStamp?
		public var mode: SDAISessionSchema.AccessType?
		public var associatedWith: SET<SchemaInstance> { abstruct() }
		
		//MARK: swift binding support
		public var defaultSchemaInstance: SchemaInstance { abstruct() }
	}
	
	//MARK: (8.4.3)
	public class SdaiModelContents: SDAI.Object {
		public typealias EntityInstanceLabel = SDAIParameterDataSchema.STRING
		public typealias EntityName = SDAIDictionarySchema.ExpressId
		
		public var instances: AnySequence<SDAIParameterDataSchema.EntityInstance> { abstruct() }
		public var folders: [EntityName : EntityExtent] = [:]
		public var populatedFolders: [EntityName : EntityExtent] = [:]
		public unowned var ownedBy: SdaiModel { abstruct() }

		//MARK: swift binding support
		public var allComplexEntities: AnySequence<SDAI.ComplexEntity> { abstruct() }
		
		//MARK: P21 support
		public var allP21PartialEntities: [P21Decode.EntityInstanceName : SDAI.PartialEntity] = [:]
		public var allP21ComplexEntities: [P21Decode.EntityInstanceName : SDAI.ComplexEntity] = [:]
	}
	
	public class EntityExtent: SDAI.Object {
		public var definition: SDAIDictionarySchema.EntityDefinition { abstruct() }
		public var instances: AnySequence<SDAIParameterDataSchema.EntityInstance> { abstruct() }
		public unowned var ownedBy: SdaiModelContents { abstruct() }
	}
	
}
