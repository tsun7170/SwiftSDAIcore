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
/// Aggregate Intersection: Bag * Bag = BAG
///
/// Computes the intersection of two aggregate values, returning a new aggregate containing only the elements common to both operands.
/// 
/// - Parameters:
///   - lhs: The left-hand side operand, an optional aggregate conforming to `SDAI__BAG__type`.
///   - rhs: The right-hand side operand, an optional aggregate conforming to `SDAI__BAG__type`.
/// - Returns: A new `SDAI.BAG` containing the intersection of elements from both `lhs` and `rhs`, or `nil` if either operand is `nil`.
/// - Note: The element types of the operands must have the same `FundamentalType`.
/// - Discussion: This operator implements the intersection operation as described in section 12.6.2 of the formal specification. It may be overloaded for other aggregate type combinations as defined by the standard.
public func * <T1: SDAI.TypeHierarchy.BAG__TypeBehavior, U1: SDAI.TypeHierarchy.BAG__TypeBehavior>(
	lhs: T1?, rhs: U1?) -> SDAI.BAG<T1.ELEMENT>?
where T1.ELEMENT.FundamentalType == U1.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.intersectionWith(rhs: rhs)
}

//MARK: Bag * Set = Set
/// Aggregate Intersection: Bag * Set = SET
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
public func * <T2: SDAI.TypeHierarchy.BAG__TypeBehavior, U2: SDAI.TypeHierarchy.SET__TypeBehavior>(
	lhs: T2?, rhs: U2?) -> SDAI.SET<T2.ELEMENT>?
where T2.ELEMENT.FundamentalType == U2.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.intersectionWith(rhs: rhs)
}


//MARK: Set * Set/Bag = Set
/// Aggregate Intersection: Set * Set/Bag = SET
///
/// Computes the intersection of two sets or a set and a bag, returning a new `SDAI.SET` containing only the elements common to both operands.
/// 
/// - Parameters:
///   - lhs: The left-hand side operand, an optional aggregate conforming to `SDAI__SET__type`.
///   - rhs: The right-hand side operand, an optional aggregate conforming to `SDAI.BagType`.
/// - Returns: A new `SDAI.SET` containing the intersection of elements from both `lhs` and `rhs`, or `nil` if either operand is `nil`.
/// - Note: The element types of the operands must have the same `FundamentalType`.
/// - Discussion: This operator implements the intersection operation (as described in section 12.6.2 of the formal specification) between a `SET` and either another `SET` or a `BAG`. The result type is always a `SET`.
public func * <T3: SDAI.TypeHierarchy.SET__TypeBehavior, U3: SDAI.BagType>(
	lhs: T3?, rhs: U3?) -> SDAI.SET<T3.ELEMENT>?
where T3.ELEMENT.FundamentalType == U3.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.intersectionWith(rhs: rhs)
}

//MARK: Bag * Aggregate = Bag
/// Aggregate Intersection: Bag * Aggregate = BAG
///
/// Computes the intersection of two optional aggregates conforming to `SDAI__BAG__type`, returning a new `SDAI.BAG` containing only the elements common to both operands.
/// 
/// - Parameters:
///   - lhs: The left-hand side operand, an optional aggregate conforming to `SDAI__BAG__type`.
///   - rhs: The right-hand side operand, an optional aggregate initializer conforming to `SDAI.AggregationInitializer`.
/// - Returns: A new `SDAI.BAG` containing the intersection of elements from both `lhs` and `rhs`, or `nil` if either operand is `nil`.
/// - Note: The element types of the operands must have the same `FundamentalType`.
/// - Discussion: This operator implements the intersection operation as described in section 12.6.2 of the formal specification. It may be overloaded for other aggregate type combinations as defined by the standard.
public func * <T4: SDAI.TypeHierarchy.BAG__TypeBehavior, U4: SDAI.AggregationInitializer>(
	lhs: T4?, rhs: U4?) -> SDAI.BAG<T4.ELEMENT>?
where T4.ELEMENT.FundamentalType == U4.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.intersectionWith(rhs: rhs)
}

//MARK: Aggregate * Bag = Bag
/// Aggregate Intersection: Aggregate * Bag = BAG
///
/// Computes the intersection of two aggregate values, returning a new aggregate containing only the elements common to both operands.
///
/// - Parameters:
///   - lhs: The left-hand side operand, an optional aggregate conforming to `SDAI.AggregationInitializer`.
///   - rhs: The right-hand side operand, an optional aggregate conforming to `SDAI__BAG__type` aggregate protocol.
/// - Returns: A new aggregate containing the intersection of elements from both `lhs` and `rhs`, or `nil` if either operand is `nil`.
/// - Note: The element types of the operands must have the same `FundamentalType`.
/// - Discussion: This operator implements the intersection operation as described in section 12.6.2 of the formal specification, for aggregate types that include aggregation initializers.
public func * <T5: SDAI.AggregationInitializer, U5: SDAI.TypeHierarchy.BAG__TypeBehavior>(
	lhs: T5?, rhs: U5?) -> SDAI.BAG<U5.ELEMENT>?
where T5.ELEMENT.FundamentalType == U5.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.intersectionWith(rhs: lhs)
}

//MARK: Set * Aggregate = Set
/// Aggregate Intersection: Set * Aggregate = SET
///
/// Computes the intersection of two aggregate values, returning a new aggregate containing only the elements common to both operands.
/// 
/// This operator implements the intersection operation between two aggregate types as described in section 12.6.2 of the formal specification.
/// It is applicable to combinations of `BAG`, `SET`, and general aggregate types, depending on the types of the operands.
/// 
/// - Parameters:
///   - lhs: The left-hand side operand, an optional aggregate conforming to `SDAI__SET__type`.
///   - rhs: The right-hand side operand, an optional aggregate conforming to `SDAI.AggregationInitializer`.
/// - Returns: A new `SDAI.SET` containing the intersection of elements from both `lhs` and `rhs`, or `nil` if either operand is `nil`.
/// - Note: The element types of the operands must have the same `FundamentalType`.
/// - Discussion: The result type is always a `SET`, as defined by the standard, for the intersection of a set and either another `SET` or a `BAG`.
public func * <T6: SDAI.TypeHierarchy.SET__TypeBehavior, U6: SDAI.AggregationInitializer>(
	lhs: T6?, rhs: U6?) -> SDAI.SET<T6.ELEMENT>?
where T6.ELEMENT.FundamentalType == U6.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.intersectionWith(rhs: rhs)
}

//MARK: Aggregate * Set = Set
/// Aggregate Intersection: Aggregate * Set = SET
///
/// Computes the intersection of two aggregate values, returning a new aggregate containing only the elements common to both operands.
///
/// This operator performs the intersection operation as described in section 12.6.2 of the formal specification. 
/// It is applicable to combinations of `BAG`, `SET`, and general aggregate types, depending on the types of the operands.
/// 
/// - Parameters:
///   - lhs: The left-hand side operand, an optional aggregate conforming to `SDAI.AggregationInitializer`.
///   - rhs: The right-hand side operand, an optional aggregate conforming to `SDAI__SET__type`.
/// - Returns: A new aggregate containing the intersection of elements from both `lhs` and `rhs`, or `nil` if either operand is `nil`.
/// - Note: The element types of the operands must have the same `FundamentalType`.
/// - Discussion: The result type depends on the operand types, as defined by the standard. For example, the intersection of a `SET` and another aggregate yields a `SET`, while other combinations may yield different types.
public func * <T7: SDAI.AggregationInitializer, U7: SDAI.TypeHierarchy.SET__TypeBehavior>(
	lhs: T7?, rhs: U7?) -> SDAI.SET<U7.ELEMENT>?
where T7.ELEMENT.FundamentalType == U7.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.intersectionWith(rhs: lhs)
}



//MARK: - Union operator (12.6.3)

//MARK: Bag + Bag/Set = Bag
/// Aggregate Union: Bag + Bag/Set = BAG
///
public func + <T1: SDAI.TypeHierarchy.BAG__TypeBehavior, U1: SDAI.BagType>(
	lhs: T1?, rhs: U1?) -> SDAI.BAG<T1.ELEMENT>?
where T1.ELEMENT.FundamentalType == U1.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

//MARK: Bag + List = Bag
/// Aggregate Union: Bag + List = BAG
///
public func + <T2: SDAI.TypeHierarchy.BAG__TypeBehavior, U2: SDAI.ListType>(
	lhs: T2?, rhs: U2?) -> SDAI.BAG<T2.ELEMENT>?
where T2.ELEMENT.FundamentalType == U2.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

//MARK: Bag + Element = Bag
/// Aggregate Union: BAG\<Fundamental\> + Fundamental = BAG
///
public func + <T3: SDAI.TypeHierarchy.BAG__TypeBehavior, U3: SDAI.GenericType>(
	lhs: T3?, rhs: U3?) -> SDAI.BAG<T3.ELEMENT>?
where T3.ELEMENT.FundamentalType == U3.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

/// Aggregate Union: BAG\<Generic\> + GENERIC = Bag
///
public func + <T4: SDAI.TypeHierarchy.BAG__TypeBehavior, U4: SDAI.TypeHierarchy.GENERIC__TypeBehavior>(
	lhs: T4?, rhs: U4?) -> SDAI.BAG<T4.ELEMENT>?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

/// Aggregate Union: BAG\<NUMBER\> + Real = BAG
///
public func + <T5: SDAI.TypeHierarchy.BAG__TypeBehavior, U5>(
	lhs: T5?, rhs: U5?) -> SDAI.BAG<T5.ELEMENT>?
where T5.ELEMENT: SDAI.TypeHierarchy.NUMBER__TypeBehavior,
			U5: SDAI.RealType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: SDAI.NUMBER(rhs))
}

/// Aggregate Union: BAG\<REAL\> + Integer = BAG
///
public func + <T6: SDAI.TypeHierarchy.BAG__TypeBehavior, U6>(
	lhs: T6?, rhs: U6?) -> SDAI.BAG<T6.ELEMENT>?
where T6.ELEMENT: SDAI.TypeHierarchy.REAL__TypeBehavior,
			U6: SDAI.IntegerType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: SDAI.REAL(rhs))
}

/// Aggregate Union: BAG\<LOGICAL\> + Boolean = BAG
///
public func + <T7: SDAI.TypeHierarchy.BAG__TypeBehavior, U7>(
	lhs: T7?, rhs: U7?) -> SDAI.BAG<T7.ELEMENT>?
where T7.ELEMENT: SDAI.TypeHierarchy.LOGICAL__TypeBehavior,
			U7: SDAI.BooleanType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: SDAI.LOGICAL(rhs))
}

/// Aggregate Union: BAG\<Complex\> + Complex = BAG
///
public func + <T8: SDAI.TypeHierarchy.BAG__TypeBehavior>(
	lhs: T8?, rhs: SDAI.ComplexEntity?) -> SDAI.BAG<T8.ELEMENT>?
where T8.ELEMENT: SDAI.Initializable.ByComplexEntity
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

/// Aggregate Union: BAG\<Entity\> + Select = BAG
///
public func + <T9: SDAI.TypeHierarchy.BAG__TypeBehavior, U9: SDAI.SelectType>(
	lhs: T9?, rhs: U9?) -> SDAI.BAG<T9.ELEMENT>?
where T9.ELEMENT: SDAI.EntityReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

/// Aggregate Union: BAG\<PRef\> + Select = BAG
///
public func + <T10: SDAI.TypeHierarchy.BAG__TypeBehavior, U10: SDAI.SelectType>(
	lhs: T10?, rhs: U10?) -> SDAI.BAG<T10.ELEMENT>?
where T10.ELEMENT: SDAI.PersistentReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

//MARK: Element + Bag = Bag
/// Aggregate Union: Fundamental + BAG\<Fundamental\> = BAG
///
public func + <T11: SDAI.GenericType, U11: SDAI.TypeHierarchy.BAG__TypeBehavior>(
	lhs: T11?, rhs: U11?) -> SDAI.BAG<U11.ELEMENT>?
where T11.FundamentalType == U11.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

/// Aggregate Union: GENERIC + BAG\<Generic\> = BAG
///
public func + <T12: SDAI.TypeHierarchy.GENERIC__TypeBehavior, U12: SDAI.TypeHierarchy.BAG__TypeBehavior>	(
	lhs: T12?, rhs: U12?) -> SDAI.BAG<U12.ELEMENT>?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

/// Aggregate Union: Real + BAG\<NUMBER\> = BAG
///
public func + <T13, U13: SDAI.TypeHierarchy.BAG__TypeBehavior>(
	lhs: T13?, rhs: U13?) -> SDAI.BAG<U13.ELEMENT>?
where T13: SDAI.RealType,
			U13.ELEMENT: SDAI.TypeHierarchy.NUMBER__TypeBehavior
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: SDAI.NUMBER(lhs))
}

/// Aggregate Union: Integer + BAG\<REAL\> = BAG
///
public func + <T14, U14: SDAI.TypeHierarchy.BAG__TypeBehavior>(
	lhs: T14?, rhs: U14?) -> SDAI.BAG<U14.ELEMENT>?
where T14: SDAI.IntegerType,
			U14.ELEMENT: SDAI.TypeHierarchy.REAL__TypeBehavior
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: SDAI.REAL(lhs))
}

/// Aggregate Union: Boolean + BAG\<LOGICAL\> = BAG
///
public func + <T15, U15: SDAI.TypeHierarchy.BAG__TypeBehavior>(
	lhs: T15?, rhs: U15?) -> SDAI.BAG<U15.ELEMENT>?
where T15: SDAI.BooleanType,
			U15.ELEMENT: SDAI.TypeHierarchy.LOGICAL__TypeBehavior
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: SDAI.LOGICAL(lhs))
}

/// Aggregate Union: Complex + BAG\<Complex\> = BAG
///
public func + <U16: SDAI.TypeHierarchy.BAG__TypeBehavior>(
	lhs: SDAI.ComplexEntity?, rhs: U16?) -> SDAI.BAG<U16.ELEMENT>?
where U16.ELEMENT: SDAI.Initializable.ByComplexEntity
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

/// Aggregate Union: Select + BAG\<Entity\> = BAG
///
public func + <T17: SDAI.SelectType, U17: SDAI.TypeHierarchy.BAG__TypeBehavior>(
	lhs: T17?, rhs: U17?) -> SDAI.BAG<U17.ELEMENT>?
where U17.ELEMENT: SDAI.EntityReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

/// Aggregate Union: Select + BAG\<PRef\> = BAG
///
public func + <T18: SDAI.SelectType, U18: SDAI.TypeHierarchy.BAG__TypeBehavior>(
	lhs: T18?, rhs: U18?) -> SDAI.BAG<U18.ELEMENT>?
where U18.ELEMENT: SDAI.PersistentReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

//MARK:  Set + Set/Bag = Set
/// Aggregate Union: Set + Set/Bag = SET
///
public func + <T19: SDAI.TypeHierarchy.SET__TypeBehavior, U19: SDAI.BagType>(
	lhs: T19?, rhs: U19?) -> SDAI.SET<T19.ELEMENT>?
where T19.ELEMENT.FundamentalType == U19.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

//MARK: Set + List = Set
/// Aggregate Union: Set + List = SET
///
public func + <T20: SDAI.TypeHierarchy.SET__TypeBehavior, U20: SDAI.ListType>(
	lhs: T20?, rhs: U20?) -> SDAI.SET<T20.ELEMENT>?
where T20.ELEMENT.FundamentalType == U20.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}



//MARK: Set + Element = Set

/// Aggregate Union: SET\<Fundamental\> + Fundamental = SET
///
public func + <T21: SDAI.TypeHierarchy.SET__TypeBehavior, U21: SDAI.GenericType>(
	lhs: T21?, rhs: U21?) -> SDAI.SET<T21.ELEMENT>?
where T21.ELEMENT.FundamentalType == U21.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

/// Aggregate Union: SET\<Generic\> + GENERIC = SET
///
public func + <T22: SDAI.TypeHierarchy.SET__TypeBehavior, U22: SDAI.TypeHierarchy.GENERIC__TypeBehavior>(
	lhs: T22?, rhs: U22?) -> SDAI.SET<T22.ELEMENT>?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

/// Aggregate Union: SET\<NUMBER\> + Real = SET
///
public func + <T23: SDAI.TypeHierarchy.SET__TypeBehavior, U23>(
	lhs: T23?, rhs: U23?) -> SDAI.SET<T23.ELEMENT>?
where T23.ELEMENT: SDAI.TypeHierarchy.NUMBER__TypeBehavior,
			U23: SDAI.RealType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: SDAI.NUMBER(rhs))
}

/// Aggregate Union: SET\<NUMBER\> + Integer = SET
///
public func + <T24: SDAI.TypeHierarchy.SET__TypeBehavior, U24>(
	lhs: T24?, rhs: U24?) -> SDAI.SET<T24.ELEMENT>?
where T24.ELEMENT: SDAI.TypeHierarchy.REAL__TypeBehavior,
			U24: SDAI.IntegerType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: SDAI.REAL(rhs))
}

/// Aggregate Union: SET\<LOGICAL\> + Boolean = SET
///
public func + <T25: SDAI.TypeHierarchy.SET__TypeBehavior, U25>(
	lhs: T25?, rhs: U25?) -> SDAI.SET<T25.ELEMENT>?
where T25.ELEMENT: SDAI.TypeHierarchy.LOGICAL__TypeBehavior,
			U25: SDAI.BooleanType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: SDAI.LOGICAL(rhs))
}

/// Aggregate Union: SET\<Complex\> + Complex = SET
///
public func + <T26: SDAI.TypeHierarchy.SET__TypeBehavior>(
	lhs: T26?, rhs: SDAI.ComplexEntity?) -> SDAI.SET<T26.ELEMENT>?
where T26.ELEMENT: SDAI.Initializable.ByComplexEntity
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

/// Aggregate Union: SET\<Entity\> + Select = SET
///
public func + <T27: SDAI.TypeHierarchy.SET__TypeBehavior, U27: SDAI.SelectType>(
	lhs: T27?, rhs: U27?) -> SDAI.SET<T27.ELEMENT>?
where T27.ELEMENT: SDAI.EntityReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

/// Aggregate Union: SET\<PRef\> + Select = SET
///
public func + <T28: SDAI.TypeHierarchy.SET__TypeBehavior, U28: SDAI.SelectType>(
	lhs: T28?, rhs: U28?) -> SDAI.SET<T28.ELEMENT>?
where T28.ELEMENT: SDAI.PersistentReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

//MARK: Element + Set = Set
/// Aggregate Union: Fundamental + SET\<Fundamental\> = SET
///
public func + <T29: SDAI.GenericType, U29: SDAI.TypeHierarchy.SET__TypeBehavior>(
	lhs: T29?, rhs: U29?) -> SDAI.SET<U29.ELEMENT>?
where T29.FundamentalType == U29.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

/// Aggregate Union: GENERIC + SET\<Generic\> = SET
///
public func + <T30: SDAI.TypeHierarchy.GENERIC__TypeBehavior, U30: SDAI.TypeHierarchy.SET__TypeBehavior>(
	lhs: T30?, rhs: U30?) -> SDAI.SET<U30.ELEMENT>?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

/// Aggregate Union: Real + SET\<NUMBER\> = SET
///
public func + <T31, U31: SDAI.TypeHierarchy.SET__TypeBehavior>(
	lhs: T31?, rhs: U31?) -> SDAI.SET<U31.ELEMENT>?
where T31: SDAI.RealType,
			U31.ELEMENT: SDAI.TypeHierarchy.NUMBER__TypeBehavior
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: SDAI.NUMBER(lhs))
}

/// Aggregate Union: Integer + SET\<REAL\> = SET
///
public func + <T32, U32: SDAI.TypeHierarchy.SET__TypeBehavior>(
	lhs: T32?, rhs: U32?) -> SDAI.SET<U32.ELEMENT>?
where T32: SDAI.IntegerType,
			U32.ELEMENT: SDAI.TypeHierarchy.REAL__TypeBehavior
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: SDAI.REAL(lhs))
}

/// Aggregate Union: Boolean + SET\<LOGICAL\> = SET
///
public func + <T33, U33: SDAI.TypeHierarchy.SET__TypeBehavior>(
	lhs: T33?, rhs: U33?) -> SDAI.SET<U33.ELEMENT>?
where T33: SDAI.BooleanType,
			U33.ELEMENT: SDAI.TypeHierarchy.LOGICAL__TypeBehavior
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: SDAI.LOGICAL(lhs))
}

/// Aggregate Union: Complex + SET\<Complex\> = SET
///
public func + <U34: SDAI.TypeHierarchy.SET__TypeBehavior>(
	lhs: SDAI.ComplexEntity?, rhs: U34?) -> SDAI.SET<U34.ELEMENT>?
where U34.ELEMENT: SDAI.Initializable.ByComplexEntity
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

/// Aggregate Union: Select + SET\<Entity\> = SET
///
public func + <T35: SDAI.SelectType, U35: SDAI.TypeHierarchy.SET__TypeBehavior>(
	lhs: T35?, rhs: U35?) -> SDAI.SET<U35.ELEMENT>?
where U35.ELEMENT: SDAI.EntityReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

/// Aggregate Union: Select + SET\<PRef\> = SET
///
public func + <T36: SDAI.SelectType, U36: SDAI.TypeHierarchy.SET__TypeBehavior>(
	lhs: T36?, rhs: U36?) -> SDAI.SET<U36.ELEMENT>?
where U36.ELEMENT: SDAI.PersistentReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

//MARK: List + List = List
/// Aggregate Union: List + List = List
///
public func + <T37: SDAI.TypeHierarchy.LIST__TypeBehavior, U37: SDAI.ListType>(
	lhs: T37?, rhs: U37?) -> SDAI.LIST<T37.ELEMENT>?
where T37.ELEMENT.FundamentalType == U37.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: rhs)
}

//MARK: List + Element = List
/// Aggregate Union: LIST\<Fundamental\> + Fundamental = List
///
public func + <T38: SDAI.TypeHierarchy.LIST__TypeBehavior, U38: SDAI.GenericType>(
	lhs: T38?, rhs: U38?) -> SDAI.LIST<T38.ELEMENT>?
where T38.ELEMENT.FundamentalType == U38.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: rhs)
}

/// Aggregate Union: LIST\<Generic\> + GENERIC = List
///
public func + <T39: SDAI.TypeHierarchy.LIST__TypeBehavior, U39: SDAI.TypeHierarchy.GENERIC__TypeBehavior>(
	lhs: T39?, rhs: U39?) -> SDAI.LIST<T39.ELEMENT>?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: rhs)
}

/// Aggregate Union: LIST\<NUMBER\> + Real = List
///
public func + <T40: SDAI.TypeHierarchy.LIST__TypeBehavior, U40>(
	lhs: T40?, rhs: U40?) -> SDAI.LIST<T40.ELEMENT>?
where T40.ELEMENT: SDAI.TypeHierarchy.NUMBER__TypeBehavior,
			U40: SDAI.RealType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: SDAI.NUMBER(rhs))
}

/// Aggregate Union: LIST\<REAL\> + Integer = List
///
public func + <T41: SDAI.TypeHierarchy.LIST__TypeBehavior, U41>(
	lhs: T41?, rhs: U41?) -> SDAI.LIST<T41.ELEMENT>?
where T41.ELEMENT: SDAI.TypeHierarchy.REAL__TypeBehavior,
			U41: SDAI.IntegerType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: SDAI.REAL(rhs))
}

/// Aggregate Union: LIST\<LOGICAL\> + Boolean = List
///
public func + <T42: SDAI.TypeHierarchy.LIST__TypeBehavior, U42>(
	lhs: T42?, rhs: U42?) -> SDAI.LIST<T42.ELEMENT>?
where T42.ELEMENT: SDAI.TypeHierarchy.LOGICAL__TypeBehavior,
			U42: SDAI.BooleanType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: SDAI.LOGICAL(rhs))
}

/// Aggregate Union: LIST\<Complex\> + Complex = List
///
public func + <T43: SDAI.TypeHierarchy.LIST__TypeBehavior>(
	lhs: T43?, rhs: SDAI.ComplexEntity?) -> SDAI.LIST<T43.ELEMENT>?
where T43.ELEMENT: SDAI.Initializable.ByComplexEntity
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: rhs)
}

/// Aggregate Union: LIST\<Entity\> + Select = List
///
public func + <T44: SDAI.TypeHierarchy.LIST__TypeBehavior, U44: SDAI.SelectType>(
	lhs: T44?, rhs: U44?) -> SDAI.LIST<T44.ELEMENT>?
where T44.ELEMENT: SDAI.EntityReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: rhs)
}

/// Aggregate Union: LIST\<PRef\> + Select = List
///
public func + <T45: SDAI.TypeHierarchy.LIST__TypeBehavior, U45: SDAI.SelectType>(
	lhs: T45?, rhs: U45?) -> SDAI.LIST<T45.ELEMENT>?
where T45.ELEMENT: SDAI.PersistentReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: rhs)
}

//MARK: Element + List = List
/// Aggregate Union: Fundamental + LIST\<Fundamental\> = List
///
public func + <T46: SDAI.GenericType, U46: SDAI.TypeHierarchy.LIST__TypeBehavior>(
	lhs: T46?, rhs: U46?) -> SDAI.LIST<U46.ELEMENT>?
where T46.FundamentalType == U46.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: lhs)
}

/// Aggregate Union: GENERIC + LIST\<Generic\> = List
///
public func + <T47: SDAI.TypeHierarchy.GENERIC__TypeBehavior, U47: SDAI.TypeHierarchy.LIST__TypeBehavior>(
	lhs: T47?, rhs: U47?) -> SDAI.LIST<U47.ELEMENT>?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: lhs)
}

/// Aggregate Union: Real + LIST\<NUMBER\> = List
///
public func + <T48, U48: SDAI.TypeHierarchy.LIST__TypeBehavior>(
	lhs: T48?, rhs: U48?) -> SDAI.LIST<U48.ELEMENT>?
where T48: SDAI.RealType,
			U48.ELEMENT: SDAI.TypeHierarchy.NUMBER__TypeBehavior
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: SDAI.NUMBER(lhs))
}

/// Aggregate Union: Integer + LIST\<REAL\> = List
///
public func + <T49, U49: SDAI.TypeHierarchy.LIST__TypeBehavior>(
	lhs: T49?, rhs: U49?) -> SDAI.LIST<U49.ELEMENT>?
where T49: SDAI.IntegerType,
			U49.ELEMENT: SDAI.TypeHierarchy.REAL__TypeBehavior
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: SDAI.REAL(lhs))
}

/// Aggregate Union: Boolean + LIST\<LOGICAL\> = List
///
public func + <T50, U50: SDAI.TypeHierarchy.LIST__TypeBehavior>(
	lhs: T50?, rhs: U50?) -> SDAI.LIST<U50.ELEMENT>?
where T50: SDAI.BooleanType,
			U50.ELEMENT: SDAI.TypeHierarchy.LOGICAL__TypeBehavior
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: SDAI.LOGICAL(lhs))
}

/// Aggregate Union: Complex + LIST\<Complex\> = List
///
public func + <U51: SDAI.TypeHierarchy.LIST__TypeBehavior>(
	lhs: SDAI.ComplexEntity?, rhs: U51?) -> SDAI.LIST<U51.ELEMENT>?
where U51.ELEMENT: SDAI.Initializable.ByComplexEntity
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: lhs)
}

/// Aggregate Union: Select + LIST\<Entity\> = List
///
public func + <T52: SDAI.SelectType, U52: SDAI.TypeHierarchy.LIST__TypeBehavior>(
	lhs: T52?, rhs: U52?) -> SDAI.LIST<U52.ELEMENT>?
where U52.ELEMENT: SDAI.EntityReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: lhs)
}

/// Aggregate Union: Select + LIST\<PRef\> = List
///
public func + <T53: SDAI.SelectType, U53: SDAI.TypeHierarchy.LIST__TypeBehavior>(
	lhs: T53?, rhs: U53?) -> SDAI.LIST<U53.ELEMENT>?
where U53.ELEMENT: SDAI.PersistentReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: lhs)
}

//MARK: Bag + Aggregate = Bag
/// Aggregate Union: Bag + Aggregate = BAG
///
public func + <T54: SDAI.TypeHierarchy.BAG__TypeBehavior, U54: SDAI.AggregationInitializer>(
	lhs: T54?, rhs: U54?) -> SDAI.BAG<T54.ELEMENT>?
where T54.ELEMENT.FundamentalType == U54.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

//MARK: Aggregate + Bag = Bag
/// Aggregate Union: Aggregate + Bag = BAG
///
public func + <T55: SDAI.AggregationInitializer, U55: SDAI.TypeHierarchy.BAG__TypeBehavior>(
	lhs: T55?, rhs: U55?) -> SDAI.BAG<U55.ELEMENT>?
where T55.ELEMENT.FundamentalType == U55.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

//MARK: Set + Aggregate = Set
/// Aggregate Union: Set + Aggregate = SET
///
public func + <T56: SDAI.TypeHierarchy.SET__TypeBehavior, U56: SDAI.AggregationInitializer>(
	lhs: T56?, rhs: U56?) -> SDAI.SET<T56.ELEMENT>?
where T56.ELEMENT.FundamentalType == U56.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.unionWith(rhs: rhs)
}

//MARK: Aggregate + Set = Set
/// Aggregate Union: Aggregate + Set = SET
///
public func + <T57: SDAI.AggregationInitializer, U57: SDAI.TypeHierarchy.SET__TypeBehavior>(
	lhs: T57?, rhs: U57?) -> SDAI.SET<U57.ELEMENT>?
where T57.ELEMENT.FundamentalType == U57.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.unionWith(rhs: lhs)
}

//MARK: List + Aggregate = List
/// Aggregate Union: List + Aggregate = List
///
public func + <T58: SDAI.TypeHierarchy.LIST__TypeBehavior, U58: SDAI.AggregationInitializer>(
	lhs: T58?, rhs: U58?) -> SDAI.LIST<T58.ELEMENT>?
where T58.ELEMENT.FundamentalType == U58.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.appendWith(rhs: rhs)
}

//MARK: Aggregate + List = List
/// Aggregate Union: Aggregate + List = List
///
public func + <T59: SDAI.AggregationInitializer, U59: SDAI.TypeHierarchy.LIST__TypeBehavior>(
	lhs: T59?, rhs: U59?) -> SDAI.LIST<U59.ELEMENT>?
where T59.ELEMENT.FundamentalType == U59.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return rhs.prependWith(lhs: lhs)
}






//MARK: - Difference operator (12.6.4)

//MARK: Bag - Bag/Set = Bag
/// Aggregate Difference: Bag - Bag/Set = BAG
///
public func - <T1: SDAI.TypeHierarchy.BAG__TypeBehavior, U1: SDAI.BagType>(
	lhs: T1?, rhs: U1?) -> SDAI.BAG<T1.ELEMENT>?
where T1.ELEMENT.FundamentalType == U1.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

//MARK: Bag - Element = Bag
/// Aggregate Difference: BAG\<Fundamental\> - Fundamental = BAG
///
public func - <T2: SDAI.TypeHierarchy.BAG__TypeBehavior, U2: SDAI.GenericType>(
	lhs: T2?, rhs: U2?) -> SDAI.BAG<T2.ELEMENT>?
where T2.ELEMENT.FundamentalType == U2.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

/// Aggregate Difference: BAG\<Generic\> - GENERIC = BAG
///
public func - <T3: SDAI.TypeHierarchy.BAG__TypeBehavior, U3: SDAI.TypeHierarchy.GENERIC__TypeBehavior>(
	lhs: T3?, rhs: U3?) -> SDAI.BAG<T3.ELEMENT>?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

/// Aggregate Difference: BAG\<NUMBER\> - Real = BAG
///
public func - <T4: SDAI.TypeHierarchy.BAG__TypeBehavior, U4>(
	lhs: T4?, rhs: U4?) -> SDAI.BAG<T4.ELEMENT>?
where T4.ELEMENT: SDAI.TypeHierarchy.NUMBER__TypeBehavior,
			U4: SDAI.RealType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: SDAI.NUMBER(rhs))
}

/// Aggregate Difference: BAG\<REAL\> - Integer = BAG
///
public func - <T5: SDAI.TypeHierarchy.BAG__TypeBehavior, U5>(
	lhs: T5?, rhs: U5?) -> SDAI.BAG<T5.ELEMENT>?
where T5.ELEMENT: SDAI.TypeHierarchy.REAL__TypeBehavior,
			U5: SDAI.IntegerType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: SDAI.REAL(rhs))
}

/// Aggregate Difference: BAG\<LOGICAL\> - Boolean = BAG
///
public func - <T6: SDAI.TypeHierarchy.BAG__TypeBehavior, U6>(
	lhs: T6?, rhs: U6?) -> SDAI.BAG<T6.ELEMENT>?
where T6.ELEMENT: SDAI.TypeHierarchy.LOGICAL__TypeBehavior,
			U6: SDAI.BooleanType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: SDAI.LOGICAL(rhs))
}

/// Aggregate Difference: BAG\<Complex\> - Complex = BAG
///
public func - <T7: SDAI.TypeHierarchy.BAG__TypeBehavior>(
	lhs: T7?, rhs: SDAI.ComplexEntity?) -> SDAI.BAG<T7.ELEMENT>?
where T7.ELEMENT: SDAI.Initializable.ByComplexEntity
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

/// Aggregate Difference: BAG\<Entity\> - Select = BAG
///
public func - <T8: SDAI.TypeHierarchy.BAG__TypeBehavior, U8: SDAI.SelectType>(
	lhs: T8?, rhs: U8?) -> SDAI.BAG<T8.ELEMENT>?
where T8.ELEMENT: SDAI.EntityReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

/// Aggregate Difference: BAG\<PRef\> - Select = BAG
///
public func - <T9: SDAI.TypeHierarchy.BAG__TypeBehavior, U9: SDAI.SelectType>(
	lhs: T9?, rhs: U9?) -> SDAI.BAG<T9.ELEMENT>?
where T9.ELEMENT: SDAI.PersistentReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}


//MARK: Set - Set/Bag = Set
/// Aggregate Difference: Set - Set/Bag = SET
///
public func - <T10: SDAI.TypeHierarchy.SET__TypeBehavior, U10: SDAI.BagType>(
	lhs: T10?, rhs: U10?) -> SDAI.SET<T10.ELEMENT>?
where T10.ELEMENT.FundamentalType == U10.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

//MARK: Set - Element = Set
/// Aggregate Difference: SET\<Fundamental\> - Fundamental = SET
///
public func - <T11: SDAI.TypeHierarchy.SET__TypeBehavior, U11: SDAI.GenericType>(
	lhs: T11?, rhs: U11?) -> SDAI.SET<T11.ELEMENT>?
where T11.ELEMENT.FundamentalType == U11.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

/// Aggregate Difference: SET\<Generic\> - GENERIC = SET
///
public func - <T12: SDAI.TypeHierarchy.SET__TypeBehavior, U12: SDAI.TypeHierarchy.GENERIC__TypeBehavior>(
	lhs: T12?, rhs: U12?) -> SDAI.SET<T12.ELEMENT>?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

/// Aggregate Difference: SET\<NUMBER\> - Real = SET
///
public func - <T13: SDAI.TypeHierarchy.SET__TypeBehavior, U13>(
	lhs: T13?, rhs: U13?) -> SDAI.SET<T13.ELEMENT>?
where T13.ELEMENT: SDAI.TypeHierarchy.NUMBER__TypeBehavior,
			U13: SDAI.RealType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: SDAI.NUMBER(rhs))
}

/// Aggregate Difference: SET\<REAL\> - Integer = SET
///
public func - <T14: SDAI.TypeHierarchy.SET__TypeBehavior, U14>(
	lhs: T14?, rhs: U14?) -> SDAI.SET<T14.ELEMENT>?
where T14.ELEMENT: SDAI.TypeHierarchy.REAL__TypeBehavior,
			U14: SDAI.IntegerType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: SDAI.REAL(rhs))
}

/// Aggregate Difference: SET\<LOGICL\> - Boolean = SET
///
public func - <T15: SDAI.TypeHierarchy.SET__TypeBehavior, U15>(
	lhs: T15?, rhs: U15?) -> SDAI.SET<T15.ELEMENT>?
where T15.ELEMENT: SDAI.TypeHierarchy.LOGICAL__TypeBehavior,
			U15: SDAI.BooleanType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: SDAI.LOGICAL(rhs))
}

/// Aggregate Difference: SET\<Complex\> - Complex = SET
///
public func - <T16: SDAI.TypeHierarchy.SET__TypeBehavior>(
	lhs: T16?, rhs: SDAI.ComplexEntity?) -> SDAI.SET<T16.ELEMENT>?
where T16.ELEMENT: SDAI.Initializable.ByComplexEntity
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

/// Aggregate Difference: SET\<Entity\> - Select = SET
///
public func - <T17: SDAI.TypeHierarchy.SET__TypeBehavior, U17: SDAI.SelectType>(
	lhs: T17?, rhs: U17?) -> SDAI.SET<T17.ELEMENT>?
where T17.ELEMENT: SDAI.EntityReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

/// Aggregate Difference: SET\<PRef\> - Select = SET
///
public func - <T18: SDAI.TypeHierarchy.SET__TypeBehavior, U18: SDAI.SelectType>(
	lhs: T18?, rhs: U18?) -> SDAI.SET<T18.ELEMENT>?
where T18.ELEMENT: SDAI.PersistentReference
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}


//MARK: Bag - Aggregate = Bag
/// Aggregate Difference: Bag - Aggregate = BAG
///
public func - <T19: SDAI.TypeHierarchy.BAG__TypeBehavior, U19: SDAI.AggregationInitializer>(
	lhs: T19?, rhs: U19?) -> SDAI.BAG<T19.ELEMENT>?
where T19.ELEMENT.FundamentalType == U19.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}

//MARK: Set - Aggregate = Set
/// Aggregate Difference: Set - Aggregate = SET
///
public func - <T20: SDAI.TypeHierarchy.SET__TypeBehavior, U20: SDAI.AggregationInitializer>	(
	lhs: T20?, rhs: U20?) -> SDAI.SET<T20.ELEMENT>?
where T20.ELEMENT.FundamentalType == U20.ELEMENT.FundamentalType
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.differenceWith(rhs: rhs)
}



//MARK: - Subset operator (12.6.5)
/// Aggregate Subset: Bag/Set \<= Bag/Set = LOGICAL
///
public func <= <TB: SDAI.BagType, UB: SDAI.BagType>(
  lhs: TB?, rhs: UB?) -> SDAI.LOGICAL
where TB.ELEMENT.FundamentalType == UB.ELEMENT.FundamentalType {
	return rhs >= lhs
}

//MARK: - Superset operator (12.6.6)
/// Aggregate Superset Bag/Set >= Bag/Set = LOGICAL
///
public func >= <TB: SDAI.BagType, UB: SDAI.BagType>(
  lhs: TB?, rhs: UB?) -> SDAI.LOGICAL
where TB.ELEMENT.FundamentalType == UB.ELEMENT.FundamentalType {
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	return SDAI.LOGICAL(lhs.isSuperset(of: rhs))
}
