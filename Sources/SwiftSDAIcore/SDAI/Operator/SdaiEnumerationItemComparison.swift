//
//  File.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//

import Foundation

//MARK: - Enumeration item comparisons
public func .==. <T: SDAIEnumerationType,U: SDAIEnumerationType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL where T.FundamentalType == U.FundamentalType { abstruct() }
public func .!=. <T: SDAIEnumerationType,U: SDAIEnumerationType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL where T.FundamentalType == U.FundamentalType { abstruct() }
public func >    <T: SDAIEnumerationType,U: SDAIEnumerationType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL where T.FundamentalType == U.FundamentalType { abstruct() }
public func <    <T: SDAIEnumerationType,U: SDAIEnumerationType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL where T.FundamentalType == U.FundamentalType { abstruct() }
public func >=   <T: SDAIEnumerationType,U: SDAIEnumerationType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL where T.FundamentalType == U.FundamentalType { abstruct() }
public func <=   <T: SDAIEnumerationType,U: SDAIEnumerationType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL where T.FundamentalType == U.FundamentalType { abstruct() }
