//
//  InitializableBySelecttype.swift
//  
//
//  Created by Yoshida on 2020/12/18.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - from select type scalar
extension SDAI.Initializable {
  /// from select type scalar
  public protocol BySelectType
  {
    init?<S: SDAI.SelectType>(possiblyFrom select: S?)
  }
}
public extension SDAI.Initializable.BySelectType
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

public extension SDAI.Initializable.BySelectType
where Self: SDAI.Initializable.ByGenericType
{
	init?<S: SDAI.SelectType>(possiblyFrom select: S?) {
		self.init(fromGeneric: select)
	}
}

//MARK: - from select type as list (with optional bounds)
extension SDAI.Initializable {
  /// from select type as list (with optional bounds)
  public protocol BySelecttypeAsList
  {
    init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, S: SDAI.SelectType>(bound1: I1, bound2: I2?, _ select: S?)
  }
}

//MARK: - from select type as array (with required bounds)
extension SDAI.Initializable {
  /// from select type as array (with required bounds)
  public protocol BySelecttypeAsArray
  {
    init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, S: SDAI.SelectType>(bound1: I1, bound2: I2, _ select: S?)	
  }
}




//MARK: - from select type list
extension SDAI.Initializable {
  /// from select type list
  public protocol BySelecttypeList
  {
    init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.TypeHierarchy.LIST__TypeBehavior>(bound1: I1, bound2: I2?, _ listtype: T?)
    where T.ELEMENT: SDAI.SelectType
  }
}
public extension SDAI.Initializable.BySelecttypeList
{
	init?<T: SDAI.TypeHierarchy.LIST__TypeBehavior>(_ listtype: T?) 
	where T.ELEMENT: SDAI.SelectType
	{
		guard let listtype = listtype else { return nil }
		self.init(bound1: listtype.loBound, bound2: listtype.hiBound, listtype)
	}
}



//MARK: - from select type bag
extension SDAI.Initializable {
  /// from select type bag
  public protocol BySelecttypeBag
  {
    init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.TypeHierarchy.BAG__TypeBehavior>(bound1: I1, bound2: I2?, _ bagtype: T?)
    where T.ELEMENT: SDAI.SelectType
  }
}
public extension SDAI.Initializable.BySelecttypeBag
{
  init?<T: SDAI.TypeHierarchy.BAG__TypeBehavior>(_ bagtype: T?)
	where T.ELEMENT: SDAI.SelectType
	{
		guard let bagtype = bagtype else { return nil }
		self.init(bound1: bagtype.loBound, bound2: bagtype.hiBound, bagtype)
	}
}



//MARK: - from select type set
extension SDAI.Initializable {
  /// from select type set
  public protocol BySelecttypeSet
  {
    init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.TypeHierarchy.SET__TypeBehavior>(bound1: I1, bound2: I2?, _ settype: T?)
    where T.ELEMENT: SDAI.SelectType
  }
}
public extension SDAI.Initializable.BySelecttypeSet
{
  init?<T: SDAI.TypeHierarchy.SET__TypeBehavior>(_ settype: T?)
	where T.ELEMENT: SDAI.SelectType
	{
		guard let settype = settype else { return nil }
		self.init(bound1: settype.loBound, bound2: settype.hiBound, settype)
	}
}

//MARK: - from select type array optional
extension SDAI.Initializable {
  /// from select type array optional
  public protocol BySelecttypeArrayOptional
  {
    init?<T: SDAI.TypeHierarchy.ARRAY_OPTIONAL__TypeBehavior>(_ arraytype: T?)
    where T.ELEMENT: SDAI.SelectType
  }
}
public extension SDAI.Initializable.BySelecttypeArrayOptional
{
  init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.TypeHierarchy.ARRAY_OPTIONAL__TypeBehavior>(bound1: I1, bound2: I2, _ arraytype: T?)
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
extension SDAI.Initializable {
  /// from select type array
  public protocol BySelecttypeArray
  {
    init?<T: SDAI.TypeHierarchy.ARRAY__TypeBehavior>(_ arraytype: T?)
    where T.ELEMENT: SDAI.SelectType
  }
}
public extension SDAI.Initializable.BySelecttypeArray
{
  init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.TypeHierarchy.ARRAY__TypeBehavior>(bound1: I1, bound2: I2, _ arraytype: T?)
	where T.ELEMENT: SDAI.SelectType
	{
		guard let arraytype = arraytype, 
					bound1.asSwiftInt == arraytype.loIndex, 
					bound2.asSwiftInt == arraytype.hiIndex 
		else { return nil }
		self.init(arraytype)
	}
}
