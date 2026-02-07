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
    init?<S>(possiblyFrom select: S?)
    where S: SDAI.SelectType
  }
}
public extension SDAI.Initializable.BySelectType
{
	init?<S>(_ select: S?)
  where S: SDAI.SelectType
  {
		self.init(possiblyFrom: select)
	}
	
	static func convert<T>(sibling: T?) -> Self?
  where T: SDAI.SelectType
  {
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
	init?<S>(possiblyFrom select: S?)
  where S: SDAI.SelectType
  {
		self.init(fromGeneric: select)
	}
}

//MARK: - from select type as list (with optional bounds)
extension SDAI.Initializable {

  /// from select type as list (with optional bounds)
  public protocol BySelecttypeAsList
  {
    init?<I1, I2, S>(
      bound1: I1, bound2: I2?, _ select: S?)
    where
    I1: SDAI.SwiftIntConvertible,
    I2: SDAI.SwiftIntConvertible,
    S: SDAI.SelectType
  }
}

//MARK: - from select type as array (with required bounds)
extension SDAI.Initializable {

  /// from select type as array (with required bounds)
  public protocol BySelecttypeAsArray
  {
    init?<I1, I2, S>(
      bound1: I1, bound2: I2, _ select: S?)
    where
    I1: SDAI.SwiftIntConvertible,
    I2: SDAI.SwiftIntConvertible,
    S: SDAI.SelectType
  }
}




//MARK: - from select type list
extension SDAI.Initializable {

  /// from select type list
  public protocol BySelecttypeList
  {
    init?<I1, I2, T>(
      bound1: I1, bound2: I2?, _ listtype: T?)
    where
    I1: SDAI.SwiftIntConvertible,
    I2: SDAI.SwiftIntConvertible,
    T: SDAI.TypeHierarchy.LIST__TypeBehavior,
    T.ELEMENT: SDAI.SelectType
  }
}
public extension SDAI.Initializable.BySelecttypeList
{
	init?<T>(_ listtype: T?)
	where
  T: SDAI.TypeHierarchy.LIST__TypeBehavior,
  T.ELEMENT: SDAI.SelectType
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
    init?<I1, I2, T>(
      bound1: I1, bound2: I2?, _ bagtype: T?)
    where
    I1: SDAI.SwiftIntConvertible,
    I2: SDAI.SwiftIntConvertible,
    T: SDAI.TypeHierarchy.BAG__TypeBehavior,
    T.ELEMENT: SDAI.SelectType
  }
}
public extension SDAI.Initializable.BySelecttypeBag
{
  init?<T>(_ bagtype: T?)
	where
  T: SDAI.TypeHierarchy.BAG__TypeBehavior,
  T.ELEMENT: SDAI.SelectType
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
    init?<I1, I2, T>(
      bound1: I1, bound2: I2?, _ settype: T?)
    where
    I1: SDAI.SwiftIntConvertible,
    I2: SDAI.SwiftIntConvertible,
    T: SDAI.TypeHierarchy.SET__TypeBehavior,
    T.ELEMENT: SDAI.SelectType
  }
}
public extension SDAI.Initializable.BySelecttypeSet
{
  init?<T>(_ settype: T?)
	where
  T: SDAI.TypeHierarchy.SET__TypeBehavior,
  T.ELEMENT: SDAI.SelectType
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
    init?<I1, I2, T>(
      bound1: I1, bound2: I2?, _ arraytype: T?)
    where
    I1: SDAI.SwiftIntConvertible,
    I2: SDAI.SwiftIntConvertible,
    T: SDAI.TypeHierarchy.ARRAY_OPTIONAL__TypeBehavior,
    T.ELEMENT: SDAI.SelectType

//    init?<T>(_ arraytype: T?)
//    where
//    T: SDAI.TypeHierarchy.ARRAY_OPTIONAL__TypeBehavior,
//    T.ELEMENT: SDAI.SelectType
  }
}
public extension SDAI.Initializable.BySelecttypeArrayOptional
{
//  init?<I1, I2, T>(
//    bound1: I1, bound2: I2, _ arraytype: T?)
//	where
//  I1: SDAI.SwiftIntConvertible,
//  I2: SDAI.SwiftIntConvertible,
//  T: SDAI.TypeHierarchy.ARRAY_OPTIONAL__TypeBehavior,
//  T.ELEMENT: SDAI.SelectType
//	{
//		guard let arraytype = arraytype, 
//					bound1.asSwiftInt == arraytype.loIndex, 
//					bound2.asSwiftInt == arraytype.hiIndex 
//		else { return nil }
//		self.init(arraytype)
//	}

  init?<T>(_ arraytype: T?)
  where
  T: SDAI.TypeHierarchy.ARRAY_OPTIONAL__TypeBehavior,
  T.ELEMENT: SDAI.SelectType
  {
    guard let arraytype = arraytype else { return nil }
    self.init(bound1: arraytype.loBound, bound2: arraytype.hiBound, arraytype)
  }
}


//MARK: - from select type array
extension SDAI.Initializable {

  /// from select type array
  public protocol BySelecttypeArray
  {
    init?<I1, I2, T>(
      bound1: I1, bound2: I2?, _ arraytype: T?)
    where
    I1: SDAI.SwiftIntConvertible,
    I2: SDAI.SwiftIntConvertible,
    T: SDAI.TypeHierarchy.ARRAY__TypeBehavior,
    T.ELEMENT: SDAI.SelectType

//    init?<T>(_ arraytype: T?)
//    where
//    T: SDAI.TypeHierarchy.ARRAY__TypeBehavior,
//    T.ELEMENT: SDAI.SelectType
  }
}
public extension SDAI.Initializable.BySelecttypeArray
{
//  init?<I1, I2, T>(
//    bound1: I1, bound2: I2, _ arraytype: T?)
//	where
//  I1: SDAI.SwiftIntConvertible,
//  I2: SDAI.SwiftIntConvertible,
//  T: SDAI.TypeHierarchy.ARRAY__TypeBehavior,
//  T.ELEMENT: SDAI.SelectType
//	{
//		guard let arraytype = arraytype, 
//					bound1.asSwiftInt == arraytype.loIndex, 
//					bound2.asSwiftInt == arraytype.hiIndex 
//		else { return nil }
//		self.init(arraytype)
//	}

  init?<T>(_ arraytype: T?)
  where
  T: SDAI.TypeHierarchy.ARRAY__TypeBehavior,
  T.ELEMENT: SDAI.SelectType
  {
    guard let arraytype = arraytype else { return nil }
    self.init(bound1: arraytype.loBound, bound2: arraytype.hiBound, arraytype)
  }
}
