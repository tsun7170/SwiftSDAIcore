//
//  File.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//

import Foundation

//MARK: - String concatenation operator (12.5.2)

public func + <T: SDAI__STRING__type, U: SDAI__STRING__type>(lhs: T?, rhs: U?) -> SDAI.STRING? { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return SDAI.STRING( lhs.asSwiftType + rhs.asSwiftType )
}
public func + <T: SDAI__STRING__type, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.STRING? { lhs + rhs?.stringValue }
public func + <T: SDAISelectType, U: SDAI__STRING__type>(lhs: T?, rhs: U?) -> SDAI.STRING? { lhs?.stringValue + rhs }
public func + <T: SDAI__STRING__type>(lhs: T?, rhs: String?) -> SDAI.STRING? { lhs + SDAI.STRING(rhs) }
public func + <U: SDAI__STRING__type>(lhs: String?, rhs: U?) -> SDAI.STRING? { SDAI.STRING(lhs) + rhs }
