//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation


//MARK: - LIST subtype
public protocol SDAI__LIST__subtype: SDAI__LIST__type, SDAIDefinedType
where Supertype: SDAI__LIST__type
{}
public extension SDAI__LIST__subtype
{
	// Aggregation operator support
	func unionWith<U: SDAIListType>(rhs: U) -> SDAI.LIST<ELEMENT>? 
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { rep.unionWith(rhs: rhs) }
	func unionWith<U: SDAIGenericType>(rhs: U) -> SDAI.LIST<ELEMENT>? 
	where ELEMENT.FundamentalType == U.FundamentalType { rep.unionWith(rhs: rhs) }
	func unionWith<U: SDAIGenericType>(lhs: U) -> SDAI.LIST<ELEMENT>? 
	where ELEMENT.FundamentalType == U.FundamentalType { rep.unionWith(lhs: lhs) }
	func unionWith<U: SDAI__GENERIC__type>(rhs: U) -> SDAI.LIST<ELEMENT>? { rep.unionWith(rhs: rhs) }
	func unionWith<U: SDAI__GENERIC__type>(lhs: U) -> SDAI.LIST<ELEMENT>? { rep.unionWith(lhs: lhs) }
	func unionWith<U: SDAIAggregationInitializer>(rhs: U) -> SDAI.LIST<ELEMENT>? 
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { rep.unionWith(rhs: rhs) }
	func unionWith<U: SDAIAggregationInitializer>(lhs: U) -> SDAI.LIST<ELEMENT>? 
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { rep.unionWith(lhs: lhs) }
	
	// InitializableByGenerictype
	init?<G: SDAIGenericType>(fromGeneric generic: G?) {
		guard let fundamental = FundamentalType(fromGeneric: generic) else { return nil }
		self.init(fundamental: fundamental)
	}
	
	// InitializableByGenericList
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__LIST__type>(bound1: I1, bound2: I2?, generic listtype: T?) 
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, generic: listtype))
	}

	
	// InitializableByEmptyListLiteral
	init<I1: SwiftIntConvertible, I2: SwiftIntConvertible>(bound1: I1, bound2: I2?, _ emptyLiteral: SDAI.EmptyAggregateLiteral = SDAI.EMPLY_AGGREGATE) {
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
public extension SDAI__LIST__subtype
where ELEMENT: InitializableBySelecttype
{
//	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E: SDAISelectType>(bound1: I1, bound2: I2?, _ elements: [SDAI.AggregationInitializerElement<E>]) 
//	{
//		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, elements) )
//	}

	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T:SDAI__LIST__type>(bound1: I1, bound2: I2?, _ listtype: T?) 
	where T.ELEMENT: SDAISelectType//, T.ELEMENT == T.Element
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, listtype) )
	}
}


//MARK: - for entity type element
public extension SDAI__LIST__subtype
where ELEMENT: InitializableByEntity
{
//	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E: SDAI.EntityReference>(bound1: I1, bound2: I2?, _ elements: [SDAI.AggregationInitializerElement<E>]) {
//		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, elements) )
//	}

	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__LIST__type>(bound1: I1, bound2: I2?, _ listtype: T?) 
	where T.ELEMENT: SDAI.EntityReference
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, listtype) )
	}	
}


//MARK: - for defined type element
public extension SDAI__LIST__subtype
where ELEMENT: InitializableByDefinedtype
{
//	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E: SDAIUnderlyingType>(bound1: I1, bound2: I2?, _ elements: [SDAI.AggregationInitializerElement<E>]) 
//	{
//		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, elements) )
//	}

	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T:SDAI__LIST__type>(bound1: I1, bound2: I2?, _ listtype: T?) 
	where T.ELEMENT: SDAIUnderlyingType
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, listtype) )
	}
}


////MARK: - for swift type array literal
//public extension SDAI__LIST__subtype
//where ELEMENT: InitializableBySwifttype
//{
//	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E>(bound1: I1, bound2: I2?, _ elements: [SDAI.AggregationInitializerElement<E>]) 
//	where E == ELEMENT.SwiftType
//	{
//		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, elements) )
//	}
//}
//
