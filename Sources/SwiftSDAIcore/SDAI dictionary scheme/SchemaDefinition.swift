//
//  SchemaDefinition.swift
//  SwiftSDAIcore
//
//  Created by Yoshida on 2020/05/16.
//  Copyright © 2020 Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAIDictionarySchema {
	
	public class SchemaDefinition {
		
		public var name: ExpressId
		public let identification: InfoObjectId = "{ iso standard 10303 part(22) version(0) object(1) SDAI-dictionary-schema(1) }"
		
		
		
		public func add(entity: EntityDefinition ) {
			
		}
		
		public func add(clone: EntityDefinition) {
			
		}
		
		public func add(schema: ExternalSchema ) {
			
		}
		
		public func add(type: DefinedType ) {
			
		}
		
		
		
		
	}
	
	
	
}
