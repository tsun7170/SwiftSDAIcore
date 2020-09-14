//
//  SdaiBinary.swift
//  
//
//  Created by Yoshida on 2020/09/11.
//

import Foundation


public protocol SDAI__BINARY__type: SDAISimpleType,
																		ExpressibleByStringLiteral
where SwiftType == String
{
	init()
}


extension SDAI {
	public struct BINARY: SDAI__BINARY__type 
	{
		private var rep: String
		
		public init() {
			rep = String()
		}
		
		public var asSwiftType: String { return rep }
		public init(_ swiftValue: String) {
			assert(Self.isValidValue(value: swiftValue))
			rep = swiftValue
		}
		
		public init(stringLiteral value: StringLiteralType) {
			assert(Self.isValidValue(value: value))
			rep = value
		}

		private static func isValidValue(value: String) -> Bool {
			for c in value {
				if c != "0" && c != "1" { return false }
			}
			return true
		}
	}
}


public protocol SDAI__BINARY__subtype: SDAI__BINARY__type
{
	associatedtype Supertype: SDAI__BINARY__type
	var rep: Supertype {get set}
}
public extension SDAI__BINARY__subtype
{
	var asSwiftType: Supertype.SwiftType { return rep.asSwiftType }
	init(_ swiftValue: Supertype.SwiftType) {
		self.init()
		rep = Supertype(swiftValue)
	}
}
