//
//  SdaiGeneric.swift
//  
//
//  Created by Yoshida on 2021/02/07.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

// abstruct superclass
fileprivate class _AnyGenericBox: Hashable {
	static func == (lhs: _AnyGenericBox, rhs: _AnyGenericBox) -> Bool {
			return lhs.base == rhs.base
	}

	func hash(into hasher: inout Hasher) {
			hasher.combine(base)
	}
	
	var base: AnyHashable { abstruct() }
	func copy() -> AnyHashable { abstruct() }
	var value: SDAI.GenericValue { abstruct() }
	var entityReference: SDAI.EntityReference? { abstruct() }
	var stringValue: SDAI.STRING? { abstruct() }
	var binaryValue: SDAI.BINARY? { abstruct() }
	var logicalValue: SDAI.LOGICAL? { abstruct() }
	var booleanValue: SDAI.BOOLEAN? { abstruct() }
	var numberValue: SDAI.NUMBER? { abstruct() }
	var realValue: SDAI.REAL? { abstruct() }
	var integerValue: SDAI.INTEGER? { abstruct() }
	var genericEnumValue: SDAI.GenericEnumValue? { abstruct() }
	var entityReferences: AnySequence<SDAI.EntityReference> { abstruct() }
	func configure(with observer: SDAI.EntityReferenceObserver) { abstruct() }
	func teardownObserver() { abstruct() }

	func arrayOptionalValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY_OPTIONAL<ELEM>? { abstruct() }
	func arrayValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>? { abstruct() }
	func listValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.LIST<ELEM>? { abstruct() }
	func bagValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.BAG<ELEM>? { abstruct() }
	func setValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.SET<ELEM>? { abstruct() }
	func enumValue<ENUM:SDAIEnumerationType>(enumType:ENUM.Type) -> ENUM? { abstruct() }
	
	class func validateWhereRules(instance:_AnyGenericBox?, prefix:SDAI.WhereLabel) -> [SDAI.WhereLabel:SDAI.LOGICAL] { abstruct() }
}

fileprivate final class _GenericBox<G: SDAIGenericType>: _AnyGenericBox {
	private var _base: G
	
	init(_ base: G){
		assert(type(of: base) != SDAI.GENERIC.self)
		self._base = base
	}
	
	override var base: AnyHashable { _base }
	override func copy() -> AnyHashable { _base.copy() }
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
		if let base = (self._base as Any) as? SDAIObservableAggregateElement {
			return base.entityReferences
		}
		else {
			return AnySequence<SDAI.EntityReference>([])
		}
	}
	override func configure(with observer: SDAI.EntityReferenceObserver) { 
		if var base = (self._base as Any) as? SDAIObservableAggregateElement {
			base.configure(with: observer)
			self._base = base as! G
		}
	}
	override func teardownObserver() {
		if var base = (self._base as Any) as? SDAIObservableAggregateElement {
			base.teardownObserver()
			self._base = base as! G
		}
	}

	override func arrayOptionalValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY_OPTIONAL<ELEM>? { _base.arrayOptionalValue(elementType: elementType) }
	override func arrayValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>? { _base.arrayValue(elementType: elementType) }
	override func listValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.LIST<ELEM>? { _base.listValue(elementType: elementType) }
	override func bagValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.BAG<ELEM>? { _base.bagValue(elementType: elementType) }
	override func setValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.SET<ELEM>? { _base.setValue(elementType: elementType) }
	override func enumValue<ENUM:SDAIEnumerationType>(enumType:ENUM.Type) -> ENUM? { _base.enumValue(enumType: enumType) }
	
	override class func validateWhereRules(instance:_AnyGenericBox?, prefix:SDAI.WhereLabel) -> [SDAI.WhereLabel:SDAI.LOGICAL] {
		guard let instance = instance as? Self else { return [:] } 
		return G.validateWhereRules(instance:instance._base, prefix: prefix)
	}

}

public protocol SDAI__GENERIC__type: SDAIGenericType, SDAIObservableAggregateElement
{}

extension SDAI {
	public struct GENERIC: SDAI__GENERIC__type, CustomStringConvertible {		
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
//			let validation = self.entityReferences
//			for item in validation {
//				assert(item is SDAI.EntityReference)
//			}
		}
		
		public var base: AnyHashable { box.base }
		
		// InitializableByGenerictype
		public init?<G: SDAIGenericType>(fromGeneric generic: G?){
			self.init(generic)
		}
		
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

		public func arrayOptionalValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY_OPTIONAL<ELEM>? { box.arrayOptionalValue(elementType: elementType) }
		public func arrayValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>? { box.arrayValue(elementType: elementType) }
		public func listValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.LIST<ELEM>? { box.listValue(elementType: elementType) }
		public func bagValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.BAG<ELEM>? { box.bagValue(elementType: elementType) }
		public func setValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.SET<ELEM>? { box.setValue(elementType: elementType) }
		public func enumValue<ENUM:SDAIEnumerationType>(enumType:ENUM.Type) -> ENUM? { box.enumValue(enumType: enumType) }
		
		public static func validateWhereRules(instance:Self?, prefix:SDAI.WhereLabel) -> [SDAI.WhereLabel:SDAI.LOGICAL] {
			guard let instance = instance else { return [:] }
			let basetype = type(of: instance.box)
			if !((basetype as Any) is SDAI.EntityReference) { return [:] }
			return basetype.validateWhereRules(instance:instance.box, prefix: prefix)
		}

		// SDAIObservableAggregateElement
		public var entityReferences: AnySequence<SDAI.EntityReference> {
			return box.entityReferences
		}
		
		public mutating func configure(with observer: SDAI.EntityReferenceObserver) {
			box.configure(with: observer)
		}
		
		public mutating func teardownObserver() {
			box.teardownObserver()
		}

		// InitializableByP21Parameter
		public static var bareTypeName: String = "GENERIC"
		public init?(p21untypedParam: P21Decode.ExchangeStructure.UntypedParameter, from exchangeStructure: P21Decode.ExchangeStructure) {
			abstruct()	
		}
		public init?(p21omittedParamfrom exchangeStructure: P21Decode.ExchangeStructure) {
			abstruct()
		}

	}
	
}
