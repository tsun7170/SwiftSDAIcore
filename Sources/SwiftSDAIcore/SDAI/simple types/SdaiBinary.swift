//
//  SdaiBinary.swift
//  
//
//  Created by Yoshida on 2020/09/11.
//

import Foundation

//MARK: - BINARY type
public protocol SDAIBinaryType: SDAISimpleType, ExpressibleByStringLiteral
where StringLiteralType == String
{
	var blength: Int {get}
	subscript<I: SDAI__INTEGER__type>(index: I?) -> SDAI.BINARY? {get}
	subscript(index: Int?) -> SDAI.BINARY? {get}
	subscript(range: ClosedRange<Int>?) -> SDAI.BINARY? {get}

}
public extension SDAIBinaryType
{
	subscript<I: SDAI__INTEGER__type>(index: I?) -> SDAI.BINARY? {
		return self[index?.asSwiftType]
	}
}


public protocol SDAI__BINARY__type: SDAIBinaryType
where FundamentalType == SDAI.BINARY,
			Value == FundamentalType.Value,
			SwiftType == FundamentalType.SwiftType
{
	init?(_ string: String?)
	init(_ string: String)
	init?<T:SDAI__BINARY__type>(_ subtype: T?)
	init<T:SDAI__BINARY__type>(_ subtype: T)
}
public extension SDAI__BINARY__type
{
	init?(_ string: String?) {
		guard let string = string else { return nil }
		self.init(string)
	}
	init(_ string: String) {
		self.init(stringLiteral: string)
	}
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
		public typealias SwiftType = Array<Int8>
		public typealias FundamentalType = Self
		private var rep: SwiftType

		// SDAIGenericType \SDAIUnderlyingType\SDAISimpleType\SDAI__BINARY__type
		public var typeMembers: Set<SDAI.STRING> {
			return [SDAI.STRING(stringLiteral: Self.typeName)]
		}
		public var value: FundamentalType { return self.asFundamentalType }
		
		public var entityReference: SDAI.EntityReference? {nil}	
		public var stringValue: SDAI.STRING? {nil}
		public var binaryValue: SDAI.BINARY? { self }
		public var logicalValue: SDAI.LOGICAL? {nil}
		public var booleanValue: SDAI.BOOLEAN? {nil}
		public var numberValue: SDAI.NUMBER? {nil}
		public var realValue: SDAI.REAL? {nil}
		public var integerValue: SDAI.INTEGER? {nil}
		public func arrayOptionalValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY_OPTIONAL<ELEM>? {nil}
		public func arrayValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>? {nil}
		public func listValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.LIST<ELEM>? {nil}
		public func bagValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.BAG<ELEM>? {nil}
		public func setValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.SET<ELEM>? {nil}
		public func enumValue<ENUM:SDAIEnumerationType>(enumType:ENUM.Type) -> ENUM? {nil}

		
//		public init?<S>(possiblyFrom select: S?) where S : SDAISelectType {
//			self.init(fromGeneric: select)
////			guard let binaryValue = select?.binaryValue else { return nil }
////			self.init(binaryValue)
//		}
		// InitializableByGenerictype
		public init?<G: SDAIGenericType>(fromGeneric generic: G?) {
			guard let binaryValue = generic?.binaryValue else { return nil }
			self.init(binaryValue)
		}
		
		// SDAIUnderlyingType \SDAISimpleType\SDAI__BINARY__type
		public static let typeName: String = "BINARY"
		public var asSwiftType: SwiftType { return rep }
		public var asFundamentalType: FundamentalType { return self }
		public init(fundamental: FundamentalType) {
			self.init(fundamental.rep)
		}

		// SDAISimpleType \SDAI__BINARY__type
		public init(_ swiftValue: SwiftType) {
			assert(Self.isValidValue(value: swiftValue))
			rep = swiftValue
		}
		
		// ExpressibleByStringLiteral \SDAI__BINARY__type
		public init(stringLiteral value: String) {
			assert(value.hasPrefix("%"))
			rep = SwiftType()
			rep.reserveCapacity(value.count-1)
			for c in value.dropFirst() {
				switch c {
				case "0": rep.append(0)
				case "1": rep.append(1)
				default: fatalError()
				}
			}
		}

		// SDAI__BINARY__type
		public var blength: Int { return rep.count }

		public subscript(index: Int?) -> BINARY? {
			guard let index = index, index >= 1, index <= self.blength else { return nil }
			return BINARY( SwiftType([rep[index-1]]) )
		}
		public subscript(range: ClosedRange<Int>?) -> BINARY? {
			guard let range = range, range.lowerBound >= 1, range.upperBound <= self.blength else { return nil }
			let swiftrange = (range.lowerBound - 1) ... (range.upperBound - 1)
			return BINARY( SwiftType(rep[swiftrange]) )
		}
		
		// BINARY specific
		private static func isValidValue(value: SwiftType) -> Bool {
			for bit in value {
				if bit != 0 && bit != 1 { return false }
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

