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
public func * <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:InitializableBySwifttype, T.ELEMENT.SwiftType == U.ELEMENT { abstruct() }
public func * <T: SDAIAggregationInitializer, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? where U.ELEMENT:InitializableBySwifttype, T.ELEMENT == U.ELEMENT.SwiftType { abstruct() }

// defined type vs. definded type
public func * <T: SDAI__BAG__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
public func * <T: SDAI__BAG__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }

public func * <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
public func * <T: SDAIAggregationInitializer, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }

// entity type vs. entity type
public func * <T: SDAI__BAG__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAI.EntityReference { abstruct() }
public func * <T: SDAI__BAG__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAI.EntityReference { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAI.EntityReference { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAI.EntityReference { abstruct() }

public func * <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference,U.ELEMENT:SDAI.EntityReference { abstruct() }
public func * <T: SDAIAggregationInitializer, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? where T.ELEMENT:SDAI.EntityReference,U.ELEMENT:SDAI.EntityReference { abstruct() }

// select type vs. select type
public func * <T: SDAI__BAG__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAISelectType { abstruct() }
public func * <T: SDAI__BAG__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAISelectType { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAISelectType { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAISelectType { abstruct() }

public func * <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAISelectType { abstruct() }
public func * <T: SDAIAggregationInitializer, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAISelectType { abstruct() }

// select type vs. defined type
public func * <T: SDAI__BAG__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIUnderlyingType { abstruct() }
public func * <T: SDAI__BAG__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIUnderlyingType { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIUnderlyingType { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIUnderlyingType { abstruct() }

public func * <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIUnderlyingType { abstruct() }
public func * <T: SDAIAggregationInitializer, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIUnderlyingType { abstruct() }

// select type vs. entity type
public func * <T: SDAI__BAG__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAI.EntityReference { abstruct() }
public func * <T: SDAI__BAG__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAI.EntityReference { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAI.EntityReference { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAI.EntityReference { abstruct() }

public func * <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAI.EntityReference { abstruct() }
public func * <T: SDAIAggregationInitializer, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAI.EntityReference { abstruct() }

// defined type vs. select type
public func * <T: SDAI__BAG__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAISelectType { abstruct() }
public func * <T: SDAI__BAG__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAISelectType { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAISelectType { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAISelectType { abstruct() }

public func * <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAISelectType { abstruct() }
public func * <T: SDAIAggregationInitializer, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAISelectType { abstruct() }

// entity type vs. select type
public func * <T: SDAI__BAG__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAISelectType { abstruct() }
public func * <T: SDAI__BAG__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAISelectType { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAISelectType { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAISelectType { abstruct() }

public func * <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAISelectType { abstruct() }
public func * <T: SDAIAggregationInitializer, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAISelectType { abstruct() }


//MARK: - Union operator
// vs. swift type aggretate initializer
public func + <T: SDAI__BAG__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:InitializableBySwifttype, T.ELEMENT.SwiftType == U.ELEMENT { abstruct() }
public func + <T: SDAIAggregationInitializer, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<U.ELEMENT>? where U.ELEMENT:InitializableBySwifttype, T.ELEMENT == U.ELEMENT.SwiftType { abstruct() }
public func + <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:InitializableBySwifttype, T.ELEMENT.SwiftType == U.ELEMENT { abstruct() }
public func + <T: SDAIAggregationInitializer, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? where U.ELEMENT:InitializableBySwifttype, T.ELEMENT == U.ELEMENT.SwiftType { abstruct() }
public func + <T: SDAIListType, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>? where T.ELEMENT:InitializableBySwifttype, T.ELEMENT.SwiftType == U.ELEMENT { abstruct() }
public func + <T: SDAIAggregationInitializer, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LIST<U.ELEMENT>? where U.ELEMENT:InitializableBySwifttype, T.ELEMENT == U.ELEMENT.SwiftType { abstruct() }



public func + <T: SDAI__BAG__type, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT == U.ELEMENT { abstruct() }
public func + <T: SDAI__BAG__type, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT == U.ELEMENT { abstruct() }
public func + <T: SDAI__BAG__type, U>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT == U { abstruct() }
public func + <T, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T>? where T == U.ELEMENT { abstruct() }

public func + <T: SDAI__SET__type, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT == U.ELEMENT { abstruct() }
public func + <T: SDAI__SET__type, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT == U.ELEMENT { abstruct() }
public func + <T: SDAI__SET__type, U>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT == U { abstruct() }
public func + <T, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T>? where T == U.ELEMENT { abstruct() }

public func + <T: SDAIListType, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>? where T.ELEMENT == U.ELEMENT { abstruct() }
public func + <T: SDAIListType, U>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>? where T.ELEMENT == U { abstruct() }
public func + <T, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LIST<T>? where T == U.ELEMENT { abstruct() }

//MARK: - Difference operator
public func - <T: SDAI__BAG__type, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT == U.ELEMENT { abstruct() }
public func - <T: SDAI__BAG__type, U>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT == U { abstruct() }

public func - <T: SDAI__SET__type, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT == U.ELEMENT { abstruct() }
public func - <T: SDAI__SET__type, U>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT == U { abstruct() }

//MARK: - Subset operator
public func <=   <T: SDAIBagType, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

//MARK: - Superset operator
public func >=   <T: SDAIBagType, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { return rhs <= lhs }
