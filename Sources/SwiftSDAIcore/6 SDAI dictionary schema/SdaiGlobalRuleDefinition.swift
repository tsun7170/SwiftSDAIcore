//
//  SdaiGlobalRuleDefinition.swift
//  
//
//  Created by Yoshida on 2021/04/10.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAIDictionarySchema {
	/// ISO 10303-22 (6.4.19) global_rule
	/// 
	/// A GlobalRule is a constraint. It constrains all instances of an entity type or constrains instances of multiple entity types and represents an EXPRESS RULE.
	public final class GlobalRule: SDAI.Object, CustomStringConvertible, @unchecked Sendable {

		//MARK: Attribute definitions:
		
		/// the name of the rule.
		public let name: ExpressId

//		public var entities: SDAI.LIST<EntityDefinition>
//		public var whereRules: SDAI.LIST<WhereRule>
		
		/// the schema in which the rule is declared.
		public var parentSchema: SchemaDefinition { self._parentSchema! }

		//MARK: swift language binding
		// CustomStringConvertible
		public var description: String { "GlobalRule(\(name))" }
		
		public init(name: ExpressId, rule: @escaping SDAI.GlobalRuleSignature) {
			self.name = name
			self.ruleBody = rule
//			super.init()
		}

		private unowned var _parentSchema: SchemaDefinition?

		internal func fixup(parentSchema: SchemaDefinition) {
			self._parentSchema = parentSchema
		}

		public let ruleBody: SDAI.GlobalRuleSignature
	}
}
