//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation


//MARK: - BOOLEAN type (8.1.5)
public protocol SDAIBooleanType: SDAILogicalType
{}

public protocol SDAI__BOOLEAN__type: SDAIBooleanType 
where FundamentalType == SDAI.BOOLEAN,
			Value == FundamentalType.Value,
			SwiftType == FundamentalType.SwiftType
{
	init?(_ bool: Bool?)
	init(_ bool: Bool)
	init?<T:SDAI__BOOLEAN__type>(_ subtype: T?)	
	init<T:SDAI__BOOLEAN__type>(_ subtype: T)	
	init?<T:SDAI__LOGICAL__type>(_ logical: T?)
	init<T:SDAI__LOGICAL__type>(_ logical: T)
}
public extension SDAI__BOOLEAN__type
{
	var possiblyAsSwiftBool: Bool? { return self.asSwiftType }
	var asSwiftBool: Bool { return self.asSwiftType }
	var isTRUE: Bool { return self.asSwiftType }

	init?(_ bool: Bool?) {
		guard let bool = bool else { return nil }
		self.init(bool)
	}
	init(booleanLiteral value: Bool) {
		self.init(value)
	}
	init?<T:SDAI__BOOLEAN__type>(_ subtype: T?)	{
		guard let subtype = subtype else { return nil }
		self.init(subtype)
	}
	init<T:SDAI__BOOLEAN__type>(_ subtype: T) {
		self.init(subtype.asSwiftType)
	}
	init?<T:SDAI__LOGICAL__type>(_ logical: T?) {
		guard let bool = logical?.asSwiftType else { return nil }
		self.init(bool)
	}
	init<T:SDAI__LOGICAL__type>(_ logical: T) {
		self.init( SDAI.UNWRAP(logical.asSwiftType) )
	}
}

extension SDAI {
	public struct BOOLEAN : SDAI__BOOLEAN__type, SDAIValue
	{
		public typealias SwiftType = Bool
		public typealias FundamentalType = Self
		private var rep: SwiftType
		
		// SDAIGenericType \SDAIUnderlyingType\SDAISimpleType\SDAI__LOGICAL__type\SDAI__BOOLEAN__type
		public var typeMembers: Set<SDAI.STRING> {
			return [SDAI.STRING(Self.typeName)]
		}
		public var value: FundamentalType { return self.asFundamentalType }
		
		public var entityReference: SDAI.EntityReference? {nil}	
		public var stringValue: SDAI.STRING? {nil}
		public var binaryValue: SDAI.BINARY? {nil}
		public var logicalValue: SDAI.LOGICAL? { LOGICAL(self) }
		public var booleanValue: SDAI.BOOLEAN? { self }
		public var numberValue: SDAI.NUMBER? {nil}
		public var realValue: SDAI.REAL? {nil}
		public var integerValue: SDAI.INTEGER? {nil}
		public var genericEnumValue: SDAI.GenericEnumValue? {nil}
		
		public func arrayOptionalValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY_OPTIONAL<ELEM>? {nil}
		public func arrayValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>? {nil}
		public func listValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.LIST<ELEM>? {nil}
		public func bagValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.BAG<ELEM>? {nil}
		public func setValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.SET<ELEM>? {nil}
		public func enumValue<ENUM:SDAIEnumerationType>(enumType:ENUM.Type) -> ENUM? {nil}

		public static func validateWhereRules(instance:Self?, prefix:SDAI.WhereLabel, excludingEntity: Bool) -> [SDAI.WhereLabel:SDAI.LOGICAL] { return [:] }

		
		// InitializableByGenerictype
		public init?<G: SDAIGenericType>(fromGeneric generic: G?) {
			guard let booleanValue = generic?.booleanValue else { return nil }
			self.init(booleanValue)
		}

		// SDAIUnderlyingType \SDAISimpleType\SDAI__LOGICAL__type\SDAI__BOOLEAN__type
		public static let typeName: String = "BOOLEAN"
		public var asSwiftType: SwiftType { return rep }
		public var asFundamentalType: FundamentalType { return self }
		public init(fundamental: FundamentalType) {
			self.init(fundamental.rep)
		}

		// SDAISimpleType \SDAI__LOGICAL__type\SDAI__BOOLEAN__type
		public init(_ swiftValue: SwiftType) {
			rep = swiftValue
		}
		
		// SDAIValue
		public func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool 
		{
			if let rhs = rhs as? Self { return self == rhs }
			if let rhs = rhs as? SwiftBoolConvertible { return self.possiblyAsSwiftBool == rhs.possiblyAsSwiftBool }
			return false
		}

	}
}

