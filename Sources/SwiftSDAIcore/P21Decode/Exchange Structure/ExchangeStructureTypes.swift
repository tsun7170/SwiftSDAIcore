//
//  File.swift
//  
//
//  Created by Yoshida on 2021/04/30.
//

import Foundation

extension P21Decode.ExchangeStructure {
	
	public typealias SubsuperRecord = [SimpleRecord]
	
	//MARK:  SimpleRecord
	public class SimpleRecord: CustomStringConvertible {
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
	public class TypedParameter: Equatable, CustomStringConvertible {
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
	
	//MARK: UNtypedParameter
	public enum UntypedParameter: Equatable, CustomStringConvertible {
		case noValue
		case integer(Int)
		case real(Double)
		case string(String)
		case rhsOccurenceName(RHSOccurenceName)
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
	
	//MARK: RHSOccurenceName
	public enum RHSOccurenceName: Equatable, CustomStringConvertible {
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

	public typealias UniversalResourceIdentifier = String
	public typealias URIFragmentIdentifier = String
	public typealias UUID = URIFragmentIdentifier
	public typealias AnchorName = URIFragmentIdentifier
	
	public enum AnchorItem: Equatable, CustomStringConvertible {
		case noValue
		case integer(Int)
		case real(Double)
		case string(String)
		case enumeration(String)
		case binary(String)
		case rhsOccurenceName(RHSOccurenceName)
		case resource(Resource)
		case anchorItemList([AnchorItem])
		
		public var description: String {
			switch self {
			case .noValue:	return "$"
			case .integer(let val):	return "INTEGER(\(val))"
			case .real(let val): return "REAL(\(val))"
			case .string(let val): return "STRING(\(val))"
			case .rhsOccurenceName(let name): return "\(name)"
			case .enumeration(let val): return ".\(val)."
			case .binary(let val):	return "\"\(val)\""
			case .anchorItemList(let val): return "\(val)"
			case .resource(let ref): return "\(ref)"
			}
		}
	}
	
	public class AnchorTag: CustomStringConvertible {
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
	
	
//	public enum URIFragment {
//		case uuid(UUID)
//		case anchorName(AnchorName)
//	}
	
//	public typealias Resource = String
	public typealias ValueInstanceName = Int
	public typealias EntityInstanceName = Int
	
}
