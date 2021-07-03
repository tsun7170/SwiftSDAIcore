//
//  File.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//

import Foundation

//MARK: - String comparisons (12.2.1.4)

//MARK: string type vs. string type
public func .==. <T: SwiftStringRepresented, U: SwiftStringRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { 
	guard let lhs = lhs?.possiblyAsSwiftString, let rhs = rhs?.possiblyAsSwiftString else { return SDAI.UNKNOWN }
	return SDAI.LOGICAL( lhs == rhs )
}
public func .!=. <T: SwiftStringRepresented, U: SwiftStringRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .==. rhs) }
public func >    <T: SwiftStringRepresented, U: SwiftStringRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { 
	guard let lhs = lhs?.possiblyAsSwiftString, let rhs = rhs?.possiblyAsSwiftString else { return SDAI.UNKNOWN }
	return SDAI.LOGICAL( lhs > rhs )
}
public func <    <T: SwiftStringRepresented, U: SwiftStringRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs > lhs }
public func >=   <T: SwiftStringRepresented, U: SwiftStringRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs > rhs)||(lhs .==. rhs) }
public func <=   <T: SwiftStringRepresented, U: SwiftStringRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs < rhs)||(lhs .==. rhs) }


//MARK: select type vs. string type
public func .==. <T: SDAISelectType, U: SwiftStringRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs?.stringValue .==. rhs }
public func .!=. <T: SDAISelectType, U: SwiftStringRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .==. rhs) }
public func >    <T: SDAISelectType, U: SwiftStringRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs?.stringValue > rhs }
public func <    <T: SDAISelectType, U: SwiftStringRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs > lhs }
public func >=   <T: SDAISelectType, U: SwiftStringRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs > rhs)||(lhs .==. rhs) }
public func <=   <T: SDAISelectType, U: SwiftStringRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs < rhs)||(lhs .==. rhs) }


//MARK: string type vs. select type
public func .==. <T: SwiftStringRepresented, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs .==. lhs }
public func .!=. <T: SwiftStringRepresented, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .==. rhs) }
public func >    <T: SwiftStringRepresented, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs > rhs?.stringValue }
public func <    <T: SwiftStringRepresented, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs > lhs }
public func >=   <T: SwiftStringRepresented, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs > rhs)||(lhs .==. rhs) }
public func <=   <T: SwiftStringRepresented, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs < rhs)||(lhs .==. rhs) }

