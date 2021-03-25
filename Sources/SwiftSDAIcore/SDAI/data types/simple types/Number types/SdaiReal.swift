//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation

//MARK: - REAL type (8.1.2)
public protocol SDAIRealType: SDAINumberType 
{}

public protocol SDAI__REAL__type: SDAIRealType, SDAIDoubleRepresentedNumberType, ExpressibleByFloatLiteral
where FundamentalType == SDAI.REAL,
			Value == FundamentalType.Value
{
	init?(_ double: Double?)
	init(_ double: Double)
	init?(_ int: Int?)
	init(_ int: Int)
	init?<T:SDAIRealType>(_ subtype: T?)
	init<T:SDAIRealType>(_ subtype: T)
}
public extension SDAI__REAL__type
{
	var asSwiftDouble: Double { return self.asSwiftType }

	init?(_ double: Double?) {
		guard let double = double else { return nil }
		self.init(double)
	}
	init?(_ int: Int?) {
		guard let int = int else { return nil }
		self.init(int)
	}
	init(_ int: Int) {
		self.init(Double(int))
	}
	init(integerLiteral value: Int) {
		self.init(SwiftType(value))
	}
	init(floatLiteral value: Double) {
		self.init(value)
	}
	init?<T:SDAIRealType>(_ subtype: T?) {
		guard let subtype = subtype else { return nil }
		self.init(subtype)
	}
	init<T:SDAIRealType>(_ subtype: T) {
		self.init(subtype.asSwiftDouble)
	}
}

extension SDAI {
	public struct REAL: SDAI__REAL__type, SDAIValue
	{
		public typealias SwiftType = Double
		public typealias FundamentalType = Self
		private var rep: SwiftType
		
		// SDAIGenericType \SDAIUnderlyingType\SDAISimpleType\SDAI__NUMBER__type\SDAI__REAL__type
		public var typeMembers: Set<SDAI.STRING> {
			return [SDAI.STRING(Self.typeName)]
		}
		public var value: FundamentalType { return self.asFundamentalType }
		
		public var entityReference: SDAI.EntityReference? {nil}	
		public var stringValue: SDAI.STRING? {nil}
		public var binaryValue: SDAI.BINARY? {nil}
		public var logicalValue: SDAI.LOGICAL? {nil}
		public var booleanValue: SDAI.BOOLEAN? {nil}
		public var numberValue: SDAI.NUMBER? { NUMBER(self) }
		public var realValue: SDAI.REAL? { self }
		public var integerValue: SDAI.INTEGER? {nil}
		public var genericEnumValue: SDAI.GenericEnumValue? {nil}
		
		public func arrayOptionalValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY_OPTIONAL<ELEM>? {nil}
		public func arrayValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>? {nil}
		public func listValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.LIST<ELEM>? {nil}
		public func bagValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.BAG<ELEM>? {nil}
		public func setValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.SET<ELEM>? {nil}
		public func enumValue<ENUM:SDAIEnumerationType>(enumType:ENUM.Type) -> ENUM? {nil}

		
		// InitializableByGenerictype
		public init?<G: SDAIGenericType>(fromGeneric generic: G?) {
			guard let realValue = generic?.realValue else { return nil }
			self.init(realValue)
		}
		
		// SDAIUnderlyingType \SDAISimpleType\SDAI__NUMBER__type\SDAI__REAL__type
		public static let typeName: String = "REAL"
		public var asSwiftType: SwiftType { return rep }
		public var asFundamentalType: FundamentalType { return self }
		public init(fundamental: FundamentalType) {
			rep = fundamental.rep
		}

		// SDAISimpleType \SDAI__NUMBER__type\SDAI__REAL__type
		public init(_ swiftValue: SwiftType) {
			rep = swiftValue
		}
		
		// ExpressibleByIntegerLiteral \SDAI__NUMBER__type\SDAI__REAL__type
		public init(integerLiteral value: Int) {
			rep = SwiftType(value)
		}
		
		// SDAIValue
		public func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool 
		{
			if let rhs = rhs as? Self { return self == rhs }
			if let rhs = rhs as? SwiftDoubleConvertible { return self.asSwiftDouble == rhs.asSwiftDouble }
			return false
		}

	}
}

