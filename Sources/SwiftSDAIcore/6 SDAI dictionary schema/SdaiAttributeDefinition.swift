//
//  SdaiAttributeDefinition.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/24.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation


/// ISO 10303-22 (6.4.13) attribute
extension SDAIDictionarySchema {

  /// A protocol representing an attribute of an entity as defined in ISO 10303-22 (6.4.13).
  ///
  /// `AttributeType` describes the interface for metadata and access operations on entity attributes
  /// in a data dictionary schema. It abstracts over explicit, derived, inverse, and optional attributes,
  /// and provides methods for generic value access and persistent reference discovery.
  ///
  /// ## Responsibilities
  /// - Expose attribute metadata such as its name, parent entity, type, kind, and source.
  /// - Provide mechanisms to obtain the value of the attribute from an entity instance, wrapped as a generic value.
  /// - Support discovery of persistent entity references contained in the attribute value, to facilitate functions like `USEDIN()`.
  ///
  /// ## Properties
  /// - `name`: The name of the attribute as declared in the schema.
  /// - `parentEntity`: The entity type in which the attribute is declared.
  /// - `domain`: The data type of the attribute value or derivation.
  /// - `kind`: The kind of attribute (explicit, derived, inverse, redeclaring, optional).
  /// - `typeName`: The fully qualified name of the attribute's domain type.
  /// - `bareTypeName`: The unqualified name of the attribute's domain type.
  /// - `source`: Denotes where the attribute is defined (super, this, or sub entity).
  /// - `mayYieldEntityReference`: Indicates whether the attribute's value may contain entity references.
  /// - `qualifiedAttributeName`: Fully qualified attribute name including schema and entity context.
  ///
  /// ## Methods
  /// - `genericValue(for:)`: Returns the attribute's value for a given entity instance, wrapped in a generic container. May return `nil` if unset.
  /// - `persistentEntityReferences(for:)`: Returns any persistent entity references yielded by the attribute value for a given entity instance, supporting reference-tracing operations like `USEDIN()`.
  ///
  /// ## Conformance
  /// - Conforming types should be `Sendable` to support concurrency.
  public protocol AttributeType: Sendable {
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
    /// This operation returns the value of an attribute of an entityInstance. If no value exists for the attribute (because it has never been assigned or has been unset, whether or not the attribute is optional) the value returned is not defined by ISO 10303-22 and the VA-NSET error shall be generated.
    ///
    /// - Parameter entityInstance: The entity instance from which to obtain an attribute value.
    /// - Returns: attribute value wrapped in SDAI.GENERIC
    ///
    /// defined in: ``SDAIDictionarySchema/AttributeType``
    func genericValue(for entityInstance: SDAI.EntityReference) -> SDAI.GENERIC?
    
    /// ISO 10303-22 (10.10.2) Test attribute
    ///
    /// This operation determines whether an attribute of an entity instance has a value. This operation is applicable to explicit attributes only.
    /// - Parameter entityInstance: The entity instance whose attribute is to be tested.
    /// - Returns: TRUE if Attribute has a value in Object; FALSE if it does not.
    ///
    /// defined in: ``SDAIDictionarySchema/AttributeType``
    func testAttribute(for entityInstance: SDAI.EntityReference) -> Bool


    /// persistent entity references for the entities contained in the attribute value
    ///
    /// to support USEDIN() function evaluations
    /// - Parameter entityInstance: The entity instance from which to obtain an attribute value.
    /// - Returns: sequence of persistent entity references
    ///
    func persistentEntityReferences(for entityInstance: SDAI.EntityReference) ->  AnySequence<SDAI.GenericPersistentEntityReference>?
  }
}
extension SDAIDictionarySchema.AttributeType {
  public func testAttribute(for entityInstance: SDAI.EntityReference) -> Bool
  {
    switch self.kind {
      case .explicit,
          .explicitOptional,
          .explicitRedeclaring,
          .explicitOptionalRedeclaring:
        let result = self.genericValue(for: entityInstance) != nil
        return result

      default:
        return false
    }
  }
}

extension SDAIDictionarySchema {

  /// An enumeration representing the kind of an attribute as defined in ISO 10303-22.
  /// 
  /// `AttributeKind` distinguishes between various categories of entity attributes,
  /// such as explicit, derived, and inverse attributes, as well as marking redeclared and optional variants.
  ///
  /// - `explicit`: An explicitly declared attribute.
  /// - `explicitOptional`: An explicitly declared optional attribute.
  /// - `explicitRedeclaring`: An explicitly redeclared attribute.
  /// - `explicitOptionalRedeclaring`: An explicitly redeclared optional attribute.
  /// - `derived`: A derived attribute whose value is computed rather than stored.
  /// - `derivedRedeclaring`: A derived attribute that redeclares an attribute from a supertype.
  /// - `inverse`: An inverse attribute representing a reverse relationship to another entity.
  ///
  /// This enumeration is used to describe the nature and declaration context of attributes in entity definitions.
	public enum AttributeKind {
		case explicit
		case explicitOptional
		case explicitRedeclaring
		case explicitOptionalRedeclaring
		case derived
		case derivedRedeclaring
		case inverse
	}
	
  /// An enumeration indicating the origin of an attribute definition within an entity hierarchy.
  ///
  /// `AttributeSource` distinguishes whether an attribute is defined in a supertype, the current entity, or a subtype.
  /// This helps clarify the source context for attribute inheritance, specialization, and redeclaration.
  ///
  /// - `superEntity`: The attribute is inherited from a supertype entity definition.
  /// - `thisEntity`: The attribute is declared directly in the current entity definition.
  /// - `subEntity`: The attribute is introduced or specialized in a subtype entity definition.
	public enum AttributeSource {
		case superEntity
		case thisEntity
		case subEntity
	}
	
	//MARK: - implementation base class
	internal protocol SDAIAttributePrototype {
		func freeze() -> SDAIDictionarySchema.AttributeType
	}
	internal protocol AttributeFixable {
		func fixup(parentEntity: EntityDefinition)
	}


  /// A base class representing an attribute of an entity as defined in ISO 10303-22 (6.4.13).
  ///
  /// `Attribute` encapsulates the definition and access mechanisms for an entity's attribute, including its name, parent entity, type, and kind (explicit, derived, inverse, etc.).
  ///
  /// - Parameters:
  ///   - ENT: The entity type (`SDAI.EntityReference`) in which the attribute is declared.
  ///   - BaseType: The data type (`SDAI.GenericType`) of the attribute value.
  ///
  /// Conforms to:
  /// - `SDAI.Object`: For SDAI object semantics.
  /// - `SDAIDictionarySchema.AttributeType`: Protocol describing required attribute properties and accessors.
  /// - `CustomStringConvertible`: For debug and logging.
  /// - `AttributeFixable`: Protocol for fixing up references to parent entities.
  /// - `@unchecked Sendable`: Allows the type to be used in concurrent contexts (unsafe).
  ///
  /// ## Responsibilities
  /// - Stores and exposes the attribute's metadata: name, type, kind, source, and parent entity.
  /// - Provides access to the attribute's value for a given entity instance (abstract).
  /// - Supports generation of generic values and persistent entity references for use in SDAI operations.
  /// - Facilitates the construction of optional and non-optional specializations.
  ///
  /// ## Usage
  /// This class is intended to be subclassed or specialized for concrete attribute definitions,
  /// such as `OptionalAttribute` and `NonOptionalAttribute`, which provide concrete implementations
  /// for accessing the attribute value from an entity instance.
	public class Attribute<ENT: SDAI.EntityReference, BaseType: SDAI.GenericType>: SDAI.Object, SDAIDictionarySchema.AttributeType, CustomStringConvertible, AttributeFixable, @unchecked Sendable
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
		}

		private unowned var _parentEntity: EntityDefinition?

		internal func fixup(parentEntity: EntityDefinition) {
			self._parentEntity = parentEntity
		}

		//MARK: SDAIDictionarySchema.AttributeType
		public var domain: Any.Type { BaseType.self }
		public var typeName: String { BaseType.typeName }
		public var bareTypeName: String { BaseType.bareTypeName }
		public let name: ExpressId
		public var parentEntity: EntityDefinition { self._parentEntity! }

		public var qualifiedAttributeName: SDAIDictionarySchema.ExpressId { parentEntity.qualifiedEntityName + "." + self.name }

		public final func genericValue(for entityInstance: SDAI.EntityReference) -> SDAI.GENERIC?
		{
			guard let entity = entityInstance as? ENT else { return nil }
			let value = SDAI.GENERIC(self.value(for: entity))
			return value
		}

    public final func persistentEntityReferences(
      for entityInstance: SDAI.EntityReference
    ) -> AnySequence<SDAI.GenericPersistentEntityReference>?
    {
      guard let entity = entityInstance as? ENT,
            let attrValue = self.value(for: entity) as? SDAI.EntityReferenceYielding
      else { return nil }

      let attrYieldingPRefs = attrValue.persistentEntityReferences
      return attrYieldingPRefs
    }

		public let kind: AttributeKind
		public let source: AttributeSource
		public let mayYieldEntityReference: Bool

		open func value(for entity: ENT) -> BaseType? { abstract() }	// abstract

	}
	
	
	//MARK: - specialization for optional attribute value type

  /// A specialization of `Attribute` representing an optional attribute value type within an entity definition.
  ///
  /// `OptionalAttribute` encapsulates the definition and mechanisms for accessing an optional attribute value from an entity instance.
  /// It leverages key paths to efficiently reference and access the attribute's value, supporting the case where the value may be absent.
  ///
  /// - Parameters:
  ///   - ENT: The entity type (`SDAI.EntityReference`) in which the attribute is declared.
  ///   - BaseType: The data type (`SDAI.GenericType`) of the attribute value.
  ///
  /// ## Usage
  /// Use `OptionalAttribute` for entity attributes that are defined as optional within the schema. Access to the attribute's value will return
  /// either the value or `nil` if it is unset.
  ///
  /// This class is typically constructed using the `Prototype` inner class, which provides the necessary metadata and keyPath for building the attribute definition.
  ///
  /// ## Conforms to
  /// - `@unchecked Sendable`: Enables concurrent usage (with potential thread-safety caveats).
  ///
  /// ## Responsibilities
  /// - Provides access to the attribute's optional value for a given entity instance using a key path.
  /// - Stores metadata such as the attribute's name, kind, source, and whether it may yield an entity reference.
  ///
  /// ### Example
  /// ```swift
  /// // Constructing an OptionalAttribute for an entity:
  /// let myAttr = OptionalAttribute<MyEntity, MyValueType>(byFreezing: myPrototype)
  /// let value = myAttr.value(for: myEntityInstance)
  /// // value is of type MyValueType?
  /// ```
	public final class OptionalAttribute<ENT: SDAI.EntityReference, BaseType: SDAI.GenericType>: Attribute<ENT,BaseType>, @unchecked Sendable
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
			func freeze() -> any SDAIDictionarySchema.AttributeType
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

  /// A specialization of `Attribute` representing a non-optional attribute value type within an entity definition.
  ///
  /// `NonOptionalAttribute` encapsulates the definition and mechanisms for accessing a non-optional attribute value from an entity instance.
  /// It leverages key paths to efficiently reference and access the attribute's value, supporting the case where the value is always expected to be present.
  ///
  /// - Parameters:
  ///   - ENT: The entity type (`SDAI.EntityReference`) in which the attribute is declared.
  ///   - BaseType: The data type (`SDAI.GenericType`) of the attribute value.
  ///
  /// ## Usage
  /// Use `NonOptionalAttribute` for entity attributes that are defined as required (non-optional) within the schema. Access to the attribute's value will always return a value (never `nil`), assuming the entity instance is initialized correctly.
  ///
  /// This class is typically constructed using the `Prototype` inner class, which provides the necessary metadata and keyPath for building the attribute definition.
  ///
  /// ## Conforms to
  /// - `@unchecked Sendable`: Enables concurrent usage (with potential thread-safety caveats).
  ///
  /// ## Responsibilities
  /// - Provides access to the attribute's non-optional value for a given entity instance using a key path.
  /// - Stores metadata such as the attribute's name, kind, source, and whether it may yield an entity reference.
  ///
  /// ### Example
  /// ```swift
  /// // Constructing a NonOptionalAttribute for an entity:
  /// let myAttr = NonOptionalAttribute<MyEntity, MyValueType>(byFreezing: myPrototype)
  /// let value = myAttr.value(for: myEntityInstance)
  /// // value is of type MyValueType?
  /// ```
	public final class NonOptionalAttribute<ENT: SDAI.EntityReference, BaseType: SDAI.GenericType>: Attribute<ENT,BaseType>, @unchecked Sendable
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
			func freeze() -> any SDAIDictionarySchema.AttributeType
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

