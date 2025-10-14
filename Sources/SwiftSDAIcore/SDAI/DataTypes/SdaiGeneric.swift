//
//  SdaiGeneric.swift
//  
//
//  Created by Yoshida on 2021/02/07.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

// abstract superclass
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
	func isHolding(entityReference: SDAI.EntityReference) -> Bool { abstract() }
//	func configure(with observer: SDAI.EntityReferenceObserver) { abstract() }
//	func teardownObserver() { abstract() }

	var pRef: SDAI.GENERIC { abstract() }
	var aRef: SDAI.GENERIC { abstract() }
	var optionalARef: SDAI.GENERIC? { abstract() }

	func arrayOptionalValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY_OPTIONAL<ELEM>? { abstract() }
	func arrayValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>? { abstract() }
	func listValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.LIST<ELEM>? { abstract() }
	func bagValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.BAG<ELEM>? { abstract() }
	func setValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.SET<ELEM>? { abstract() }
	func enumValue<ENUM:SDAIEnumerationType>(enumType:ENUM.Type) -> ENUM? { abstract() }
	
	class func validateWhereRules(
		instance:_AnyGenericBox?,
		prefix:SDAIPopulationSchema.WhereLabel
	) -> SDAIPopulationSchema.WhereRuleValidationRecords { abstract() }
}

fileprivate final class _GenericBox<G: SDAIGenericType>: _AnyGenericBox, @unchecked Sendable
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
		if let base = self.anyBase as? SDAIEntityReferenceYielding {
			return base.entityReferences
		}
		else {
			return AnySequence<SDAI.EntityReference>([])
		}
	}
	override func isHolding( entityReference: SDAI.EntityReference ) -> Bool
	{
		if let base = self.anyBase as? SDAIEntityReferenceYielding {
			return base.isHolding(entityReference: entityReference)
		}
		else {
			return false
		}
	}


	override var pRef: SDAI.GENERIC {
		if let base = self.anyBase as? (any SDAIDualModeReference) {
			return SDAI.GENERIC(base.pRef)
		}
		else {
			return SDAI.GENERIC(box:self)
		}
	}

	override var aRef: SDAI.GENERIC {
		if let base = self.anyBase as? (any SDAIPersistentReference) {
			return SDAI.GENERIC(base.aRef)
		}
		else {
			return SDAI.GENERIC(box:self)
		}
	}

	override var optionalARef: SDAI.GENERIC? {
		if let base = self.anyBase as? (any SDAIPersistentReference) {
			guard let aRef = base.optionalARef else { return nil }
			return SDAI.GENERIC(aRef)
		}
		else {
			return SDAI.GENERIC(box:self)
		}
	}

	override func arrayOptionalValue<ELEM:SDAIGenericType>(
		elementType:ELEM.Type) -> SDAI.ARRAY_OPTIONAL<ELEM>?
	{ _base.arrayOptionalValue(elementType: elementType) }

	override func arrayValue<ELEM:SDAIGenericType>(
		elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>?
	{ _base.arrayValue(elementType: elementType) }

	override func listValue<ELEM:SDAIGenericType>(
		elementType:ELEM.Type) -> SDAI.LIST<ELEM>?
	{ _base.listValue(elementType: elementType) }

	override func bagValue<ELEM:SDAIGenericType>(
		elementType:ELEM.Type) -> SDAI.BAG<ELEM>?
	{ _base.bagValue(elementType: elementType) }

	override func setValue<ELEM:SDAIGenericType>(
		elementType:ELEM.Type) -> SDAI.SET<ELEM>?
	{ _base.setValue(elementType: elementType) }

	override func enumValue<ENUM:SDAIEnumerationType>(
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

public protocol SDAI__GENERIC__type:
	SDAIGenericType,
	SDAIEntityReferenceYielding,
	SDAIDualModeReference,
	SDAIPersistentReference
{}

extension SDAI {
	public struct GENERIC: SDAI__GENERIC__type, CustomStringConvertible
	{
		public typealias FundamentalType = Self
		public typealias Value = GenericValue
		private var box: _AnyGenericBox
		
		// CustomStringConvertible
		public var description: String { "GENERIC(\(box.base))" }
		
		public init?<G: SDAIGenericType>(_ generic: G?) {
			guard let generic = generic else { return nil }
			self.init(generic)
		}
		
		public init<G: SDAIGenericType>(_ generic: G) {
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
		
		// InitializableByGenericType
		public init?<G: SDAIGenericType>(fromGeneric generic: G?){
			self.init(generic)
		}
		
		// SdaiCacheableSource
		public var isCacheable: Bool { box.isCacheable }
		
		// SDAIGenericType
		public func copy() -> SDAI.GENERIC { return self }
		public var asFundamentalType: FundamentalType { return self }	
		public init(fundamental: FundamentalType) {
			box = fundamental.box
		}
		public static var typeName: String { "GENERIC" }
		public var typeMembers: Set<SDAI.STRING> { return [SDAI.STRING(Self.typeName)] }
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

		public func arrayOptionalValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY_OPTIONAL<ELEM>?
		{ box.arrayOptionalValue(elementType: elementType) }

		public func arrayValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>?
		{ box.arrayValue(elementType: elementType) }

		public func listValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.LIST<ELEM>?
		{ box.listValue(elementType: elementType) }

		public func bagValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.BAG<ELEM>?
		{ box.bagValue(elementType: elementType) }

		public func setValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.SET<ELEM>?
		{ box.setValue(elementType: elementType) }

		public func enumValue<ENUM:SDAIEnumerationType>(enumType:ENUM.Type) -> ENUM?
		{ box.enumValue(enumType: enumType) }

		public static func validateWhereRules(
			instance:Self?,
			prefix:SDAIPopulationSchema.WhereLabel
		) -> SDAIPopulationSchema.WhereRuleValidationRecords
		{
			guard let instance = instance else { return [:] }
			let basetype = type(of: instance.box)
			if !((basetype as Any) is SDAI.EntityReference) { return [:] }
			return basetype.validateWhereRules(instance:instance.box, prefix: prefix)
		}

		// SDAIEntityReferenceYielding
		public var entityReferences: AnySequence<SDAI.EntityReference> {
			return box.entityReferences
		}

		public func isHolding(entityReference: SDAI.EntityReference) -> Bool {
			return box.isHolding(entityReference: entityReference)
		}

		// SDAIDualModeReference
		public var pRef: GENERIC {
			return box.pRef
		}

		//SDAIPersistentReference
		public var aRef: GENERIC {
			return box.aRef
		}

		public var optionalARef: GENERIC? {
			return box.optionalARef
		}

		// InitializableByP21Parameter
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
