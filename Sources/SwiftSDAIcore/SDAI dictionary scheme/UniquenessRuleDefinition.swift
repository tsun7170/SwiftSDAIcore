//
//  UniquenessRuleDefinition.swift
//  
//
//  Created by Yoshida on 2021/04/10.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAIDictionarySchema {
	public final class UniquenessRule: SDAI.Object, CustomStringConvertible {
		// CustomStringConvertible
		public var description: String { "UniquenessRule(\(parentEntity.name).\(label))" }
		
		public init(label: ExpressId, rule: @escaping SDAI.UniquenessRuleSignature, entity: EntityDefinition) {
			self.label = label
			self.rule = rule
			self.parentEntity = entity
			super.init()
		}
		
		
		public let label: ExpressId
		public unowned let parentEntity: EntityDefinition
		
		public let rule: SDAI.UniquenessRuleSignature
	}
}
