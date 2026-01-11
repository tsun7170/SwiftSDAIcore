//
//  InitializableByComplexEntityType.swift
//
//
//  Created by Yoshida on 2020/12/17.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - from entity type scalar
extension SDAI {
  public protocol InitializableByComplexEntity
  {
    init?(possiblyFrom complex: SDAI.ComplexEntity?)
  }
}

public extension SDAI.InitializableByComplexEntity
{
  //Initializers
	init?(possiblyFrom entityRef: SDAI.EntityReference?)
  {
		self.init(possiblyFrom: entityRef?.complexEntity)
	}

  init?<PREF>(possiblyFrom pref: PREF?)
  where PREF: SDAIPersistentReference,
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
	where PREF: SDAIPersistentReference,
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


public extension SDAI.InitializableByComplexEntity
where Self: SDAI.EntityReference
{
	init?(possiblyFrom complex: SDAI.ComplexEntity?)
  {
		self.init(complex: complex)
	}

}


//MARK: - from entity type list
extension SDAI {
  public protocol InitializableByEntityList
  {
    init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__LIST__type>(
      bound1: I1, bound2: I2?, _ listtype: T?)
    where T.ELEMENT: SDAI.EntityReference

    init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__LIST__type>(
      bound1: I1, bound2: I2?, _ listtype: T?)
    where T.ELEMENT: SDAIPersistentReference,
    T.ELEMENT.ARef: SDAI.EntityReference

  }
}
public extension SDAI.InitializableByEntityList
{
	init?<T: SDAI__LIST__type>(_ listtype: T?) 
	where T.ELEMENT: SDAI.EntityReference
	{
		guard let listtype = listtype else { return nil }
		self.init(bound1: listtype.loBound, bound2: listtype.hiBound, listtype)
	}

	init?<T: SDAI__LIST__type>(_ listtype: T?)
	where T.ELEMENT: SDAIPersistentReference,
	T.ELEMENT.ARef: SDAI.EntityReference
	{
		guard let listtype = listtype else { return nil }
		self.init(bound1: listtype.loBound, bound2: listtype.hiBound, listtype)
	}
}

//MARK: - from entity type bag
extension SDAI {
  public protocol InitializableByEntityBag
  {
    init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__BAG__type>(
      bound1: I1, bound2: I2?, _ bagtype: T?)
    where T.ELEMENT: SDAI.EntityReference

    init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__BAG__type>(
      bound1: I1, bound2: I2?, _ bagtype: T?)
    where T.ELEMENT: SDAIPersistentReference,
    T.ELEMENT.ARef: SDAI.EntityReference

  }
}
public extension SDAI.InitializableByEntityBag
{
	init?<T: SDAI__BAG__type>(_ bagtype: T?) 
	where T.ELEMENT: SDAI.EntityReference
	{
		guard let bagtype = bagtype else { return nil }
		self.init(bound1: bagtype.loBound, bound2: bagtype.hiBound, bagtype)
	}
	
	init?<T: SDAI__BAG__type>(_ bagtype: T?)
	where T.ELEMENT: SDAIPersistentReference,
	T.ELEMENT.ARef: SDAI.EntityReference
	{
		guard let bagtype = bagtype else { return nil }
		self.init(bound1: bagtype.loBound, bound2: bagtype.hiBound, bagtype)
	}
}

//MARK: - from entity type set
extension SDAI {
  public protocol InitializableByEntitySet
  {
    init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__SET__type>(
      bound1: I1, bound2: I2?, _ settype: T?)
    where T.ELEMENT: SDAI.EntityReference

    init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__SET__type>(
      bound1: I1, bound2: I2?, _ settype: T?)
    where T.ELEMENT: SDAIPersistentReference,
    T.ELEMENT.ARef: SDAI.EntityReference
  }
}
public extension SDAI.InitializableByEntitySet
{
	init?<T: SDAI__SET__type>(_ settype: T?) 
	where T.ELEMENT: SDAI.EntityReference
	{
		guard let settype = settype else { return nil }
		self.init(bound1: settype.loBound, bound2: settype.hiBound, settype)
	}

	init?<T: SDAI__SET__type>(_ settype: T?)
	where T.ELEMENT: SDAIPersistentReference,
	T.ELEMENT.ARef: SDAI.EntityReference
	{
		guard let settype = settype else { return nil }
		self.init(bound1: settype.loBound, bound2: settype.hiBound, settype)
	}
}


//MARK: - from entity type array optional
extension SDAI {
  public protocol InitializableByEntityArrayOptional
  {
    init?<T: SDAI__ARRAY_OPTIONAL__type>(_ arraytype: T?)
    where T.ELEMENT: SDAI.EntityReference

    init?<T: SDAI__ARRAY_OPTIONAL__type>(_ arraytype: T?)
    where T.ELEMENT: SDAIPersistentReference,
    T.ELEMENT.ARef: SDAI.EntityReference
  }
}
public extension SDAI.InitializableByEntityArrayOptional
{
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__ARRAY_OPTIONAL__type>(
		bound1: I1, bound2: I2, _ arraytype: T?) 
	where T.ELEMENT: SDAI.EntityReference
	{
		guard let arraytype = arraytype, 
					bound1.asSwiftInt == arraytype.loIndex, 
					bound2.asSwiftInt == arraytype.hiIndex 
		else { return nil }
		self.init(arraytype)
	}

	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__ARRAY_OPTIONAL__type>(
		bound1: I1, bound2: I2, _ arraytype: T?)
	where T.ELEMENT: SDAIPersistentReference,
	T.ELEMENT.ARef: SDAI.EntityReference
	{
		guard let arraytype = arraytype, 
					bound1.asSwiftInt == arraytype.loIndex, 
					bound2.asSwiftInt == arraytype.hiIndex 
		else { return nil }
		self.init(arraytype)
	}
}


//MARK: - from entity type array
extension SDAI {
  public protocol InitializableByEntityArray
  {
    init?<T: SDAI__ARRAY__type>(_ arraytype: T?)
    where T.ELEMENT: SDAI.EntityReference

    init?<T: SDAI__ARRAY__type>(_ arraytype: T?)
    where T.ELEMENT: SDAIPersistentReference,
    T.ELEMENT.ARef: SDAI.EntityReference
  }
}
public extension SDAI.InitializableByEntityArray
{
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__ARRAY__type>(
		bound1: I1, bound2: I2, _ arraytype: T?) 
	where T.ELEMENT: SDAI.EntityReference
	{
		guard let arraytype = arraytype, 
					bound1.asSwiftInt == arraytype.loIndex, 
					bound2.asSwiftInt == arraytype.hiIndex 
		else { return nil }
		self.init(arraytype)
	}

	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__ARRAY__type>(
		bound1: I1, bound2: I2, _ arraytype: T?)
	where T.ELEMENT: SDAIPersistentReference,
	T.ELEMENT.ARef: SDAI.EntityReference
	{
		guard let arraytype = arraytype, 
					bound1.asSwiftInt == arraytype.loIndex, 
					bound2.asSwiftInt == arraytype.hiIndex 
		else { return nil }
		self.init(arraytype)
	}
}
