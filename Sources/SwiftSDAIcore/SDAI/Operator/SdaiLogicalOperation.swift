//
//  File.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//

import Foundation

//MARK: - Logical operators
public prefix func ! <T: SDAILogicalType>(logical: T?) -> SDAI.LOGICAL { abstruct() }

public func && <T: SDAILogicalType, U: SDAILogicalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func || <T: SDAILogicalType, U: SDAILogicalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
