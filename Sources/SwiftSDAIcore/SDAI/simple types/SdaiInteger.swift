//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation


//MARK: - INTEGER type
public protocol SDAIIntegerType: SDAIRealType, SwiftIntConvertible
{}

public protocol SDAI__INTEGER__type: SDAIIntegerType, SDAIIntRepresentedNumberType
where FundamentalType == SDAI.INTEGER,
			Value == FundamentalType.Value
//			SwiftType == FundamentalType.SwiftType
{
	init?(_ int: Int?)
	init(_ int: Int)
	init?<T:SDAIIntegerType>(_ subtype: T?)
	init<T:SDAIIntegerType>(_ subtype: T)
}
public extension SDAI__INTEGER__type
{
	var asSwiftInt: Int { return self.asSwiftType }
	var asSwiftDouble: Double { return Double(self.asSwiftType) }

	init?(_ int: Int?) {
		guard let int = int else { return nil }
		self.init(int)
	}
	init(integerLiteral value: Int) {
		self.init(value)
	}
	init?<T:SDAIIntegerType>(_ subtype: T?) {
		guard let subtype = subtype else { return nil }
		self.init(subtype)
	}
	init<T:SDAIIntegerType>(_ subtype: T) {
		self.init(subtype.asSwiftInt)
	}
}

extension SDAI {
	public struct INTEGER: SDAI__INTEGER__type, SDAIValue
	{
		public typealias SwiftType = Int
		public typealias FundamentalType = Self
		private var rep: SwiftType

		// SDAIGenericType \SDAIUnderlyingType\SDAISimpleType\SDAI__NUMBER__type\SDAI__REAL__type\SDAI__INTEGER__type
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
		public var realValue: SDAI.REAL? { REAL(self) }
		public var integerValue: SDAI.INTEGER? { self }
		public func arrayOptionalValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY_OPTIONAL<ELEM>? {nil}
		public func arrayValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>? {nil}
		public func listValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.LIST<ELEM>? {nil}
		public func bagValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.BAG<ELEM>? {nil}
		public func setValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.SET<ELEM>? {nil}
		public func enumValue<ENUM:SDAIEnumerationType>(enumType:ENUM.Type) -> ENUM? {nil}

		
//		public init?<S>(possiblyFrom select: S?) where S : SDAISelectType {
//			self.init(fromGeneric: select)
////			guard let integerValue = select?.integerValue else { return nil }
////			self.init(integerValue)
//		}
		// InitializableByGenerictype
		public init?<G: SDAIGenericType>(fromGeneric generic: G?) {
			guard let integerValue = generic?.integerValue else { return nil }
			self.init(integerValue)
		}
		
		// SDAIUnderlyingType \SDAISimpleType\SDAI__NUMBER__type\SDAI__REAL__type\SDAI__INTEGER__type
		public static let typeName: String = "INTEGER"
		public var asSwiftType: SwiftType { return rep }
		public var asFundamentalType: FundamentalType { return self }
		public init(fundamental: FundamentalType) {
			self.init(fundamental.rep)
		}

		// SDAISimpleType \SDAI__NUMBER__type\SDAI__REAL__type\SDAI__INTEGER__type
		public init(_ swiftValue: SwiftType) {
			rep = swiftValue
		}
		
		// SDAIValue
		public func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool 
		{
			if let rhs = rhs as? Self { return self == rhs }
			if let rhs = rhs as? SwiftIntConvertible { return self.asSwiftInt == rhs.asSwiftInt }
			return false
		}
	}
}


