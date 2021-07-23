//
//  SdaiNumber.swift
//  
//
//  Created by Yoshida on 2020/09/09.
//

import Foundation

public protocol SdaiNumberRepType : SignedNumeric, Strideable
{}
extension Double: SdaiNumberRepType {}
extension Int: SdaiNumberRepType {}

//MARK: - Double represented
public protocol SDAIDoubleRepresented
{
	var asSwiftDouble: Double {get}
}

//MARK: - Int represented
public protocol SDAIIntRepresented: SwiftDoubleConvertible
{
	var asSwiftInt: Int {get}
}


//MARK: - Double convertible
public protocol SwiftDoubleConvertible
{
	var possiblyAsSwiftDouble: Double? {get}
	var asSwiftDouble: Double {get}
}

extension Double: SwiftDoubleConvertible, SDAIDoubleRepresented
{
	public var asSwiftDouble: Double { return self }
	public var possiblyAsSwiftDouble: Double? { return self }
}

extension Int: SwiftDoubleConvertible
{
	public var possiblyAsSwiftDouble: Double? { return Double(self) }
	public var asSwiftDouble: Double { return Double(self) }
}

public extension SwiftDoubleConvertible
where Self: SDAIDoubleRepresentedNumberType
{
	var possiblyAsSwiftDouble: Double? { return self.asSwiftType }
	var asSwiftDouble: Double { return self.asSwiftType }
}

public extension SwiftDoubleConvertible
where Self: SDAIIntRepresentedNumberType
{
	var possiblyAsSwiftDouble: Double? { return Double(self.asSwiftType) }
	var asSwiftDouble: Double { return Double(self.asSwiftType) }
}


//MARK: - Int convertible
public protocol SwiftIntConvertible
{
	var possiblyAsSwiftInt: Int? {get}
	var asSwiftInt: Int {get}
}

extension Int: SwiftIntConvertible, SDAIIntRepresented
{
	public var asSwiftInt: Int { return self }
	public var possiblyAsSwiftInt: Int? { return self }
}

public extension SwiftIntConvertible
where Self: SDAIIntRepresentedNumberType
{
	var possiblyAsSwiftInt: Int? { return self.asSwiftType }
	var asSwiftInt: Int { return self.asSwiftType }
}


//MARK: - NUMBER type (8.1.1)
public protocol SDAINumberType: SDAISimpleType, ExpressibleByIntegerLiteral, SwiftDoubleConvertible
where SwiftType: SdaiNumberRepType
{}

public protocol SDAIDoubleRepresentedNumberType: SDAINumberType, SDAIDoubleRepresented 
where SwiftType == Double
{}

public protocol SDAIIntRepresentedNumberType: SDAINumberType, SDAIIntRepresented 
where SwiftType == Int
{}

public protocol SDAI__NUMBER__type: SDAIDoubleRepresentedNumberType, ExpressibleByFloatLiteral
where FundamentalType == SDAI.NUMBER,
			Value == FundamentalType.Value
{
	init?(_ double: Double?)
	init(_ double: Double)
	init?(_ int: Int?)
	init(_ int: Int)
	init?<T:SDAINumberType>(_ subtype: T?)
	init<T:SDAINumberType>(_ subtype: T)
}
public extension SDAI__NUMBER__type
{
	var asSwiftDouble: Double { return self.asSwiftType }

	init?(_ double: Double?) {
		guard let double = double else { return nil }
		self.init(from: double)
	}
	init(_ double: Double) {
		self.init(from: double)
	}

	init?(_ int: Int?) {
		guard let int = int else { return nil }
		self.init(from: SwiftType(int))
	}
	init(_ int: Int) {
		self.init(from: SwiftType(int))
	}
	init(integerLiteral value: Int) {
		self.init(from: SwiftType(value))
	}
	init(floatLiteral value: Double) {
		self.init(from: value)
	}
	init?<T:SDAINumberType>(_ subtype: T?) {
		guard let subtype = subtype else { return nil }
		self.init(from: subtype.asSwiftDouble)
	}
	init<T:SDAINumberType>(_ subtype: T) {
		self.init(from: subtype.asSwiftDouble)
	}
}

extension SDAI {
	public struct NUMBER: SDAI__NUMBER__type, SDAIValue, CustomStringConvertible
	{
		public typealias SwiftType = Double
		public typealias FundamentalType = Self
		private var rep: SwiftType

		// CustomStringConvertible
		public var description: String { "NUMBER(\(rep))" }
		
		// SDAIGenericType \SDAIUnderlyingType\SDAISimpleType\SDAI__NUMBER__type
		public var typeMembers: Set<SDAI.STRING> {
			return [SDAI.STRING(from: Self.typeName)]
		}
		public var value: FundamentalType { return self.asFundamentalType }
		
		public var entityReference: SDAI.EntityReference? {nil}	
		public var stringValue: SDAI.STRING? {nil}
		public var binaryValue: SDAI.BINARY? {nil}
		public var logicalValue: SDAI.LOGICAL? {nil}
		public var booleanValue: SDAI.BOOLEAN? {nil}
		public var numberValue: SDAI.NUMBER? { self }
		public var realValue: SDAI.REAL? { REAL(from: self.asSwiftDouble) }
		public var integerValue: SDAI.INTEGER? {
			let intval = Int(self.asSwiftDouble)
			if NUMBER(intval) == self { return INTEGER(intval) }
			return nil
		}
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
			guard let numberValue = generic?.numberValue else { return nil }
			self.init(numberValue)
		}
		
		
		// SDAIUnderlyingType \SDAISimpleType\SDAI__NUMBER__type
		public static let typeName: String = "NUMBER"
		public var asSwiftType: SwiftType { return rep }
		
		// SDAIGenericType
		public var asFundamentalType: FundamentalType { return self }
		public init(fundamental: FundamentalType) {
			self.init(fundamental.rep)
		}


		// SDAISimpleType \SDAI__NUMBER__type
		public init(from swiftValue: SwiftType) {
			rep = swiftValue
		}
		
		// SDAIValue
		public func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool 
		{
			if let rhs = rhs as? Self { return self == rhs }
			if let rhs = rhs as? SwiftDoubleConvertible { return self.asSwiftDouble == rhs.asSwiftDouble }
			return false
		}
		
		// InitializableByP21Parameter
		public static var bareTypeName: String { self.typeName }
		
		public init?(p21untypedParam: P21Decode.ExchangeStructure.UntypedParameter, from exchangeStructure: P21Decode.ExchangeStructure) {
			switch p21untypedParam {
			case .real(let realval):
				self.init(realval)
				
			case .rhsOccurenceName(let rhsname):
				switch rhsname {
				case .constantValueName(let name):
					guard let generic = exchangeStructure.resolve(constantValueName: name) else {exchangeStructure.add(errorContext: "while resolving \(Self.bareTypeName) value"); return nil }
					guard let numberValue = generic.numberValue else { exchangeStructure.error = "constant value(\(name): \(generic)) is not compatible with \(Self.bareTypeName)"; return nil }
					self.init(numberValue)
				
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
			self.init(0.0)
		}
		
	}	
}

