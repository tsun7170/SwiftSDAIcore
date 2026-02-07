//
//  SdaiDefinedType.swift
//  
//
//  Created by Yoshida on 2020/09/22.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - Underlying Type base (8.6.3)
extension SDAI {
  /// A protocol representing the base type for underlying types that are compatible with EXPRESS `SELECT` types.
  /// 
  /// Types conforming to `SelectCompatibleUnderlyingTypeBase` must also conform to `SDAI.GenericType`, and their
  /// associated `FundamentalType` must itself be a `SelectCompatibleUnderlyingTypeBase`.
  /// 
  /// This protocol is used to abstract over types that can be used as the underlying types for EXPRESS `SELECT` types,
  /// as described in section 8.6.3 of the EXPRESS language specification.
  /// 
  /// - Note: Types that conform to this protocol can participate in select type compatibility checks and conversions
  ///   within the SDAI framework.
  ///
  public protocol SelectCompatibleUnderlyingTypeBase: SDAI.GenericType
  where FundamentalType: SDAI.SelectCompatibleUnderlyingTypeBase
  {}
}


//MARK: - Underlying Type excluding select type
extension SDAI {
  /// A protocol representing an underlying type that can be used as the base for EXPRESS defined types,
  /// excluding select types.
  /// 
  /// Types conforming to `UnderlyingType` must also conform to both `SelectCompatibleUnderlyingTypeBase`
  /// and `InitializableByDefinedType`.
  ///
  /// This protocol is used to abstract over types that serve as the underlying types for EXPRESS-defined types
  /// (except for select types), enabling compatibility checks, conversions, and initializations within the SDAI framework.
  /// 
  /// - Note: `UnderlyingType` is the protocol to use for most base types of custom defined types in EXPRESS,
  ///   except where those types are or contain select types.
  ///
  public protocol UnderlyingType: SDAI.SelectCompatibleUnderlyingTypeBase, SDAI.Initializable.ByDefinedType
  {}
}
public extension SDAI.UnderlyingType
{	
	init?<T: SDAI.UnderlyingType>(possiblyFrom underlyingType: T?) 
	{
		if let fundamental = underlyingType?.asFundamentalType as? FundamentalType {
			self.init(fundamental: fundamental)
		}
		else {
			self.init(fromGeneric: underlyingType)
		}
	}

}



//MARK: - Defined Type (8.3.2)
extension SDAI {
  /// A protocol representing an EXPRESS-defined type in the SDAI framework.
  ///
  /// `DefinedType` models the concept of a defined type as described in section 8.3.2 of the EXPRESS language specification.
  /// Defined types are user-declared types that are based on an existing underlying type (the "supertype"), possibly with additional constraints.
  ///
  /// Types conforming to `DefinedType` must also conform to both `NamedType` and `SelectCompatibleUnderlyingTypeBase`.
  /// They specify their `Supertype`, which is the underlying base for the defined type. The associated `FundamentalType`
  /// and `Value` types of the conforming type must match those of the `Supertype`.
  ///
  /// The protocol requires a property `rep` that holds the value in the underlying `Supertype`.
  ///
  /// - Important: `DefinedType` enables defined types to participate in EXPRESS type compatibility and conversion logic,
  ///   and provides access to their fundamental and value representations.
  /// - SeeAlso: EXPRESS specification section 8.3.2; `SelectCompatibleUnderlyingTypeBase`; `NamedType`.
  ///
  /// ### Associated Types
  /// - `Supertype`: The underlying type from which the defined type is derived. Must conform to `SelectCompatibleUnderlyingTypeBase`.
  /// - `FundamentalType`: The most basic type underlying the defined type, equal to `Supertype.FundamentalType`.
  /// - `Value`: The value representation for the defined type, equal to `Supertype.Value`.
  ///
  /// ### Requirements
  /// - `rep`: A property storing the value as the underlying `Supertype`.
  ///
  public protocol DefinedType: SDAI.NamedType, SDAI.SelectCompatibleUnderlyingTypeBase
  {
    associatedtype Supertype: SDAI.SelectCompatibleUnderlyingTypeBase
    where FundamentalType == Supertype.FundamentalType,
          Value == Supertype.Value

    var rep: Supertype {get set}
  }
}
public extension SDAI.DefinedType
{ 
	var asFundamentalType: FundamentalType { return rep.asFundamentalType }
}

public extension SDAI.DefinedType
where Self: Equatable, FundamentalType: Equatable
{
	static func ==<T:SDAI.UnderlyingType> (lhs: Self, rhs: T) -> Bool
	where FundamentalType == T.FundamentalType
	{ 
		return lhs.asFundamentalType == rhs.asFundamentalType
	}

	static func ==<T:SDAI.UnderlyingType> (lhs: T, rhs: Self) -> Bool
	where FundamentalType == T.FundamentalType
	{ 
		return lhs.asFundamentalType == rhs.asFundamentalType
	}
}

public extension SDAI.DefinedType where Self: Sequence, FundamentalType: Sequence
{
	func makeIterator() -> FundamentalType.Iterator { return self.asFundamentalType.makeIterator() }

}
