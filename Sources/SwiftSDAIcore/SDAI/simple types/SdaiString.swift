//
//  File.swift
//  
//
//  Created by Yoshida on 2020/09/13.
//

import Foundation

//MARK: - String convertible
public protocol SwiftStringConvertible
{
	var possiblyAsSwiftString: String? {get}
}

extension String: SwiftStringConvertible
{
	public var possiblyAsSwiftString: String? { return self }
}


//MARK: - STRING type
public protocol SDAIStringType: SDAISimpleType, ExpressibleByStringLiteral, SwiftStringConvertible
where StringLiteralType == String
{
	var length: Int {get}
	subscript<I: SDAI__INTEGER__type>(index: I?) -> SDAI.STRING? {get}
	subscript(index: Int?) -> SDAI.STRING? {get}
	subscript(range: ClosedRange<Int>?) -> SDAI.STRING? {get}
	func ISLIKE<T:SDAIStringType>(PATTERN substring: T? ) -> SDAI.LOGICAL	// Express 'LIKE' operator translation
	func ISLIKE(PATTERN substring: String? ) -> SDAI.LOGICAL	// Express 'LIKE' operator translation
	var asSwiftString: String {get}
}
public extension SDAIStringType
{
	subscript<I: SDAI__INTEGER__type>(index: I?) -> SDAI.STRING? {
		return self[index?.asSwiftType]
	}

	func ISLIKE<T:SDAIStringType>(PATTERN substring: T? ) -> SDAI.LOGICAL{
		return self.ISLIKE(PATTERN: substring?.asSwiftString)
	}
}
public extension SDAIStringType where SwiftType == String
{
	var possiblyAsSwiftString: String? { return self.asSwiftType }
}

public protocol SDAI__STRING__type: SDAIStringType 
where FundamentalType == SDAI.STRING,
			Value == FundamentalType.Value,
			SwiftType == FundamentalType.SwiftType
{
	init?(_ string:String?)
	init(_ string:String)
	init?<T:SDAI__STRING__type>(_ subtype: T?)
	init<T:SDAI__STRING__type>(_ subtype: T)
}
public extension SDAI__STRING__type
{
	var asSwiftString: String { return String(self.asSwiftType) }

	init?(_ string: String?) {
		guard let string = string else { return nil }
		self.init(string)
	}
	
	init(stringLiteral value: String) {
		self.init( SwiftType(value) )
	}

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
		public var typeMembers: Set<SDAI.STRING> {
			return [SDAI.STRING(Self.typeName)]
		}
		public var value: FundamentalType { return self.asFundamentalType }
		
		public var entityReference: SDAI.EntityReference? {nil}	
		public var stringValue: SDAI.STRING? { self }
		public var binaryValue: SDAI.BINARY? {nil}
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

		
//		public init?<S: SDAISelectType>(possiblyFrom select: S?) {
//			self.init(fromGeeneric: select)
////			guard let stringValue = select?.stringValue else { return nil }
////			self.init(stringValue)
//		}
		// InitializableByGenerictype
		public init?<G: SDAIGenericType>(fromGeneric generic: G?) {
			guard let stringValue = generic?.stringValue else { return nil }
			self.init(stringValue)
		}

		// SDAIUnderlyingType\SDAISimpleType\SDAI__STRING__type
		public static let typeName: String = "STRING"
		public var asFundamentalType: FundamentalType { return self }
		public var asSwiftType: SwiftType { return rep }
		public init(fundamental: FundamentalType) {
			self.init(fundamental.rep)
		}

		// SDAISimpleType \SDAI__STRING__type
		public init(_ swiftValue: SwiftType) {
			rep = swiftValue
		}

		// SDAI__STRING__type
		public var length: Int { return rep.count }

		public subscript(index: Int?) -> SDAI.STRING? {
			guard let index = index, index >= 1, index <= self.length else { return nil }
			let sindex = rep.index(rep.startIndex, offsetBy: index-1)
			return STRING( SwiftType(rep[sindex]) )
		}
		public subscript(range: ClosedRange<Int>?) -> SDAI.STRING? {
			guard let range = range, range.lowerBound >= 1, range.upperBound <= self.length else { return nil }
			let swiftrange = (range.lowerBound - 1) ... (range.upperBound - 1)
			let charArray = Array(rep)
			return STRING( SwiftType(charArray[swiftrange]) )
		}
		
		public func ISLIKE(PATTERN substring: String?) -> SDAI.LOGICAL {
			abstruct()
		}
		

		// SDAIValue
		public func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool 
		{
			if let rhs = rhs as? Self { return self == rhs }
			return false
		}
	}
}

