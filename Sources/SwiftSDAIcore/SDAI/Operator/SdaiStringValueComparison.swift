//
//  File.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//

import Foundation

//MARK: - String comparisons
public func .==. <T: SDAIStringType, U: SDAIStringType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAIStringType, U: SDAIStringType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >    <T: SDAIStringType, U: SDAIStringType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <    <T: SDAIStringType, U: SDAIStringType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >=   <T: SDAIStringType, U: SDAIStringType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <=   <T: SDAIStringType, U: SDAIStringType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .==. <T: SDAIStringType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAIStringType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }
public func >    <T: SDAIStringType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }
public func <    <T: SDAIStringType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }
public func >=   <T: SDAIStringType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }
public func <=   <T: SDAIStringType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }

public func .==. <U: SDAIStringType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <U: SDAIStringType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >    <U: SDAIStringType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <    <U: SDAIStringType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >=   <U: SDAIStringType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <=   <U: SDAIStringType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }


public func .==. <T: SDAISelectType, U: SDAIStringType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAISelectType, U: SDAIStringType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >    <T: SDAISelectType, U: SDAIStringType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <    <T: SDAISelectType, U: SDAIStringType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >=   <T: SDAISelectType, U: SDAIStringType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <=   <T: SDAISelectType, U: SDAIStringType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .==. <T: SDAIStringType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAIStringType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >    <T: SDAIStringType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <    <T: SDAIStringType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >=   <T: SDAIStringType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <=   <T: SDAIStringType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .==. <T: SDAISelectType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAISelectType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }
public func >    <T: SDAISelectType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }
public func <    <T: SDAISelectType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }
public func >=   <T: SDAISelectType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }
public func <=   <T: SDAISelectType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }

public func .==. <U: SDAISelectType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <U: SDAISelectType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >    <U: SDAISelectType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <    <U: SDAISelectType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >=   <U: SDAISelectType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <=   <U: SDAISelectType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
