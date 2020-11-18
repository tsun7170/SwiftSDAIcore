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
public protocol SDAILogicalType: SDAISimpleType, ExpressibleByBooleanLiteral, SwiftBoolOptionalConvertible
{
	var isTRUE: Bool {get}
	var isnotTRUE: Bool {get}
	var asSwiftBoolOptional: Bool? {get}
}
public extension SDAILogicalType
{
	var isnotTRUE: Bool { return !self.isTRUE }
}

public protocol SDAI__LOGICAL__type: SDAILogicalType, ExpressibleByNilLiteral where SwiftType == Bool?
{
	init(_ bool: Bool?)
	init<T:SDAILogicalType>(_ subtype: T?)
	init<T:SDAILogicalType>(_ subtype: T)
}
public extension SDAI__LOGICAL__type
{
	var asSwiftBoolOptional: Bool? { return self.asSwiftType }
	var isTRUE: Bool { return self.asSwiftType ?? false }

	init(booleanLiteral value: Bool) {
		self.init(value)
	}
	init(nilLiteral: ()) {
		self.init(nil)
	}
	init<T:SDAILogicalType>(_ subtype: T?) {
		self.init(subtype?.asSwiftBoolOptional)
	}
	init<T:SDAILogicalType>(_ subtype: T) {
		self.init(subtype.asSwiftBoolOptional)
	}
}

extension SDAI {
	public struct LOGICAL : SDAI__LOGICAL__type, SDAIValue
	{
		
		public typealias SwiftType = Bool?
		public typealias FundamentalType = Self
		private var rep: SwiftType
		
		// SDAIGenericType \SDAIUnderlyingType\SDAISimpleType\SDAI__LOGICAL__type
		public var typeMembers: Set<SDAI.STRING> {
			return [SDAI.STRING(Self.typeName)]
		}
		public init?<S>(possiblyFrom select: S) where S : SDAISelectType {
			guard let logicalValue = select.logicalValue else { return nil }
			self.init(logicalValue)
		}

		// SDAIUnderlyingType \SDAISimpleType\SDAI__LOGICAL__type
		public static let typeName: String = "LOGICAL"
		public var asSwiftType: SwiftType { return rep }
		public var asFundamentalType: FundamentalType { return self }
		public init(_ fundamental: FundamentalType) {
			self.init(fundamental.rep)
		}

		// SDAISimpleType \SDAI__LOGICAL__type
		public init(_ swiftValue: SwiftType) {
			rep = swiftValue
		}
		
//		// ExpressibleByBooleanLiteral \SDAI__LOGICAL__type
//		public init(booleanLiteral value: Bool) {
//			self.init(value)
//		}
		
//		// SDAI__LOGICAL__type
//		public var asSwiftBoolOptional: Bool? {
//			return rep
//		}
//		public var isTRUE: Bool {
//			return rep ?? false
//		}

//		// ExpressibleByNilLiteral
//		public init(nilLiteral: ()) {
//			self.init(nil)
//		}
		
		// SDAIValue
		public func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool 
		{
			if let rhs = rhs as? Self { return self == rhs }
			if let rhs = rhs as? SwiftBoolOptionalConvertible { return self.asSwiftBoolOptional == rhs.asSwiftBoolOptional }
			return false
		}
		
//		// LOGICAL specific
//		public init<T:SDAI__LOGICAL__type>(_ subtype: T) {
//			self.init(subtype.asSwiftBoolOptional)
//		}
	}
}


public protocol SDAI__LOGICAL__subtype: SDAI__LOGICAL__type, SDAIDefinedType//, ExpressibleByNilLiteral
where Supertype: SDAI__LOGICAL__type,
			Supertype.FundamentalType == SDAI.LOGICAL
//			Supertype.SwiftType == SDAI.LOGICAL.SwiftType
{
//	init?<T:SDAI__LOGICAL__type>(_ subtype: T?)
//	init<T:SDAI__LOGICAL__type>(_ subtype: T)
}
//public extension SDAI__LOGICAL__subtype
//{
//	init?<T:SDAI__LOGICAL__type>(_ subtype: T?) {
//		guard let subtype = subtype else { return nil }
//		self.init(subtype)
//	}
//}
public extension SDAI__LOGICAL__subtype
{
	// SDAIGenericType
	init?<S: SDAISelectType>(possiblyFrom select: S) {
		guard let supertype = Supertype(possiblyFrom: select) else { return nil }
		self.init(supertype)
	}
	
	// SDAISimpleType \SDAI__LOGICAL__type\SDAI__LOGICAL__subtype
	init(_ swiftValue: Supertype.SwiftType) {
		self.init(Supertype(swiftValue))
	}
	
//	// ExpressibleByBooleanLiteral \SDAI__LOGICAL__type\SDAI__LOGICAL__subtype
//	init(booleanLiteral value: Supertype.BooleanLiteralType) {
//		self.init(Supertype(booleanLiteral: value))
//	}

//	// SDAI__LOGICAL__type \SDAI__LOGICAL__subtype
//	var asSwiftBoolOptional: Bool? {
//		return rep.asSwiftBoolOptional
//	}
//	var isTRUE: Bool {
//		return rep.isTRUE
//	}
	
//	// ExpressibleByNilLiteral \SDAI__LOGICAL__subtype
//	init(nilLiteral: ()) {
//		self.init(Supertype(nilLiteral: ()))
//	}
	
//	// SDAI__LOGICAL__subtype
//	init<T:SDAI__LOGICAL__type>(_ subtype: T) {
//		self.init(Supertype(subtype.asSwiftBoolOptional))
//	}
}


//MARK: - BOOLEAN type
public protocol SDAIBooleanType: SDAILogicalType
{}

public protocol SDAI__BOOLEAN__type: SDAIBooleanType 
where SwiftType == Bool
{
	init?(_ bool: Bool?)
	init(_ bool: Bool)
	init?<T:SDAI__BOOLEAN__type>(_ subtype: T?)	
	init<T:SDAI__BOOLEAN__type>(_ subtype: T)	
}
public extension SDAI__BOOLEAN__type
{
	var asSwiftBoolOptional: Bool? { return self.asSwiftType }
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
		public init?<S>(possiblyFrom select: S) where S : SDAISelectType {
			guard let booleanValue = select.booleanValue else { return nil }
			self.init(booleanValue)
		}

		// SDAIUnderlyingType \SDAISimpleType\SDAI__LOGICAL__type\SDAI__BOOLEAN__type
		public static let typeName: String = "BOOLEAN"
		public var asSwiftType: SwiftType { return rep }
		public var asFundamentalType: FundamentalType { return self }
		public init(_ fundamental: FundamentalType) {
			self.init(fundamental.rep)
		}

		// SDAISimpleType \SDAI__LOGICAL__type\SDAI__BOOLEAN__type
		public init(_ swiftValue: SwiftType) {
			rep = swiftValue
		}
		
//		// ExpressibleByBooleanLiteral \SDAI__LOGICAL__type\SDAI__BOOLEAN__type
//		public init(booleanLiteral value: Bool) {
//			self.init(value)
//		}
		
//		// SDAI__LOGICAL__type \SDAI__BOOLEAN__type
//		public var asSwiftBoolOptional: Bool? {
//			return rep
//		}
//		public var isTRUE: Bool {
//			return rep
//		}
		
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
	// SDAIGenericType
	init?<S: SDAISelectType>(possiblyFrom select: S) {
		guard let supertype = Supertype(possiblyFrom: select) else { return nil }
		self.init(supertype)
	}
	
	// SDAISimpleType \SDAI__LOGICAL__type\SDAI__BOOLEAN__type\SDAI__BOOLEAN__subtype
	init(_ swiftValue: Supertype.SwiftType) {
		self.init(Supertype(swiftValue))
	}
	
//	// ExpressibleByBooleanLiteral \SDAI__LOGICAL__type\SDAI__BOOLEAN__type\SDAI__BOOLEAN__subtype
//	init(booleanLiteral value:Supertype.BooleanLiteralType) {
//		self.init(Supertype(booleanLiteral: value))
//	}

//	// SDAI__LOGICAL__type \SDAI__BOOLEAN__type\SDAI__BOOLEAN__subtype
//	var asSwiftBoolOptional: Bool? { return rep.asSwiftBoolOptional }
//	var isTRUE: Bool { return rep.isTRUE }
}
