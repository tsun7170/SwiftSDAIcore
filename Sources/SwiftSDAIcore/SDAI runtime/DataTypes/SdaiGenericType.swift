//
//  SdaiGenericType.swift
//  
//
//  Created by Yoshida on 2021/05/21.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAI {
  
  public protocol GenericType: Hashable, SDAI.InitializableBySelectType, SDAI.InitializableByP21Parameter, SDAI.CacheableSource, Sendable
  {
    associatedtype FundamentalType: SDAI.GenericType
    associatedtype Value: SDAI.Value

    func copy() -> Self

    var asFundamentalType: FundamentalType {get}
    init(fundamental: FundamentalType)

    static var typeName: String {get}
    var typeMembers: Set<SDAI.STRING> {get}
    var value: Value {get}

    var entityReference: SDAI.EntityReference? {get}
    var stringValue: SDAI.STRING? {get}
    var binaryValue: SDAI.BINARY? {get}
    var logicalValue: SDAI.LOGICAL? {get}
    var booleanValue: SDAI.BOOLEAN? {get}
    var numberValue: SDAI.NUMBER? {get}
    var realValue: SDAI.REAL? {get}
    var integerValue: SDAI.INTEGER? {get}
    var genericEnumValue: SDAI.GenericEnumValue? {get}

    func arrayOptionalValue<ELEM:SDAI.GenericType>(
      elementType:ELEM.Type) -> SDAI.ARRAY_OPTIONAL<ELEM>?

    func arrayValue<ELEM:SDAI.GenericType>(
      elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>?

    func listValue<ELEM:SDAI.GenericType>(
      elementType:ELEM.Type) -> SDAI.LIST<ELEM>?

    func bagValue<ELEM:SDAI.GenericType>(
      elementType:ELEM.Type) -> SDAI.BAG<ELEM>?

    func setValue<ELEM:SDAI.GenericType>(
      elementType:ELEM.Type) -> SDAI.SET<ELEM>?

    func enumValue<ENUM:SDAI.EnumerationType>(
      enumType:ENUM.Type) -> ENUM?

    static func validateWhereRules(
      instance:Self?,
      prefix:SDAIPopulationSchema.WhereLabel
    ) -> SDAIPopulationSchema.WhereRuleValidationRecords
  }
}

public extension SDAI.GenericType
{
  static func convert(from other: FundamentalType) -> Self {
    if let other = other as? Self {
      return other.copy()
    }
//    debugPrint("\(#function): Self:\(Self.self), FundamentalType: \(FundamentalType.self)")
    return self.init(fundamental: other)
  }

  init?(fundamental: FundamentalType?) {
    guard let fundamental = fundamental else { return nil }
//    debugPrint("\(#function): Self:\(Self.self), FundamentalType: \(FundamentalType.self)")
    self.init(fundamental: fundamental)
  }

	func isEqual(to another:(any SDAI.GenericType)?) -> Bool {
		guard let another = another as? Self else { return false }
		return self == another
	}

	func hash_(into hasher: inout Hasher) {
		hasher.combine(self)
	}
}

public extension SDAI.GenericType where FundamentalType == Self
{
	static func convert(from other: FundamentalType) -> Self {
		return other.copy()
	}
}

//MARK: - for SDAIDefinedTYpe
public extension SDAI.GenericType where Self: SDAI.DefinedType
{
	static func validateWhereRules(instance:Self?, prefix:SDAIPopulationSchema.WhereLabel) -> SDAIPopulationSchema.WhereRuleValidationRecords {
		return Supertype.validateWhereRules(instance:instance?.rep, prefix: prefix + "\\" + Supertype.typeName)
	}

	var value: Value {rep.value}

	var entityReference: SDAI.EntityReference? {rep.entityReference}
	var stringValue: SDAI.STRING? {rep.stringValue}
	var binaryValue: SDAI.BINARY? {rep.binaryValue}
	var logicalValue: SDAI.LOGICAL? {rep.logicalValue}
	var booleanValue: SDAI.BOOLEAN? {rep.booleanValue}
	var numberValue: SDAI.NUMBER? {rep.numberValue}
	var realValue: SDAI.REAL? {rep.realValue}
	var integerValue: SDAI.INTEGER? {rep.integerValue}
	var genericEnumValue: SDAI.GenericEnumValue? {rep.genericEnumValue}
	
	func arrayOptionalValue<ELEMENT:SDAI.GenericType>(elementType:ELEMENT.Type) -> SDAI.ARRAY_OPTIONAL<ELEMENT>?
	{ rep.arrayOptionalValue(elementType: elementType) }

	func arrayValue<ELEMENT:SDAI.GenericType>(elementType:ELEMENT.Type) -> SDAI.ARRAY<ELEMENT>?
	{ rep.arrayValue(elementType: elementType) }

	func listValue<ELEMENT:SDAI.GenericType>(elementType:ELEMENT.Type) -> SDAI.LIST<ELEMENT>?
	{ rep.listValue(elementType: elementType) }

	func bagValue<ELEMENT:SDAI.GenericType>(elementType:ELEMENT.Type) -> SDAI.BAG<ELEMENT>?
	{ rep.bagValue(elementType: elementType) }

	func setValue<ELEMENT:SDAI.GenericType>(elementType:ELEMENT.Type) -> SDAI.SET<ELEMENT>?
	{ rep.setValue(elementType: elementType) }

	func enumValue<ENUM:SDAI.EnumerationType>(enumType:ENUM.Type) -> ENUM? { rep.enumValue(enumType: enumType) }
}


