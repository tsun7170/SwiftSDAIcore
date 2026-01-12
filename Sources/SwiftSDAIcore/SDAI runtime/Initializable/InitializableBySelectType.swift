//
//  InitializableBySelecttype.swift
//  
//
//  Created by Yoshida on 2020/12/18.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - from select type scalar
extension SDAI {
  public protocol InitializableBySelectType
  {
    init?<S: SDAI.SelectType>(possiblyFrom select: S?)
  }
}
public extension SDAI.InitializableBySelectType
{
	init?<S: SDAI.SelectType>(_ select: S?) {
		self.init(possiblyFrom: select)
	}
	
	static func convert<T: SDAI.SelectType>(sibling: T?) -> Self? {
		if let sibling = sibling as? Self {
			return sibling
		}
		else {
			return self.init(possiblyFrom: sibling)
		}
	}
}

public extension SDAI.InitializableBySelectType
where Self: SDAI.InitializableByGenericType
{
	init?<S: SDAI.SelectType>(possiblyFrom select: S?) {
		self.init(fromGeneric: select)
	}
}

//MARK: - from select type as list (with optional bounds)
public protocol InitializableBySelecttypeAsList
{
	init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, S: SDAI.SelectType>(bound1: I1, bound2: I2?, _ select: S?)	
}

//MARK: - from select type as array (with required bounds)
public protocol InitializableBySelecttypeAsArray
{
	init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, S: SDAI.SelectType>(bound1: I1, bound2: I2, _ select: S?)	
}





//MARK: - from select type list
extension SDAI {
  public protocol InitializableBySelecttypeList
  {
    init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI__LIST__type>(bound1: I1, bound2: I2?, _ listtype: T?)
    where T.ELEMENT: SDAI.SelectType
  }
}
public extension SDAI.InitializableBySelecttypeList
{
	init?<T: SDAI__LIST__type>(_ listtype: T?) 
	where T.ELEMENT: SDAI.SelectType
	{
		guard let listtype = listtype else { return nil }
		self.init(bound1: listtype.loBound, bound2: listtype.hiBound, listtype)
	}
}



//MARK: - from select type bag
extension SDAI {
  public protocol InitializableBySelecttypeBag
  {
    init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI__BAG__type>(bound1: I1, bound2: I2?, _ bagtype: T?)
    where T.ELEMENT: SDAI.SelectType
  }
}
public extension SDAI.InitializableBySelecttypeBag
{
	init?<T: SDAI__BAG__type>(_ bagtype: T?) 
	where T.ELEMENT: SDAI.SelectType
	{
		guard let bagtype = bagtype else { return nil }
		self.init(bound1: bagtype.loBound, bound2: bagtype.hiBound, bagtype)
	}
}



//MARK: - from select type set
extension SDAI {
  public protocol InitializableBySelecttypeSet
  {
    init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI__SET__type>(bound1: I1, bound2: I2?, _ settype: T?)
    where T.ELEMENT: SDAI.SelectType
  }
}
public extension SDAI.InitializableBySelecttypeSet
{
	init?<T: SDAI__SET__type>(_ settype: T?) 
	where T.ELEMENT: SDAI.SelectType
	{
		guard let settype = settype else { return nil }
		self.init(bound1: settype.loBound, bound2: settype.hiBound, settype)
	}
}

//MARK: - from select type array optional
extension SDAI {
  public protocol InitializableBySelecttypeArrayOptional
  {
    init?<T: SDAI__ARRAY_OPTIONAL__type>(_ arraytype: T?)
    where T.ELEMENT: SDAI.SelectType
  }
}
public extension SDAI.InitializableBySelecttypeArrayOptional
{
	init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI__ARRAY_OPTIONAL__type>(bound1: I1, bound2: I2, _ arraytype: T?) 
	where T.ELEMENT: SDAI.SelectType
	{
		guard let arraytype = arraytype, 
					bound1.asSwiftInt == arraytype.loIndex, 
					bound2.asSwiftInt == arraytype.hiIndex 
		else { return nil }
		self.init(arraytype)
	}
}


//MARK: - from select type array
extension SDAI {
  public protocol InitializableBySelecttypeArray
  {
    init?<T: SDAI__ARRAY__type>(_ arraytype: T?)
    where T.ELEMENT: SDAI.SelectType
  }
}
public extension SDAI.InitializableBySelecttypeArray
{
	init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI__ARRAY__type>(bound1: I1, bound2: I2, _ arraytype: T?) 
	where T.ELEMENT: SDAI.SelectType
	{
		guard let arraytype = arraytype, 
					bound1.asSwiftInt == arraytype.loIndex, 
					bound2.asSwiftInt == arraytype.hiIndex 
		else { return nil }
		self.init(arraytype)
	}
}
