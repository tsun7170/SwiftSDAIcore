//
//  SdaiAggregateOperation.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK:  Intersection operator (12.6.2)
// Bag * Bag = Bag
public func * <T: SDAI__BAG__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.intersectionWith(rhs: rhs)
}

// Bag * Set = Set
public func * <T: SDAI__BAG__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.intersectionWith(rhs: rhs)
}


// Set * Set = Set
// Set * Bag = Set
public func * <T: SDAI__SET__type, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.intersectionWith(rhs: rhs)
}

// Bag * Aggregate = Bag
public func * <T: SDAI__BAG__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? 	
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.intersectionWith(rhs: rhs)
}

// Aggregate * Bag = Bag
public func * <T: SDAIAggregationInitializer, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<U.ELEMENT>? 	
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.intersectionWith(rhs: lhs)
}

// Set * Aggregate = Set
public func * <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? 	
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.intersectionWith(rhs: rhs)
}

// Aggregate * Set = Set
public func * <T: SDAIAggregationInitializer, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? 	
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.intersectionWith(rhs: lhs)
}



//MARK: - Union operator (12.6.3)
// Bag + Bag = Bag
// Bag + Set = Bag
public func + <T: SDAI__BAG__type, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

// Bag + List = Bag
public func + <T: SDAI__BAG__type, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

// Bag + Element = Bag
public func + <T: SDAI__BAG__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	
where T.ELEMENT.FundamentalType == U.FundamentalType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}
public func + <T: SDAI__BAG__type, U: SDAI__GENERIC__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}
public func + <T: SDAI__BAG__type, U>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	
where T.ELEMENT: SDAI__NUMBER__type, 
			U: SDAIRealType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: SDAI.NUMBER(rhs))
}
public func + <T: SDAI__BAG__type, U>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	
where T.ELEMENT: SDAI__REAL__type, 
			U: SDAIIntegerType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: SDAI.REAL(rhs))
}
public func + <T: SDAI__BAG__type, U>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	
where T.ELEMENT: SDAI__LOGICAL__type, 
			U: SDAIBooleanType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: SDAI.LOGICAL(rhs))
}
public func + <T: SDAI__BAG__type>(lhs: T?, rhs: SDAI.ComplexEntity?) -> SDAI.BAG<T.ELEMENT>?
where T.ELEMENT: InitializableByEntity {
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}
public func + <T: SDAI__BAG__type, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?
where T.ELEMENT: SDAI.EntityReference {
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

// Element + Bag = Bag
public func + <T: SDAIGenericType, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<U.ELEMENT>?					
where T.FundamentalType == U.ELEMENT.FundamentalType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}
public func + <T: SDAI__GENERIC__type, U: SDAI__BAG__type>	(lhs: T?, rhs: U?) -> SDAI.BAG<U.ELEMENT>? { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}
public func + <T, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<U.ELEMENT>?					
where T: SDAIRealType, 
			U.ELEMENT: SDAI__NUMBER__type { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: SDAI.NUMBER(lhs))
}
public func + <T, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<U.ELEMENT>?					
where T: SDAIIntegerType, 
			U.ELEMENT: SDAI__REAL__type { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: SDAI.REAL(lhs))
}
public func + <T, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<U.ELEMENT>?					
where T: SDAIBooleanType, 
			U.ELEMENT: SDAI__LOGICAL__type { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: SDAI.LOGICAL(lhs))
}
public func + <U: SDAI__BAG__type>(lhs: SDAI.ComplexEntity?, rhs: U?) -> SDAI.BAG<U.ELEMENT>?
where U.ELEMENT: InitializableByEntity {
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}
public func + <T: SDAISelectType, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<U.ELEMENT>?
where U.ELEMENT: SDAI.EntityReference {
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

// Set + Set = Set
// Set + Bag = Set
public func + <T: SDAI__SET__type, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? 	
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

// Set + List = Set
public func + <T: SDAI__SET__type, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

// Set + Element = Set
public func + <T: SDAI__SET__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	
where T.ELEMENT.FundamentalType == U.FundamentalType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}
public func + <T: SDAI__SET__type, U: SDAI__GENERIC__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}
public func + <T: SDAI__SET__type, U>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	
where T.ELEMENT: SDAI__NUMBER__type, 
			U: SDAIRealType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: SDAI.NUMBER(rhs))
}
public func + <T: SDAI__SET__type, U>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	
where T.ELEMENT: SDAI__REAL__type, 
			U: SDAIIntegerType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: SDAI.REAL(rhs))
}
public func + <T: SDAI__SET__type, U>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	
where T.ELEMENT: SDAI__LOGICAL__type, 
			U: SDAIBooleanType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: SDAI.LOGICAL(rhs))
}
public func + <T: SDAI__SET__type>(lhs: T?, rhs: SDAI.ComplexEntity?) -> SDAI.SET<T.ELEMENT>?
where T.ELEMENT: InitializableByEntity {
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}
public func + <T: SDAI__SET__type, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?
where T.ELEMENT: SDAI.EntityReference {
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

// Element + Set = Set
public func + <T: SDAIGenericType, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>?	
where T.FundamentalType == U.ELEMENT.FundamentalType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}
public func + <T: SDAI__GENERIC__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}
public func + <T, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>?					
where T: SDAIRealType, 
			U.ELEMENT: SDAI__NUMBER__type { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: SDAI.NUMBER(lhs))
}
public func + <T, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>?					
where T: SDAIIntegerType, 
			U.ELEMENT: SDAI__REAL__type { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: SDAI.REAL(lhs))
}
public func + <T, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>?			
where T: SDAIBooleanType, 
			U.ELEMENT: SDAI__LOGICAL__type { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: SDAI.LOGICAL(lhs))
}
public func + <U: SDAI__SET__type>(lhs: SDAI.ComplexEntity?, rhs: U?) -> SDAI.SET<U.ELEMENT>?
where U.ELEMENT: InitializableByEntity {
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}
public func + <T: SDAISelectType, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>?
where U.ELEMENT: SDAI.EntityReference {
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

// List + List = List
public func + <T: SDAI__LIST__type, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>?	
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: rhs)
}

// List + Element = List
public func + <T: SDAI__LIST__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>?	
where T.ELEMENT.FundamentalType == U.FundamentalType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: rhs)
}
public func + <T: SDAI__LIST__type, U: SDAI__GENERIC__type>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>? { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: rhs)
}
public func + <T: SDAI__LIST__type, U>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>?	
where T.ELEMENT: SDAI__NUMBER__type, 
			U: SDAIRealType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: SDAI.NUMBER(rhs))
}
public func + <T: SDAI__LIST__type, U>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>?	
where T.ELEMENT: SDAI__REAL__type, 
			U: SDAIIntegerType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: SDAI.REAL(rhs))
}
public func + <T: SDAI__LIST__type, U>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>?	
where T.ELEMENT: SDAI__LOGICAL__type, 
			U: SDAIBooleanType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: SDAI.LOGICAL(rhs))
}
public func + <T: SDAI__LIST__type>(lhs: T?, rhs: SDAI.ComplexEntity?) -> SDAI.LIST<T.ELEMENT>?
where T.ELEMENT: InitializableByEntity {
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: rhs)
}
public func + <T: SDAI__LIST__type, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>?
where T.ELEMENT: SDAI.EntityReference {
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: rhs)
}

// Element + List = List
public func + <T: SDAIGenericType, U: SDAI__LIST__type>(lhs: T?, rhs: U?) -> SDAI.LIST<U.ELEMENT>?	
where T.FundamentalType == U.ELEMENT.FundamentalType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: lhs)
}
public func + <T: SDAI__GENERIC__type, U: SDAI__LIST__type>(lhs: T?, rhs: U?) -> SDAI.LIST<U.ELEMENT>? { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: lhs)
}
public func + <T, U: SDAI__LIST__type>(lhs: T?, rhs: U?) -> SDAI.LIST<U.ELEMENT>?	
where T: SDAIRealType, 
			U.ELEMENT: SDAI__NUMBER__type { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: SDAI.NUMBER(lhs))
}
public func + <T, U: SDAI__LIST__type>(lhs: T?, rhs: U?) -> SDAI.LIST<U.ELEMENT>?		
where T: SDAIIntegerType, 
			U.ELEMENT: SDAI__REAL__type { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: SDAI.REAL(lhs))
}
public func + <T, U: SDAI__LIST__type>(lhs: T?, rhs: U?) -> SDAI.LIST<U.ELEMENT>?	
where T: SDAIBooleanType, 
			U.ELEMENT: SDAI__LOGICAL__type { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: SDAI.LOGICAL(lhs))
}
public func + <U: SDAI__LIST__type>(lhs: SDAI.ComplexEntity?, rhs: U?) -> SDAI.LIST<U.ELEMENT>?
where U.ELEMENT: InitializableByEntity {
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: lhs)
}
public func + <T: SDAISelectType, U: SDAI__LIST__type>(lhs: T?, rhs: U?) -> SDAI.LIST<U.ELEMENT>?
where U.ELEMENT: SDAI.EntityReference {
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: lhs)
}

// Bag + Aggregate = Bag
public func + <T: SDAI__BAG__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? 	
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

// Aggregate + Bag = Bag
public func + <T: SDAIAggregationInitializer, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<U.ELEMENT>? 	
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

// Set + Aggregate = Set
public func + <T: SDAI__SET__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? 	
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

// Aggregate + Set = Set
public func + <T: SDAIAggregationInitializer, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>? 	
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

// List + Aggregate = List
public func + <T: SDAI__LIST__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>?	
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: rhs)
}

// Aggregate + List = List
public func + <T: SDAIAggregationInitializer, U: SDAI__LIST__type>(lhs: T?, rhs: U?) -> SDAI.LIST<U.ELEMENT>?	
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: lhs)
}






//MARK: - Difference operator (12.6.4)
// Bag - Bag = Bag
// Bag - Set = Bag
public func - <T: SDAI__BAG__type, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

// Bag - Element = Bag
public func - <T: SDAI__BAG__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	
where T.ELEMENT.FundamentalType == U.FundamentalType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}
public func - <T: SDAI__BAG__type, U: SDAI__GENERIC__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	 { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}
public func - <T: SDAI__BAG__type, U>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	
where T.ELEMENT: SDAI__NUMBER__type, 
			U: SDAIRealType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: SDAI.NUMBER(rhs))
}
public func - <T: SDAI__BAG__type, U>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	
where T.ELEMENT: SDAI__REAL__type, 
			U: SDAIIntegerType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: SDAI.REAL(rhs))
}
public func - <T: SDAI__BAG__type, U>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?	
where T.ELEMENT: SDAI__LOGICAL__type, 
			U: SDAIBooleanType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: SDAI.LOGICAL(rhs))
}
public func - <T: SDAI__BAG__type>(lhs: T?, rhs: SDAI.ComplexEntity?) -> SDAI.BAG<T.ELEMENT>?
where T.ELEMENT: InitializableByEntity {
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}
public func - <T: SDAI__BAG__type, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?
where T.ELEMENT: SDAI.EntityReference {
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

// Set - Set = Set
// Set - Bag = Set
public func - <T: SDAI__SET__type, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? 	
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

// Set - Element = Set
public func - <T: SDAI__SET__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	
where T.ELEMENT.FundamentalType == U.FundamentalType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}
public func - <T: SDAI__SET__type, U: SDAI__GENERIC__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}
public func - <T: SDAI__SET__type, U>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	
where T.ELEMENT: SDAI__NUMBER__type, 
			U: SDAIRealType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: SDAI.NUMBER(rhs))
}
public func - <T: SDAI__SET__type, U>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	
where T.ELEMENT: SDAI__REAL__type, 
			U: SDAIIntegerType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: SDAI.REAL(rhs))
}
public func - <T: SDAI__SET__type, U>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?	
where T.ELEMENT: SDAI__LOGICAL__type, 
			U: SDAIBooleanType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: SDAI.LOGICAL(rhs))
}
public func - <T: SDAI__SET__type>(lhs: T?, rhs: SDAI.ComplexEntity?) -> SDAI.SET<T.ELEMENT>?
where T.ELEMENT: InitializableByEntity {
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}
public func - <T: SDAI__SET__type, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?
where T.ELEMENT: SDAI.EntityReference {
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

// Bag - Aggregate = Bag
public func - <T: SDAI__BAG__type, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? 	
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

// Set - Aggregate = Set
public func - <T: SDAI__SET__type, U: SDAIAggregationInitializer>	(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? 	
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}






//MARK: - Subset operator (12.6.5)
public func <=   <T: SDAIBagType, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL 
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { 
	return rhs >= lhs
}

//MARK: - Superset operator (12.6.6)
public func >=   <T: SDAIBagType, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL 
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { 
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	return SDAI.LOGICAL(lhs.isSuperset(of: rhs))
}
