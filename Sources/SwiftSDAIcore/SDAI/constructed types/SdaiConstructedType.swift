//
//  SdaiConstructedType.swift
//  
//
//  Created by Yoshida on 2020/10/18.
//

import Foundation



public protocol SDAIConstructedType: SDAIUnderlyingType 
where Value == FundamentalType,
			SwiftType == FundamentalType
{}
public extension SDAIConstructedType
{
	// SDAIGenericType \SDAIUnderlyingType\SDAIConstructedType\SDAIEnumerationType
	var value: Value { self.asFundamentalType }
	
	// SDAIUnderlyingType \SDAIConstructedType\SDAIEnumerationType
	var asSwiftType: SwiftType { self.asFundamentalType }
}

//MARK: - ENUMERATION TYPE base
public protocol SDAIEnumerationType: SDAIConstructedType 
{}
public extension SDAIEnumerationType
where Self: SDAIValue
{
	// SDAIValue
	func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool 
	{
		if let rhs = rhs as? Self { return self == rhs }
		return false
	}
}

extension SDAI {
	public typealias ENUMERATION = Int
	
}


//MARK: - SELECT TYPE base
public protocol SDAISelectType: SDAIConstructedType 
{
	init?<G: SDAIGenericType>(possiblyFrom generic: G?)
	init?(possiblyFrom complex: SDAI.ComplexEntity?)
	
	var entityReference: SDAI.EntityReference? {get}
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
	var sizeOfAggregation: Int? {get}
//	subscript<I: SDAI__INTEGER__type>(index: I?) -> ELEMENT? {get}
//	subscript(index: Int?) -> ELEMENT? {get}
}
//public extension SDAISelectType
//{
//	subscript<I: SDAI__INTEGER__type>(index: I?) -> ELEMENT? {
//		return self[index?.asSwiftType]
//	}
//}
public extension SDAIDefinedType where Supertype: SDAISelectType
{
	var entityReference: SDAI.EntityReference? {
		return rep.entityReference
	}
}

