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

//MARK: - NUMBER type
public protocol SDAI__NUMBER__type: SDAISimpleType
where SwiftType: SdaiNumberRepType
{
	var asSwiftDouble: Double {get}
	init(_ swiftValue: Double)
	init()
}


extension SDAI {
	public struct NUMBER: SDAI__NUMBER__type
	{
		private var rep: Double
		
		public init() {
			rep = Double()
		}
		
		public var asSwiftType: Double { return rep }
		public init(_ swiftValue: Double) {
			rep = swiftValue
		}
		
		public var asSwiftDouble: Double { return rep }
	}	
}


public protocol SDAI__NUMBER__subtype: SDAI__NUMBER__type
{
	associatedtype Supertype: SDAI__NUMBER__type
	var rep: Supertype {get set}
}
public extension SDAI__NUMBER__subtype
{
	var asSwiftType: Supertype.SwiftType { return rep.asSwiftType }
	init(_ swiftValue: Supertype.SwiftType) {
		self.init()
		rep = Supertype(swiftValue)
	}
	var asSwiftDouble: Double { return rep.asSwiftDouble }
}



//MARK: - REAL type
public protocol SDAI__REAL__type: SDAI__NUMBER__type
{}

extension SDAI {
	public struct REAL: SDAI__REAL__type
	{
		private var rep: NUMBER
		
		public init() {
			rep = NUMBER()
		}
		
		public var asSwiftType: NUMBER.SwiftType { return rep.asSwiftType }
		public init(_ swiftValue: NUMBER.SwiftType) {
			rep = NUMBER(swiftValue)
		}
		
		public var asSwiftDouble: Double { return rep.asSwiftDouble }
	}
}


public protocol SDAI__REAL__subtype: SDAI__REAL__type
{
	associatedtype Supertype: SDAI__REAL__type
	var rep: Supertype {get set}
}
public extension SDAI__REAL__subtype
{
	var asSwiftType: Supertype.SwiftType { return rep.asSwiftType }
	init(_ swiftValue: Supertype.SwiftType) {
		self.init()
		rep = Supertype(swiftValue)
	}
	var asSwiftDouble: Double { return rep.asSwiftDouble }
}


//MARK: - INTEGER type
public protocol SDAI__INTEGER__type: SDAI__REAL__type 
{}

extension SDAI {
	public struct INTEGER: SDAI__INTEGER__type
	{
		private var rep: Int
		
		public init() {
			rep = Int()
		}
		
		public var asSwiftType: Int { return rep }
		public init(_ swiftValue: Int) {
			rep = swiftValue
		}
		
		public var asSwiftDouble: Double { return Double(rep) }		
		public init(_ swiftValue: Double) {
			rep = Int(swiftValue)
		}
	}
}


public protocol SDAI__INTEGER__subtype: SDAI__INTEGER__type
{
	associatedtype Supertype: SDAI__INTEGER__type
	var rep: Supertype {get set}
}
public extension SDAI__INTEGER__subtype
{
	var asSwiftType: Supertype.SwiftType { return rep.asSwiftType }
	init(_ swiftValue: Supertype.SwiftType) {
		self.init()
		rep = Supertype(swiftValue)
	}
	var asSwiftDouble: Double { return rep.asSwiftDouble }
	init(_ swiftValue:Double) {
		self.init()
		rep = Supertype(swiftValue)
	}
}
