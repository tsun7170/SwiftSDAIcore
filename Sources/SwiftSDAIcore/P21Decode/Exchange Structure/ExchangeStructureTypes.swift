//
//  ExchangeStructureTypes.swift
//  
//
//  Created by Yoshida on 2021/04/30.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension P21Decode.ExchangeStructure {
	
	/// SUBSUPER_RECORD = "(" SIMPLE_RECORD_LIST ")"
	/// 
	/// # Reference
	/// 5.5 WSN of the exchange structure;
	/// ISO 10303-21
	public typealias SubsuperRecord = [SimpleRecord]
	
	
	//MARK:  SimpleRecord
	
	
	/// SIMPLE_RECORD = KEYWORD "(" [ PARAMETER_LIST ] ")"
	///
	/// # Reference
	/// 5.5 WSN of the exchange structure;
	/// ISO 10303-21
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
	
	/// KEYWORD = USER_DEFINED_KEYWORD | STANDARD_KEYWORD
	///
	/// # Reference
	/// 5.4 Definition of tokens;
	/// ISO 10303-21
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
	
	/// PARAMETER = TYPED_PARAMETER | UNTYPED_PARAMETER | OMITTED_PARAMETER
	///
	/// # Reference
	/// 5.5 WSN of the exchange structure;
	/// ISO 10303-21
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
			guard case .untypedParameter(.rhsOccurenceName(.entityInstanceName(let val))) = self else { return nil }
			return val
		}
		public var asValueInstanceName: Int? {
			guard case .untypedParameter(.rhsOccurenceName(.valueInstanceName(let val))) = self else { return nil }
			return val
		}
		public var asConstantEntityName: String? {
			guard case .untypedParameter(.rhsOccurenceName(.constantEntityName(let val))) = self else { return nil }
			return val
		}
		public var asConstantValueName: String? {
			guard case .untypedParameter(.rhsOccurenceName(.constantValueName(let val))) = self else { return nil }
			return val
		}
	}
	
	//MARK: TypedParameter
	
	/// TYPED_PARAMETER = KEYWORD "(" PARAMETER ")"
	///
	/// # Reference
	/// 5.5 WSN of the exchange structure;
	/// ISO 10303-21
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
	
	/// UNTYPED_PARAMETER = "$" | INTEGER | REAL | STRING | RHS_OCCURENCE_NAME
	///  | ENUMERATION | BINARY | LIST
	///
	/// # Reference
	/// 5.5 WSN of the exchange structure;
	/// ISO 10303-21
	public enum UntypedParameter: Equatable, CustomStringConvertible {
		case noValue
		case integer(Int)
		case real(Double)
		case string(String)
		case rhsOccurenceName(RHSOccurrenceName)
		case enumeration(String)
		case binary(String)	// sequence of "0" or "1"
		case list([Parameter])
		
		public var description: String {
			switch self {
			case .noValue:	return "$"
			case .integer(let val):	return "INTEGER(\(val))"
			case .real(let val): return "REAL(\(val))"
			case .string(let val): return "STRING(\(val))"
			case .rhsOccurenceName(let name): return "\(name)"
			case .enumeration(let val): return ".\(val)."
			case .binary(let val):	return "\"\(val)\""
			case .list(let val): return "\(val)"
			}
		}
	}
	
	//MARK: RHS Occurrence Name

	/// RHS_OCCURRENCE_NAME =( ENTITY_INSTANCE_NAME | VALUE_INSTANCE_NAME | 
	/// CONSTANT_ENTITY_NAME | CONSTANT_VALUE_NAME)
	///
	/// # Reference
	/// 5.4 Definition of tokens;
	/// ISO 10303-21
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

	/// A UNIVERSAL_RESOURCE_IDENTIFIER token of Table 2 shall meet the requirements defined by the IETF (see 3.6).
	///
	/// # Reference
	/// 6.5.2 Universal Resource Identifier (URI);
	/// ISO 10303-21
	public typealias UniversalResourceIdentifier = String
	
	/// A URI_FRAGMENT_IDENTIFIER token of Table 2 is the name following the number sign, "#", in a Universal Resource Identifier.
	///
	/// # Reference
	/// 6.5.3 URI Fragment identifier;
	/// ISO 10303-21
	public typealias URIFragmentIdentifier = String
	
	/// A UUID is a 128 bit value generated by a system.
	/// When used as an anchor name the UUID shall be encoded as prescribed in RFC 4122 (see clause 3.7.1). 
	/// There shall be no prefix on the encoding. 
	///
	/// # Reference
	/// Annex G Mapping UUIDs to anchor names;
	/// ISO 10303-21
	public typealias UUID = URIFragmentIdentifier
	
	/// ANCHOR_NAME = "<" URI_FRAGMENT_IDENTIFIER ">"
	///
	/// # Reference
	/// 5.4 Definition of tokens;
	/// ISO 10303-21
	public typealias AnchorName = URIFragmentIdentifier
	
	/// ANCHOR_ITEM = "$" | INTEGER | REAL | STRING | ENUMERATION | BINARY 
	/// | RHS_OCCURRENCE_NAME | RESOURCE | ANCHOR_ITEM_LIST
	///
	/// # Reference
	/// 5.5 WSN of the exchange structure;
	/// ISO 10303-21
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
	
	/// ANCHOR_TAG = "{" TAG_NAME ":" ANCHOR_ITEM "}"
	///
	/// # Reference
	/// 5.5 WSN of the exchange structure;
	/// ISO 10303-21
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
	
	/// RESOURCE = "<" UNIVERSAL_RESOURCE_IDENTIFIER ">"
	///
	/// # Reference
	/// 5.4 Definition of tokens;
	/// ISO 10303-21
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
	
	/// VALUE_INSTANCE_NAME ="@"(DIGIT){DIGIT}
	///
	/// # Reference
	/// 5.4 Definition of tokens;
	/// ISO 10303-21
public typealias ValueInstanceName = Int
	
	/// ENTITY_INSTANCE_NAME = "#"(DIGIT){DIGIT}
	///
	/// # Reference
	/// 5.4 Definition of tokens;
	/// ISO 10303-21
	public typealias EntityInstanceName = Int
	
}
