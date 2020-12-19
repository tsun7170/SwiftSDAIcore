//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation


//MARK: - INTEGER type
public protocol SDAIIntegerType: SDAIRealType
{}

public protocol SDAI__INTEGER__type: SDAIIntegerType, SDAIIntRepresentedNumberType
{
	init?(_ int: Int?)
	init(_ int: Int)
	init?<T:SDAI__INTEGER__type>(_ subtype: T?)
	init<T:SDAI__INTEGER__type>(_ subtype: T)
}
public extension SDAI__INTEGER__type
{
	var asSwiftDouble: Double { return Double(self.asSwiftType) }

	init?(_ int: Int?) {
		guard let int = int else { return nil }
		self.init(int)
	}
	init(integerLiteral value: Int) {
		self.init(value)
	}
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

		// SDAIGenericType \SDAIUnderlyingType\SDAISimpleType\SDAI__NUMBER__type\SDAI__REAL__type\SDAI__INTEGER__type
		public var typeMembers: Set<SDAI.STRING> {
			return [SDAI.STRING(Self.typeName)]
		}
		public init?<S>(possiblyFrom select: S?) where S : SDAISelectType {
			guard let integerValue = select?.integerValue else { return nil }
			self.init(integerValue)
		}
		
		// SDAIUnderlyingType \SDAISimpleType\SDAI__NUMBER__type\SDAI__REAL__type\SDAI__INTEGER__type
		public static let typeName: String = "INTEGER"
		public var asSwiftType: SwiftType { return rep }
		public var asFundamentalType: FundamentalType { return self }
		public init(fundamental: FundamentalType) {
			self.init(fundamental.rep)
		}

		// SDAISimpleType \SDAI__NUMBER__type\SDAI__REAL__type\SDAI__INTEGER__type
		public init(_ swiftValue: SwiftType) {
			rep = swiftValue
		}
		
		// SDAIValue
		public func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool 
		{
			if let rhs = rhs as? Self { return self == rhs }
			if let rhs = rhs as? SwiftDoubleConvertible { return self.asSwiftDouble == rhs.asSwiftDouble }
			return false
		}
	}
}


