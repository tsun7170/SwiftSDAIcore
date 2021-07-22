//
//  GlobalRuleDefinition.swift
//  
//
//  Created by Yoshida on 2021/04/10.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAIDictionarySchema {
	//MARK: (6.4.19)
	public final class GlobalRule: SDAI.Object, CustomStringConvertible {
		// CustomStringConvertible
		public var description: String { "GlobalRule(\(name))" }
		
		public init(name: ExpressId, rule: @escaping SDAI.GlobalRuleSignature, schema: SchemaDefinition) {
			self.name = name
			self.rule = rule
			self.parentSchema = schema
			super.init()
		}
		
		public let name: ExpressId
		//		public var entities: SDAI.LIST<EntityDefinition>
		//		public var whereRules: SDAI.LIST<WhereRule>
		public unowned let parentSchema: SchemaDefinition
		
		public let rule: SDAI.GlobalRuleSignature
	}
}
