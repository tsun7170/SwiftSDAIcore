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
public func .===. <T: SDAIArrayOptionalType, U: SDAIArrayOptionalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { 
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
public func .!==. <T: SDAIArrayOptionalType, U: SDAIArrayOptionalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

//MARK: array vs. select
public func .===. <T: SDAIArrayOptionalType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs .===. rhs?.arrayOptionalValue(elementType: SDAI.GENERIC.self) }
public func .!==. <T: SDAIArrayOptionalType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

//MARK: select vs. array
public func .===. <T: SDAISelectType, U: SDAIArrayOptionalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs .===. lhs }
public func .!==. <T: SDAISelectType, U: SDAIArrayOptionalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

//MARK: list vs. list
public func .===. <T: SDAIListType, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { 
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
public func .!==. <T: SDAIListType, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

//MARK: list vs. aggregate
public func .===. <T: SDAIListType, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { 
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
public func .!==. <T: SDAIListType, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

//MARK: aggregate vs. list
public func .===. <T: SDAIAggregationInitializer, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs .===. lhs }
public func .!==. <T: SDAIAggregationInitializer, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }


//MARK: list vs. select
public func .===. <T: SDAIListType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs .===. rhs?.listValue(elementType: SDAI.GENERIC.self) }
public func .!==. <T: SDAIListType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

//MARK: select vs. list
public func .===. <T: SDAISelectType, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs .===. lhs }
public func .!==. <T: SDAISelectType, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

//MARK: (bag or set) vs. (bag or set)
public func .===. <T: SDAIBagType, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { 
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	if SDAI.SIZEOF(lhs) != SDAI.SIZEOF(rhs) { return SDAI.FALSE }

	let lhsDict = lhs.asSwiftDict
	let rhsDict = rhs.asSwiftDict
	for (elem,lhsCount) in lhsDict {
		if let elem = U.ELEMENT.FundamentalType.convert(fromGeneric: elem), let rhsCount = rhsDict[elem] {
			if lhsCount != rhsCount { return SDAI.FALSE }
		}
		else { return SDAI.FALSE }
	}
	return SDAI.TRUE
}
public func .!==. <T: SDAIBagType, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

//MARK: (bag or set) vs. select
public func .===. <T: SDAIBagType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs .===. rhs?.bagValue(elementType: SDAI.GENERIC.self) }
public func .!==. <T: SDAIBagType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

//MARK: select vs. (bag or set)
public func .===. <T: SDAISelectType, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs .===. lhs }
public func .!==. <T: SDAISelectType, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

//MARK: (bag or set) vs. aggregate
public func .===. <T: SDAIBagType, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { 
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	if SDAI.SIZEOF(lhs) != SDAI.SIZEOF(rhs) { return SDAI.FALSE }

	let lhsDict = lhs.asSwiftDict
	let rhsDict = rhs.asSwiftDict
	for (elem,lhsCount) in lhsDict {
		if let elem = U.ELEMENT.FundamentalType.convert(fromGeneric: elem), let rhsCount = rhsDict[elem] {
			if lhsCount != rhsCount { return SDAI.FALSE }
		}
		else { return SDAI.FALSE }
	}
	return SDAI.TRUE
}
public func .!==. <T: SDAIBagType, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

//MARK: aggregate vs. (bag or set)
public func .===. <T: SDAIAggregationInitializer, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs .===. lhs }
public func .!==. <T: SDAIAggregationInitializer, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }
