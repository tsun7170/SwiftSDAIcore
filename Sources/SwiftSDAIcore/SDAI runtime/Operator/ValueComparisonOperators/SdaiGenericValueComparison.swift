//
//  SdaiGenericValueComparison.swift
//  
//
//  Created by Yoshida on 2021/03/14.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - GENERIC value comparisons (12.2.1)

/// GENERIC value Equal: GENERIC .==. GENERIC = LOGICAL
///
public func .==. (
  lhs: SDAI.GENERIC?, rhs: SDAI.GENERIC?) -> SDAI.LOGICAL
{
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

/// GENERIC value NotEqual: GENERIC .!=. GENERIC = LOGICAL
///
public func .!=. (
  lhs: SDAI.GENERIC?, rhs: SDAI.GENERIC?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }

/// GENERIC value GreaterThan: GENERIC \> GENERIC = LOGICAL
///
public func >    (
  lhs: SDAI.GENERIC?, rhs: SDAI.GENERIC?) -> SDAI.LOGICAL
{
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

/// GENERIC value LessThan: GENERIC \< GENERIC = LOGICAL
///
public func <    (
  lhs: SDAI.GENERIC?, rhs: SDAI.GENERIC?) -> SDAI.LOGICAL
{ rhs > lhs }

/// GENERIC value GreaterThanOrEqual: GENERIC \>= GENERIC = LOGICAL
///
public func >=   (
  lhs: SDAI.GENERIC?, rhs: SDAI.GENERIC?) -> SDAI.LOGICAL
{ (lhs > rhs)||(lhs .==. rhs) }

/// GENERIC value LessThanOrEqual: GENERIC \<= GENERIC = LOGICAL
///
public func <=   (
  lhs: SDAI.GENERIC?, rhs: SDAI.GENERIC?) -> SDAI.LOGICAL
{ (lhs < rhs)||(lhs .==. rhs) }

