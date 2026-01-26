//
//  SdaiString.swift
//  
//
//  Created by Yoshida on 2020/09/13.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - String convertible
extension SDAI {

  /// A protocol that provides a standardized interface for types that can be converted to a Swift `String`.
  ///
  /// Types conforming to `SwiftStringConvertible` must supply both a possibly-optional and a guaranteed conversion to a Swift `String`.
  ///
  /// - Note: This protocol is designed to support types that represent string data but may have optional or invalid states.
  ///
  /// ### Conforming Types
  /// Types conforming to this protocol should provide an implementation for both properties:
  /// - `possiblyAsSwiftString`: Returns an optional `String` representation (may be `nil` if conversion is not possible).
  /// - `asSwiftString`: Returns a non-optional `String` representation (may be an empty string if not available).
  public protocol SwiftStringConvertible
  {
    var possiblyAsSwiftString: String? {get}
    var asSwiftString: String {get}
  }

  /// A marker protocol indicating that a type can be represented as a Swift `String`
  /// and conforms to the `SwiftStringConvertible` protocol.
  ///
  /// Types conforming to `SwiftStringRepresented` are expected to provide
  /// conversion to a Swift `String`, typically by implementing or inheriting
  /// the required properties from `SwiftStringConvertible`.
  ///
  /// - Note: This protocol does not require any additional implementation beyond
  ///   `SwiftStringConvertible`, and is primarily used to distinguish types that
  ///   semantically represent string values within the SDAI framework.
  public protocol SwiftStringRepresented: SDAI.SwiftStringConvertible
  {}
}

extension String: SDAI.SwiftStringRepresented
{
	public var possiblyAsSwiftString: String? { return self }
	public var asSwiftString: String { return self }
}


//MARK: - STRING type (8.1.6)
extension SDAI {

  /// A protocol representing the EXPRESS `STRING` type as defined by ISO 10303-11 (section 8.1.6),
  /// used within the SDAI framework. 
  ///
  /// Types conforming to `StringType` support conversion to and from Swift `String` values,
  /// subscript access using 1-based indices, and the EXPRESS 'LIKE' pattern matching operation.
  ///
  /// ### Requirements:
  /// - Must conform to `SDAI.SimpleType`, `SDAI.SwiftStringConvertible`, `ExpressibleByStringLiteral`,
  ///   and `SDAI.Initializable.ByVoid`.
  /// - Must use `String` as its `StringLiteralType`.
  ///
  /// ### Functionality:
  /// - Provides the character count via the `length` property.
  /// - Supports 1-based indexed and ranged substring access, returning optional `SDAI.STRING` values.
  /// - Supports EXPRESS-compliant 'LIKE' pattern matching using the `ISLIKE(PATTERN:)` method,
  ///   which accepts both `StringType` and raw `String` pattern arguments and returns `SDAI.LOGICAL`.
  /// - Exposes the string value as a Swift `String` via the `asSwiftString` property.
  ///
  /// ### Indexing:
  /// - All subscript access is 1-based (i.e., the first character is at index 1),
  ///   reflecting EXPRESS string semantics. Out-of-bounds or `nil` indices/ranges return `nil`.
  ///
  /// ### Pattern Matching:
  /// - The EXPRESS 'LIKE' operator is supported, allowing pattern-based string comparison
  ///   with special metacharacters for alphabetic, numeric, whitespace, and wildcard matching.
  ///
  /// ### Conforming Types:
  /// - Implementations should provide storage, initialization, and all protocol-required
  ///   methods and properties as defined.
  ///
  /// - Note: This protocol bridges EXPRESS `STRING` and Swift's native `String` functionality,
  ///   preserving EXPRESS semantics where appropriate.
  public protocol StringType: SDAI.SimpleType, SDAI.SwiftStringConvertible,
                                  ExpressibleByStringLiteral, SDAI.Initializable.ByVoid
  where StringLiteralType == String
  {
    /// The number of characters contained in the string value.
    /// - Note: This represents the length of the string as defined in the SDAI specification.
    /// - Returns: An `Int` value indicating the total count of characters.
    var length: Int {get}

    /// Accesses the character at the specified position in the string, using 1-based indexing as defined in the SDAI specification.
    ///
    /// - Parameter index: The position of the character to access, where the first character is at position 1.
    /// - Returns: An optional `SDAI.STRING` containing the character at the specified index, or `nil` if the index is `nil`, less than 1, or greater than the string's length.
    ///
    /// - Note: The index is 1-based (not 0-based like typical Swift strings). If the index is out of bounds or `nil`, this subscript returns `nil`.
    subscript<I: SDAI.TypeHierarchy.INTEGER__TypeBehavior>(index: I?) -> SDAI.STRING? {get}

    /// Accesses the character at the specified position in the string, using 1-based indexing as defined in the SDAI specification.
    /// 
    /// - Parameter index: The position of the character to access, where the first character is at position 1.
    /// - Returns: An optional `SDAI.STRING` containing the character at the specified index, or `nil` if the index is `nil`, less than 1, or greater than the string's length.
    /// 
    /// - Note: The index is 1-based (not 0-based like typical Swift strings). If the index is out of bounds or `nil`, this subscript returns `nil`.
    subscript(index: Int?) -> SDAI.STRING? {get}

    /// Accesses a substring within the receiver, using 1-based indexing as defined in the SDAI specification.
    ///
    /// - Parameter range: A closed range specifying the starting and ending positions of the substring, where the first character is at position 1.
    /// - Returns: An optional `SDAI.STRING` containing the substring defined by the range, or `nil` if `range` is `nil`, the lower bound is less than 1, or the upper bound exceeds the string's length.
    ///
    /// - Note: The range is 1-based (not 0-based like typical Swift strings). If the specified range is out of bounds or `nil`, this subscript returns `nil`.
    subscript(range: ClosedRange<Int>?) -> SDAI.STRING? {get}

    /// Evaluates whether the receiver matches the given pattern string, using the EXPRESS 'LIKE' operator semantics (ISO 10303-11:12.2.5).
    ///
    /// - Parameter substring: The pattern string to match against, or `nil`.
    /// - Returns: A `SDAI.LOGICAL` value indicating whether the receiver matches the pattern (`TRUE`), does not match (`FALSE`), or if the result is indeterminate (`UNKNOWN`).
    ///
    /// - Discussion:
    ///   The EXPRESS 'LIKE' pattern supports special characters:
    ///   - `"!"`: Negates the next pattern element.
    ///   - `"@"`: Matches an alphabetic character.
    ///   - `"^"`: Matches an uppercase letter.
    ///   - `"?"`: Matches any single character.
    ///   - `"&"`: Succeeds if the current pattern state matches.
    ///   - `"#"`: Matches a numeric digit.
    ///   - `"$"`: Matches a sequence of whitespace.
    ///   - `"*"`: Matches any sequence of zero or more characters.
    ///   - `"\\"`: Escapes the next character to match it literally.
    ///
    ///   If `substring` is `nil`, the function returns `SDAI.UNKNOWN`.
    ///   If the receiver matches the pattern, the result is `SDAI.TRUE`.
    ///   If the receiver does not match, the result is `SDAI.FALSE`.
    ///
    ///   The pattern is applied from left to right. Matching is case-sensitive unless pattern symbols dictate otherwise.
    func ISLIKE<T:SDAI.StringType>(PATTERN substring: T? ) -> SDAI.LOGICAL	// Express 'LIKE' operator translation

    /// Evaluates whether the receiver matches the given pattern string, using the EXPRESS 'LIKE' operator semantics (ISO 10303-11:12.2.5).
    ///
    /// - Parameter substring: The pattern string to match against, or `nil`.
    /// - Returns: A `SDAI.LOGICAL` value indicating whether the receiver matches the pattern (`TRUE`), does not match (`FALSE`), or if the result is indeterminate (`UNKNOWN`).
    ///
    /// - Discussion:
    ///   The EXPRESS 'LIKE' pattern supports special characters:
    ///   - `"!"`: Negates the next pattern element.
    ///   - `"@"`: Matches an alphabetic character.
    ///   - `"^"`: Matches an uppercase letter.
    ///   - `"?"`: Matches any single character.
    ///   - `"&"`: Succeeds if the current pattern state matches.
    ///   - `"#"`: Matches a numeric digit.
    ///   - `"$"`: Matches a sequence of whitespace.
    ///   - `"*"`: Matches any sequence of zero or more characters.
    ///   - `"\\"`: Escapes the next character to match it literally.
    ///
    ///   If `substring` is `nil`, the function returns `SDAI.UNKNOWN`.
    ///   If the receiver matches the pattern, the result is `SDAI.TRUE`.
    ///   If the receiver does not match, the result is `SDAI.FALSE`.
    ///
    ///   The pattern is applied from left to right. Matching is case-sensitive unless pattern symbols dictate otherwise.
    func ISLIKE(PATTERN substring: String? ) -> SDAI.LOGICAL	// Express 'LIKE' operator translation
    var asSwiftString: String {get}
  }
}

public extension SDAI.StringType
{
	subscript<I: SDAI.TypeHierarchy.INTEGER__TypeBehavior>(index: I?) -> SDAI.STRING? {
		return self[index?.asSwiftType]
	}

	func ISLIKE<T:SDAI.StringType>(PATTERN substring: T? ) -> SDAI.LOGICAL{
		return self.ISLIKE(PATTERN: substring?.asSwiftString)
	}
}
public extension SDAI.StringType where SwiftType == String
{
	var asSwiftString: String { return self.asSwiftType }
	var possiblyAsSwiftString: String? { return self.asSwiftType }
}


extension SDAI.TypeHierarchy {
  /**
   A protocol that defines the standardized behavior for types conforming to the EXPRESS `STRING` type hierarchy within the SDAI framework.

   `STRING__TypeBehavior` extends `SDAI.StringType` and `SDAI.SwiftStringRepresented`, ensuring that all fundamental EXPRESS string semantics and interoperability are preserved. This protocol sets requirements for initialization, conversion, type constraints, and type relationships among EXPRESS `STRING` subtypes.

   ## Key Responsibilities:
   - **Initialization**: Must support initialization from Swift `String`, other conforming string subtypes, and optional/width/fixed-width variations. This enables conversion and interoperability between EXPRESS `STRING` subtypes and Swift strings, handling optional and non-optional cases.
   - **Per-Instance Width Properties**: Each instance exposes properties describing its width constraint and whether it is fixed or variable width. These properties describe the characteristics of the individual string instance, and may vary between instances depending on initialization.
   - **Type Canonicalization**: Enforces type associations so that associated types of `Value` and `SwiftType` match those of the fundamental type, ensuring type-safe value and Swift interoperability.

   ## Requirements:
   - The conforming type must use `SDAI.STRING` as its `FundamentalType`.
   - The `Value` and `SwiftType` associated types must match those of `SDAI.STRING`.
   - Conforming types are expected to provide initializers for:
     - Swift `String` (optional and non-optional)
     - Other types conforming to `STRING__TypeBehavior` (optional and non-optional)
     - Width and fixed-width constraints, as needed for bounded/fixed-width implementations
   - Must expose the instance properties `width` and `fixedWidth` describing the width bound and fixed/variable width status of the string.

   ## Usage:
   Use this protocol for types that serve as EXPRESS `STRING` subtypes (such as bounded-length or fixed-width strings). It ensures correct initialization, conversion, and width properties as mandated by the EXPRESS data modeling standard. While the default implementation models unbounded and variable width strings, this protocol is designed to support EXPRESS's full range of string types.

   - SeeAlso: `SDAI.StringType`, `SDAI.STRING`
   */
  public protocol STRING__TypeBehavior: SDAI.StringType, SDAI.SwiftStringRepresented
  where FundamentalType == SDAI.STRING,
        Value == FundamentalType.Value,
        SwiftType == FundamentalType.SwiftType
  {
    init?(_ string:String?)
    init(_ string:String)

    init?<I: SDAI.SwiftIntConvertible>(width:I?, _ string:String?)
    init<I: SDAI.SwiftIntConvertible>(width:I?,  _ string:String)

    init?<I: SDAI.SwiftIntConvertible>(width:I?, fixed:Bool, _ string:String?)
    init<I: SDAI.SwiftIntConvertible>(width:I?, fixed:Bool, _ string:String)


    init?<T:SDAI.TypeHierarchy.STRING__TypeBehavior>(_ subtype: T?)
    init<T:SDAI.TypeHierarchy.STRING__TypeBehavior>(_ subtype: T)
    
    init?<T:SDAI.TypeHierarchy.STRING__TypeBehavior,I: SDAI.SwiftIntConvertible>(width:I?, _ subtype: T?)
    init<T:SDAI.TypeHierarchy.STRING__TypeBehavior,I: SDAI.SwiftIntConvertible>(width:I?, _ subtype: T)
    
    init?<T:SDAI.TypeHierarchy.STRING__TypeBehavior,I: SDAI.SwiftIntConvertible>(width:I?, fixed:Bool, _ subtype: T?)
    init<T:SDAI.TypeHierarchy.STRING__TypeBehavior,I: SDAI.SwiftIntConvertible>(width:I?, fixed:Bool, _ subtype: T)


    var width: SDAIDictionarySchema.Bound? {get}
    var fixedWidth: SDAI.BOOLEAN {get}
  }
}

public extension SDAI.TypeHierarchy.STRING__TypeBehavior
{
	var asSwiftString: String { return String(self.asSwiftType) }

  init(from swiftValue: SwiftType) {
    self.init(swiftValue)
  }
  init(stringLiteral value: String) {
    self.init( SwiftType(value) )
  }


  init(_ string: String){
    self.init(width: nil as Int?, fixed: false, string)
  }
  init?(_ string: String?){
    self.init(width: nil as Int?, fixed: false, string)
  }

  init?<I: SDAI.SwiftIntConvertible>(width:I?, _ string:String?) {
    self.init(width: width, fixed: false, string)
  }
  init<I: SDAI.SwiftIntConvertible>(width:I?,  _ string:String) {
    self.init(width: width, fixed: false, string)
  }

	init?<I: SDAI.SwiftIntConvertible>(
    width:I?, fixed:Bool, _ string: String?)
  {
		guard let string = string else { return nil }
    self.init(width:width, fixed:fixed, string)
	}
//	init(_ string:String) {
//		self.init(from: string)
//	}



  init?<T:SDAI.TypeHierarchy.STRING__TypeBehavior>(
    _ subtype: T?)
  {
    self.init(width: nil as Int?, fixed: false, subtype?.asSwiftType)
  }
  init<T:SDAI.TypeHierarchy.STRING__TypeBehavior>(
    _ subtype:T)
  {
    self.init(width:nil as Int?, fixed: false, subtype.asSwiftType)
  }

  init?<T:SDAI.TypeHierarchy.STRING__TypeBehavior,I: SDAI.SwiftIntConvertible>(
    width:I?, _ subtype: T?)
  {
    self.init(width: width, fixed: false, subtype?.asSwiftType)
  }
  init<T:SDAI.TypeHierarchy.STRING__TypeBehavior,I: SDAI.SwiftIntConvertible>(
    width:I?, _ subtype:T)
  {
    self.init(width:width, fixed: false, subtype.asSwiftType)
  }

	init?<T:SDAI.TypeHierarchy.STRING__TypeBehavior,I: SDAI.SwiftIntConvertible>(
    width:I?, fixed:Bool, _ subtype: T?)
  {
		self.init(width: width, fixed: fixed, subtype?.asSwiftType)
	}
	init<T:SDAI.TypeHierarchy.STRING__TypeBehavior,I: SDAI.SwiftIntConvertible>(
    width:I?, fixed:Bool, _ subtype:T)
  {
    self.init(width:width, fixed: fixed, subtype.asSwiftType)
	}

//	static var width: SDAIDictionarySchema.Bound? {nil}
//	static var fixedWidth: SDAI.BOOLEAN {false}
}

extension SDAI {
  
  /// A concrete implementation of the EXPRESS `STRING` type as defined by ISO 10303-11 (section 8.1.6), 
  /// representing string values within the SDAI framework.
  ///
  /// `STRING` encapsulates a Swift `String` value and provides EXPRESS-compliant string semantics, 
  /// including 1-based indexing, length calculation, and 'LIKE' pattern matching operations.
  ///
  /// ### Key Features:
  /// - **Bridges EXPRESS and Swift:** `STRING` provides a type-safe wrapper over Swift's `String`,
  ///   while adhering to the requirements and semantics of the EXPRESS `STRING` type.
  /// - **1-based Indexing:** Subscript access uses EXPRESS-style 1-based indices and ranges, 
  ///   returning optional `STRING` values for valid indices, or `nil` for out-of-bounds access.
  /// - **Pattern Matching:** Implements the EXPRESS 'LIKE' operator, allowing EXPRESS-compliant 
  ///   string pattern matching with support for special metacharacters.
  /// - **Value Semantics and Type Conversion:** Integrates with the SDAI type system, supporting value 
  ///   conversion, initialization from Swift strings, and interoperability with other SDAI types.
  /// - **ExpressibleByStringLiteral:** Supports Swift string literals for concise initialization.
  ///
  /// ### EXPRESS 'LIKE' Pattern Matching (ISO 10303-11:12.2.5)
  /// The `ISLIKE(PATTERN:)` method evaluates whether the receiver matches a specified pattern string, 
  /// supporting the following metacharacters:
  /// - `"!"`: Negates the next pattern element.
  /// - `"@"`: Matches an alphabetic character.
  /// - `"^"`: Matches an uppercase letter.
  /// - `"?"`: Matches any single character.
  /// - `"&"`: Succeeds if the current pattern state matches.
  /// - `"#"`: Matches a numeric digit.
  /// - `"$"`: Matches a sequence of whitespace.
  /// - `"*"`: Matches any sequence of zero or more characters.
  /// - `"\\"`: Escapes the next character to match it literally.
  ///
  /// ### Usage
  /// ```swift
  /// let s: SDAI.STRING = "Example"
  /// print(s.length) // 7
  /// let firstLetter = s[1] // SDAI.STRING("E")
  /// let substring = s[2...4] // SDAI.STRING("xam")
  /// let isLike = s.ISLIKE(PATTERN: "Ex*") // SDAI.TRUE
  /// ```
  ///
  /// - Note: This type directly models the EXPRESS `STRING` specification, preserving its semantics.
  /// - SeeAlso: `SDAI.StringType`, `SDAI.TypeHierarchy.STRING__TypeBehavior`
	public struct STRING: SDAI.TypeHierarchy.STRING__TypeBehavior, SDAI.Value, CustomStringConvertible
	{
		public typealias SwiftType = String
		public typealias FundamentalType = Self

    public let width: SDAIDictionarySchema.Bound?
    public let fixedWidth: SDAI.BOOLEAN

    private let rep: SwiftType

		// CustomStringConvertible
		public var description: String { "STRING(\(rep))" }
		
		// SDAI.GenericType \SDAI.UnderlyingType\SDAI.SimpleType\SDAI__STRING__type
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
			guard let stringValue = generic?.stringValue else { return nil }
			self.init(stringValue)
		}

		// SDAI.UnderlyingType\SDAI.SimpleType\SDAI__STRING__type
		public static let typeName: String = "STRING"
		public var asSwiftType: SwiftType { return rep }
		
		// SDAI.GenericType
		public var asFundamentalType: FundamentalType { return self }
		public init(fundamental: FundamentalType) {
      self.init(width: fundamental.width, fixed: fundamental.fixedWidth.asSwiftType, fundamental.rep)
		}

		// SDAI.SimpleType \SDAI__STRING__type
//		public init(from swiftValue: SwiftType) {
//			rep = swiftValue
//		}

		// SDAI__STRING__type
    public init<I: SDAI.SwiftIntConvertible>(
      width:I?, fixed:Bool, _ string: String)
    {
      self.width = width?.asSwiftInt
      self.fixedWidth = SDAI.BOOLEAN(fixed)
      self.rep = string
    }

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
		

		// SDAI.Value
		public func isValueEqual<T: SDAI.Value>(to rhs: T) -> Bool 
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
				
			case .rhsOccurrenceName(let rhsname):
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
			self.init()
		}

	}
}

