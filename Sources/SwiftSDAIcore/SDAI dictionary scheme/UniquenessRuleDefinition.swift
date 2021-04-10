//
//  File.swift
//  
//
//  Created by Yoshida on 2021/04/10.
//

import Foundation

extension SDAIDictionarySchema {
	public class UniquenessRule: SDAI.Object {
		public init(label: ExpressId, rule: @escaping SDAI.UniquenessRuleSignature, entity: EntityDefinition) {
			self.label = label
			self.rule = rule
			self.parentEntity = entity
			super.init()
		}
		
		
		public let label: ExpressId
//		public var attributes: SDAI.LIST<Attribute>
		public unowned let parentEntity: EntityDefinition
		
		public let rule: SDAI.UniquenessRuleSignature
	}
}