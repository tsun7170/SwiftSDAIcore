//
//  InitializableByGenerictype.swift
//  
//
//  Created by Yoshida on 2021/01/31.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - from generic type scalar
extension SDAI {
  public protocol InitializableByGenericType
  {
    init?<G: SDAI.GenericType>(fromGeneric generic: G?)
    static func convert<G: SDAI.GenericType>(fromGeneric generic: G?) -> Self?
  }
}
public extension SDAI.InitializableByGenericType
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

public extension SDAI.InitializableByGenericType
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
extension SDAI {
  public protocol InitializableByGenericList
  {
    init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI__LIST__type>(bound1: I1, bound2: I2?, generic listtype: T?)
  }
}
public extension SDAI.InitializableByGenericList
{
	init?<T: SDAI__LIST__type>(generic listtype: T?) 
	{
		guard let listtype = listtype else { return nil }
		self.init(bound1: listtype.loBound, bound2: listtype.hiBound, generic: listtype)
	}
}

//MARK: - from generic type bag
extension SDAI {
  public protocol InitializableByGenericBag
  {
    init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI__BAG__type>(bound1: I1, bound2: I2?, generic bagtype: T?)
  }
}
public extension SDAI.InitializableByGenericBag
{
	init?<T: SDAI__BAG__type>(generic bagtype: T?) 
	{
		guard let bagtype = bagtype else { return nil }
		self.init(bound1: bagtype.loBound, bound2: bagtype.hiBound, generic: bagtype)
	}
}

//MARK: - from generic type set
extension SDAI {
  public protocol InitializableByGenericSet
  {
    init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI__SET__type>(bound1: I1, bound2: I2?, generic settype: T?)
  }
}
public extension SDAI.InitializableByGenericSet
{
	init?<T: SDAI__SET__type>(generic settype: T?) 
	{
		guard let settype = settype else { return nil }
		self.init(bound1: settype.loBound, bound2: settype.hiBound, generic: settype)
	}
}


//MARK: - from generic type array optional
extension SDAI {
  public protocol InitializableByGenericArrayOptional
  {
    init?<T: SDAI__ARRAY_OPTIONAL__type>(generic arraytype: T?)
  }
}
public extension SDAI.InitializableByGenericArrayOptional
{
	init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI__ARRAY_OPTIONAL__type>(bound1: I1, bound2: I2, generic arraytype: T?) 
	{
		guard let arraytype = arraytype, 
					bound1.asSwiftInt == arraytype.loIndex, 
					bound2.asSwiftInt == arraytype.hiIndex 
		else { return nil }
		self.init(generic: arraytype)
	}
}


//MARK: - from generic type array
extension SDAI {
  public protocol InitializableByGenericArray
  {
    init?<T: SDAI__ARRAY__type>(generic arraytype: T?)
  }
}
public extension SDAI.InitializableByGenericArray
{
	init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI__ARRAY__type>(bound1: I1, bound2: I2, generic arraytype: T?) 
	{
		guard let arraytype = arraytype, 
					bound1.asSwiftInt == arraytype.loIndex, 
					bound2.asSwiftInt == arraytype.hiIndex 
		else { return nil }
		self.init(generic: arraytype)
	}
}
