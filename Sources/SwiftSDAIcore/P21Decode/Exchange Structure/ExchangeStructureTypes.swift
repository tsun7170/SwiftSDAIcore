//
//  ExchangeStructureTypes.swift
//  
//
//  Created by Yoshida on 2021/04/30.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension P21Decode.ExchangeStructure {
	
  /// Represents a SUBSUPER_RECORD in the ISO 10303-21 exchange structure.
  ///
  /// SUBSUPER_RECORD = "(" SIMPLE_RECORD_LIST ")"
  ///
  /// A SUBSUPER_RECORD is defined as a group of `SimpleRecord` instances enclosed in parentheses.
  ///
  /// ## Structure
  /// `( SIMPLE_RECORD_LIST )`
  /// 
  /// ## Reference
  /// - ISO 10303-21, Section 5.5 "WSN of the exchange structure"
  /// 
  /// Each `SimpleRecord` corresponds to a record with a keyword and optional parameter list,
  /// and the `SubsuperRecord` groups them together, typically for use in STEP files and related data exchange formats.
  ///
  /// - SeeAlso: `SimpleRecord`
	public typealias SubsuperRecord = [SimpleRecord]
	
	
	//MARK:  SimpleRecord
	
	
  /// Represents a SIMPLE_RECORD in the ISO 10303-21 exchange structure.
  ///
  /// SIMPLE_RECORD = KEYWORD "(" [ PARAMETER_LIST ] ")"
  ///
  /// A SIMPLE_RECORD consists of a keyword followed by an optional parameter list enclosed in parentheses.
  /// This structure is commonly used to encode records within STEP files for product data exchange, where
  /// the `keyword` identifies the record type and the `parameterList` holds its associated values.
  ///
  /// Example: `RECORD_NAME(param1, param2, ...)`
  ///
  /// - Parameters:
  ///   - keyword: The keyword identifying the type of the record. This can be a standard or user-defined keyword.
  ///   - parameterList: The list of parameters associated with the record. This list can be empty.
  ///
  /// ## Reference
  /// - ISO 10303-21, Section 5.5 "WSN of the exchange structure"
  ///
  /// - SeeAlso: `P21Decode.ExchangeStructure.Keyword`, `P21Decode.ExchangeStructure.Parameter`
	public final class SimpleRecord: CustomStringConvertible {
		public let keyword: Keyword
		public private(set) var parameterList: [Parameter] = []
		
		public var description: String {
			return "SimpleRecord(keyword:\(keyword), parameters:\(parameterList))"
		}
		
		public init(userDefined keyword: String, parameters: [Parameter] ) {
			self.keyword = .userDefinedKeyword(keyword)
			self.parameterList = parameters
		}
		
		public init(standard keyword: String, parameters: [Parameter] ) {
			self.keyword = .standardKeyword(keyword)
			self.parameterList = parameters
		}
		
		public func append(parameter: Parameter) {
			self.parameterList.append(parameter)
		}
	}
	
	//MARK: Keyword
	
  /// Represents a keyword in the ISO 10303-21 exchange structure (STEP file).
  ///
  /// KEYWORD = USER_DEFINED_KEYWORD | STANDARD_KEYWORD
  ///
  /// A `Keyword` distinguishes between user-defined and standard keywords within an exchange structure.
  /// In STEP files, keywords identify the type or role of a record, and are used in constructs such as
  /// entity definitions, parameterized values, and type specifiers.
  ///
  /// - `userDefinedKeyword`: A keyword defined outside of the standard, typically prefixed with an exclamation mark (`!`).
  /// - `standardKeyword`: A keyword defined by the ISO 10303-21 standard, written without a prefix.
  ///
  /// ## Reference
  /// ISO 10303-21, Section 5.4 "Definition of tokens"
  ///
  /// - SeeAlso: `P21Decode.ExchangeStructure.SimpleRecord`
	public enum Keyword: Equatable, CustomStringConvertible {
		case userDefinedKeyword(String)
		case standardKeyword(String)
		
		public var description: String {
			switch self {
			case .userDefinedKeyword(let keyword):
				return "!"+keyword
			case .standardKeyword(let keyword):
				return keyword
			}	
		}
		
		public var asUserDefinedKeyword: String? {
			guard case .userDefinedKeyword(let symbol) = self else { return nil }
			return symbol
		}
		
		public var asStandardKeyword: String? {
			guard case .standardKeyword(let symbol) = self else { return nil }
			return symbol
		}
	}
	
	//MARK: Parameter
	
  /// Represents a parameter in the ISO 10303-21 exchange structure (STEP file).
  ///
  /// PARAMETER = TYPED_PARAMETER | UNTYPED_PARAMETER | OMITTED_PARAMETER
  ///
  /// A `Parameter` models the possible parameter types present in a STEP file's exchange structure.
  /// According to the standard, a parameter can be typed, untyped, omitted, or a generic value:
  ///
  /// - `typedParameter`: A parameter with an explicit type, represented as a keyword followed by a value (e.g., `TYPE(value)`).
  /// - `untypedParameter`: A parameter without an explicit type; can be an integer, real, string, enumeration, binary, list, or reference to an instance or constant.
  /// - `omittedParameter`: Represents an omitted parameter, denoted by an asterisk (`*`). This is used when a parameter is intentionally left unspecified.
  /// - `sdaiGeneric`: Represents a generic SDAI value, mapping to the SDAI.GENERIC type.
  ///
  /// This enumeration enables flexible and type-safe handling of STEP parameter values during parsing and exchange structure interpretation.
  ///
  /// ## Reference
  /// - ISO 10303-21, Section 5.5 "WSN of the exchange structure"
  ///
  /// - SeeAlso: `TypedParameter`, `UntypedParameter`, `SDAI.GENERIC`
	public enum Parameter: Equatable, CustomStringConvertible {
		case typedParameter(TypedParameter)
		case untypedParameter(UntypedParameter)
		case omittedParameter
		case sdaiGeneric(SDAI.GENERIC)
		
		public var description: String {
			switch self {
			case .typedParameter(let typed):
				return "\(typed)"
			case .untypedParameter(let untyped):
				return "\(untyped)"
			case .omittedParameter:
				return "*"
			case .sdaiGeneric(let generic):
				return "\(generic)"
			}
		}
		
		public var asTypedParameter: TypedParameter? {
			guard case .typedParameter(let p) = self else { return nil }
			return p
		}
		public var isOmitted: Bool {
			return self == .omittedParameter
		}
		public var isNullValue: Bool {
			return self == .untypedParameter(.noValue)
		}
		public var asInteger: Int? {
			guard case .untypedParameter(.integer(let val)) = self else { return nil }
			return val
		}
		public var asReal: Double? {
			guard case .untypedParameter(.real(let val)) = self else { return nil }
			return val
		}
		public var asString: String? {
			guard case .untypedParameter(.string(let val)) = self else { return nil }
			return val
		}
		public var asEnumeration: String? {
			guard case .untypedParameter(.enumeration(let val)) = self else { return nil }
			return val
		}
		public var asBinary: String? {
			guard case .untypedParameter(.binary(let val)) = self else { return nil }
			return val
		}
		public var asList: [Parameter]? {
			guard case .untypedParameter(.list(let val)) = self else { return nil }
			return val
		}
		public var asListOfString: [String]? {
			guard let list = self.asList else { return nil }
			var listOfString:[String] = []
			for item in list {
				guard let str = item.asString else { return nil }
				listOfString.append(str)
			}
			return listOfString
		}
		public var asEntityInstanceName: Int? {
			guard case .untypedParameter(.rhsOccurrenceName(.entityInstanceName(let val))) = self else { return nil }
			return val
		}
		public var asValueInstanceName: Int? {
			guard case .untypedParameter(.rhsOccurrenceName(.valueInstanceName(let val))) = self else { return nil }
			return val
		}
		public var asConstantEntityName: String? {
			guard case .untypedParameter(.rhsOccurrenceName(.constantEntityName(let val))) = self else { return nil }
			return val
		}
		public var asConstantValueName: String? {
			guard case .untypedParameter(.rhsOccurrenceName(.constantValueName(let val))) = self else { return nil }
			return val
		}
	}
	
	//MARK: TypedParameter
	
  /// Represents a TYPED_PARAMETER in the ISO 10303-21 exchange structure (STEP file).
  ///
  /// TYPED_PARAMETER = KEYWORD "(" PARAMETER ")"
  ///
  /// A `TypedParameter` models a parameter with an explicit type annotation, where a standard (or user-defined)
  /// keyword is associated with a single parameter value. This construct is used in STEP files to encode
  /// type-qualified values, such as `IFCBOOLEAN(.T.)` or `TYPE(value)`.
  ///
  /// - Parameters:
  ///   - keyword: The keyword that identifies the explicit type of the parameter. This can be a standard or user-defined keyword.
  ///   - parameter: The value associated with the typed parameter, which can itself be a typed or untyped parameter.
  /// 
  /// ## Reference
  /// - ISO 10303-21, Section 5.5 "WSN of the exchange structure"
  ///
  /// - SeeAlso: `P21Decode.ExchangeStructure.Parameter`, `P21Decode.ExchangeStructure.Keyword`
  ///
	public final class TypedParameter: Equatable, CustomStringConvertible {
		public static func == (lhs: TypedParameter, rhs: TypedParameter) -> Bool {
			if lhs === rhs { return true }
			return lhs.keyword == rhs.keyword && lhs.parameter == rhs.parameter
		}
		
		public let keyword: Keyword
		public let parameter: Parameter
		
		public var description: String {
			return "\(keyword)(\(parameter))"
		}
		
		public init(keyword: String, parameter: Parameter) {
			self.keyword = .standardKeyword(keyword)
			self.parameter = parameter
		}
	}
	
	//MARK: Untyped Parameter
	
  /// Represents an untyped parameter in the ISO 10303-21 exchange structure (STEP file).
  ///
  /// UNTYPED_PARAMETER = "$" | INTEGER | REAL | STRING | RHS_OCCURENCE_NAME
  ///  | ENUMERATION | BINARY | LIST
  ///
  /// An `UntypedParameter` models the set of parameter value forms that do not include explicit type annotations in STEP files.
  /// This includes primitive values, references, lists, and some special tokens. Untyped parameters are the most common form of
  /// STEP parameters and are used throughout the exchange structure to represent values directly.
  ///
  /// ## Structure
  /// In the ISO 10303-21 grammar, an untyped parameter can be:
  /// - A missing value denoted by the dollar sign (`$`)
  /// - An integer literal
  /// - A real (floating-point) literal
  /// - A string literal
  /// - A reference to an entity or value instance (RHS occurrence name)
  /// - An enumeration value (surrounded by dots, e.g., `.ENUM.`)
  /// - A binary string (usually a quoted sequence of "0" and "1")
  /// - A list of parameters, usually surrounded by parentheses
  ///
  /// ## Cases
  /// - `noValue`: Represents a missing or undefined parameter (the `$` symbol in STEP).
  /// - `integer(Int)`: An integer value.
  /// - `real(Double)`: A real (floating-point) value.
  /// - `string(String)`: A string value.
  /// - `rhsOccurrenceName(RHSOccurrenceName)`: A reference to an entity or value instance, or a named constant.
  /// - `enumeration(String)`: An enumeration literal (as specified in STEP syntax).
  /// - `binary(String)`: A binary value, represented as a sequence of "0" or "1" characters.
  /// - `list([Parameter])`: A list of parameters, enabling nesting of parameter values.
  ///
  /// ## Reference
  /// - ISO 10303-21, Section 5.5 "WSN of the exchange structure"
  ///
  /// - SeeAlso: `P21Decode.ExchangeStructure.Parameter`, `P21Decode.ExchangeStructure.TypedParameter`, `P21Decode.ExchangeStructure.RHSOccurrenceName`
	public enum UntypedParameter: Equatable, CustomStringConvertible {
		case noValue
		case integer(Int)
		case real(Double)
		case string(String)
		case rhsOccurrenceName(RHSOccurrenceName)
		case enumeration(String)
		case binary(String)	// sequence of "0" or "1"
		case list([Parameter])
		
		public var description: String {
			switch self {
			case .noValue:	return "$"
			case .integer(let val):	return "INTEGER(\(val))"
			case .real(let val): return "REAL(\(val))"
			case .string(let val): return "STRING(\(val))"
			case .rhsOccurrenceName(let name): return "\(name)"
			case .enumeration(let val): return ".\(val)."
			case .binary(let val):	return "\"\(val)\""
			case .list(let val): return "\(val)"
			}
		}
	}
	
	//MARK: RHS Occurrence Name

  /// Represents a right-hand-side (RHS) occurrence name in the ISO 10303-21 exchange structure (STEP file).
  ///
  /// RHS_OCCURRENCE_NAME = ENTITY_INSTANCE_NAME | VALUE_INSTANCE_NAME | CONSTANT_ENTITY_NAME | CONSTANT_VALUE_NAME
  ///
  /// An `RHSOccurrenceName` encodes the different forms of reference tokens that can be used in the right-hand side of assignments
  /// within STEP files. These references can point to entity instances, value instances, or named constants, and are important for
  /// linking data within the exchange structure.
  ///
  /// ## Cases
  /// - `entityInstanceName`: A reference to an entity instance, denoted by `#` followed by a number (e.g., `#42`).
  /// - `valueInstanceName`: A reference to a value instance, denoted by `@` followed by a number (e.g., `@15`).
  /// - `constantEntityName`: A reference to a named constant entity, denoted by `#` followed by a symbolic name (e.g., `#CONST_ENTITY`).
  /// - `constantValueName`: A reference to a named constant value, denoted by `@` followed by a symbolic name (e.g., `@CONST_VALUE`).
  ///
  /// ## Reference
  /// - ISO 10303-21, Section 5.4 "Definition of tokens"
  ///
  /// - SeeAlso: `P21Decode.ExchangeStructure.UntypedParameter`, `P21Decode.ExchangeStructure.Parameter`
  ///
	public enum RHSOccurrenceName: Equatable, CustomStringConvertible {
		case entityInstanceName(Int)
		case valueInstanceName(Int)
		case constantEntityName(String)
		case constantValueName(String)
		
		public var description: String {
			switch self {
			case .entityInstanceName(let name): return "#\(name)"
			case .valueInstanceName(let name): return "@\(name)"
			case .constantEntityName(let name): return "#\(name)"
			case .constantValueName(let name): return "@\(name)"
			}
		}
	}

  /// A UNIVERSAL_RESOURCE_IDENTIFIER token as defined in ISO 10303-21 (STEP file format).
  ///
  /// Represents a universal resource identifier (URI) according to IETF standards,
  /// used to reference external resources within the exchange structure.
  /// This can include file paths, web addresses, or any globally unique resource identifiers.
  ///
  /// # Reference
  /// - ISO 10303-21, Section 6.5.2 "Universal Resource Identifier (URI)"
  /// - IETF URI specification (see ISO 10303-21 clause 3.6)
  ///
  /// Example: `"http://example.com/resource#fragment"`
  ///
  /// Used in the STEP exchange structure to represent external references, including
  /// in constructs such as RESOURCE or ANCHOR_ITEM.
  ///
  /// - SeeAlso: `URIFragmentIdentifier`, `Resource`
	public typealias UniversalResourceIdentifier = String
	
  ///
  /// A URI_FRAGMENT_IDENTIFIER token, as defined in ISO 10303-21 (STEP file format).
  ///
  /// A URI_FRAGMENT_IDENTIFIER token of Table 2 is the name following the number sign, "#", in a Universal Resource Identifier.
  ///
  /// Represents the fragment component of a Universal Resource Identifier (URI), according to the IETF URI specification.
  /// In the STEP exchange structure, this is the substring that appears after the number sign (`#`) in a URI, identifying a secondary resource or fragment within the primary resource.
  ///
  /// # Reference
  /// - ISO 10303-21, Section 6.5.3 "URI Fragment identifier"
  /// - IETF URI specification (see ISO 10303-21 clause 3.6)
  ///
  /// ## Example
  /// For the URI `http://example.com/resource#fragment`, the `URIFragmentIdentifier` is `"fragment"`.
  ///
  /// Used in the STEP file format to refer to specific components or anchors within an external resource, commonly in constructs such as RESOURCE or ANCHOR_ITEM.
	public typealias URIFragmentIdentifier = String
	
  /// A universally unique identifier (UUID) as defined for use in STEP (ISO 10303-21) exchange structures.
  /// 
  /// A UUID (Universally Unique Identifier) is a 128-bit value generated to uniquely identify information in distributed systems.
  /// In the context of STEP files, UUIDs are typically used as anchor names and should be encoded according to RFC 4122,
  /// with no prefix and represented as a plain string of hexadecimal digits in the standard 8-4-4-4-12 format.
  /// 
  /// ## Reference
  /// - ISO 10303-21, Annex G: Mapping UUIDs to anchor names
  /// - RFC 4122: A Universally Unique IDentifier (UUID) URN Namespace
  /// 
  /// ## Example
  /// `123e4567-e89b-12d3-a456-426655440000`
  /// 
  /// Use UUIDs in STEP exchange files to provide globally unique references for anchors and resources within the file or across related files.
	public typealias UUID = URIFragmentIdentifier
	
  /// Represents an anchor name in the ISO 10303-21 exchange structure (STEP file).
  ///
  /// ANCHOR_NAME = "<" URI_FRAGMENT_IDENTIFIER ">"
  ///
  /// An `AnchorName` is a symbolic identifier enclosed in angle brackets, referring to a specific anchor within the STEP exchange structure.
  /// Anchors are used in STEP files to provide stable, symbolic references to data elements, resources, or locations, enabling linking
  /// within the file or across multiple files. The anchor name corresponds to the fragment component of a URI and is used to identify
  /// a particular fragment or item in a resource.
  ///
  /// # Reference
  /// - ISO 10303-21, Section 5.4 "Definition of tokens"
  /// - ISO 10303-21, Section 6.5.3 "URI Fragment identifier"
  ///
  /// ## Example
  /// For an anchor name `<fragment>`, the underlying `AnchorName` value is `"fragment"`.
  ///
  /// Anchor names are commonly encountered in ANCHOR_ITEM and RESOURCE constructs, and are essential for referencing and resolving
  /// cross-resource relationships in STEP files and product data exchange scenarios.
	public typealias AnchorName = URIFragmentIdentifier
	
  /// Represents the possible forms of an anchor item in the ISO 10303-21 exchange structure (STEP file).
  ///
  /// ANCHOR_ITEM = "$" | INTEGER | REAL | STRING | ENUMERATION | BINARY | RHS_OCCURRENCE_NAME | RESOURCE | ANCHOR_ITEM_LIST
  ///
  /// An `AnchorItem` models the set of values and references that can be used as anchor items within STEP files. 
  /// Anchor items are employed for cross-referencing and linking data elements, such as resources and anchors, in product data exchange scenarios.
  ///
  /// ## Cases
  /// - `noValue`: Represents a missing or undefined anchor item, denoted by the dollar sign (`$`).
  /// - `integer(Int)`: An integer value.
  /// - `real(Double)`: A real (floating-point) value.
  /// - `string(String)`: A string literal.
  /// - `enumeration(String)`: An enumeration value (enclosed in dots, e.g., `.ENUM.`).
  /// - `binary(String)`: A binary value, represented as a string of "0" and "1" characters.
  /// - `rhsOccurrenceName(RHSOccurrenceName)`: A reference to an entity or value instance; see `RHSOccurrenceName`.
  /// - `resource(Resource)`: A reference to an external resource using a URI or fragment; see `Resource`.
  /// - `anchorItemList([AnchorItem])`: A list of anchor items, allowing nested structures.
  ///
  /// ## Reference
  /// - ISO 10303-21, Section 5.5 "WSN of the exchange structure"
  /// - ISO 10303-21, Section 6.5.3 "URI Fragment identifier"
  ///
  /// Anchor items are crucial for representing and resolving relationships within STEP files, enabling robust data linking and referencing mechanisms.
	public enum AnchorItem: Equatable, CustomStringConvertible {
		case noValue
		case integer(Int)
		case real(Double)
		case string(String)
		case enumeration(String)
		case binary(String)
		case rhsOccurrenceName(RHSOccurrenceName)
		case resource(Resource)
		case anchorItemList([AnchorItem])
		
		public var description: String {
			switch self {
			case .noValue:	return "$"
			case .integer(let val):	return "INTEGER(\(val))"
			case .real(let val): return "REAL(\(val))"
			case .string(let val): return "STRING(\(val))"
			case .rhsOccurrenceName(let name): return "\(name)"
			case .enumeration(let val): return ".\(val)."
			case .binary(let val):	return "\"\(val)\""
			case .anchorItemList(let val): return "\(val)"
			case .resource(let ref): return "\(ref)"
			}
		}
	}
	
  /// Represents an anchor tag in the ISO 10303-21 exchange structure (STEP file).
  ///
  /// ANCHOR_TAG = "{" TAG_NAME ":" ANCHOR_ITEM "}"
  ///
  /// An `AnchorTag` models a tagged item within the STEP exchange structure, associating a symbolic tag name
  /// with an anchor item value. Anchor tags are used in STEP files to provide named access to anchor items,
  /// enabling structured references and organization within complex data sets.
  ///
  /// - Parameters:
  ///   - tagName: The symbolic name of the tag. This identifier provides a human-readable reference to the anchor item.
  ///   - anchorItem: The value or reference associated with the tag, which can be any valid `AnchorItem` (e.g., primitive value, list, resource, or reference).
  ///
  /// # Reference
  /// - ISO 10303-21, Section 5.5 "WSN of the exchange structure"
  ///
  /// ## Example
  /// For an anchor tag `{A1:#42}`, the `AnchorTag` would have `tagName = "A1"` and `anchorItem = .rhsOccurrenceName(.entityInstanceName(42))`.
  ///
  /// Anchor tags are essential for organizing and referencing elements in STEP files, especially when working with anchors and cross-resource linking scenarios.
  ///
  /// - SeeAlso: `P21Decode.ExchangeStructure.AnchorItem`
	public final class AnchorTag: CustomStringConvertible {
		public let tagName: String
		public let anchorItem: AnchorItem
		
		public var description: String {
			return "AnchorTag{\(tagName):\(anchorItem)}"
		}
		
		public init(tagName: String, anchorItem: AnchorItem) {
			self.tagName = tagName
			self.anchorItem = anchorItem
		}
	}
	
  /// Represents a `RESOURCE` token in the ISO 10303-21 (STEP file) exchange structure.
  ///
  /// RESOURCE = "<" UNIVERSAL_RESOURCE_IDENTIFIER ">"
  ///
  /// A `Resource` encodes a reference to an external or local resource, using a Universal Resource Identifier (URI)
  /// possibly with a fragment identifier to point to a specific part of the resource. Resources are used within STEP files
  /// to enable referencing of data and anchors across files or network locations, supporting modularity and distributed data.
  ///
  /// - Parameters:
  ///   - uri: The universal resource identifier (URI) part of the resource reference. This can be a file path, web address, or any
  ///     valid IETF-compliant URI referencing the primary resource. If the resource reference consists only of a fragment (e.g., "#fragment"),
  ///     this property will be `nil`.
  ///   - fragment: The fragment identifier portion of the URI, following the `#` symbol, designating a secondary resource or anchor within
  ///     the referenced primary resource. If there is no fragment, this property will be `nil`.
  ///
  /// ## Parsing and Structure
  /// When parsing a `RESOURCE`, the URI and fragment are separated at the first `#` symbol. If the reference string starts with `#`,
  /// then the URI is `nil` and only the fragment is set (an intra-resource anchor). Otherwise, the URI is the substring up to the `#`
  /// (if present), and fragment is the substring after.
  ///
  /// ## STEP Grammar Reference
  /// - `RESOURCE = "<" UNIVERSAL_RESOURCE_IDENTIFIER ">"`
  /// - `UNIVERSAL_RESOURCE_IDENTIFIER` may include a fragment identifier, separated by `#`.
  ///
  /// ## Example
  /// - `<http://example.com/resource#fragment>`: `uri` is `"http://example.com/resource"`, `fragment` is `"fragment"`
  /// - `<#anchor>`: `uri` is `nil`, `fragment` is `"anchor"`
  /// - `<file.stp>`: `uri` is `"file.stp"`, `fragment` is `nil`
  ///
  /// # Reference
  /// 5.4 Definition of tokens;
  /// ISO 10303-21
  ///
  /// ## See Also
  /// - [ISO 10303-21, Section 6.5.2 "Universal Resource Identifier (URI)"](https://www.iso.org/standard/63141.html)
  /// - [IETF URI specification](https://datatracker.ietf.org/doc/html/rfc3986)
  /// - `UniversalResourceIdentifier`
  /// - `URIFragmentIdentifier`
  /// - `AnchorName`
	public struct Resource: Equatable, CustomStringConvertible {
		public let uri: UniversalResourceIdentifier?
		public let fragment: URIFragmentIdentifier?
		
		public var description: String {
			return "Resource(\(uri ?? "")#\(fragment ?? ""))"	
		}
		
		public init(_ uriref: String) {
			if let fragmentSep = uriref.firstIndex(of: "#") {
				if fragmentSep == uriref.startIndex {
					self.uri = nil
				}
				else {
					self.uri = String(uriref[..<fragmentSep])
				}
				self.fragment = String(uriref[uriref.index(after: fragmentSep)...])
			}
			else {
				self.uri = uriref
				self.fragment = nil
			}
		}
	}
	
  /// Represents a VALUE_INSTANCE_NAME in the ISO 10303-21 exchange structure (STEP file).
  ///
  /// VALUE_INSTANCE_NAME = "@" DIGIT{DIGIT}
  ///
  /// A `ValueInstanceName` is a reference to a specific value instance within a STEP exchange structure, denoted by the "@" symbol
  /// followed by one or more digits (e.g., `@15`). This token allows for referencing and linking value instances within the STEP file,
  /// supporting constructs that require unique identification of values for assignments, references, and reuse.
  ///
  /// ## Reference
  /// - ISO 10303-21, Section 5.4 "Definition of tokens"
  ///
  /// ## Example
  /// For an instance name `@42`, the corresponding `ValueInstanceName` value is `42`.
  ///
  /// Value instance names are used throughout the STEP exchange structure for cross-referencing,
  //  enabling robust and unambiguous identification of parameter values and their relationships.
public typealias ValueInstanceName = Int
	
  /// Represents an ENTITY_INSTANCE_NAME in the ISO 10303-21 exchange structure (STEP file).
  ///
  /// ENTITY_INSTANCE_NAME = "#" DIGIT{DIGIT}
  ///
  /// An `EntityInstanceName` is a reference to a specific entity instance within a STEP exchange structure, denoted by the "#" symbol
  /// followed by one or more digits (e.g., `#42`). This token allows for referencing and linking entity instances within the STEP file,
  /// enabling constructs that require unique identification of entities for assignments, references, and reuse.
  ///
  /// ## Reference
  /// - ISO 10303-21, Section 5.4 "Definition of tokens"
  ///
  /// ## Example
  /// For an instance name `#42`, the corresponding `EntityInstanceName` value is `42`.
  ///
  /// Entity instance names are used throughout the STEP exchange structure for cross-referencing,
  /// enabling robust and unambiguous identification of entity instances and their relationships.
	public typealias EntityInstanceName = Int
	
}
