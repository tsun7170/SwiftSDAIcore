//
//  File.swift
//  
//
//  Created by Yoshida on 2021/04/30.
//

import Foundation

extension P21Decode.ExchangeStructure {
	
	public typealias SubsuperRecord = [SimpleRecord]
	
	public class SimpleRecord {
		public let keyword: Keyword
		public private(set) var parameterList: [Parameter] = []
		
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
	
	public enum Keyword: Equatable {
		case userDefinedKeyword(String)
		case standardKeyword(String)
		
		public var asUserDefinedKeyword: String? {
			guard case .userDefinedKeyword(let symbol) = self else { return nil }
			return symbol
		}
		
		public var asStandardKeyword: String? {
			guard case .standardKeyword(let symbol) = self else { return nil }
			return symbol
		}
	}
	
	public enum Parameter: Equatable {
		case typedParameter(TypedParameter)
		case untypedParameter(UntypedParameter)
		case omittedParameter
		case sdaiGeneric(SDAI.GENERIC)
		
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
	
	public class TypedParameter: Equatable {
		public static func == (lhs: TypedParameter, rhs: TypedParameter) -> Bool {
			if lhs === rhs { return true }
			return lhs.keyword == rhs.keyword && lhs.parameter == rhs.parameter
		}
		
		public let keyword: Keyword
		public let parameter: Parameter
		
		public init(keyword: String, parameter: Parameter) {
			self.keyword = .standardKeyword(keyword)
			self.parameter = parameter
		}
	}
	
	public enum UntypedParameter: Equatable {
		case noValue
		case integer(Int)
		case real(Double)
		case string(String)
		case rhsOccurenceName(RHSOccurenceName)
		case enumeration(String)
		case binary(String)	// sequence of "0" or "1"
		case list([Parameter])
	}
	
	public enum RHSOccurenceName: Equatable {
		case entityInstanceName(Int)
		case valueInstanceName(Int)
		case constantEntityName(String)
		case constantValueName(String)
	}

	public typealias UniversalResourceIdentifier = String
	public typealias URIFragmentIdentifier = String
	public typealias UUID = URIFragmentIdentifier
	public typealias AnchorName = URIFragmentIdentifier
	
	public enum AnchorItem: Equatable {
		case noValue
		case integer(Int)
		case real(Double)
		case string(String)
		case enumeration(String)
		case binary(String)
		case rhsOccurenceName(RHSOccurenceName)
		case resource(Resource)
		case anchorItemList([AnchorItem])
	}
	
	public class AnchorTag {
		public let tagName: String
		public let anchorItem: AnchorItem
		
		public init(tagName: String, anchorItem: AnchorItem) {
			self.tagName = tagName
			self.anchorItem = anchorItem
		}
	}
	
	public struct Resource: Equatable {
		public let uri: UniversalResourceIdentifier?
		public let fragment: URIFragmentIdentifier?
		
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
	
	
	public enum URIFragment {
		case uuid(UUID)
		case anchorName(AnchorName)
	}
	
//	public typealias Resource = String
	public typealias ValueInstanceName = Int
	public typealias EntityInstanceName = Int
	
}
