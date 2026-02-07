//
//  SdaiBinary.swift
//  
//
//  Created by Yoshida on 2020/09/11.
//

import Foundation

//MARK: - BINARY type (8.1.7)
extension SDAI {
  /// A protocol representing a binary value, corresponding to the EXPRESS BINARY type (ISO 10303-11:8.1.7).
  ///
  /// This type is used for modeling sequences of bits, with methods for accessing individual bits or bit ranges.
  /// Types conforming to `BinaryType` must also conform to `SDAI.SimpleType`, `ExpressibleByStringLiteral`, and `SDAI.Initializable.ByVoid`.
  ///
  /// Conformance Requirements:
  /// - `StringLiteralType` must be `String`.
  ///
  /// - Note: The indices for bit access are 1-based, following the EXPRESS language specification.
  ///
  /// ## Properties
  ///
  /// - `blength`: The number of bits contained in the binary value. For example, a binary value of `%10110` has a `blength` of 5.
  ///
  /// ## Subscripts
  ///
  /// - `subscript<I: SDAI.TypeHierarchy.INTEGER__TypeBehavior>(index: I?) -> SDAI.BINARY?`
  ///   Accesses the bit at the specified (1-based) index as a new `BINARY` instance containing a single bit.
  ///   Returns `nil` if the index is `nil` or out of bounds.
  ///
  /// - `subscript(index: Int?) -> SDAI.BINARY?`
  ///   Accesses the bit at the specified (1-based) index as a new `BINARY` instance containing a single bit.
  ///   Returns `nil` if the index is `nil` or out of bounds.
  ///
  /// - `subscript(range: ClosedRange<Int>?) -> SDAI.BINARY?`
  ///   Accesses a sequence of bits at the specified (1-based) closed range as a new `BINARY` instance containing those bits.
  ///   Returns `nil` if the range is `nil`, the lower bound is less than 1, or the upper bound exceeds the bit length.
  ///
  public protocol BinaryType: SDAI.SimpleType, ExpressibleByStringLiteral,
                                  SDAI.Initializable.ByVoid
  where StringLiteralType == String
  {
    /// The number of bits contained in the binary value.
    /// 
    /// This property returns the length of the binary sequence, representing how many individual bits are present.
    /// For example, a binary value of `%10110` has a `blength` of 5.
    /// 
    /// - Returns: The total count of bits in the binary value.
    ///
    var blength: Int {get}

    /// Accesses the bit at the specified (1-based) index as a new `BINARY` instance containing a single bit.
    /// 
    /// - Parameter index: The (1-based) index of the bit to access. If the index is `nil` or out of bounds (less than 1 or greater than the bit length), returns `nil`.
    /// - Returns: A new `BINARY` instance containing the bit at the specified index, or `nil` if the index is invalid.
    ///
    subscript<I: SDAI.TypeHierarchy.INTEGER__TypeBehavior>(index: I?) -> SDAI.BINARY? {get}

    /// Accesses the bit at the specified (1-based) index as a new `BINARY` instance containing a single bit.
    ///
    /// - Parameter index: The (1-based) index of the bit to access. If the index is `nil` or out of bounds (less than 1 or greater than the bit length), returns `nil`.
    /// - Returns: A new `BINARY` instance containing the bit at the specified index, or `nil` if the index is invalid.
    ///
    subscript(index: Int?) -> SDAI.BINARY? {get}

    /// Accesses a sequence of bits at the specified (1-based) closed range as a new `BINARY` instance containing those bits.
    /// 
    /// - Parameter range: The (1-based) closed range of bit indices to access. If the range is `nil`, the lower bound is less than 1, or the upper bound exceeds the bit length, returns `nil`.
    /// - Returns: A new `BINARY` instance containing the bits within the specified range, or `nil` if the range is invalid.
    ///
    subscript(range: ClosedRange<Int>?) -> SDAI.BINARY? {get}

  }
}

public extension SDAI.BinaryType
{
	subscript<I: SDAI.TypeHierarchy.INTEGER__TypeBehavior>(index: I?) -> SDAI.BINARY? { return self[index?.asSwiftType] }
}


extension SDAI.TypeHierarchy {
  /// A protocol defining EXPRESS BINARY type behavior for concrete types in the type hierarchy.
  ///
  /// Conforming types must represent an immutable sequence of bits (0 or 1), with initialization from string literals or other BINARY type values.
  /// Types conforming to `BINARY__TypeBehavior` are required to implement the fundamental EXPRESS BINARY protocol requirements,
  /// including conformance to `SDAI.BinaryType`, and must specify typealiases for their fundamental and Swift representations.
  ///
  /// ## Associated Types and Constraints
  /// - `FundamentalType`: Must be `SDAI.BINARY`.
  /// - `Value`: Must be the same as `FundamentalType.Value`.
  /// - `SwiftType`: Must be the same as `FundamentalType.SwiftType`.
  ///
  /// ## Initializers
  /// - `init?(_ string: String?)`: Initializes from an optional string, or returns `nil` if invalid.
  /// - `init(_ string: String)`: Initializes from a non-optional string.
  /// - `init?<T: SDAI.TypeHierarchy.BINARY__TypeBehavior>(_ subtype: T?)`: Initializes from an optional BINARY subtype, or returns `nil` if invalid.
  /// - `init<T: SDAI.TypeHierarchy.BINARY__TypeBehavior>(_ subtype: T)`: Initializes from another BINARY subtype.
  ///
  /// ## Instance Properties
  /// - `width: SDAIDictionarySchema.Bound?`: Describes the upper bound (maximum length) of the binary value for this instance, or `nil` if unbounded.
  ///   This value may differ per instance and indicates the maximum allowed length of the binary sequence.
  /// - `fixedWidth: SDAI.BOOLEAN`: Indicates whether this binary value instance has a fixed width (`true`) or variable width (`false`).
  ///   This is an instance-level property representing the semantics of the binary data.
  ///
  /// ## Notes
  /// - This protocol enables the implementation of derived BINARY types with specific width constraints or semantics as required by EXPRESS schemas.
  /// - All conforming types must ensure validity of their bit representation and handle initialization and type conversion according to EXPRESS rules.
  /// - Conformance to this protocol does not imply mutability; all BINARY values should be treated as immutable after creation.
  /// - The `width` and `fixedWidth` instance properties allow modeling both bounded and unbounded, as well as fixed or variable length binary values on a per-instance basis.
  public protocol BINARY__TypeBehavior: SDAI.BinaryType
  where FundamentalType == SDAI.BINARY,
        Value == FundamentalType.Value,
        SwiftType == FundamentalType.SwiftType
  {
    //MARK: init from FundamentalType
    init?<I: SDAI.SwiftIntConvertible>(
      width:I?, fixed:Bool,  fundamental:FundamentalType?)
    init<I: SDAI.SwiftIntConvertible>(
      width:I?, fixed:Bool,  fundamental:FundamentalType)

    //MARK: init from String
    init?(_ string: String?)
    init(_ string: String)

    init?<I: SDAI.SwiftIntConvertible>(
      width:I?, _ string:String?)
    init<I: SDAI.SwiftIntConvertible>(
      width:I?,  _ string:String)

    init?<I: SDAI.SwiftIntConvertible>(
      width:I?, fixed:Bool, _ string:String?)
    init<I: SDAI.SwiftIntConvertible>(
      width:I?, fixed:Bool, _ string:String)


    //MARK: init from subtype
    init?<T:SDAI.TypeHierarchy.BINARY__TypeBehavior>(_ subtype: T?)
    init<T:SDAI.TypeHierarchy.BINARY__TypeBehavior>(_ subtype: T)

    init?<T:SDAI.TypeHierarchy.BINARY__TypeBehavior,I: SDAI.SwiftIntConvertible>(
      width:I?, _ subtype: T?)
    init<T:SDAI.TypeHierarchy.BINARY__TypeBehavior,I: SDAI.SwiftIntConvertible>(
      width:I?, _ subtype: T)

    init?<T:SDAI.TypeHierarchy.BINARY__TypeBehavior,I: SDAI.SwiftIntConvertible>(
      width:I?, fixed:Bool, _ subtype: T?)
    init<T:SDAI.TypeHierarchy.BINARY__TypeBehavior,I: SDAI.SwiftIntConvertible>(
      width:I?, fixed:Bool, _ subtype: T)


    var width: SDAIDictionarySchema.Bound? {get}
    var fixedWidth: SDAI.BOOLEAN {get}
  }
}

public extension SDAI.TypeHierarchy.BINARY__TypeBehavior
{
  init?<I: SDAI.SwiftIntConvertible>(
    width: I?, fixed: Bool, fundamental: FundamentalType?)
  {
    guard let fundamental = fundamental else { return nil }
    self.init(width:width, fixed: fixed, fundamental)
  }


  init(_ string: String)
  {
    self.init(width: nil as Int?, fixed: false, string)
  }
  init?(_ string: String?)
  {
    self.init(width: nil as Int?, fixed: false, string)
  }

  init?<I: SDAI.SwiftIntConvertible>(
    width: I?, _ string: String?)
  {
    self.init(width: width, fixed: false, string)
  }
  init<I: SDAI.SwiftIntConvertible>(
    width: I?,  _ string: String)
  {
    self.init(width: width, fixed: false, string)
  }

  init?<I: SDAI.SwiftIntConvertible>(
    width:I?, fixed:Bool, _ string: String?)
  {
    guard let string = string else { return nil }
    self.init(width:width, fixed:fixed, string)
  }



	init?<T:SDAI.TypeHierarchy.BINARY__TypeBehavior>(_ subtype: T?)
  {
    self.init(
      width: nil as Int?, fixed: false, fundamental: subtype?.asFundamentalType)
	}
	init<T:SDAI.TypeHierarchy.BINARY__TypeBehavior>(_ subtype: T) {
    self.init(
      width: nil as Int?, fixed: false, fundamental: subtype.asFundamentalType)
	}

  init?<T:SDAI.TypeHierarchy.BINARY__TypeBehavior,I: SDAI.SwiftIntConvertible>(
    width:I?, _ subtype: T?)
  {
    self.init(
      width: width, fixed: false, fundamental: subtype?.asFundamentalType)
  }
  init<T:SDAI.TypeHierarchy.BINARY__TypeBehavior,I: SDAI.SwiftIntConvertible>(
    width:I?, _ subtype: T)
  {
    self.init(
      width: width, fixed: false, fundamental: subtype.asFundamentalType)
  }

  init?<T:SDAI.TypeHierarchy.BINARY__TypeBehavior,I: SDAI.SwiftIntConvertible>(
    width:I?, fixed:Bool, _ subtype: T?)
  {
    self.init(
      width: width, fixed: fixed, fundamental: subtype?.asFundamentalType)
  }
  init<T:SDAI.TypeHierarchy.BINARY__TypeBehavior,I: SDAI.SwiftIntConvertible>(
    width:I?, fixed:Bool, _ subtype: T)
  {
    self.init(
      width: width, fixed: fixed, fundamental: subtype.asFundamentalType)
  }

}


extension SDAI {
  
  /// An implementation of the EXPRESS BINARY type (ISO 10303-11:8.1.7).
  ///
  /// `BINARY` values are ordered sequences of bits, represented internally as an array of `Int8` where each value must be `0` or `1`.
  ///
  /// ## Initialization
  ///
  /// Instances can be created from string literals using the `ExpressibleByStringLiteral` protocol, with the string beginning with a percent sign (`%`) followed by a sequence of `0` and `1` characters (e.g., `"%1101"`). They can also be created directly from an array of 0/1 integers.
  ///
  /// ## Properties
  ///
  /// - `blength`: The number of bits in the binary value.
  /// - `typeName`: The EXPRESS type name ("BINARY").
  /// - `asSwiftType`: The underlying array of `Int8` representing the bits.
  /// - `asFundamentalType`: Returns self, for protocol conformance.
  /// - `entityReference`, `stringValue`, `binaryValue`, `logicalValue`, `booleanValue`, `numberValue`, `realValue`, `integerValue`, `genericEnumValue`: Various computed properties for protocol conformance, returning appropriate representations or `nil`.
  ///
  /// ## Subscripts
  ///
  /// - `subscript(index: Int?) -> BINARY?`: Returns a new `BINARY` containing a single bit at the provided (1-based) index, or `nil` if the index is invalid.
  /// - `subscript(range: ClosedRange<Int>?) -> BINARY?`: Returns a new `BINARY` containing the bit sequence within the (1-based) closed range, or `nil` if the range is invalid.
  ///
  /// ## Methods
  ///
  /// - `init?<G: SDAI.GenericType>(fromGeneric:)`: Initializes a BINARY value from a generic SDAI value, if it can be interpreted as a BINARY.
  /// - `isValueEqual<T: SDAI.Value>(to:)`: Tests equality with another value conforming to `SDAI.Value`.
  ///
  /// ## EXPRESS Mapping
  ///
  /// This struct supports conversion to and from the STEP physical file (Part 21) untyped parameter representations, including error handling for invalid or unresolved data.
  ///
  /// ## Invariants
  ///
  /// - The underlying bit array must only contain values 0 or 1.
  /// - All methods and subscripts perform bounds checking and validation as required by the EXPRESS specification.
  ///
  /// ## Usage
  ///
  /// ```swift
  /// let a: SDAI.BINARY = "%10110"
  /// let singleBit = a[3] // returns BINARY("%1")
  /// let subBinary = a[2...4] // returns BINARY("%011")
  /// ```
  ///
	public struct BINARY: SDAI.TypeHierarchy.BINARY__TypeBehavior, SDAI.Value, CustomStringConvertible
	{
		public typealias SwiftType = Array<Int8>
		public typealias FundamentalType = Self

    public let width: SDAIDictionarySchema.Bound?
    public let fixedWidth: SDAI.BOOLEAN

		private let rep: SwiftType

		//MARK: CustomStringConvertible
		public var description: String { "BINARY(\(rep))" }
		
		//MARK: SDAI.GenericType \SDAI.UnderlyingType\SDAI.SimpleType\SDAI__BINARY__type
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
		
		public func arrayOptionalValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.ARRAY_OPTIONAL<ELEM>? {nil}
		public func arrayValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>? {nil}
		public func listValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.LIST<ELEM>? {nil}
		public func bagValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.BAG<ELEM>? {nil}
		public func setValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.SET<ELEM>? {nil}
		public func enumValue<ENUM:SDAI.EnumerationType>(enumType:ENUM.Type) -> ENUM? {nil}

		public static func validateWhereRules(
			instance:Self?,
			prefix:SDAIPopulationSchema.WhereLabel
    ) -> SDAIPopulationSchema.WhereRuleValidationRecords
    {
      var result:SDAIPopulationSchema.WhereRuleValidationRecords = [:]

      guard let instance = instance else { return result }

      if let width = instance.width {
        if instance.fixedWidth == .TRUE {
          result[prefix + ".fixedWidth(\(width))"] = SDAI.LOGICAL(instance.blength == width)
        }
        else {
          result[prefix + ".width(\(width))"] = SDAI.LOGICAL(instance.blength <= width)
        }
      }

      return result
    }


		//MARK: InitializableByGenerictype
		public init?<G: SDAI.GenericType>(fromGeneric generic: G?) {
			guard let binaryValue = generic?.binaryValue else { return nil }
      self.init(fundamental: binaryValue)
		}
		
		//MARK: SDAI.UnderlyingType \SDAI.SimpleType\SDAI__BINARY__type
		public static let typeName: String = "BINARY"
		public var asSwiftType: SwiftType { return rep }
		
		//MARK: SDAI.GenericType
		public var asFundamentalType: FundamentalType { return self }

		public init(fundamental: FundamentalType) {
      self.rep = fundamental.rep
      self.width = fundamental.width
      self.fixedWidth = fundamental.fixedWidth
		}

		//MARK: SDAI.SimpleType \SDAI__BINARY__type
		public init(from swiftValue: SwiftType) {
			assert(Self.isValidValue(value: swiftValue))
			rep = swiftValue
      self.width = nil
      self.fixedWidth = false
		}
		
		//MARK: ExpressibleByStringLiteral \SDAI__BINARY__type
		public init(stringLiteral value: String) {
      self.init(width: nil as Int?, fixed: false, value)
		}

		//MARK: SDAI__BINARY__type
    public init<I: SDAI.SwiftIntConvertible>(
      width:I?, fixed:Bool, fundamental:FundamentalType)
    {
      self.rep = fundamental.rep
      self.width = width?.asSwiftInt
      self.fixedWidth = SDAI.BOOLEAN(fixed)
    }

    public init<I: SDAI.SwiftIntConvertible>(
      width:I?, fixed:Bool, _ value:String)
    {
      assert(value.hasPrefix("%"))
      var rep = SwiftType()
      rep.reserveCapacity(value.count-1)
      for c in value.dropFirst() {
        switch c {
          case "0": rep.append(0)
          case "1": rep.append(1)
          default: fatalError()
        }
      }

      self.rep = rep
      self.width = width?.asSwiftInt
      self.fixedWidth = SDAI.BOOLEAN(fixed)
    }

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
		
		//MARK: BINARY specific
		private static func isValidValue(value: SwiftType) -> Bool {
			for bit in value {
				if bit != 0 && bit != 1 { return false }
			}
			return true
		}
		
		//MARK: SDAI.Value
		public func isValueEqual<T: SDAI.Value>(to rhs: T) -> Bool
		{
			if let rhs = rhs as? Self { return self == rhs }
			return false
		}

		//MARK: InitializableByP21Parameter
		public static var bareTypeName: String { self.typeName }
		
		public init?(
      p21untypedParam: P21Decode.ExchangeStructure.UntypedParameter,
      from exchangeStructure: P21Decode.ExchangeStructure)
    {
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
				
			case .rhsOccurrenceName(let rhsname):
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
			self.init()
		}

	}
}

