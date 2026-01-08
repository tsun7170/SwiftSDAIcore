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
public func .==. <T: SDAIArrayOptionalType, U: SDAIArrayOptionalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { 
	return SDAI.LOGICAL( lhs?.value.isValueEqualOptionally(to: rhs?.value) )
}
public func .!=. <T: SDAIArrayOptionalType, U: SDAIArrayOptionalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .==. rhs) }

//MARK: array vs. select
public func .==. <T: SDAIArrayOptionalType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs .==. rhs?.arrayOptionalValue(elementType: SDAI.GENERIC.self) }
public func .!=. <T: SDAIArrayOptionalType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .==. rhs) }

//MARK: select vs. array
public func .==. <T: SDAISelectType, U: SDAIArrayOptionalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs .==. lhs }
public func .!=. <T: SDAISelectType, U: SDAIArrayOptionalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .==. rhs) }


//MARK: list vs. list
public func .==. <T: SDAIListType, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { 
	return SDAI.LOGICAL( lhs?.value.isValueEqualOptionally(to: rhs?.value) )
}
public func .!=. <T: SDAIListType, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .==. rhs) }

//MARK: list vs. aggregate
public func .==. <T: SDAIListType, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { 
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
public func .!=. <T: SDAIListType, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .==. rhs) }

//MARK: aggregate vs. list
public func .==. <T: SDAIAggregationInitializer, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs .==. lhs }
public func .!=. <T: SDAIAggregationInitializer, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .==. rhs) }

//MARK: list vs. select
public func .==. <T: SDAIListType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs .==. rhs?.listValue(elementType: SDAI.GENERIC.self) }
public func .!=. <T: SDAIListType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .==. rhs) }

//MARK: select vs. list
public func .==. <T: SDAISelectType, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs .==. lhs }
public func .!=. <T: SDAISelectType, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .==. rhs) }


//MARK: (bag or set) vs. (bag or set)
public func .==. <T: SDAIBagType, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { 
	return SDAI.LOGICAL( lhs?.value.isValueEqualOptionally(to: rhs?.value) )
}
public func .!=. <T: SDAIBagType, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .==. rhs) }

//MARK: (bag or set) vs. select
public func .==. <T: SDAIBagType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs .==. rhs?.bagValue(elementType: SDAI.GENERIC.self) }
public func .!=. <T: SDAIBagType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .==. rhs) }

//MARK: select vs. (bag or set)
public func .==. <T: SDAISelectType, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs .==. lhs }
public func .!=. <T: SDAISelectType, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .==. rhs) }

//MARK: (bag or set) vs. aggregate
public func .==. <T: SDAIBagType, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { 
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	if SDAI.SIZEOF(lhs) != SDAI.SIZEOF(rhs) { return SDAI.FALSE }

	let lhsDict = lhs.asValueDict
	let rhsDict = rhs.asValueDict
	for (elem,lhsCount) in lhsDict {
		if let elem = (elem as Any) as? U.ELEMENT.Value, let rhsCount = rhsDict[elem] {
			if lhsCount != rhsCount { return SDAI.FALSE }
		}
		else { return SDAI.FALSE }
	}
	return SDAI.TRUE
}
public func .!=. <T: SDAIBagType, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .==. rhs) }

//MARK: aggregate vs. (bag or set)
public func .==. <T: SDAIAggregationInitializer, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs .==. lhs }
public func .!=. <T: SDAIAggregationInitializer, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .==. rhs) }
