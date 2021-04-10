//
//  SchemaDefinition.swift
//  SwiftSDAIcore
//
//  Created by Yoshida on 2020/05/16.
//  Copyright © 2020 Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAIDictionarySchema {
	
	//MARK: (6.4.1)
	public class SchemaDefinition: SDAI.Object {
		public init(name: ExpressId) {
			self.name = name
			super.init()
		}
		
		public let name: ExpressId
		
		public var identification: InfoObjectId?

		public private(set) var entities: [ExpressId:EntityDefinition] = [:]
		public private(set) var globalRules: [ExpressId:GlobalRule] = [:]
		
		public func addEntity(entityDef: EntityDefinition) {
			entityDef.parentSchema = self
			entities[entityDef.name] = entityDef
		}
		
		public func addGlobalRule(name: ExpressId, rule:@escaping SDAI.GlobalRuleSignature) {
			let ruleDef = GlobalRule(name: name, rule: rule, schema: self)
			globalRules[name] = ruleDef
		}
		
	}
	
	
	
}
