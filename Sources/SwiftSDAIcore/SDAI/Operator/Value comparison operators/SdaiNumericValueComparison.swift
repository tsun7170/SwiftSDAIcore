//
//  File.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//

import Foundation

//MARK: - Numeric comparisons (12.2.1.1)

//MARK: integer vs. integer
public func .==. <T: SDAIIntRepresented, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { 
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	return SDAI.LOGICAL( lhs.asSwiftInt == rhs.asSwiftInt )
}
public func .!=. <T: SDAIIntRepresented, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .==. rhs) }
public func >    <T: SDAIIntRepresented, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { 
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	return SDAI.LOGICAL( lhs.asSwiftInt > rhs.asSwiftInt )
}
public func <    <T: SDAIIntRepresented, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs > lhs }
public func >=   <T: SDAIIntRepresented, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs > rhs)||(lhs .==. rhs) }
public func <=   <T: SDAIIntRepresented, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs < rhs)||(lhs .==. rhs) }


//MARK: integer vs. double
public func .==. <T: SDAIIntRepresented, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs?.asSwiftDouble .==. rhs }
public func .!=. <T: SDAIIntRepresented, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .==. rhs) }
public func >    <T: SDAIIntRepresented, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs?.asSwiftDouble > rhs }
public func <    <T: SDAIIntRepresented, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs > lhs }
public func >=   <T: SDAIIntRepresented, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs > rhs)||(lhs .==. rhs) }
public func <=   <T: SDAIIntRepresented, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs < rhs)||(lhs .==. rhs) }


//MARK: double vs. double
public func .==. <T: SDAIDoubleRepresented, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { 
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	return SDAI.LOGICAL( lhs.asSwiftDouble == rhs.asSwiftDouble )
}
public func .!=. <T: SDAIDoubleRepresented, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .==. rhs) }
public func >    <T: SDAIDoubleRepresented, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { 
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	return SDAI.LOGICAL( lhs.asSwiftDouble > rhs.asSwiftDouble )
}
public func <    <T: SDAIDoubleRepresented, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs > lhs }
public func >=   <T: SDAIDoubleRepresented, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs > rhs)||(lhs .==. rhs) }
public func <=   <T: SDAIDoubleRepresented, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs < rhs)||(lhs .==. rhs) }


//MARK: double vs. integer
public func .==. <T: SDAIDoubleRepresented, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs .==. lhs }
public func .!=. <T: SDAIDoubleRepresented, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .==. rhs) }
public func >    <T: SDAIDoubleRepresented, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs < lhs }
public func <    <T: SDAIDoubleRepresented, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs > lhs }
public func >=   <T: SDAIDoubleRepresented, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs > rhs)||(lhs .==. rhs) }
public func <=   <T: SDAIDoubleRepresented, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs < rhs)||(lhs .==. rhs) }


//MARK: integer vs. select
public func .==. <T: SDAIIntRepresented, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { 
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	if let rhs = rhs.possiblyAsSwiftInt {
		return SDAI.LOGICAL( lhs.asSwiftInt == rhs )
	}
	else if let rhs = rhs.possiblyAsSwiftDouble {
		return SDAI.LOGICAL( lhs.asSwiftDouble == rhs )
	}
	return SDAI.FALSE
}
public func .!=. <T: SDAIIntRepresented, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .==. rhs) }
public func >    <T: SDAIIntRepresented, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { 
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	if let rhs = rhs.possiblyAsSwiftInt {
		return SDAI.LOGICAL( lhs.asSwiftInt > rhs )
	}
	else if let rhs = rhs.possiblyAsSwiftDouble {
		return SDAI.LOGICAL( lhs.asSwiftDouble > rhs )
	}
	return SDAI.UNKNOWN
}
public func <    <T: SDAIIntRepresented, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs > lhs }
public func >=   <T: SDAIIntRepresented, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs > rhs)||(lhs .==. rhs) }
public func <=   <T: SDAIIntRepresented, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs < rhs)||(lhs .==. rhs) }


//MARK: double vs. select
public func .==. <T: SDAIDoubleRepresented, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { 
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	if let rhs = rhs.possiblyAsSwiftDouble {
		return SDAI.LOGICAL( lhs.asSwiftDouble == rhs )
	}
	return SDAI.FALSE
}
public func .!=. <T: SDAIDoubleRepresented, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .==. rhs) }
public func >    <T: SDAIDoubleRepresented, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { 
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	if let rhs = rhs.possiblyAsSwiftDouble {
		return SDAI.LOGICAL( lhs.asSwiftDouble > rhs )
	}
	return SDAI.UNKNOWN
}
public func <    <T: SDAIDoubleRepresented, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs > lhs }
public func >=   <T: SDAIDoubleRepresented, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs > rhs)||(lhs .==. rhs) }
public func <=   <T: SDAIDoubleRepresented, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs < rhs)||(lhs .==. rhs) }


//MARK: select vs. select
public func .==. <T: SDAISelectType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { SDAI.GENERIC(lhs) .==. rhs }
public func .!=. <T: SDAISelectType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .==. rhs) }
public func >    <T: SDAISelectType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { SDAI.GENERIC(lhs) > rhs }
public func <    <T: SDAISelectType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs > lhs }
public func >=   <T: SDAISelectType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs > rhs)||(lhs .==. rhs) }
public func <=   <T: SDAISelectType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs < rhs)||(lhs .==. rhs) }

//MARK: select vs. integer
public func .==. <T: SDAISelectType, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs .==. lhs }
public func .!=. <T: SDAISelectType, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .==. rhs) }
public func >    <T: SDAISelectType, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs < lhs }
public func <    <T: SDAISelectType, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs > lhs }
public func >=   <T: SDAISelectType, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs > rhs)||(lhs .==. rhs) }
public func <=   <T: SDAISelectType, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs < rhs)||(lhs .==. rhs) }


//MARK: select vs. double
public func .==. <T: SDAISelectType, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs .==. lhs }
public func .!=. <T: SDAISelectType, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .==. rhs) }
public func >    <T: SDAISelectType, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs < lhs }
public func <    <T: SDAISelectType, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs > lhs }
public func >=   <T: SDAISelectType, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs > rhs)||(lhs .==. rhs) }
public func <=   <T: SDAISelectType, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs < rhs)||(lhs .==. rhs) }


