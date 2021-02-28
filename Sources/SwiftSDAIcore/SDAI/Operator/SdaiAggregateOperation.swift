//
//  File.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//

import Foundation

//MARK: - Aggregate operators
//MARK:  Intersection operator
// vs. swift type aggretate initializer
//public func * <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:InitializableBySwifttype, T.ELEMENT.SwiftType == U.ELEMENT { abstruct() }
//public func * <T: SDAIAggregationInitializer, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? where U.ELEMENT:InitializableBySwifttype, T.ELEMENT == U.ELEMENT.SwiftType { abstruct() }

// defined type vs. definded type
public func * <T: SDAI__BAG__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
public func * <T: SDAI__BAG__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }

public func * <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
public func * <T: SDAIAggregationInitializer, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }

public func * <T: SDAI__BAG__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
public func * <T: SDAIAggregationInitializer, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }

// entity type vs. entity type
public func * <T: SDAI__BAG__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAI.EntityReference { abstruct() }
public func * <T: SDAI__BAG__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAI.EntityReference { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAI.EntityReference { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAI.EntityReference { abstruct() }

public func * <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference,U.ELEMENT:SDAI.EntityReference { abstruct() }
public func * <T: SDAIAggregationInitializer, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? where T.ELEMENT:SDAI.EntityReference,U.ELEMENT:SDAI.EntityReference { abstruct() }

public func * <T: SDAI__BAG__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference,U.ELEMENT:SDAI.EntityReference { abstruct() }
public func * <T: SDAIAggregationInitializer, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? where T.ELEMENT:SDAI.EntityReference,U.ELEMENT:SDAI.EntityReference { abstruct() }

// select type vs. select type
public func * <T: SDAI__BAG__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAISelectType { abstruct() }
public func * <T: SDAI__BAG__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAISelectType { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAISelectType { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAISelectType { abstruct() }

public func * <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAISelectType { abstruct() }
public func * <T: SDAIAggregationInitializer, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAISelectType { abstruct() }

public func * <T: SDAI__BAG__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAISelectType { abstruct() }
public func * <T: SDAIAggregationInitializer, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAISelectType { abstruct() }

// select type vs. defined type
public func * <T: SDAI__BAG__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIUnderlyingType { abstruct() }
public func * <T: SDAI__BAG__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIUnderlyingType { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIUnderlyingType { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIUnderlyingType { abstruct() }

public func * <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIUnderlyingType { abstruct() }
public func * <T: SDAIAggregationInitializer, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIUnderlyingType { abstruct() }

public func * <T: SDAI__BAG__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIUnderlyingType { abstruct() }
public func * <T: SDAIAggregationInitializer, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIUnderlyingType { abstruct() }

// select type vs. entity type
public func * <T: SDAI__BAG__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAI.EntityReference { abstruct() }
public func * <T: SDAI__BAG__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAI.EntityReference { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAI.EntityReference { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAI.EntityReference { abstruct() }

public func * <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAI.EntityReference { abstruct() }
public func * <T: SDAIAggregationInitializer, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAI.EntityReference { abstruct() }

public func * <T: SDAI__BAG__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAI.EntityReference { abstruct() }
public func * <T: SDAIAggregationInitializer, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAI.EntityReference { abstruct() }

// defined type vs. select type
public func * <T: SDAI__BAG__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAISelectType { abstruct() }
public func * <T: SDAI__BAG__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAISelectType { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAISelectType { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAISelectType { abstruct() }

public func * <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAISelectType { abstruct() }
public func * <T: SDAIAggregationInitializer, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAISelectType { abstruct() }

public func * <T: SDAI__BAG__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAISelectType { abstruct() }
public func * <T: SDAIAggregationInitializer, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAISelectType { abstruct() }

// entity type vs. select type
public func * <T: SDAI__BAG__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAISelectType { abstruct() }
public func * <T: SDAI__BAG__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAISelectType { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAISelectType { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAISelectType { abstruct() }

public func * <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAISelectType { abstruct() }
public func * <T: SDAIAggregationInitializer, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAISelectType { abstruct() }

public func * <T: SDAI__BAG__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAISelectType { abstruct() }
public func * <T: SDAIAggregationInitializer, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAISelectType { abstruct() }


//MARK: - Union operator
// Bag + Bag = Bag
// Bag + Set = Bag
public func + <T: SDAI__BAG__type, U: SDAIBagType>		(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }

// Bag + List = Bag
public func + <T: SDAI__BAG__type, U: SDAIListType>		(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }

// Bag + Element = Bag
//public func + <T: SDAI__BAG__type, U: SDAISelectType>				(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	 { abstruct() }
public func + <T: SDAI__BAG__type, U: SDAIGenericType>		(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT.FundamentalType == U.FundamentalType { abstruct() }
public func + <T: SDAI__BAG__type, U: SDAI__GENERIC__type>	(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	 { abstruct() }
public func + <T: SDAI__BAG__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT.FundamentalType: SDAI__NUMBER__type, U.FundamentalType: SDAIRealType { abstruct() }
public func + <T: SDAI__BAG__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT.FundamentalType: SDAI__REAL__type, U.FundamentalType: SDAIIntegerType { abstruct() }
public func + <T: SDAI__BAG__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT.FundamentalType: SDAI__LOGICAL__type, U.FundamentalType: SDAIBooleanType { abstruct() }
//public func + <T: SDAI__BAG__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT.FundamentalType: SDAI__ARRAY_OPTIONAL__type, U.FundamentalType: SDAIArrayType { abstruct() }
//public func + <T: SDAI__BAG__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT.FundamentalType: SDAI__BAG__type, U.FundamentalType: SDAISetType { abstruct() }

// Element + Bag = Bag
//public func + <T: SDAISelectType, U: SDAI__BAG__type>				(lhs: T?, rhs: U?) -> SDAI.BAG<U.ELEMENT>?		{ abstruct() }
public func + <T: SDAIGenericType, U: SDAI__BAG__type>		(lhs: T?, rhs: U?) -> SDAI.BAG<T>?					where T.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
public func + <T: SDAI__GENERIC__type, U: SDAI__BAG__type>	(lhs: T?, rhs: U?) -> SDAI.BAG<T>?				{ abstruct() }
public func + <T: SDAIGenericType, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T>?					where T.FundamentalType: SDAI__NUMBER__type, U.ELEMENT.FundamentalType: SDAIRealType { abstruct() }
public func + <T: SDAIGenericType, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T>?					where T.FundamentalType: SDAI__REAL__type, U.ELEMENT.FundamentalType: SDAIIntegerType { abstruct() }
public func + <T: SDAIGenericType, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T>?					where T.FundamentalType: SDAI__LOGICAL__type, U.ELEMENT.FundamentalType: SDAIBooleanType { abstruct() }
//public func + <T: SDAIGenericType, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T>?					where T.FundamentalType: SDAI__ARRAY_OPTIONAL__type, U.ELEMENT.FundamentalType: SDAIArrayType { abstruct() }
//public func + <T: SDAIGenericType, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T>?					where T.FundamentalType: SDAI__BAG__type, U.ELEMENT.FundamentalType: SDAISetType { abstruct() }

// Set + Set = Set
// Set + Bag = Set
public func + <T: SDAI__SET__type, U: SDAIBagType>		(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? 	where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }

// Set + List = Set
public func + <T: SDAI__SET__type, U: SDAIListType>		(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }

// Set + Element = Set
//public func + <T: SDAI__SET__type, U: SDAISelectType>				(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?		{ abstruct() }
public func + <T: SDAI__SET__type, U: SDAIGenericType>		(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	where T.ELEMENT.FundamentalType == U.FundamentalType { abstruct() }
public func + <T: SDAI__SET__type, U: SDAI__GENERIC__type>	(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	 { abstruct() }
public func + <T: SDAI__SET__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	where T.ELEMENT.FundamentalType: SDAI__NUMBER__type, U.FundamentalType: SDAIRealType { abstruct() }
public func + <T: SDAI__SET__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	where T.ELEMENT.FundamentalType: SDAI__REAL__type, U.FundamentalType: SDAIIntegerType { abstruct() }
public func + <T: SDAI__SET__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	where T.ELEMENT.FundamentalType: SDAI__LOGICAL__type, U.FundamentalType: SDAIBooleanType { abstruct() }
//public func + <T: SDAI__SET__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	where T.ELEMENT.FundamentalType: SDAI__ARRAY_OPTIONAL__type, U.FundamentalType: SDAIArrayType { abstruct() }
//public func + <T: SDAI__SET__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	where T.ELEMENT.FundamentalType: SDAI__BAG__type, U.FundamentalType: SDAISetType { abstruct() }

// Element + Set = Set
//public func + <T: SDAISelectType, U: SDAI__SET__type>				(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>?		{ abstruct() }
public func + <T: SDAIGenericType, U: SDAI__SET__type>		(lhs: T?, rhs: U?) -> SDAI.SET<T>?	where T.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
public func + <T: SDAI__GENERIC__type, U: SDAI__SET__type>	(lhs: T?, rhs: U?) -> SDAI.SET<T>?	 { abstruct() }
public func + <T: SDAIGenericType, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T>?					where T.FundamentalType: SDAI__NUMBER__type, U.ELEMENT.FundamentalType: SDAIRealType { abstruct() }
public func + <T: SDAIGenericType, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T>?					where T.FundamentalType: SDAI__REAL__type, U.ELEMENT.FundamentalType: SDAIIntegerType { abstruct() }
public func + <T: SDAIGenericType, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T>?					where T.FundamentalType: SDAI__LOGICAL__type, U.ELEMENT.FundamentalType: SDAIBooleanType { abstruct() }

// List + List = List
public func + <T: SDAIListType, U: SDAIListType>			(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>?	where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }

// List + Element = List
//public func + <T: SDAIListType, U: SDAISelectType>				(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>?	{ abstruct() }
public func + <T: SDAIListType, U: SDAIGenericType>		(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>?	where T.ELEMENT.FundamentalType == U.FundamentalType { abstruct() }
public func + <T: SDAIListType, U: SDAI__GENERIC__type>		(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>?	{ abstruct() }
public func + <T: SDAIListType, U: SDAIGenericType>		(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>?	where T.ELEMENT.FundamentalType: SDAI__NUMBER__type, U.FundamentalType: SDAIRealType { abstruct() }
public func + <T: SDAIListType, U: SDAIGenericType>		(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>?	where T.ELEMENT.FundamentalType: SDAI__REAL__type, U.FundamentalType: SDAIIntegerType { abstruct() }
public func + <T: SDAIListType, U: SDAIGenericType>		(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>?	where T.ELEMENT.FundamentalType: SDAI__LOGICAL__type, U.FundamentalType: SDAIBooleanType { abstruct() }

// Element + List = List
//public func + <T: SDAISelectType, U: SDAIListType>				(lhs: T?, rhs: U?) -> SDAI.LIST<U.ELEMENT>?	{ abstruct() }
public func + <T: SDAIGenericType, U: SDAIListType>		(lhs: T?, rhs: U?) -> SDAI.LIST<T>?					where T.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
public func + <T: SDAI__GENERIC__type, U: SDAIListType>		(lhs: T?, rhs: U?) -> SDAI.LIST<T>?			 { abstruct() }
public func + <T: SDAIGenericType, U: SDAIListType>		(lhs: T?, rhs: U?) -> SDAI.LIST<T>?					where T.FundamentalType: SDAI__NUMBER__type, U.ELEMENT.FundamentalType: SDAIRealType { abstruct() }
public func + <T: SDAIGenericType, U: SDAIListType>		(lhs: T?, rhs: U?) -> SDAI.LIST<T>?					where T.FundamentalType: SDAI__REAL__type, U.ELEMENT.FundamentalType: SDAIIntegerType { abstruct() }
public func + <T: SDAIGenericType, U: SDAIListType>		(lhs: T?, rhs: U?) -> SDAI.LIST<T>?					where T.FundamentalType: SDAI__LOGICAL__type, U.ELEMENT.FundamentalType: SDAIBooleanType { abstruct() }

// Bag + Aggregate = Bag
public func + <T: SDAI__BAG__type, U: SDAIAggregationInitializer>	(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? 	where U.ELEMENT: SDAIGenericType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }

// Aggregate + Bag = Bag
public func + <T: SDAIAggregationInitializer, U: SDAI__BAG__type>	(lhs: T?, rhs: U?) -> SDAI.BAG<U.ELEMENT>? 	where T.ELEMENT: SDAIGenericType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }

// Set + Aggregate = Set
public func + <T: SDAI__SET__type, U: SDAIAggregationInitializer>	(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? 	where U.ELEMENT: SDAIGenericType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }

// Aggregate + Set = Set
public func + <T: SDAIAggregationInitializer, U: SDAI__SET__type>	(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? 	where T.ELEMENT: SDAIGenericType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }

// List + Aggregate = List
public func + <T: SDAIListType, U: SDAIAggregationInitializer>		(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>?	where U.ELEMENT: SDAIGenericType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }

// Aggregate + List = List
public func + <T: SDAIAggregationInitializer, U: SDAIListType>		(lhs: T?, rhs: U?) -> SDAI.LIST<U.ELEMENT>?	where T.ELEMENT: SDAIGenericType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }

//// defined type vs. definded type
//public func + <T: SDAI__BAG__type, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
//public func + <T: SDAI__BAG__type, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
//public func + <T: SDAI__BAG__type, U>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? 							where T.ELEMENT:SDAIUnderlyingType, U:				SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.FundamentalType { abstruct() }
//public func + <T, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T>? 											where T:				SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
//
//public func + <T: SDAI__SET__type, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? 	where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
//public func + <T: SDAI__SET__type, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
//public func + <T: SDAI__SET__type, U>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? 							where T.ELEMENT:SDAIUnderlyingType, U:				SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.FundamentalType { abstruct() }
//public func + <T, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T>? 											where T:				SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
//
//public func + <T: SDAIListType, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>? 	where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
//public func + <T: SDAIListType, U>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>? 								where T.ELEMENT:SDAIUnderlyingType, U:				SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.FundamentalType { abstruct() }
//public func + <T, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LIST<T>? 												where T:				SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
//
//public func + <T: SDAI__BAG__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
//public func + <T: SDAIAggregationInitializer, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<U.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
//public func + <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
//public func + <T: SDAIAggregationInitializer, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
//public func + <T: SDAIListType, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>? 	where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
//public func + <T: SDAIAggregationInitializer, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LIST<U.ELEMENT>? 	where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
//
//// entity type vs. entity type
//public func + <T: SDAI__BAG__type, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAI.EntityReference { abstruct() }
//public func + <T: SDAI__BAG__type, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAI.EntityReference { abstruct() }
//public func + <T: SDAI__BAG__type, U>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? 							where T.ELEMENT:SDAI.EntityReference, U:				SDAI.EntityReference { abstruct() }
//public func + <T, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T>? 											where T:				SDAI.EntityReference, U.ELEMENT:SDAI.EntityReference { abstruct() }
//
//public func + <T: SDAI__SET__type, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? 	where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAI.EntityReference { abstruct() }
//public func + <T: SDAI__SET__type, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAI.EntityReference { abstruct() }
//public func + <T: SDAI__SET__type, U>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? 							where T.ELEMENT:SDAI.EntityReference, U:				SDAI.EntityReference { abstruct() }
//public func + <T, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T>? 											where T:				SDAI.EntityReference, U.ELEMENT:SDAI.EntityReference { abstruct() }
//
//public func + <T: SDAIListType, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>? 	where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAI.EntityReference { abstruct() }
//public func + <T: SDAIListType, U>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>? 								where T.ELEMENT:SDAI.EntityReference, U:				SDAI.EntityReference { abstruct() }
//public func + <T, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LIST<T>? 												where T:				SDAI.EntityReference, U.ELEMENT:SDAI.EntityReference { abstruct() }
//
//public func + <T: SDAI__BAG__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAI.EntityReference { abstruct() }
//public func + <T: SDAIAggregationInitializer, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<U.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAI.EntityReference { abstruct() }
//public func + <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAI.EntityReference { abstruct() }
//public func + <T: SDAIAggregationInitializer, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAI.EntityReference { abstruct() }
//public func + <T: SDAIListType, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>? 	where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAI.EntityReference { abstruct() }
//public func + <T: SDAIAggregationInitializer, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LIST<U.ELEMENT>? 	where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAI.EntityReference { abstruct() }
//
//// select type vs. select type
//public func + <T: SDAI__BAG__type, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAISelectType { abstruct() }
//public func + <T: SDAI__BAG__type, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAISelectType { abstruct() }
//public func + <T: SDAI__BAG__type, U>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? 							where T.ELEMENT:SDAISelectType, U:				SDAISelectType { abstruct() }
//public func + <T, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T>? 											where T:				SDAISelectType, U.ELEMENT:SDAISelectType { abstruct() }
//
//public func + <T: SDAI__SET__type, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? 	where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAISelectType { abstruct() }
//public func + <T: SDAI__SET__type, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAISelectType { abstruct() }
//public func + <T: SDAI__SET__type, U>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? 							where T.ELEMENT:SDAISelectType, U:				SDAISelectType { abstruct() }
//public func + <T, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T>? 											where T:				SDAISelectType, U.ELEMENT:SDAISelectType { abstruct() }
//
//public func + <T: SDAIListType, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>? 	where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAISelectType { abstruct() }
//public func + <T: SDAIListType, U>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>? 								where T.ELEMENT:SDAISelectType, U:				SDAISelectType { abstruct() }
//public func + <T, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LIST<T>? 												where T:				SDAISelectType, U.ELEMENT:SDAISelectType { abstruct() }
//
//public func + <T: SDAI__BAG__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAISelectType { abstruct() }
//public func + <T: SDAIAggregationInitializer, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<U.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAISelectType { abstruct() }
//public func + <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAISelectType { abstruct() }
//public func + <T: SDAIAggregationInitializer, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAISelectType { abstruct() }
//public func + <T: SDAIListType, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>? 	where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAISelectType { abstruct() }
//public func + <T: SDAIAggregationInitializer, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LIST<U.ELEMENT>? 	where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAISelectType { abstruct() }
//
//// select type vs. defined type
//public func + <T: SDAI__BAG__type, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIUnderlyingType { abstruct() }
//public func + <T: SDAI__BAG__type, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIUnderlyingType { abstruct() }
////public func + <T: SDAI__BAG__type, U>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? 							where T.ELEMENT:SDAISelectType, U:				SDAIUnderlyingType { abstruct() }
//public func + <T, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T>? 											where T:				SDAISelectType, U.ELEMENT:SDAIUnderlyingType { abstruct() }
//
//public func + <T: SDAI__SET__type, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? 	where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIUnderlyingType { abstruct() }
//public func + <T: SDAI__SET__type, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIUnderlyingType { abstruct() }
////public func + <T: SDAI__SET__type, U>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? 							where T.ELEMENT:SDAISelectType, U:				SDAIUnderlyingType { abstruct() }
//public func + <T, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T>? 											where T:				SDAISelectType, U.ELEMENT:SDAIUnderlyingType { abstruct() }
//
//public func + <T: SDAIListType, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>? 	where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIUnderlyingType { abstruct() }
////public func + <T: SDAIListType, U>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>? 								where T.ELEMENT:SDAISelectType, U:				SDAIUnderlyingType { abstruct() }
//public func + <T, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LIST<T>? 												where T:				SDAISelectType, U.ELEMENT:SDAIUnderlyingType { abstruct() }
//
//public func + <T: SDAI__BAG__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIUnderlyingType { abstruct() }
//public func + <T: SDAIAggregationInitializer, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<U.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIUnderlyingType { abstruct() }
//public func + <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIUnderlyingType { abstruct() }
//public func + <T: SDAIAggregationInitializer, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIUnderlyingType { abstruct() }
//public func + <T: SDAIListType, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>? 	where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIUnderlyingType { abstruct() }
//public func + <T: SDAIAggregationInitializer, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LIST<U.ELEMENT>? 	where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIUnderlyingType { abstruct() }
//
//// select type vs. entity type
//public func + <T: SDAI__BAG__type, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAI.EntityReference { abstruct() }
//public func + <T: SDAI__BAG__type, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAI.EntityReference { abstruct() }
//public func + <T: SDAI__BAG__type, U>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? 							where T.ELEMENT:SDAISelectType, U:				SDAI.EntityReference { abstruct() }
//public func + <T, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T>? 											where T:				SDAISelectType, U.ELEMENT:SDAI.EntityReference { abstruct() }
//
//public func + <T: SDAI__SET__type, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? 	where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAI.EntityReference { abstruct() }
//public func + <T: SDAI__SET__type, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAI.EntityReference { abstruct() }
//public func + <T: SDAI__SET__type, U>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? 							where T.ELEMENT:SDAISelectType, U:				SDAI.EntityReference { abstruct() }
//public func + <T, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T>? 											where T:				SDAISelectType, U.ELEMENT:SDAI.EntityReference { abstruct() }
//
//public func + <T: SDAIListType, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>? 	where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAI.EntityReference { abstruct() }
//public func + <T: SDAIListType, U>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>? 								where T.ELEMENT:SDAISelectType, U:				SDAI.EntityReference { abstruct() }
//public func + <T, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LIST<T>? 												where T:				SDAISelectType, U.ELEMENT:SDAI.EntityReference { abstruct() }
//
//public func + <T: SDAI__BAG__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAI.EntityReference { abstruct() }
//public func + <T: SDAIAggregationInitializer, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<U.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAI.EntityReference { abstruct() }
//public func + <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAI.EntityReference { abstruct() }
//public func + <T: SDAIAggregationInitializer, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAI.EntityReference { abstruct() }
//public func + <T: SDAIListType, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>? 	where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAI.EntityReference { abstruct() }
//public func + <T: SDAIAggregationInitializer, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LIST<U.ELEMENT>? 	where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAI.EntityReference { abstruct() }
//
//// defined type vs. select type
//public func + <T: SDAI__BAG__type, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAISelectType { abstruct() }
//public func + <T: SDAI__BAG__type, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAISelectType { abstruct() }
//public func + <T: SDAI__BAG__type, U>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? 							where T.ELEMENT:SDAIUnderlyingType, U:				SDAISelectType { abstruct() }
////public func + <T, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T>? 											where T:				SDAIUnderlyingType, U.ELEMENT:SDAISelectType { abstruct() }
//
//public func + <T: SDAI__SET__type, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? 	where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAISelectType { abstruct() }
//public func + <T: SDAI__SET__type, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAISelectType { abstruct() }
//public func + <T: SDAI__SET__type, U>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? 							where T.ELEMENT:SDAIUnderlyingType, U:				SDAISelectType { abstruct() }
////public func + <T, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T>? 											where T:				SDAIUnderlyingType, U.ELEMENT:SDAISelectType { abstruct() }
//
//public func + <T: SDAIListType, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>? 	where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAISelectType { abstruct() }
//public func + <T: SDAIListType, U>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>? 								where T.ELEMENT:SDAIUnderlyingType, U:				SDAISelectType { abstruct() }
////public func + <T, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LIST<T>? 												where T:				SDAIUnderlyingType, U.ELEMENT:SDAISelectType { abstruct() }
//
//public func + <T: SDAI__BAG__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAISelectType { abstruct() }
//public func + <T: SDAIAggregationInitializer, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<U.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAISelectType { abstruct() }
//public func + <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAISelectType { abstruct() }
//public func + <T: SDAIAggregationInitializer, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAISelectType { abstruct() }
//public func + <T: SDAIListType, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>? 	where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAISelectType { abstruct() }
//public func + <T: SDAIAggregationInitializer, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LIST<U.ELEMENT>? 	where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAISelectType { abstruct() }
//
//// entity type vs. select type
//public func + <T: SDAI__BAG__type, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAISelectType { abstruct() }
//public func + <T: SDAI__BAG__type, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAISelectType { abstruct() }
//public func + <T: SDAI__BAG__type, U>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? 							where T.ELEMENT:SDAI.EntityReference, U:				SDAISelectType { abstruct() }
//public func + <T, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T>? 											where T:				SDAI.EntityReference, U.ELEMENT:SDAISelectType { abstruct() }
//
//public func + <T: SDAI__SET__type, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? 	where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAISelectType { abstruct() }
//public func + <T: SDAI__SET__type, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAISelectType { abstruct() }
//public func + <T: SDAI__SET__type, U>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? 							where T.ELEMENT:SDAI.EntityReference, U:				SDAISelectType { abstruct() }
//public func + <T, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T>? 											where T:				SDAI.EntityReference, U.ELEMENT:SDAISelectType { abstruct() }
//
//public func + <T: SDAIListType, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>? 	where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAISelectType { abstruct() }
//public func + <T: SDAIListType, U>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>? 								where T.ELEMENT:SDAI.EntityReference, U:				SDAISelectType { abstruct() }
//public func + <T, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LIST<T>? 												where T:				SDAI.EntityReference, U.ELEMENT:SDAISelectType { abstruct() }
//
//public func + <T: SDAI__BAG__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAISelectType { abstruct() }
//public func + <T: SDAIAggregationInitializer, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<U.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAISelectType { abstruct() }
//public func + <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAISelectType { abstruct() }
//public func + <T: SDAIAggregationInitializer, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAISelectType { abstruct() }
//public func + <T: SDAIListType, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>? 	where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAISelectType { abstruct() }
//public func + <T: SDAIAggregationInitializer, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LIST<U.ELEMENT>? 	where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAISelectType { abstruct() }
//
//
//// GENERIC vs. generic type
//public func + <T: SDAI__BAG__type, U: SDAIBagType>			(lhs: T?, rhs: U?) -> SDAI.BAG<SDAI.GENERIC>?	where T.ELEMENT == SDAI.GENERIC { abstruct() }
//public func + <T: SDAI__BAG__type, U: SDAIListType>			(lhs: T?, rhs: U?) -> SDAI.BAG<SDAI.GENERIC>?	where T.ELEMENT == SDAI.GENERIC { abstruct() }
//
//public func + <T: SDAI__BAG__type>	(lhs: T?, rhs: SDAI.GENERIC?) -> SDAI.BAG<SDAI.GENERIC>? where T.ELEMENT == SDAI.GENERIC 	{ abstruct() }
//public func + <U: SDAI__BAG__type>	(lhs: SDAI.GENERIC?, rhs: U?) -> SDAI.BAG<SDAI.GENERIC>?  																{ abstruct() }
//
//public func + <T: SDAI__SET__type, U: SDAIBagType>			(lhs: T?, rhs: U?) -> SDAI.SET<SDAI.GENERIC>? where T.ELEMENT == SDAI.GENERIC { abstruct() }
//public func + <T: SDAI__SET__type, U: SDAIListType>			(lhs: T?, rhs: U?) -> SDAI.SET<SDAI.GENERIC>?	where T.ELEMENT == SDAI.GENERIC { abstruct() }
//
//public func + <T: SDAI__SET__type>	(lhs: T?, rhs: SDAI.GENERIC?) -> SDAI.SET<SDAI.GENERIC>? where T.ELEMENT == SDAI.GENERIC 	{ abstruct() }
//public func + <U: SDAI__SET__type>	(lhs: SDAI.GENERIC?, rhs: U?) -> SDAI.SET<SDAI.GENERIC>?																	{ abstruct() }
//
//public func + <T: SDAIListType, U: SDAIListType>				(lhs: T?, rhs: U?) -> SDAI.LIST<SDAI.GENERIC>? where T.ELEMENT == SDAI.GENERIC { abstruct() }
//public func + <T: SDAIListType>	(lhs: T?, rhs: SDAI.GENERIC?) -> SDAI.LIST<SDAI.GENERIC>? where T.ELEMENT == SDAI.GENERIC { abstruct() }
//public func + <U: SDAIListType>	(lhs: SDAI.GENERIC?, rhs: U?) -> SDAI.LIST<SDAI.GENERIC>?																 	{ abstruct() }
//
//public func + <T: SDAI__BAG__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.BAG<SDAI.GENERIC>? 	where T.ELEMENT == SDAI.GENERIC	{ abstruct() }
//public func + <T: SDAIAggregationInitializer, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<SDAI.GENERIC>? 	where T.ELEMENT == SDAI.GENERIC	{ abstruct() }
//public func + <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<SDAI.GENERIC>? 	where T.ELEMENT == SDAI.GENERIC	{ abstruct() }
//public func + <T: SDAIAggregationInitializer, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<SDAI.GENERIC>? 	where T.ELEMENT == SDAI.GENERIC	{ abstruct() }
//public func + <T: SDAIListType, U: SDAIAggregationInitializer>   (lhs: T?, rhs: U?) -> SDAI.LIST<SDAI.GENERIC>? where T.ELEMENT == SDAI.GENERIC	{ abstruct() }
//public func + <T: SDAIAggregationInitializer, U: SDAIListType>   (lhs: T?, rhs: U?) -> SDAI.LIST<SDAI.GENERIC>? where T.ELEMENT == SDAI.GENERIC	{ abstruct() }





//MARK: - Difference operator
// defined type vs. definded type
public func - <T: SDAI__BAG__type, U: SDAIBagType>							 (lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
public func - <T: SDAI__BAG__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
public func - <T: SDAI__BAG__type, U>														 (lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U:				SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.FundamentalType { abstruct() }
public func - <T: SDAI__SET__type, U: SDAIBagType>							 (lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
public func - <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
public func - <T: SDAI__SET__type, U>														 (lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U:				SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.FundamentalType { abstruct() }

// entity type vs. entity type
public func - <T: SDAI__BAG__type, U: SDAIBagType>							 (lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAI.EntityReference { abstruct() }
public func - <T: SDAI__BAG__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAI.EntityReference { abstruct() }
public func - <T: SDAI__BAG__type, U>														 (lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U:				SDAI.EntityReference { abstruct() }
public func - <T: SDAI__SET__type, U: SDAIBagType>							 (lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAI.EntityReference { abstruct() }
public func - <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAI.EntityReference { abstruct() }
public func - <T: SDAI__SET__type, U>														 (lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U:				SDAI.EntityReference { abstruct() }

// select type vs. select type
public func - <T: SDAI__BAG__type, U: SDAIBagType>							 (lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAISelectType { abstruct() }
public func - <T: SDAI__BAG__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAISelectType { abstruct() }
public func - <T: SDAI__BAG__type, U>														 (lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U:				SDAISelectType { abstruct() }
public func - <T: SDAI__SET__type, U: SDAIBagType>							 (lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAISelectType { abstruct() }
public func - <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAISelectType { abstruct() }
public func - <T: SDAI__SET__type, U>														 (lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U:				SDAISelectType { abstruct() }

// select type vs. defined type
public func - <T: SDAI__BAG__type, U: SDAIBagType>							 (lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIUnderlyingType { abstruct() }
public func - <T: SDAI__BAG__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIUnderlyingType { abstruct() }
public func - <T: SDAI__BAG__type, U>														 (lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U:				SDAIUnderlyingType { abstruct() }
public func - <T: SDAI__SET__type, U: SDAIBagType>							 (lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIUnderlyingType { abstruct() }
public func - <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIUnderlyingType { abstruct() }
public func - <T: SDAI__SET__type, U>														 (lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U:				SDAIUnderlyingType { abstruct() }

// select type vs. entity type
public func - <T: SDAI__BAG__type, U: SDAIBagType>							 (lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAI.EntityReference { abstruct() }
public func - <T: SDAI__BAG__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAI.EntityReference { abstruct() }
public func - <T: SDAI__BAG__type, U>														 (lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U:				SDAI.EntityReference { abstruct() }
public func - <T: SDAI__SET__type, U: SDAIBagType>							 (lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAI.EntityReference { abstruct() }
public func - <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAI.EntityReference { abstruct() }
public func - <T: SDAI__SET__type, U>														 (lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U:				SDAI.EntityReference { abstruct() }

// defined type vs. select type
public func - <T: SDAI__BAG__type, U: SDAIBagType>							 (lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAISelectType { abstruct() }
public func - <T: SDAI__BAG__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAISelectType { abstruct() }
public func - <T: SDAI__BAG__type, U>														 (lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U:				SDAISelectType { abstruct() }
public func - <T: SDAI__SET__type, U: SDAIBagType>							 (lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAISelectType { abstruct() }
public func - <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAISelectType { abstruct() }
public func - <T: SDAI__SET__type, U>														 (lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U:				SDAISelectType { abstruct() }

// entity type vs. select type
public func - <T: SDAI__BAG__type, U: SDAIBagType>							 (lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAISelectType { abstruct() }
public func - <T: SDAI__BAG__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAISelectType { abstruct() }
public func - <T: SDAI__BAG__type, U>														 (lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U:				SDAISelectType { abstruct() }
public func - <T: SDAI__SET__type, U: SDAIBagType>							 (lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAISelectType { abstruct() }
public func - <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAISelectType { abstruct() }
public func - <T: SDAI__SET__type, U>														 (lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U:				SDAISelectType { abstruct() }





//MARK: - Subset operator
public func <=   <T: SDAIBagType, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

//MARK: - Superset operator
public func >=   <T: SDAIBagType, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { return rhs <= lhs }
