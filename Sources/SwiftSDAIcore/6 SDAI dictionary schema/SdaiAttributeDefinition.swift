//
//  SdaiAttributeDefinition.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/24.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation


/// ISO 10303-22 (6.4.13) attribute
public protocol SDAIAttributeType: Sendable {
	/// the name of the attribute. (6.4.13)
	var name: SDAIDictionarySchema.ExpressId { get }

	/// the entity type in which the attribute is declared. (6.4.13)
	var parentEntity: SDAIDictionarySchema.EntityDefinition { get }
	
	/// the data type of the result of the attribute value derivation. (6.4.14)
	/// the data type referenced by the attribute. (6.4.15)
	/// the referencing entity type defining the forward relationship; the source of the relationship. (6.4.16) 
	var domain: Any.Type { get }
	
	/// flag distinguishing the derived(6.4.14)/explicit(6.4.15)/inverse(6.4.16) attributes, redeclaring(6.4.14)(6.4.15), optional_flag(6.4.15)
	var kind: SDAIDictionarySchema.AttributeKind { get }
	
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
	public enum AttributeKind {
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
	internal protocol SDAIAttributePrototype {
		func freeze() -> SDAIAttributeType
	}
	internal protocol AttributeFixable {
		func fixup(parentEntity: EntityDefinition)
	}


	public class Attribute<ENT: SDAI.EntityReference, BaseType: SDAIGenericType>: SDAI.Object, SDAIAttributeType, CustomStringConvertible, AttributeFixable, @unchecked Sendable
	{
		// CustomStringConvertible
		public var description: String {
			"Attribute(\(name): type:\(BaseType.self), kind:\(kind), source:\(source) of \(parentEntity.name))"
		}

		internal init(
			name: ExpressId,
			kind: AttributeKind,
			source: AttributeSource,
			mayYieldEntityReference: Bool )
		{
			self.name = name
			self.kind = kind
			self.source = source
			self.mayYieldEntityReference = mayYieldEntityReference
//			super.init()
		}

		private unowned var _parentEntity: EntityDefinition?

		internal func fixup(parentEntity: EntityDefinition) {
			self._parentEntity = parentEntity
		}

		//MARK: SDAIAttributeType
		public var domain: Any.Type { BaseType.self }
		public var typeName: String { BaseType.typeName }
		public var bareTypeName: String { BaseType.bareTypeName }
		public let name: ExpressId
		public var parentEntity: EntityDefinition { self._parentEntity! }

		public var qualifiedAttributeName: SDAIDictionarySchema.ExpressId { parentEntity.qualifiedEntityName + "." + self.name }

//		private var invokedBy: Set<SDAI.EntityReference> = []
		public func genericValue(for entity: SDAI.EntityReference) -> SDAI.GENERIC?
		{
			guard let entity = entity as? ENT else { return nil }
//			if invokedBy.contains(entity) { return nil }	// to prevent infinite invocation loop
//			invokedBy.insert(entity)
			let value = SDAI.GENERIC(self.value(for: entity))
//			invokedBy.remove(entity)
			return value
		}

		public let kind: AttributeKind
		public let source: AttributeSource
		public let mayYieldEntityReference: Bool

		open func value(for entity: ENT) -> BaseType? { abstract() }	// abstract

	}
	
	
	//MARK: - specialization for optional attribute value type
	public final class OptionalAttribute<ENT: SDAI.EntityReference, BaseType: SDAIGenericType>: Attribute<ENT,BaseType>, @unchecked Sendable
	{
		internal init(byFreezing prototype: Prototype )
		{
			self.keyPath = prototype.keyPath

			super.init(
				name: prototype.name,
				kind: prototype.kind,
				source: prototype.source,
				mayYieldEntityReference: prototype.mayYieldEntityReference)
		}

		public let keyPath: KeyPath<ENT,BaseType?>

		public override func value(for entity: ENT) -> BaseType? {
			return entity[keyPath: self.keyPath]
		}

		//MARK: prototype for instance construction
		internal class Prototype: SDAIAttributePrototype
		{
			func freeze() -> any SDAIAttributeType
			{
				return OptionalAttribute(byFreezing: self)
			}
			
			let name: ExpressId
			let kind: AttributeKind
			let source: AttributeSource
			let mayYieldEntityReference: Bool
			let keyPath: KeyPath<ENT,BaseType?>


			internal init(
				name: ExpressId,
				keyPath: KeyPath<ENT,BaseType?>,
				kind: AttributeKind,
				source: AttributeSource,
				mayYieldEntityReference: Bool )
			{
				self.name = name
				self.kind = kind
				self.source = source
				self.mayYieldEntityReference = mayYieldEntityReference
				self.keyPath = keyPath
			}

		}//Prototype

	}

	
	//MARK: - specialization for non-optional attribute value type
	public final class NonOptionalAttribute<ENT: SDAI.EntityReference, BaseType: SDAIGenericType>: Attribute<ENT,BaseType>, @unchecked Sendable
	{
		internal init(byFreezing prototype: Prototype )
		{
			self.keyPath = prototype.keyPath

			super.init(
				name: prototype.name,
				kind: prototype.kind,
				source: prototype.source,
				mayYieldEntityReference: prototype.mayYieldEntityReference)
		}

		public let keyPath: KeyPath<ENT,BaseType>

		public override func value(for entity: ENT) -> BaseType? {
			return entity[keyPath: self.keyPath]
		}

		//MARK: prototype for instance construction
		internal class Prototype: SDAIAttributePrototype
		{
			func freeze() -> any SDAIAttributeType
			{
				return NonOptionalAttribute(byFreezing: self)
			}

			let name: ExpressId
			let kind: AttributeKind
			let source: AttributeSource
			let mayYieldEntityReference: Bool
			let keyPath: KeyPath<ENT,BaseType>


			internal init(
				name: ExpressId,
				keyPath: KeyPath<ENT,BaseType>,
				kind: AttributeKind,
				source: AttributeSource,
				mayYieldEntityReference: Bool )
			{
				self.name = name
				self.kind = kind
				self.source = source
				self.mayYieldEntityReference = mayYieldEntityReference
				self.keyPath = keyPath
			}

		}//Prototype
	}

}

