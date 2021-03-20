//
//  File.swift
//  
//
//  Created by Yoshida on 2021/03/14.
//

import Foundation

public func .==. <T: SDAI__GENERIC__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { 
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	if let lhs = lhs.entityReference, let rhs = rhs.entityReference {
		return lhs .==. rhs
	}
	if let lhs = lhs.stringValue, let rhs = rhs.stringValue {
		return lhs .==. rhs
	}
	if let lhs = lhs.binaryValue, let rhs = rhs.binaryValue {
		return lhs .==. rhs
	}
	if let lhs = lhs.booleanValue, let rhs = rhs.booleanValue {
		return lhs .==. rhs
	}
	if let lhs = lhs.logicalValue, let rhs = rhs.logicalValue {
		return lhs .==. rhs
	}
	if let lhs = lhs.integerValue, let rhs = rhs.integerValue {
		return lhs .==. rhs
	}
	if let lhs = lhs.realValue, let rhs = rhs.realValue {
		return lhs .==. rhs
	}
	if let lhs = lhs.numberValue, let rhs = rhs.numberValue {
		return lhs .==. rhs
	}
	if let lhs = lhs.genericEnumValue, let rhs = rhs.genericEnumValue {
		return SDAI.LOGICAL(lhs == rhs)
	}
	if let lhs = lhs.arrayOptionalValue(elementType: SDAI.GENERIC.self), 
		 let rhs = rhs.arrayOptionalValue(elementType: SDAI.GENERIC.self) {
		return lhs .==. rhs
	}
	if let lhs = lhs.listValue(elementType: SDAI.GENERIC.self), 
		 let rhs = rhs.listValue(elementType: SDAI.GENERIC.self) {
		return lhs .==. rhs
	}
	if let lhs = lhs.bagValue(elementType: SDAI.GENERIC.self), 
		 let rhs = rhs.bagValue(elementType: SDAI.GENERIC.self) {
		return lhs .==. rhs
	}
	return SDAI.UNKNOWN
}

public func .!=. <T: SDAI__GENERIC__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .==. rhs) }

public func >    <T: SDAI__GENERIC__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { 
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	if let lhs = lhs.stringValue, let rhs = rhs.stringValue {
		return lhs > rhs
	}
	if let lhs = lhs.binaryValue, let rhs = rhs.binaryValue {
		return lhs > rhs
	}
	if let lhs = lhs.booleanValue, let rhs = rhs.booleanValue {
		return lhs > rhs
	}
	if let lhs = lhs.logicalValue, let rhs = rhs.logicalValue {
		return lhs > rhs
	}
	if let lhs = lhs.integerValue, let rhs = rhs.integerValue {
		return lhs > rhs
	}
	if let lhs = lhs.realValue, let rhs = rhs.realValue {
		return lhs > rhs
	}
	if let lhs = lhs.numberValue, let rhs = rhs.numberValue {
		return lhs > rhs
	}
	if let lhs = lhs.genericEnumValue, let rhs = rhs.genericEnumValue {
		if lhs.typeId == rhs.typeId { return SDAI.LOGICAL(lhs.enumCardinal > rhs.enumCardinal) }
		return SDAI.UNKNOWN
	}
	return SDAI.UNKNOWN
}

public func <    <T: SDAI__GENERIC__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { SDAI.GENERIC(rhs) > lhs }

public func >=   <T: SDAI__GENERIC__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs > rhs)||(lhs .==. rhs) }

public func <=   <T: SDAI__GENERIC__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { (lhs < rhs)||(lhs .==. rhs) }