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
	init()
	var length: SDAI.INTEGER {get}
}

extension SDAI {
	public struct STRING: SDAI__STRING__type
	{
		public var length: SDAI.INTEGER { return INTEGER(rep.count) }
		
		private var rep: String
		
		public init() {
			rep = String()
		}
		
		public var asSwiftType: String { return rep }
		public init(_ swiftValue: String) {
			rep = swiftValue
		}
		
		public init(stringLiteral value: StringLiteralType) {
			rep = value
		}
	}
}


public protocol SDAI__STRING__subtype: SDAI__STRING__type
{
	associatedtype Supertype: SDAI__STRING__type
	var rep: Supertype {get set}
}
public extension SDAI__STRING__subtype
{
	var asSwiftType: Supertype.SwiftType { return rep.asSwiftType }
	init(_ swiftValue: Supertype.SwiftType) {
		self.init()
		rep = Supertype(swiftValue)
	}
	
	init(stringLiteral value: Supertype.StringLiteralType ) {
		self.init()
		rep = Supertype(stringLiteral: value)
	}
}
