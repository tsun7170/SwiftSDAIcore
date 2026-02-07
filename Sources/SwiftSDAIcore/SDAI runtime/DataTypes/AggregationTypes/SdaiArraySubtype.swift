//
//  SdaiArraySubtype.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - ARRAY subtype (8.2.1, 8.3.2)
extension SDAI.TypeHierarchy {
  public protocol ARRAY__Subtype: SDAI.TypeHierarchy.ARRAY__TypeBehavior, SDAI.DefinedType
  where Supertype: SDAI.TypeHierarchy.ARRAY__TypeBehavior
  {}
}

public extension SDAI.TypeHierarchy.ARRAY__Subtype
{
	//MARK: SDAI.ArrayOptionalType
	static var uniqueFlag: SDAI.BOOLEAN { Supertype.uniqueFlag }
	static var optionalFlag: SDAI.BOOLEAN { Supertype.optionalFlag }
	
	//MARK: InitializableByGenerictype
	init?<G: SDAI.GenericType>(fromGeneric generic: G?) {
		guard let fundamental = FundamentalType.convert(fromGeneric: generic) else { return nil }
		self.init(fundamental: fundamental)
	}
	
	//MARK: InitializableByGenericArray
  init?<I1, I2, T>(
    bound1: I1, bound2: I2?, generic arraytype: T?)
  where
  I1: SDAI.SwiftIntConvertible,
  I2: SDAI.SwiftIntConvertible,
  T: SDAI.TypeHierarchy.ARRAY__TypeBehavior
  {
    self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, generic: arraytype))
  }

  init?<T: SDAI.TypeHierarchy.ARRAY__TypeBehavior>(generic arraytype: T?) {
		self.init(fundamental: FundamentalType(generic: arraytype))
	}

  //MARK: InitializableByGenericArrayOptional
  init?<I1, I2, T>(
    bound1: I1, bound2: I2?, generic arraytype: T?)
  where
  I1: SDAI.SwiftIntConvertible,
  I2: SDAI.SwiftIntConvertible,
  T: SDAI.TypeHierarchy.ARRAY_OPTIONAL__TypeBehavior
  {
    self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, generic: arraytype))
  }

	//MARK: InitializableBySwifttypeAsArray
	init<I1, I2>(
		from swiftValue: SwiftType, bound1: I1, bound2: I2?)
  where
  I1: SDAI.SwiftIntConvertible,
  I2: SDAI.SwiftIntConvertible
	{
		self.init(fundamental: FundamentalType(from: swiftValue, bound1: bound1, bound2: bound2) )
	} 
	
	//MARK: SDAI.Initializable.ByArrayLiteral
	init?<I1, I2, E>(
		bound1: I1, bound2: I2?,
    _ elements: [SDAI.AggregationInitializerElement<E>])
  where
  I1: SDAI.SwiftIntConvertible,
  I2: SDAI.SwiftIntConvertible,
  E: SDAI.GenericType
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, elements) )
	} 

}


//MARK: - for SDAI.Initializable.BySelectType ELEMENT
public extension SDAI.TypeHierarchy.ARRAY__Subtype
where ELEMENT: SDAI.Initializable.BySelectType
{
  init?<I1, I2, T>(
    bound1: I1, bound2: I2?, _ arraytype: T?)
  where
  I1: SDAI.SwiftIntConvertible,
  I2: SDAI.SwiftIntConvertible,
  T: SDAI.TypeHierarchy.ARRAY__TypeBehavior,
  T.ELEMENT: SDAI.SelectType
  {
    self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, arraytype) )
  }



  init?<I1, I2, T>(
    bound1: I1, bound2: I2?, _ arraytype: T?)
  where
  I1: SDAI.SwiftIntConvertible,
  I2: SDAI.SwiftIntConvertible,
  T: SDAI.TypeHierarchy.ARRAY_OPTIONAL__TypeBehavior,
  T.ELEMENT: SDAI.SelectType
  {
    self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, arraytype) )
  }


}



//MARK: - for SDAI.Initializable.ByComplexEntity ELEMENT
public extension SDAI.TypeHierarchy.ARRAY__Subtype
where ELEMENT: SDAI.Initializable.ByComplexEntity
{
  init?<I1, I2, T>(
    bound1: I1, bound2: I2?, _ arraytype: T?)
  where
  I1: SDAI.SwiftIntConvertible,
  I2: SDAI.SwiftIntConvertible,
  T: SDAI.TypeHierarchy.ARRAY__TypeBehavior,
  T.ELEMENT: SDAI.EntityReference
  {
    self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, arraytype) )
  }

  init?<I1, I2, T>(
    bound1: I1, bound2: I2?, _ arraytype: T?)
  where
  I1: SDAI.SwiftIntConvertible,
  I2: SDAI.SwiftIntConvertible,
  T: SDAI.TypeHierarchy.ARRAY__TypeBehavior,
  T.ELEMENT: SDAI.PersistentReference,
  T.ELEMENT.ARef: SDAI.EntityReference
  {
    self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, arraytype) )
  }



  init?<I1, I2, T>(
    bound1: I1, bound2: I2?, _ arraytype: T?)
  where
  I1: SDAI.SwiftIntConvertible,
  I2: SDAI.SwiftIntConvertible,
  T: SDAI.TypeHierarchy.ARRAY_OPTIONAL__TypeBehavior,
  T.ELEMENT: SDAI.EntityReference
  {
    self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, arraytype) )
  }

  init?<I1, I2, T>(
    bound1: I1, bound2: I2?, _ arraytype: T?)
  where
  I1: SDAI.SwiftIntConvertible,
  I2: SDAI.SwiftIntConvertible,
  T: SDAI.TypeHierarchy.ARRAY_OPTIONAL__TypeBehavior,
  T.ELEMENT: SDAI.PersistentReference,
  T.ELEMENT.ARef: SDAI.EntityReference
  {
    self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, arraytype) )
  }




}


//MARK: - for SDAI.Initializable.ByDefinedType ELEMENT
public extension SDAI.TypeHierarchy.ARRAY__Subtype
where ELEMENT: SDAI.Initializable.ByDefinedType
{
  init?<I1, I2, T>(bound1: I1, bound2: I2?, _ arraytype: T?)
  where
  I1: SDAI.SwiftIntConvertible,
  I2: SDAI.SwiftIntConvertible,
  T: SDAI.TypeHierarchy.ARRAY__TypeBehavior,
  T.ELEMENT: SDAI.UnderlyingType
  {
    self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, arraytype) )
  }



  init?<I1, I2, T>(bound1: I1, bound2: I2?, _ arraytype: T?)
  where
  I1: SDAI.SwiftIntConvertible,
  I2: SDAI.SwiftIntConvertible,
  T: SDAI.TypeHierarchy.ARRAY_OPTIONAL__TypeBehavior,
  T.ELEMENT: SDAI.UnderlyingType
  {
    self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, arraytype) )
  }


}


