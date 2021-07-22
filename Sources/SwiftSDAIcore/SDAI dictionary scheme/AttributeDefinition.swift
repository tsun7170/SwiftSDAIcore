//
//  AttributeDefinition.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/24.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

public protocol SDAIAttributeType {
	var name: SDAIDictionarySchema.ExpressId { get }
	var domain: Any.Type { get }
	var typeName: String { get }
	var bareTypeName: String { get }
	var kind: SDAIDictionarySchema.AttirbuteKind { get }
	var source: SDAIDictionarySchema.AttributeSource { get }
	var mayYieldEntityReference: Bool { get }
	var parentEntity: SDAIDictionarySchema.EntityDefinition { get }
	var qualifiedAttributeName: SDAIDictionarySchema.ExpressId { get }
	func genericValue(for entity: SDAI.EntityReference) -> SDAI.GENERIC?
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
		
	//MARK: (6.4.13)
		public var domain: Any.Type { BaseType.self }
		public var typeName: String { BaseType.typeName }
		public var bareTypeName: String { BaseType.bareTypeName }
		public let name: ExpressId
		public unowned let parentEntity: EntityDefinition
		
		//MARK: SDAIAttributeType
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
		
		//MARK: swift binding support
		open func value(for entity: ENT) -> BaseType? { abstruct() }	// abstruct
	}
	
	
	
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
	
	
//	public class ExplicitAttribute<ENT: SDAI.EntityReference, T: SDAIGenericType>: Attribute<ENT,T> {
//		public var domain: BaseType
//		public var redeclaring: ExplicitAttribute?
//		public var optionalFlag: SDAI.BOOLEAN
//		
//	}
//	
//	public class DerivedAttribute<ENT: SDAI.EntityReference, T: SDAIGenericType>: Attribute<ENT,T> {
//		public var domain: BaseType
//		public var redeclaring: ExplicitOrDerived?
//		
//	}
//	
//	
//	public enum ExplicitOrDerived//: SDAISelectType 
//	{
//		case explicitAttribute(ExplicitAttribute)
//		case derivedAttribute(DerivedAttribute)
//	}
//
//	public class InverseAttribute<ENT: SDAI.EntityReference, T: SDAIGenericType>: Attribute<ENT,T> {
//		public var domain: EntityDefinition
//		public var redeclaring: InverseAttribute?
//		public var invertedAttr: ExplicitAttribute
//		public var minCardinality: Bound?
//		public var maxCardinality: Bound?
//		public var duplicates: SDAI.BOOLEAN
//	}
//	

	
	
	
}

