//
//  SdaiBinaryValueComparison.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - Binary value comparisons (12.2.1.2)

/// Binary Value Equal: Binary .==. Binary = LOGICAL
///
public func .==. <TBi: SDAI.BinaryType, UBi: SDAI.BinaryType>(
  lhs: TBi?, rhs: UBi?) -> SDAI.LOGICAL
{
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	for idx in 1 ... min(lhs.blength, rhs.blength) {
		if let lhs = lhs[idx]?.asSwiftType[0], let rhs = rhs[idx]?.asSwiftType[0] {
			if lhs != rhs { return SDAI.FALSE }
		}
		else { return SDAI.UNKNOWN }
	}
	return SDAI.LOGICAL( lhs.blength == rhs.blength )
}

/// Binary Value NotEqual: Binary .!=. Binary = LOGICAL
///
public func .!=. <TBi: SDAI.BinaryType, UBi: SDAI.BinaryType>(
  lhs: TBi?, rhs: UBi?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }

/// Binary Value GreaterThan: Binary \> Binary = LOGICAL
///
public func >    <TBi: SDAI.BinaryType, UBi: SDAI.BinaryType>(
  lhs: TBi?, rhs: UBi?) -> SDAI.LOGICAL
{
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	for idx in 1 ... min(lhs.blength, rhs.blength) {
		if let lhs = lhs[idx]?.asSwiftType[0], let rhs = rhs[idx]?.asSwiftType[0] {
			if lhs != rhs { return SDAI.LOGICAL( lhs > rhs ) }
		}
		else { return SDAI.UNKNOWN }
	}
	return SDAI.LOGICAL( lhs.blength > rhs.blength )
}

/// Binary Value LessThan: Binary \< Binary = LOGICAL
///
public func <    <TBi: SDAI.BinaryType, UBi: SDAI.BinaryType>(
  lhs: TBi?, rhs: UBi?) -> SDAI.LOGICAL
{ rhs > lhs }

/// Binary Value GreaterThanOrEqual: Binary \>= Binary = LOGICAL
///
public func >=   <TBi: SDAI.BinaryType, UBi: SDAI.BinaryType>(
  lhs: TBi?, rhs: UBi?) -> SDAI.LOGICAL
{ (lhs > rhs)||(lhs .==. rhs) }

/// Binary Value LessThanOrEqual: Binary \<= Binary = LOGICAL
///
public func <=   <TBi: SDAI.BinaryType, UBi: SDAI.BinaryType>(
  lhs: TBi?, rhs: UBi?) -> SDAI.LOGICAL
{ (lhs < rhs)||(lhs .==. rhs) }


//MARK: binary vs. select

/// Binary Value Equal: Binary .==. Select = LOGICAL
///
public func .==. <TBi: SDAI.BinaryType, US: SDAI.SelectType>(
  lhs: TBi?, rhs: US?) -> SDAI.LOGICAL
{ lhs .==. rhs?.binaryValue }

/// Binary Value NotEqual: Binary .!=. Select = LOGICAL
///
public func .!=. <TBi: SDAI.BinaryType, US: SDAI.SelectType>(
  lhs: TBi?, rhs: US?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }

/// Binary Value GreaterThan: Binary \> Select = LOGICAL
///
public func >    <TBi: SDAI.BinaryType, US: SDAI.SelectType>(
  lhs: TBi?, rhs: US?) -> SDAI.LOGICAL
{ lhs > rhs?.binaryValue }

/// Binary Value LessThan: Binary \< Select = LOGICAL
///
public func <    <TBi: SDAI.BinaryType, US: SDAI.SelectType>(
  lhs: TBi?, rhs: US?) -> SDAI.LOGICAL
{ rhs > lhs }

/// Binary Value GreaterThanOrEqual: Binary \>= Select = LOGICAL
///
public func >=   <TBi: SDAI.BinaryType, US: SDAI.SelectType>(
  lhs: TBi?, rhs: US?) -> SDAI.LOGICAL
{ (lhs > rhs)||(lhs .==. rhs) }

/// Binary Value LessThanOrEqual: Binary \<= Select = LOGICAL
///
public func <=   <TBi: SDAI.BinaryType, US: SDAI.SelectType>(
  lhs: TBi?, rhs: US?) -> SDAI.LOGICAL
{ (lhs < rhs)||(lhs .==. rhs) }


//MARK: select vs. binary

/// Binary Value Equal: Select .==. Binary = LOGICAL
///
public func .==. <TS: SDAI.SelectType, UBi: SDAI.BinaryType>(
  lhs: TS?, rhs: UBi?) -> SDAI.LOGICAL
{ rhs .==. lhs }

/// Binary Value NotEqual: Select .!=. Binary = LOGICAL
///
public func .!=. <TS: SDAI.SelectType, UBi: SDAI.BinaryType>(
  lhs: TS?, rhs: UBi?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }

/// Binary Value GreaterThan: Select \> Binary = LOGICAL
///
public func >    <TS: SDAI.SelectType, UBi: SDAI.BinaryType>(
  lhs: TS?, rhs: UBi?) -> SDAI.LOGICAL
{ lhs?.binaryValue > rhs }

/// Binary Value LessThan: Select \< Binary = LOGICAL
///
public func <    <TS: SDAI.SelectType, UBi: SDAI.BinaryType>(
  lhs: TS?, rhs: UBi?) -> SDAI.LOGICAL
{ rhs > lhs }

/// Binary Value GreaterThanOrEqual: Select \>= Binary = LOGICAL
///
public func >=   <TS: SDAI.SelectType, UBi: SDAI.BinaryType>(
  lhs: TS?, rhs: UBi?) -> SDAI.LOGICAL
{ (lhs > rhs)||(lhs .==. rhs) }

/// Binary Value LessThanOrEqual: Select \<= Binary = LOGICAL
///
public func <=   <TS: SDAI.SelectType, UBi: SDAI.BinaryType>(
  lhs: TS?, rhs: UBi?) -> SDAI.LOGICAL
{ (lhs < rhs)||(lhs .==. rhs) }

