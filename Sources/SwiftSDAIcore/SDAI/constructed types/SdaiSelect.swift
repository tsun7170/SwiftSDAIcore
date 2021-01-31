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
{
	
//	var entityReference: SDAI.EntityReference? {get}
//	var stringValue: SDAI.STRING? {get}
//	var binaryValue: SDAI.BINARY? {get}
//	var logicalValue: SDAI.LOGICAL? {get}
//	var booleanValue: SDAI.BOOLEAN? {get}
//	var numberValue: SDAI.NUMBER? {get}
//	var realValue: SDAI.REAL? {get}
//	var integerValue: SDAI.INTEGER? {get}
//	func arrayOptionalValue<ELEMENT:SDAIGenericType>(elementType:ELEMENT.Type) -> SDAI.ARRAY_OPTIONAL<ELEMENT>?
//	func arrayValue<ELEMENT:SDAIGenericType>(elementType:ELEMENT.Type) -> SDAI.ARRAY<ELEMENT>?
//	func listValue<ELEMENT:SDAIGenericType>(elementType:ELEMENT.Type) -> SDAI.LIST<ELEMENT>?
//	func bagValue<ELEMENT:SDAIGenericType>(elementType:ELEMENT.Type) -> SDAI.BAG<ELEMENT>?
//	func setValue<ELEMENT:SDAIGenericType>(elementType:ELEMENT.Type) -> SDAI.SET<ELEMENT>?
//	func enumValue<ENUM:SDAIEnumerationType>(enumType:ENUM.Type) -> ENUM?
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

//	var entityReference: SDAI.EntityReference? {nil}	
//	var stringValue: SDAI.STRING? {nil}
//	var binaryValue: SDAI.BINARY? {nil}
//	var logicalValue: SDAI.LOGICAL? {nil}
//	var booleanValue: SDAI.BOOLEAN? {nil}
//	var numberValue: SDAI.NUMBER? {nil}
//	var realValue: SDAI.REAL? {nil}
//	var integerValue: SDAI.INTEGER? {nil}
//	func arrayOptionalValue<ELEMENT:SDAIGenericType>(elementType:ELEMENT.Type) -> SDAI.ARRAY_OPTIONAL<ELEMENT>? {nil}
//	func arrayValue<ELEMENT:SDAIGenericType>(elementType:ELEMENT.Type) -> SDAI.ARRAY<ELEMENT>? {nil}
//	func listValue<ELEMENT:SDAIGenericType>(elementType:ELEMENT.Type) -> SDAI.LIST<ELEMENT>? {nil}
//	func bagValue<ELEMENT:SDAIGenericType>(elementType:ELEMENT.Type) -> SDAI.BAG<ELEMENT>? {nil}
//	func setValue<ELEMENT:SDAIGenericType>(elementType:ELEMENT.Type) -> SDAI.SET<ELEMENT>? {nil}
//	func enumValue<ENUM:SDAIEnumerationType>(enumType:ENUM.Type) -> ENUM? {nil}
//	var sizeOfAggregation: Int? {nil}
}

public extension SDAIDefinedType where Supertype: SDAISelectType, Self: SDAISelectType
{
	var entityReference: SDAI.EntityReference? {
		return rep.entityReference
	}
}

