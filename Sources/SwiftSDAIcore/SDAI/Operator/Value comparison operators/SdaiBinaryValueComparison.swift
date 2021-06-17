//
//  File.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//

import Foundation

//MARK: - Binary comparisons (12.2.1.2)

public func .==. <T: SDAIBinaryType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { 
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	for idx in 1 ... min(lhs.blength, rhs.blength) {
		if let lhs = lhs[idx]?.asSwiftType[0], let rhs = rhs[idx]?.asSwiftType[0] {
			if lhs != rhs { return SDAI.FALSE }
		}
		else { return SDAI.UNKNOWN }
	}
	return SDAI.LOGICAL( lhs.blength == rhs.blength )
}
public func .!=. <T: SDAIBinaryType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .==. rhs) }
public func >    <T: SDAIBinaryType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { 
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	for idx in 1 ... min(lhs.blength, rhs.blength) {
		if let lhs = lhs[idx]?.asSwiftType[0], let rhs = rhs[idx]?.asSwiftType[0] {
			if lhs != rhs { return SDAI.LOGICAL( lhs > rhs ) }
		}
		else { return SDAI.UNKNOWN }
	}
	return SDAI.LOGICAL( lhs.blength > rhs.blength )
}
public func <    <T: SDAIBinaryType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs > lhs }
public func >=   <T: SDAIBinaryType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs > rhs)||(lhs .==. rhs) }
public func <=   <T: SDAIBinaryType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs < rhs)||(lhs .==. rhs) }

//MARK: binary vs. select
public func .==. <T: SDAIBinaryType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs .==. rhs?.binaryValue }
public func .!=. <T: SDAIBinaryType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .==. rhs) }
public func >    <T: SDAIBinaryType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs > rhs?.binaryValue }
public func <    <T: SDAIBinaryType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs > lhs }
public func >=   <T: SDAIBinaryType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs > rhs)||(lhs .==. rhs) }
public func <=   <T: SDAIBinaryType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs < rhs)||(lhs .==. rhs) }

//MARK: select vs. binary
public func .==. <T: SDAISelectType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs .==. lhs }
public func .!=. <T: SDAISelectType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .==. rhs) }
public func >    <T: SDAISelectType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs?.binaryValue > rhs }
public func <    <T: SDAISelectType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs > lhs }
public func >=   <T: SDAISelectType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs > rhs)||(lhs .==. rhs) }
public func <=   <T: SDAISelectType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs < rhs)||(lhs .==. rhs) }

