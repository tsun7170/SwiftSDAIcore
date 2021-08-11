//
//  SdaiEntityDefinition.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/24.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAIDictionarySchema {
	
	
	/// ISO 10303-22 (6.4.12) entity_definition
	///  
	/// An EntityDefinition is a NamedType establishing an entity as the result of an EXPRESS ENTITY declaration or as the result of the mapping applied to a combination of EXPRESS ENTITY declarations constrained using the EXPRESS ANDOR ro AND keyword (see A.1.3). Entities established by this mapping are considered subtypes of the constituent entity types.    
	public final class EntityDefinition : NamedType, CustomStringConvertible {
		
		//MARK: Attribute definitions:
		
		/// the list of entity type of which the entity type is an immediate SUBTYPE, or indirect SUBTYPE and ending with the subject(self) entity type.
		/// 
		/// the list corresponds with the list of partial entity types required to instantiate the subject entity instance by ISO 10303-21 external mapping.  
		public private(set) var supertypes: [SDAI.EntityReference.Type] = [] // ending with self entity
		
		/// a boolean that has the value TRUE if the EntityDefinition is the result of mapping ANDOR or AND supertypes in the application schema (see A.1.3); FALSE if the EntityDefinition is mapped directly from an entity type in the schema.
		public var complex: SDAI.BOOLEAN { SDAI.BOOLEAN(supertypes.count > 1) }
		
//		public var instantiable: SDAI.BOOLEAN
		
		/// a boolean that has the value FALSE if the entity type is not independently instantiable because it is made available by a REFERENCE specification or is implicitly interfaced into the schema; TRUE if the entity type is declared locally within the schema or is made available by a USE specification.
		public var independent: SDAI.BOOLEAN { SDAI.BOOLEAN(true) }
		
		/// the attributes that are declared or redeclared (see ISO 10303-11: 9.2.3.4) in the entity type.
		/// 
		/// Attributes inherited from supertypes DO appear as elements of this set. Attributes to be introduced in the declared subtypes also DO appear as elements of this set. This set is populated for instances of EntityDefinition established by the EXPRESS ANDOR or AND supertype constraint.  
		public private(set) var attributes: [ExpressId:SDAIAttributeType] = [:]
		
		public private(set) var uniquenessRules: [ExpressId:UniquenessRule] = [:]

//		public var globalRules: SDAI.SET<GlobalRule>
		
		
		// CustomStringConvertible
		public var description: String {
			return "EntityDefinition(\(name): \(supertypes.count-1) supertypes, \(attributes.count) attributes, \(uniquenessRules.count) uniqueness rules)"
		}
		
		public init(name: ExpressId, type: SDAI.EntityReference.Type, explicitAttributeCount: Int) {
			self.type = type
			self.partialEntityExplicitAttributeCount = explicitAttributeCount
			super.init(name: name)
		}


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

