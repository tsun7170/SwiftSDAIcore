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
		public init?<S>(possiblyFrom select: S?) where S : SDAISelectType {
			guard let logicalValue = select?.logicalValue else { return nil }
			self.init(logicalValue)
		}

		// SDAIUnderlyingType \SDAISimpleType\SDAI__LOGICAL__type
		public static let typeName: String = "LOGICAL"
		public var asSwiftType: SwiftType { return rep }
		public var asFundamentalType: FundamentalType { return self }
		public init(fundamental: FundamentalType) {
			self.init(fundamental.rep)
		}

		// SDAISimpleType \SDAI__LOGICAL__type
		public init(_ swiftValue: SwiftType) {
			rep = swiftValue
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


