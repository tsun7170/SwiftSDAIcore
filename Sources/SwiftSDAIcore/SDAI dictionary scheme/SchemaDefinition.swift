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
		public init(name: ExpressId, schema: SDAISchema.Type) {
			self.name = name
			self.schema = schema
			super.init()
			SDAISessionSchema.SdaiSession.dataDictionary[self.name] = self
		}
		
		public let name: ExpressId
		
		public var identification: InfoObjectId?

		public private(set) var entities: [ExpressId:EntityDefinition] = [:]
		public private(set) var globalRules: [ExpressId:GlobalRule] = [:]
		public private(set) var constants: [ExpressId:SDAI.GENERIC] = [:]
		
		// swift language binding
		public let schema: SDAISchema.Type
		
		public func addEntity(entityDef: EntityDefinition) {
			entityDef.parentSchema = self
			entities[entityDef.name] = entityDef
		}
		
		public func addGlobalRule(name: ExpressId, rule:@escaping SDAI.GlobalRuleSignature) {
			let ruleDef = GlobalRule(name: name, rule: rule, schema: self)
			globalRules[name] = ruleDef
		}
		
		public func addConstant<T:SDAIGenericType>(name:ExpressId, value:T) {
			let genericValue = SDAI.GENERIC(value)	
			constants[name] = genericValue
		}
		
		
		public var uniquenessRules: AnySequence<SDAIDictionarySchema.UniquenessRule> {
			return AnySequence( self.entities.lazy.map{ $1.uniquenessRules.lazy.map { $1 }}.joined() )
		}
	}
	
	
	
}
