//
//  SdaiUniquenessRuleDefinition.swift
//  
//
//  Created by Yoshida on 2021/04/10.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAIDictionarySchema {
	
	/// ISO 10303-22 (6.4.17) uniqueness_rule
	/// 
	/// A UniquenessRule is the representation of an EXPRESS UNIQUE rule.
	/// It specifies a combination of attributes that are required to be unique within instances of the EntityDefinition within which the rule is declared.
	///
	public final class UniquenessRule: SDAI.Object, CustomStringConvertible, @unchecked Sendable
	{

		//MARK: Attribute definitions:
		
		/// if present, the name of the uniqueness rule.
		public let label: ExpressId

		//public var attributes
		
		/// the entity type within which the rule is declared.
		public var parentEntity: EntityDefinition { self._parentEntity! }

		//MARK: swift language binding
		// CustomStringConvertible
		public var description: String { "UniquenessRule(\(parentEntity.name).\(label))" }
		
		public init(label: ExpressId, rule: @escaping SDAI.UniquenessRuleSignature)
		{
			self.label = label
			self.ruleBody = rule
//			super.init()
		}


		private unowned var _parentEntity: EntityDefinition?

		internal func fixup(parentEntity: EntityDefinition) {
			self._parentEntity = parentEntity
		}

		public let ruleBody: SDAI.UniquenessRuleSignature
	}
}
