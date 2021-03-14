//
//  File.swift
//  
//
//  Created by Yoshida on 2021/01/23.
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
		let comp = SDAI.GENERIC(lhs[idx]) .===. rhs[idx]
		if comp == SDAI.FALSE { return SDAI.FALSE }
		if comp == SDAI.UNKNOWN { result = SDAI.UNKNOWN }		
	}
	return result
}
public func .!==. <T: SDAIArrayOptionalType, U: SDAIArrayOptionalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

//MARK: list vs. list
public func .===. <T: SDAIListType, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { 
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	if SDAI.SIZEOF(lhs) != SDAI.SIZEOF(rhs) { return SDAI.FALSE }

	var result = SDAI.TRUE
	for idx in lhs.loIndex ... lhs.hiIndex {
		let comp = SDAI.GENERIC(lhs[idx]) .===. rhs[idx]
		if comp == SDAI.FALSE { return SDAI.FALSE }
		if comp == SDAI.UNKNOWN { result = SDAI.UNKNOWN }		
	}
	return result
}
public func .!==. <T: SDAIListType, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

//MARK: bag vs. bag, set vs. set, bag vs. set, set vs. bag
public func .===. <T: SDAIBagType, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { 
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	if SDAI.SIZEOF(lhs) != SDAI.SIZEOF(rhs) { return SDAI.FALSE }

	let lhsDict = lhs.asSwiftDict
	let rhsDict = rhs.asSwiftDict
	for (elem,lhsCount) in lhsDict {
		if let elem = U.ELEMENT.FundamentalType(fromGeneric: elem), let rhsCount = rhsDict[elem] {
			if lhsCount != rhsCount { return SDAI.FALSE }
		}
		else { return SDAI.FALSE }
	}
	return SDAI.TRUE
}
public func .!==. <T: SDAIBagType, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }
