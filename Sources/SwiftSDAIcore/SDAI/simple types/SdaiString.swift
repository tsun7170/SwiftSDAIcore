//
//  File.swift
//  
//
//  Created by Yoshida on 2020/09/13.
//

import Foundation


public protocol SDAI__STRING__type: SDAISimpleType, ExpressibleByStringLiteral
where SwiftType == String
{
	var length: Int {get}
	init?<T:SDAI__STRING__type>(_ subtype: T?)
	init<T:SDAI__STRING__type>(_ subtype: T)
}
public extension SDAI__STRING__type
{
	init?<T:SDAI__STRING__type>(_ subtype: T?) {
		guard let subtype = subtype else { return nil }
		self.init(subtype)
	}
	init<T:SDAI__STRING__type>(_ subtype:T) {
		self.init(subtype.asSwiftType)
	}
}

extension SDAI {
	public struct STRING: SDAI__STRING__type, SDAIValue
	{
		public typealias SwiftType = String
		public typealias FundamentalType = Self
		private var rep: SwiftType

		// SDAIGenericType \SDAIUnderlyingType\SDAISimpleType\SDAI__STRING__type
		public static let typeName: String = "STRING"
		public var asSwiftType: SwiftType { return rep }
		public var asFundamentalType: FundamentalType { return self }
		public var typeMembers: Set<SDAI.STRING> {
			return [SDAI.STRING(Self.typeName)]
		}
		public init(_ fundamental: FundamentalType) {
			rep = fundamental.rep
		}
		
//		// SDAIUnderlyingType\SDAISimpleType\SDAI__STRING__type
//		public init() {
//			rep = SwiftType()
//		}
//	public init(_ selfValue: Self)

		// SDAISimpleType \SDAI__STRING__type
		public init(_ swiftValue: SwiftType) {
			rep = swiftValue
		}
		
		// ExpressibleByStringLiteral \SDAI__STRING__type
		public init(stringLiteral value: String) {
			rep = value
		}

		// SDAI__STRING__type
		public var length: Int { return rep.count }
		
		// SDAIValue
		public func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool 
		{
			if let rhs = rhs as? Self { return self == rhs }
			return false
		}
	}
}


public protocol SDAI__STRING__subtype: SDAI__STRING__type, SDAIDefinedType
where Supertype: SDAI__STRING__type,
			Supertype.FundamentalType == SDAI.STRING
{}
public extension SDAI__STRING__subtype
{
//	// SDAIGenericType\SDAIUnderlyingType\SDAISimpleType\SDAI__STRING__type
//	var asSwiftType: Supertype.SwiftType { return rep.asSwiftType }
//	var asFundamentalType: FundamentalType { return rep.asFundamentalType }
//	var typeMembers: Set<SDAI.STRING> {
//		var members = rep.typeMembers
//		members.insert(SDAI.STRING(Self.typeName))
//		return members
//	}
//	init(_ fundamental: FundamentalType) {
//		self.init()
//		rep = Supertype(fundamental)
//	}
//
//	// SDAIUnderlyingType\SDAISimpleType\SDAI__STRING__type
//	init(_ selfValue: Self) {
//		self.init()
//		rep = selfValue.rep
//	}

	// SDAISimpleType \SDAI__STRING__type\SDAI__STRING__subtype
	init(_ swiftValue: Supertype.SwiftType) {
		self.init(Supertype(swiftValue))
	}
	
	// ExpressibleByStringLiteral \SDAI__STRING__type\SDAI__STRING__subtype
	init(stringLiteral value: Supertype.StringLiteralType) {
		self.init(Supertype(stringLiteral: value))
	}

	// SDAI__STRING__type \SDAI__STRING__subtype
	var length: Int { return rep.length }
}
