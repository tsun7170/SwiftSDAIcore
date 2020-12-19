//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation


//MARK: - SET subtype
public protocol SDAI__SET__subtype: SDAI__SET__type, SDAIDefinedType
where Supertype: SDAI__SET__type, 
			Supertype.FundamentalType == SDAI.SET<ELEMENT>, 
			ELEMENT: SDAIGenericType
{}
public extension SDAI__SET__subtype
{
	// SDAIGenericType
	init?<S: SDAISelectType>(possiblyFrom select: S?) {
		guard let fundamental = FundamentalType(possiblyFrom: select) else { return nil }
		self.init(fundamental: fundamental)
	}
	
	// SDAIBagType
	init(from swiftValue: SwiftType, bound1: Int = 0, bound2: Int? = nil) {
//		abstruct()
		self.init( FundamentalType(from: swiftValue, bound1: bound1, bound2: bound2) )
	} 

	init(bound1: Int = 0, bound2: Int? = nil, _ emptyLiteral: SDAI.EmptyAggregateLiteral = SDAI.EMPLY_AGGREGATE) {
//		abstruct()
		self.init( FundamentalType(bound1: bound1, bound2: bound2, emptyLiteral) )
	} 

	mutating func set(bound1: Int, bound2: Int?) {
		rep.set(bound1: bound1, bound2: bound2)
	}
}

public extension SDAI__SET__subtype
where Supertype.FundamentalType: InitializableByEntitySet, ELEMENT: SDAI.EntityReference
{
	init(bound1: Int = 0, bound2: Int? = nil, _ elements: [SDAI.AggregationInitializerElement<SDAI.EntityReference>]) {
		self.init( FundamentalType(bound1: bound1, bound2: bound2, elements) )
	}
	
	init<T: SDAI__SET__type>(bound1: Int, bound2: Int?, _ settype: T) 
	where T.ELEMENT: SDAI.EntityReference, T.Element == T.ELEMENT
	{
		self.init( FundamentalType(bound1: bound1, bound2: bound2, settype) )
	}	
}

public extension SDAI__SET__subtype
where Supertype.FundamentalType: InitializableByDefinedtypeSet, ELEMENT: SDAIUnderlyingType
{
	init<E:SDAIUnderlyingType>(bound1: Int = 0, bound2: Int? = nil, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E.FundamentalType == ELEMENT.FundamentalType
	{
		self.init( FundamentalType(bound1: bound1, bound2: bound2, elements) )
	}
	
	init<T:SDAI__SET__type>(bound1: Int, bound2: Int?, _ settype: T) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element
	{
		self.init( FundamentalType(bound1: bound1, bound2: bound2, settype) )
	}
}


public extension SDAI__SET__subtype
where Supertype.FundamentalType: InitializableBySelecttypeSet
{
	init<E: SDAISelectType>(bound1: Int = 0, bound2: Int? = nil, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	{
		self.init( FundamentalType(bound1: bound1, bound2: bound2, elements) )
	}

	init<T:SDAI__SET__type>(bound1: Int, bound2: Int?, _ settype: T) 
	where T.ELEMENT: SDAISelectType, T.ELEMENT == T.Element
	{
		self.init( FundamentalType(bound1: bound1, bound2: bound2, settype) )
	}
}

public extension SDAI__SET__subtype
where Supertype.FundamentalType: InitializableBySwiftListLiteral, ELEMENT: SDAISimpleType
{
	init<E>(bound1: Int = 0, bound2: Int? = nil, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E == ELEMENT.SwiftType
	{
		self.init( FundamentalType(bound1:bound1, bound2:bound2, elements) )
	}
}


public extension SDAI__SET__subtype
where ELEMENT: SDAISelectType,
			Supertype.FundamentalType == SDAI.SET<ELEMENT>
{
	init<E: SDAI.EntityReference>(bound1: Int, bound2: Int?, _ elements: [SDAI.AggregationInitializerElement<E>])
	{
		self.init( FundamentalType(bound1:bound1, bound2:bound2, elements) )
	}
	init<E: SDAIUnderlyingType>(bound1: Int, bound2: Int?, _ elements: [SDAI.AggregationInitializerElement<E>])
	{
		self.init( FundamentalType(bound1:bound1, bound2:bound2, elements) )
	}
	init<E: SDAISelectType>(bound1: Int, bound2: Int?, _ elements: [SDAI.AggregationInitializerElement<E>])
	{
		self.init( FundamentalType(bound1:bound1, bound2:bound2, elements) )
	}
	
	init?<T: SDAI__SET__type>(_ settype: T?) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAI.EntityReference
	{
		guard let settype = settype else { return nil }
		self.init(settype)
	}
	init?<T: SDAI__SET__type>(_ settype: T?) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAIUnderlyingType
	{
		guard let settype = settype else { return nil }
		self.init(settype)
	}
	init?<T: SDAI__SET__type>(_ settype: T?) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAISelectType
	{
		guard let settype = settype else { return nil }
		self.init(settype)
	}

	init<T: SDAI__SET__type>(_ settype: T) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAI.EntityReference
	{
		self.init( FundamentalType(bound1: settype.loBound, bound2: settype.hiBound, settype) )
	}
	init<T: SDAI__SET__type>(_ settype: T) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAIUnderlyingType
	{
		self.init( FundamentalType(bound1: settype.loBound, bound2: settype.hiBound, settype) )
	}
	init<T: SDAI__SET__type>(_ settype: T) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAISelectType
	{
		self.init( FundamentalType(bound1: settype.loBound, bound2: settype.hiBound, settype) )
	}
	
	init?<T: SDAI__SET__type>(bound1: Int, bound2: Int?, _ settype: T?) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAI.EntityReference
	{
		guard let settype = settype else { return nil }
		self.init(bound1: bound1, bound2: bound2, settype)
	}
	init?<T: SDAI__SET__type>(bound1: Int, bound2: Int?, _ settype: T?) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAIUnderlyingType
	{
		guard let settype = settype else { return nil }
		self.init(bound1: bound1, bound2: bound2, settype)
	}
	init?<T: SDAI__SET__type>(bound1: Int, bound2: Int?, _ settype: T?) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAISelectType
	{
		guard let settype = settype else { return nil }
		self.init(bound1: bound1, bound2: bound2, settype)
	}

	init<T: SDAI__SET__type>(bound1: Int, bound2: Int?, _ settype: T) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAI.EntityReference
	{
		self.init( FundamentalType(bound1: bound1, bound2: bound2, settype) )
	}
	init<T: SDAI__SET__type>(bound1: Int, bound2: Int?, _ settype: T) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAIUnderlyingType
	{
		self.init( FundamentalType(bound1: bound1, bound2: bound2, settype) )
	}
	init<T: SDAI__SET__type>(bound1: Int, bound2: Int?, _ settype: T) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAISelectType
	{
		self.init( FundamentalType(bound1: bound1, bound2: bound2, settype) )
	}
}
