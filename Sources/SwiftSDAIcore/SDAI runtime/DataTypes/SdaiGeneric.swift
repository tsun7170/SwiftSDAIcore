//
//  SdaiGeneric.swift
//  
//
//  Created by Yoshida on 2021/02/07.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - abstract superclass
fileprivate class _AnyGenericBox: Hashable, @unchecked Sendable {
	static func == (lhs: _AnyGenericBox, rhs: _AnyGenericBox) -> Bool {
			return lhs.base == rhs.base
	}

	func hash(into hasher: inout Hasher) {
			hasher.combine(base)
	}
	
	var base: AnyHashable { abstract() }
	func copy() -> AnyHashable { abstract() }
	var isCacheable: Bool { abstract() }
  var typeMembers: Set<SDAI.STRING> { abstract() }
	var value: SDAI.GenericValue { abstract() }
	var entityReference: SDAI.EntityReference? { abstract() }
	var stringValue: SDAI.STRING? { abstract() }
	var binaryValue: SDAI.BINARY? { abstract() }
	var logicalValue: SDAI.LOGICAL? { abstract() }
	var booleanValue: SDAI.BOOLEAN? { abstract() }
	var numberValue: SDAI.NUMBER? { abstract() }
	var realValue: SDAI.REAL? { abstract() }
	var integerValue: SDAI.INTEGER? { abstract() }
	var genericEnumValue: SDAI.GenericEnumValue? { abstract() }

	var entityReferences: AnySequence<SDAI.EntityReference> { abstract() }
  var persistentEntityReferences: AnySequence<SDAI.GenericPersistentEntityReference> { abstract() }
	func isHolding(entityReference: SDAI.EntityReference) -> Bool { abstract() }

	var pRef: SDAI.GENERIC { abstract() }
	var aRef: SDAI.GENERIC { abstract() }
	var optionalARef: SDAI.GENERIC? { abstract() }

	func arrayOptionalValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.ARRAY_OPTIONAL<ELEM>? { abstract() }
	func arrayValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>? { abstract() }
	func listValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.LIST<ELEM>? { abstract() }
	func bagValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.BAG<ELEM>? { abstract() }
	func setValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.SET<ELEM>? { abstract() }
	func enumValue<ENUM:SDAI.EnumerationType>(enumType:ENUM.Type) -> ENUM? { abstract() }
	
	class func validateWhereRules(
		instance:_AnyGenericBox?,
		prefix:SDAIPopulationSchema.WhereLabel
	) -> SDAIPopulationSchema.WhereRuleValidationRecords { abstract() }

}

//MARK: - _GenericBox
fileprivate final class _GenericBox<G: SDAI.GenericType>: _AnyGenericBox, @unchecked Sendable
{
	private var _base: G
	private var anyBase: Any { self._base as Any }

	init(_ base: G){
		assert(type(of: base) != SDAI.GENERIC.self)
		self._base = base
	}
	
	override var base: AnyHashable { _base }
	override func copy() -> AnyHashable { _base.copy() }
	override var isCacheable: Bool { _base.isCacheable }
  override var typeMembers: Set<SDAI.STRING> { _base.typeMembers }
	override var value: SDAI.GenericValue { _base.value as SDAI.GenericValue }
	override var entityReference: SDAI.EntityReference? { _base.entityReference }
	override var stringValue: SDAI.STRING? { _base.stringValue }
	override var binaryValue: SDAI.BINARY? { _base.binaryValue }
	override var logicalValue: SDAI.LOGICAL? { _base.logicalValue }
	override var booleanValue: SDAI.BOOLEAN? { _base.booleanValue }
	override var numberValue: SDAI.NUMBER? { _base.numberValue }
	override var realValue: SDAI.REAL? { _base.realValue }
	override var integerValue: SDAI.INTEGER? { _base.integerValue }
	override var genericEnumValue: SDAI.GenericEnumValue? { _base.genericEnumValue }

	override var entityReferences: AnySequence<SDAI.EntityReference> {
		if let base = self.anyBase as? SDAI.EntityReferenceYielding {
			return base.entityReferences
		}
		else {
			return AnySequence()
		}
	}
  override var persistentEntityReferences: AnySequence<SDAI.GenericPersistentEntityReference> {
    if let base = self.anyBase as? SDAI.EntityReferenceYielding {
      return base.persistentEntityReferences
    }
    else {
      return AnySequence()
    }
  }
	override func isHolding( entityReference: SDAI.EntityReference ) -> Bool
	{
		if let base = self.anyBase as? SDAI.EntityReferenceYielding {
			return base.isHolding(entityReference: entityReference)
		}
		else {
			return false
		}
	}


	override var pRef: SDAI.GENERIC {
		if let base = self.anyBase as? (any SDAI.DualModeReference) {
			return SDAI.GENERIC(base.pRef)
		}
		else {
			return SDAI.GENERIC(box:self)
		}
	}

	override var aRef: SDAI.GENERIC {
		if let base = self.anyBase as? (any SDAI.PersistentReference) {
			return SDAI.GENERIC(base.aRef)
		}
		else {
			return SDAI.GENERIC(box:self)
		}
	}

	override var optionalARef: SDAI.GENERIC? {
		if let base = self.anyBase as? (any SDAI.PersistentReference) {
			guard let aRef = base.optionalARef else { return nil }
			return SDAI.GENERIC(aRef)
		}
		else {
			return SDAI.GENERIC(box:self)
		}
	}

	override func arrayOptionalValue<ELEM:SDAI.GenericType>(
		elementType:ELEM.Type) -> SDAI.ARRAY_OPTIONAL<ELEM>?
	{ _base.arrayOptionalValue(elementType: elementType) }

	override func arrayValue<ELEM:SDAI.GenericType>(
		elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>?
	{ _base.arrayValue(elementType: elementType) }

	override func listValue<ELEM:SDAI.GenericType>(
		elementType:ELEM.Type) -> SDAI.LIST<ELEM>?
	{ _base.listValue(elementType: elementType) }

	override func bagValue<ELEM:SDAI.GenericType>(
		elementType:ELEM.Type) -> SDAI.BAG<ELEM>?
	{ _base.bagValue(elementType: elementType) }

	override func setValue<ELEM:SDAI.GenericType>(
		elementType:ELEM.Type) -> SDAI.SET<ELEM>?
	{ _base.setValue(elementType: elementType) }

	override func enumValue<ENUM:SDAI.EnumerationType>(
		enumType:ENUM.Type) -> ENUM?
	{ _base.enumValue(enumType: enumType) }

	override class func validateWhereRules(
		instance:_AnyGenericBox?,
		prefix:SDAIPopulationSchema.WhereLabel
	) -> SDAIPopulationSchema.WhereRuleValidationRecords
	{
		guard let instance = instance as? Self else { return [:] }
		return G.validateWhereRules(instance:instance._base, prefix: prefix)
	}

}


//MARK: - SDAI__GENERIC__type
extension SDAI.TypeHierarchy {
  /// A protocol that aggregates the required behaviors for type-erased, generic EXPRESS values.
  ///
  /// `GENERIC__TypeBehavior` is adopted by types intended to represent the EXPRESS `GENERIC` type in Swift,
  /// providing a unified interface for all the capabilities required of a type-erased, boxed generic value.
  /// 
  /// ## Conformance Requirements:
  /// - `SDAI.GenericType`: Ensures conformance to the EXPRESS base type system and essential copying and value extraction.
  /// - `SDAI.EntityReferenceYielding`: Allows traversal and inspection of entity references contained in the generic value.
  /// - `SDAI.DualModeReference`: Supports dual-mode reference semantics (persistent and transient forms) required by EXPRESS.
  /// - `SDAI.PersistentReference`: Enables handling and conversion of persistent entity references.
  ///
  /// ## Purpose:
  /// This protocol is not intended to be implemented directly by user types, but is used as a type constraint
  /// for boxed, type-erased generic values (such as `SDAI.GENERIC`). It enables dynamic dispatch and abstraction
  /// of EXPRESS generic attributes, collections, and parameters, supporting type-safe operations and conversions
  /// across the EXPRESS type hierarchy.
  ///
  /// ## Usage:
  /// Use `GENERIC__TypeBehavior` as a type constraint or existential type when you need to work with any value
  /// conforming to all of the EXPRESS generic protocols listed above, particularly in the context of EXPRESS
  /// generic attribute values, collection elements, or dynamic EXPRESS data manipulation.
  public protocol GENERIC__TypeBehavior:
    SDAI.GenericType,
    SDAI.EntityReferenceYielding,
    SDAI.DualModeReference,
    SDAI.PersistentReference
  {}
}

//MARK: - SDAI.GENERIC
extension SDAI {
  
  /// A type-erased, boxed representation of any value conforming to `SDAI.GenericType`.
  ///
  /// `SDAI.GENERIC` enables the storage, manipulation, and transmission of values that conform to `SDAI.GenericType`,
  /// erasing their specific underlying type. This is particularly useful for expressing EXPRESS's GENERIC type in a type-safe manner,
  /// while allowing dynamic dispatch of common operations and value conversions required by generic EXPRESS attributes or parameters.
  ///
  /// ## Key Features:
  /// - Type-erasure for any `SDAI.GenericType`.
  /// - Provides dynamic access to underlying values with type-safe conversion functions for EXPRESS base types (e.g., STRING, NUMBER, ENTITY).
  /// - Supports EXPRESS generic collections (ARRAY, LIST, BAG, SET) and enumeration values.
  /// - Implements protocols for entity reference traversal and dual-mode/persistent references.
  /// - Suitable for use in collections, persistent storage, and as a bridge for EXPRESS generic attributes.
  ///
  /// ## Usage:
  /// Use `SDAI.GENERIC` to box a value of any type conforming to `SDAI.GenericType`:
  /// ```swift
  /// let value: SomeSDAIType = ...
  /// let genericValue = SDAI.GENERIC(value)
  /// ```
  ///
  /// Provides properties and methods to extract EXPRESS-typed values, traverse references, and perform generic operations,
  /// regardless of the underlying type.
  ///
  /// ## Implementation:
  /// - Wraps an internal private box for type-erasure and polymorphic dispatch.
  /// - Conforms to `SDAI.TypeHierarchy.GENERIC__TypeBehavior`, `CustomStringConvertible`, and EXPRESS-specific protocols.
  ///
	public struct GENERIC: SDAI.TypeHierarchy.GENERIC__TypeBehavior, CustomStringConvertible
	{
		public typealias FundamentalType = Self
		public typealias Value = GenericValue
		private var box: _AnyGenericBox
		
		//MARK: CustomStringConvertible
		public var description: String { "GENERIC(\(box.base))" }
		
		public init?<G: SDAI.GenericType>(_ generic: G?) {
			guard let generic = generic else { return nil }
			self.init(generic)
		}
		
		public init<G: SDAI.GenericType>(_ generic: G) {
			if let generic = generic as? GENERIC {
				box = generic.box
			}
			else {
				box = _GenericBox<G>(generic.copy())
			}
		}

		fileprivate init(box: _AnyGenericBox) {
			self.box = box
		}

		public var base: AnyHashable { box.base }
		
		//MARK: InitializableByGenericType
		public init?<G: SDAI.GenericType>(fromGeneric generic: G?){
			self.init(generic)
		}
		
		//MARK: SDAI.CacheableSource
		public var isCacheable: Bool { box.isCacheable }
		
		//MARK: SDAI.GenericType
		public func copy() -> SDAI.GENERIC { return self }
		public var asFundamentalType: FundamentalType { return self }	
		public init(fundamental: FundamentalType) {
			box = fundamental.box
		}
		public static var typeName: String { "GENERIC" }
    public var typeMembers: Set<SDAI.STRING> {
      return box.typeMembers
    }
		public var value: Value { box.value }
		
		public var entityReference: SDAI.EntityReference? { box.entityReference }
		public var stringValue: SDAI.STRING? { box.stringValue }
		public var binaryValue: SDAI.BINARY? { box.binaryValue }
		public var logicalValue: SDAI.LOGICAL? { box.logicalValue }
		public var booleanValue: SDAI.BOOLEAN? {box.booleanValue }
		public var numberValue: SDAI.NUMBER? { box.numberValue }
		public var realValue: SDAI.REAL? { box.realValue }
		public var integerValue: SDAI.INTEGER? { box.integerValue }
		public var genericEnumValue: SDAI.GenericEnumValue? { box.genericEnumValue }

		public func arrayOptionalValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.ARRAY_OPTIONAL<ELEM>?
		{ box.arrayOptionalValue(elementType: elementType) }

		public func arrayValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>?
		{ box.arrayValue(elementType: elementType) }

		public func listValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.LIST<ELEM>?
		{ box.listValue(elementType: elementType) }

		public func bagValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.BAG<ELEM>?
		{ box.bagValue(elementType: elementType) }

		public func setValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.SET<ELEM>?
		{ box.setValue(elementType: elementType) }

		public func enumValue<ENUM:SDAI.EnumerationType>(enumType:ENUM.Type) -> ENUM?
		{ box.enumValue(enumType: enumType) }

		public static func validateWhereRules(
			instance:Self?,
			prefix:SDAIPopulationSchema.WhereLabel
		) -> SDAIPopulationSchema.WhereRuleValidationRecords
		{
			guard let instance = instance else { return [:] }
			let basetype = type(of: instance.box)
			return basetype.validateWhereRules(instance:instance.box, prefix: prefix)
		}


    
		//MARK: SDAI.EntityReferenceYielding
		public var entityReferences: AnySequence<SDAI.EntityReference> {
			return box.entityReferences
		}

    public var persistentEntityReferences: AnySequence<SDAI.GenericPersistentEntityReference> {
      return box.persistentEntityReferences
    }

		public func isHolding(entityReference: SDAI.EntityReference) -> Bool {
			return box.isHolding(entityReference: entityReference)
		}

		//MARK: SDAI.DualModeReference
		public var pRef: GENERIC {
			return box.pRef
		}

		//MARK: SDAI.PersistentReference
		public var aRef: GENERIC {
			return box.aRef
		}

		public var optionalARef: GENERIC? {
			return box.optionalARef
		}

		//MARK: InitializableByP21Parameter
		public static let bareTypeName: String = "GENERIC"

		public init?(
			p21untypedParam: P21Decode.ExchangeStructure.UntypedParameter,
			from exchangeStructure: P21Decode.ExchangeStructure)
		{
			abstract()
		}
		public init?(p21omittedParamfrom exchangeStructure: P21Decode.ExchangeStructure) {
			abstract()
		}

	}
	
}
