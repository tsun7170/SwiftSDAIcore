//
//  SdaiBagSubtype.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation


//MARK: - BAG subtypes (8.2.3, 8.3.2)
extension SDAI {
  public protocol BAG__Subtype: SDAI.BAG__TypeBehavior, SDAI.DefinedType
  where Supertype: SDAI.BAG__TypeBehavior
  {}
}

public extension SDAI.BAG__Subtype
{
	// Aggregation operator support
	func intersectionWith<U: SDAI.BAG__TypeBehavior>(rhs: U) -> SDAI.BAG<ELEMENT>? 
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { rep.intersectionWith(rhs: rhs) }

	func intersectionWith<U: SDAI.SET__TypeBehavior>(rhs: U) -> SDAI.SET<ELEMENT>?
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { rep.intersectionWith(rhs: rhs) }

	func intersectionWith<U: SDAI.AggregationInitializer>(rhs: U) -> SDAI.BAG<ELEMENT>?
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { rep.intersectionWith(rhs: rhs) }


	func unionWith<U: SDAI.BagType>(rhs: U) -> SDAI.BAG<ELEMENT>?
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { rep.unionWith(rhs: rhs) }

	func unionWith<U: SDAI.ListType>(rhs: U) -> SDAI.BAG<ELEMENT>?
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { rep.unionWith(rhs: rhs) }

	func unionWith<U: SDAI.GenericType>(rhs: U) -> SDAI.BAG<ELEMENT>?
	where ELEMENT.FundamentalType == U.FundamentalType { rep.unionWith(rhs: rhs) }

	func unionWith<U: SDAI.GENERIC__TypeBehavior>(rhs: U) -> SDAI.BAG<ELEMENT>? { rep.unionWith(rhs: rhs) }

	func unionWith<U: SDAI.AggregationInitializer>(rhs: U) -> SDAI.BAG<ELEMENT>?
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { rep.unionWith(rhs: rhs) }


	func differenceWith<U: SDAI.BagType>(rhs: U) -> SDAI.BAG<ELEMENT>?
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { rep.differenceWith(rhs: rhs) }

	func differenceWith<U: SDAI.GenericType>(rhs: U) -> SDAI.BAG<ELEMENT>?
	where ELEMENT.FundamentalType == U.FundamentalType { rep.differenceWith(rhs: rhs) }

	func differenceWith<U: SDAI.GENERIC__TypeBehavior>(rhs: U) -> SDAI.BAG<ELEMENT>? { rep.differenceWith(rhs: rhs) }

	func differenceWith<U: SDAI.AggregationInitializer>(rhs: U) -> SDAI.BAG<ELEMENT>?
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { rep.differenceWith(rhs: rhs) }

	// InitializableByGenerictype
	init?<G: SDAI.GenericType>(fromGeneric generic: G?) {
		guard let fundamental = FundamentalType.convert(fromGeneric: generic) else { return nil }
		self.init(fundamental: fundamental)
	}
	
	// InitializableByGenericSet
	init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.SET__TypeBehavior>(
		bound1: I1, bound2: I2?, generic settype: T?)
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, generic: settype))
	}

	// InitializableByGenericBag
	init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.BAG__TypeBehavior>(
		bound1: I1, bound2: I2?, generic bagtype: T?)
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, generic: bagtype))
	}

	// InitializableByGenericList
	init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.LIST__TypeBehavior>(
		bound1: I1, bound2: I2?, generic listtype: T?)
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, generic: listtype))
	}

	// InitializableByEmptyListLiteral
	init<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible>(
		bound1: I1, bound2: I2?, _ emptyLiteral: SDAI.EmptyAggregateLiteral = SDAI.EMPTY_AGGREGATE)
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, emptyLiteral) )
	} 

	// InitializableBySwifttypeAsList
	init<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible>(
		from swiftValue: SwiftType, bound1: I1, bound2: I2?)
	{
		self.init(fundamental: FundamentalType(from: swiftValue, bound1: bound1, bound2: bound2) )
	} 
	
	// SDAI.InitializableBySelecttypeAsList
	init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, S: SDAI.SelectType>(
		bound1: I1, bound2: I2?, _ select: S?)
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, select) )
	}

	// SDAI.InitializableByListLiteral
	init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, E: SDAI.GenericType>(
		bound1: I1, bound2: I2?, _ elements: [SDAI.AggregationInitializerElement<E>])
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, elements) )
	} 
}

//MARK: - for select type element
public extension SDAI.BAG__Subtype
where ELEMENT: SDAI.InitializableBySelectType
{
	init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T:SDAI.BAG__TypeBehavior>(
		bound1: I1, bound2: I2?, _ bagtype: T?)
	where T.ELEMENT: SDAI.SelectType
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, bagtype) )
	}

	init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T:SDAI.SET__TypeBehavior>(
		bound1: I1, bound2: I2?, _ settype: T?) 
	where T.ELEMENT: SDAI.SelectType
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, settype) )
	}
}


//MARK: - for entity type element
public extension SDAI.BAG__Subtype
where ELEMENT: SDAI.InitializableByComplexEntity
{
	init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.BAG__TypeBehavior>(
		bound1: I1, bound2: I2?, _ bagtype: T?)
	where T.ELEMENT: SDAI.EntityReference
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, bagtype) )
	}	

	init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.SET__TypeBehavior>(
		bound1: I1, bound2: I2?, _ settype: T?)
	where T.ELEMENT: SDAI.EntityReference
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, settype) )
	}	


	init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.BAG__TypeBehavior>(
		bound1: I1, bound2: I2?, _ bagtype: T?)
	where T.ELEMENT: SDAI.PersistentReference,
	T.ELEMENT.ARef: SDAI.EntityReference
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, bagtype) )
	}	

	init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.SET__TypeBehavior>(
		bound1: I1, bound2: I2?, _ settype: T?)
	where T.ELEMENT: SDAI.PersistentReference,
	T.ELEMENT.ARef: SDAI.EntityReference
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, settype) )
	}	
}


//MARK: - for defined type element
public extension SDAI.BAG__Subtype
where ELEMENT: SDAI.InitializableByDefinedType
{
	init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T:SDAI.BAG__TypeBehavior>(
		bound1: I1, bound2: I2?, _ bagtype: T?)
	where T.ELEMENT: SDAI.UnderlyingType
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, bagtype) )
	}	

	init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T:SDAI.SET__TypeBehavior>(
		bound1: I1, bound2: I2?, _ settype: T?) 
	where T.ELEMENT: SDAI.UnderlyingType
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, settype) )
	}
}



