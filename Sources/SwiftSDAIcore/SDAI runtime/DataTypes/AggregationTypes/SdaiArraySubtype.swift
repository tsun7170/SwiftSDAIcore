//
//  SdaiArraySubtype.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - ARRAY subtype (8.2.1, 8.3.2)
extension SDAI {
  public protocol ARRAY__Subtype: SDAI.ARRAY__TypeBehavior, SDAI.DefinedType
  where Supertype: SDAI.ARRAY__TypeBehavior
  {}
}

public extension SDAI.ARRAY__Subtype
{
	// SDAI.ArrayOptionalType
	static var uniqueFlag: SDAI.BOOLEAN { Supertype.uniqueFlag }
	static var optionalFlag: SDAI.BOOLEAN { Supertype.optionalFlag }
	
	// InitializableByGenerictype
	init?<G: SDAI.GenericType>(fromGeneric generic: G?) {
		guard let fundamental = FundamentalType.convert(fromGeneric: generic) else { return nil }
		self.init(fundamental: fundamental)
	}
	
	// InitializableByGenericArray
	init?<T: SDAI.ARRAY__TypeBehavior>(generic arraytype: T?) {
		self.init(fundamental: FundamentalType(generic: arraytype))
	}

	
	// InitializableBySwifttypeAsArray
	init<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible>(
		from swiftValue: SwiftType, bound1: I1, bound2: I2)
	{
		self.init(fundamental: FundamentalType(from: swiftValue, bound1: bound1, bound2: bound2) )
	} 
	
	// SDAI.InitializableByArrayLiteral
	init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, E: SDAI.GenericType>(
		bound1: I1, bound2: I2, _ elements: [SDAI.AggregationInitializerElement<E>])
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, elements) )
	} 

}


//MARK: - for select type element
public extension SDAI.ARRAY__Subtype
where ELEMENT: SDAI.InitializableBySelectType
{
	init?<T:SDAI.ARRAY__TypeBehavior>(_ arraytype: T?) 
	where T.ELEMENT: SDAI.SelectType
	{
		self.init(fundamental: FundamentalType(arraytype) )
	}
}



//MARK: - for entity type element
public extension SDAI.ARRAY__Subtype
where ELEMENT: SDAI.InitializableByComplexEntity
{
	init?<T: SDAI.ARRAY__TypeBehavior>(_ arraytype: T?) 
	where T.ELEMENT: SDAI.EntityReference
	{
		self.init(fundamental: FundamentalType(arraytype) )
	}

	init?<T: SDAI.ARRAY__TypeBehavior>(_ arraytype: T?)
	where T.ELEMENT: SDAI.PersistentReference,
	T.ELEMENT.ARef: SDAI.EntityReference
	{
		self.init(fundamental: FundamentalType(arraytype) )
	}
}


//MARK: - for defined type element
public extension SDAI.ARRAY__Subtype
where ELEMENT: SDAI.InitializableByDefinedType
{
	init?<T:SDAI.ARRAY__TypeBehavior>(_ arraytype: T?) 
	where T.ELEMENT: SDAI.UnderlyingType
	{
		self.init(fundamental: FundamentalType(arraytype) )
	}
}


