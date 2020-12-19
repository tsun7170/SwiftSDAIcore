//
//  SdaiNumber.swift
//  
//
//  Created by Yoshida on 2020/09/09.
//

import Foundation

public protocol SdaiNumberRepType : SignedNumeric, Comparable
{}
extension Double: SdaiNumberRepType {}
extension Int: SdaiNumberRepType {}

public protocol SwiftDoubleConvertible
{
	var asSwiftDouble: Double {get}
}

//MARK: - NUMBER type
public protocol SDAINumberType: SDAISimpleType, ExpressibleByIntegerLiteral, SwiftDoubleConvertible
where SwiftType: SdaiNumberRepType
{
	var asSwiftDouble: Double {get}
}

public protocol SDAIDoubleRepresentedNumberType: SDAINumberType where SwiftType == Double
{}

public protocol SDAIIntRepresentedNumberType: SDAINumberType where SwiftType == Int
{}

public protocol SDAI__NUMBER__type: SDAIDoubleRepresentedNumberType, ExpressibleByFloatLiteral
{
	init?(_ double: Double?)
	init(_ double: Double)
	init?<T:SDAINumberType>(_ subtype: T?)
	init<T:SDAINumberType>(_ subtype: T)
}
public extension SDAI__NUMBER__type
{
	var asSwiftDouble: Double { return self.asSwiftType }

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

