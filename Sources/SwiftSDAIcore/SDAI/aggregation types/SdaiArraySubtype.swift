//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation

//MARK: - ARRAY subtype
public protocol SDAI__ARRAY__subtype: SDAI__ARRAY__type, SDAIDefinedType
where Supertype: SDAI__ARRAY__type, 
			Supertype.FundamentalType == SDAI.ARRAY<ELEMENT>, 
			ELEMENT: SDAIGenericType
{}
public extension SDAI__ARRAY__subtype
{
	// SDAIGenericType
	init?<S: SDAISelectType>(possiblyFrom select: S?) {
		guard let fundamental = FundamentalType(possiblyFrom: select) else { return nil }
		self.init(fundamental: fundamental)
	}
	
	// SDAI__ARRAY_OPTIONAL__type \SDAI__ARRAY__type\SDAI__ARRAY__subtype
	init(from swiftValue: SwiftType, bound1: Int, bound2: Int) {
//		abstruct()
		self.init( FundamentalType(from: swiftValue, bound1: bound1, bound2: bound2) )
	} 
}

public extension SDAI__ARRAY__subtype
where Supertype.FundamentalType: InitializableByEntityArray, ELEMENT: SDAI.EntityReference
{
	// InitializableByArray \SDAI__ARRAY_OPTIONAL__type\SDAI__ARRAY__type\SDAI__ARRAY__subtype
	init(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<SDAI.EntityReference>]) {
		self.init( FundamentalType(bound1: bound1, bound2: bound2, elements) )
	}

	init<T: SDAI__ARRAY__type>(_ arraytype: T) 
	where T.ELEMENT: SDAI.EntityReference, T.Element == T.ELEMENT
	{
		self.init( FundamentalType(arraytype) )
	}
}

public extension SDAI__ARRAY__subtype
where Supertype.FundamentalType: InitializableByDefinedtypeArray, ELEMENT: SDAIUnderlyingType
{
	init<E: SDAIUnderlyingType>(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E.FundamentalType == ELEMENT.FundamentalType
	{
		self.init( FundamentalType(bound1: bound1, bound2: bound2, elements) )
	}

	init<T:SDAI__ARRAY__type>(_ arraytype: T) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element
	{
		self.init( FundamentalType(arraytype) )
	}
}

public extension SDAI__ARRAY__subtype
where Supertype.FundamentalType: InitializableBySelecttypeArray
{
	init<E: SDAISelectType>(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	{
		self.init( FundamentalType(bound1: bound1, bound2: bound2, elements) )
	}

	init<T:SDAI__ARRAY__type>(_ arraytype: T) 
	where T.ELEMENT: SDAISelectType, T.ELEMENT == T.Element
	{
		self.init( FundamentalType(arraytype) )
	}
}

public extension SDAI__ARRAY__subtype
where Supertype: InitializableByOptionalSwiftArrayLiteral, ELEMENT: SDAISimpleType
{
	init<E>(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E == ELEMENT.SwiftType
	{
		self.init( FundamentalType(bound1:bound1, bound2:bound2, elements) )
	}
}
