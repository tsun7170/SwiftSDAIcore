//
//  SdaiEnumerationItemComparison.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - Enumeration item value comparisons (12.2.1.5)

/// Enumeration Item Value Equal: Enum .==. Enum = LOGICAL
///
public func .==. <TE: SDAI.EnumerationType,UE: SDAI.EnumerationType>(
  lhs: TE?, rhs: UE?) -> SDAI.LOGICAL
where TE.FundamentalType == UE.FundamentalType
{
	guard let lhs = lhs?.asFundamentalType.rawValue, let rhs = rhs?.asFundamentalType.rawValue else { return SDAI.UNKNOWN }
	return SDAI.LOGICAL( lhs == rhs )
}

/// Enumeration Item Value NotEqual: Enum .!=. Enum = LOGICAL
///
public func .!=. <TE: SDAI.EnumerationType,UE: SDAI.EnumerationType>(
  lhs: TE?, rhs: UE?) -> SDAI.LOGICAL
where TE.FundamentalType == UE.FundamentalType
{ !(lhs .==. rhs) }

/// Enumeration Item Value GreaterThan: Enum \> Enum = LOGICAL
///
public func >    <TE: SDAI.EnumerationType,UE: SDAI.EnumerationType>(
  lhs: TE?, rhs: UE?) -> SDAI.LOGICAL
where TE.FundamentalType == UE.FundamentalType
{
	guard let lhs = lhs?.asFundamentalType.rawValue, let rhs = rhs?.asFundamentalType.rawValue else { return SDAI.UNKNOWN }
	return SDAI.LOGICAL( lhs > rhs )
}

/// Enumeration Item Value LessThan: Enum \< Enum = LOGICAL
///
public func <    <TE: SDAI.EnumerationType,UE: SDAI.EnumerationType>(
  lhs: TE?, rhs: UE?) -> SDAI.LOGICAL
where TE.FundamentalType == UE.FundamentalType
{ rhs > lhs }

/// Enumeration Item Value GreaterThanOrEqual: Enum \>= Enum = LOGICAL
///
public func >=   <TE: SDAI.EnumerationType,UE: SDAI.EnumerationType>(
  lhs: TE?, rhs: UE?) -> SDAI.LOGICAL
where TE.FundamentalType == UE.FundamentalType
{ (lhs > rhs)||(lhs .==. rhs) }

/// Enumeration Item Value LessThanOrEqual: Enum \<= Enum = LOGICAL
///
public func <=   <TE: SDAI.EnumerationType,UE: SDAI.EnumerationType>(
  lhs: TE?, rhs: UE?) -> SDAI.LOGICAL
where TE.FundamentalType == UE.FundamentalType
{ (lhs < rhs)||(lhs .==. rhs) }


//MARK: enum vs. select
/// Enumeration Item Value Equal: Enum .==. Select = LOGICAL
///
public func .==. <TE: SDAI.EnumerationType,US: SDAI.SelectType>(
  lhs: TE?, rhs: US?) -> SDAI.LOGICAL
{ lhs .==. rhs?.enumValue(enumType: TE.self) }

/// Enumeration Item Value NotEqual: Enum .!=. Select = LOGICAL
///
public func .!=. <TE: SDAI.EnumerationType,US: SDAI.SelectType>(
  lhs: TE?, rhs: US?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }

/// Enumeration Item Value GreaterThan: Enum \> Select = LOGICAL
///
public func >    <TE: SDAI.EnumerationType,US: SDAI.SelectType>(
  lhs: TE?, rhs: US?) -> SDAI.LOGICAL
{ lhs > rhs?.enumValue(enumType: TE.self) }

/// Enumeration Item Value LessThan: Enum \< Select = LOGICAL
///
public func <    <TE: SDAI.EnumerationType,US: SDAI.SelectType>(
  lhs: TE?, rhs: US?) -> SDAI.LOGICAL
{ rhs > lhs }

/// Enumeration Item Value GreaterThanOrEqual: Enum \>= Select = LOGICAL
///
public func >=   <TE: SDAI.EnumerationType,US: SDAI.SelectType>(
  lhs: TE?, rhs: US?) -> SDAI.LOGICAL
{ (lhs > rhs)||(lhs .==. rhs) }

/// Enumeration Item Value LessThanOrEqual: Enum \<= Select = LOGICAL
///
public func <=   <TE: SDAI.EnumerationType,US: SDAI.SelectType>(
  lhs: TE?, rhs: US?) -> SDAI.LOGICAL
{ (lhs < rhs)||(lhs .==. rhs) }


//MARK: select vs. enum
/// Enumeration Item Value Equal: Select .==. Enum = LOGICAL
///
public func .==. <TS: SDAI.SelectType,UE: SDAI.EnumerationType>(
  lhs: TS?, rhs: UE?) -> SDAI.LOGICAL
{ rhs .==. lhs }

/// Enumeration Item Value NotEqual: Select .!=. Enum = LOGICAL
///
public func .!=. <TS: SDAI.SelectType,UE: SDAI.EnumerationType>(
  lhs: TS?, rhs: UE?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }

/// Enumeration Item Value GreaterThan: Select \> Enum = LOGICAL
///
public func >    <TS: SDAI.SelectType,UE: SDAI.EnumerationType>(
  lhs: TS?, rhs: UE?) -> SDAI.LOGICAL
{ lhs?.enumValue(enumType: UE.self) > rhs }

/// Enumeration Item Value LessThan: Select \< Enum = LOGICAL
///
public func <    <TS: SDAI.SelectType,UE: SDAI.EnumerationType>(
  lhs: TS?, rhs: UE?) -> SDAI.LOGICAL
{ rhs > lhs }

/// Enumeration Item Value GreaterThanOrEqual: Select \>= Enum = LOGICAL
///
public func >=   <TS: SDAI.SelectType,UE: SDAI.EnumerationType>(
  lhs: TS?, rhs: UE?) -> SDAI.LOGICAL
{ (lhs > rhs)||(lhs .==. rhs) }

/// Enumeration Item Value LessThanOrEqual: Select \<= Enum = LOGICAL
///
public func <=   <TS: SDAI.SelectType,UE: SDAI.EnumerationType>(
  lhs: TS?, rhs: UE?) -> SDAI.LOGICAL
{ (lhs < rhs)||(lhs .==. rhs) }


