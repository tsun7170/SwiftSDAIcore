//
//  InitializableByDefinedtype.swift
//  
//
//  Created by Yoshida on 2020/12/17.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - from defined type scalar
extension SDAI {
  public protocol InitializableByDefinedType
  {
    init?<T: SDAI.UnderlyingType>(possiblyFrom underlyingType: T?)
  }
}
public extension SDAI.InitializableByDefinedType
{
	init?<T: SDAI.UnderlyingType>(_ underlyingType: T?)
	{
		self.init(possiblyFrom: underlyingType)
	}	
	
	static func convert<T: SDAI.UnderlyingType>(sibling: T?) -> Self? {
		if let sibling = sibling as? Self {
			return sibling
		}
		else {
			return self.init(possiblyFrom: sibling)
		}
	}
}




//MARK: - from defined type list
extension SDAI {
  public protocol InitializableByDefinedtypeList
  {
    init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI__LIST__type>(bound1: I1, bound2: I2?, _ listtype: T?)
    where T.ELEMENT: SDAI.UnderlyingType
  }
}
public extension SDAI.InitializableByDefinedtypeList
{
	init?<T: SDAI__LIST__type>(_ listtype: T?) 
	where T.ELEMENT: SDAI.UnderlyingType
	{
		guard let listtype = listtype else {  return nil }
		self.init(bound1: listtype.loBound, bound2: listtype.hiBound, listtype)
	}
}


//MARK: - from defined type bag
extension SDAI {
  public protocol InitializableByDefinedtypeBag
  {
    init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI__BAG__type>(bound1: I1, bound2: I2?, _ bagtype: T?)
    where T.ELEMENT: SDAI.UnderlyingType
  }
}
public extension SDAI.InitializableByDefinedtypeBag
{
	init?<T: SDAI__BAG__type>(_ bagtype: T?) 
	where T.ELEMENT: SDAI.UnderlyingType
	{
		guard let bagtype = bagtype else { return nil }
		self.init(bound1: bagtype.loBound, bound2: bagtype.hiBound, bagtype)
	}
}


//MARK: - from defined type set
extension SDAI {
  public protocol InitializableByDefinedtypeSet
  {
    init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI__SET__type>(bound1: I1, bound2: I2?, _ settype: T?)
    where T.ELEMENT: SDAI.UnderlyingType
  }
}
public extension SDAI.InitializableByDefinedtypeSet
{
	init?<T: SDAI__SET__type>(_ settype: T?) 
	where T.ELEMENT: SDAI.UnderlyingType
	{
		guard let settype = settype else { return nil }
		self.init(bound1: settype.loBound, bound2: settype.hiBound, settype)
	}
}

//MARK: - from defined type array optional
extension SDAI {
  public protocol InitializableByDefinedtypeArrayOptional
  {
    init?<T: SDAI__ARRAY_OPTIONAL__type>(_ arraytype: T?)
    where T.ELEMENT: SDAI.UnderlyingType
  }
}
public extension SDAI.InitializableByDefinedtypeArrayOptional
{
	init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI__ARRAY_OPTIONAL__type>(bound1: I1, bound2: I2, _ arraytype: T?) 
	where T.ELEMENT: SDAI.UnderlyingType
	{
		guard let arraytype = arraytype, 
					bound1.asSwiftInt == arraytype.loIndex, 
					bound2.asSwiftInt == arraytype.hiIndex 
		else { return nil }
		self.init(arraytype)
	}
}


//MARK: - from defined type array
extension SDAI {
  public protocol InitializableByDefinedtypeArray
  {
    init?<T: SDAI__ARRAY__type>(_ arraytype: T?)
    where T.ELEMENT: SDAI.UnderlyingType
  }
}
public extension SDAI.InitializableByDefinedtypeArray
{
	init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI__ARRAY__type>(bound1: I1, bound2: I2, _ arraytype: T?) 
	where T.ELEMENT: SDAI.UnderlyingType
	{
		guard let arraytype = arraytype, 
					bound1.asSwiftInt == arraytype.loIndex, 
					bound2.asSwiftInt == arraytype.hiIndex 
		else { return nil }
		self.init(arraytype)
	}
}
