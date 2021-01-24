//
//  File.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//

import Foundation

//MARK: - Entity value comparisons
public func .==. (lhs: SDAI.EntityReference?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL { abstruct() }
public func .!=. (lhs: SDAI.EntityReference?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL { abstruct() }

public func .==. <U: SDAISelectType>(lhs: SDAI.EntityReference?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <U: SDAISelectType>(lhs: SDAI.EntityReference?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .==. (lhs: SDAI.EntityReference?, rhs: SDAI.PartialEntity?) -> SDAI.LOGICAL { abstruct() }
public func .!=. (lhs: SDAI.EntityReference?, rhs: SDAI.PartialEntity?) -> SDAI.LOGICAL { abstruct() }


//public func .==. <T: SDAISelectType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
//public func .!=. <T: SDAISelectType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .==. <T: SDAISelectType>(lhs: T?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAISelectType>(lhs: T?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL { abstruct() }

public func .==. <T: SDAISelectType>(lhs: T?, rhs: SDAI.PartialEntity?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAISelectType>(lhs: T?, rhs: SDAI.PartialEntity?) -> SDAI.LOGICAL { abstruct() }


public func .==. (lhs: SDAI.PartialEntity?, rhs: SDAI.PartialEntity?) -> SDAI.LOGICAL { abstruct() }
public func .!=. (lhs: SDAI.PartialEntity?, rhs: SDAI.PartialEntity?) -> SDAI.LOGICAL { abstruct() }

public func .==. (lhs: SDAI.PartialEntity?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL { abstruct() }
public func .!=. (lhs: SDAI.PartialEntity?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL { abstruct() }

public func .==. <U: SDAISelectType>(lhs: SDAI.PartialEntity?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <U: SDAISelectType>(lhs: SDAI.PartialEntity?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
