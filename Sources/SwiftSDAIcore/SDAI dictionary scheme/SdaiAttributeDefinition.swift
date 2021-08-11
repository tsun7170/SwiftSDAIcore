//
//  SdaiAttributeDefinition.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/24.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation


/// ISO 10303-22 (6.4.13) attribute
public protocol SDAIAttributeType {
	/// the name of the attribute. (6.4.13)
	var name: SDAIDictionarySchema.ExpressId { get }

	/// the entity type in which the attribute is declared. (6.4.13)
	var parentEntity: SDAIDictionarySchema.EntityDefinition { get }
	
	/// the data type of the result of the attribute value derivation. (6.4.14)
	/// the data type referenced by the attribute. (6.4.15)
	/// the referencing entity type defining the forward relationship; the source of the relationship. (6.4.16) 
	var domain: Any.Type { get }
	
	/// flag distinguishing the derived(6.4.14)/explicit(6.4.15)/inverse(6.4.16) attributes, redeclaring(6.4.14)(6.4.15), optional_flag(6.4.15)
	var kind: SDAIDictionarySchema.AttirbuteKind { get }
	
	/// name of attribute domain, qualified with the originating schema.
	var typeName: String { get }
	/// name of attribute domain, without originating schema qualification.
	var bareTypeName: String { get }
	
	/// flag distinguishing where the attribute is defined (super/this/sub)
	var source: SDAIDictionarySchema.AttributeSource { get }
	
	/// flag indicating if the attribute value may yield entity reference.
	var mayYieldEntityReference: Bool { get }
	
	/// attribute name fully qualified with originating schema and entity names.
	var qualifiedAttributeName: SDAIDictionarySchema.ExpressId { get }
	
	/// ISO 10303-22 (10.10.1) Get attribute
	/// 
	/// This operation returns the value of an attribute of an entityInstance. If no value exists for the attribute (because it has never been assigned or has been unset, whether or not the attribute is optional) the vallue returned is not defined by ISO 10303-22 and the VA-NSET error shall be generated.  
	/// - Parameter entityInstance: The entity instance from which to obtain an attribute value.
	/// - Returns: attribute value wrapped in SDAI.GENERIC
	func genericValue(for entityInstance: SDAI.EntityReference) -> SDAI.GENERIC?
}

extension SDAIDictionarySchema {
	public enum AttirbuteKind {
		case explicit
		case explicitOptional
		case explicitRedeclaring
		case explicitOptionalRedeclaring
		case derived
		case derivedRedeclaring
		case inverse
	}
	
	public enum AttributeSource {
		case superEntity
		case thisEntity
		case subEntity
	}
	
	//MARK: - implementation base class
	public class Attribute<ENT: SDAI.EntityReference, BaseType: SDAIGenericType>: SDAI.Object, SDAIAttributeType, CustomStringConvertible {
		// CustomStringConvertible
		public var description: String {
			"Attribute(\(name): type:\(BaseType.self), kind:\(kind), source:\(source) of \(parentEntity.name))"
		}		
		
		public init(name: ExpressId, entityDef: EntityDefinition, 
								kind: AttirbuteKind, source: AttributeSource, mayYieldEntityReference: Bool ) {
			self.name = name
			self.parentEntity = entityDef
			self.kind = kind
			self.source = source
			self.mayYieldEntityReference = mayYieldEntityReference
			super.init()
		}
		
		//MARK: SDAIAttributeType
		public var domain: Any.Type { BaseType.self }
		public var typeName: String { BaseType.typeName }
		public var bareTypeName: String { BaseType.bareTypeName }
		public let name: ExpressId
		public unowned let parentEntity: EntityDefinition
		
		public var qualifiedAttributeName: SDAIDictionarySchema.ExpressId { parentEntity.qualifiedEntityName + "." + self.name }

		private var invokedBy: Set<SDAI.EntityReference> = []
		public func genericValue(for entity: SDAI.EntityReference) -> SDAI.GENERIC? {
			guard let entity = entity as? ENT else { return nil }
			if invokedBy.contains(entity) { return nil }	// to prevent infinite invocation loop
			invokedBy.insert(entity)
			let value = SDAI.GENERIC(self.value(for: entity))
			invokedBy.remove(entity)
			return value
		}
		
		public let kind: AttirbuteKind
		public let source: AttributeSource
		public let mayYieldEntityReference: Bool
		
		open func value(for entity: ENT) -> BaseType? { abstruct() }	// abstruct
	}
	
	
	//MARK: - specialization for optional attribute value type
	public final class OptionalAttribute<ENT: SDAI.EntityReference, BaseType: SDAIGenericType>: Attribute<ENT,BaseType> {
		public init(name: ExpressId, entityDef: EntityDefinition, keyPath: KeyPath<ENT,BaseType?>, 
								kind: AttirbuteKind, source: AttributeSource, mayYieldEntityReference: Bool ) {
			self.keyPath = keyPath
			super.init(name: name, entityDef: entityDef, 
								 kind: kind, source: source, mayYieldEntityReference: mayYieldEntityReference)
		}
		
		public let keyPath: KeyPath<ENT,BaseType?>

		public override func value(for entity: ENT) -> BaseType? { 
			return entity[keyPath: self.keyPath]
		}
	}

	
	//MARK: - specialization for non-optional attribute value type
	public final class NonOptionalAttribute<ENT: SDAI.EntityReference, BaseType: SDAIGenericType>: Attribute<ENT,BaseType> {
		public init(name: ExpressId, entityDef: EntityDefinition, keyPath: KeyPath<ENT,BaseType>, 
								kind: AttirbuteKind, source: AttributeSource, mayYieldEntityReference: Bool ) {
			self.keyPath = keyPath
			super.init(name: name, entityDef: entityDef,
								 kind: kind, source: source, mayYieldEntityReference: mayYieldEntityReference)
		}
		
		public let keyPath: KeyPath<ENT,BaseType>
		
		public override func value(for entity: ENT) -> BaseType? { 
			return entity[keyPath: self.keyPath]
		}
	}
	
}

