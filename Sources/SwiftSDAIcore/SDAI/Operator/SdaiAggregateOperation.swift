//
//  File.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//

import Foundation

//MARK: - Aggregate operators
//MARK:  Intersection operator
// Bag * Bag = Bag
public func * <T: SDAI__BAG__type, U: SDAI__BAG__type>		(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }

// Bag * Set = Set
public func * <T: SDAI__BAG__type, U: SDAI__SET__type>		(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }


// Set * Set = Set
// Set * Bag = Set
public func * <T: SDAI__SET__type, U: SDAIBagType>		(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }

// Bag * Aggregate = Bag
public func * <T: SDAI__BAG__type, U: SDAIAggregationInitializer>	(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? 	where U.ELEMENT: SDAIGenericType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }

// Aggregate * Bag = Bag
public func * <T: SDAIAggregationInitializer, U: SDAI__BAG__type>	(lhs: T?, rhs: U?) -> SDAI.BAG<U.ELEMENT>? 	where T.ELEMENT: SDAIGenericType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }

// Set * Aggregate = Set
public func * <T: SDAI__SET__type, U: SDAIAggregationInitializer>	(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? 	where U.ELEMENT: SDAIGenericType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }

// Aggregate * Set = Set
public func * <T: SDAIAggregationInitializer, U: SDAI__SET__type>	(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? 	where T.ELEMENT: SDAIGenericType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }



//MARK: - Union operator
// Bag + Bag = Bag
// Bag + Set = Bag
public func + <T: SDAI__BAG__type, U: SDAIBagType>		(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }

// Bag + List = Bag
public func + <T: SDAI__BAG__type, U: SDAIListType>		(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }

// Bag + Element = Bag
public func + <T: SDAI__BAG__type, U: SDAIGenericType>		(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT.FundamentalType == U.FundamentalType { abstruct() }
public func + <T: SDAI__BAG__type, U: SDAI__GENERIC__type>	(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	 { abstruct() }
public func + <T: SDAI__BAG__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT.FundamentalType: SDAI__NUMBER__type, U.FundamentalType: SDAIRealType { abstruct() }
public func + <T: SDAI__BAG__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT.FundamentalType: SDAI__REAL__type, U.FundamentalType: SDAIIntegerType { abstruct() }
public func + <T: SDAI__BAG__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT.FundamentalType: SDAI__LOGICAL__type, U.FundamentalType: SDAIBooleanType { abstruct() }

// Element + Bag = Bag
public func + <T: SDAIGenericType, U: SDAI__BAG__type>		(lhs: T?, rhs: U?) -> SDAI.BAG<T>?					where T.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
public func + <T: SDAI__GENERIC__type, U: SDAI__BAG__type>	(lhs: T?, rhs: U?) -> SDAI.BAG<T>?				{ abstruct() }
public func + <T: SDAIGenericType, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T>?					where T.FundamentalType: SDAI__NUMBER__type, U.ELEMENT.FundamentalType: SDAIRealType { abstruct() }
public func + <T: SDAIGenericType, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T>?					where T.FundamentalType: SDAI__REAL__type, U.ELEMENT.FundamentalType: SDAIIntegerType { abstruct() }
public func + <T: SDAIGenericType, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T>?					where T.FundamentalType: SDAI__LOGICAL__type, U.ELEMENT.FundamentalType: SDAIBooleanType { abstruct() }

// Set + Set = Set
// Set + Bag = Set
public func + <T: SDAI__SET__type, U: SDAIBagType>		(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? 	where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }

// Set + List = Set
public func + <T: SDAI__SET__type, U: SDAIListType>		(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }

// Set + Element = Set
public func + <T: SDAI__SET__type, U: SDAIGenericType>		(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	where T.ELEMENT.FundamentalType == U.FundamentalType { abstruct() }
public func + <T: SDAI__SET__type, U: SDAI__GENERIC__type>	(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	 { abstruct() }
public func + <T: SDAI__SET__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	where T.ELEMENT.FundamentalType: SDAI__NUMBER__type, U.FundamentalType: SDAIRealType { abstruct() }
public func + <T: SDAI__SET__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	where T.ELEMENT.FundamentalType: SDAI__REAL__type, U.FundamentalType: SDAIIntegerType { abstruct() }
public func + <T: SDAI__SET__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	where T.ELEMENT.FundamentalType: SDAI__LOGICAL__type, U.FundamentalType: SDAIBooleanType { abstruct() }

// Element + Set = Set
public func + <T: SDAIGenericType, U: SDAI__SET__type>		(lhs: T?, rhs: U?) -> SDAI.SET<T>?	where T.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
public func + <T: SDAI__GENERIC__type, U: SDAI__SET__type>	(lhs: T?, rhs: U?) -> SDAI.SET<T>?	 { abstruct() }
public func + <T: SDAIGenericType, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T>?					where T.FundamentalType: SDAI__NUMBER__type, U.ELEMENT.FundamentalType: SDAIRealType { abstruct() }
public func + <T: SDAIGenericType, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T>?					where T.FundamentalType: SDAI__REAL__type, U.ELEMENT.FundamentalType: SDAIIntegerType { abstruct() }
public func + <T: SDAIGenericType, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T>?					where T.FundamentalType: SDAI__LOGICAL__type, U.ELEMENT.FundamentalType: SDAIBooleanType { abstruct() }

// List + List = List
public func + <T: SDAIListType, U: SDAIListType>			(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>?	where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }

// List + Element = List
public func + <T: SDAIListType, U: SDAIGenericType>		(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>?	where T.ELEMENT.FundamentalType == U.FundamentalType { abstruct() }
public func + <T: SDAIListType, U: SDAI__GENERIC__type>		(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>?	{ abstruct() }
public func + <T: SDAIListType, U: SDAIGenericType>		(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>?	where T.ELEMENT.FundamentalType: SDAI__NUMBER__type, U.FundamentalType: SDAIRealType { abstruct() }
public func + <T: SDAIListType, U: SDAIGenericType>		(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>?	where T.ELEMENT.FundamentalType: SDAI__REAL__type, U.FundamentalType: SDAIIntegerType { abstruct() }
public func + <T: SDAIListType, U: SDAIGenericType>		(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>?	where T.ELEMENT.FundamentalType: SDAI__LOGICAL__type, U.FundamentalType: SDAIBooleanType { abstruct() }

// Element + List = List
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






//MARK: - Difference operator
// Bag - Bag = Bag
// Bag - Set = Bag
public func - <T: SDAI__BAG__type, U: SDAIBagType>		(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }

// Bag - Element = Bag
public func - <T: SDAI__BAG__type, U: SDAIGenericType>		(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT.FundamentalType == U.FundamentalType { abstruct() }
public func - <T: SDAI__BAG__type, U: SDAI__GENERIC__type>	(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	 { abstruct() }
public func - <T: SDAI__BAG__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT.FundamentalType: SDAI__NUMBER__type, U.FundamentalType: SDAIRealType { abstruct() }
public func - <T: SDAI__BAG__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT.FundamentalType: SDAI__REAL__type, U.FundamentalType: SDAIIntegerType { abstruct() }
public func - <T: SDAI__BAG__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	where T.ELEMENT.FundamentalType: SDAI__LOGICAL__type, U.FundamentalType: SDAIBooleanType { abstruct() }

// Set - Set = Set
// Set - Bag = Set
public func - <T: SDAI__SET__type, U: SDAIBagType>		(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? 	where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }

// Set - Element = Set
public func - <T: SDAI__SET__type, U: SDAIGenericType>		(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	where T.ELEMENT.FundamentalType == U.FundamentalType { abstruct() }
public func - <T: SDAI__SET__type, U: SDAI__GENERIC__type>	(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	 { abstruct() }
public func - <T: SDAI__SET__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	where T.ELEMENT.FundamentalType: SDAI__NUMBER__type, U.FundamentalType: SDAIRealType { abstruct() }
public func - <T: SDAI__SET__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	where T.ELEMENT.FundamentalType: SDAI__REAL__type, U.FundamentalType: SDAIIntegerType { abstruct() }
public func - <T: SDAI__SET__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	where T.ELEMENT.FundamentalType: SDAI__LOGICAL__type, U.FundamentalType: SDAIBooleanType { abstruct() }

// Bag - Aggregate = Bag
public func - <T: SDAIAggregationInitializer, U: SDAI__BAG__type>	(lhs: T?, rhs: U?) -> SDAI.BAG<U.ELEMENT>? 	where T.ELEMENT: SDAIGenericType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }

// Set - Aggregate = Set
public func - <T: SDAI__SET__type, U: SDAIAggregationInitializer>	(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? 	where U.ELEMENT: SDAIGenericType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }






//MARK: - Subset operator
public func <=   <T: SDAIBagType, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }

//MARK: - Superset operator
public func >=   <T: SDAIBagType, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { return rhs <= lhs }
