//
//  SdaiArrayOptionalSubtype.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - ARRAY_OPTIONAL subtype (8.2.1, 8.3.2)
public protocol SDAI__ARRAY_OPTIONAL__subtype: SDAI__ARRAY_OPTIONAL__type, SDAIDefinedType
where Supertype: SDAI__ARRAY_OPTIONAL__type
{}
public extension SDAI__ARRAY_OPTIONAL__subtype
{
	// SDAIArrayOptionalType
	static var uniqueFlag: SDAI.BOOLEAN { Supertype.uniqueFlag }
	static var optionalFlag: SDAI.BOOLEAN { Supertype.optionalFlag }
	
	// InitializableByGenerictype
	init?<G: SDAIGenericType>(fromGeneric generic: G?) {
		guard let fundamental = FundamentalType.convert(fromGeneric: generic) else { return nil }
		self.init(fundamental: fundamental)
	}
	
	// InitializableByGenericArray
	init?<T: SDAI__ARRAY__type>(generic arraytype: T?) {
		self.init(fundamental: FundamentalType(generic: arraytype))
	}

	// InitializableByGenericArrayOptional
	init?<T: SDAI__ARRAY_OPTIONAL__type>(generic arraytype: T?) {
		self.init(fundamental: FundamentalType(generic: arraytype))
	}
	
	// InitializableByEmptyArrayLiteral
	init<I1: SwiftIntConvertible, I2: SwiftIntConvertible>(
		bound1: I1, bound2: I2, _ emptyLiteral: SDAI.EmptyAggregateLiteral = SDAI.EMPTY_AGGREGATE)
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, emptyLiteral) )
	} 
	
	// InitializableBySwifttypeAsArray
	init<I1: SwiftIntConvertible, I2: SwiftIntConvertible>(
		from swiftValue: SwiftType, bound1: I1, bound2: I2)
	{
		self.init(fundamental: FundamentalType(from: swiftValue, bound1: bound1, bound2: bound2) )
	} 
	
	// InitializableByArrayLiteral
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E: SDAIGenericType>(
		bound1: I1, bound2: I2, _ elements: [SDAI.AggregationInitializerElement<E>])
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, elements))
	} 
}

//MARK: - for select type element
public extension SDAI__ARRAY_OPTIONAL__subtype
where ELEMENT: InitializableBySelectType
{
	init?<T:SDAI__ARRAY_OPTIONAL__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAISelectType
	{
		self.init(fundamental: FundamentalType(arraytype) )
	}	

	init?<T:SDAI__ARRAY__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAISelectType
	{
		self.init(fundamental: FundamentalType(arraytype) )
	}
}


//MARK: - for entity type element
public extension SDAI__ARRAY_OPTIONAL__subtype
where ELEMENT: InitializableByComplexEntity
{
	init?<T: SDAI__ARRAY_OPTIONAL__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAI.EntityReference
	{
		self.init(fundamental: FundamentalType(arraytype) )
	}

	init?<T: SDAI__ARRAY__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAI.EntityReference
	{
		self.init(fundamental: FundamentalType(arraytype) )
	}	


	init?<T: SDAI__ARRAY_OPTIONAL__type>(_ arraytype: T?)
	where T.ELEMENT: SDAIPersistentReference,
	T.ELEMENT.ARef: SDAI.EntityReference
	{
		self.init(fundamental: FundamentalType(arraytype) )
	}

	init?<T: SDAI__ARRAY__type>(_ arraytype: T?)
	where T.ELEMENT: SDAIPersistentReference,
	T.ELEMENT.ARef: SDAI.EntityReference
	{
		self.init(fundamental: FundamentalType(arraytype) )
	}
}


//MARK: - for defined type element
public extension SDAI__ARRAY_OPTIONAL__subtype
where ELEMENT: InitializableByDefinedType
{
	init?<T:SDAI__ARRAY_OPTIONAL__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAIUnderlyingType
	{
		self.init(fundamental: FundamentalType(arraytype) )
	}	

	init?<T:SDAI__ARRAY__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAIUnderlyingType
	{
		self.init(fundamental: FundamentalType(arraytype) )
	}
}


