//
//  SdaiInteger.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation


//MARK: - INTEGER type (8.1.3)
extension SDAI {
  public protocol IntegerType: SDAI.RealType, SDAI.SwiftIntConvertible
  {}
}

extension SDAI {
  public protocol INTEGER__TypeBehavior: SDAI.IntegerType, SDAI.IntRepresentedNumberType
  where FundamentalType == SDAI.INTEGER,
        Value == FundamentalType.Value
  {
    init?(_ int: Int?)
    init(_ int: Int)
    init?<T:SDAI.IntegerType>(_ subtype: T?)
    init<T:SDAI.IntegerType>(_ subtype: T)
  }
}

public extension SDAI.INTEGER__TypeBehavior
{
	var asSwiftInt: Int { return self.asSwiftType }
	var asSwiftDouble: Double { return Double(self.asSwiftType) }

	init?(_ int: Int?) {
		guard let int = int else { return nil }
		self.init(from: int)
	}
	init(_ int: Int) {
		self.init(from: int)
	}

	init(integerLiteral value: Int) {
		self.init(from: value)
	}
	init?<T:SDAI.IntegerType>(_ subtype: T?) {
		guard let subtype = subtype else { return nil }
		self.init(from: subtype.asSwiftInt)
	}
	init<T:SDAI.IntegerType>(_ subtype: T) {
		self.init(from: subtype.asSwiftInt)
	}
}

extension SDAI {
	public struct INTEGER: SDAI.INTEGER__TypeBehavior, SDAI.Value, CustomStringConvertible
	{
		public typealias SwiftType = Int
		public typealias FundamentalType = Self
		private var rep: SwiftType

		// CustomStringConvertible
		public var description: String { "INTEGER(\(rep))" }
		
		// SDAI.GenericType \SDAI.UnderlyingType\SDAI.SimpleType\SDAI__NUMBER__type\SDAI__REAL__type\SDAI__INTEGER__type
		public var typeMembers: Set<SDAI.STRING> {
			return [SDAI.STRING(from: Self.typeName), SDAI.STRING(from: REAL.typeName), SDAI.STRING(from: NUMBER.typeName)]
		}
		public var value: FundamentalType { return self.asFundamentalType }
		
		public var entityReference: SDAI.EntityReference? {nil}	
		public var stringValue: SDAI.STRING? {nil}
		public var binaryValue: SDAI.BINARY? {nil}
		public var logicalValue: SDAI.LOGICAL? {nil}
		public var booleanValue: SDAI.BOOLEAN? {nil}
		public var numberValue: SDAI.NUMBER? { NUMBER(self) }
		public var realValue: SDAI.REAL? { REAL(self) }
		public var integerValue: SDAI.INTEGER? { self }
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
			guard let integerValue = generic?.integerValue else { return nil }
			self.init(integerValue)
		}
		
		// SDAI.UnderlyingType \SDAI.SimpleType\SDAI__NUMBER__type\SDAI__REAL__type\SDAI__INTEGER__type
		public static let typeName: String = "INTEGER"
		public var asSwiftType: SwiftType { return rep }
		
		// SDAI.GenericType
		public var asFundamentalType: FundamentalType { return self }
		public init(fundamental: FundamentalType) {
			self.init(fundamental.rep)
		}

		// SDAI.SimpleType \SDAI__NUMBER__type\SDAI__REAL__type\SDAI__INTEGER__type
		public init(from swiftValue: SwiftType) {
			rep = swiftValue
		}
		
		// SDAI.Value
		public func isValueEqual<T: SDAI.Value>(to rhs: T) -> Bool 
		{
			if let rhs = rhs as? Self { return self == rhs }
			if let rhs = rhs as? SDAI.SwiftIntConvertible { return self.asSwiftInt == rhs.asSwiftInt }
			return false
		}
		
		// INTEGER specific
		public init?(truncating real: SDAI.DoubleRepresented?) {
			guard let double = real?.asSwiftDouble else { return nil }
			self.init(Int(double))
		}
		
		// InitializableByP21Parameter
		public static var bareTypeName: String { self.typeName }
		
		public init?(p21untypedParam: P21Decode.ExchangeStructure.UntypedParameter, from exchangeStructure: P21Decode.ExchangeStructure) {
			switch p21untypedParam {
			case .integer(let intval):
				self.init(intval)
				
			case .rhsOccurrenceName(let rhsname):
				switch rhsname {
				case .constantValueName(let name):
					guard let generic = exchangeStructure.resolve(constantValueName: name) else {exchangeStructure.add(errorContext: "while resolving \(Self.bareTypeName) value"); return nil }
					guard let integerValue = generic.integerValue else { exchangeStructure.error = "constant value(\(name): \(generic)) is not compatible with \(Self.bareTypeName)"; return nil }
					self.init(integerValue)
				
				case .valueInstanceName(let name):
					guard let param = exchangeStructure.resolve(valueInstanceName: name) else {exchangeStructure.add(errorContext: "while resolving \(Self.bareTypeName) value from \(rhsname)"); return nil }
					self.init(p21param: param, from: exchangeStructure)
					
				default:
					exchangeStructure.error = "unexpected p21parameter(\(p21untypedParam)) while resolving \(Self.bareTypeName) value"
					return nil
				}
							
			case .noValue:
				return nil

      case .real(let realval):
          if let intval = NUMBER(realval).integerValue {
            self.init(intval)
          }
          else {
            exchangeStructure.error = "unexpected p21parameter(\(p21untypedParam)) while resolving \(Self.bareTypeName) value"
            return nil
          }

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


