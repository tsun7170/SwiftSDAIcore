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
    init?<T: SDAI.UnderlyingType>(possiblyFrom underlyingType: T?)
  }
}
public extension SDAI.Initializable.ByDefinedType
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
extension SDAI.Initializable {
  /// from defined type list
  public protocol ByDefinedtypeList
  {
    init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.TypeHierarchy.LIST__TypeBehavior>(bound1: I1, bound2: I2?, _ listtype: T?)
    where T.ELEMENT: SDAI.UnderlyingType
  }
}
public extension SDAI.Initializable.ByDefinedtypeList
{
	init?<T: SDAI.TypeHierarchy.LIST__TypeBehavior>(_ listtype: T?) 
	where T.ELEMENT: SDAI.UnderlyingType
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
    init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.TypeHierarchy.BAG__TypeBehavior>(bound1: I1, bound2: I2?, _ bagtype: T?)
    where T.ELEMENT: SDAI.UnderlyingType
  }
}
public extension SDAI.Initializable.ByDefinedtypeBag
{
  init?<T: SDAI.TypeHierarchy.BAG__TypeBehavior>(_ bagtype: T?)
	where T.ELEMENT: SDAI.UnderlyingType
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
    init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.TypeHierarchy.SET__TypeBehavior>(bound1: I1, bound2: I2?, _ settype: T?)
    where T.ELEMENT: SDAI.UnderlyingType
  }
}
public extension SDAI.Initializable.ByDefinedtypeSet
{
  init?<T: SDAI.TypeHierarchy.SET__TypeBehavior>(_ settype: T?)
	where T.ELEMENT: SDAI.UnderlyingType
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
    init?<T: SDAI.TypeHierarchy.ARRAY_OPTIONAL__TypeBehavior>(_ arraytype: T?)
    where T.ELEMENT: SDAI.UnderlyingType
  }
}
public extension SDAI.Initializable.ByDefinedtypeArrayOptional
{
  init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.TypeHierarchy.ARRAY_OPTIONAL__TypeBehavior>(bound1: I1, bound2: I2, _ arraytype: T?)
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
extension SDAI.Initializable {
  /// from defined type array
  public protocol ByDefinedtypeArray
  {
    init?<T: SDAI.TypeHierarchy.ARRAY__TypeBehavior>(_ arraytype: T?)
    where T.ELEMENT: SDAI.UnderlyingType
  }
}
public extension SDAI.Initializable.ByDefinedtypeArray
{
  init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.TypeHierarchy.ARRAY__TypeBehavior>(bound1: I1, bound2: I2, _ arraytype: T?)
	where T.ELEMENT: SDAI.UnderlyingType
	{
		guard let arraytype = arraytype, 
					bound1.asSwiftInt == arraytype.loIndex, 
					bound2.asSwiftInt == arraytype.hiIndex 
		else { return nil }
		self.init(arraytype)
	}
}
