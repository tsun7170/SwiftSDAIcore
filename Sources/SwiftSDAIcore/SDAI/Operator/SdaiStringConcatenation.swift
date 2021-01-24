//
//  File.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//

import Foundation

//MARK: - String concatenation operator
public func + <T: SDAIStringType, U: SDAIStringType>(lhs: T?, rhs: U?) -> SDAI.STRING? { abstruct() }
public func + <T: SDAIStringType>(lhs: T?, rhs: String?) -> SDAI.STRING? { abstruct() }
public func + <U: SDAIStringType>(lhs: String?, rhs: U?) -> SDAI.STRING? { abstruct() }
