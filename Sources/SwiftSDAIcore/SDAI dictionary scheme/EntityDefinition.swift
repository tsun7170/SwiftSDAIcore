//
//  EntityDefinition.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/24.
//  Copyright © 2020 Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAIDictionarySchema {
	
	
	//MARK: (6.4.12)
	public class EntityDefinition : NamedType {
		public init(name: ExpressId, type: SDAI.EntityReference.Type) {
			self.type = type
			super.init(name: name)
		}

//		public var supertypes: SDAI.LIST<EntityDefinition>
//		public var complex: SDAI.BOOLEAN
//		public var instantiable: SDAI.BOOLEAN
//		public var independent: SDAI.BOOLEAN
		public private(set) var attributes: [ExpressId:SDAIAttributeType] = [:]
		public private(set) var uniquenessRules: [ExpressId:UniquenessRule] = [:]
//		public var globalRules: SDAI.SET<GlobalRule>
//
//		
//		
		public let type: SDAI.EntityReference.Type
		
		public func addAttribute<ENT: SDAI.EntityReference,T: SDAIGenericType>(name:ExpressId, keyPath: KeyPath<ENT,T>) {
			let attrdef = NonOptionalAttribute(name: name, entityDef: self, keyPath: keyPath)
			self.attributes[name] = attrdef
		}
		public func addAttribute<ENT: SDAI.EntityReference,T: SDAIGenericType>(name:ExpressId, keyPath: KeyPath<ENT,T?>) {
			let attrdef = OptionalAttribute(name: name, entityDef: self, keyPath: keyPath)
			self.attributes[name] = attrdef
		}
		
		public func addUniqunessRule(label:ExpressId, rule: @escaping SDAI.UniquenessRuleSignature) {
			let uniquedef = UniquenessRule(label: label, rule: rule, entity: self)
			self.uniquenessRules[label] = uniquedef
		}
	}
	
}

