//
//  InitializableByDefinedtype.swift
//  
//
//  Created by Yoshida on 2020/12/17.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - from defined type scalar
extension SDAI.Initializable {

  /// from defined type scalar
  public protocol ByDefinedType
  {
    init?<T>(possiblyFrom underlyingType: T?)
    where T: SDAI.UnderlyingType
  }
}
public extension SDAI.Initializable.ByDefinedType
{
	init?<T>(_ underlyingType: T?)
  where T: SDAI.UnderlyingType
	{
		self.init(possiblyFrom: underlyingType)
	}	
	
	static func convert<T>(sibling: T?) -> Self?
  where T: SDAI.UnderlyingType
  {
		if let sibling = sibling as? Self {
			return sibling
		}
		else {
			return self.init(possiblyFrom: sibling)
		}
	}
}




//MARK: - from defined type list
extension SDAI.Initializable {

  /// from defined type list
  public protocol ByDefinedtypeList
  {
    init?<I1, I2, T>(bound1: I1, bound2: I2?, _ listtype: T?)
    where
    I1: SDAI.SwiftIntConvertible,
    I2: SDAI.SwiftIntConvertible,
    T: SDAI.TypeHierarchy.LIST__TypeBehavior,
    T.ELEMENT: SDAI.UnderlyingType
  }
}
public extension SDAI.Initializable.ByDefinedtypeList
{
	init?<T>(_ listtype: T?)
	where
  T: SDAI.TypeHierarchy.LIST__TypeBehavior,
  T.ELEMENT: SDAI.UnderlyingType
	{
		guard let listtype = listtype else {  return nil }
		self.init(bound1: listtype.loBound, bound2: listtype.hiBound, listtype)
	}
}


//MARK: - from defined type bag
extension SDAI.Initializable {

  /// from defined type bag
  public protocol ByDefinedtypeBag
  {
    init?<I1, I2, T>(
      bound1: I1, bound2: I2?, _ bagtype: T?)
    where
    I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.TypeHierarchy.BAG__TypeBehavior,
    T.ELEMENT: SDAI.UnderlyingType
  }
}
public extension SDAI.Initializable.ByDefinedtypeBag
{
  init?<T>(_ bagtype: T?)
	where
  T: SDAI.TypeHierarchy.BAG__TypeBehavior,
  T.ELEMENT: SDAI.UnderlyingType
	{
		guard let bagtype = bagtype else { return nil }
		self.init(bound1: bagtype.loBound, bound2: bagtype.hiBound, bagtype)
	}
}


//MARK: - from defined type set
extension SDAI.Initializable {
  /// from defined type set
  public protocol ByDefinedtypeSet
  {
    init?<I1, I2, T>(
      bound1: I1, bound2: I2?, _ settype: T?)
    where
    I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.TypeHierarchy.SET__TypeBehavior,
    T.ELEMENT: SDAI.UnderlyingType
  }
}
public extension SDAI.Initializable.ByDefinedtypeSet
{
  init?<T>(_ settype: T?)
	where
  T: SDAI.TypeHierarchy.SET__TypeBehavior,
  T.ELEMENT: SDAI.UnderlyingType
	{
		guard let settype = settype else { return nil }
		self.init(bound1: settype.loBound, bound2: settype.hiBound, settype)
	}
}

//MARK: - from defined type array optional
extension SDAI.Initializable {

  /// from defined type array optional
  public protocol ByDefinedtypeArrayOptional
  {
    init?<I1, I2, T>(bound1: I1, bound2: I2?, _ arraytype: T?)
    where
    I1: SDAI.SwiftIntConvertible,
    I2: SDAI.SwiftIntConvertible,
    T: SDAI.TypeHierarchy.ARRAY_OPTIONAL__TypeBehavior,
    T.ELEMENT: SDAI.UnderlyingType

//    init?<T>(_ arraytype: T?)
//    where
//    T: SDAI.TypeHierarchy.ARRAY_OPTIONAL__TypeBehavior,
//    T.ELEMENT: SDAI.UnderlyingType

  }
}
public extension SDAI.Initializable.ByDefinedtypeArrayOptional
{
//  init?<I1, I2, T>(bound1: I1, bound2: I2, _ arraytype: T?)
//	where
//  I1: SDAI.SwiftIntConvertible,
//  I2: SDAI.SwiftIntConvertible,
//  T: SDAI.TypeHierarchy.ARRAY_OPTIONAL__TypeBehavior,
//  T.ELEMENT: SDAI.UnderlyingType
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
  T.ELEMENT: SDAI.UnderlyingType
  {
    guard let arraytype = arraytype else { return nil }
    self.init(bound1: arraytype.loBound, bound2: arraytype.hiBound, arraytype)
  }
}


//MARK: - from defined type array
extension SDAI.Initializable {

  /// from defined type array
  public protocol ByDefinedtypeArray
  {
    init?<I1, I2, T>(bound1: I1, bound2: I2?, _ arraytype: T?)
    where
    I1: SDAI.SwiftIntConvertible,
    I2: SDAI.SwiftIntConvertible,
    T: SDAI.TypeHierarchy.ARRAY__TypeBehavior,
    T.ELEMENT: SDAI.UnderlyingType

//    init?<T>(_ arraytype: T?)
//    where
//    T: SDAI.TypeHierarchy.ARRAY__TypeBehavior,
//    T.ELEMENT: SDAI.UnderlyingType
  }
}
public extension SDAI.Initializable.ByDefinedtypeArray
{
//  init?<I1, I2, T>(bound1: I1, bound2: I2, _ arraytype: T?)
//	where
//  I1: SDAI.SwiftIntConvertible,
//  I2: SDAI.SwiftIntConvertible,
//  T: SDAI.TypeHierarchy.ARRAY__TypeBehavior,
//  T.ELEMENT: SDAI.UnderlyingType
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
  T.ELEMENT: SDAI.UnderlyingType
  {
    guard let arraytype = arraytype else { return nil }
    self.init(bound1: arraytype.loBound, bound2: arraytype.hiBound, arraytype)
  }
}
