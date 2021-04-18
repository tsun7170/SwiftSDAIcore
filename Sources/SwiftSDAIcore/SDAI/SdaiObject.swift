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

public protocol SDAISchema {
	static var schemaDefinition: SDAIDictionarySchema.SchemaDefinition {get}
}




//MARK: - SDAI namespace
public enum SDAI {
	public typealias GENERIC_ENTITY = EntityReference

	public static let TRUE:LOGICAL = true
	public static let FALSE:LOGICAL = false
	public static let UNKNOWN:LOGICAL = nil
	
	public static let CONST_E:REAL = REAL(exp(1.0))
	public static let PI:REAL = REAL(Double.pi)
	
	public static let _Infinity:INTEGER? = nil;

	public typealias WhereLabel = SDAIDictionarySchema.ExpressId
	
	public typealias GlobalRuleSignature = (_ allComplexEntities: AnySequence<SDAI.ComplexEntity>) -> [SDAI.WhereLabel:SDAI.LOGICAL]
	
	public struct GlobalRuleValidationResult {
		public var globalRule: SDAIDictionarySchema.GlobalRule
		public var result: SDAI.LOGICAL
		public var record: [SDAI.WhereLabel:SDAI.LOGICAL]
	}
	
	public typealias UniquenessRuleSignature = (_ entity: SDAI.EntityReference) -> AnyHashable?
	
	public struct UniquenessRuleValidationResult {
		public var uniquenessRule: SDAIDictionarySchema.UniquenessRule
		public var result: SDAI.LOGICAL
		public var record: (uniqueCount:Int, instanceCount:Int)
	}
	
	public struct WhereRuleValidationResult {
		public var result: SDAI.LOGICAL
		public var record: [SDAI.EntityReference:[SDAI.WhereLabel:SDAI.LOGICAL]]
	}
	
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
	
	//MARK: - SDAI.ObjectReference
	open class ObjectReference<OBJ: Object>: Hashable {
		internal let object: OBJ
		
		public init(object: OBJ) {
			self.object = object
		}

		public static func == (lhs: ObjectReference<OBJ>, rhs: ObjectReference<OBJ>) -> Bool {
			return lhs.object === rhs.object
		}
		
		public func hash(into hasher: inout Hasher) {
			object.hash(into: &hasher)
		}
		
	}
	
	public class UnownedReference<OBJ: Object>: Hashable {
		public unowned let object: OBJ
		
		public init(_ object: OBJ) {
			self.object = object
		}
		
		public static func == (lhs: UnownedReference<OBJ>, rhs: UnownedReference<OBJ>) -> Bool {
			return lhs.object === rhs.object
		}
		
		public func hash(into hasher: inout Hasher) {
			object.hash(into: &hasher)
		}
	
	}
}


