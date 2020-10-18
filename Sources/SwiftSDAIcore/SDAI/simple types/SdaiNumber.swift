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

public protocol SwiftDoubleConvertivle
{
	var asSwiftDouble: Double {get}
}

//MARK: - NUMBER type
public protocol SDAI__NUMBER__type: SDAISimpleType, ExpressibleByIntegerLiteral, SwiftDoubleConvertivle
where SwiftType: SdaiNumberRepType
{
	init?(_ double: Double?)
	init(_ double: Double)
	init?<T:SDAI__NUMBER__type>(_ subtype: T?)
	init<T:SDAI__NUMBER__type>(_ subtype: T)
}
public extension SDAI__NUMBER__type
{
	init?(_ double: Double?) {
		guard let double = double else { return nil }
		self.init(double)
	}
	init?<T:SDAI__NUMBER__type>(_ subtype: T?) {
		guard let subtype = subtype else { return nil }
		self.init(subtype)
	}
	init<T:SDAI__NUMBER__type>(_ subtype: T) {
		self.init(subtype.asSwiftDouble)
	}
}

extension SDAI {
	public struct NUMBER: SDAI__NUMBER__type, ExpressibleByFloatLiteral, SDAIValue
	{
		public typealias SwiftType = Double
		public typealias FundamentalType = Self
		private var rep: SwiftType

		// SDAIGenericType \SDAIUnderlyingType\SDAISimpleType\SDAI__NUMBER__type
		public static let typeName: String = "NUMBER"
		public var asSwiftType: SwiftType { return rep }
		public var asFundamentalType: FundamentalType { return self }
		public var typeMembers: Set<SDAI.STRING> {
			return [SDAI.STRING(Self.typeName)]
		}
		public init(_ fundamental: FundamentalType) {
			rep = fundamental.rep
		}
		
		// SDAISimpleType \SDAI__NUMBER__type
		public init(_ swiftValue: SwiftType) {
			rep = swiftValue
		}
		
		// ExpressibleByIntegerLiteral\SDAI__NUMBER__type
		public init(integerLiteral value: Int) {
			rep = SwiftType(value)
		}
		
		// SDAI__NUMBER__type
		public var asSwiftDouble: Double { return rep }
		
		// ExpressibleByFloatLiteral
		public init(floatLiteral value: Double) {
			rep = value
		}
		
		// SDAIValue
		public func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool 
		{
			if let rhs = rhs as? Self { return self == rhs }
			if let rhs = rhs as? SwiftDoubleConvertivle { return self.asSwiftDouble == rhs.asSwiftDouble }
			return false
		}
	}	
}


public protocol SDAI__NUMBER__subtype: SDAI__NUMBER__type, SDAIDefinedType, ExpressibleByFloatLiteral
where Supertype: SDAI__NUMBER__type & ExpressibleByFloatLiteral, 
			Supertype.FundamentalType == SDAI.NUMBER,
			Supertype.SwiftType == SDAI.NUMBER.SwiftType 
{
	init?<T:SDAI__NUMBER__type>(_ subtype: T?)
	init<T:SDAI__NUMBER__type>(_ subtype: T)
}
public extension SDAI__NUMBER__subtype
{
	init?<T:SDAI__NUMBER__type>(_ subtype: T?) {
		guard let subtype = subtype else { return nil}
		self.init(subtype)
	}
}
public extension SDAI__NUMBER__subtype
{
	// SDAISimpleType \SDAI__NUMBER__type\SDAI__NUMBER__subtype
	init(_ swiftValue: Supertype.SwiftType) {
		self.init(Supertype(swiftValue))
	}
	
	// ExpressibleByIntegerLiteral \SDAI__NUMBER__type\SDAI__NUMBER__subtype
	init(integerLiteral value: Supertype.IntegerLiteralType) {
		self.init(Supertype(integerLiteral: value))
	}
	
	// SDAI__NUMBER__type \SDAI__NUMBER__subtype
	var asSwiftDouble: Double { return rep.asSwiftDouble }
	
	// ExpressibleByFloatLiteral \SDAI__NUMBER__subtype
	init(floatLiteral value: Supertype.FloatLiteralType) {
		self.init(Supertype(floatLiteral: value))
	}
}



//MARK: - REAL type
public protocol SDAI__REAL__type: SDAI__NUMBER__type 
{}

extension SDAI {
	public struct REAL: SDAI__REAL__type, ExpressibleByFloatLiteral, SDAIValue
	{
		public typealias SwiftType = Double
		public typealias FundamentalType = Self
		private var rep: SwiftType
		
		// SDAIGenericType \SDAIUnderlyingType\SDAISimpleType\SDAI__NUMBER__type\SDAI__REAL__type
		public static let typeName: String = "REAL"
		public var asSwiftType: SwiftType { return rep }
		public var asFundamentalType: FundamentalType { return self }
		public var typeMembers: Set<SDAI.STRING> {
			return [SDAI.STRING(Self.typeName)]
		}
		public init(_ fundamental: FundamentalType) {
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
		
		// SDAI__NUMBER__type \SDAI__REAL__type
		public var asSwiftDouble: Double { return rep }
		
		// ExpressibleByFloatLiteral
		public init(floatLiteral value: Double) {
			rep = value
		}
		
		// SDAIValue
		public func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool 
		{
			if let rhs = rhs as? Self { return self == rhs }
			if let rhs = rhs as? SwiftDoubleConvertivle { return self.asSwiftDouble == rhs.asSwiftDouble }
			return false
		}
	}
}


public protocol SDAI__REAL__subtype: SDAI__REAL__type, SDAIDefinedType, ExpressibleByFloatLiteral
where Supertype: SDAI__REAL__type & ExpressibleByFloatLiteral,
			Supertype.FundamentalType == SDAI.REAL,
			Supertype.SwiftType == SDAI.REAL.SwiftType
{}
public extension SDAI__REAL__subtype
{
	init?<T:SDAI__REAL__type>(_ subtype: T?) {
		guard let subtype = subtype else { return nil }
		self.init(subtype)
	}
}
public extension SDAI__REAL__subtype
{
	// SDAISimpleType \SDAI__NUMBER__type\SDAI__REAL__type\SDAI__REAL__subtype
	init(_ swiftValue: Supertype.SwiftType) {
		self.init(Supertype(swiftValue))
	}
	
	// ExpressibleByIntegerLiteral \SDAI__NUMBER__type\SDAI__REAL__type\SDAI__REAL__subtype
	init(integerLiteral value: Supertype.IntegerLiteralType) {
		self.init(Supertype(integerLiteral: value))
	}
	
	// SDAI__NUMBER__type \SDAI__REAL__type\SDAI__REAL__subtype
	var asSwiftDouble: Double { return rep.asSwiftDouble }
	
	// ExpressibleByFloatLiteral \SDAI__REAL__subtype
	init(floatLiteral value: Supertype.FloatLiteralType) {
		self.init(Supertype(floatLiteral: value))
	}
}


//MARK: - INTEGER type
public protocol SDAI__INTEGER__type: SDAI__REAL__type 
where SwiftType == Int
{
	init?<T:SDAI__INTEGER__type>(_ subtype: T?)
	init<T:SDAI__INTEGER__type>(_ subtype: T)
}
public extension SDAI__INTEGER__type
{
	init?<T:SDAI__INTEGER__type>(_ subtype: T?) {
		guard let subtype = subtype else { return nil }
		self.init(subtype)
	}
	init<T:SDAI__INTEGER__type>(_ subtype: T) {
		self.init(subtype.asSwiftType)
	}
}

extension SDAI {
	public struct INTEGER: SDAI__INTEGER__type, SDAIValue
	{
		public typealias SwiftType = Int
		public typealias FundamentalType = Self
		private var rep: SwiftType

		// SDAIGenericType\SDAIUnderlyingType\SDAISimpleType\SDAI__NUMBER__type\SDAI__REAL__type\SDAI__INTEGER__type
		public static let typeName: String = "INTEGER"
		public var asSwiftType: SwiftType { return rep }
		public var asFundamentalType: FundamentalType { return self }
		public var typeMembers: Set<SDAI.STRING> {
			return [SDAI.STRING(Self.typeName)]
		}
		public init(_ fundamental: FundamentalType) {
			rep = fundamental.rep
		}
		
		// SDAISimpleType \SDAI__NUMBER__type\SDAI__REAL__type\SDAI__INTEGER__type
		public init(_ swiftValue: SwiftType) {
			rep = swiftValue
		}
		
		// ExpressibleByIntegerLiteral \SDAI__NUMBER__type\SDAI__REAL__type\SDAI__INTEGER__type
		public init(integerLiteral value: Int) {
			rep = value
		}
		
		// SDAI__NUMBER__type \SDAI__REAL__type\SDAI__INTEGER__type
		public var asSwiftDouble: Double { return Double(rep) }
		public init(_ double: Double) {
			rep = Int(double)
		}
		
		// SDAIValue
		public func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool 
		{
			if let rhs = rhs as? Self { return self == rhs }
			if let rhs = rhs as? SwiftDoubleConvertivle { return self.asSwiftDouble == rhs.asSwiftDouble }
			return false
		}
	}
}


public protocol SDAI__INTEGER__subtype: SDAI__INTEGER__type, SDAIDefinedType
where Supertype: SDAI__INTEGER__type,
			Supertype.FundamentalType == SDAI.INTEGER
{}
public extension SDAI__INTEGER__subtype
{
	// SDAISimpleType \SDAI__NUMBER__type\SDAI__REAL__type\SDAI__INTEGER__type
	init(_ swiftValue: Supertype.SwiftType) {
		self.init(Supertype(swiftValue))
	}
	
	// ExpressibleByIntegerLiteral \SDAI__NUMBER__type\SDAI__REAL__type\SDAI__INTEGER__type
	init(integerLiteral value: Supertype.IntegerLiteralType) {
		self.init(Supertype(integerLiteral: value))
	}
	
	// SDAI__NUMBER__type \SDAI__REAL__type\SDAI__INTEGER__type
	var asSwiftDouble: Double { return rep.asSwiftDouble }
	init(_ double:Double) {
		self.init(Supertype(double))
	}
}	
	

