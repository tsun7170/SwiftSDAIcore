//
//  File.swift
//  
//
//  Created by Yoshida on 2021/05/04.
//

import Foundation

public protocol InitializableByP21Parameter
{
	static var bareTypeName: String {get}
	init?(p21param: P21Decode.ExchangeStructure.Parameter, from exchangeStructure: P21Decode.ExchangeStructure)
	init?(p21typedParam: P21Decode.ExchangeStructure.TypedParameter, from exchangeStructure: P21Decode.ExchangeStructure)
	init?(p21untypedParam: P21Decode.ExchangeStructure.UntypedParameter, from exchangeStructure: P21Decode.ExchangeStructure)
	init?(p21omittedParamfrom exchangeStructure: P21Decode.ExchangeStructure)
}

//MARK: - bareTypeName
public extension InitializableByP21Parameter where Self: SDAI.EntityReference
{
	static var bareTypeName: String {
		self.entityDefinition.name
	}
}


//MARK: - init from ExchangeStructure.Parameter
public extension InitializableByP21Parameter
{
	init?(p21param: P21Decode.ExchangeStructure.Parameter, from exchangeStructure: P21Decode.ExchangeStructure) {
		switch p21param {
		case .typedParameter(let typedParam):
			self.init(p21typedParam: typedParam, from: exchangeStructure)
			
		case .untypedParameter(let untypedParam):
			self.init(p21untypedParam: untypedParam, from: exchangeStructure)
			
		case .omittedParameter:
			self.init(p21omittedParamfrom: exchangeStructure)
		}
	}
}

//MARK: - init from ExchangeStructure.TypedParameter
public extension InitializableByP21Parameter
{
	init?(p21typedParam: P21Decode.ExchangeStructure.TypedParameter, from exchangeStructure: P21Decode.ExchangeStructure) {
		guard p21typedParam.keyword.asStandardKeyword == Self.bareTypeName else { exchangeStructure.error = "unexpected p21parameter(\(p21typedParam)) while resolving \(Self.bareTypeName) value"; return nil }
		self.init(p21param: p21typedParam.parameter, from: exchangeStructure)
	}
}

//MARK: - init form ExchangeStructure.UntypedParameter
public extension InitializableByP21Parameter where Self: SDAIDefinedType
{
	init?(p21untypedParam: P21Decode.ExchangeStructure.UntypedParameter, from exchangeStructure: P21Decode.ExchangeStructure) {
		guard let supertype = Supertype(p21untypedParam: p21untypedParam, from: exchangeStructure) else { exchangeStructure.add(errorContext: "while resolving \(Self.bareTypeName) value"); return nil }
		self.init(fundamental: supertype.asFundamentalType)
	}
}

public extension InitializableByP21Parameter where Self: SDAI.EntityReference
{
	init?(p21untypedParam: P21Decode.ExchangeStructure.UntypedParameter, from exchangeStructure: P21Decode.ExchangeStructure) {
		switch p21untypedParam {
		case .rhsOccurenceName(let rhsname):
			switch rhsname {
			case .constantEntityName(let name):
				guard let entity = exchangeStructure.resolve(constantEntityName: name) else {exchangeStructure.add(errorContext: "while resolving \(Self.bareTypeName) instance"); return nil }
				self.init(complex: entity.complexEntity)
				
			case .entityInstanceName(let name):
				guard let complex = exchangeStructure.resolve(entityInstanceName: name) else {exchangeStructure.add(errorContext: "while resolving \(Self.bareTypeName) instance"); return nil }
				self.init(complex: complex)
			
			default:
				exchangeStructure.error = "unexpected p21parameter(\(p21untypedParam)) while resolving \(Self.bareTypeName) instance"
				return nil
			}
						
		case .nullValue:
			return nil
			
		default:
			exchangeStructure.error = "unexpected p21parameter(\(p21untypedParam)) while resolving \(Self.bareTypeName) value"
			return nil
		}
	}

}


//MARK: - init from p21omittedParam
public extension InitializableByP21Parameter where Self: SDAIDefinedType
{
	init?(p21omittedParamfrom exchangeStructure: P21Decode.ExchangeStructure) {
		guard let supertype = Supertype(p21omittedParamfrom: exchangeStructure) else { return nil }
		self.init(fundamental: supertype.asFundamentalType)
	}

}

public extension InitializableByP21Parameter where Self: SDAI.EntityReference
{
	init?(p21omittedParamfrom exchangeStructure: P21Decode.ExchangeStructure) {
		return nil
	}
}
