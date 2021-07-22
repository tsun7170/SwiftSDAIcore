//
//  EntityDefinition.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/24.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAIDictionarySchema {
	
	
	//MARK: (6.4.12)
	public final class EntityDefinition : NamedType, CustomStringConvertible {
		// CustomStringConvertible
		public var description: String {
			return "EntityDefinition(\(name): \(supertypes.count-1) supertypes, \(attributes.count) attributes, \(uniquenessRules.count) uniqueness rules)"
		}
		
		public init(name: ExpressId, type: SDAI.EntityReference.Type, explicitAttributeCount: Int) {
			self.type = type
			self.partialEntityExplicitAttributeCount = explicitAttributeCount
			super.init(name: name)
		}

		public private(set) var supertypes: [SDAI.EntityReference.Type] = [] // ending with self entity
//		public var complex: SDAI.BOOLEAN
//		public var instantiable: SDAI.BOOLEAN
//		public var independent: SDAI.BOOLEAN
		public private(set) var attributes: [ExpressId:SDAIAttributeType] = [:]
		public private(set) var uniquenessRules: [ExpressId:UniquenessRule] = [:]
//		public var globalRules: SDAI.SET<GlobalRule>

		// swift language binding
		public let type: SDAI.EntityReference.Type
		public var partialEntityType: SDAI.PartialEntity.Type { self.type.partialEntityType }
		public let partialEntityExplicitAttributeCount: Int
		public var totalExplicitAttribureCounts: [Int] {
			supertypes.map { $0.entityDefinition.partialEntityExplicitAttributeCount }
		}
		
		public var qualifiedEntityName: ExpressId {
			return self.parentSchema.name + "." + self.name
		}
		
		public func add(supertype: SDAI.EntityReference.Type) {
			self.supertypes.append(supertype)
		}
		
		public func addAttribute<ENT: SDAI.EntityReference,T: SDAIGenericType>(
			name:ExpressId, keyPath: KeyPath<ENT,T>, 
			kind: AttirbuteKind, source: AttributeSource, mayYieldEntityReference: Bool ) {
			let attrdef = NonOptionalAttribute(name: name, entityDef: self, keyPath: keyPath,
																				 kind: kind, source: source, mayYieldEntityReference: mayYieldEntityReference)
			self.attributes[name] = attrdef
		}
		public func addAttribute<ENT: SDAI.EntityReference,T: SDAIGenericType>(
			name:ExpressId, keyPath: KeyPath<ENT,T?>, 
			kind: AttirbuteKind, source: AttributeSource, mayYieldEntityReference: Bool ) {
			let attrdef = OptionalAttribute(name: name, entityDef: self, keyPath: keyPath,
																			kind: kind, source: source, mayYieldEntityReference: mayYieldEntityReference)
			self.attributes[name] = attrdef
		}
		
		public func addUniqunessRule(label:ExpressId, rule: @escaping SDAI.UniquenessRuleSignature) {
			let uniquedef = UniquenessRule(label: label, rule: rule, entity: self)
			self.uniquenessRules[label] = uniquedef
		}
	}
	
}

