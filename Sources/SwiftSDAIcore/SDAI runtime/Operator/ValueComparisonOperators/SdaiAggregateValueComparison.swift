//
//  SdaiAggregateValueComparison.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - Aggregate value comparisons (12.2.1.6)

//MARK: array vs. array
/// Aggregate Value Equal: Array .==. Array = LOGICAL
///
public func .==. <TA: SDAI.ArrayOptionalType, UA: SDAI.ArrayOptionalType>(
  lhs: TA?, rhs: UA?) -> SDAI.LOGICAL
{
	return SDAI.LOGICAL( lhs?.value.isValueEqualOptionally(to: rhs?.value) )
}

/// Aggregate Value NotEqual: Array .!=. Array = LOGICAL
///
public func .!=. <TA: SDAI.ArrayOptionalType, UA: SDAI.ArrayOptionalType>(
  lhs: TA?, rhs: UA?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }


//MARK: array vs. select
/// Aggregate Value Equal: Array .==. Select = LOGICAL
///
public func .==. <TA: SDAI.ArrayOptionalType, US: SDAI.SelectType>(
  lhs: TA?, rhs: US?) -> SDAI.LOGICAL
{ lhs .==. rhs?.arrayOptionalValue(elementType: SDAI.GENERIC.self) }

/// Aggregate Value NotEqual: Array .==. Select = LOGICAL
///
public func .!=. <TA: SDAI.ArrayOptionalType, US: SDAI.SelectType>(
  lhs: TA?, rhs: US?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }


//MARK: select vs. array
/// Aggregate Value Equal: Select .==. Array = LOGICAL
///
public func .==. <TS: SDAI.SelectType, UA: SDAI.ArrayOptionalType>(
  lhs: TS?, rhs: UA?) -> SDAI.LOGICAL
{ rhs .==. lhs }

/// Aggregate Value NotEqual: Select .==. Array = LOGICAL
///
public func .!=. <TS: SDAI.SelectType, UA: SDAI.ArrayOptionalType>(
  lhs: TS?, rhs: UA?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }


//MARK: list vs. list
/// Aggregate Value Equal: List .==. List = LOGICAL
///
public func .==. <TL: SDAI.ListType, UL: SDAI.ListType>(
  lhs: TL?, rhs: UL?) -> SDAI.LOGICAL
{
	return SDAI.LOGICAL( lhs?.value.isValueEqualOptionally(to: rhs?.value) )
}

/// Aggregate Value NotEqual: List .==. List = LOGICAL
///
public func .!=. <TL: SDAI.ListType, UL: SDAI.ListType>(
  lhs: TL?, rhs: UL?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }


//MARK: list vs. aggregate
/// Aggregate Value Equal: List .==. Aggregate = LOGICAL
///
public func .==. <TL: SDAI.ListType, UG: SDAI.AggregationInitializer>(
  lhs: TL?, rhs: UG?) -> SDAI.LOGICAL
{
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	if SDAI.SIZEOF(lhs) != SDAI.SIZEOF(rhs) { return SDAI.FALSE }

	var result = SDAI.TRUE
	for (i, rhsElem) in rhs.asAggregationSequence.enumerated() {
		let comp = SDAI.GENERIC(lhs[i+1]) .==. SDAI.GENERIC(rhsElem)
		if comp == SDAI.FALSE { return SDAI.FALSE }
		if comp == SDAI.UNKNOWN { result = SDAI.UNKNOWN }		
	}
	return result
}

/// Aggregate Value NotEqual: List .==. Aggregate = LOGICAL
///
public func .!=. <TL: SDAI.ListType, UG: SDAI.AggregationInitializer>(
  lhs: TL?, rhs: UG?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }


//MARK: aggregate vs. list
/// Aggregate Value Equal: Aggregate .==. List = LOGICAL
///
public func .==. <TG: SDAI.AggregationInitializer, UL: SDAI.ListType>(
  lhs: TG?, rhs: UL?) -> SDAI.LOGICAL
{ rhs .==. lhs }

/// Aggregate Value NotEqual: Aggregate .==. List = LOGICAL
///
public func .!=. <TG: SDAI.AggregationInitializer, UL: SDAI.ListType>(
  lhs: TG?, rhs: UL?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }


//MARK: list vs. select
/// Aggregate Value Equal: List .==. Select = LOGICAL
///
public func .==. <TL: SDAI.ListType, US: SDAI.SelectType>(
  lhs: TL?, rhs: US?) -> SDAI.LOGICAL
{ lhs .==. rhs?.listValue(elementType: SDAI.GENERIC.self) }

/// Aggregate Value NotEqual: List .==. Select = LOGICAL
///
public func .!=. <TL: SDAI.ListType, US: SDAI.SelectType>(
  lhs: TL?, rhs: US?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }


//MARK: select vs. list
/// Aggregate Value Equal: Select .==. List = LOGICAL
///
public func .==. <TS: SDAI.SelectType, UL: SDAI.ListType>(
  lhs: TS?, rhs: UL?) -> SDAI.LOGICAL
{ rhs .==. lhs }

/// Aggregate Value NotEqual: Select .==. List = LOGICAL
///
public func .!=. <TS: SDAI.SelectType, UL: SDAI.ListType>(
  lhs: TS?, rhs: UL?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }


//MARK: (bag or set) vs. (bag or set)
/// Aggregate Value Equal: Bag/Set .==. Bag/Set = LOGICAL
///
public func .==. <TB: SDAI.BagType, UB: SDAI.BagType>(
  lhs: TB?, rhs: UB?) -> SDAI.LOGICAL
{
	return SDAI.LOGICAL( lhs?.value.isValueEqualOptionally(to: rhs?.value) )
}

/// Aggregate Value NotEqual: Bag/Set .==. Bag/Set = LOGICAL
///
public func .!=. <TB: SDAI.BagType, UB: SDAI.BagType>(
  lhs: TB?, rhs: UB?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }


//MARK: (bag or set) vs. select
/// Aggregate Value Equal: Bag/Set .==. Select = LOGICAL
///
public func .==. <TB: SDAI.BagType, US: SDAI.SelectType>(
  lhs: TB?, rhs: US?) -> SDAI.LOGICAL
{ lhs .==. rhs?.bagValue(elementType: SDAI.GENERIC.self) }

/// Aggregate Value NotEqual: Bag/Set .==. Select = LOGICAL
///
public func .!=. <TB: SDAI.BagType, US: SDAI.SelectType>(
  lhs: TB?, rhs: US?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }


//MARK: select vs. (bag or set)
/// Aggregate Value Equal: Select .==. Bag/Set = LOGICAL
///
public func .==. <TS: SDAI.SelectType, UB: SDAI.BagType>(
  lhs: TS?, rhs: UB?) -> SDAI.LOGICAL
{ rhs .==. lhs }

/// Aggregate Value NotEqual: Select .==. Bag/Set = LOGICAL
///
public func .!=. <TS: SDAI.SelectType, UB: SDAI.BagType>(
  lhs: TS?, rhs: UB?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }


//MARK: (bag or set) vs. aggregate
/// Aggregate Value Equal: Bag/Set .==. Aggregate = LOGICAL
///
public func .==. <TB: SDAI.BagType, UG: SDAI.AggregationInitializer>(
  lhs: TB?, rhs: UG?) -> SDAI.LOGICAL
{
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	if SDAI.SIZEOF(lhs) != SDAI.SIZEOF(rhs) { return SDAI.FALSE }

	let lhsDict = lhs.asValueDict
	let rhsDict = rhs.asValueDict
	for (elem,lhsCount) in lhsDict {
		if let elem = (elem as Any) as? UG.ELEMENT.Value, let rhsCount = rhsDict[elem] {
			if lhsCount != rhsCount { return SDAI.FALSE }
		}
		else { return SDAI.FALSE }
	}
	return SDAI.TRUE
}

/// Aggregate Value NotEqual: Bag/Set .==. Aggregate = LOGICAL
///
public func .!=. <TB: SDAI.BagType, UG: SDAI.AggregationInitializer>(
  lhs: TB?, rhs: UG?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }


//MARK: aggregate vs. (bag or set)
/// Aggregate Value Equal: Aggregate .==. Bag/Set = LOGICAL
///
public func .==. <TG: SDAI.AggregationInitializer, UB: SDAI.BagType>(
  lhs: TG?, rhs: UB?) -> SDAI.LOGICAL
{ rhs .==. lhs }

/// Aggregate Value NotEqual: Aggregate .==. Bag/Set = LOGICAL
///
public func .!=. <TG: SDAI.AggregationInitializer, UB: SDAI.BagType>(
  lhs: TG?, rhs: UB?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }
