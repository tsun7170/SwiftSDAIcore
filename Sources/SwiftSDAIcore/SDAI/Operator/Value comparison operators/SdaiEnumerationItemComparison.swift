//
//  File.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//

import Foundation

//MARK: - Enumeration item comparisons (12.2.1.5)

public func .==. <T: SDAIEnumerationType,U: SDAIEnumerationType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL 
where T.FundamentalType == U.FundamentalType { 
	guard let lhs = lhs?.asFundamentalType.rawValue, let rhs = rhs?.asFundamentalType.rawValue else { return SDAI.UNKNOWN }
	return SDAI.LOGICAL( lhs == rhs )
}
public func .!=. <T: SDAIEnumerationType,U: SDAIEnumerationType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL 
where T.FundamentalType == U.FundamentalType { !(lhs .==. rhs) }
public func >    <T: SDAIEnumerationType,U: SDAIEnumerationType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL 
where T.FundamentalType == U.FundamentalType { 
	guard let lhs = lhs?.asFundamentalType.rawValue, let rhs = rhs?.asFundamentalType.rawValue else { return SDAI.UNKNOWN }
	return SDAI.LOGICAL( lhs > rhs )
}
public func <    <T: SDAIEnumerationType,U: SDAIEnumerationType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL where T.FundamentalType == U.FundamentalType { rhs > lhs }
public func >=   <T: SDAIEnumerationType,U: SDAIEnumerationType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL where T.FundamentalType == U.FundamentalType { (lhs > rhs)||(lhs .==. rhs) }
public func <=   <T: SDAIEnumerationType,U: SDAIEnumerationType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL where T.FundamentalType == U.FundamentalType { (lhs < rhs)||(lhs .==. rhs) }

//MARK: enum vs. select
public func .==. <T: SDAIEnumerationType,U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs .==. rhs?.enumValue(enumType: T.self) }
public func .!=. <T: SDAIEnumerationType,U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .==. rhs) }
public func >    <T: SDAIEnumerationType,U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs > rhs?.enumValue(enumType: T.self) }
public func <    <T: SDAIEnumerationType,U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs > lhs }
public func >=   <T: SDAIEnumerationType,U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs > rhs)||(lhs .==. rhs) }
public func <=   <T: SDAIEnumerationType,U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs < rhs)||(lhs .==. rhs) }

//MARK: select vs. enum
public func .==. <T: SDAISelectType,U: SDAIEnumerationType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs .==. lhs }
public func .!=. <T: SDAISelectType,U: SDAIEnumerationType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .==. rhs) }
public func >    <T: SDAISelectType,U: SDAIEnumerationType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs?.enumValue(enumType: U.self) > rhs }
public func <    <T: SDAISelectType,U: SDAIEnumerationType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs > lhs }
public func >=   <T: SDAISelectType,U: SDAIEnumerationType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs > rhs)||(lhs .==. rhs) }
public func <=   <T: SDAISelectType,U: SDAIEnumerationType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs < rhs)||(lhs .==. rhs) }


