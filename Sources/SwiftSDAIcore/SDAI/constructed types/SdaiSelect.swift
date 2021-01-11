//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation

//MARK: - SELECT TYPE base
public protocol SDAISelectType: SDAIConstructedType, InitializableByDefinedtype, InitializableByEntity, SDAIObservableAggregateElement 
where Value == FundamentalType,
	FundamentalType: SDAISelectType
//			SwiftType == FundamentalType
{
//	init?<G: SDAIGenericType>(possiblyFrom generic: G?)
//	init?(possiblyFrom complex: SDAI.ComplexEntity?)
	
//	init?(possiblyFrom entityRef: SDAI.EntityReference?)
//	init?<T: SDAIUnderlyingType>(possiblyFrom underlyingType: T?)
//	init?<S: SDAISelectType>(possiblyFrom select: S?)
	
//	init?<G: SDAIGenericType>(_ generic: G?)
//	init<G: SDAIGenericType>(_ generic: G)
	
//	init?(_ entityRef: SDAI.EntityReference?)
//	init(_ entityRef: SDAI.EntityReference)
//
//	init?<T: SDAIUnderlyingType>(_ underlyingType: T?)
//	init<T: SDAIUnderlyingType>(_ underlyingType: T)
//
//	init?<S: SDAISelectType>(_ select: S?)
//	init<S: SDAISelectType>(_ select: S)

	
//	var entityReference: SDAI.EntityReference? {get}
	var stringValue: SDAI.STRING? {get}
	var binaryValue: SDAI.BINARY? {get}
	var logicalValue: SDAI.LOGICAL? {get}
	var booleanValue: SDAI.BOOLEAN? {get}
	var numberValue: SDAI.NUMBER? {get}
	var realValue: SDAI.REAL? {get}
	var integerValue: SDAI.INTEGER? {get}
	func arrayOptionalValue<ELEMENT:SDAIGenericType>(elementType:ELEMENT.Type) -> SDAI.ARRAY_OPTIONAL<ELEMENT>?
	func arrayValue<ELEMENT:SDAIGenericType>(elementType:ELEMENT.Type) -> SDAI.ARRAY<ELEMENT>?
	func listValue<ELEMENT:SDAIGenericType>(elementType:ELEMENT.Type) -> SDAI.LIST<ELEMENT>?
	func bagValue<ELEMENT:SDAIGenericType>(elementType:ELEMENT.Type) -> SDAI.BAG<ELEMENT>?
	func setValue<ELEMENT:SDAIGenericType>(elementType:ELEMENT.Type) -> SDAI.SET<ELEMENT>?
	func enumValue<ENUM:SDAIEnumerationType>(enumType:ENUM.Type) -> ENUM?
//	var sizeOfAggregation: Int? {get}
//	subscript<I: SDAI__INTEGER__type>(index: I?) -> ELEMENT? {get}
//	subscript(index: Int?) -> ELEMENT? {get}
}

public extension SDAISelectType
{
	// SDAIGenericType
	var value: Value { self.asFundamentalType }
	
//	// SDAIUnderlyingType
//	var asSwiftType: SwiftType { self.asFundamentalType }

	init?<G: SDAI.EntityReference>(_ generic: G?){
		guard let generic = generic else { return nil }
		self.init(possiblyFrom: generic)
	}
//	init<G: SDAI.EntityReference>(_ generic: G){
//		self.init(possiblyFrom: generic)!
//	}

//	init?<G: SDAIUnderlyingType>(_ generic: G?){
//		guard let generic = generic else { return nil }
//		self.init(possiblyFrom: generic)
//	}
//	init<G: SDAIUnderlyingType>(_ generic: G){
//		self.init(possiblyFrom: generic)!
//	}

//	init?<G: SDAISelectType>(_ generic: G?){
//		guard let generic = generic else { return nil }
//		self.init(possiblyFrom: generic)
//	}
//	init<G: SDAISelectType>(_ generic: G){
//		self.init(possiblyFrom: generic)!
//	}

	// SDAIObservableAggregateElement
	var entityReference: SDAI.EntityReference? {nil}
	
	var stringValue: SDAI.STRING? {nil}
	var binaryValue: SDAI.BINARY? {nil}
	var logicalValue: SDAI.LOGICAL? {nil}
	var booleanValue: SDAI.BOOLEAN? {nil}
	var numberValue: SDAI.NUMBER? {nil}
	var realValue: SDAI.REAL? {nil}
	var integerValue: SDAI.INTEGER? {nil}
	func arrayOptionalValue<ELEMENT:SDAIGenericType>(elementType:ELEMENT.Type) -> SDAI.ARRAY_OPTIONAL<ELEMENT>? {nil}
	func arrayValue<ELEMENT:SDAIGenericType>(elementType:ELEMENT.Type) -> SDAI.ARRAY<ELEMENT>? {nil}
	func listValue<ELEMENT:SDAIGenericType>(elementType:ELEMENT.Type) -> SDAI.LIST<ELEMENT>? {nil}
	func bagValue<ELEMENT:SDAIGenericType>(elementType:ELEMENT.Type) -> SDAI.BAG<ELEMENT>? {nil}
	func setValue<ELEMENT:SDAIGenericType>(elementType:ELEMENT.Type) -> SDAI.SET<ELEMENT>? {nil}
	func enumValue<ENUM:SDAIEnumerationType>(enumType:ENUM.Type) -> ENUM? {nil}
//	var sizeOfAggregation: Int? {nil}
}

public extension SDAIDefinedType where Supertype: SDAISelectType, Self: SDAISelectType
{
	var entityReference: SDAI.EntityReference? {
		return rep.entityReference
	}
}

