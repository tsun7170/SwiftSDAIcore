//
//  File.swift
//  
//
//  Created by Yoshida on 2020/09/09.
//

import Foundation

public protocol SwiftBoolOptionalConvertible
{
	var asSwiftBoolOptional: Bool? {get}
}


//MARK: - LOGICAL type
public protocol SDAI__LOGICAL__type: SDAISimpleType, ExpressibleByBooleanLiteral, SwiftBoolOptionalConvertible
{
	var isTRUE: Bool {get}
	var isnotTRUE: Bool {get}
}
public extension SDAI__LOGICAL__type
{
	var isnotTRUE: Bool { return !self.isTRUE }
}

extension SDAI {
	public struct LOGICAL : SDAI__LOGICAL__type, ExpressibleByNilLiteral, SDAIValue
	{
		public typealias SwiftType = Bool?
		public typealias FundamentalType = Self
		private var rep: SwiftType
		
		// SDAIGenericType \SDAIUnderlyingType\SDAISimpleType\SDAI__LOGICAL__type
		public static let typeName: String = "LOGICAL"
		public var asSwiftType: SwiftType { return rep }
		public var asFundamentalType: FundamentalType { return self }
		public var typeMembers: Set<SDAI.STRING> {
			return [SDAI.STRING(Self.typeName)]
		}
		public init(_ fundamental: FundamentalType) {
			rep = fundamental.rep
		}

		// SDAISimpleType \SDAI__LOGICAL__type
		public init(_ swiftValue: SwiftType) {
			rep = swiftValue
		}
		
		// ExpressibleByBooleanLiteral \SDAI__LOGICAL__type
		public init(booleanLiteral value: Bool) {
			rep = value
		}
		
		// SDAI__LOGICAL__type
		public var asSwiftBoolOptional: Bool? {
			return rep
		}
		public var isTRUE: Bool {
			return rep ?? false
		}

		// ExpressibleByNilLiteral
		public init(nilLiteral: ()) {
			rep = nil
		}
		
		// SDAIValue
		public func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool 
		{
			if let rhs = rhs as? Self { return self == rhs }
			if let rhs = rhs as? SwiftBoolOptionalConvertible { return self.asSwiftBoolOptional == rhs.asSwiftBoolOptional }
			return false
		}
		
		// LOGICAL specific
		public init<T:SDAI__LOGICAL__type>(_ subtype: T) {
			self.init(subtype.asSwiftBoolOptional)
		}
	}
}


public protocol SDAI__LOGICAL__subtype: SDAI__LOGICAL__type, SDAIDefinedType, ExpressibleByNilLiteral
where Supertype: SDAI__LOGICAL__type & ExpressibleByNilLiteral,
			Supertype.FundamentalType == SDAI.LOGICAL,
			Supertype.SwiftType == SDAI.LOGICAL.SwiftType
{
	init?<T:SDAI__LOGICAL__type>(_ subtype: T?)
	init<T:SDAI__LOGICAL__type>(_ subtype: T)
}
public extension SDAI__LOGICAL__subtype
{
	init?<T:SDAI__LOGICAL__type>(_ subtype: T?) {
		guard let subtype = subtype else { return nil }
		self.init(subtype)
	}
}
public extension SDAI__LOGICAL__subtype
{
	// SDAISimpleType \SDAI__LOGICAL__type\SDAI__LOGICAL__subtype
	init(_ swiftValue: Supertype.SwiftType) {
		self.init(Supertype(swiftValue))
	}
	
	// ExpressibleByBooleanLiteral \SDAI__LOGICAL__type\SDAI__LOGICAL__subtype
	init(booleanLiteral value: Supertype.BooleanLiteralType) {
		self.init(Supertype(booleanLiteral: value))
	}

	// SDAI__LOGICAL__type \SDAI__LOGICAL__subtype
	var asSwiftBoolOptional: Bool? {
		return rep.asSwiftBoolOptional
	}
	var isTRUE: Bool {
		return rep.isTRUE
	}
	
	// ExpressibleByNilLiteral \SDAI__LOGICAL__subtype
	init(nilLiteral: ()) {
		self.init(Supertype(nilLiteral: ()))
	}
	
	// SDAI__LOGICAL__subtype
	init<T:SDAI__LOGICAL__type>(_ subtype: T) {
		self.init(Supertype(subtype.asSwiftBoolOptional))
	}
}


//MARK: - BOOLEAN type
public protocol SDAI__BOOLEAN__type: SDAI__LOGICAL__type 
where SwiftType == Bool
{
	init?<T:SDAI__BOOLEAN__type>(_ subtype: T?)	
	init<T:SDAI__BOOLEAN__type>(_ subtype: T)	
}
public extension SDAI__BOOLEAN__type
{
	init?<T:SDAI__BOOLEAN__type>(_ subtype: T?)	{
		guard let subtype = subtype else { return nil }
		self.init(subtype)
	}
	init<T:SDAI__BOOLEAN__type>(_ subtype: T) {
		self.init(subtype.asSwiftType)
	}
}

extension SDAI {
	public struct BOOLEAN : SDAI__BOOLEAN__type, SDAIValue
	{		
		public typealias SwiftType = Bool
		public typealias FundamentalType = Self
		private var rep: SwiftType
		
		// SDAIGenericType \SDAIUnderlyingType\SDAISimpleType\SDAI__LOGICAL__type\SDAI__BOOLEAN__type
		public static let typeName: String = "BOOLEAN"
		public var asSwiftType: SwiftType { return rep }
		public var asFundamentalType: FundamentalType { return self }
		public var typeMembers: Set<SDAI.STRING> {
			return [SDAI.STRING(Self.typeName)]
		}
		public init(_ fundamental: FundamentalType) {
			rep = fundamental.rep
		}

		// SDAISimpleType \SDAI__LOGICAL__type\SDAI__BOOLEAN__type
		public init(_ swiftValue: SwiftType) {
			rep = swiftValue
		}
		
		// ExpressibleByBooleanLiteral \SDAI__LOGICAL__type\SDAI__BOOLEAN__type
		public init(booleanLiteral value: Bool) {
			rep = value
		}
		
		// SDAI__LOGICAL__type \SDAI__BOOLEAN__type
		public var asSwiftBoolOptional: Bool? {
			return rep
		}
		public var isTRUE: Bool {
			return rep
		}
		
		// SDAIValue
		public func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool 
		{
			if let rhs = rhs as? Self { return self == rhs }
			if let rhs = rhs as? SwiftBoolOptionalConvertible { return self.asSwiftBoolOptional == rhs.asSwiftBoolOptional }
			return false
		}
	}
}


public protocol SDAI__BOOLEAN__subtype: SDAI__BOOLEAN__type, SDAIDefinedType
where Supertype: SDAI__BOOLEAN__type,
			Supertype.FundamentalType == SDAI.BOOLEAN
{}
public extension SDAI__BOOLEAN__subtype
{
	// SDAISimpleType \SDAI__LOGICAL__type\SDAI__BOOLEAN__type\SDAI__BOOLEAN__subtype
	init(_ swiftValue: Supertype.SwiftType) {
		self.init(Supertype(swiftValue))
	}
	
	// ExpressibleByBooleanLiteral \SDAI__LOGICAL__type\SDAI__BOOLEAN__type\SDAI__BOOLEAN__subtype
	init(booleanLiteral value:Supertype.BooleanLiteralType) {
		self.init(Supertype(booleanLiteral: value))
	}

	// SDAI__LOGICAL__type \SDAI__BOOLEAN__type\SDAI__BOOLEAN__subtype
	var asSwiftBoolOptional: Bool? { return rep.asSwiftBoolOptional }
	var isTRUE: Bool { return rep.isTRUE }
}
