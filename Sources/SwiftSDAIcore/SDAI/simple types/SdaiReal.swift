//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation

//MARK: - REAL type
public protocol SDAIRealType: SDAINumberType 
{}

public protocol SDAI__REAL__type: SDAIRealType, SDAIDoubleRepresentedNumberType, ExpressibleByFloatLiteral
{
	init?(_ double: Double?)
	init(_ double: Double)
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
		public init?<S>(possiblyFrom select: S?) where S : SDAISelectType {
			guard let realValue = select?.realValue else { return nil }
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

