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
  /// A protocol representing the EXPRESS `BOOLEAN` type as specified in ISO 10303-11 (8.1.5).
  ///
  /// Conforming types provide the interface for handling logical boolean values
  /// in the STEP data model, extending the requirements of `SDAI.LogicalType`.
  ///
  /// Use `BooleanType` to define types that encapsulate true/false logic
  /// in accordance with the EXPRESS specification, supporting interoperability
  /// with other logical types in the SDAI framework.
  public protocol BooleanType: SDAI.LogicalType
  {}
}

extension SDAI.TypeHierarchy {
  /// A protocol defining the EXPRESS `BOOLEAN` behavior in the SDAI type hierarchy.
  /// 
  /// `BOOLEAN__TypeBehavior` describes the requirements for types that model the EXPRESS `BOOLEAN`
  /// type as per ISO 10303-11 (8.1.5), extending `SDAI.BooleanType`. It standardizes 
  /// initialization and conversion from Swift `Bool` values and other EXPRESS logical types,
  /// ensuring consistent boolean semantics and interoperability within the SDAI framework.
  ///
  /// ### Conformance
  /// Conforming types must implement all required initializers, guarantee value-type semantics,
  /// and support type conversions and interoperability with related logical types.
  ///
  /// ### Initializers
  /// - `init?(_ bool: Bool?)`: Failable initializer from an optional Swift `Bool`.
  /// - `init(_ bool: Bool)`: Initializer from a Swift `Bool`.
  /// - `init?<T:SDAI.TypeHierarchy.BOOLEAN__TypeBehavior>(_ subtype: T?)`: Failable initializer from an optional subtype conforming to `BOOLEAN__TypeBehavior`.
  /// - `init<T:SDAI.TypeHierarchy.BOOLEAN__TypeBehavior>(_ subtype: T)`: Initializer from another subtype conforming to `BOOLEAN__TypeBehavior`.
  /// - `init?<T:SDAI.TypeHierarchy.LOGICAL__TypeBehavior>(_ logical: T?)`: Failable initializer from an optional logical value.
  /// - `init<T:SDAI.TypeHierarchy.LOGICAL__TypeBehavior>(_ logical: T)`: Initializer from another logical value.
  ///
  /// ### Associated Types
  /// - `FundamentalType`: The concrete type representing the EXPRESS `BOOLEAN`.
  /// - `Value`: The underlying boolean value type.
  /// - `SwiftType`: The native Swift `Bool` type.
  ///
  /// ### Usage
  /// Use this protocol to define types that provide EXPRESS-compliant boolean logic, supporting
  /// conversions from other logical types and integration with the SDAI type and value system.
  public protocol BOOLEAN__TypeBehavior: SDAI.BooleanType
  where FundamentalType == SDAI.BOOLEAN,
        Value == FundamentalType.Value,
        SwiftType == FundamentalType.SwiftType
  {
    init?(_ bool: Bool?)
    init(_ bool: Bool)
    init?<T:SDAI.TypeHierarchy.BOOLEAN__TypeBehavior>(_ subtype: T?)
    init<T:SDAI.TypeHierarchy.BOOLEAN__TypeBehavior>(_ subtype: T)
    init?<T:SDAI.TypeHierarchy.LOGICAL__TypeBehavior>(_ logical: T?)
    init<T:SDAI.TypeHierarchy.LOGICAL__TypeBehavior>(_ logical: T)
  }
}

public extension SDAI.TypeHierarchy.BOOLEAN__TypeBehavior
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
	init?<T:SDAI.TypeHierarchy.BOOLEAN__TypeBehavior>(_ subtype: T?)	{
		guard let subtype = subtype else { return nil }
		self.init(from: subtype.asSwiftType)
	}
	init<T:SDAI.TypeHierarchy.BOOLEAN__TypeBehavior>(_ subtype: T) {
		self.init(from: subtype.asSwiftType)
	}
	init?<T:SDAI.TypeHierarchy.LOGICAL__TypeBehavior>(_ logical: T?) {
		guard let bool = logical?.asSwiftType else { return nil }
		self.init(from: bool)
	}
	init<T:SDAI.TypeHierarchy.LOGICAL__TypeBehavior>(_ logical: T) {
		self.init(from: SDAI.UNWRAP(logical.asSwiftType) )
	}
}

extension SDAI {
  /// A concrete implementation of the EXPRESS `BOOLEAN` type as specified in ISO 10303-11 (8.1.5).
  ///
  /// `BOOLEAN` is a value type that represents logical Boolean (`true` or `false`) values within the
  /// STEP data model, in conformance with SDAI's type system. It provides interoperability
  /// with other logical and generic types defined in the SDAI framework, and is used to encapsulate
  /// true/false logic in EXPRESS schemas.
  ///
  /// ### Features
  /// - Represents standard Boolean logic with two states: `TRUE` or `FALSE`.
  /// - Provides conversion between Swift `Bool` and STEP `BOOLEAN` values.
  /// - Supports initialization from other SDAI logical types and P21 exchange parameters.
  /// - Implements the `SDAI.Value` protocol for type-erased value handling and comparison.
  /// - Conforms to `CustomStringConvertible` for readable debugging output.
  ///
  /// ### Usage
  /// Use `SDAI.BOOLEAN` for EXPRESS schema attributes, entity fields, and other contexts where a
  /// logical Boolean value is required by the STEP data model or ISO 10303-11 specification.
  ///
  /// ### Related Types
  /// - `SDAI.LOGICAL` — EXPRESS logical type supporting `TRUE`, `FALSE`, and `UNKNOWN`.
  /// - `SDAI.BooleanType` — The protocol defining the EXPRESS Boolean type interface.
	public struct BOOLEAN : SDAI.TypeHierarchy.BOOLEAN__TypeBehavior, SDAI.Value, CustomStringConvertible
	{
		public typealias SwiftType = Bool
		public typealias FundamentalType = Self
		private let rep: SwiftType
		
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
		
		// SDAI.Value
		public func isValueEqual<T: SDAI.Value>(to rhs: T) -> Bool 
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

