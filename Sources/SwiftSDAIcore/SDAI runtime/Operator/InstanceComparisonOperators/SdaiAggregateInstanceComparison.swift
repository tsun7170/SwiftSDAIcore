//
//  SdaiAggregateInstanceComparison.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - Aggregate instance comparison (12.2.2.1)

//MARK: array vs. array
/// Aggregate Instance Equal: Array .===. Array = LOGICAL
///
public func .===. <TA: SDAIArrayOptionalType, UA: SDAIArrayOptionalType>(
  lhs: TA?, rhs: UA?) -> SDAI.LOGICAL
{
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	if SDAI.SIZEOF(lhs) != SDAI.SIZEOF(rhs) { return SDAI.FALSE }
	if lhs.loIndex != rhs.loIndex { return SDAI.FALSE }

	var result = SDAI.TRUE
	for idx in lhs.loIndex ... lhs.hiIndex {
		let comp = SDAI.GENERIC(lhs[idx]) .===. SDAI.GENERIC(rhs[idx])
		if comp == SDAI.FALSE { return SDAI.FALSE }
		if comp == SDAI.UNKNOWN { result = SDAI.UNKNOWN }		
	}
	return result
}

/// Aggregate Instance NotEqual: Array .!==. Array = LOGICAL
///
public func .!==. <TA: SDAIArrayOptionalType, UA: SDAIArrayOptionalType>(
  lhs: TA?, rhs: UA?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }

//MARK: array vs. select
/// Aggregate Instance Equal: Array .===. Select = LOGICAL
///
public func .===. <TA: SDAIArrayOptionalType, US: SDAISelectType>(
  lhs: TA?, rhs: US?) -> SDAI.LOGICAL
{ lhs .===. rhs?.arrayOptionalValue(elementType: SDAI.GENERIC.self) }

public func .!==. <TA: SDAIArrayOptionalType, US: SDAISelectType>(
  lhs: TA?, rhs: US?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


//MARK: select vs. array
/// Aggregate Instance Equal: Select .===. Array = LOGICAL
///
public func .===. <TS: SDAISelectType, UA: SDAIArrayOptionalType>(
  lhs: TS?, rhs: UA?) -> SDAI.LOGICAL
{ rhs .===. lhs }

/// Aggregate Instance NotEqual: Select .!==. Array = LOGICAL
///
public func .!==. <TS: SDAISelectType, UA: SDAIArrayOptionalType>(
  lhs: TS?, rhs: UA?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


//MARK: list vs. list
/// Aggregate Instance Equal: List .===. List = LOGICAL
///
public func .===. <TL: SDAIListType, UL: SDAIListType>(
  lhs: TL?, rhs: UL?) -> SDAI.LOGICAL
{
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	if SDAI.SIZEOF(lhs) != SDAI.SIZEOF(rhs) { return SDAI.FALSE }

	var result = SDAI.TRUE
	for idx in lhs.loIndex ... lhs.hiIndex {
		let comp = SDAI.GENERIC(lhs[idx]) .===. SDAI.GENERIC(rhs[idx])
		if comp == SDAI.FALSE { return SDAI.FALSE }
		if comp == SDAI.UNKNOWN { result = SDAI.UNKNOWN }		
	}
	return result
}

/// Aggregate Instance NotEqual: List .!==. List = LOGICAL
///
public func .!==. <TL: SDAIListType, UL: SDAIListType>(
  lhs: TL?, rhs: UL?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


//MARK: list vs. aggregate
/// Aggregate Instance Equal: List .===. Aggregate = LOGICAL
///
public func .===. <TL: SDAIListType, UG: SDAIAggregationInitializer>(
  lhs: TL?, rhs: UG?) -> SDAI.LOGICAL
{
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	if SDAI.SIZEOF(lhs) != SDAI.SIZEOF(rhs) { return SDAI.FALSE }

	var result = SDAI.TRUE
	for (i, rhsElem) in rhs.asAggregationSequence.enumerated() {
		let comp = SDAI.GENERIC(lhs[i+1]) .===. SDAI.GENERIC(rhsElem)
		if comp == SDAI.FALSE { return SDAI.FALSE }
		if comp == SDAI.UNKNOWN { result = SDAI.UNKNOWN }		
	}
	return result
}

/// Aggregate Instance NotEqual: List .!==. Aggregate = LOGICAL
///
public func .!==. <TL: SDAIListType, UG: SDAIAggregationInitializer>(
  lhs: TL?, rhs: UG?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


//MARK: aggregate vs. list
/// Aggregate Instance Equal: Aggregate .===. List = LOGICAL
///
public func .===. <TG: SDAIAggregationInitializer, UL: SDAIListType>(
  lhs: TG?, rhs: UL?) -> SDAI.LOGICAL
{ rhs .===. lhs }

/// Aggregate Instance NotEqual: Aggregate .!==. List = LOGICAL
///
public func .!==. <TG: SDAIAggregationInitializer, UL: SDAIListType>(
  lhs: TG?, rhs: UL?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


//MARK: list vs. select
/// Aggregate Instance Equal: List .===. Select = LOGICAL
///
public func .===. <TL: SDAIListType, US: SDAISelectType>(
  lhs: TL?, rhs: US?) -> SDAI.LOGICAL
{ lhs .===. rhs?.listValue(elementType: SDAI.GENERIC.self) }

/// Aggregate Instance NotEqual: List .!==. Select = LOGICAL
///
public func .!==. <TL: SDAIListType, US: SDAISelectType>(
  lhs: TL?, rhs: US?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


//MARK: select vs. list
/// Aggregate Instance Equal: Select .===. List = LOGICAL
///
public func .===. <TS: SDAISelectType, UL: SDAIListType>(
  lhs: TS?, rhs: UL?) -> SDAI.LOGICAL
{ rhs .===. lhs }

/// Aggregate Instance NotEqual: Select .!==. List = LOGICAL
///
public func .!==. <TS: SDAISelectType, UL: SDAIListType>(
  lhs: TS?, rhs: UL?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


//MARK: (bag or set) vs. (bag or set)
/// Aggregate Instance Equal: Bag/Set .===. Bag/Set = LOGICAL
///
public func .===. <TB: SDAIBagType, UB: SDAIBagType>(
  lhs: TB?, rhs: UB?) -> SDAI.LOGICAL
{
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	if SDAI.SIZEOF(lhs) != SDAI.SIZEOF(rhs) { return SDAI.FALSE }

	let lhsDict = lhs.asSwiftDict
	let rhsDict = rhs.asSwiftDict
	for (elem,lhsCount) in lhsDict {
		if let elem = UB.ELEMENT.FundamentalType.convert(fromGeneric: elem), let rhsCount = rhsDict[elem] {
			if lhsCount != rhsCount { return SDAI.FALSE }
		}
		else { return SDAI.FALSE }
	}
	return SDAI.TRUE
}

/// Aggregate Instance NotEqual: Bag/Set .!==. Bag/Set = LOGICAL
///
public func .!==. <TB: SDAIBagType, UB: SDAIBagType>(
  lhs: TB?, rhs: UB?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


//MARK: (bag or set) vs. select
/// Aggregate Instance Equal: Bag/Set .===. Select = LOGICAL
///
public func .===. <TB: SDAIBagType, US: SDAISelectType>(
  lhs: TB?, rhs: US?) -> SDAI.LOGICAL
{ lhs .===. rhs?.bagValue(elementType: SDAI.GENERIC.self) }

/// Aggregate Instance NotEqual: Bag/Set .!==. Select = LOGICAL
///
public func .!==. <TB: SDAIBagType, US: SDAISelectType>(
  lhs: TB?, rhs: US?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


//MARK: select vs. (bag or set)
/// Aggregate Instance Equal: Select .===. Bag/Set = LOGICAL
///
public func .===. <TS: SDAISelectType, UB: SDAIBagType>(
  lhs: TS?, rhs: UB?) -> SDAI.LOGICAL
{ rhs .===. lhs }

/// Aggregate Instance NotEqual: Select .!==. Bag/Set = LOGICAL
///
public func .!==. <TS: SDAISelectType, UB: SDAIBagType>(
  lhs: TS?, rhs: UB?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


//MARK: (bag or set) vs. aggregate
/// Aggregate Instance Equal: Bag/Set .===. Aggregate = LOGICAL
///
public func .===. <TB: SDAIBagType, UG: SDAIAggregationInitializer>(
  lhs: TB?, rhs: UG?) -> SDAI.LOGICAL
{
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	if SDAI.SIZEOF(lhs) != SDAI.SIZEOF(rhs) { return SDAI.FALSE }

	let lhsDict = lhs.asSwiftDict
	let rhsDict = rhs.asSwiftDict
	for (elem,lhsCount) in lhsDict {
		if let elem = UG.ELEMENT.FundamentalType.convert(fromGeneric: elem), let rhsCount = rhsDict[elem] {
			if lhsCount != rhsCount { return SDAI.FALSE }
		}
		else { return SDAI.FALSE }
	}
	return SDAI.TRUE
}

/// Aggregate Instance NotEqual: Bag/Set .!==. Aggregate = LOGICAL
///
public func .!==. <TB: SDAIBagType, UG: SDAIAggregationInitializer>(
  lhs: TB?, rhs: UG?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


//MARK: aggregate vs. (bag or set)
/// Aggregate Instance Equal: Aggregatet .===. Bag/Set = LOGICAL
///
public func .===. <TG: SDAIAggregationInitializer, UB: SDAIBagType>(
  lhs: TG?, rhs: UB?) -> SDAI.LOGICAL
{ rhs .===. lhs }

/// Aggregate Instance NotEqual: Aggregate .!==. Bag/Set = LOGICAL
///
public func .!==. <TG: SDAIAggregationInitializer, UB: SDAIBagType>(
  lhs: TG?, rhs: UB?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }
