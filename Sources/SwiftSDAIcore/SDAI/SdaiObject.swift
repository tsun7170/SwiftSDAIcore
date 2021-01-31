//
//  SdaiObject.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/23.
//  Copyright © 2020 Minokamo, Japan. All rights reserved.
//

import Foundation


public protocol SDAIGenericType: Hashable, InitializableBySelecttype, InitializableByGenerictype 
{
	associatedtype Value: SDAIValue
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
	func arrayOptionalValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY_OPTIONAL<ELEM>?
	func arrayValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>?
	func listValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.LIST<ELEM>?
	func bagValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.BAG<ELEM>?
	func setValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.SET<ELEM>?
	func enumValue<ENUM:SDAIEnumerationType>(enumType:ENUM.Type) -> ENUM?
}
//public extension SDAIGenericType
//{
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
//}

public extension SDAIGenericType where Self: SDAIDefinedType
//where Supertype: SDAIGenericType
{
	var typeMembers: Set<SDAI.STRING> {
		var members = rep.typeMembers
		members.insert(SDAI.STRING(Self.typeName))
		return members
	}
}

public extension SDAIGenericType where Self: SDAIDefinedType
//where Value == Supertype.Value
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




public protocol SDAINamedType 
{}




public protocol SDAISwiftType
{}
extension String: SDAISwiftType {}
extension Int: SDAISwiftType {}
extension Double: SDAISwiftType {}
extension Bool: SDAISwiftType {}



public protocol SDAISwiftTypeRepresented
{
	associatedtype SwiftType
	var asSwiftType: SwiftType {get}	
}
public extension SDAIDefinedType 
where Supertype: SDAISwiftTypeRepresented, Self: SDAISwiftTypeRepresented, SwiftType == Supertype.SwiftType
{
	var asSwiftType: SwiftType { return rep.asSwiftType }
}






//MARK: - SDAI namespace
public enum SDAI {
	public typealias GENERIC = Any
	public typealias GENERIC_ENTITY = EntityReference

//	public static let INDETERMINATE: Any? = nil
	
	public static let TRUE:LOGICAL = true
	public static let FALSE:LOGICAL = false
	public static let UNKNOWN:LOGICAL = nil
	
	public static let CONST_E:REAL = REAL(exp(1.0))
	public static let PI:REAL = REAL(Double.pi)
	
	


	//MARK: - SDAI.Object	
	open class Object: Hashable {
		public static func == (lhs: SDAI.Object, rhs: SDAI.Object) -> Bool {
			return lhs === rhs
		}
		
		public func hash(into hasher: inout Hasher) {
			withUnsafePointer(to: self) { (p) -> Void in
				hasher.combine(p.hashValue)
			}
		}
	}
	
}


