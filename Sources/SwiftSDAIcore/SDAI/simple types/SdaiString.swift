//
//  File.swift
//  
//
//  Created by Yoshida on 2020/09/13.
//

import Foundation


public protocol SDAIStringType: SDAISimpleType, ExpressibleByStringLiteral
where StringLiteralType == String
{
	var length: Int {get}
	subscript<I: SDAI__INTEGER__type>(index: I?) -> SDAI.STRING? {get}
	subscript(index: Int?) -> SDAI.STRING? {get}
	subscript(range: ClosedRange<Int>?) -> SDAI.STRING? {get}
	func ISLIKE<T:SDAIStringType>(PATTERN substring: T? ) -> SDAI.LOGICAL	// Express 'LIKE' operator translation
	func ISLIKE(PATTERN substring: String? ) -> SDAI.LOGICAL	// Express 'LIKE' operator translation
//	func ISLIKE(PATTERN substring: SwiftType? ) -> SDAI.LOGICAL	// Express 'LIKE' operator translation
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
//	func ISLIKE(PATTERN substring: String? ) -> SDAI.LOGICAL{
//		guard let substring = substring else { return nil }
//		return self.ISLIKE(PATTERN: SwiftType(substring))
//	}

//	init?<T:SDAIStringType>(_ subtype: T?) {
//		guard let subtype = subtype else { return nil }
//		self.init(subtype)
//	}
//	init<T:SDAIStringType>(_ subtype:T) {
//		self.init(subtype.asSwiftType)
//	}
//	init(_ string: String) {
//		self.init(stringLiteral: string)
//	}
//	var asSwiftString: String { return String(self.asSwiftType) }
}

public protocol SDAI__STRING__type: SDAIStringType where SwiftType == String
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
		public init?<S: SDAISelectType>(possiblyFrom select: S) {
			guard let stringValue = select.stringValue else { return nil }
			self.init(stringValue)
		}

//		// SDAIUnderlyingType\SDAISimpleType\SDAI__STRING__type
		public static let typeName: String = "STRING"
		public var asFundamentalType: FundamentalType { return self }
		public var asSwiftType: SwiftType { return rep }
		public init(_ fundamental: FundamentalType) {
			self.init(fundamental.rep)
		}

		// SDAISimpleType \SDAI__STRING__type
		public init(_ swiftValue: SwiftType) {
			rep = swiftValue
		}
		
//		// ExpressibleByStringLiteral \SDAI__STRING__type
//		public init(stringLiteral value: String) {
//			self.init( SwiftType(value) )
//		}

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


public protocol SDAI__STRING__subtype: SDAI__STRING__type, SDAIDefinedType
where Supertype: SDAI__STRING__type,
			Supertype.FundamentalType == SDAI.STRING
{}
public extension SDAI__STRING__subtype
{
	// SDAIGenericType
	init?<S: SDAISelectType>(possiblyFrom select: S) {
		guard let supertype = Supertype(possiblyFrom: select) else { return nil }
		self.init(supertype)
	}
	
	// SDAISimpleType \SDAI__STRING__type\SDAI__STRING__subtype
	init(_ swiftValue: Supertype.SwiftType) {
		self.init(Supertype(swiftValue))
	}
	
//	// ExpressibleByStringLiteral \SDAI__STRING__type\SDAI__STRING__subtype
//	init(stringLiteral value: Supertype.StringLiteralType) {
//		self.init(Supertype(stringLiteral: value))
//	}

	// SDAI__STRING__type \SDAI__STRING__subtype
	var length: Int { return rep.length }
	subscript(index: Int?) -> SDAI.STRING? { return rep[index] }
	subscript(range: ClosedRange<Int>?) -> SDAI.STRING? { return rep[range] }
	func ISLIKE(PATTERN substring: SwiftType? ) -> SDAI.LOGICAL { rep.ISLIKE(PATTERN: substring) }
}
