//
//  SdaiUnownedWrap.swift
//  
//
//  Created by Yoshida on 2021/07/22.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - SDAI.UnownedWrap
extension SDAI {
	public struct UnownedWrap<REF: AnyObject> {
		public unowned let object: REF
		
		public init(_ object: REF) {
			self.object = object
		}
	}
}

extension SDAI.UnownedWrap: Equatable where REF: Equatable {}

extension SDAI.UnownedWrap: Hashable where REF: Hashable {}


extension SDAI.UnownedWrap: InitializableBySelecttype where REF: InitializableBySelecttype {
	public init?<S: SDAISelectType>(possiblyFrom select: S?) {
		guard let obj = REF.init(possiblyFrom: select) else { return nil }
		self.object = obj
	}

}

extension SDAI.UnownedWrap: InitializableByGenerictype where REF: InitializableByGenerictype {
	public init?<G: SDAIGenericType>(fromGeneric generic: G?) {
		guard let obj = REF.init(fromGeneric: generic) else { return nil }
		self.object = obj
	}

	public static func convert<G: SDAIGenericType>(fromGeneric generic: G?) -> Self? {
		guard let obj = REF.convert(fromGeneric: generic) else { return nil }
		return Self(obj)
	}

}

extension SDAI.UnownedWrap: InitializableByP21Parameter where REF: InitializableByP21Parameter {
	public static var bareTypeName: String { REF.bareTypeName }
	
	public init?(p21param: P21Decode.ExchangeStructure.Parameter, from exchangeStructure: P21Decode.ExchangeStructure) {
		guard let obj = REF.init(p21param: p21param, from: exchangeStructure) else { return nil }
		self.object = obj
	}
	
	public init?(p21typedParam: P21Decode.ExchangeStructure.TypedParameter, from exchangeStructure: P21Decode.ExchangeStructure) {
		guard let obj = REF.init(p21typedParam: p21typedParam, from: exchangeStructure)	else { return nil }
		self.object = obj
	}
	
	public init?(p21untypedParam: P21Decode.ExchangeStructure.UntypedParameter, from exchangeStructure: P21Decode.ExchangeStructure) {
		guard let obj = REF.init(p21untypedParam: p21untypedParam, from: exchangeStructure)	else { return nil }
		self.object = obj 
	}
	
	public init?(p21omittedParamfrom exchangeStructure: P21Decode.ExchangeStructure) {
		guard let obj = REF.init(p21omittedParamfrom: exchangeStructure) else { return nil }
		self.object = obj
	}
}

//extension SDAI.UnownedWrap: SDAIGenericTypeBase where REF: SDAIGenericTypeBase {
//	public func copy() -> Self {
//		let obj = self.object.copy()
//		return Self(obj)
//	}
//
//}

extension SDAI.UnownedWrap: SDAIGenericType where REF: SDAIGenericType {
	
	public typealias FundamentalType = REF.FundamentalType
	public typealias Value = REF.Value
	
	public func copy() -> Self {
		let obj = self.object.copy()
		return Self(obj)
	}

	public var asFundamentalType: FundamentalType { object.asFundamentalType	}
	public init(fundamental: FundamentalType) {
		self.object = REF.init(fundamental: fundamental)
	}
	
	public static var typeName: String { REF.typeName }
	public var typeMembers: Set<SDAI.STRING> { object.typeMembers }
	public var value: Value { object.value }
	
	public var entityReference: SDAI.EntityReference? { object.entityReference }
	public var stringValue: SDAI.STRING? { object.stringValue }
	public var binaryValue: SDAI.BINARY? { object.binaryValue }
	public var logicalValue: SDAI.LOGICAL? { object.logicalValue }
	public var booleanValue: SDAI.BOOLEAN? { object.booleanValue }
	public var numberValue: SDAI.NUMBER? { object.numberValue }
	public var realValue: SDAI.REAL? { object.realValue }
	public var integerValue: SDAI.INTEGER? { object.integerValue }
	public var genericEnumValue: SDAI.GenericEnumValue? { object.genericEnumValue }
	
	public func arrayOptionalValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY_OPTIONAL<ELEM>? {
		object.arrayOptionalValue(elementType: elementType)
	}
	public func arrayValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>? {
		object.arrayValue(elementType: elementType)
	}
	public func listValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.LIST<ELEM>? {
		object.listValue(elementType: elementType)
	}
	public func bagValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.BAG<ELEM>? {
		object.bagValue(elementType: elementType)
	}
	public func setValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.SET<ELEM>? {
		object.setValue(elementType: elementType)
	}
	public func enumValue<ENUM:SDAIEnumerationType>(enumType:ENUM.Type) -> ENUM? {
		object.enumValue(enumType: enumType)
	}
	
	public static func validateWhereRules(instance:Self?, prefix:SDAI.WhereLabel) -> [SDAI.WhereLabel:SDAI.LOGICAL] {
		REF.validateWhereRules(instance: instance?.object, prefix: prefix)
	}
	
}
