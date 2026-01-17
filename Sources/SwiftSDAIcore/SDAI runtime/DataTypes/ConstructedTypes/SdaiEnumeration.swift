//
//  SdaiEnumeration.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - ENUMERATION TYPE base (8.4.1)

extension SDAI {
  /// A protocol representing an SDAI enumeration type, conforming to both `SDAI.ConstructedType` and `SDAI.UnderlyingType`.
  ///
  /// Conforming types must define their associated `Value` type as their `FundamentalType`,
  /// which itself must conform to `SDAI.EnumerationType`, be `RawRepresentable`, and use `SDAI.ENUMERATION` (an `Int`) as its `RawValue`.
  ///
  /// This protocol models the base requirements for SDAI (STEP Data Access Interface) enumeration types,
  /// supporting value semantics, type safety, and underlying raw value access consistent with the SDAI specification.
  ///
  /// - Note: This is typically used to represent EXPRESS enumeration types in Swift,
  ///         ensuring conformance to the SDAI type system and interoperability with fundamental values.
  public protocol EnumerationType: SDAI.ConstructedType, SDAI.UnderlyingType
  where Value == FundamentalType,
          FundamentalType: SDAI.EnumerationType,
          FundamentalType: RawRepresentable,
          FundamentalType.RawValue == SDAI.ENUMERATION
  {}
}

public extension SDAI.EnumerationType
{
	// SDAI.GenericType
	func copy() -> Self { return self }
	var isCacheable: Bool { return true }
	var value: Value { self.asFundamentalType }
}

public extension SDAI.EnumerationType
where Self: SDAI.Value
{
	// SDAI.Value
	func isValueEqual<T: SDAI.Value>(to rhs: T) -> Bool 
	{
		if let rhs = rhs as? Self { return self == rhs }
		return false
	}
}


//MARK: - GenericEnumValue

extension SDAI {
	public typealias ENUMERATION = Int
	
  /// A type-erased representation of an SDAI enumeration value, encapsulating both its type identity and raw integer cardinal value.
  /// 
  /// `GenericEnumValue` is used to allow the storage and comparison of enumeration values from different SDAI types 
  /// in a type-agnostic way. It keeps track of the enumeration's Swift type information and its underlying integer value,
  /// which enables hashing and equality checks that account for both the kind of enumeration and its value.
  /// 
  /// Typical usage involves wrapping a concrete enumeration value using the public initializer, which takes any 
  /// `RawRepresentable` type whose `RawValue` is `SDAI.ENUMERATION` (an `Int`). 
  /// 
  /// This is useful for collections, generic algorithms, or any context where enumeration values of differing types 
  /// need to be compared or stored without loss of their type semantics.
  /// 
  /// - Note: The equality and hashing semantics ensure that enumeration values are only considered equal (and have the same hash)
  ///   if both their type and underlying raw value are the same.
  ///
  /// - SeeAlso: `SDAI.ENUMERATION`, `RawRepresentable`
	public struct GenericEnumValue: Hashable
	{
		let typeId: Any.Type
		let enumCardinal: ENUMERATION
		
		public init<T>(_ enumeration: T) where T: RawRepresentable, T.RawValue == ENUMERATION
		{
			typeId = T.self
			enumCardinal = enumeration.rawValue
		}
		
		public static func == (lhs: GenericEnumValue, rhs: GenericEnumValue) -> Bool {
			return lhs.typeId == rhs.typeId && lhs.enumCardinal == rhs.enumCardinal
		}
		
		public func hash(into hasher: inout Hasher) {
			withUnsafePointer(to: typeId) { (p) -> Void in
				hasher.combine(p.hashValue)
			}
			hasher.combine(enumCardinal)
		}
	}

}
