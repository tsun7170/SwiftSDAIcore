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
	public struct UnownedWrap<REF: SdaiObjectReference>: Hashable {
		public unowned let reference: REF
		public let objectId: ObjectIdentifier
		public var object: REF.Object { reference.object }
		
		public init(_ ref: REF) {
			self.reference = ref
			objectId = ref.objectId
		}
				
		public static func == (lhs: UnownedWrap<REF>, rhs: UnownedWrap<REF>) -> Bool {
			return lhs.objectId == rhs.objectId
		}
		
		public func hash(into hasher: inout Hasher) {
			objectId.hash(into: &hasher)
		}

	}
}


extension SDAI.UnownedWrap: InitializableBySelecttype where REF: InitializableBySelecttype {
	public init?<S: SDAISelectType>(possiblyFrom select: S?) {
		guard let obj = REF.init(possiblyFrom: select) else { return nil }
		self.init(obj)
	}

}

extension SDAI.UnownedWrap: InitializableByGenerictype where REF: InitializableByGenerictype {
	public init?<G: SDAIGenericType>(fromGeneric generic: G?) {
		guard let obj = REF.init(fromGeneric: generic) else { return nil }
		self.init(obj)
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
		self.init(obj)
	}
	
	public init?(p21typedParam: P21Decode.ExchangeStructure.TypedParameter, from exchangeStructure: P21Decode.ExchangeStructure) {
		guard let obj = REF.init(p21typedParam: p21typedParam, from: exchangeStructure)	else { return nil }
		self.init(obj)
	}
	
	public init?(p21untypedParam: P21Decode.ExchangeStructure.UntypedParameter, from exchangeStructure: P21Decode.ExchangeStructure) {
		guard let obj = REF.init(p21untypedParam: p21untypedParam, from: exchangeStructure)	else { return nil }
		self.init(obj)
	}
	
	public init?(p21omittedParamfrom exchangeStructure: P21Decode.ExchangeStructure) {
		guard let obj = REF.init(p21omittedParamfrom: exchangeStructure) else { return nil }
		self.init(obj)
	}
}


extension SDAI.UnownedWrap: SDAIGenericType, SdaiCachableSource where REF: SDAIGenericType {
	
	public typealias FundamentalType = REF.FundamentalType
	public typealias Value = REF.Value
	
	public func copy() -> Self {
		let obj = self.reference.copy()
		return Self(obj)
	}
	
	public var isCachable: Bool { reference.isCachable }

	public var asFundamentalType: FundamentalType { reference.asFundamentalType	}
	public init(fundamental: FundamentalType) {
		let obj = REF.init(fundamental: fundamental)
		self.init(obj)
	}
	
	public static var typeName: String { REF.typeName }
	public var typeMembers: Set<SDAI.STRING> { reference.typeMembers }
	public var value: Value { reference.value }
	
	public var entityReference: SDAI.EntityReference? { reference.entityReference }
	public var stringValue: SDAI.STRING? { reference.stringValue }
	public var binaryValue: SDAI.BINARY? { reference.binaryValue }
	public var logicalValue: SDAI.LOGICAL? { reference.logicalValue }
	public var booleanValue: SDAI.BOOLEAN? { reference.booleanValue }
	public var numberValue: SDAI.NUMBER? { reference.numberValue }
	public var realValue: SDAI.REAL? { reference.realValue }
	public var integerValue: SDAI.INTEGER? { reference.integerValue }
	public var genericEnumValue: SDAI.GenericEnumValue? { reference.genericEnumValue }
	
	public func arrayOptionalValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY_OPTIONAL<ELEM>? {
		reference.arrayOptionalValue(elementType: elementType)
	}
	public func arrayValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>? {
		reference.arrayValue(elementType: elementType)
	}
	public func listValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.LIST<ELEM>? {
		reference.listValue(elementType: elementType)
	}
	public func bagValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.BAG<ELEM>? {
		reference.bagValue(elementType: elementType)
	}
	public func setValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.SET<ELEM>? {
		reference.setValue(elementType: elementType)
	}
	public func enumValue<ENUM:SDAIEnumerationType>(enumType:ENUM.Type) -> ENUM? {
		reference.enumValue(enumType: enumType)
	}
	
	public static func validateWhereRules(instance:Self?, prefix:SDAI.WhereLabel) -> [SDAI.WhereLabel:SDAI.LOGICAL] {
		REF.validateWhereRules(instance: instance?.reference, prefix: prefix)
	}
	
}
