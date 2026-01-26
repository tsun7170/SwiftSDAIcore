//
//  SdaiLogical.swift
//  
//
//  Created by Yoshida on 2020/09/09.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAI {
  /// A protocol that defines conversion to a Swift `Bool` value.
  /// 
  /// Types conforming to `SwiftBoolConvertible` provide access to their value as an optional or non-optional Swift `Bool`.
  /// This enables interoperability between custom logical or boolean types and standard Swift boolean logic.
  /// 
  /// - Properties:
  ///   - possiblyAsSwiftBool: Returns the value as a Swift `Bool?`, or `nil` if the value is unknown or undefined.
  ///   - asSwiftBool: Returns the value as a non-optional Swift `Bool`. 
  ///     May provide a default value (e.g., `false`) or otherwise unwrap when the value is not representable as a standard `Bool`.
  public protocol SwiftBoolConvertible
  {
    var possiblyAsSwiftBool: Bool? {get}
    var asSwiftBool: Bool {get}
  }
}

//MARK: - LOGICAL type (8.1.4)
extension SDAI {
  /// A protocol that defines the behavior and requirements of the EXPRESS `LOGICAL` type (section 8.1.4).
  ///
  /// Conforming types represent logical values which may be `TRUE`, `FALSE`, or `UNKNOWN` (i.e., indeterminate).
  ///
  /// Types adopting `LogicalType` must support interoperability with Swift boolean logic and initialization from boolean literals.
  /// - Inherits from:
  ///    - `SDAI.SimpleType`: Ensures EXPRESS simple type behavior.
  ///    - `ExpressibleByBooleanLiteral`: Enables initialization from Swift `true` or `false`.
  ///    - `SDAI.SwiftBoolConvertible`: Allows conversion to Swift `Bool` and `Bool?`.
  ///    - `SDAI.Initializable.ByVoid`: Allows initialization with no arguments, typically for an `UNKNOWN` value.
  ///
  /// - Properties:
  ///   - `isTRUE`: `true` if the value is logically `TRUE`, `false` otherwise.
  ///   - `isFALSE`: `true` if the value is logically `FALSE`, `false` otherwise.
  ///   - `isUNKNOWN`: `true` if the value is logically `UNKNOWN`, `false` otherwise.
  ///   - `possiblyAsSwiftBool`: Returns the value as an optional Swift `Bool?`, or `nil` if the value is `UNKNOWN`.
  public protocol LogicalType: SDAI.SimpleType, ExpressibleByBooleanLiteral,
                                   SDAI.SwiftBoolConvertible, SDAI.Initializable.ByVoid
  {
    var isTRUE: Bool {get}
    var isFALSE: Bool {get}
    var isUNKNOWN: Bool {get}
    var possiblyAsSwiftBool: Bool? {get}
  }
}

extension SDAI.TypeHierarchy {
  /// A protocol that defines the core behavior and requirements for types representing the EXPRESS `LOGICAL` type.
  /// 
  /// Conforming types provide tri-state logical semantics—`TRUE`, `FALSE`, and `UNKNOWN`—as well as interoperability
  /// with Swift's boolean types and nil literal expressibility.
  /// 
  /// This protocol is intended for use with types that act as fundamental representations of EXPRESS LOGICAL values,
  /// and is used by ``SDAI.LOGICAL`` and its related type hierarchy.
  /// 
  /// - Inherits from:
  ///   - ``SDAI.LogicalType``: Ensures EXPRESS logical semantics and Swift boolean interoperability.
  ///   - `ExpressibleByNilLiteral`: Allows initialization from `nil` to represent `UNKNOWN`.
  /// 
  /// - Associated Types:
  ///   - `FundamentalType`: The underlying concrete EXPRESS LOGICAL type.
  ///   - `Value`: The logical value type (typically matches `FundamentalType.Value`).
  ///   - `SwiftType`: The matching Swift type for the logical value (typically `Bool?`).
  /// 
  /// - Initializers:
  ///   - `init(_ bool: Bool?)`: Initializes from a Swift optional boolean. `nil` represents `UNKNOWN`.
  ///   - `init<T:SDAI.LogicalType>(_ subtype: T?)`: Initializes from another EXPRESS logical type (optional).
  ///   - `init<T:SDAI.LogicalType>(_ subtype: T)`: Initializes from another EXPRESS logical type.
  /// 
  /// - Usage:
  ///   - Use for implementing custom types or wrappers conforming to EXPRESS LOGICAL semantics,
  ///     ensuring full interoperability between Swift and EXPRESS representations in STEP schemas.
  public protocol LOGICAL__TypeBehavior: SDAI.LogicalType, ExpressibleByNilLiteral
  where FundamentalType == SDAI.LOGICAL,
        Value == FundamentalType.Value,
        SwiftType == FundamentalType.SwiftType
  {
    init(_ bool: Bool?)
    init<T:SDAI.LogicalType>(_ subtype: T?)
    init<T:SDAI.LogicalType>(_ subtype: T)
  }
}

public extension SDAI.TypeHierarchy.LOGICAL__TypeBehavior
{
	var possiblyAsSwiftBool: Bool? { return self.asSwiftType }
	var asSwiftBool: Bool { return SDAI.UNWRAP(self.possiblyAsSwiftBool) }
	var isTRUE: Bool { return self.asSwiftType ?? false }
	var isFALSE: Bool { return !(self.asSwiftType ?? true) }
	var isUNKNOWN: Bool { return self.asSwiftType == nil }

	init(_ bool: Bool?) {
		self.init(from: bool)
	}

	init(booleanLiteral value: Bool) {
		self.init(from: value)
	}
	init(nilLiteral: ()) {
		self.init(from: nil as SwiftType)
	}
	init<T:SDAI.LogicalType>(_ subtype: T?) {
		self.init(from: subtype?.possiblyAsSwiftBool)
	}
	init<T:SDAI.LogicalType>(_ subtype: T) {
		self.init(from: subtype.possiblyAsSwiftBool)
	}
}

extension SDAI {
  /// Represents the EXPRESS `LOGICAL` type, which can be `TRUE`, `FALSE`, or `UNKNOWN`.
  /// 
  /// The `LOGICAL` type models three-valued logic, where a value may be explicitly `true`, `false`, or indeterminate/unknown (`nil`).
  /// It is used to interoperate with EXPRESS schemas and files, such as ISO 10303-21 ("STEP") data.
  /// 
  /// - Conforms to:
  ///   - ``SDAI.TypeHierarchy.LOGICAL__TypeBehavior``: Provides EXPRESS LOGICAL semantics and Swift interoperability.
  ///   - ``SDAI.Value``: Allows for EXPRESS value comparison and manipulation.
  ///   - `CustomStringConvertible`: Presents human-readable descriptions for debugging and logging.
  /// 
  /// - Type Aliases:
  ///   - `SwiftType`: The associated Swift type, which is `Bool?`.
  ///   - `FundamentalType`: Self-referential; used for generic constraints.
  /// 
  /// - Properties:
  ///   - `rep`: The internal representation, as a `Bool?` — `true`, `false`, or `nil` for `UNKNOWN`.
  ///   - `typeMembers`: The set of EXPRESS type names for this value.
  ///   - `value`: The fundamental value for generic processing.
  ///   - `entityReference`, `stringValue`, `binaryValue`, `logicalValue`, etc.: EXPRESS-typed value accessors for type-safe conversions.
  ///   - `asSwiftType`: The value as a Swift `Bool?`.
  ///   - `asFundamentalType`: The value as its fundamental type.
  /// 
  /// - Initialization:
  ///   - From a Swift `Bool?`, another EXPRESS logical type, a cardinal value, or from STEP/P21 exchange structure parameters.
  ///   - Supports initialization as `UNKNOWN` (i.e., `nil`) with a default initializer.
  /// 
  /// - EXPRESS Interoperability:
  ///   - Implements parsing and mapping of STEP/P21 file representation (`.enumeration`, `.rhsOccurrenceName`, `.noValue`).
  ///   - Supports conversion to and from cardinal values (e.g., 0 = `FALSE`, 2 = `TRUE`, others = `UNKNOWN`).
  /// 
  /// - Logical Value Operations:
  ///   - Supports value comparison (`isValueEqual`) with other EXPRESS types or Swift logical values.
  ///   - Provides methods for working with arrays, lists, bags, and sets, though these return `nil` as `LOGICAL` is scalarlike.
  /// 
  /// - Usage:
  ///   - Use `LOGICAL(true)` or `LOGICAL(false)` for definite values, or `LOGICAL()`/`LOGICAL(nil)` for `UNKNOWN`.
  ///   - Useful when EXPRESS logic needs to be mapped into or out of Swift code with support for indeterminate values.
	public struct LOGICAL : SDAI.TypeHierarchy.LOGICAL__TypeBehavior, SDAI.Value, CustomStringConvertible
	{
		
		public typealias SwiftType = Bool?
		public typealias FundamentalType = Self
		private let rep: SwiftType
		
		// CustomStringConvertible
		public var description: String { 
			if let bool = rep {
				return "LOGICAL(\(bool ? "TRUE" : "FALSE"))" 
			}
			else {
				return "LOGICAL(UNKNOWN)" 
			}
		}
		
		// SDAI.GenericType \SDAI.UnderlyingType\SDAI.SimpleType\SDAI__LOGICAL__type
		public var typeMembers: Set<SDAI.STRING> {
			return [SDAI.STRING(from: Self.typeName)]
		}
		public var value: FundamentalType { return self.asFundamentalType }
		
		public var entityReference: SDAI.EntityReference? {nil}	
		public var stringValue: SDAI.STRING? {nil}
		public var binaryValue: SDAI.BINARY? {nil}
		public var logicalValue: SDAI.LOGICAL? { self }
    public var booleanValue: SDAI.BOOLEAN? {
      if let bool = self.rep {
        return BOOLEAN(from: bool)
      }
      return nil
    }
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
			guard let logicalValue = generic?.logicalValue else { return nil }
			self.init(logicalValue)
		}

		// SDAI.UnderlyingType \SDAI.SimpleType\SDAI__LOGICAL__type
		public static let typeName: String = "LOGICAL"
		public var asSwiftType: SwiftType { return rep }
		
		// SDAI.GenericType
		public var asFundamentalType: FundamentalType { return self }
		public init(fundamental: FundamentalType) {
			self.init(fundamental.rep)
		}

		// SDAI.SimpleType \SDAI__LOGICAL__type
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
		
		// LIGICAL specific
		public init(fromCardinal cardinal: Int) {
			var bool: Bool? = nil
			switch cardinal {
			case 0: bool = false
			case 2: bool = true
			default:bool = nil
			}
			self.init(bool)
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
					
				case "U":
					self.init(nil as SwiftType)
					
				default:
					exchangeStructure.error = "unexpected p21parameter enum case(\(enumcase)) while resolving \(Self.bareTypeName) value [ref. 12.1.1.4 of ISO 10303-21]"
					return nil
				}
				
			case .rhsOccurrenceName(let rhsname):
				switch rhsname {
				case .constantValueName(let name):
					guard let generic = exchangeStructure.resolve(constantValueName: name) else {exchangeStructure.add(errorContext: "while resolving \(Self.bareTypeName) value"); return nil }
					guard let logicalValue = generic.logicalValue else { exchangeStructure.error = "constant value(\(name): \(generic)) is not compatible with \(Self.bareTypeName)"; return nil }
					self.init(logicalValue)
				
				case .valueInstanceName(let name):
					guard let param = exchangeStructure.resolve(valueInstanceName: name) else {exchangeStructure.add(errorContext: "while resolving \(Self.bareTypeName) value from \(rhsname)"); return nil }
					self.init(p21param: param, from: exchangeStructure)
					
				default:
					exchangeStructure.error = "unexpected p21parameter(\(p21untypedParam)) while resolving \(Self.bareTypeName) value"
					return nil
				}
												
			case .noValue:
				self.init(nil as SwiftType)
				
			default:
				exchangeStructure.error = "unexpected p21parameter(\(p21untypedParam)) while resolving \(Self.bareTypeName) value"
				return nil
			}
		}

		public init(p21omittedParamfrom exchangeStructure: P21Decode.ExchangeStructure) {
			self.init()
		}

    public init() {
      self.init(nil as SwiftType)
    }
	}
}


