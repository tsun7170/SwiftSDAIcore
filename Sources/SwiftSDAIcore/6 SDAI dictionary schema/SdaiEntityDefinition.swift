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

	public final class EntityDefinition : NamedType, CustomStringConvertible, @unchecked Sendable
	{

		//MARK: Attribute definitions:
		
		/// the list of entity type of which the entity type is an immediate SUBTYPE, or indirect SUBTYPE and ending with the subject(self) entity type.
		/// 
		/// the list corresponds with the list of partial entity types required to instantiate the subject entity instance by ISO 10303-21 external mapping.  
		public let supertypes: [SDAI.EntityReference.Type] // ending with self entity

		/// a boolean that has the value TRUE if the EntityDefinition is the result of mapping ANDOR or AND supertypes in the application schema (see A.1.3); FALSE if the EntityDefinition is mapped directly from an entity type in the schema.
		public var complex: SDAI.BOOLEAN { SDAI.BOOLEAN(supertypes.count > 1) }
		

		/// a boolean that has the value FALSE if the entity type is not independently instantiable because it is made available by a REFERENCE specification or is implicitly interfaced into the schema; TRUE if the entity type is declared locally within the schema or is made available by a USE specification.
		public var independent: SDAI.BOOLEAN { SDAI.BOOLEAN(true) }
		
		/// the attributes that are declared or redeclared (see ISO 10303-11: 9.2.3.4) in the entity type.
		/// 
		/// Attributes inherited from supertypes DO appear as elements of this set. Attributes to be introduced in the declared subtypes also DO appear as elements of this set. This set is populated for instances of EntityDefinition established by the EXPRESS ANDOR or AND supertype constraint.  
		public let attributes: [ExpressId:SDAIDictionarySchema.AttributeType]

    public let entityYieldingEssentialAttributes: [SDAIDictionarySchema.AttributeType]

		public let uniquenessRules: [ExpressId:UniquenessRule]

//		public var globalRules: SDAI.SET<GlobalRule>
		
		
		// CustomStringConvertible
		public var description: String {
			return "EntityDefinition(\(name): \(supertypes.count-1) supertypes, \(attributes.count) attributes, \(uniquenessRules.count) uniqueness rules)"
		}

		fileprivate init(byFreezing prototype: Prototype) {
			self.type = prototype.type
			self.partialEntityExplicitAttributeCount = prototype.partialEntityExplicitAttributeCount

			self.supertypes = prototype.supertypes
			self.attributes = prototype.attributes.mapValues{ $0.freeze() }
			self.uniquenessRules = prototype.uniquenessRules

      self.entityYieldingEssentialAttributes = self.attributes.values
        .filter {
          guard $0.mayYieldEntityReference,
                $0.source == .thisEntity
          else { return false }
          return true
        }

			super.init(name: prototype.name)

			self.fixupParentEntityReferences()
		}

		private func fixupParentEntityReferences() {
			for attrDef in self.attributes.values {
				if let attrDef = attrDef as? AttributeFixable {
					attrDef.fixup(parentEntity: self)
				}
			}
			for unique in self.uniquenessRules.values {
				unique.fixup(parentEntity: self)
			}
		}

		// swift language binding
		public let type: SDAI.EntityReference.Type
		public var partialEntityType: SDAI.PartialEntity.Type { self.type.partialEntityType }
		public let partialEntityExplicitAttributeCount: Int
		public var totalExplicitAttributeCounts: [Int] {
			supertypes.map { $0.entityDefinition.partialEntityExplicitAttributeCount }
		}
		
		public var qualifiedEntityName: ExpressId {
			return self.parentSchema.name + "." + self.name
		}
		

		//MARK: prototype for instance construction
		public class Prototype
		{
			internal let name: ExpressId
			internal let type: SDAI.EntityReference.Type
			internal let partialEntityExplicitAttributeCount: Int

			internal private(set) var supertypes: [SDAI.EntityReference.Type] = [] // ending with self entity
			internal private(set) var attributes: [ExpressId:SDAIAttributePrototype] = [:]
			internal private(set) var uniquenessRules: [ExpressId:UniquenessRule] = [:]

			public init(
				name: ExpressId,
				type: SDAI.EntityReference.Type,
				explicitAttributeCount: Int)
			{
				self.name = name
				self.type = type
				self.partialEntityExplicitAttributeCount = explicitAttributeCount
			}

			public func freeze() -> EntityDefinition {
				let entDef = EntityDefinition(byFreezing: self)
				return entDef
			}


			public func add(supertype: SDAI.EntityReference.Type)
			{
				self.supertypes.append(supertype)
			}

			public func addAttribute<ENT: SDAI.EntityReference,T: SDAI.GenericType>(
				name:ExpressId,
				keyPath: KeyPath<ENT,T>,
				kind: AttributeKind,
				source: AttributeSource,
				mayYieldEntityReference: Bool )
			{
				let attrdef = NonOptionalAttribute.Prototype(
					name: name,
					keyPath: keyPath,
					kind: kind,
					source: source,
					mayYieldEntityReference: mayYieldEntityReference)
				self.attributes[name] = attrdef
			}

			public func addAttribute<ENT: SDAI.EntityReference,T: SDAI.GenericType>(
				name:ExpressId,
				keyPath: KeyPath<ENT,T?>,
				kind: AttributeKind,
				source: AttributeSource,
				mayYieldEntityReference: Bool )
			{
				let attrdef = OptionalAttribute.Prototype(
					name: name,
					keyPath: keyPath,
					kind: kind,
					source: source,
					mayYieldEntityReference: mayYieldEntityReference)
				self.attributes[name] = attrdef
			}

			public func addUniquenessRule(
				label:ExpressId,
				rule: @escaping SDAI.UniquenessRuleSignature )
			{
				let uniquedef = UniquenessRule(label: label, rule: rule)
				self.uniquenessRules[label] = uniquedef
			}
		}//Prototype
	}
	
}

