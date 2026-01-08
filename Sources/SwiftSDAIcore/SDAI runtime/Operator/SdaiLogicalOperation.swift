//
//  SdaiLogicalOperation.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - Logical operators (12.4)

public prefix func ! <T: SDAILogicalType>(logical: T?) -> SDAI.LOGICAL { 
	return !SDAI.LOGICAL(logical)
}
public prefix func ! <T: SDAILogicalType>(logical: T) -> SDAI.LOGICAL { 
	guard let bool = logical.possiblyAsSwiftBool else { return SDAI.UNKNOWN }
	return bool ? SDAI.FALSE : SDAI.TRUE
}

public func && <T: SDAILogicalType, U: SDAILogicalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { 
	return SDAI.LOGICAL(lhs) && SDAI.LOGICAL(rhs)
}
public func && <T: SDAILogicalType, U: SDAILogicalType>(lhs: T , rhs: U?) -> SDAI.LOGICAL { 
	return lhs && SDAI.LOGICAL(rhs)
}
public func && <T: SDAILogicalType, U: SDAILogicalType>(lhs: T?, rhs: U ) -> SDAI.LOGICAL { 
	return SDAI.LOGICAL(lhs) && rhs
}
/// master _logical and_ operator for the SDAILogicalType
/// - TRUE && TRUE -> TRUE
/// - TRUE && UNKNOWN -> UNKNOWN
/// - TRUE && FALSE -> FALSE
/// - UNKNOWN && UNKNOWN -> UNKNOWN
/// - UNKNOWN && FALSE -> FALSE
/// - FALSE && FALSE -> FALSE
///
/// - Parameters:
///   - lhs: logical value
///   - rhs: logical value
/// - Returns: lhs && rhs value
///
public func && <T: SDAILogicalType, U: SDAILogicalType>(lhs: T , rhs: U ) -> SDAI.LOGICAL {
	let lhs = SDAI.cardinal(logical: lhs)
	let rhs = SDAI.cardinal(logical: rhs)
	return SDAI.LOGICAL(fromCardinal: min(lhs,rhs) )
}


public func || <T: SDAILogicalType, U: SDAILogicalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { 
	return SDAI.LOGICAL(lhs) || SDAI.LOGICAL(rhs)
}
public func || <T: SDAILogicalType, U: SDAILogicalType>(lhs: T , rhs: U?) -> SDAI.LOGICAL { 
	return lhs || SDAI.LOGICAL(rhs)
}
public func || <T: SDAILogicalType, U: SDAILogicalType>(lhs: T?, rhs: U ) -> SDAI.LOGICAL { 
	return SDAI.LOGICAL(lhs) || rhs
}
/// master _logical or_ operator for the SDAILogicalType
/// - TRUE || TRUE -> TRUE
/// - TRUE || UNKNOWN -> TRUE
/// - TRUE || FALSE -> TRUE
/// - UNKNOWN || UNKNOWN -> UNKNOWN
/// - UNKNOWN || FALSE -> UNKNOWN
/// - FALSE || FALSE -> FALSE
///
/// - Parameters:
///   - lhs: logical value
///   - rhs: logical value
/// - Returns: lhs || rhs value
/// 
public func || <T: SDAILogicalType, U: SDAILogicalType>(lhs: T , rhs: U ) -> SDAI.LOGICAL {
	let lhs = SDAI.cardinal(logical: lhs)
	let rhs = SDAI.cardinal(logical: rhs)
	return SDAI.LOGICAL(fromCardinal: max(lhs,rhs) )
}
