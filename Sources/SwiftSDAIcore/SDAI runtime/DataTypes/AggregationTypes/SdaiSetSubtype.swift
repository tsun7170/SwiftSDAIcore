//
//  SdaiSetSubtype.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation


//MARK: - SET subtype (8.2.4, 8.3.2)
extension SDAI.TypeHierarchy {
  public protocol SET__Subtype: SDAI.TypeHierarchy.SET__TypeBehavior, SDAI.DefinedType
  where Supertype: SDAI.TypeHierarchy.SET__TypeBehavior
  {}
}

public extension SDAI.TypeHierarchy.SET__Subtype
{
	//MARK: Aggregation operator support
	func intersectionWith<U: SDAI.BagType>(rhs: U) -> SDAI.SET<ELEMENT>?
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { rep.intersectionWith(rhs: rhs) }

	func intersectionWith<U: SDAI.AggregationInitializer>(rhs: U) -> SDAI.SET<ELEMENT>?
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { rep.intersectionWith(rhs: rhs) }


	func unionWith<U: SDAI.BagType>(rhs: U) -> SDAI.SET<ELEMENT>?
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { rep.unionWith(rhs: rhs) }

	func unionWith<U: SDAI.ListType>(rhs: U) -> SDAI.SET<ELEMENT>?
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { rep.unionWith(rhs: rhs) }

	func unionWith<U: SDAI.GenericType>(rhs: U) -> SDAI.SET<ELEMENT>?
	where ELEMENT.FundamentalType == U.FundamentalType { rep.unionWith(rhs: rhs) }

	func unionWith<U: SDAI.TypeHierarchy.GENERIC__TypeBehavior>(rhs: U) -> SDAI.SET<ELEMENT>? { rep.unionWith(rhs: rhs) }

	func unionWith<U: SDAI.AggregationInitializer>(rhs: U) -> SDAI.SET<ELEMENT>?
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { rep.unionWith(rhs: rhs) }


	func differenceWith<U: SDAI.BagType>(rhs: U) -> SDAI.SET<ELEMENT>?
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { rep.differenceWith(rhs: rhs) }

	func differenceWith<U: SDAI.GenericType>(rhs: U) -> SDAI.SET<ELEMENT>?
	where ELEMENT.FundamentalType == U.FundamentalType { rep.differenceWith(rhs: rhs) }

	func differenceWith<U: SDAI.TypeHierarchy.GENERIC__TypeBehavior>(rhs: U) -> SDAI.SET<ELEMENT>? { rep.differenceWith(rhs: rhs) }

	func differenceWith<U: SDAI.AggregationInitializer>(rhs: U) -> SDAI.SET<ELEMENT>?
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { rep.differenceWith(rhs: rhs) }
	
	//MARK: InitializableByGenerictype
	init?<G: SDAI.GenericType>(fromGeneric generic: G?) {
		guard let fundamental = FundamentalType.convert(fromGeneric: generic) else { return nil }
		self.init(fundamental: fundamental)
	}
	
	//MARK: InitializableByGenericSet
  init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.TypeHierarchy.SET__TypeBehavior>(
		bound1: I1, bound2: I2?, generic settype: T?)
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, generic: settype))
	}

	//MARK: InitializableByGenericBag
  init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.TypeHierarchy.BAG__TypeBehavior>(
		bound1: I1, bound2: I2?, generic bagtype: T?)
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, generic: bagtype))
	}

	//MARK: InitializableByGenericList
	init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.TypeHierarchy.LIST__TypeBehavior>(
		bound1: I1, bound2: I2?, generic listtype: T?)
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, generic: listtype))
	}

	//MARK: InitializableByEmptyListLiteral
	init<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible>(
		bound1: I1, bound2: I2?, _ emptyLiteral: SDAI.EmptyAggregateLiteral = SDAI.EMPTY_AGGREGATE)
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, emptyLiteral) )
	} 
	
	//MARK: InitializableBySwifttypeAsList
	init<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible>(from swiftValue: SwiftType, bound1: I1, bound2: I2?) {
		self.init(fundamental: FundamentalType(from: swiftValue, bound1: bound1, bound2: bound2) )
	} 

	//MARK: SDAI.Initializable.BySelecttypeAsList
	init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, S: SDAI.SelectType>(bound1: I1, bound2: I2?, _ select: S?) {
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, select) )
	}

	//MARK: SDAI.Initializable.ByListLiteral
	init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, E: SDAI.GenericType>(bound1: I1, bound2: I2?, _ elements: [SDAI.AggregationInitializerElement<E>]) {
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, elements) )
	} 
}



//MARK: - for SDAI.Initializable.BySelectType ELEMENT
public extension SDAI.TypeHierarchy.SET__Subtype
where ELEMENT: SDAI.Initializable.BySelectType
{
  init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T:SDAI.TypeHierarchy.SET__TypeBehavior>(
		bound1: I1, bound2: I2?, _ settype: T?)
	where T.ELEMENT: SDAI.SelectType
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, settype) )
	}
}


//MARK: - for SDAI.Initializable.ByComplexEntity ELEMENT
public extension SDAI.TypeHierarchy.SET__Subtype
where ELEMENT: SDAI.Initializable.ByComplexEntity
{
  init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.TypeHierarchy.SET__TypeBehavior>(
		bound1: I1, bound2: I2?, _ settype: T?)
	where T.ELEMENT: SDAI.EntityReference
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, settype) )
	}	


  init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.TypeHierarchy.SET__TypeBehavior>(
		bound1: I1, bound2: I2?, _ settype: T?)
	where T.ELEMENT: SDAI.PersistentReference,
	T.ELEMENT.ARef: SDAI.EntityReference
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, settype) )
	}	
}


//MARK: - for SDAI.Initializable.ByDefinedType ELEMENT
public extension SDAI.TypeHierarchy.SET__Subtype
where ELEMENT: SDAI.Initializable.ByDefinedType
{
  init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T:SDAI.TypeHierarchy.SET__TypeBehavior>(
		bound1: I1, bound2: I2?, _ settype: T?)
	where T.ELEMENT: SDAI.UnderlyingType
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, settype) )
	}
}

