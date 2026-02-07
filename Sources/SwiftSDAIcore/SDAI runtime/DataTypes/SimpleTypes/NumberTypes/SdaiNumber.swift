//
//  SdaiNumber.swift
//  
//
//  Created by Yoshida on 2020/09/09.
//

import Foundation

extension SDAI {

  /// A protocol that represents numeric types suitable for use in the SDAI framework.
  /// 
  /// `NumberRepType` combines the capabilities of signed numbers and types that can be  
  /// traversed by a stride, making it suitable for representing both integer and floating-
  /// point numeric types. Conforming types must support arithmetic operations, comparison, 
  /// and stride-based operations.
  ///
  /// Types conforming to `NumberRepType` include standard Swift types like `Int` and `Double`.
  ///
  /// - Conforms To:
  ///   - `SignedNumeric`: Enables arithmetic operations and handling of signed values.
  ///   - `Strideable`: Enables calculation and traversal of values at regular intervals (strides).
  public protocol NumberRepType : SignedNumeric, Strideable
  {}
}

extension Double: SDAI.NumberRepType {}
extension Int: SDAI.NumberRepType {}

//MARK: - Double represented
extension SDAI {

  /// A protocol for types that can be represented as a `Double`.
  ///
  /// Types conforming to `DoubleRepresented` must provide a computed property, `asSwiftDouble`,
  /// exposing their value as a Swift `Double`. This enables conversion and interoperability
  /// with APIs and logic that operate on floating-point numbers, regardless of the underlying type.
  ///
  /// Conformance to this protocol is useful for types that natively store or can losslessly convert
  /// to a `Double` value, facilitating generic numeric operations within the SDAI framework.
  public protocol DoubleRepresented
  {
    var asSwiftDouble: Double {get}
  }
}

//MARK: - Int represented
extension SDAI {

  /// A protocol for types that can be represented as an `Int`.
  ///
  /// Types conforming to `IntRepresented` must provide a computed property, `asSwiftInt`,
  /// exposing their value as a Swift `Int`. This enables conversion and interoperability
  /// with APIs and logic that operate on integer values, regardless of the underlying type.
  ///
  /// Conformance to this protocol is useful for types that natively store or can losslessly convert
  /// to an `Int` value, facilitating generic numeric operations within the SDAI framework.
  ///
  /// - Conforms To:
  ///   - `SwiftDoubleConvertible`: Enables conversion to a `Double` representation.
  public protocol IntRepresented: SDAI.SwiftDoubleConvertible
  {
    var asSwiftInt: Int {get}
  }
}

//MARK: - Double convertible
extension SDAI {

  /// A protocol that enables types to provide a conversion to a `Double` value, either as a guaranteed or optional representation.
  ///
  /// Types conforming to `SwiftDoubleConvertible` must provide:
  /// - `possiblyAsSwiftDouble`: An optional `Double` value representing a possible conversion, or `nil` if conversion is not possible.
  /// - `asSwiftDouble`: A non-optional `Double` value representing the type as a `Double`, which may be lossy or undefined for some types.
  ///
  /// This protocol supports interoperability with APIs and computations that require floating-point representations, and is commonly adopted
  /// by numeric types within the SDAI framework as well as other types that can reasonably be expressed as a double-precision value.
  public protocol SwiftDoubleConvertible
  {
    var possiblyAsSwiftDouble: Double? {get}
    var asSwiftDouble: Double {get}
  }
}

extension Double: SDAI.SwiftDoubleConvertible, SDAI.DoubleRepresented
{
	public var asSwiftDouble: Double { return self }
	public var possiblyAsSwiftDouble: Double? { return self }
}

extension Int: SDAI.SwiftDoubleConvertible
{
	public var possiblyAsSwiftDouble: Double? { return Double(self) }
	public var asSwiftDouble: Double { return Double(self) }
}

public extension SDAI.SwiftDoubleConvertible
where Self: SDAI.DoubleRepresentedNumberType
{
	var possiblyAsSwiftDouble: Double? { return self.asSwiftType }
	var asSwiftDouble: Double { return self.asSwiftType }
}

public extension SDAI.SwiftDoubleConvertible
where Self: SDAI.IntRepresentedNumberType
{
	var possiblyAsSwiftDouble: Double? { return Double(self.asSwiftType) }
	var asSwiftDouble: Double { return Double(self.asSwiftType) }
}


//MARK: - Int convertible
extension SDAI {

  /// A protocol that enables types to provide a conversion to an `Int` value, either as a guaranteed or optional representation.
  /// 
  /// Types conforming to `SwiftIntConvertible` must provide:
  /// - `possiblyAsSwiftInt`: An optional `Int` value representing a possible conversion, or `nil` if conversion is not possible.
  /// - `asSwiftInt`: A non-optional `Int` value representing the type as an `Int`, which may be lossy or undefined for some types.
  /// 
  /// This protocol supports interoperability with APIs and computations that require integer representations, and is commonly adopted
  /// by numeric types within the SDAI framework as well as other types that can reasonably be expressed as an integer value.
  public protocol SwiftIntConvertible
  {
    var possiblyAsSwiftInt: Int? {get}
    var asSwiftInt: Int {get}
  }
}

extension Int: SDAI.SwiftIntConvertible, SDAI.IntRepresented
{
	public var asSwiftInt: Int { return self }
	public var possiblyAsSwiftInt: Int? { return self }
}

public extension SDAI.SwiftIntConvertible
where Self: SDAI.IntRepresentedNumberType
{
	var possiblyAsSwiftInt: Int? { return self.asSwiftType }
	var asSwiftInt: Int { return self.asSwiftType }
}


//MARK: - NUMBER type (8.1.1)
extension SDAI {

  /// A protocol representing the SDAI NUMBER type, providing a foundation for numeric values in the SDAI framework.
  ///
  /// `NumberType` conforms to several protocols to ensure compatibility with numeric operations, encoding/decoding, and
  /// interoperability with Swift's numeric system:
  /// - `SDAI.SimpleType`: Indicates conformance to SDAI's simple type requirements.
  /// - `ExpressibleByIntegerLiteral`: Allows initialization from integer literals.
  /// - `SDAI.SwiftDoubleConvertible`: Enables conversion of the value to a `Double` representation for numerical computations.
  /// - `SDAI.Initializable.ByVoid`: Supports initialization from an empty or void value.
  /// - The associated type `SwiftType` is constrained to `SDAI.NumberRepType`, which encompasses numeric types that are signed and support strides (e.g., `Int`, `Double`).
  ///
  /// Types conforming to `NumberType` serve as the basis for representing SDAI's general NUMBER type, which can model both integer
  /// and real (floating-point) values. This protocol is further refined by `DoubleRepresentedNumberType` and `IntRepresentedNumberType`
  /// for types that specifically represent real or integer numbers.
  ///
  public protocol NumberType: SDAI.SimpleType, ExpressibleByIntegerLiteral, SDAI.SwiftDoubleConvertible, SDAI.Initializable.ByVoid
  where SwiftType: SDAI.NumberRepType
  {}

  /// A protocol representing numeric types within the SDAI framework that are specifically 
  /// represented using a `Double` as their underlying storage type.
  /// 
  /// Conforming types:
  /// - Must also conform to `SDAI.NumberType`, ensuring they fulfill the general requirements 
  ///   for SDAI numeric values, including initialization, encoding/decoding, and Swift numeric 
  ///   compatibility.
  /// - Must conform to `SDAI.DoubleRepresented`, exposing their value as a Swift `Double`, which
  ///   enables efficient interoperability with floating-point APIs and logic.
  /// - Have `SwiftType` constrained as `Double`, guaranteeing the underlying data representation
  ///   and supporting generic numeric operations that require floating-point semantics.
  ///
  /// This protocol is intended for types that model real numbers or other values that are best
  /// represented as doubles, and enables specialized handling of such types in generic numeric
  /// contexts within the SDAI framework.
  ///
  public protocol DoubleRepresentedNumberType: SDAI.NumberType, SDAI.DoubleRepresented
  where SwiftType == Double
  {}

  /// A protocol representing numeric types within the SDAI framework that are specifically 
  /// represented using an `Int` as their underlying storage type.
  /// 
  /// Conforming types:
  /// - Must also conform to `SDAI.NumberType`, ensuring they fulfill the general requirements 
  ///   for SDAI numeric values, including initialization, encoding/decoding, and Swift numeric 
  ///   compatibility.
  /// - Must conform to `SDAI.IntRepresented`, exposing their value as a Swift `Int`, which
  ///   enables efficient interoperability with integer-based APIs and logic.
  /// - Have `SwiftType` constrained as `Int`, guaranteeing the underlying data representation
  ///   and supporting generic numeric operations that require integer semantics.
  ///
  /// This protocol is intended for types that model integer numbers or other values that are best
  /// represented as integers, and enables specialized handling of such types in generic numeric
  /// contexts within the SDAI framework.
  ///
  public protocol IntRepresentedNumberType: SDAI.NumberType, SDAI.IntRepresented
  where SwiftType == Int
  {}
}

extension SDAI.TypeHierarchy {
  /// A protocol describing the core numeric type behavior for types modeled as `NUMBER`
  /// in the SDAI framework's type hierarchy.
  ///
  /// `NUMBER__TypeBehavior` unifies key capabilities needed by types representing general
  /// numeric values, including double-precision real numbers and exact integers, as 
  /// specified by the EXPRESS `NUMBER` supertype. Types conforming to this protocol
  /// bridge between the abstract SDAI type system and underlying Swift numeric values,
  /// supporting conversion, initialization, and literal expressibility.
  ///
  /// ### Key Capabilities
  /// - Inherits from `SDAI.DoubleRepresentedNumberType`, ensuring conformance to
  ///   protocols for numeric operations, value conversion, and generic handling within
  ///   the SDAI framework.
  /// - Requires conformance to `ExpressibleByFloatLiteral`, enabling initialization
  ///   from Swift floating-point literals, as well as support for integer literals
  ///   via inherited protocols.
  /// - Defines initializers to construct values from `Double`, `Int`, or other
  ///   `SDAI.NumberType` values, with both optional and non-optional forms, supporting
  ///   broad numeric interoperability.
  /// - Specifies that adopting types use `SDAI.NUMBER` as their fundamental type, and
  ///   that their value representation matches that of the fundamental type.
  ///
  /// ### Associated Types and Constraints
  /// - `FundamentalType` must be `SDAI.NUMBER`, aligning the type with the EXPRESS
  ///   NUMBER supertype and supporting type-safe numeric polymorphism.
  /// - `Value` must be identical to `FundamentalType`.
  ///
  /// ### Usage
  /// Conform to `NUMBER__TypeBehavior` when defining types that must support general
  /// numeric value semantics as defined by the EXPRESS `NUMBER` type, enabling full
  /// literal expressibility, numeric conversion, and value bridging with both integer
  /// and real number representations.
  ///
  /// - SeeAlso: `SDAI.NUMBER`, `SDAI.DoubleRepresentedNumberType`, `SDAI.NumberType`
  ///
  public protocol NUMBER__TypeBehavior: SDAI.DoubleRepresentedNumberType, ExpressibleByFloatLiteral
  where FundamentalType == SDAI.NUMBER,
        Value == FundamentalType.Value
  {
    init?(_ double: Double?)
    init(_ double: Double)
    init?(_ int: Int?)
    init(_ int: Int)
    init?<T:SDAI.NumberType>(_ subtype: T?)
    init<T:SDAI.NumberType>(_ subtype: T)
  }
}

public extension SDAI.TypeHierarchy.NUMBER__TypeBehavior
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
	init?<T:SDAI.NumberType>(_ subtype: T?) {
		guard let subtype = subtype else { return nil }
		self.init(from: subtype.asSwiftDouble)
	}
	init<T:SDAI.NumberType>(_ subtype: T) {
		self.init(from: subtype.asSwiftDouble)
	}
}

extension SDAI {
  
  /// A Swift struct representing the SDAI `NUMBER` type, which models general numeric values in the SDAI framework.
  ///
  /// The `NUMBER` type in SDAI is a fundamental numeric type that acts as a supertype for both integer and real (floating-point) values.
  /// The `NUMBER` struct is designed for use in EXPRESS-driven data modeling contexts, and serves as the basis for values that may be
  /// either integer or real, but are not known to be specifically one or the other.
  ///
  /// ### Key Features
  /// - **Double Representation:** Internally, `NUMBER` stores its value as a `Double`, which allows for efficient, lossless interchange
  ///   with both integer and real-valued SDAI types and supports a wide range of numeric operations.
  /// - **Type Conformance:**
  ///   - `SDAI.TypeHierarchy.NUMBER__TypeBehavior`: Provides the core numeric and conversion behaviors for the type.
  ///   - `SDAI.Value`: Integrates the type with SDAI's value semantics and generic handling.
  ///   - `CustomStringConvertible`: Allows for a string representation of the value, useful for debugging and display.
  /// - **Literal Expressibility:** Can be initialized directly from integer and floating-point literals for convenience.
  ///
  /// ### Initializers
  /// - Can be initialized from Swift `Double` or `Int` values.
  /// - Can be created from other SDAI number types (e.g., `REAL`, `INTEGER`), enabling seamless numeric conversions within the framework.
  /// - Provides initializers for EXPRESS P21 file decoding, supporting integration with STEP/IFC data exchange.
  ///
  /// ### Value Access
  /// - Provides computed properties for accessing the value as `Double`, and, where possible, as `Int` (if the value is an exact integer).
  /// - Supports conversion to related types, such as `REAL` and `INTEGER`, when meaningful and lossless.
  ///
  /// ### Usage
  /// Use `NUMBER` when representing a numeric value whose specific type (integer or real) may not be determined in advance, or when
  /// interoperating with EXPRESS schemas that utilize the general `NUMBER` supertype.
  ///
  /// ### Example
  /// ```swift
  /// let n1: SDAI.NUMBER = 42
  /// let n2: SDAI.NUMBER = 3.14159
  /// let sum = n1.asSwiftDouble + n2.asSwiftDouble
  /// ```
  ///
  /// - SeeAlso: `SDAI.REAL`, `SDAI.INTEGER`, `SDAI.DoubleRepresentedNumberType`, `SDAI.IntRepresentedNumberType`
  ///
	public struct NUMBER: SDAI.TypeHierarchy.NUMBER__TypeBehavior, SDAI.Value, CustomStringConvertible
	{
		public typealias SwiftType = Double
		public typealias FundamentalType = Self
		private let rep: SwiftType

		//MARK: CustomStringConvertible
		public var description: String { "NUMBER(\(rep))" }
		
		//MARK: SDAI.GenericType \SDAI.UnderlyingType\SDAI.SimpleType\SDAI__NUMBER__type
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



		//MARK: InitializableByGenerictype
		public init?<G: SDAI.GenericType>(fromGeneric generic: G?) {
			guard let numberValue = generic?.numberValue else { return nil }
			self.init(numberValue)
		}
		
		
		//MARK: SDAI.UnderlyingType \SDAI.SimpleType\SDAI__NUMBER__type
		public static let typeName: String = "NUMBER"
		public var asSwiftType: SwiftType { return rep }
		
		//MARK: SDAI.GenericType
		public var asFundamentalType: FundamentalType { return self }
		public init(fundamental: FundamentalType) {
			self.init(fundamental.rep)
		}


		//MARK: SDAI.SimpleType \SDAI__NUMBER__type
		public init(from swiftValue: SwiftType) {
			rep = swiftValue
		}
		
		//MARK: SDAI.Value
		public func isValueEqual<T: SDAI.Value>(to rhs: T) -> Bool
		{
			if let rhs = rhs as? Self { return self == rhs }
			if let rhs = rhs as? SDAI.SwiftDoubleConvertible { return self.asSwiftDouble == rhs.asSwiftDouble }
			return false
		}
		
		//MARK: InitializableByP21Parameter
		public static var bareTypeName: String { self.typeName }
		
		public init?(p21untypedParam: P21Decode.ExchangeStructure.UntypedParameter, from exchangeStructure: P21Decode.ExchangeStructure) {
			switch p21untypedParam {
			case .real(let realval):
				self.init(realval)

      case .integer(let intval):
        self.init(intval)

			case .rhsOccurrenceName(let rhsname):
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
			self.init()
		}

	}
}

