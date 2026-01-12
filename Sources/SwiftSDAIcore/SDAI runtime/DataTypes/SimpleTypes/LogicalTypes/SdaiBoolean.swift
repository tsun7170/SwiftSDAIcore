//
//  SdaiBoolean.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation


//MARK: - BOOLEAN type (8.1.5)
extension SDAI {
  public protocol BooleanType: SDAI.LogicalType
  {}
}

extension SDAI {
  public protocol BOOLEAN__TypeBehavior: SDAI.BooleanType
  where FundamentalType == SDAI.BOOLEAN,
        Value == FundamentalType.Value,
        SwiftType == FundamentalType.SwiftType
  {
    init?(_ bool: Bool?)
    init(_ bool: Bool)
    init?<T:SDAI.BOOLEAN__TypeBehavior>(_ subtype: T?)
    init<T:SDAI.BOOLEAN__TypeBehavior>(_ subtype: T)
    init?<T:SDAI.LOGICAL__TypeBehavior>(_ logical: T?)
    init<T:SDAI.LOGICAL__TypeBehavior>(_ logical: T)
  }
}

public extension SDAI.BOOLEAN__TypeBehavior
{
	var possiblyAsSwiftBool: Bool? { return self.asSwiftType }
	var asSwiftBool: Bool { return self.asSwiftType }
	var isTRUE: Bool { return self.asSwiftType }
	var isFALSE: Bool { return !self.asSwiftType }
	var isUNKNOWN: Bool { return false }

	init(_ bool: Bool) {
		self.init(from: bool)
	}
	init?(_ bool: Bool?) {
		guard let bool = bool else { return nil }
		self.init(from: bool)
	}
	init(booleanLiteral value: Bool) {
		self.init(from: value)
	}
	init?<T:SDAI.BOOLEAN__TypeBehavior>(_ subtype: T?)	{
		guard let subtype = subtype else { return nil }
		self.init(from: subtype.asSwiftType)
	}
	init<T:SDAI.BOOLEAN__TypeBehavior>(_ subtype: T) {
		self.init(from: subtype.asSwiftType)
	}
	init?<T:SDAI.LOGICAL__TypeBehavior>(_ logical: T?) {
		guard let bool = logical?.asSwiftType else { return nil }
		self.init(from: bool)
	}
	init<T:SDAI.LOGICAL__TypeBehavior>(_ logical: T) {
		self.init(from: SDAI.UNWRAP(logical.asSwiftType) )
	}
}

extension SDAI {
	public struct BOOLEAN : SDAI.BOOLEAN__TypeBehavior, SDAIValue, CustomStringConvertible
	{
		public typealias SwiftType = Bool
		public typealias FundamentalType = Self
		private var rep: SwiftType
		
		// CustomStringConvertible
		public var description: String { "BOOLEAN(\( rep ? "TRUE" : "FALSE"))" }
		
		// SDAI.GenericType \SDAI.UnderlyingType\SDAI.SimpleType\SDAI__LOGICAL__type\SDAI__BOOLEAN__type
		public var typeMembers: Set<SDAI.STRING> {
			return [SDAI.STRING(from: Self.typeName), SDAI.STRING(from: LOGICAL.typeName)]
		}
		public var value: FundamentalType { return self.asFundamentalType }
		
		public var entityReference: SDAI.EntityReference? {nil}	
		public var stringValue: SDAI.STRING? {nil}
		public var binaryValue: SDAI.BINARY? {nil}
		public var logicalValue: SDAI.LOGICAL? { LOGICAL(self) }
		public var booleanValue: SDAI.BOOLEAN? { self }
		public var numberValue: SDAI.NUMBER? {nil}
		public var realValue: SDAI.REAL? {nil}
		public var integerValue: SDAI.INTEGER? {nil}
		public var genericEnumValue: SDAI.GenericEnumValue? {nil}
		
		public func arrayOptionalValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.ARRAY_OPTIONAL<ELEM>? {nil}
		public func arrayValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>? {nil}
		public func listValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.LIST<ELEM>? {nil}
		public func bagValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.BAG<ELEM>? {nil}
		public func setValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.SET<ELEM>? {nil}
		public func enumValue<ENUM:SDAI.EnumerationType>(enumType:ENUM.Type) -> ENUM? {nil}

		public static func validateWhereRules(
			instance:Self?,
			prefix:SDAIPopulationSchema.WhereLabel
		) -> SDAIPopulationSchema.WhereRuleValidationRecords { return [:] }

		
		// InitializableByGenerictype
		public init?<G: SDAI.GenericType>(fromGeneric generic: G?) {
			guard let booleanValue = generic?.booleanValue else { return nil }
			self.init(booleanValue)
		}

		// SDAI.UnderlyingType \SDAI.SimpleType\SDAI__LOGICAL__type\SDAI__BOOLEAN__type
		public static let typeName: String = "BOOLEAN"
		public var asSwiftType: SwiftType { return rep }
		
		// SDAI.GenericType
		public var asFundamentalType: FundamentalType { return self }
		public init(fundamental: FundamentalType) {
			self.init(fundamental.rep)
		}

		// SDAI.SimpleType \SDAI__LOGICAL__type\SDAI__BOOLEAN__type
		public init(from swiftValue: SwiftType) {
			rep = swiftValue
		}
		
		// SDAIValue
		public func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool 
		{
			if let rhs = rhs as? Self { return self == rhs }
			if let rhs = rhs as? SDAI.SwiftBoolConvertible { return self.possiblyAsSwiftBool == rhs.possiblyAsSwiftBool }
			return false
		}
		
		// InitializableByP21Parameter
		public static var bareTypeName: String { self.typeName }
		
		public init?(p21untypedParam: P21Decode.ExchangeStructure.UntypedParameter, from exchangeStructure: P21Decode.ExchangeStructure) {
			switch p21untypedParam {
			case .enumeration(let enumcase):
				switch enumcase {
				case "T":
					self.init(true)
					
				case "F":
					self.init(false)
					
				default:
					exchangeStructure.error = "unexpected p21parameter enum case(\(enumcase)) while resolving \(Self.bareTypeName) value [ref. 12.1.1.3 of ISO 10303-21]"
					return nil
				}
				
			case .rhsOccurrenceName(let rhsname):
				switch rhsname {
				case .constantValueName(let name):
					guard let generic = exchangeStructure.resolve(constantValueName: name) else {exchangeStructure.add(errorContext: "while resolving \(Self.bareTypeName) value"); return nil }
					guard let booleanValue = generic.booleanValue else { exchangeStructure.error = "constant value(\(name): \(generic)) is not compatible with \(Self.bareTypeName)"; return nil }
					self.init(booleanValue)
				
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
			self.init()
		}

	}
}

