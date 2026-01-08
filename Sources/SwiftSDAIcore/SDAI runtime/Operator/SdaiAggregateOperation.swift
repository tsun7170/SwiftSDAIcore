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
/// Bag * Bag = Bag
/// 
/// Computes the intersection of two aggregate values, returning a new aggregate containing only the elements common to both operands.
/// 
/// - Parameters:
///   - lhs: The left-hand side operand, an optional aggregate conforming to `SDAI__BAG__type`.
///   - rhs: The right-hand side operand, an optional aggregate conforming to `SDAI__BAG__type`.
/// - Returns: A new `SDAI.BAG` containing the intersection of elements from both `lhs` and `rhs`, or `nil` if either operand is `nil`.
/// - Note: The element types of the operands must have the same `FundamentalType`.
/// - Discussion: This operator implements the intersection operation as described in section 12.6.2 of the formal specification. It may be overloaded for other aggregate type combinations as defined by the standard.
public func * <T1: SDAI__BAG__type, U1: SDAI__BAG__type>(
	lhs: T1?, rhs: U1?) -> SDAI.BAG<T1.ELEMENT>?
where T1.ELEMENT.FundamentalType == U1.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.intersectionWith(rhs: rhs)
}

//MARK: Bag * Set = Set
/// Bag * Set = Set
/// 
/// Computes the intersection of two aggregate values, returning a new aggregate that contains only the elements common to both operands.
/// 
/// This operator implements the intersection operation between two aggregate types as described in section 12.6.2 of the formal specification. 
/// It is applicable to combinations of `BAG`, `SET`, and general aggregate types, depending on the types of the operands.
/// 
/// - Parameters:
///   - lhs: The left-hand side operand, an optional aggregate conforming to an appropriate SDAI aggregate protocol.
///   - rhs: The right-hand side operand, an optional aggregate conforming to an appropriate SDAI aggregate protocol.
/// - Returns: A new aggregate containing the intersection of elements from both `lhs` and `rhs`, or `nil` if either operand is `nil`.
/// - Note: The element types of the operands must have the same `FundamentalType`.
/// - Discussion: The result type depends on the operand types, for example, `BAG * BAG` yields a `BAG`, while `SET * BAG` yields a `SET`.
public func * <T2: SDAI__BAG__type, U2: SDAI__SET__type>(
	lhs: T2?, rhs: U2?) -> SDAI.SET<T2.ELEMENT>?
where T2.ELEMENT.FundamentalType == U2.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.intersectionWith(rhs: rhs)
}


//MARK: Set * Set/Bag = Set
/// Set * Set/Bag = Set
///
/// Computes the intersection of two sets or a set and a bag, returning a new `SDAI.SET` containing only the elements common to both operands.
/// 
/// - Parameters:
///   - lhs: The left-hand side operand, an optional aggregate conforming to `SDAI__SET__type`.
///   - rhs: The right-hand side operand, an optional aggregate conforming to `SDAIBagType`.
/// - Returns: A new `SDAI.SET` containing the intersection of elements from both `lhs` and `rhs`, or `nil` if either operand is `nil`.
/// - Note: The element types of the operands must have the same `FundamentalType`.
/// - Discussion: This operator implements the intersection operation (as described in section 12.6.2 of the formal specification) between a `SET` and either another `SET` or a `BAG`. The result type is always a `SET`.
public func * <T3: SDAI__SET__type, U3: SDAIBagType>(
	lhs: T3?, rhs: U3?) -> SDAI.SET<T3.ELEMENT>?
where T3.ELEMENT.FundamentalType == U3.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.intersectionWith(rhs: rhs)
}

//MARK: Bag * Aggregate = Bag
/// Bag * Aggregate = Bag
///
/// Computes the intersection of two optional aggregates conforming to `SDAI__BAG__type`, returning a new `SDAI.BAG` containing only the elements common to both operands.
/// 
/// - Parameters:
///   - lhs: The left-hand side operand, an optional aggregate conforming to `SDAI__BAG__type`.
///   - rhs: The right-hand side operand, an optional aggregate initializer conforming to `SDAIAggregationInitializer`.
/// - Returns: A new `SDAI.BAG` containing the intersection of elements from both `lhs` and `rhs`, or `nil` if either operand is `nil`.
/// - Note: The element types of the operands must have the same `FundamentalType`.
/// - Discussion: This operator implements the intersection operation as described in section 12.6.2 of the formal specification. It may be overloaded for other aggregate type combinations as defined by the standard.
public func * <T4: SDAI__BAG__type, U4: SDAIAggregationInitializer>(
	lhs: T4?, rhs: U4?) -> SDAI.BAG<T4.ELEMENT>?
where T4.ELEMENT.FundamentalType == U4.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.intersectionWith(rhs: rhs)
}

//MARK: Aggregate * Bag = Bag
/// Aggregate * Bag = Bag
///
/// Computes the intersection of two aggregate values, returning a new aggregate containing only the elements common to both operands.
///
/// - Parameters:
///   - lhs: The left-hand side operand, an optional aggregate conforming to `SDAIAggregationInitializer`.
///   - rhs: The right-hand side operand, an optional aggregate conforming to `SDAI__BAG__type` aggregate protocol.
/// - Returns: A new aggregate containing the intersection of elements from both `lhs` and `rhs`, or `nil` if either operand is `nil`.
/// - Note: The element types of the operands must have the same `FundamentalType`.
/// - Discussion: This operator implements the intersection operation as described in section 12.6.2 of the formal specification, for aggregate types that include aggregation initializers.
public func * <T5: SDAIAggregationInitializer, U5: SDAI__BAG__type>(
	lhs: T5?, rhs: U5?) -> SDAI.BAG<U5.ELEMENT>?
where T5.ELEMENT.FundamentalType == U5.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.intersectionWith(rhs: lhs)
}

//MARK: Set * Aggregate = Set
/// Set * Aggregate = Set
///
/// Computes the intersection of two aggregate values, returning a new aggregate containing only the elements common to both operands.
/// 
/// This operator implements the intersection operation between two aggregate types as described in section 12.6.2 of the formal specification.
/// It is applicable to combinations of `BAG`, `SET`, and general aggregate types, depending on the types of the operands.
/// 
/// - Parameters:
///   - lhs: The left-hand side operand, an optional aggregate conforming to `SDAI__SET__type`.
///   - rhs: The right-hand side operand, an optional aggregate conforming to `SDAIAggregationInitializer`.
/// - Returns: A new `SDAI.SET` containing the intersection of elements from both `lhs` and `rhs`, or `nil` if either operand is `nil`.
/// - Note: The element types of the operands must have the same `FundamentalType`.
/// - Discussion: The result type is always a `SET`, as defined by the standard, for the intersection of a set and either another `SET` or a `BAG`.
public func * <T6: SDAI__SET__type, U6: SDAIAggregationInitializer>(
	lhs: T6?, rhs: U6?) -> SDAI.SET<T6.ELEMENT>?
where T6.ELEMENT.FundamentalType == U6.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.intersectionWith(rhs: rhs)
}

//MARK: Aggregate * Set = Set
/// Aggregate * Set = Set
///
/// Computes the intersection of two aggregate values, returning a new aggregate containing only the elements common to both operands.
///
/// This operator performs the intersection operation as described in section 12.6.2 of the formal specification. 
/// It is applicable to combinations of `BAG`, `SET`, and general aggregate types, depending on the types of the operands.
/// 
/// - Parameters:
///   - lhs: The left-hand side operand, an optional aggregate conforming to `SDAIAggregationInitializer`.
///   - rhs: The right-hand side operand, an optional aggregate conforming to `SDAI__SET__type`.
/// - Returns: A new aggregate containing the intersection of elements from both `lhs` and `rhs`, or `nil` if either operand is `nil`.
/// - Note: The element types of the operands must have the same `FundamentalType`.
/// - Discussion: The result type depends on the operand types, as defined by the standard. For example, the intersection of a `SET` and another aggregate yields a `SET`, while other combinations may yield different types.
public func * <T7: SDAIAggregationInitializer, U7: SDAI__SET__type>(
	lhs: T7?, rhs: U7?) -> SDAI.SET<U7.ELEMENT>?
where T7.ELEMENT.FundamentalType == U7.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.intersectionWith(rhs: lhs)
}



//MARK: - Union operator (12.6.3)

//MARK: Bag + Bag/Set = Bag
/// Bag + Bag/Set = Bag
///
public func + <T1: SDAI__BAG__type, U1: SDAIBagType>(
	lhs: T1?, rhs: U1?) -> SDAI.BAG<T1.ELEMENT>?
where T1.ELEMENT.FundamentalType == U1.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

//MARK: Bag + List = Bag
/// Bag + List = Bag
///
public func + <T2: SDAI__BAG__type, U2: SDAIListType>(
	lhs: T2?, rhs: U2?) -> SDAI.BAG<T2.ELEMENT>?
where T2.ELEMENT.FundamentalType == U2.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

//MARK: Bag + Element = Bag
/// BAG<Fundamental> + Fundamental = Bag
///
public func + <T3: SDAI__BAG__type, U3: SDAIGenericType>(
	lhs: T3?, rhs: U3?) -> SDAI.BAG<T3.ELEMENT>?
where T3.ELEMENT.FundamentalType == U3.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

/// BAG<Generic> + GENERIC = Bag
///
public func + <T4: SDAI__BAG__type, U4: SDAI__GENERIC__type>(
	lhs: T4?, rhs: U4?) -> SDAI.BAG<T4.ELEMENT>?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

/// BAG<NUMBER> + Real = Bag
///
public func + <T5: SDAI__BAG__type, U5>(
	lhs: T5?, rhs: U5?) -> SDAI.BAG<T5.ELEMENT>?
where T5.ELEMENT: SDAI__NUMBER__type,
			U5: SDAIRealType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: SDAI.NUMBER(rhs))
}

/// BAG<REAL> + Integer = Bag
///
public func + <T6: SDAI__BAG__type, U6>(
	lhs: T6?, rhs: U6?) -> SDAI.BAG<T6.ELEMENT>?
where T6.ELEMENT: SDAI__REAL__type,
			U6: SDAIIntegerType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: SDAI.REAL(rhs))
}

/// BAG<LOGICAL> + Boolean = Bag
///
public func + <T7: SDAI__BAG__type, U7>(
	lhs: T7?, rhs: U7?) -> SDAI.BAG<T7.ELEMENT>?
where T7.ELEMENT: SDAI__LOGICAL__type,
			U7: SDAIBooleanType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: SDAI.LOGICAL(rhs))
}

/// BAG<Complex> + Complex = Bag
///
public func + <T8: SDAI__BAG__type>(
	lhs: T8?, rhs: SDAI.ComplexEntity?) -> SDAI.BAG<T8.ELEMENT>?
where T8.ELEMENT: InitializableByComplexEntity
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

/// BAG<Entity> + Select = Bag
///
public func + <T9: SDAI__BAG__type, U9: SDAISelectType>(
	lhs: T9?, rhs: U9?) -> SDAI.BAG<T9.ELEMENT>?
where T9.ELEMENT: SDAI.EntityReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

/// BAG<PRef> + Select = Bag
///
public func + <T10: SDAI__BAG__type, U10: SDAISelectType>(
	lhs: T10?, rhs: U10?) -> SDAI.BAG<T10.ELEMENT>?
where T10.ELEMENT: SDAIPersistentReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

//MARK: Element + Bag = Bag
/// Fundamental + BAG<Fundamental> = Bag
///
public func + <T11: SDAIGenericType, U11: SDAI__BAG__type>(
	lhs: T11?, rhs: U11?) -> SDAI.BAG<U11.ELEMENT>?
where T11.FundamentalType == U11.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

/// GENERIC + BAG<Generic> = Bag
///
public func + <T12: SDAI__GENERIC__type, U12: SDAI__BAG__type>	(
	lhs: T12?, rhs: U12?) -> SDAI.BAG<U12.ELEMENT>?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

/// Real + BAG<NUMBER> = Bag
///
public func + <T13, U13: SDAI__BAG__type>(
	lhs: T13?, rhs: U13?) -> SDAI.BAG<U13.ELEMENT>?
where T13: SDAIRealType,
			U13.ELEMENT: SDAI__NUMBER__type
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: SDAI.NUMBER(lhs))
}

/// Integer + BAG<REAL> = Bag
///
public func + <T14, U14: SDAI__BAG__type>(
	lhs: T14?, rhs: U14?) -> SDAI.BAG<U14.ELEMENT>?
where T14: SDAIIntegerType,
			U14.ELEMENT: SDAI__REAL__type
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: SDAI.REAL(lhs))
}

/// Boolean + BAG<LOGICAL> = Bag
///
public func + <T15, U15: SDAI__BAG__type>(
	lhs: T15?, rhs: U15?) -> SDAI.BAG<U15.ELEMENT>?
where T15: SDAIBooleanType,
			U15.ELEMENT: SDAI__LOGICAL__type
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: SDAI.LOGICAL(lhs))
}

/// Complex + BAG<Complex> = Bag
///
public func + <U16: SDAI__BAG__type>(
	lhs: SDAI.ComplexEntity?, rhs: U16?) -> SDAI.BAG<U16.ELEMENT>?
where U16.ELEMENT: InitializableByComplexEntity
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

/// Select + BAG<Entity> = Bag
///
public func + <T17: SDAISelectType, U17: SDAI__BAG__type>(
	lhs: T17?, rhs: U17?) -> SDAI.BAG<U17.ELEMENT>?
where U17.ELEMENT: SDAI.EntityReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

/// Select + BAG<PRef> = Bag
///
public func + <T18: SDAISelectType, U18: SDAI__BAG__type>(
	lhs: T18?, rhs: U18?) -> SDAI.BAG<U18.ELEMENT>?
where U18.ELEMENT: SDAIPersistentReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

//MARK:  Set + Set/Bag = Set
/// Set + Set/Bag = Set
///
public func + <T19: SDAI__SET__type, U19: SDAIBagType>(
	lhs: T19?, rhs: U19?) -> SDAI.SET<T19.ELEMENT>?
where T19.ELEMENT.FundamentalType == U19.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

//MARK: Set + List = Set
/// Set + List = Set
///
public func + <T20: SDAI__SET__type, U20: SDAIListType>(
	lhs: T20?, rhs: U20?) -> SDAI.SET<T20.ELEMENT>?
where T20.ELEMENT.FundamentalType == U20.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}



//MARK: Set + Element = Set

/// SET<Fundamental> + Fundamental = Set
///
public func + <T21: SDAI__SET__type, U21: SDAIGenericType>(
	lhs: T21?, rhs: U21?) -> SDAI.SET<T21.ELEMENT>?
where T21.ELEMENT.FundamentalType == U21.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

/// SET<Generic> + GENERIC = Set
///
public func + <T22: SDAI__SET__type, U22: SDAI__GENERIC__type>(
	lhs: T22?, rhs: U22?) -> SDAI.SET<T22.ELEMENT>?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

/// SET<NUMBER> + Real = Set
///
public func + <T23: SDAI__SET__type, U23>(
	lhs: T23?, rhs: U23?) -> SDAI.SET<T23.ELEMENT>?
where T23.ELEMENT: SDAI__NUMBER__type,
			U23: SDAIRealType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: SDAI.NUMBER(rhs))
}

/// SET<NUMBER> + Integer = Set
///
public func + <T24: SDAI__SET__type, U24>(
	lhs: T24?, rhs: U24?) -> SDAI.SET<T24.ELEMENT>?
where T24.ELEMENT: SDAI__REAL__type,
			U24: SDAIIntegerType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: SDAI.REAL(rhs))
}

/// SET<LOGICAL> + Boolean = Set
///
public func + <T25: SDAI__SET__type, U25>(
	lhs: T25?, rhs: U25?) -> SDAI.SET<T25.ELEMENT>?
where T25.ELEMENT: SDAI__LOGICAL__type,
			U25: SDAIBooleanType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: SDAI.LOGICAL(rhs))
}

/// SET<Complex> + Complex = Set
///
public func + <T26: SDAI__SET__type>(
	lhs: T26?, rhs: SDAI.ComplexEntity?) -> SDAI.SET<T26.ELEMENT>?
where T26.ELEMENT: InitializableByComplexEntity
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

/// SET<Entity> + Select = Set
///
public func + <T27: SDAI__SET__type, U27: SDAISelectType>(
	lhs: T27?, rhs: U27?) -> SDAI.SET<T27.ELEMENT>?
where T27.ELEMENT: SDAI.EntityReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

/// SET<PRef> + Select = Set
///
public func + <T28: SDAI__SET__type, U28: SDAISelectType>(
	lhs: T28?, rhs: U28?) -> SDAI.SET<T28.ELEMENT>?
where T28.ELEMENT: SDAIPersistentReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

//MARK: Element + Set = Set
/// Fundamental + SET<Fundamental> = Set
///
public func + <T29: SDAIGenericType, U29: SDAI__SET__type>(
	lhs: T29?, rhs: U29?) -> SDAI.SET<U29.ELEMENT>?
where T29.FundamentalType == U29.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

/// GENERIC + SET<Generic> = Set
///
public func + <T30: SDAI__GENERIC__type, U30: SDAI__SET__type>(
	lhs: T30?, rhs: U30?) -> SDAI.SET<U30.ELEMENT>?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

/// Real + SET<NUMBER> = Set
///
public func + <T31, U31: SDAI__SET__type>(
	lhs: T31?, rhs: U31?) -> SDAI.SET<U31.ELEMENT>?
where T31: SDAIRealType,
			U31.ELEMENT: SDAI__NUMBER__type
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: SDAI.NUMBER(lhs))
}

/// Integer + SET<REAL> = Set
///
public func + <T32, U32: SDAI__SET__type>(
	lhs: T32?, rhs: U32?) -> SDAI.SET<U32.ELEMENT>?
where T32: SDAIIntegerType,
			U32.ELEMENT: SDAI__REAL__type
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: SDAI.REAL(lhs))
}

/// Boolean + SET<LOGICAL> = Set
///
public func + <T33, U33: SDAI__SET__type>(
	lhs: T33?, rhs: U33?) -> SDAI.SET<U33.ELEMENT>?
where T33: SDAIBooleanType,
			U33.ELEMENT: SDAI__LOGICAL__type
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: SDAI.LOGICAL(lhs))
}

/// Complex + SET<Complex> = Set
///
public func + <U34: SDAI__SET__type>(
	lhs: SDAI.ComplexEntity?, rhs: U34?) -> SDAI.SET<U34.ELEMENT>?
where U34.ELEMENT: InitializableByComplexEntity
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

/// Select + SET<Entity> = Set
///
public func + <T35: SDAISelectType, U35: SDAI__SET__type>(
	lhs: T35?, rhs: U35?) -> SDAI.SET<U35.ELEMENT>?
where U35.ELEMENT: SDAI.EntityReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

/// Select + SET<PRef> = Set
///
public func + <T36: SDAISelectType, U36: SDAI__SET__type>(
	lhs: T36?, rhs: U36?) -> SDAI.SET<U36.ELEMENT>?
where U36.ELEMENT: SDAIPersistentReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

//MARK: List + List = List
/// List + List = List
///
public func + <T37: SDAI__LIST__type, U37: SDAIListType>(
	lhs: T37?, rhs: U37?) -> SDAI.LIST<T37.ELEMENT>?
where T37.ELEMENT.FundamentalType == U37.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: rhs)
}

//MARK: List + Element = List
/// LIST<Fundamental> + Fundamental = List
///
public func + <T38: SDAI__LIST__type, U38: SDAIGenericType>(
	lhs: T38?, rhs: U38?) -> SDAI.LIST<T38.ELEMENT>?
where T38.ELEMENT.FundamentalType == U38.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: rhs)
}

/// LIST<Generic> + GENERIC = List
///
public func + <T39: SDAI__LIST__type, U39: SDAI__GENERIC__type>(
	lhs: T39?, rhs: U39?) -> SDAI.LIST<T39.ELEMENT>?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: rhs)
}

/// LIST<NUMBER> + Real = List
///
public func + <T40: SDAI__LIST__type, U40>(
	lhs: T40?, rhs: U40?) -> SDAI.LIST<T40.ELEMENT>?
where T40.ELEMENT: SDAI__NUMBER__type,
			U40: SDAIRealType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: SDAI.NUMBER(rhs))
}

/// LIST<REAL> + Integer = List
///
public func + <T41: SDAI__LIST__type, U41>(
	lhs: T41?, rhs: U41?) -> SDAI.LIST<T41.ELEMENT>?
where T41.ELEMENT: SDAI__REAL__type,
			U41: SDAIIntegerType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: SDAI.REAL(rhs))
}

/// LIST<LOGICAL> + Boolean = List
///
public func + <T42: SDAI__LIST__type, U42>(
	lhs: T42?, rhs: U42?) -> SDAI.LIST<T42.ELEMENT>?
where T42.ELEMENT: SDAI__LOGICAL__type,
			U42: SDAIBooleanType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: SDAI.LOGICAL(rhs))
}

/// LIST<Complex> + Complex = List
///
public func + <T43: SDAI__LIST__type>(
	lhs: T43?, rhs: SDAI.ComplexEntity?) -> SDAI.LIST<T43.ELEMENT>?
where T43.ELEMENT: InitializableByComplexEntity
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: rhs)
}

/// LIST<Entity> + Select = List
///
public func + <T44: SDAI__LIST__type, U44: SDAISelectType>(
	lhs: T44?, rhs: U44?) -> SDAI.LIST<T44.ELEMENT>?
where T44.ELEMENT: SDAI.EntityReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: rhs)
}

/// LIST<PRef> + Select = List
///
public func + <T45: SDAI__LIST__type, U45: SDAISelectType>(
	lhs: T45?, rhs: U45?) -> SDAI.LIST<T45.ELEMENT>?
where T45.ELEMENT: SDAIPersistentReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: rhs)
}

//MARK: Element + List = List
/// Fundamental + LIST<Fundamental> = List
///
public func + <T46: SDAIGenericType, U46: SDAI__LIST__type>(
	lhs: T46?, rhs: U46?) -> SDAI.LIST<U46.ELEMENT>?
where T46.FundamentalType == U46.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: lhs)
}

/// GENERIC + LIST<Generic> = List
///
public func + <T47: SDAI__GENERIC__type, U47: SDAI__LIST__type>(
	lhs: T47?, rhs: U47?) -> SDAI.LIST<U47.ELEMENT>?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: lhs)
}

/// Real + LIST<NUMBER> = List
///
public func + <T48, U48: SDAI__LIST__type>(
	lhs: T48?, rhs: U48?) -> SDAI.LIST<U48.ELEMENT>?
where T48: SDAIRealType,
			U48.ELEMENT: SDAI__NUMBER__type
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: SDAI.NUMBER(lhs))
}

/// Integer + LIST<REAL> = List
///
public func + <T49, U49: SDAI__LIST__type>(
	lhs: T49?, rhs: U49?) -> SDAI.LIST<U49.ELEMENT>?
where T49: SDAIIntegerType,
			U49.ELEMENT: SDAI__REAL__type
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: SDAI.REAL(lhs))
}

/// Boolean + LIST<LOGICAL> = List
///
public func + <T50, U50: SDAI__LIST__type>(
	lhs: T50?, rhs: U50?) -> SDAI.LIST<U50.ELEMENT>?
where T50: SDAIBooleanType,
			U50.ELEMENT: SDAI__LOGICAL__type
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: SDAI.LOGICAL(lhs))
}

/// Complex + LIST<Complex> = List
///
public func + <U51: SDAI__LIST__type>(
	lhs: SDAI.ComplexEntity?, rhs: U51?) -> SDAI.LIST<U51.ELEMENT>?
where U51.ELEMENT: InitializableByComplexEntity
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: lhs)
}

/// Select + LIST<Entity> = List
///
public func + <T52: SDAISelectType, U52: SDAI__LIST__type>(
	lhs: T52?, rhs: U52?) -> SDAI.LIST<U52.ELEMENT>?
where U52.ELEMENT: SDAI.EntityReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: lhs)
}

/// Select + LIST<PRef> = List
///
public func + <T53: SDAISelectType, U53: SDAI__LIST__type>(
	lhs: T53?, rhs: U53?) -> SDAI.LIST<U53.ELEMENT>?
where U53.ELEMENT: SDAIPersistentReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: lhs)
}

//MARK: Bag + Aggregate = Bag
/// Bag + Aggregate = Bag
///
public func + <T54: SDAI__BAG__type, U54: SDAIAggregationInitializer>(
	lhs: T54?, rhs: U54?) -> SDAI.BAG<T54.ELEMENT>?
where T54.ELEMENT.FundamentalType == U54.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

//MARK: Aggregate + Bag = Bag
/// Aggregate + Bag = Bag
///
public func + <T55: SDAIAggregationInitializer, U55: SDAI__BAG__type>(
	lhs: T55?, rhs: U55?) -> SDAI.BAG<U55.ELEMENT>?
where T55.ELEMENT.FundamentalType == U55.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

//MARK: Set + Aggregate = Set
/// Set + Aggregate = Set
///
public func + <T56: SDAI__SET__type, U56: SDAIAggregationInitializer>(
	lhs: T56?, rhs: U56?) -> SDAI.SET<T56.ELEMENT>?
where T56.ELEMENT.FundamentalType == U56.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

//MARK: Aggregate + Set = Set
/// Aggregate + Set = Set
///
public func + <T57: SDAIAggregationInitializer, U57: SDAI__SET__type>(
	lhs: T57?, rhs: U57?) -> SDAI.SET<U57.ELEMENT>?
where T57.ELEMENT.FundamentalType == U57.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

//MARK: List + Aggregate = List
/// List + Aggregate = List
///
public func + <T58: SDAI__LIST__type, U58: SDAIAggregationInitializer>(
	lhs: T58?, rhs: U58?) -> SDAI.LIST<T58.ELEMENT>?
where T58.ELEMENT.FundamentalType == U58.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: rhs)
}

//MARK: Aggregate + List = List
/// Aggregate + List = List
///
public func + <T59: SDAIAggregationInitializer, U59: SDAI__LIST__type>(
	lhs: T59?, rhs: U59?) -> SDAI.LIST<U59.ELEMENT>?
where T59.ELEMENT.FundamentalType == U59.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: lhs)
}






//MARK: - Difference operator (12.6.4)

//MARK: Bag - Bag/Set = Bag
/// Bag - Bag/Set = Bag
///
public func - <T1: SDAI__BAG__type, U1: SDAIBagType>(
	lhs: T1?, rhs: U1?) -> SDAI.BAG<T1.ELEMENT>?
where T1.ELEMENT.FundamentalType == U1.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

//MARK: Bag - Element = Bag
/// BAG<Fundamental> - Fundamental = Bag
///
public func - <T2: SDAI__BAG__type, U2: SDAIGenericType>(
	lhs: T2?, rhs: U2?) -> SDAI.BAG<T2.ELEMENT>?
where T2.ELEMENT.FundamentalType == U2.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

/// BAG<Generic> - GENERIC = Bag
///
public func - <T3: SDAI__BAG__type, U3: SDAI__GENERIC__type>(
	lhs: T3?, rhs: U3?) -> SDAI.BAG<T3.ELEMENT>?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

/// BAG<NUMBER> - Real = Bag
///
public func - <T4: SDAI__BAG__type, U4>(
	lhs: T4?, rhs: U4?) -> SDAI.BAG<T4.ELEMENT>?
where T4.ELEMENT: SDAI__NUMBER__type,
			U4: SDAIRealType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: SDAI.NUMBER(rhs))
}

/// BAG<REAL> - Integer = Bag
///
public func - <T5: SDAI__BAG__type, U5>(
	lhs: T5?, rhs: U5?) -> SDAI.BAG<T5.ELEMENT>?
where T5.ELEMENT: SDAI__REAL__type,
			U5: SDAIIntegerType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: SDAI.REAL(rhs))
}

/// BAG<LOGICAL> - Boolean = Bag
///
public func - <T6: SDAI__BAG__type, U6>(
	lhs: T6?, rhs: U6?) -> SDAI.BAG<T6.ELEMENT>?
where T6.ELEMENT: SDAI__LOGICAL__type,
			U6: SDAIBooleanType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: SDAI.LOGICAL(rhs))
}

/// BAG<Complex> - Complex = Bag
///
public func - <T7: SDAI__BAG__type>(
	lhs: T7?, rhs: SDAI.ComplexEntity?) -> SDAI.BAG<T7.ELEMENT>?
where T7.ELEMENT: InitializableByComplexEntity
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

/// BAG<Entity> - Select = Bag
///
public func - <T8: SDAI__BAG__type, U8: SDAISelectType>(
	lhs: T8?, rhs: U8?) -> SDAI.BAG<T8.ELEMENT>?
where T8.ELEMENT: SDAI.EntityReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

/// BAG<PRef> - Select = Bag
///
public func - <T9: SDAI__BAG__type, U9: SDAISelectType>(
	lhs: T9?, rhs: U9?) -> SDAI.BAG<T9.ELEMENT>?
where T9.ELEMENT: SDAIPersistentReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}


//MARK: Set - Set/Bag = Set
/// Set - Set/Bag = Set
///
public func - <T10: SDAI__SET__type, U10: SDAIBagType>(
	lhs: T10?, rhs: U10?) -> SDAI.SET<T10.ELEMENT>?
where T10.ELEMENT.FundamentalType == U10.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

//MARK: Set - Element = Set
/// SET<Fundamental> - Fundamental = Set
///
public func - <T11: SDAI__SET__type, U11: SDAIGenericType>(
	lhs: T11?, rhs: U11?) -> SDAI.SET<T11.ELEMENT>?
where T11.ELEMENT.FundamentalType == U11.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

/// SET<Generic> - GENERIC = Set
///
public func - <T12: SDAI__SET__type, U12: SDAI__GENERIC__type>(
	lhs: T12?, rhs: U12?) -> SDAI.SET<T12.ELEMENT>?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

/// SET<NUMBER> - Real = Set
///
public func - <T13: SDAI__SET__type, U13>(
	lhs: T13?, rhs: U13?) -> SDAI.SET<T13.ELEMENT>?
where T13.ELEMENT: SDAI__NUMBER__type,
			U13: SDAIRealType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: SDAI.NUMBER(rhs))
}

/// SET<REAL> - Integer = Set
///
public func - <T14: SDAI__SET__type, U14>(
	lhs: T14?, rhs: U14?) -> SDAI.SET<T14.ELEMENT>?
where T14.ELEMENT: SDAI__REAL__type,
			U14: SDAIIntegerType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: SDAI.REAL(rhs))
}

/// SET<LOGICL> - Boolean = Set
///
public func - <T15: SDAI__SET__type, U15>(
	lhs: T15?, rhs: U15?) -> SDAI.SET<T15.ELEMENT>?
where T15.ELEMENT: SDAI__LOGICAL__type,
			U15: SDAIBooleanType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: SDAI.LOGICAL(rhs))
}

/// SET<Complex> - Complex = Set
///
public func - <T16: SDAI__SET__type>(
	lhs: T16?, rhs: SDAI.ComplexEntity?) -> SDAI.SET<T16.ELEMENT>?
where T16.ELEMENT: InitializableByComplexEntity
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

/// SET<Entity> - Select = Set
///
public func - <T17: SDAI__SET__type, U17: SDAISelectType>(
	lhs: T17?, rhs: U17?) -> SDAI.SET<T17.ELEMENT>?
where T17.ELEMENT: SDAI.EntityReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

/// SET<PRef> - Select = Set
///
public func - <T18: SDAI__SET__type, U18: SDAISelectType>(
	lhs: T18?, rhs: U18?) -> SDAI.SET<T18.ELEMENT>?
where T18.ELEMENT: SDAIPersistentReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}


//MARK: Bag - Aggregate = Bag
/// Bag - Aggregate = Bag
///
public func - <T19: SDAI__BAG__type, U19: SDAIAggregationInitializer>(
	lhs: T19?, rhs: U19?) -> SDAI.BAG<T19.ELEMENT>?
where T19.ELEMENT.FundamentalType == U19.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

//MARK: Set - Aggregate = Set
/// Set - Aggregate = Set
///
public func - <T20: SDAI__SET__type, U20: SDAIAggregationInitializer>	(
	lhs: T20?, rhs: U20?) -> SDAI.SET<T20.ELEMENT>?
where T20.ELEMENT.FundamentalType == U20.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}



//MARK: - Subset operator (12.6.5)
/// Subset operator
///
public func <= <T: SDAIBagType, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { 
	return rhs >= lhs
}

//MARK: - Superset operator (12.6.6)
/// Superset operator
/// 
public func >= <T: SDAIBagType, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL
where T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { 
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	return SDAI.LOGICAL(lhs.isSuperset(of: rhs))
}
