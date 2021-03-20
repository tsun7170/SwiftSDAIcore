//
//  File.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//

import Foundation

//MARK: - Logical operators (12.4)

public prefix func ! <T: SDAILogicalType>(logical: T?) -> SDAI.LOGICAL { 
	guard let logical = logical else { return SDAI.UNKNOWN }
	return !logical
}
public prefix func ! <T: SDAILogicalType>(logical: T) -> SDAI.LOGICAL { 
	guard let bool = logical.possiblyAsSwiftBool else { return SDAI.UNKNOWN }
	return bool ? SDAI.FALSE : SDAI.TRUE
}

public func && <T: SDAILogicalType, U: SDAILogicalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { 
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	return lhs && rhs
}
public func && <T: SDAILogicalType, U: SDAILogicalType>(lhs: T , rhs: U?) -> SDAI.LOGICAL { 
	guard let rhs = rhs else { return SDAI.UNKNOWN }
	return lhs && rhs
}
public func && <T: SDAILogicalType, U: SDAILogicalType>(lhs: T?, rhs: U ) -> SDAI.LOGICAL { 
	guard let lhs = lhs else { return SDAI.UNKNOWN }
	return lhs && rhs
}
public func && <T: SDAILogicalType, U: SDAILogicalType>(lhs: T , rhs: U ) -> SDAI.LOGICAL { 
	let lhs = SDAI.cardinal(logical: lhs)
	let rhs = SDAI.cardinal(logical: rhs)
	return SDAI.LOGICAL(fromCardinal: min(lhs,rhs) )
}


public func || <T: SDAILogicalType, U: SDAILogicalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { 
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	return lhs || rhs
}
public func || <T: SDAILogicalType, U: SDAILogicalType>(lhs: T , rhs: U?) -> SDAI.LOGICAL { 
	guard let rhs = rhs else { return SDAI.UNKNOWN }
	return lhs || rhs
}
public func || <T: SDAILogicalType, U: SDAILogicalType>(lhs: T?, rhs: U ) -> SDAI.LOGICAL { 
	guard let lhs = lhs else { return SDAI.UNKNOWN }
	return lhs || rhs
}
public func || <T: SDAILogicalType, U: SDAILogicalType>(lhs: T , rhs: U ) -> SDAI.LOGICAL { 
	let lhs = SDAI.cardinal(logical: lhs)
	let rhs = SDAI.cardinal(logical: rhs)
	return SDAI.LOGICAL(fromCardinal: max(lhs,rhs) )
}
