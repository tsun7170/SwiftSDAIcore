//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/18.
//

import Foundation


public protocol InitializableBySelecttype
{
	init?<S: SDAISelectType>(possiblyFrom select: S?)
}

public protocol InitializableBySelecttypeList
{
	init<E: SDAISelectType>(bound1: Int, bound2: Int?, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	
	init?<T: SDAI__LIST__type>(_ listtype: T?) 
	where T.ELEMENT: SDAISelectType, T.ELEMENT == T.Element

	init<T: SDAI__LIST__type>(_ listtype: T) 
	where T.ELEMENT: SDAISelectType, T.ELEMENT == T.Element	
	
	init?<T: SDAI__LIST__type>(bound1: Int, bound2: Int?, _ listtype: T?) 
	where T.ELEMENT: SDAISelectType, T.ELEMENT == T.Element

	init<T: SDAI__LIST__type>(bound1: Int, bound2: Int?, _ listtype: T) 
	where T.ELEMENT: SDAISelectType, T.ELEMENT == T.Element	
}
public extension InitializableBySelecttypeList
{
	init?<T: SDAI__LIST__type>(_ listtype: T?) 
	where T.ELEMENT: SDAISelectType, T.ELEMENT == T.Element
	{
		guard let listtype = listtype else { return nil}
		self.init(listtype)		
	}

	init<T: SDAI__LIST__type>(_ listtype: T) 
	where T.ELEMENT: SDAISelectType, T.ELEMENT == T.Element	
	{
		self.init(bound1: listtype.loBound, bound2: listtype.hiBound, listtype)
	}
	
	init?<T: SDAI__LIST__type>(bound1: Int, bound2: Int?, _ listtype: T?) 
	where T.ELEMENT: SDAISelectType, T.ELEMENT == T.Element
	{
		guard let listtype = listtype else { return nil}
		self.init(bound1: bound1, bound2: bound2, listtype)
	}
}




public protocol InitializableBySelecttypeBag
{
	init<E: SDAISelectType>(bound1: Int, bound2: Int?, _ elements: [SDAI.AggregationInitializerElement<E>]) 

	init?<T: SDAI__BAG__type>(_ bagtype: T?) 
	where T.ELEMENT: SDAISelectType, T.ELEMENT == T.Element
	
	init<T: SDAI__BAG__type>(_ bagtype: T) 
	where T.ELEMENT: SDAISelectType, T.ELEMENT == T.Element

	init?<T: SDAI__BAG__type>(bound1: Int, bound2: Int?, _ bagtype: T?) 
	where T.ELEMENT: SDAISelectType, T.ELEMENT == T.Element
	
	init<T: SDAI__BAG__type>(bound1: Int, bound2: Int?, _ bagtype: T) 
	where T.ELEMENT: SDAISelectType, T.ELEMENT == T.Element
}
public extension InitializableBySelecttypeBag
{
	init?<T: SDAI__BAG__type>(_ bagtype: T?) 
	where T.ELEMENT: SDAISelectType, T.ELEMENT == T.Element
	{
		guard let bagtype = bagtype else { return nil }
		self.init(bagtype)
	}
	
	init<T: SDAI__BAG__type>(_ bagtype: T) 
	where T.ELEMENT: SDAISelectType, T.ELEMENT == T.Element
	{
		self.init(bound1: bagtype.loBound, bound2: bagtype.hiBound, bagtype)
	}

	init?<T: SDAI__BAG__type>(bound1: Int, bound2: Int?, _ bagtype: T?) 
	where T.ELEMENT: SDAISelectType, T.ELEMENT == T.Element
	{
		guard let bagtype = bagtype else { return nil }
		self.init(bound1: bound1, bound2: bound2, bagtype)
	}
}




public protocol InitializableBySelecttypeSet
{	
	init<E: SDAISelectType>(bound1: Int, bound2: Int?, _ elements: [SDAI.AggregationInitializerElement<E>]) 

	init?<T: SDAI__SET__type>(_ settype: T?) 
	where T.ELEMENT: SDAISelectType, T.ELEMENT == T.Element
	
	init<T: SDAI__SET__type>(_ settype: T) 
	where T.ELEMENT: SDAISelectType, T.ELEMENT == T.Element

	init?<T: SDAI__SET__type>(bound1: Int, bound2: Int?, _ settype: T?) 
	where T.ELEMENT: SDAISelectType, T.ELEMENT == T.Element
	
	init<T: SDAI__SET__type>(bound1: Int, bound2: Int?, _ settype: T) 
	where T.ELEMENT: SDAISelectType, T.ELEMENT == T.Element
}
public extension InitializableBySelecttypeSet
{
	init?<T: SDAI__SET__type>(_ settype: T?) 
	where T.ELEMENT: SDAISelectType, T.ELEMENT == T.Element
	{
		guard let settype = settype else { return nil}
		self.init(settype)
	}
	
	init<T: SDAI__SET__type>(_ settype: T) 
	where T.ELEMENT: SDAISelectType, T.ELEMENT == T.Element
	{
		self.init(bound1: settype.loBound, bound2: settype.hiBound, settype)
	}

	init?<T: SDAI__SET__type>(bound1: Int, bound2: Int?, _ settype: T?) 
	where T.ELEMENT: SDAISelectType, T.ELEMENT == T.Element
	{
		guard let settype = settype else { return nil}
		self.init(bound1: bound1, bound2: bound2, settype)
	}
}


public protocol InitializableByOptionalSelecttypeArray
{
	init<E: SDAISelectType>(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<E>]) 

	init?<T: SDAI__ARRAY_OPTIONAL__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAISelectType, T.Element == Optional<T.ELEMENT>

	init<T: SDAI__ARRAY_OPTIONAL__type>(_ arraytype: T) 
	where T.ELEMENT: SDAISelectType, T.Element == Optional<T.ELEMENT>
}
public extension InitializableByOptionalSelecttypeArray
{
	init?<T: SDAI__ARRAY_OPTIONAL__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAISelectType, T.Element == Optional<T.ELEMENT>
	{
		guard let arraytype = arraytype else { return nil }
		self.init(arraytype)
	}
}



public protocol InitializableBySelecttypeArray
{
	init<E: SDAISelectType>(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<E>]) 

	init?<T: SDAI__ARRAY__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAISelectType, T.ELEMENT == T.Element

	init<T: SDAI__ARRAY__type>(_ arraytype: T) 
	where T.ELEMENT: SDAISelectType, T.ELEMENT == T.Element
}
public extension InitializableBySelecttypeArray
{
	init?<T: SDAI__ARRAY__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAISelectType, T.ELEMENT == T.Element
	{
		guard let arraytype = arraytype else { return nil}
		self.init(arraytype)
	}
}
