//
//  File.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//

import Foundation

//MARK: - Binary comparisons
public func .==. <T: SDAIBinaryType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAIBinaryType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >    <T: SDAIBinaryType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <    <T: SDAIBinaryType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >=   <T: SDAIBinaryType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <=   <T: SDAIBinaryType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .==. <T: SDAIBinaryType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAIBinaryType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }
public func >    <T: SDAIBinaryType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }
public func <    <T: SDAIBinaryType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }
public func >=   <T: SDAIBinaryType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }
public func <=   <T: SDAIBinaryType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }

public func .==. <U: SDAIBinaryType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <U: SDAIBinaryType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >    <U: SDAIBinaryType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <    <U: SDAIBinaryType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >=   <U: SDAIBinaryType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <=   <U: SDAIBinaryType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

