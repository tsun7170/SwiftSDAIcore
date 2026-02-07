//
//  InitializableByComplexEntityType.swift
//
//
//  Created by Yoshida on 2020/12/17.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - from entity type scalar
extension SDAI.Initializable {

  /// from entity type scalar
  public protocol ByComplexEntity
  {
    init?(possiblyFrom complex: SDAI.ComplexEntity?)
  }
}

public extension SDAI.Initializable.ByComplexEntity
{
  //Initializers
	init?(possiblyFrom entityRef: SDAI.EntityReference?)
  {
		self.init(possiblyFrom: entityRef?.complexEntity)
	}

  init?<PREF>(possiblyFrom pref: PREF?)
  where PREF: SDAI.PersistentReference,
        PREF.ARef: SDAI.EntityReference
  {
    self.init(possiblyFrom: pref?.optionalARef?.complexEntity)
  }


  //Converters
  static func convert(fromComplex complex: SDAI.ComplexEntity?) -> Self?
  {
    return self.init(possiblyFrom: complex)
  }

	static func convert(sibling: SDAI.EntityReference?) -> Self?
  {
		if let sibling = sibling as? Self {
			return sibling
		}
		else {
			return self.init(possiblyFrom: sibling)
		}
	}

	static func convert<PREF>(sibling: PREF?) -> Self?
	where PREF: SDAI.PersistentReference,
				PREF.ARef: SDAI.EntityReference
	{
		if let sibling = sibling as? Self {
			return sibling
		}
		else {
			return self.init(possiblyFrom: sibling)
		}
	}
}


public extension SDAI.Initializable.ByComplexEntity
where Self: SDAI.EntityReference
{
	init?(possiblyFrom complex: SDAI.ComplexEntity?)
  {
		self.init(complex: complex)
	}

}


//MARK: - from entity type list
extension SDAI.Initializable {

  /// from entity type list
  public protocol ByEntityList
  {
    init?<I1, I2, T>(
      bound1: I1, bound2: I2?, _ listtype: T?)
    where
    I1: SDAI.SwiftIntConvertible,
    I2: SDAI.SwiftIntConvertible,
    T: SDAI.TypeHierarchy.LIST__TypeBehavior,
    T.ELEMENT: SDAI.EntityReference

    init?<I1, I2, T>(
      bound1: I1, bound2: I2?, _ listtype: T?)
    where
    I1: SDAI.SwiftIntConvertible,
    I2: SDAI.SwiftIntConvertible,
    T: SDAI.TypeHierarchy.LIST__TypeBehavior,
    T.ELEMENT: SDAI.PersistentReference,
    T.ELEMENT.ARef: SDAI.EntityReference

  }
}
public extension SDAI.Initializable.ByEntityList
{
	init?<T>(_ listtype: T?)
	where
  T: SDAI.TypeHierarchy.LIST__TypeBehavior,
  T.ELEMENT: SDAI.EntityReference
	{
		guard let listtype = listtype else { return nil }
		self.init(bound1: listtype.loBound, bound2: listtype.hiBound, listtype)
	}

	init?<T>(_ listtype: T?)
	where
  T: SDAI.TypeHierarchy.LIST__TypeBehavior,
  T.ELEMENT: SDAI.PersistentReference,
	T.ELEMENT.ARef: SDAI.EntityReference
	{
		guard let listtype = listtype else { return nil }
		self.init(bound1: listtype.loBound, bound2: listtype.hiBound, listtype)
	}
}

//MARK: - from entity type bag
extension SDAI.Initializable {

  /// from entity type bag
  public protocol ByEntityBag
  {
    init?<I1, I2, T>(
      bound1: I1, bound2: I2?, _ bagtype: T?)
    where
    I1: SDAI.SwiftIntConvertible,
    I2: SDAI.SwiftIntConvertible,
    T: SDAI.TypeHierarchy.BAG__TypeBehavior,
    T.ELEMENT: SDAI.EntityReference

    init?<I1, I2, T>(
      bound1: I1, bound2: I2?, _ bagtype: T?)
    where
    I1: SDAI.SwiftIntConvertible,
    I2: SDAI.SwiftIntConvertible,
    T: SDAI.TypeHierarchy.BAG__TypeBehavior,
    T.ELEMENT: SDAI.PersistentReference,
    T.ELEMENT.ARef: SDAI.EntityReference

  }
}
public extension SDAI.Initializable.ByEntityBag
{
  init?<T>(_ bagtype: T?)
	where
  T: SDAI.TypeHierarchy.BAG__TypeBehavior,
  T.ELEMENT: SDAI.EntityReference
	{
		guard let bagtype = bagtype else { return nil }
		self.init(bound1: bagtype.loBound, bound2: bagtype.hiBound, bagtype)
	}
	
  init?<T>(_ bagtype: T?)
	where
  T: SDAI.TypeHierarchy.BAG__TypeBehavior,
  T.ELEMENT: SDAI.PersistentReference,
	T.ELEMENT.ARef: SDAI.EntityReference
	{
		guard let bagtype = bagtype else { return nil }
		self.init(bound1: bagtype.loBound, bound2: bagtype.hiBound, bagtype)
	}
}

//MARK: - from entity type set
extension SDAI.Initializable {

  /// from entity type set
  public protocol ByEntitySet
  {
    init?<I1, I2, T>(
      bound1: I1, bound2: I2?, _ settype: T?)
    where
    I1: SDAI.SwiftIntConvertible,
    I2: SDAI.SwiftIntConvertible,
    T: SDAI.TypeHierarchy.SET__TypeBehavior,
    T.ELEMENT: SDAI.EntityReference

    init?<I1, I2, T>(
      bound1: I1, bound2: I2?, _ settype: T?)
    where
    I1: SDAI.SwiftIntConvertible,
    I2: SDAI.SwiftIntConvertible,
    T: SDAI.TypeHierarchy.SET__TypeBehavior,
    T.ELEMENT: SDAI.PersistentReference,
    T.ELEMENT.ARef: SDAI.EntityReference
  }
}
public extension SDAI.Initializable.ByEntitySet
{
  init?<T>(_ settype: T?)
	where
  T: SDAI.TypeHierarchy.SET__TypeBehavior,
  T.ELEMENT: SDAI.EntityReference
	{
		guard let settype = settype else { return nil }
		self.init(bound1: settype.loBound, bound2: settype.hiBound, settype)
	}

  init?<T>(_ settype: T?)
	where
  T: SDAI.TypeHierarchy.SET__TypeBehavior,
  T.ELEMENT: SDAI.PersistentReference,
	T.ELEMENT.ARef: SDAI.EntityReference
	{
		guard let settype = settype else { return nil }
		self.init(bound1: settype.loBound, bound2: settype.hiBound, settype)
	}
}


//MARK: - from entity type array optional
extension SDAI.Initializable {

  /// from entity type array optional
  public protocol ByEntityArrayOptional
  {
    init?<I1, I2, T>(
      bound1: I1, bound2: I2?, _ arraytype: T?)
    where
    I1: SDAI.SwiftIntConvertible,
    I2: SDAI.SwiftIntConvertible,
    T: SDAI.TypeHierarchy.ARRAY_OPTIONAL__TypeBehavior,
    T.ELEMENT: SDAI.EntityReference

    init?<I1, I2, T>(
      bound1: I1, bound2: I2?, _ arraytype: T?)
    where
    I1: SDAI.SwiftIntConvertible,
    I2: SDAI.SwiftIntConvertible,
    T: SDAI.TypeHierarchy.ARRAY_OPTIONAL__TypeBehavior,
    T.ELEMENT: SDAI.PersistentReference,
    T.ELEMENT.ARef: SDAI.EntityReference


//    init?<T>(_ arraytype: T?)
//    where
//    T: SDAI.TypeHierarchy.ARRAY_OPTIONAL__TypeBehavior,
//    T.ELEMENT: SDAI.EntityReference
//
//    init?<T>(_ arraytype: T?)
//    where
//    T: SDAI.TypeHierarchy.ARRAY_OPTIONAL__TypeBehavior,
//    T.ELEMENT: SDAI.PersistentReference,
//    T.ELEMENT.ARef: SDAI.EntityReference
  }
}
public extension SDAI.Initializable.ByEntityArrayOptional
{
//  init?<I1, I2, T>(
//		bound1: I1, bound2: I2, _ arraytype: T?)
//	where
//  I1: SDAI.SwiftIntConvertible,
//  I2: SDAI.SwiftIntConvertible,
//  T: SDAI.TypeHierarchy.ARRAY_OPTIONAL__TypeBehavior,
//  T.ELEMENT: SDAI.EntityReference
//	{
//		guard let arraytype = arraytype, 
//					bound1.asSwiftInt == arraytype.loIndex, 
//					bound2.asSwiftInt == arraytype.hiIndex 
//		else { return nil }
//		self.init(arraytype)
//	}
//
//  init?<I1, I2, T>(
//		bound1: I1, bound2: I2, _ arraytype: T?)
//	where
//  I1: SDAI.SwiftIntConvertible,
//  I2: SDAI.SwiftIntConvertible,
//  T: SDAI.TypeHierarchy.ARRAY_OPTIONAL__TypeBehavior,
//  T.ELEMENT: SDAI.PersistentReference,
//	T.ELEMENT.ARef: SDAI.EntityReference
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
  T.ELEMENT: SDAI.EntityReference
  {
    guard let arraytype = arraytype else { return nil }
    self.init(bound1: arraytype.loBound, bound2: arraytype.hiBound, arraytype)
  }

  init?<T>(_ arraytype: T?)
  where
  T: SDAI.TypeHierarchy.ARRAY_OPTIONAL__TypeBehavior,
  T.ELEMENT: SDAI.PersistentReference,
  T.ELEMENT.ARef: SDAI.EntityReference
  {
    guard let arraytype = arraytype else { return nil }
    self.init(bound1: arraytype.loBound, bound2: arraytype.hiBound, arraytype)
  }
}


//MARK: - from entity type array
extension SDAI.Initializable {

  /// from entity type array
  public protocol ByEntityArray
  {
    init?<I1, I2, T>(
      bound1: I1, bound2: I2?, _ arraytype: T?)
    where
    I1: SDAI.SwiftIntConvertible,
    I2: SDAI.SwiftIntConvertible,
    T: SDAI.TypeHierarchy.ARRAY__TypeBehavior,
    T.ELEMENT: SDAI.EntityReference

    init?<I1, I2, T>(
      bound1: I1, bound2: I2?, _ arraytype: T?)
    where
    I1: SDAI.SwiftIntConvertible,
    I2: SDAI.SwiftIntConvertible,
    T: SDAI.TypeHierarchy.ARRAY__TypeBehavior,
    T.ELEMENT: SDAI.PersistentReference,
    T.ELEMENT.ARef: SDAI.EntityReference

//    init?<T>(_ arraytype: T?)
//    where
//    T: SDAI.TypeHierarchy.ARRAY__TypeBehavior,
//    T.ELEMENT: SDAI.EntityReference
//
//    init?<T>(_ arraytype: T?)
//    where
//    T: SDAI.TypeHierarchy.ARRAY__TypeBehavior,
//    T.ELEMENT: SDAI.PersistentReference,
//    T.ELEMENT.ARef: SDAI.EntityReference
  }
}
public extension SDAI.Initializable.ByEntityArray
{
//  init?<I1, I2, T>(
//		bound1: I1, bound2: I2, _ arraytype: T?)
//	where
//  I1: SDAI.SwiftIntConvertible,
//  I2: SDAI.SwiftIntConvertible,
//  T: SDAI.TypeHierarchy.ARRAY__TypeBehavior,
//  T.ELEMENT: SDAI.EntityReference
//	{
//		guard let arraytype = arraytype, 
//					bound1.asSwiftInt == arraytype.loIndex, 
//					bound2.asSwiftInt == arraytype.hiIndex 
//		else { return nil }
//		self.init(arraytype)
//	}
//
//  init?<I1, I2, T>(
//		bound1: I1, bound2: I2, _ arraytype: T?)
//	where
//  I1: SDAI.SwiftIntConvertible,
//  I2: SDAI.SwiftIntConvertible,
//  T: SDAI.TypeHierarchy.ARRAY__TypeBehavior,
//  T.ELEMENT: SDAI.PersistentReference,
//	T.ELEMENT.ARef: SDAI.EntityReference
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
  T.ELEMENT: SDAI.EntityReference
  {
    guard let arraytype = arraytype else { return nil }
    self.init(bound1: arraytype.loBound, bound2: arraytype.hiBound, arraytype)
  }

  init?<T>(_ arraytype: T?)
  where
  T: SDAI.TypeHierarchy.ARRAY__TypeBehavior,
  T.ELEMENT: SDAI.PersistentReference,
  T.ELEMENT.ARef: SDAI.EntityReference
  {
    guard let arraytype = arraytype else { return nil }
    self.init(bound1: arraytype.loBound, bound2: arraytype.hiBound, arraytype)
  }

}
