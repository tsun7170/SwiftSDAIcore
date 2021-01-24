//
//  SdaiNumber.swift
//  
//
//  Created by Yoshida on 2020/09/09.
//

import Foundation

public protocol SdaiNumberRepType : SignedNumeric, Strideable
{}
extension Double: SdaiNumberRepType {}
extension Int: SdaiNumberRepType {}

public protocol SDAIDoubleRepresented
{
	var asSwiftDouble: Double {get}
}

public protocol SDAIIntRepresented
{
	var asSwiftInt: Int {get}
}

//MARK: - Double convertible
public protocol SwiftDoubleConvertible
{
	var asSwiftDouble: Double {get}
}

extension Double: SwiftDoubleConvertible, SDAIDoubleRepresented
{
	public var asSwiftDouble: Double { return self }
}

extension Int: SwiftDoubleConvertible
{
	public var asSwiftDouble: Double { return Double(self) }
}

public extension SwiftDoubleConvertible
where Self: SDAIDoubleRepresentedNumberType
{
	var asSwiftDouble: Double { return self.asSwiftType }
}

public extension SwiftDoubleConvertible
where Self: SDAIIntRepresentedNumberType
{
	var asSwiftDouble: Double { return Double(self.asSwiftType) }
}


//MARK: - Int convertible
public protocol SwiftIntConvertible
{
	var asSwiftInt: Int {get}
}

extension Int: SwiftIntConvertible, SDAIIntRepresented
{
	public var asSwiftInt: Int { return self }
}

public extension SwiftIntConvertible
where Self: SDAIIntRepresentedNumberType
{
	var asSwiftInt: Int { return self.asSwiftType }
}


//MARK: - NUMBER type
public protocol SDAINumberType: SDAISimpleType, ExpressibleByIntegerLiteral, SwiftDoubleConvertible
where SwiftType: SdaiNumberRepType
{
//	var asSwiftDouble: Double {get}
}

public protocol SDAIDoubleRepresentedNumberType: SDAINumberType, SDAIDoubleRepresented 
where SwiftType == Double
{}

public protocol SDAIIntRepresentedNumberType: SDAINumberType, SDAIIntRepresented 
where SwiftType == Int
{}

public protocol SDAI__NUMBER__type: SDAIDoubleRepresentedNumberType, ExpressibleByFloatLiteral
where FundamentalType == SDAI.NUMBER,
			Value == FundamentalType.Value
//			SwiftType == FundamentalType.SwiftType
{
	init?(_ double: Double?)
	init(_ double: Double)
	init?<T:SDAINumberType>(_ subtype: T?)
	init<T:SDAINumberType>(_ subtype: T)
}
public extension SDAI__NUMBER__type
{
//	var asSwiftDouble: Double { return self.asSwiftType }

	init?(_ double: Double?) {
		guard let double = double else { return nil }
		self.init(double)
	}
	init(integerLiteral value: Int) {
		self.init(SwiftType(value))
	}
	init(floatLiteral value: Double) {
		self.init(value)
	}
	init?<T:SDAINumberType>(_ subtype: T?) {
		guard let subtype = subtype else { return nil }
		self.init(subtype)
	}
	init<T:SDAINumberType>(_ subtype: T) {
		self.init(subtype.asSwiftDouble)
	}
}

extension SDAI {
	public struct NUMBER: SDAI__NUMBER__type, SDAIValue
	{
		public typealias SwiftType = Double
		public typealias FundamentalType = Self
		private var rep: SwiftType

		// SDAIGenericType \SDAIUnderlyingType\SDAISimpleType\SDAI__NUMBER__type
		public var typeMembers: Set<SDAI.STRING> {
			return [SDAI.STRING(Self.typeName)]
		}
		public var value: FundamentalType { return self.asFundamentalType }
		public init?<S>(possiblyFrom select: S?) where S : SDAISelectType {
			guard let numberValue = select?.numberValue else { return nil }
			self.init(numberValue)
		}
		
		// SDAIUnderlyingType \SDAISimpleType\SDAI__NUMBER__type
		public static let typeName: String = "NUMBER"
		public var asSwiftType: SwiftType { return rep }
		public var asFundamentalType: FundamentalType { return self }
		public init(fundamental: FundamentalType) {
			self.init(fundamental.rep)
		}


		// SDAISimpleType \SDAI__NUMBER__type
		public init(_ swiftValue: SwiftType) {
			rep = swiftValue
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

