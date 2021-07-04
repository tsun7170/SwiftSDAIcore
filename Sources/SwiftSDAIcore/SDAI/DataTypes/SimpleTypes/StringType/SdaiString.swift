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
	var asSwiftString: String {get}
}

public protocol SwiftStringRepresented: SwiftStringConvertible
{}

extension String: SwiftStringRepresented
{
	public var possiblyAsSwiftString: String? { return self }
	public var asSwiftString: String { return self }
}


//MARK: - STRING type (8.1.6)
public protocol SDAIStringType: SDAISimpleType, SwiftStringConvertible, ExpressibleByStringLiteral
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
	var asSwiftString: String { return self.asSwiftType }
	var possiblyAsSwiftString: String? { return self.asSwiftType }
}

public protocol SDAI__STRING__type: SDAIStringType, SwiftStringRepresented 
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
		self.init(from: string)
	}
	init(_ string:String) {
		self.init(from: string)
	}
	
	init(stringLiteral value: String) {
		self.init(from: SwiftType(value) )
	}

	init?<T:SDAI__STRING__type>(_ subtype: T?) {
		guard let subtype = subtype else { return nil }
		self.init(from: subtype.asSwiftType)
	}

	init<T:SDAI__STRING__type>(_ subtype:T) {
		self.init(from: subtype.asSwiftType)
	}
}

extension SDAI {
	public struct STRING: SDAI__STRING__type, SDAIValue, CustomStringConvertible
	{
		public typealias SwiftType = String
		public typealias FundamentalType = Self
		private var rep: SwiftType

		// CustomStringConvertible
		public var description: String { "STRING(\(rep))" }
		
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
		public var genericEnumValue: SDAI.GenericEnumValue? {nil}
		
		public func arrayOptionalValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY_OPTIONAL<ELEM>? {nil}
		public func arrayValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>? {nil}
		public func listValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.LIST<ELEM>? {nil}
		public func bagValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.BAG<ELEM>? {nil}
		public func setValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.SET<ELEM>? {nil}
		public func enumValue<ENUM:SDAIEnumerationType>(enumType:ENUM.Type) -> ENUM? {nil}

		public static func validateWhereRules(instance:Self?, prefix:SDAI.WhereLabel, round: SDAI.ValidationRound) -> [SDAI.WhereLabel:SDAI.LOGICAL] { return [:] }

		
		// InitializableByGenerictype
		public init?<G: SDAIGenericType>(fromGeneric generic: G?) {
			guard let stringValue = generic?.stringValue else { return nil }
			self.init(stringValue)
		}

		// SDAIUnderlyingType\SDAISimpleType\SDAI__STRING__type
		public static let typeName: String = "STRING"
		public var asSwiftType: SwiftType { return rep }
		
		// SDAIGenericType
		public var asFundamentalType: FundamentalType { return self }
		public init(fundamental: FundamentalType) {
			self.init(fundamental.rep)
		}

		// SDAISimpleType \SDAI__STRING__type
		public init(from swiftValue: SwiftType) {
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
		
		// Line operator (12.2.5)
		public func ISLIKE(PATTERN substring: String?) -> SDAI.LOGICAL {
			guard let substring = substring else { return SDAI.UNKNOWN }
			var strp = self.rep.makeIterator()
			var patp = substring.makeIterator()
			var strc = strp.next()
			var patc = patp.next()
			var accept = true
			
			while var patchar = patc {
				if patchar == "!" {
					accept = !accept
				}
				else {
					guard let strchar = strc else { return SDAI.FALSE }
					switch patchar {
					case "@":
						if strchar.isLetter != accept { return SDAI.FALSE }
					case "^":
						if strchar.isUppercase != accept { return SDAI.FALSE }
					case "?":
						if true != accept { return SDAI.FALSE }
					case "&":
						return SDAI.LOGICAL( accept )
					case "#":
						if strchar.isNumber != accept { return SDAI.FALSE }
					case "$":
						if (!strchar.isWhitespace) != accept { return SDAI.FALSE }
						while let char = strc, !char.isWhitespace {
							strc = strp.next()
						}
					case "*":
						return SDAI.LOGICAL( accept )
					case "\\":
						patc = patp.next()
						guard let char = patc else { return SDAI.UNKNOWN }
						patchar = char
						fallthrough
					default:					
						if (strchar == patchar ) != accept { return SDAI.FALSE }
					}
					accept = true
					strc = strp.next()
				}
				patc = patp.next()
			}
			if !accept { return SDAI.UNKNOWN } 
			return LOGICAL( strc == nil )
		}
		

		// SDAIValue
		public func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool 
		{
			if let rhs = rhs as? Self { return self == rhs }
			return false
		}
		
		// InitializableByP21Parameter
		public static var bareTypeName: String { self.typeName }
		
		public init?(p21untypedParam: P21Decode.ExchangeStructure.UntypedParameter, from exchangeStructure: P21Decode.ExchangeStructure) {
			switch p21untypedParam {
			case .string(let strval):
				self.init(strval)
				
			case .rhsOccurenceName(let rhsname):
				switch rhsname {
				case .constantValueName(let name):
					guard let generic = exchangeStructure.resolve(constantValueName: name) else {exchangeStructure.add(errorContext: "while resolving \(Self.bareTypeName) value"); return nil }
					guard let stringValue = generic.stringValue else { exchangeStructure.error = "constant value(\(name): \(generic)) is not compatible with \(Self.bareTypeName)"; return nil }
					self.init(stringValue)
				
				case .valueInstanceName(let name):
					guard let param = exchangeStructure.resolve(valueInstanceName: name) else {exchangeStructure.add(errorContext: "while resolving \(Self.bareTypeName) value from \(rhsname)"); return nil }
					self.init(p21param: param, from: exchangeStructure)
					
				default:
					exchangeStructure.error = "unexpected p21parameter(\(p21untypedParam)) while resolving \(Self.bareTypeName) value"
					return nil
				}
							
			case .noValue:
				return nil
				
			default:
				exchangeStructure.error = "unexpected p21parameter(\(p21untypedParam)) while resolving \(Self.bareTypeName) value"
				return nil
			}
		}

		public init(p21omittedParamfrom exchangeStructure: P21Decode.ExchangeStructure) {
			self.init("")
		}
		

	}
}

