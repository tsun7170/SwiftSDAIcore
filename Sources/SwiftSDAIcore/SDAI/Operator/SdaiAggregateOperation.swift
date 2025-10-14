//
//  SdaiAggregateOperation.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - Intersection operator (12.6.2)

//MARK: Bag * Bag = Bag
public func * <T: SDAI__BAG__type, U: SDAI__BAG__type>(
	lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.intersectionWith(rhs: rhs)
}

//MARK: Bag * Set = Set
public func * <T: SDAI__BAG__type, U: SDAI__SET__type>(
	lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.intersectionWith(rhs: rhs)
}


//MARK: Set * Set/Bag = Set
public func * <T: SDAI__SET__type, U: SDAIBagType>(
	lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.intersectionWith(rhs: rhs)
}

//MARK: Bag * Aggregate = Bag
public func * <T: SDAI__BAG__type, U: SDAIAggregationInitializer>(
	lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.intersectionWith(rhs: rhs)
}

//MARK: Aggregate * Bag = Bag
public func * <T: SDAIAggregationInitializer, U: SDAI__BAG__type>(
	lhs: T?, rhs: U?) -> SDAI.BAG<U.ELEMENT>?
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.intersectionWith(rhs: lhs)
}

//MARK: Set * Aggregate = Set
public func * <T: SDAI__SET__type, U: SDAIAggregationInitializer>(
	lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.intersectionWith(rhs: rhs)
}

//MARK: Aggregate * Set = Set
public func * <T: SDAIAggregationInitializer, U: SDAI__SET__type>(
	lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>?
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.intersectionWith(rhs: lhs)
}



//MARK: - Union operator (12.6.3)

//MARK: Bag + Bag/Set = Bag
public func + <T: SDAI__BAG__type, U: SDAIBagType>(
	lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

//MARK: Bag + List = Bag
public func + <T: SDAI__BAG__type, U: SDAIListType>(
	lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

//MARK: Bag + Element = Bag
/// BAG<Fundamental> + Fundamental
///
public func + <T: SDAI__BAG__type, U: SDAIGenericType>(
	lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?
where T.ELEMENT.FundamentalType == U.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

/// BAG<Generic> + GENERIC
///
public func + <T: SDAI__BAG__type, U: SDAI__GENERIC__type>(
	lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

/// BAG<NUMBER> + Real
///
public func + <T: SDAI__BAG__type, U>(
	lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?
where T.ELEMENT: SDAI__NUMBER__type,
			U: SDAIRealType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: SDAI.NUMBER(rhs))
}

/// BAG<REAL> + Integer
///
public func + <T: SDAI__BAG__type, U>(
	lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?
where T.ELEMENT: SDAI__REAL__type,
			U: SDAIIntegerType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: SDAI.REAL(rhs))
}

/// BAG<LOGICAL> + Boolean
///
public func + <T: SDAI__BAG__type, U>(
	lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?
where T.ELEMENT: SDAI__LOGICAL__type,
			U: SDAIBooleanType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: SDAI.LOGICAL(rhs))
}

/// BAG<Complex> + Complex
///
public func + <T: SDAI__BAG__type>(
	lhs: T?, rhs: SDAI.ComplexEntity?) -> SDAI.BAG<T.ELEMENT>?
where T.ELEMENT: InitializableByComplexEntity
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

/// BAG<Entity> + Select
///
public func + <T: SDAI__BAG__type, U: SDAISelectType>(
	lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?
where T.ELEMENT: SDAI.EntityReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

/// BAG<PRef> + Select
///
public func + <T: SDAI__BAG__type, U: SDAISelectType>(
	lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?
where T.ELEMENT: SDAIPersistentReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

//MARK: Element + Bag = Bag
/// Fundamental + BAG<Fundamental>
///
public func + <T: SDAIGenericType, U: SDAI__BAG__type>(
	lhs: T?, rhs: U?) -> SDAI.BAG<U.ELEMENT>?
where T.FundamentalType == U.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

/// GENERIC + BAG<Generic>
///
public func + <T: SDAI__GENERIC__type, U: SDAI__BAG__type>	(
	lhs: T?, rhs: U?) -> SDAI.BAG<U.ELEMENT>?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

/// Real + BAG<NUMBER>
///
public func + <T, U: SDAI__BAG__type>(
	lhs: T?, rhs: U?) -> SDAI.BAG<U.ELEMENT>?
where T: SDAIRealType,
			U.ELEMENT: SDAI__NUMBER__type
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: SDAI.NUMBER(lhs))
}

/// Integer + BAG<REAL>
///
public func + <T, U: SDAI__BAG__type>(
	lhs: T?, rhs: U?) -> SDAI.BAG<U.ELEMENT>?
where T: SDAIIntegerType,
			U.ELEMENT: SDAI__REAL__type
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: SDAI.REAL(lhs))
}

/// Boolean + BAG<LOGICAL>
///
public func + <T, U: SDAI__BAG__type>(
	lhs: T?, rhs: U?) -> SDAI.BAG<U.ELEMENT>?
where T: SDAIBooleanType,
			U.ELEMENT: SDAI__LOGICAL__type
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: SDAI.LOGICAL(lhs))
}

/// Complex + BAG<Complex>
///
public func + <U: SDAI__BAG__type>(
	lhs: SDAI.ComplexEntity?, rhs: U?) -> SDAI.BAG<U.ELEMENT>?
where U.ELEMENT: InitializableByComplexEntity
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

/// Select + BAG<Entity>
///
public func + <T: SDAISelectType, U: SDAI__BAG__type>(
	lhs: T?, rhs: U?) -> SDAI.BAG<U.ELEMENT>?
where U.ELEMENT: SDAI.EntityReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

/// Select + BAG<PRef>
///
public func + <T: SDAISelectType, U: SDAI__BAG__type>(
	lhs: T?, rhs: U?) -> SDAI.BAG<U.ELEMENT>?
where U.ELEMENT: SDAIPersistentReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

//MARK:  Set + Set/Bag = Set
public func + <T: SDAI__SET__type, U: SDAIBagType>(
	lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

//MARK: Set + List = Set
public func + <T: SDAI__SET__type, U: SDAIListType>(
	lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}



//MARK: Set + Element = Set

/// SET<Fundamental> + Fundamental
///
public func + <T: SDAI__SET__type, U: SDAIGenericType>(
	lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?
where T.ELEMENT.FundamentalType == U.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

/// SET<Generic> + GENERIC
///
public func + <T: SDAI__SET__type, U: SDAI__GENERIC__type>(
	lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

/// SET<NUMBER> + Real
///
public func + <T: SDAI__SET__type, U>(
	lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?
where T.ELEMENT: SDAI__NUMBER__type,
			U: SDAIRealType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: SDAI.NUMBER(rhs))
}

/// SET<NUMBER> + Integer
///
public func + <T: SDAI__SET__type, U>(
	lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?
where T.ELEMENT: SDAI__REAL__type,
			U: SDAIIntegerType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: SDAI.REAL(rhs))
}

/// SET<LOGICAL> + Boolean
///
public func + <T: SDAI__SET__type, U>(
	lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?
where T.ELEMENT: SDAI__LOGICAL__type,
			U: SDAIBooleanType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: SDAI.LOGICAL(rhs))
}

/// SET<Complex> + Complex
///
public func + <T: SDAI__SET__type>(
	lhs: T?, rhs: SDAI.ComplexEntity?) -> SDAI.SET<T.ELEMENT>?
where T.ELEMENT: InitializableByComplexEntity
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

/// SET<Entity> + Select
///
public func + <T: SDAI__SET__type, U: SDAISelectType>(
	lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?
where T.ELEMENT: SDAI.EntityReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

/// SET<PRef> + Select
///
public func + <T: SDAI__SET__type, U: SDAISelectType>(
	lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?
where T.ELEMENT: SDAIPersistentReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

//MARK: Element + Set = Set
/// Fundamental + SET<Fundamental>
///
public func + <T: SDAIGenericType, U: SDAI__SET__type>(
	lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>?
where T.FundamentalType == U.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

/// GENERIC + SET<Generic>
///
public func + <T: SDAI__GENERIC__type, U: SDAI__SET__type>(
	lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

/// Real + SET<NUMBER>
///
public func + <T, U: SDAI__SET__type>(
	lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>?
where T: SDAIRealType,
			U.ELEMENT: SDAI__NUMBER__type
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: SDAI.NUMBER(lhs))
}

/// Integer + SET<REAL>
///
public func + <T, U: SDAI__SET__type>(
	lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>?
where T: SDAIIntegerType,
			U.ELEMENT: SDAI__REAL__type
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: SDAI.REAL(lhs))
}

/// Boolean + SET<LOGICAL>
///
public func + <T, U: SDAI__SET__type>(
	lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>?
where T: SDAIBooleanType,
			U.ELEMENT: SDAI__LOGICAL__type
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: SDAI.LOGICAL(lhs))
}

/// Complex + SET<Complex>
///
public func + <U: SDAI__SET__type>(
	lhs: SDAI.ComplexEntity?, rhs: U?) -> SDAI.SET<U.ELEMENT>?
where U.ELEMENT: InitializableByComplexEntity
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

/// Select + SET<Entity>
///
public func + <T: SDAISelectType, U: SDAI__SET__type>(
	lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>?
where U.ELEMENT: SDAI.EntityReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

/// Select + SET<PRef>
///
public func + <T: SDAISelectType, U: SDAI__SET__type>(
	lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>?
where U.ELEMENT: SDAIPersistentReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

//MARK: List + List = List
public func + <T: SDAI__LIST__type, U: SDAIListType>(
	lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>?
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: rhs)
}

//MARK: List + Element = List
/// LIST<Fundamental> + Fundamental
///
public func + <T: SDAI__LIST__type, U: SDAIGenericType>(
	lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>?
where T.ELEMENT.FundamentalType == U.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: rhs)
}

/// LIST<Generic> + GENERIC
///
public func + <T: SDAI__LIST__type, U: SDAI__GENERIC__type>(
	lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: rhs)
}

/// LIST<NUMBER> + Real
///
public func + <T: SDAI__LIST__type, U>(
	lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>?
where T.ELEMENT: SDAI__NUMBER__type,
			U: SDAIRealType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: SDAI.NUMBER(rhs))
}

/// LIST<REAL> + Integer
///
public func + <T: SDAI__LIST__type, U>(
	lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>?
where T.ELEMENT: SDAI__REAL__type,
			U: SDAIIntegerType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: SDAI.REAL(rhs))
}

/// LIST<LOGICAL> + Boolean
///
public func + <T: SDAI__LIST__type, U>(
	lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>?
where T.ELEMENT: SDAI__LOGICAL__type,
			U: SDAIBooleanType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: SDAI.LOGICAL(rhs))
}

/// LIST<Complex> + Complex
///
public func + <T: SDAI__LIST__type>(
	lhs: T?, rhs: SDAI.ComplexEntity?) -> SDAI.LIST<T.ELEMENT>?
where T.ELEMENT: InitializableByComplexEntity
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: rhs)
}

/// LIST<Entity> + Select
///
public func + <T: SDAI__LIST__type, U: SDAISelectType>(
	lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>?
where T.ELEMENT: SDAI.EntityReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: rhs)
}

/// LIST<PRef> + Select
///
public func + <T: SDAI__LIST__type, U: SDAISelectType>(
	lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>?
where T.ELEMENT: SDAIPersistentReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: rhs)
}

//MARK: Element + List = List
/// Fundamental + LIST<Fundamental>
///
public func + <T: SDAIGenericType, U: SDAI__LIST__type>(
	lhs: T?, rhs: U?) -> SDAI.LIST<U.ELEMENT>?
where T.FundamentalType == U.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: lhs)
}

/// GENERIC + LIST<Generic>
///
public func + <T: SDAI__GENERIC__type, U: SDAI__LIST__type>(
	lhs: T?, rhs: U?) -> SDAI.LIST<U.ELEMENT>?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: lhs)
}

/// Real + LIST<NUMBER>
///
public func + <T, U: SDAI__LIST__type>(
	lhs: T?, rhs: U?) -> SDAI.LIST<U.ELEMENT>?
where T: SDAIRealType,
			U.ELEMENT: SDAI__NUMBER__type
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: SDAI.NUMBER(lhs))
}

/// Integer + LIST<REAL>
///
public func + <T, U: SDAI__LIST__type>(
	lhs: T?, rhs: U?) -> SDAI.LIST<U.ELEMENT>?
where T: SDAIIntegerType,
			U.ELEMENT: SDAI__REAL__type
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: SDAI.REAL(lhs))
}

/// Boolean + LIST<LOGICAL>
///
public func + <T, U: SDAI__LIST__type>(
	lhs: T?, rhs: U?) -> SDAI.LIST<U.ELEMENT>?
where T: SDAIBooleanType,
			U.ELEMENT: SDAI__LOGICAL__type
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: SDAI.LOGICAL(lhs))
}

/// Complex + LIST<Complex>
///
public func + <U: SDAI__LIST__type>(
	lhs: SDAI.ComplexEntity?, rhs: U?) -> SDAI.LIST<U.ELEMENT>?
where U.ELEMENT: InitializableByComplexEntity
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: lhs)
}

/// Select + LIST<Entity>
///
public func + <T: SDAISelectType, U: SDAI__LIST__type>(
	lhs: T?, rhs: U?) -> SDAI.LIST<U.ELEMENT>?
where U.ELEMENT: SDAI.EntityReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: lhs)
}

/// Select + LIST<PRef>
///
public func + <T: SDAISelectType, U: SDAI__LIST__type>(
	lhs: T?, rhs: U?) -> SDAI.LIST<U.ELEMENT>?
where U.ELEMENT: SDAIPersistentReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: lhs)
}

//MARK: Bag + Aggregate = Bag
public func + <T: SDAI__BAG__type, U: SDAIAggregationInitializer>(
	lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

//MARK: Aggregate + Bag = Bag
public func + <T: SDAIAggregationInitializer, U: SDAI__BAG__type>(
	lhs: T?, rhs: U?) -> SDAI.BAG<U.ELEMENT>?
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

//MARK: Set + Aggregate = Set
public func + <T: SDAI__SET__type, U: SDAIAggregationInitializer>(
	lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

//MARK: Aggregate + Set = Set
public func + <T: SDAIAggregationInitializer, U: SDAI__SET__type>(
	lhs: T?, rhs: U?) -> SDAI.SET<U.ELEMENT>?
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

//MARK: List + Aggregate = List
public func + <T: SDAI__LIST__type, U: SDAIAggregationInitializer>(
	lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>?
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: rhs)
}

//MARK: Aggregate + List = List
public func + <T: SDAIAggregationInitializer, U: SDAI__LIST__type>(
	lhs: T?, rhs: U?) -> SDAI.LIST<U.ELEMENT>?
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: lhs)
}






//MARK: - Difference operator (12.6.4)

//MARK: Bag - Bag/Set = Bag
public func - <T: SDAI__BAG__type, U: SDAIBagType>(
	lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

//MARK: Bag - Element = Bag
/// BAG<Fundamental> - Fundamental
///
public func - <T: SDAI__BAG__type, U: SDAIGenericType>(
	lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?
where T.ELEMENT.FundamentalType == U.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

/// BAG<Generic> - GENERIC
///
public func - <T: SDAI__BAG__type, U: SDAI__GENERIC__type>(
	lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

/// BAG<NUMBER> - Real
///
public func - <T: SDAI__BAG__type, U>(
	lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?
where T.ELEMENT: SDAI__NUMBER__type,
			U: SDAIRealType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: SDAI.NUMBER(rhs))
}

/// BAG<REAL> - Integer
///
public func - <T: SDAI__BAG__type, U>(
	lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?
where T.ELEMENT: SDAI__REAL__type,
			U: SDAIIntegerType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: SDAI.REAL(rhs))
}

/// BAG<LOGICAL> - Boolean
///
public func - <T: SDAI__BAG__type, U>(
	lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?
where T.ELEMENT: SDAI__LOGICAL__type,
			U: SDAIBooleanType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: SDAI.LOGICAL(rhs))
}

/// BAG<Complex> - Complex
///
public func - <T: SDAI__BAG__type>(
	lhs: T?, rhs: SDAI.ComplexEntity?) -> SDAI.BAG<T.ELEMENT>?
where T.ELEMENT: InitializableByComplexEntity
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

/// BAG<Entity> - Select
///
public func - <T: SDAI__BAG__type, U: SDAISelectType>(
	lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?
where T.ELEMENT: SDAI.EntityReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

/// BAG<PRef> - Select
///
public func - <T: SDAI__BAG__type, U: SDAISelectType>(
	lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?
where T.ELEMENT: SDAIPersistentReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}


//MARK: Set - Set/Bag = Set
public func - <T: SDAI__SET__type, U: SDAIBagType>(
	lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

//MARK: Set - Element = Set
/// SET<Fundamental> - Fundamental
///
public func - <T: SDAI__SET__type, U: SDAIGenericType>(
	lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?
where T.ELEMENT.FundamentalType == U.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

/// SET<Generic> - GENERIC
///
public func - <T: SDAI__SET__type, U: SDAI__GENERIC__type>(
	lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

/// SET<NUMBER> - Real
///
public func - <T: SDAI__SET__type, U>(
	lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?
where T.ELEMENT: SDAI__NUMBER__type,
			U: SDAIRealType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: SDAI.NUMBER(rhs))
}

/// SET<REAL> - Integer
///
public func - <T: SDAI__SET__type, U>(
	lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?
where T.ELEMENT: SDAI__REAL__type,
			U: SDAIIntegerType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: SDAI.REAL(rhs))
}

/// SET<LOGICL> - Boolean
///
public func - <T: SDAI__SET__type, U>(
	lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?
where T.ELEMENT: SDAI__LOGICAL__type,
			U: SDAIBooleanType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: SDAI.LOGICAL(rhs))
}

/// SET<Complex> - Complex
///
public func - <T: SDAI__SET__type>(
	lhs: T?, rhs: SDAI.ComplexEntity?) -> SDAI.SET<T.ELEMENT>?
where T.ELEMENT: InitializableByComplexEntity
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

/// SET<Entity> - Select
///
public func - <T: SDAI__SET__type, U: SDAISelectType>(
	lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?
where T.ELEMENT: SDAI.EntityReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

/// SET<PRef> - Select
///
public func - <T: SDAI__SET__type, U: SDAISelectType>(
	lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?
where T.ELEMENT: SDAIPersistentReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}


//MARK: Bag - Aggregate = Bag
public func - <T: SDAI__BAG__type, U: SDAIAggregationInitializer>(
	lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>?
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

//MARK: Set - Aggregate = Set
public func - <T: SDAI__SET__type, U: SDAIAggregationInitializer>	(
	lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>?
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}



//MARK: - Subset operator (12.6.5)
public func <= <T: SDAIBagType, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { 
	return rhs >= lhs
}

//MARK: - Superset operator (12.6.6)
public func >= <T: SDAIBagType, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { 
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	return SDAI.LOGICAL(lhs.isSuperset(of: rhs))
}
