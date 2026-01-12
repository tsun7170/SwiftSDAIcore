//
//  SdaiListSubtype.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation


//MARK: - LIST subtype (8.2.2, 8.3.2)
extension SDAI {
  public protocol LIST__Subtype: SDAI.LIST__TypeBehavior, SDAI.DefinedType
  where Supertype: SDAI.LIST__TypeBehavior
  {}
}

public extension SDAI.LIST__Subtype
{	
	// SDAI__LIST__type
	static var uniqueFlag: SDAI.BOOLEAN { Supertype.uniqueFlag }

	// Built-in procedure support
	mutating func insert(element: ELEMENT, at position: Int) { rep.insert(element: element, at: position) }
	mutating func remove(at position: Int) { rep.remove(at: position) }

	// Aggregation operator support
	func appendWith<U: SDAI.ListType>(rhs: U) -> SDAI.LIST<ELEMENT>? 
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { rep.appendWith(rhs: rhs) }

	func appendWith<U: SDAI.GenericType>(rhs: U) -> SDAI.LIST<ELEMENT>?
	where ELEMENT.FundamentalType == U.FundamentalType { rep.appendWith(rhs: rhs) }

	func prependWith<U: SDAI.GenericType>(lhs: U) -> SDAI.LIST<ELEMENT>?
	where ELEMENT.FundamentalType == U.FundamentalType { rep.prependWith(lhs: lhs) }

	func appendWith<U: SDAI__GENERIC__type>(rhs: U) -> SDAI.LIST<ELEMENT>? { rep.appendWith(rhs: rhs) }

	func prependWith<U: SDAI__GENERIC__type>(lhs: U) -> SDAI.LIST<ELEMENT>? { rep.prependWith(lhs: lhs) }

	func appendWith<U: SDAIAggregationInitializer>(rhs: U) -> SDAI.LIST<ELEMENT>?
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { rep.appendWith(rhs: rhs) }

	func prependWith<U: SDAIAggregationInitializer>(lhs: U) -> SDAI.LIST<ELEMENT>?
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { rep.prependWith(lhs: lhs) }
	
	// InitializableByGenerictype
	init?<G: SDAI.GenericType>(fromGeneric generic: G?) {
		guard let fundamental = FundamentalType.convert(fromGeneric: generic) else { return nil }
		self.init(fundamental: fundamental)
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
	
	// InitializableBySelecttypeAsList
	init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, S: SDAI.SelectType>(
		bound1: I1, bound2: I2?, _ select: S?)
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, select) )
	}

	// InitializableByListLiteral
	init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, E: SDAI.GenericType>(
		bound1: I1, bound2: I2?, _ elements: [SDAI.AggregationInitializerElement<E>])
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, elements) )
	 } 
}


//MARK: - for select type element
public extension SDAI.LIST__Subtype
where ELEMENT: SDAI.InitializableBySelectType
{
	init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T:SDAI.LIST__TypeBehavior>(
		bound1: I1, bound2: I2?, _ listtype: T?) 
	where T.ELEMENT: SDAI.SelectType//, T.ELEMENT == T.Element
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, listtype) )
	}
}


//MARK: - for entity type element
public extension SDAI.LIST__Subtype
where ELEMENT: SDAI.InitializableByComplexEntity
{
	init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.LIST__TypeBehavior>(
		bound1: I1, bound2: I2?, _ listtype: T? )
	where T.ELEMENT: SDAI.EntityReference
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, listtype) )
	}

	init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.LIST__TypeBehavior>(
		bound1: I1, bound2: I2?, _ listtype: T? )
	where T.ELEMENT: SDAI.PersistentReference,
	T.ELEMENT.ARef: SDAI.EntityReference
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, listtype) )
	}


}


//MARK: - for defined type element
public extension SDAI.LIST__Subtype
where ELEMENT: SDAI.InitializableByDefinedType
{
	init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T:SDAI.LIST__TypeBehavior>(
		bound1: I1, bound2: I2?, _ listtype: T?) 
	where T.ELEMENT: SDAI.UnderlyingType
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, listtype) )
	}
}

