//
//  InitializableByGenerictype.swift
//  
//
//  Created by Yoshida on 2021/01/31.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - from generic type scalar
extension SDAI.Initializable {
  /// from generic type scalar
  public protocol ByGenericType
  {
    init?<G: SDAI.GenericType>(fromGeneric generic: G?)
    static func convert<G: SDAI.GenericType>(fromGeneric generic: G?) -> Self?
  }
}
public extension SDAI.Initializable.ByGenericType
where Self: SDAI.GenericType
{
	static func convert<G: SDAI.GenericType>(fromGeneric generic: G?) -> Self? {
		guard let generic = generic else { return nil }
		
		if let sametype = generic as? Self {
			return sametype
		}
		if let sametype = generic.asFundamentalType as? Self {
			return sametype
		}
		
		if let fundamental = generic.asFundamentalType as? FundamentalType {
//			debugPrint("\(#function): Self:\(Self.self), FundamentalType: \(FundamentalType.self)")
			return self.convert(from: fundamental)
		}
		
		if let generic = generic as? SDAI.GENERIC {
			if let sametype = generic.base as? Self {
				return sametype
			}
			if let fundamental = generic.base as? FundamentalType {
				return self.convert(from: fundamental)
			}
		}
		return self.init(fromGeneric: generic)
	}

}

public extension SDAI.Initializable.ByGenericType
where Self: SDAI.GenericType, FundamentalType == Self
{
	static func convert<G: SDAI.GenericType>(fromGeneric generic: G?) -> Self? {
		guard let generic = generic else { return nil }
		
		if let sametype = generic as? Self {
			return sametype
		}
		
		if let generic = generic as? SDAI.GENERIC {
			if let sametype = generic.base as? Self {
				return sametype
			}
		}
		return self.init(fromGeneric: generic)
	}

}

//MARK: - from generic type list
extension SDAI.Initializable {
  /// from generic type list
  public protocol ByGenericList
  {
    init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.TypeHierarchy.LIST__TypeBehavior>(bound1: I1, bound2: I2?, generic listtype: T?)
  }
}
public extension SDAI.Initializable.ByGenericList
{
	init?<T: SDAI.TypeHierarchy.LIST__TypeBehavior>(generic listtype: T?) 
	{
		guard let listtype = listtype else { return nil }
		self.init(bound1: listtype.loBound, bound2: listtype.hiBound, generic: listtype)
	}
}

//MARK: - from generic type bag
extension SDAI.Initializable {
  /// from generic type bag
  public protocol ByGenericBag
  {
    init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.TypeHierarchy.BAG__TypeBehavior>(bound1: I1, bound2: I2?, generic bagtype: T?)
  }
}
public extension SDAI.Initializable.ByGenericBag
{
  init?<T: SDAI.TypeHierarchy.BAG__TypeBehavior>(generic bagtype: T?)
	{
		guard let bagtype = bagtype else { return nil }
		self.init(bound1: bagtype.loBound, bound2: bagtype.hiBound, generic: bagtype)
	}
}

//MARK: - from generic type set
extension SDAI.Initializable {
  /// from generic type set
  public protocol ByGenericSet
  {
    init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.TypeHierarchy.SET__TypeBehavior>(bound1: I1, bound2: I2?, generic settype: T?)
  }
}
public extension SDAI.Initializable.ByGenericSet
{
  init?<T: SDAI.TypeHierarchy.SET__TypeBehavior>(generic settype: T?)
	{
		guard let settype = settype else { return nil }
		self.init(bound1: settype.loBound, bound2: settype.hiBound, generic: settype)
	}
}


//MARK: - from generic type array optional
extension SDAI.Initializable {
  /// from generic type array optional
  public protocol ByGenericArrayOptional
  {
    init?<T: SDAI.TypeHierarchy.ARRAY_OPTIONAL__TypeBehavior>(generic arraytype: T?)
  }
}
public extension SDAI.Initializable.ByGenericArrayOptional
{
  init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.TypeHierarchy.ARRAY_OPTIONAL__TypeBehavior>(bound1: I1, bound2: I2, generic arraytype: T?)
	{
		guard let arraytype = arraytype, 
					bound1.asSwiftInt == arraytype.loIndex, 
					bound2.asSwiftInt == arraytype.hiIndex 
		else { return nil }
		self.init(generic: arraytype)
	}
}


//MARK: - from generic type array
extension SDAI.Initializable {
  /// from generic type array
  public protocol ByGenericArray
  {
    init?<T: SDAI.TypeHierarchy.ARRAY__TypeBehavior>(generic arraytype: T?)
  }
}
public extension SDAI.Initializable.ByGenericArray
{
  init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.TypeHierarchy.ARRAY__TypeBehavior>(bound1: I1, bound2: I2, generic arraytype: T?) 
	{
		guard let arraytype = arraytype, 
					bound1.asSwiftInt == arraytype.loIndex, 
					bound2.asSwiftInt == arraytype.hiIndex 
		else { return nil }
		self.init(generic: arraytype)
	}
}
