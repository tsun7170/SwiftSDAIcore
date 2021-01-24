//
//  File.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//

import Foundation

//MARK: - Aggregate value comparisons
//MARK: ARRAY types
public func .==. <T: SDAIArrayOptionalType, U: SDAIArrayOptionalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAIArrayOptionalType, U: SDAIArrayOptionalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }



//MARK: LIST types
public func .==. <T: SDAIListType, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAIListType, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .==. <T: SDAIListType, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAIListType, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .==. <T: SDAIAggregationInitializer, U: SDAIListType>(lhs: T?, rhs: U) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAIAggregationInitializer, U: SDAIListType>(lhs: T, rhs: U?) -> SDAI.LOGICAL { abstruct() }




//MARK: BAG types
public func .==. <T: SDAIBagType, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAIBagType, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .==. <T: SDAIBagType, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAIBagType, U: SDAIAggregationInitializer>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .==. <T: SDAIAggregationInitializer, U: SDAIBagType>(lhs: T?, rhs: U) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAIAggregationInitializer, U: SDAIBagType>(lhs: T, rhs: U?) -> SDAI.LOGICAL { abstruct() }
