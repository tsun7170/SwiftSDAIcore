//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation

//MARK: - ARRAY_OPTIONAL subtype
public protocol SDAI__ARRAY_OPTIONAL__subtype: SDAI__ARRAY_OPTIONAL__type, SDAIDefinedType
where Supertype: SDAI__ARRAY_OPTIONAL__type, 
			Supertype.FundamentalType == SDAI.ARRAY_OPTIONAL<ELEMENT>, 
			ELEMENT: SDAIGenericType
{}
public extension SDAI__ARRAY_OPTIONAL__subtype
{
	// SDAIGenericType
	init?<S: SDAISelectType>(possiblyFrom select: S?) {
		guard let fundamental = FundamentalType(possiblyFrom: select) else { return nil }
		self.init(fundamental: fundamental)
	}
	
	// SDAI__ARRAY_OPTIONAL__type \SDAI__ARRAY_OPTIONAL__subtype
	init(from swiftValue: SwiftType, bound1: Int, bound2: Int) {
//		abstruct()
		self.init( FundamentalType(from: swiftValue, bound1: bound1, bound2: bound2) )
	} 
	init(bound1: Int, bound2: Int) {
//		abstruct()
		self.init( FundamentalType(bound1: bound1, bound2: bound2) )
	} 
}

public extension SDAI__ARRAY_OPTIONAL__subtype
where Supertype.FundamentalType: InitializableByEntityArray, ELEMENT: SDAI.EntityReference
{
	// InitializableByArray \SDAI__ARRAY_OPTIONAL__type\SDAI__ARRAY_OPTIONAL__subtype
	init(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<SDAI.EntityReference>]) {
		self.init( FundamentalType(bound1: bound1, bound2: bound2, elements) )
	}

	init<T: SDAI__ARRAY__type>(_ arraytype: T) 
	where T.ELEMENT: SDAI.EntityReference, T.Element == T.ELEMENT
	{
		self.init( FundamentalType(arraytype) )
	}	
}

public extension SDAI__ARRAY_OPTIONAL__subtype
where Supertype.FundamentalType: InitializableByOptionalEntityArray, ELEMENT: SDAI.EntityReference
{
//	// InitializableByOptionalArray \SDAI__ARRAY_OPTIONAL__subtype
//	init(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<SDAI.EntityReference?>]) {
//		self.init( FundamentalType(bound1: bound1, bound2: bound2, elements) )
//	}

	init<T: SDAI__ARRAY_OPTIONAL__type>(_ arraytype: T) 
	where T.ELEMENT: SDAI.EntityReference, T.Element == Optional<T.ELEMENT>
	{
		self.init( FundamentalType(arraytype) )
	}
}

public extension SDAI__ARRAY_OPTIONAL__subtype
where Supertype.FundamentalType: InitializableByDefinedtypeArray, ELEMENT: SDAIUnderlyingType
{
	// InitializableBySubtypeArray
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

public extension SDAI__ARRAY_OPTIONAL__subtype
where Supertype.FundamentalType: InitializableByOptionalDefinedtypeArray, ELEMENT: SDAIUnderlyingType
{
//	init<E: SDAIUnderlyingType>(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<E?>]) 
//	where E.FundamentalType == ELEMENT.FundamentalType
//	{
//		self.init( FundamentalType(bound1: bound1, bound2: bound2, elements) )
//	}

	init<T:SDAI__ARRAY_OPTIONAL__type>(_ arraytype: T) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.Element == Optional<T.ELEMENT>
	{
		self.init( FundamentalType(arraytype) )
	}	
}

public extension SDAI__ARRAY_OPTIONAL__subtype
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

public extension SDAI__ARRAY_OPTIONAL__subtype
where Supertype.FundamentalType: InitializableByOptionalSelecttypeArray
{
//	// InitializableByOptionalSubtypeArray
//	init<E: SDAISelectType>(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<E?>]) 
//	{
//		self.init( FundamentalType(bound1: bound1, bound2: bound2, elements) )
//	}

	init<T:SDAI__ARRAY_OPTIONAL__type>(_ arraytype: T) 
	where T.ELEMENT: SDAISelectType, T.Element == Optional<T.ELEMENT>
	{
		self.init( FundamentalType(arraytype) )
	}	
}

//public extension SDAI__ARRAY_OPTIONAL__subtype
//where Supertype.FundamentalType: InitializableBySwiftArrayLiteral, ELEMENT: SDAISimpleType
//{
//	init<E>(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<E>]) 
//	where E == ELEMENT.SwiftType
//	{
//		self.init( FundamentalType(bound1:bound1, bound2:bound2, elements) )
//	}
//}

public extension SDAI__ARRAY_OPTIONAL__subtype
where Supertype.FundamentalType: InitializableByOptionalSwiftArrayLiteral, ELEMENT: SDAISimpleType
{
	init<E>(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E == ELEMENT.SwiftType
	{
		self.init( FundamentalType(bound1:bound1, bound2:bound2, elements) )
	}
}

