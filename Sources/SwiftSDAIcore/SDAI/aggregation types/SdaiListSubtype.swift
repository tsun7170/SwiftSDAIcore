//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation


//MARK: - LIST subtype
public protocol SDAI__LIST__subtype: SDAI__LIST__type, SDAIDefinedType
where Supertype: SDAI__LIST__type, 
			Supertype.FundamentalType == SDAI.LIST<ELEMENT>, 
			ELEMENT: SDAIGenericType
{}
public extension SDAI__LIST__subtype
{
	// SDAIGenericType
	init?<S: SDAISelectType>(possiblyFrom select: S?) {
		guard let fundamental = FundamentalType(possiblyFrom: select) else { return nil }
		self.init(fundamental: fundamental)
	}
	
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

public extension SDAI__LIST__subtype
where Supertype.FundamentalType: InitializableByEntityList, ELEMENT: SDAI.EntityReference
{
	init(bound1: Int = 0, bound2: Int? = nil, _ elements: [SDAI.AggregationInitializerElement<SDAI.EntityReference>]) {
		self.init( FundamentalType(bound1: bound1, bound2: bound2, elements) )
	}

	init<T: SDAI__LIST__type>(bound1: Int, bound2: Int?, _ listtype: T) 
	where T.ELEMENT: SDAI.EntityReference, 
				T.Element == T.ELEMENT
	{
		self.init( FundamentalType(bound1: bound1, bound2: bound2, listtype) )
	}	
}

public extension SDAI__LIST__subtype
where Supertype.FundamentalType: InitializableByDefinedtypeList, ELEMENT: SDAIUnderlyingType
{
	init<E: SDAIUnderlyingType>(bound1: Int = 0, bound2: Int? = nil, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E.FundamentalType == ELEMENT.FundamentalType
	{
		self.init( FundamentalType(bound1: bound1, bound2: bound2, elements) )
	}

	init<T:SDAI__LIST__type>(bound1: Int, bound2: Int?, _ listtype: T) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element
	{
		self.init( FundamentalType(bound1: bound1, bound2: bound2, listtype) )
	}
}

public extension SDAI__LIST__subtype
where Supertype.FundamentalType: InitializableBySelecttypeList
{
	init<E: SDAISelectType>(bound1: Int = 0, bound2: Int? = nil, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	{
		self.init( FundamentalType(bound1: bound1, bound2: bound2, elements) )
	}

	init<T:SDAI__LIST__type>(bound1: Int, bound2: Int?, _ listtype: T) 
	where T.ELEMENT: SDAISelectType, T.ELEMENT == T.Element
	{
		self.init( FundamentalType(bound1: bound1, bound2: bound2, listtype) )
	}
}

public extension SDAI__LIST__subtype
where Supertype.FundamentalType: InitializableBySwiftListLiteral, ELEMENT: SDAISimpleType
{
	init<E>(bound1: Int = 0, bound2: Int? = nil, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E == ELEMENT.SwiftType
	{
		self.init( FundamentalType(bound1:bound1, bound2:bound2, elements) )
	}
}

public extension SDAI__LIST__subtype
where ELEMENT: SDAISelectType,
			Supertype.FundamentalType == SDAI.LIST<ELEMENT>
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
	
	init?<T: SDAI__LIST__type>(_ listtype: T?) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAI.EntityReference
	{
		guard let listtype = listtype else { return nil }
		self.init(listtype)
	}
	init?<T: SDAI__LIST__type>(_ listtype: T?) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAIUnderlyingType
	{
		guard let listtype = listtype else { return nil }
		self.init(listtype)
	}
	init?<T: SDAI__LIST__type>(_ listtype: T?) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAISelectType
	{
		guard let listtype = listtype else { return nil }
		self.init(listtype)
	}

	init<T: SDAI__LIST__type>(_ listtype: T) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAI.EntityReference
	{
		self.init( FundamentalType(bound1: listtype.loBound, bound2: listtype.hiBound, listtype) )
	}
	init<T: SDAI__LIST__type>(_ listtype: T) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAIUnderlyingType
	{
		self.init( FundamentalType(bound1: listtype.loBound, bound2: listtype.hiBound, listtype) )
	}
	init<T: SDAI__LIST__type>(_ listtype: T) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAISelectType
	{
		self.init( FundamentalType(bound1: listtype.loBound, bound2: listtype.hiBound, listtype) )
	}
	
	init?<T: SDAI__LIST__type>(bound1: Int, bound2: Int?, _ listtype: T?) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAI.EntityReference
	{
		guard let listtype = listtype else { return nil }
		self.init(bound1: bound1, bound2: bound2, listtype)
	}
	init?<T: SDAI__LIST__type>(bound1: Int, bound2: Int?, _ listtype: T?) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAIUnderlyingType
	{
		guard let listtype = listtype else { return nil }
		self.init(bound1: bound1, bound2: bound2, listtype)
	}
	init?<T: SDAI__LIST__type>(bound1: Int, bound2: Int?, _ listtype: T?) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAISelectType
	{
		guard let listtype = listtype else { return nil }
		self.init(bound1: bound1, bound2: bound2, listtype)
	}

	init<T: SDAI__LIST__type>(bound1: Int, bound2: Int?, _ listtype: T) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAI.EntityReference
	{
		self.init( FundamentalType(bound1: bound1, bound2: bound2, listtype) )
	}
	init<T: SDAI__LIST__type>(bound1: Int, bound2: Int?, _ listtype: T) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAIUnderlyingType
	{
		self.init( FundamentalType(bound1: bound1, bound2: bound2, listtype) )
	}
	init<T: SDAI__LIST__type>(bound1: Int, bound2: Int?, _ listtype: T) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAISelectType
	{
		self.init( FundamentalType(bound1: bound1, bound2: bound2, listtype) )
	}
}

