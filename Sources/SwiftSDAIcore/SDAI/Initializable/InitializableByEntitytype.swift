//
//  InitializableByEntitytype.swift
//  
//
//  Created by Yoshida on 2020/12/17.
//

import Foundation

public protocol InitializableByEntity
{
	init?(possiblyFrom complex: SDAI.ComplexEntity?)

	init?(possiblyFrom entityRef: SDAI.EntityReference?)

}



//MARK: - Initializers from List types
public protocol InitializableByEntityList
{
//	associatedtype ELEMENT: SDAI.EntityReference
	
	init(bound1: Int, bound2: Int?, _ elements: [SDAI.AggregationInitializerElement<SDAI.EntityReference>]) 

	init?<T: SDAI__LIST__type>(_ listtype: T?) 
	where T.ELEMENT: SDAI.EntityReference, 
				T.Element == T.ELEMENT

	init<T: SDAI__LIST__type>(_ listtype: T) 
	where T.ELEMENT: SDAI.EntityReference, 
				T.Element == T.ELEMENT

	init?<T: SDAI__LIST__type>(bound1: Int, bound2: Int?, _ listtype: T?) 
	where T.ELEMENT: SDAI.EntityReference, 
				T.Element == T.ELEMENT

	init<T: SDAI__LIST__type>(bound1: Int, bound2: Int?, _ listtype: T) 
	where T.ELEMENT: SDAI.EntityReference, 
				T.Element == T.ELEMENT
}
public extension InitializableByEntityList
{
	init?<T: SDAI__LIST__type>(_ listtype: T?) 
	where T.ELEMENT: SDAI.EntityReference, 
				T.Element == T.ELEMENT
	{
		guard let listtype = listtype else { return nil }
		self.init(listtype)		
	}

	init<T: SDAI__LIST__type>(_ listtype: T) 
	where T.ELEMENT: SDAI.EntityReference, 
				T.Element == T.ELEMENT
	{
		self.init(bound1: listtype.loBound, bound2: listtype.hiBound, listtype)
	}

	init?<T: SDAI__LIST__type>(bound1: Int, bound2: Int?, _ listtype: T?) 
	where T.ELEMENT: SDAI.EntityReference, 
				T.Element == T.ELEMENT
	{
		guard let listtype = listtype else { return nil }
		self.init(bound1: bound1, bound2: bound2, listtype)
	}
}

//MARK: - Initializers from Bag types
public protocol InitializableByEntityBag
{
//	associatedtype ELEMENT: SDAI.EntityReference

	init(bound1: Int, bound2: Int?, _ elements: [SDAI.AggregationInitializerElement<SDAI.EntityReference>]) 

	init?<T: SDAI__BAG__type>(_ bagtype: T?) 
	where T.ELEMENT: SDAI.EntityReference, T.Element == T.ELEMENT

	init<T: SDAI__BAG__type>(_ bagtype: T) 
	where T.ELEMENT: SDAI.EntityReference, T.Element == T.ELEMENT

	init?<T: SDAI__BAG__type>(bound1: Int, bound2: Int?, _ bagtype: T?) 
	where T.ELEMENT: SDAI.EntityReference, T.Element == T.ELEMENT

	init<T: SDAI__BAG__type>(bound1: Int, bound2: Int?, _ bagtype: T) 
	where T.ELEMENT: SDAI.EntityReference, T.Element == T.ELEMENT
}
public extension InitializableByEntityBag
{
	
	init?<T: SDAI__BAG__type>(_ bagtype: T?) 
	where T.ELEMENT: SDAI.EntityReference, T.Element == T.ELEMENT
	{
		guard let bagtype = bagtype else { return nil }
		self.init(bagtype)
	}

	init<T: SDAI__BAG__type>(_ bagtype: T) 
	where T.ELEMENT: SDAI.EntityReference, T.Element == T.ELEMENT
	{
		self.init(bound1: bagtype.loBound, bound2: bagtype.hiBound, bagtype)
	}

	init?<T: SDAI__BAG__type>(bound1: Int, bound2: Int?, _ bagtype: T?) 
	where T.ELEMENT: SDAI.EntityReference, T.Element == T.ELEMENT
	{
		guard let bagtype = bagtype else { return nil }
		self.init(bound1: bound1, bound2: bound2, bagtype)
	}
}

//MARK: - Initializers from Set types
public protocol InitializableByEntitySet
{
//	associatedtype ELEMENT: SDAI.EntityReference

	init(bound1: Int, bound2: Int?, _ elements: [SDAI.AggregationInitializerElement<SDAI.EntityReference>]) 

	init?<T: SDAI__SET__type>(_ settype: T?) 
	where T.ELEMENT: SDAI.EntityReference, T.Element == T.ELEMENT

	init<T: SDAI__SET__type>(_ settype: T) 
	where T.ELEMENT: SDAI.EntityReference, T.Element == T.ELEMENT

	init?<T: SDAI__SET__type>(bound1: Int, bound2: Int?, _ settype: T?) 
	where T.ELEMENT: SDAI.EntityReference, T.Element == T.ELEMENT

	init<T: SDAI__SET__type>(bound1: Int, bound2: Int?, _ settype: T) 
	where T.ELEMENT: SDAI.EntityReference, T.Element == T.ELEMENT
}
public extension InitializableByEntitySet
{
	init?<T: SDAI__SET__type>(_ settype: T?) 
	where T.ELEMENT: SDAI.EntityReference, T.Element == T.ELEMENT
	{
		guard let settype = settype else { return nil }
		self.init(settype)
	}

	init<T: SDAI__SET__type>(_ settype: T) 
	where T.ELEMENT: SDAI.EntityReference, T.Element == T.ELEMENT
	{
		self.init(bound1: settype.loBound, bound2: settype.hiBound, settype)
	}

	init?<T: SDAI__SET__type>(bound1: Int, bound2: Int?, _ settype: T?) 
	where T.ELEMENT: SDAI.EntityReference, T.Element == T.ELEMENT
	{
		guard let settype = settype else { return nil }
		self.init(bound1: bound1, bound2: bound2, settype)
	}
}


//MARK: - Initializers from Optional Arrays
public protocol InitializableByOptionalEntityArray
{
//	associatedtype ELEMENT: SDAI.EntityReference
	
	init(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<SDAI.EntityReference>]) 

	init?<T: SDAI__ARRAY_OPTIONAL__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAI.EntityReference, 
				T.Element == Optional<T.ELEMENT>

	init<T: SDAI__ARRAY_OPTIONAL__type>(_ arraytype: T) 
	where T.ELEMENT: SDAI.EntityReference, 
				T.Element == Optional<T.ELEMENT>
}
public extension InitializableByOptionalEntityArray
{
	init?<T: SDAI__ARRAY_OPTIONAL__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAI.EntityReference, 
				T.Element == Optional<T.ELEMENT>
	{
		guard let arraytype = arraytype else { return nil }
		self.init(arraytype)
	}
}


//MARK: - Initializers from Arrays
public protocol InitializableByEntityArray
{
//	associatedtype ELEMENT: SDAI.EntityReference
	
	init(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<SDAI.EntityReference>]) 

	init?<T: SDAI__ARRAY__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAI.EntityReference, 
				T.Element == T.ELEMENT

	init<T: SDAI__ARRAY__type>(_ arraytype: T) 
	where T.ELEMENT: SDAI.EntityReference, 
				T.Element == T.ELEMENT
}
public extension InitializableByEntityArray
{
	init?<T: SDAI__ARRAY__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAI.EntityReference, 
				T.Element == T.ELEMENT
	{
		guard let arraytype = arraytype else { return nil }
		self.init(arraytype)
	}
}
