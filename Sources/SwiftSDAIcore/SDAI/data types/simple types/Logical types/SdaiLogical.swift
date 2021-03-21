//
//  File.swift
//  
//
//  Created by Yoshida on 2020/09/09.
//

import Foundation

public protocol SwiftBoolConvertible
{
	var possiblyAsSwiftBool: Bool? {get}
	var asSwiftBool: Bool {get}
}


//MARK: - LOGICAL type
public protocol SDAILogicalType: SDAISimpleType, ExpressibleByBooleanLiteral, SwiftBoolConvertible
{
	var isTRUE: Bool {get}
	var isnotTRUE: Bool {get}
	var possiblyAsSwiftBool: Bool? {get}
}
public extension SDAILogicalType
{
	var isnotTRUE: Bool { return !self.isTRUE }
}

public protocol SDAI__LOGICAL__type: SDAILogicalType, ExpressibleByNilLiteral 
where FundamentalType == SDAI.LOGICAL,
			Value == FundamentalType.Value,
			SwiftType == FundamentalType.SwiftType
{
	init(_ bool: Bool?)
	init<T:SDAILogicalType>(_ subtype: T?)
	init<T:SDAILogicalType>(_ subtype: T)
}
public extension SDAI__LOGICAL__type
{
	var possiblyAsSwiftBool: Bool? { return self.asSwiftType }
	var asSwiftBool: Bool { return self.possiblyAsSwiftBool! }
	var isTRUE: Bool { return self.asSwiftType ?? false }

	init(booleanLiteral value: Bool) {
		self.init(value)
	}
	init(nilLiteral: ()) {
		self.init(nil)
	}
	init<T:SDAILogicalType>(_ subtype: T?) {
		self.init(subtype?.possiblyAsSwiftBool)
	}
	init<T:SDAILogicalType>(_ subtype: T) {
		self.init(subtype.possiblyAsSwiftBool)
	}
}

extension SDAI {
	public struct LOGICAL : SDAI__LOGICAL__type, SDAIValue
	{
		
		public typealias SwiftType = Bool?
		public typealias FundamentalType = Self
		private var rep: SwiftType
		
		// SDAIGenericType \SDAIUnderlyingType\SDAISimpleType\SDAI__LOGICAL__type
		public var typeMembers: Set<SDAI.STRING> {
			return [SDAI.STRING(Self.typeName)]
		}
		public var value: FundamentalType { return self.asFundamentalType }
		
		public var entityReference: SDAI.EntityReference? {nil}	
		public var stringValue: SDAI.STRING? {nil}
		public var binaryValue: SDAI.BINARY? {nil}
		public var logicalValue: SDAI.LOGICAL? { self }
		public var booleanValue: SDAI.BOOLEAN? {nil}
		public var numberValue: SDAI.NUMBER? {nil}
		public var realValue: SDAI.REAL? {nil}
		public var integerValue: SDAI.INTEGER? {nil}
		public var genericEnumValue: SDAI.GenericEnumValue? {nil}
		
		public func arrayOptionalValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY_OPTIONAL<ELEM>? {nil}
		public func arrayValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>? {nil}
		public func listValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.LIST<ELEM>? {nil}
		public func bagValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.BAG<ELEM>? {nil}
		public func setValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.SET<ELEM>? {nil}
		public func enumValue<ENUM:SDAIEnumerationType>(enumType:ENUM.Type) -> ENUM? {nil}

		
//		public init?<S>(possiblyFrom select: S?) where S : SDAISelectType {
//			self.init(fromGeneric: select)
////			guard let logicalValue = select?.logicalValue else { return nil }
////			self.init(logicalValue)
//		}
		// InitializableByGenerictype
		public init?<G: SDAIGenericType>(fromGeneric generic: G?) {
			guard let logicalValue = generic?.logicalValue else { return nil }
			self.init(logicalValue)
		}

		// SDAIUnderlyingType \SDAISimpleType\SDAI__LOGICAL__type
		public static let typeName: String = "LOGICAL"
		public var asSwiftType: SwiftType { return rep }
		public var asFundamentalType: FundamentalType { return self }
		public init(fundamental: FundamentalType) {
			self.init(fundamental.rep)
		}

		// SDAISimpleType \SDAI__LOGICAL__type
		public init(_ swiftValue: SwiftType) {
			rep = swiftValue
		}
				
		// SDAIValue
		public func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool 
		{
			if let rhs = rhs as? Self { return self == rhs }
			if let rhs = rhs as? SwiftBoolConvertible { return self.possiblyAsSwiftBool == rhs.possiblyAsSwiftBool }
			return false
		}
		
//		public func hashAsValue(into hasher: inout Hasher, visited complexEntities: inout Set<SDAI.ComplexEntity>) {
//			self.hash(into: &hasher)
//		}
//		public func isValueEqual<T: SDAIValue>(to rhs: T, visited comppairs: inout Set<SDAI.ComplexPair>) -> Bool {
//			self.isValueEqual(to: rhs)
//		}
//		public func isValueEqualOptionally<T: SDAIValue>(to rhs: T?, visited comppairs: inout Set<SDAI.ComplexPair>) -> Bool? {
//			self.isValueEqualOptionally(to: rhs)
//		}
		
		// LIGICAL specific
		public init(fromCardinal cardinal: Int) {
			var bool: Bool? = nil
			switch cardinal {
			case 0: bool = false
			case 2: bool = true
			default:bool = nil
			}
			self.init(bool)
		}
	}
}


