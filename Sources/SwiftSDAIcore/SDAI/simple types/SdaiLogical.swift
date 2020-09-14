//
//  File.swift
//  
//
//  Created by Yoshida on 2020/09/09.
//

import Foundation

public protocol SDAI__LOGICAL__type: SDAISimpleType,
																		 ExpressibleByBooleanLiteral
{
	init()
	var isTRUE: Bool {get}
	var isnotTRUE: Bool {get}
}
public extension SDAI__LOGICAL__type
{
	var isnotTRUE: Bool { return !self.isTRUE }
}


//MARK: - LOGICAL type
extension SDAI {
	public struct LOGICAL : SDAI__LOGICAL__type,
													ExpressibleByNilLiteral
	{
		private var rep: Bool?
		
		public init() {
			rep = nil
		}
		
		public var asSwiftType: Bool? { return rep }
		public init(_ swiftValue:Bool?) {
			rep = swiftValue
		}
		
		public init(_ boolean:BOOLEAN) {
			rep = boolean.asSwiftType
		}
		
		public init(booleanLiteral:Bool) {
			rep = booleanLiteral
		}
		
		public init(nilLiteral: ()) {
			rep = nil
		}
		
		public var isTRUE: Bool {
			return rep ?? false
		}
	}
}


public protocol SDAI__LOGICAL__subtype: SDAI__LOGICAL__type, 
																				ExpressibleByNilLiteral
{
	associatedtype Supertype: SDAI__LOGICAL__type & ExpressibleByNilLiteral
	var rep: Supertype {get set}
}
public extension SDAI__LOGICAL__subtype
{
	var asSwiftType: Supertype.SwiftType { return rep.asSwiftType }
	init(_ swiftValue: Supertype.SwiftType) {
		self.init()
		rep = Supertype(swiftValue)
	}
	
	init(booleanLiteral:Supertype.BooleanLiteralType) {
		self.init()
		rep = Supertype(booleanLiteral: booleanLiteral)
	}

	init(nilLiteral: ()) {
		self.init()
		rep = nil
	}
}


//MARK: - BOOLEAN type
public protocol SDAI__BOOLEAN__type: SDAI__LOGICAL__type 
{}

extension SDAI {
	public struct BOOLEAN : SDAI__BOOLEAN__type
	{		
		private var rep: Bool
		
		public init() {
			rep = Bool()
		}
		
		public var asSwiftType: Bool { return rep }
		public init(_ swiftValue:Bool) {
			rep = swiftValue
		}
		
		public init(booleanLiteral:Bool) {
			rep = booleanLiteral
		}
		
		public var isTRUE: Bool {
			return rep
		}
	}
}


public protocol SDAI__BOOLEAN__subtype: SDAI__BOOLEAN__type
{
	associatedtype Supertype: SDAI__BOOLEAN__type
	var rep: Supertype {get set}
}
public extension SDAI__BOOLEAN__subtype
{
	var asSwiftType: Supertype.SwiftType { return rep.asSwiftType }
	init(_ swiftValue: Supertype.SwiftType) {
		self.init()
		rep = Supertype(swiftValue)
	}
	
	init(booleanLiteral:Supertype.BooleanLiteralType) {
		self.init()
		rep = Supertype(booleanLiteral: booleanLiteral)
	}
}
