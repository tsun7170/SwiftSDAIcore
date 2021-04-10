//
//  File.swift
//  
//
//  Created by Yoshida on 2021/01/23.
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
public func || <T: SDAILogicalType, U: SDAILogicalType>(lhs: T , rhs: U ) -> SDAI.LOGICAL { 
	let lhs = SDAI.cardinal(logical: lhs)
	let rhs = SDAI.cardinal(logical: rhs)
	return SDAI.LOGICAL(fromCardinal: max(lhs,rhs) )
}
