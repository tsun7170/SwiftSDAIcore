//
//  SdaiBinary.swift
//  
//
//  Created by Yoshida on 2020/09/11.
//

import Foundation

//MARK: - BINARY type (8.1.7)
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
	subscript<I: SDAI__INTEGER__type>(index: I?) -> SDAI.BINARY? { return self[index?.asSwiftType] }
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
		self.init(stringLiteral: string)
	}
	init(_ string: String) {
		self.init(stringLiteral: string)
	}
	init?<T:SDAI__BINARY__type>(_ subtype: T?) {
		guard let subtype = subtype else { return nil }	
		self.init(from: subtype.asSwiftType)
	}
	init<T:SDAI__BINARY__type>(_ subtype: T) {
		self.init(from: subtype.asSwiftType)
	}
}


extension SDAI {
	public struct BINARY: SDAI__BINARY__type, SDAIValue, CustomStringConvertible
	{
		public typealias SwiftType = Array<Int8>
		public typealias FundamentalType = Self
		private var rep: SwiftType

		// CustomStringConvertible
		public var description: String { "BINARY(\(rep))" }
		
		// SDAIGenericType \SDAIUnderlyingType\SDAISimpleType\SDAI__BINARY__type
		public var typeMembers: Set<SDAI.STRING> {
			return [SDAI.STRING(from: Self.typeName)]
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
		public var genericEnumValue: SDAI.GenericEnumValue? {nil}
		
		public func arrayOptionalValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY_OPTIONAL<ELEM>? {nil}
		public func arrayValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>? {nil}
		public func listValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.LIST<ELEM>? {nil}
		public func bagValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.BAG<ELEM>? {nil}
		public func setValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.SET<ELEM>? {nil}
		public func enumValue<ENUM:SDAIEnumerationType>(enumType:ENUM.Type) -> ENUM? {nil}

		public static func validateWhereRules(instance:Self?, prefix:SDAI.WhereLabel) -> [SDAI.WhereLabel:SDAI.LOGICAL] { return [:] }

		
		// InitializableByGenerictype
		public init?<G: SDAIGenericType>(fromGeneric generic: G?) {
			guard let binaryValue = generic?.binaryValue else { return nil }
			self.init(binaryValue)
		}
		
		// SDAIUnderlyingType \SDAISimpleType\SDAI__BINARY__type
		public static let typeName: String = "BINARY"
		public var asSwiftType: SwiftType { return rep }
		
		// SDAIGenericType
		public var asFundamentalType: FundamentalType { return self }
		public init(fundamental: FundamentalType) {
			self.init(from: fundamental.rep)
		}

		// SDAISimpleType \SDAI__BINARY__type
		public init(from swiftValue: SwiftType) {
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
			return BINARY( from: SwiftType([rep[index-1]]) )
		}
		public subscript(range: ClosedRange<Int>?) -> BINARY? {
			guard let range = range, range.lowerBound >= 1, range.upperBound <= self.blength else { return nil }
			let swiftrange = (range.lowerBound - 1) ... (range.upperBound - 1)
			return BINARY( from: SwiftType(rep[swiftrange]) )
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

		// InitializableByP21Parameter
		public static var bareTypeName: String { self.typeName }
		
		public init?(p21untypedParam: P21Decode.ExchangeStructure.UntypedParameter, from exchangeStructure: P21Decode.ExchangeStructure) {
			switch p21untypedParam {
			case .binary(let bin):
				let swiftval: SwiftType = SwiftType(bin.compactMap { 
					switch $0 {
					case "0": return 0
					case "1": return 1
					default: return nil						
					}
				})
				self.init(from: swiftval)
				
			case .rhsOccurenceName(let rhsname):
				switch rhsname {
				case .constantValueName(let name):
					guard let generic = exchangeStructure.resolve(constantValueName: name) else {exchangeStructure.add(errorContext: "while resolving \(Self.bareTypeName) value"); return nil }
					guard let binaryValue = generic.binaryValue else { exchangeStructure.error = "constant value(\(name): \(generic)) is not compatible with \(Self.bareTypeName)"; return nil }
					self.init(binaryValue)
				
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
			self.init(from: SwiftType([]))
		}

	}
}

