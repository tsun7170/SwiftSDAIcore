//
//  SdaiLogicalValueComparison.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - Logical value comparisons (12.2.1.3)

//MARK: logical vs. logical
/// Logical Value Equal: Logical .==. Logical = LOGICAL
///
public func .==. <T: SDAI.LogicalType, U: SDAI.LogicalType>(
  lhs: T?, rhs: U?) -> SDAI.LOGICAL
{
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	return SDAI.LOGICAL( SDAI.cardinal(logical: lhs) == SDAI.cardinal(logical: rhs) )
}

/// Logical Value NotEqual: Logical .!=. Logical = LOGICAL
///
public func .!=. <T: SDAI.LogicalType, U: SDAI.LogicalType>(
  lhs: T?, rhs: U?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }

/// Logical Value GreaterThan: Logical \> Logical = LOGICAL
///
public func >    <T: SDAI.LogicalType, U: SDAI.LogicalType>(
  lhs: T?, rhs: U?) -> SDAI.LOGICAL
{
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	return SDAI.LOGICAL( SDAI.cardinal(logical: lhs) > SDAI.cardinal(logical: rhs) )
}

/// Logical Value LessThan: Logical \< Logical = LOGICAL
///
public func <    <T: SDAI.LogicalType, U: SDAI.LogicalType>(
  lhs: T?, rhs: U?) -> SDAI.LOGICAL
{ rhs > lhs }

/// Logical Value GreaterThanOrEqual: Logical \>= Logical = LOGICAL
///
public func >=   <T: SDAI.LogicalType, U: SDAI.LogicalType>(
  lhs: T?, rhs: U?) -> SDAI.LOGICAL
{ (lhs > rhs)||(lhs .==. rhs) }

/// Logical Value LessThanOrEqual: Logical \<= Logical = LOGICAL
///
public func <=   <T: SDAI.LogicalType, U: SDAI.LogicalType>(
  lhs: T?, rhs: U?) -> SDAI.LOGICAL
{ (lhs < rhs)||(lhs .==. rhs) }


//MARK: logical vs. select
/// Logical Value Equal: Logical .==. Select = LOGICAL
///
public func .==. <T: SDAI.LogicalType, U: SDAI.SelectType>(
  lhs: T?, rhs: U?) -> SDAI.LOGICAL
{ lhs .==. rhs?.logicalValue }

/// Logical Value NotEqual: Logical .!=. Select = LOGICAL
///
public func .!=. <T: SDAI.LogicalType, U: SDAI.SelectType>(
  lhs: T?, rhs: U?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }

/// Logical Value GreaterThan: Logical \> Select = LOGICAL
///
public func >    <T: SDAI.LogicalType, U: SDAI.SelectType>(
  lhs: T?, rhs: U?) -> SDAI.LOGICAL
{ lhs > rhs?.logicalValue }

/// Logical Value LessThan: Logical \< Select = LOGICAL
///
public func <    <T: SDAI.LogicalType, U: SDAI.SelectType>(
  lhs: T?, rhs: U?) -> SDAI.LOGICAL
{ rhs > lhs }

/// Logical Value GreaterThanOrEqual: Logical \>= Select = LOGICAL
///
public func >=   <T: SDAI.LogicalType, U: SDAI.SelectType>(
  lhs: T?, rhs: U?) -> SDAI.LOGICAL
{ (lhs > rhs)||(lhs .==. rhs) }

/// Logical Value LessThanOrEqual: Logical \<= Select = LOGICAL
///
public func <=   <T: SDAI.LogicalType, U: SDAI.SelectType>(
  lhs: T?, rhs: U?) -> SDAI.LOGICAL
{ (lhs < rhs)||(lhs .==. rhs) }


//MARK: select vs. logical
/// Logical Value Equal: Select .==. Logical = LOGICAL
///
public func .==. <T: SDAI.SelectType, U: SDAI.LogicalType>(
  lhs: T?, rhs: U?) -> SDAI.LOGICAL
{ rhs .==. lhs }

/// Logical Value NotEqual: Select .!=. Logical = LOGICAL
///
public func .!=. <T: SDAI.SelectType, U: SDAI.LogicalType>(
  lhs: T?, rhs: U?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }

/// Logical Value GreaterThan: Select \> Logical = LOGICAL
///
public func >    <T: SDAI.SelectType, U: SDAI.LogicalType>(
  lhs: T?, rhs: U?) -> SDAI.LOGICAL
{ lhs?.logicalValue > rhs }

/// Logical Value LessThan: Select \< Logical = LOGICAL
///
public func <    <T: SDAI.SelectType, U: SDAI.LogicalType>(
  lhs: T?, rhs: U?) -> SDAI.LOGICAL
{ rhs > lhs }

/// Logical Value GreaterThanOrEqual: Select \>= Logical = LOGICAL
///
public func >=   <T: SDAI.SelectType, U: SDAI.LogicalType>(
  lhs: T?, rhs: U?) -> SDAI.LOGICAL
{ (lhs > rhs)||(lhs .==. rhs) }

/// Logical Value LessThanOrEqual: Select \<= Logical = LOGICAL
///
public func <=   <T: SDAI.SelectType, U: SDAI.LogicalType>(
  lhs: T?, rhs: U?) -> SDAI.LOGICAL
{ (lhs < rhs)||(lhs .==. rhs) }


