//
//  File.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//

import Foundation

//MARK: - Binary concatenation operator
public func + <T: SDAIBinaryType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.BINARY? { abstruct() }
public func + <T: SDAIBinaryType>(lhs: T?, rhs: String?) -> SDAI.BINARY? { abstruct() }
public func + <U: SDAIBinaryType>(lhs: String?, rhs: U?) -> SDAI.BINARY? { abstruct() }
