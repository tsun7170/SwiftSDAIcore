//
//  SdaiReal.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - REAL type (8.1.2)
public protocol SDAIRealType: SDAINumberType 
{}

public protocol SDAI__REAL__type: SDAIRealType, SDAIDoubleRepresentedNumberType, ExpressibleByFloatLiteral
where FundamentalType == SDAI.REAL,
			Value == FundamentalType.Value
{
	init?(_ double: Double?)
	init(_ double: Double)
	init?(_ int: Int?)
	init(_ int: Int)
	init?<T:SDAIRealType>(_ subtype: T?)
	init<T:SDAIRealType>(_ subtype: T)
	static var precision: SDAIDictionarySchema.Bound {get}
}
public extension SDAI__REAL__type
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
	init?<T:SDAIRealType>(_ subtype: T?) {
		guard let subtype = subtype else { return nil }
		self.init(from: subtype.asSwiftDouble)
	}
	init<T:SDAIRealType>(_ subtype: T) {
		self.init(from: subtype.asSwiftDouble)
	}
}

extension SDAI {
	public struct REAL: SDAI__REAL__type, SDAIValue, CustomStringConvertible
	{
		public typealias SwiftType = Double
		public typealias FundamentalType = Self
		private var rep: SwiftType
		
		// CustomStringConvertible
		public var description: String { "REAL(\(rep))" }
		
		// SDAIGenericType \SDAIUnderlyingType\SDAISimpleType\SDAI__Nfrom: UMBER__type\SDAI__REAL__type
		public var typeMembers: Set<SDAI.STRING> {
			return [SDAI.STRING(from: Self.typeName), SDAI.STRING(from: NUMBER.typeName)]
		}
		public var value: FundamentalType { return self.asFundamentalType }
		
		public var entityReference: SDAI.EntityReference? {nil}	
		public var stringValue: SDAI.STRING? {nil}
		public var binaryValue: SDAI.BINARY? {nil}
		public var logicalValue: SDAI.LOGICAL? {nil}
		public var booleanValue: SDAI.BOOLEAN? {nil}
		public var numberValue: SDAI.NUMBER? { NUMBER(self) }
		public var realValue: SDAI.REAL? { self }
		public var integerValue: SDAI.INTEGER? {
			let intval = Int(self.asSwiftDouble)
			if REAL(intval) == self { return INTEGER(intval) }
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
			guard let realValue = generic?.realValue else { return nil }
			self.init(realValue)
		}
		
		// SDAIUnderlyingType \SDAISimpleType\SDAI__NUMBER__type\SDAI__REAL__type
		public static let typeName: String = "REAL"
		public var asSwiftType: SwiftType { return rep }
		
		// SDAIGenericType
		public var asFundamentalType: FundamentalType { return self }
		public init(fundamental: FundamentalType) {
			rep = fundamental.rep
		}

		// SDAISimpleType \SDAI__NUMBER__type\SDAI__REAL__type
		public init(from swiftValue: SwiftType) {
			rep = swiftValue
		}
		
		// SDAI__REAL__type
		public static var precision: SDAIDictionarySchema.Bound { Int(Double(SwiftType.significandBitCount) * (log(2)/log(10))) }
		
		// ExpressibleByIntegerLiteral \SDAI__NUMBER__type\SDAI__REAL__type
		public init(integerLiteral value: Int) {
			rep = SwiftType(value)
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
					guard let realValue = generic.realValue else { exchangeStructure.error = "constant value(\(name): \(generic)) is not compatible with \(Self.bareTypeName)"; return nil }
					self.init(realValue)
				
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

