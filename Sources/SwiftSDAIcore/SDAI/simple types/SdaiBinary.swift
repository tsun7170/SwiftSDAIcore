//
//  SdaiBinary.swift
//  
//
//  Created by Yoshida on 2020/09/11.
//

import Foundation


public protocol SDAI__BINARY__type: SDAISimpleType, ExpressibleByStringLiteral
where SwiftType == String
{
	init?<T:SDAI__BINARY__type>(_ subtype: T?)
	init<T:SDAI__BINARY__type>(_ subtype: T)
}
public extension SDAI__BINARY__type
{
	init?<T:SDAI__BINARY__type>(_ subtype: T?) {
		guard let subtype = subtype else { return nil }	
		self.init(subtype)
	}
	init<T:SDAI__BINARY__type>(_ subtype: T) {
		self.init(subtype.asSwiftType)
	}
}

extension SDAI {
	public struct BINARY: SDAI__BINARY__type, SDAIValue 
	{
		public typealias SwiftType = String
		public typealias FundamentalType = Self
		private var rep: SwiftType

		// SDAIGenericType \SDAIUnderlyingType\SDAISimpleType\SDAI__BINARY__type
		public static let typeName: String = "BINARY"
		public var asSwiftType: SwiftType { return rep }
		public var asFundamentalType: FundamentalType { return self }
		public var typeMembers: Set<SDAI.STRING> {
			return [SDAI.STRING(Self.typeName)]
		}
		public init(_ fundamental: FundamentalType) {
			rep = fundamental.rep
		}
		
		// SDAISimpleType \SDAI__BINARY__type
		public init(_ swiftValue: SwiftType) {
			assert(Self.isValidValue(value: swiftValue))
			rep = swiftValue
		}
		
		// ExpressibleByStringLiteral \SDAI__BINARY__type
		public init(stringLiteral value: String) {
			assert(Self.isValidValue(value: value))
			rep = value
		}

		// BINARY specific
		private static func isValidValue(value: String) -> Bool {
			for c in value {
				if c != "0" && c != "1" { return false }
			}
			return true
		}
		
		// SDAIValue
		public func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool 
		{
			if let rhs = rhs as? Self { return self == rhs }
			return false
		}
	}
}


public protocol SDAI__BINARY__subtype: SDAI__BINARY__type, SDAIDefinedType
where Supertype: SDAI__BINARY__type,
			Supertype.FundamentalType == SDAI.BINARY
{}
public extension SDAI__BINARY__subtype
{
	// SDAISimpleType \SDAI__BINARY__type\SDAI__BINARY__subtype
	init(_ swiftValue: Supertype.SwiftType) {
		self.init(Supertype(swiftValue))
	}
	
	// ExpressibleByStringLiteral \SDAI__BINARY__type\SDAI__BINARY__subtype
	init(stringLiteral value: Supertype.StringLiteralType) {
		self.init(Supertype(stringLiteral: value))
	}
}
