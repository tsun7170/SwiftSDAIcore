//
//  SdaiSetSubtype.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation


//MARK: - SET subtype (8.2.4, 8.3.2)
public protocol SDAI__SET__subtype: SDAI__SET__type, SDAIDefinedType
where Supertype: SDAI__SET__type 
{}
public extension SDAI__SET__subtype
{
	// Aggregation operator support
	func intersectionWith<U: SDAIBagType>(rhs: U) -> SDAI.SET<ELEMENT>? 
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { rep.intersectionWith(rhs: rhs) }
	func intersectionWith<U: SDAIAggregationInitializer>(rhs: U) -> SDAI.SET<ELEMENT>? 
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { rep.intersectionWith(rhs: rhs) }
	
	func unionWith<U: SDAIBagType>(rhs: U) -> SDAI.SET<ELEMENT>? 
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { rep.unionWith(rhs: rhs) }
	func unionWith<U: SDAIListType>(rhs: U) -> SDAI.SET<ELEMENT>? 
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { rep.unionWith(rhs: rhs) }
	func unionWith<U: SDAIGenericType>(rhs: U) -> SDAI.SET<ELEMENT>? 
	where ELEMENT.FundamentalType == U.FundamentalType { rep.unionWith(rhs: rhs) }
	func unionWith<U: SDAI__GENERIC__type>(rhs: U) -> SDAI.SET<ELEMENT>? { rep.unionWith(rhs: rhs) }
	func unionWith<U: SDAIAggregationInitializer>(rhs: U) -> SDAI.SET<ELEMENT>? 
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { rep.unionWith(rhs: rhs) }

	func differenceWith<U: SDAIBagType>(rhs: U) -> SDAI.SET<ELEMENT>? 
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { rep.differenceWith(rhs: rhs) }
	func differenceWith<U: SDAIGenericType>(rhs: U) -> SDAI.SET<ELEMENT>? 
	where ELEMENT.FundamentalType == U.FundamentalType { rep.differenceWith(rhs: rhs) }
	func differenceWith<U: SDAI__GENERIC__type>(rhs: U) -> SDAI.SET<ELEMENT>? { rep.differenceWith(rhs: rhs) }
	func differenceWith<U: SDAIAggregationInitializer>(rhs: U) -> SDAI.SET<ELEMENT>? 
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { rep.differenceWith(rhs: rhs) }
	
	// InitializableByGenerictype
	init?<G: SDAIGenericType>(fromGeneric generic: G?) {
		guard let fundamental = FundamentalType.convert(fromGeneric: generic) else { return nil }
		self.init(fundamental: fundamental)
	}
	
	// InitializableByGenericSet
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__SET__type>(bound1: I1, bound2: I2?, generic settype: T?) {
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, generic: settype))
	}

	// InitializableByGenericBag
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__BAG__type>(bound1: I1, bound2: I2?, generic bagtype: T?) {
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, generic: bagtype))
	}

	// InitializableByGenericList
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__LIST__type>(bound1: I1, bound2: I2?, generic listtype: T?) {
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, generic: listtype))
	}

	// InitializableByEmptyListLiteral
	init<I1: SwiftIntConvertible, I2: SwiftIntConvertible>(bound1: I1, bound2: I2?, _ emptyLiteral: SDAI.EmptyAggregateLiteral = SDAI.EMPTY_AGGREGATE) {
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, emptyLiteral) )
	} 
	
	// InitializableBySwifttypeAsList
	init<I1: SwiftIntConvertible, I2: SwiftIntConvertible>(from swiftValue: SwiftType, bound1: I1, bound2: I2?) {
		self.init(fundamental: FundamentalType(from: swiftValue, bound1: bound1, bound2: bound2) )
	} 

	// InitializableBySelecttypeAsList
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, S: SDAISelectType>(bound1: I1, bound2: I2?, _ select: S?) {
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, select) )
	}

	// InitializableByListLiteral
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E: SDAIGenericType>(bound1: I1, bound2: I2?, _ elements: [SDAI.AggregationInitializerElement<E>]) {
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, elements) )
	} 
}



//MARK: - for select type element
public extension SDAI__SET__subtype
where ELEMENT: InitializableBySelectType
{
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T:SDAI__SET__type>(bound1: I1, bound2: I2?, _ settype: T?) 
	where T.ELEMENT: SDAISelectType
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, settype) )
	}
}


//MARK: - for entity type element
public extension SDAI__SET__subtype
where ELEMENT: InitializableByEntity
{
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__SET__type>(bound1: I1, bound2: I2?, _ settype: T?) 
	where T.ELEMENT: SDAI.EntityReference
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, settype) )
	}	
}


//MARK: - for defined type element
public extension SDAI__SET__subtype
where ELEMENT: InitializableByDefinedType
{
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T:SDAI__SET__type>(bound1: I1, bound2: I2?, _ settype: T?) 
	where T.ELEMENT: SDAIUnderlyingType
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, settype) )
	}
}

