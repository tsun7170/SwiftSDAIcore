//
//  File.swift
//  
//
//  Created by Yoshida on 2021/05/21.
//

import Foundation


public protocol SDAIGenericType: Hashable, InitializableBySelecttype, InitializableByP21Parameter 
{
	associatedtype FundamentalType: SDAIGenericType
	associatedtype Value: SDAIValue

	var asFundamentalType: FundamentalType {get}	
	init(fundamental: FundamentalType)

	var typeMembers: Set<SDAI.STRING> {get}
	var value: Value {get}
	
	var entityReference: SDAI.EntityReference? {get}
	var stringValue: SDAI.STRING? {get}
	var binaryValue: SDAI.BINARY? {get}
	var logicalValue: SDAI.LOGICAL? {get}
	var booleanValue: SDAI.BOOLEAN? {get}
	var numberValue: SDAI.NUMBER? {get}
	var realValue: SDAI.REAL? {get}
	var integerValue: SDAI.INTEGER? {get}
	var genericEnumValue: SDAI.GenericEnumValue? {get}
	
	func arrayOptionalValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY_OPTIONAL<ELEM>?
	func arrayValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>?
	func listValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.LIST<ELEM>?
	func bagValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.BAG<ELEM>?
	func setValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.SET<ELEM>?
	func enumValue<ENUM:SDAIEnumerationType>(enumType:ENUM.Type) -> ENUM?
	
	static func validateWhereRules(instance:Self?, prefix:SDAI.WhereLabel, excludingEntity: Bool) -> [SDAI.WhereLabel:SDAI.LOGICAL]
}

public extension SDAIGenericType
{
	init?(fundamental: FundamentalType?) {
		guard let fundamental = fundamental else { return nil }
		self.init(fundamental: fundamental)
	}		
}

public extension SDAIGenericType where Self: SDAIDefinedType
{
	static func validateWhereRules(instance:Self?, prefix:SDAI.WhereLabel, excludingEntity: Bool) -> [SDAI.WhereLabel:SDAI.LOGICAL] {
		return Supertype.validateWhereRules(instance:instance?.rep, prefix: prefix + "\\" + Supertype.typeName, excludingEntity: excludingEntity)
	}
}



public extension SDAIGenericType where Self: SDAIDefinedType
{
	var typeMembers: Set<SDAI.STRING> {
		var members = rep.typeMembers
		members.insert(SDAI.STRING(Self.typeName))
		return members
	}
}

public extension SDAIGenericType where Self: SDAIDefinedType
{
	var value: Value {rep.value}	
}

public extension SDAIGenericType where Self: SDAIDefinedType
{
	var entityReference: SDAI.EntityReference? {rep.entityReference}	
	var stringValue: SDAI.STRING? {rep.stringValue}
	var binaryValue: SDAI.BINARY? {rep.binaryValue}
	var logicalValue: SDAI.LOGICAL? {rep.logicalValue}
	var booleanValue: SDAI.BOOLEAN? {rep.booleanValue}
	var numberValue: SDAI.NUMBER? {rep.numberValue}
	var realValue: SDAI.REAL? {rep.realValue}
	var integerValue: SDAI.INTEGER? {rep.integerValue}
	var genericEnumValue: SDAI.GenericEnumValue? {rep.genericEnumValue}
	
	func arrayOptionalValue<ELEMENT:SDAIGenericType>(elementType:ELEMENT.Type) -> SDAI.ARRAY_OPTIONAL<ELEMENT>? {
		rep.arrayOptionalValue(elementType: elementType)
	}
	func arrayValue<ELEMENT:SDAIGenericType>(elementType:ELEMENT.Type) -> SDAI.ARRAY<ELEMENT>? {
		rep.arrayValue(elementType: elementType)
	}
	func listValue<ELEMENT:SDAIGenericType>(elementType:ELEMENT.Type) -> SDAI.LIST<ELEMENT>? {
		rep.listValue(elementType: elementType)
	}
	func bagValue<ELEMENT:SDAIGenericType>(elementType:ELEMENT.Type) -> SDAI.BAG<ELEMENT>? {
		rep.bagValue(elementType: elementType)
	}
	func setValue<ELEMENT:SDAIGenericType>(elementType:ELEMENT.Type) -> SDAI.SET<ELEMENT>? {
		rep.setValue(elementType: elementType)
	}
	func enumValue<ENUM:SDAIEnumerationType>(enumType:ENUM.Type) -> ENUM? {
		rep.enumValue(enumType: enumType)
	}
}

public extension SDAIGenericType where Self: SDAI.EntityReference
{
	init(fundamental: FundamentalType) {
		self.init(complex: fundamental.complexEntity)!
	}
}

