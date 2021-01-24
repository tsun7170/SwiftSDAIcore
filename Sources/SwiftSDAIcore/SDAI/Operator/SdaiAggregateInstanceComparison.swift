//
//  File.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//

import Foundation

//MARK: - Aggregate instance comparison
public func .===. <T: SDAIArrayOptionalType, U: SDAIArrayOptionalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!==. <T: SDAIArrayOptionalType, U: SDAIArrayOptionalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .===. <T: SDAIListType, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!==. <T: SDAIListType, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .===. <T: SDAIBagType, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!==. <T: SDAIBagType, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
