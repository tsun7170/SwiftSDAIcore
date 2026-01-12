//
//  SdaiNumber.swift
//  
//
//  Created by Yoshida on 2020/09/09.
//

import Foundation

extension SDAI {
  public protocol NumberRepType : SignedNumeric, Strideable
  {}
}

extension Double: SDAI.NumberRepType {}
extension Int: SDAI.NumberRepType {}

//MARK: - Double represented
extension SDAI {
  public protocol DoubleRepresented
  {
    var asSwiftDouble: Double {get}
  }
}

//MARK: - Int represented
extension SDAI {
  public protocol IntRepresented: SDAI.SwiftDoubleConvertible
  {
    var asSwiftInt: Int {get}
  }
}

//MARK: - Double convertible
extension SDAI {
  public protocol SwiftDoubleConvertible
  {
    var possiblyAsSwiftDouble: Double? {get}
    var asSwiftDouble: Double {get}
  }
}

extension Double: SDAI.SwiftDoubleConvertible, SDAI.DoubleRepresented
{
	public var asSwiftDouble: Double { return self }
	public var possiblyAsSwiftDouble: Double? { return self }
}

extension Int: SDAI.SwiftDoubleConvertible
{
	public var possiblyAsSwiftDouble: Double? { return Double(self) }
	public var asSwiftDouble: Double { return Double(self) }
}

public extension SDAI.SwiftDoubleConvertible
where Self: SDAI.DoubleRepresentedNumberType
{
	var possiblyAsSwiftDouble: Double? { return self.asSwiftType }
	var asSwiftDouble: Double { return self.asSwiftType }
}

public extension SDAI.SwiftDoubleConvertible
where Self: SDAI.IntRepresentedNumberType
{
	var possiblyAsSwiftDouble: Double? { return Double(self.asSwiftType) }
	var asSwiftDouble: Double { return Double(self.asSwiftType) }
}


//MARK: - Int convertible
extension SDAI {
  public protocol SwiftIntConvertible
  {
    var possiblyAsSwiftInt: Int? {get}
    var asSwiftInt: Int {get}
  }
}

extension Int: SDAI.SwiftIntConvertible, SDAI.IntRepresented
{
	public var asSwiftInt: Int { return self }
	public var possiblyAsSwiftInt: Int? { return self }
}

public extension SDAI.SwiftIntConvertible
where Self: SDAI.IntRepresentedNumberType
{
	var possiblyAsSwiftInt: Int? { return self.asSwiftType }
	var asSwiftInt: Int { return self.asSwiftType }
}


//MARK: - NUMBER type (8.1.1)
extension SDAI {
  public protocol NumberType: SDAI.SimpleType, ExpressibleByIntegerLiteral, SDAI.SwiftDoubleConvertible, SDAI.InitializableByVoid
  where SwiftType: SDAI.NumberRepType
  {}

  public protocol DoubleRepresentedNumberType: SDAI.NumberType, SDAI.DoubleRepresented
  where SwiftType == Double
  {}

  public protocol IntRepresentedNumberType: SDAI.NumberType, SDAI.IntRepresented
  where SwiftType == Int
  {}
}

extension SDAI {
  public protocol NUMBER__TypeBehavior: SDAI.DoubleRepresentedNumberType, ExpressibleByFloatLiteral
  where FundamentalType == SDAI.NUMBER,
        Value == FundamentalType.Value
  {
    init?(_ double: Double?)
    init(_ double: Double)
    init?(_ int: Int?)
    init(_ int: Int)
    init?<T:SDAI.NumberType>(_ subtype: T?)
    init<T:SDAI.NumberType>(_ subtype: T)
  }
}

public extension SDAI.NUMBER__TypeBehavior
{
	var asSwiftDouble: Double { return self.asSwiftType }

	init?(_ double: Double?) {
		guard let double = double else { return nil }
		self.init(from: double)
	}
	init(_ double: Double) {
		self.init(from: double)
	}

	init?(_ int: Int?) {
		guard let int = int else { return nil }
		self.init(from: SwiftType(int))
	}
	init(_ int: Int) {
		self.init(from: SwiftType(int))
	}
	init(integerLiteral value: Int) {
		self.init(from: SwiftType(value))
	}
	init(floatLiteral value: Double) {
		self.init(from: value)
	}
	init?<T:SDAI.NumberType>(_ subtype: T?) {
		guard let subtype = subtype else { return nil }
		self.init(from: subtype.asSwiftDouble)
	}
	init<T:SDAI.NumberType>(_ subtype: T) {
		self.init(from: subtype.asSwiftDouble)
	}
}

extension SDAI {
	public struct NUMBER: SDAI.NUMBER__TypeBehavior, SDAIValue, CustomStringConvertible
	{
		public typealias SwiftType = Double
		public typealias FundamentalType = Self
		private var rep: SwiftType

		// CustomStringConvertible
		public var description: String { "NUMBER(\(rep))" }
		
		// SDAI.GenericType \SDAI.UnderlyingType\SDAI.SimpleType\SDAI__NUMBER__type
		public var typeMembers: Set<SDAI.STRING> {
			return [SDAI.STRING(from: Self.typeName)]
		}
		public var value: FundamentalType { return self.asFundamentalType }
		
		public var entityReference: SDAI.EntityReference? {nil}	
		public var stringValue: SDAI.STRING? {nil}
		public var binaryValue: SDAI.BINARY? {nil}
		public var logicalValue: SDAI.LOGICAL? {nil}
		public var booleanValue: SDAI.BOOLEAN? {nil}
		public var numberValue: SDAI.NUMBER? { self }
		public var realValue: SDAI.REAL? { REAL(from: self.asSwiftDouble) }
		public var integerValue: SDAI.INTEGER? {
			let intval = Int(self.asSwiftDouble)
			if NUMBER(intval) == self { return INTEGER(intval) }
			return nil
		}
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
			guard let numberValue = generic?.numberValue else { return nil }
			self.init(numberValue)
		}
		
		
		// SDAI.UnderlyingType \SDAI.SimpleType\SDAI__NUMBER__type
		public static let typeName: String = "NUMBER"
		public var asSwiftType: SwiftType { return rep }
		
		// SDAI.GenericType
		public var asFundamentalType: FundamentalType { return self }
		public init(fundamental: FundamentalType) {
			self.init(fundamental.rep)
		}


		// SDAI.SimpleType \SDAI__NUMBER__type
		public init(from swiftValue: SwiftType) {
			rep = swiftValue
		}
		
		// SDAIValue
		public func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool 
		{
			if let rhs = rhs as? Self { return self == rhs }
			if let rhs = rhs as? SDAI.SwiftDoubleConvertible { return self.asSwiftDouble == rhs.asSwiftDouble }
			return false
		}
		
		// InitializableByP21Parameter
		public static var bareTypeName: String { self.typeName }
		
		public init?(p21untypedParam: P21Decode.ExchangeStructure.UntypedParameter, from exchangeStructure: P21Decode.ExchangeStructure) {
			switch p21untypedParam {
			case .real(let realval):
				self.init(realval)

      case .integer(let intval):
        self.init(intval)

			case .rhsOccurrenceName(let rhsname):
				switch rhsname {
				case .constantValueName(let name):
					guard let generic = exchangeStructure.resolve(constantValueName: name) else {exchangeStructure.add(errorContext: "while resolving \(Self.bareTypeName) value"); return nil }
					guard let numberValue = generic.numberValue else { exchangeStructure.error = "constant value(\(name): \(generic)) is not compatible with \(Self.bareTypeName)"; return nil }
					self.init(numberValue)
				
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

