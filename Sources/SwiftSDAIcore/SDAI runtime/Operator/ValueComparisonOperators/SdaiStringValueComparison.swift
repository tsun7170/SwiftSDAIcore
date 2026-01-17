//
//  SdaiStringValueComparison.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - String value comparisons (12.2.1.4)

//MARK: string type vs. string type
/// String Value Equal: String .==. String = LOGICAL
///
public func .==. <TSt: SDAI.SwiftStringRepresented, USt: SDAI.SwiftStringRepresented>(
  lhs: TSt?, rhs: USt?) -> SDAI.LOGICAL
{
	guard let lhs = lhs?.possiblyAsSwiftString, let rhs = rhs?.possiblyAsSwiftString else { return SDAI.UNKNOWN }
	return SDAI.LOGICAL( lhs == rhs )
}

/// String Value NotEqual: String .!=. String = LOGICAL
///
public func .!=. <TSt: SDAI.SwiftStringRepresented, USt: SDAI.SwiftStringRepresented>(
  lhs: TSt?, rhs: USt?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }

/// String Value GreaterThan: String \> String = LOGICAL
///
public func >    <TSt: SDAI.SwiftStringRepresented, USt: SDAI.SwiftStringRepresented>(
  lhs: TSt?, rhs: USt?) -> SDAI.LOGICAL
{
	guard let lhs = lhs?.possiblyAsSwiftString, let rhs = rhs?.possiblyAsSwiftString else { return SDAI.UNKNOWN }
	return SDAI.LOGICAL( lhs > rhs )
}

/// String Value LessThan: String \< String = LOGICAL
///
public func <    <TSt: SDAI.SwiftStringRepresented, USt: SDAI.SwiftStringRepresented>(
  lhs: TSt?, rhs: USt?) -> SDAI.LOGICAL
{ rhs > lhs }

/// String Value GreaterThanOrEqual: String \>= String = LOGICAL
///
public func >=   <TSt: SDAI.SwiftStringRepresented, USt: SDAI.SwiftStringRepresented>(
  lhs: TSt?, rhs: USt?) -> SDAI.LOGICAL
{ (lhs > rhs)||(lhs .==. rhs) }

/// String Value LessThanOrEqual: String \<=> String = LOGICAL
///
public func <=   <TSt: SDAI.SwiftStringRepresented, USt: SDAI.SwiftStringRepresented>(
  lhs: TSt?, rhs: USt?) -> SDAI.LOGICAL
{ (lhs < rhs)||(lhs .==. rhs) }


//MARK: select type vs. string type
/// String Value Equal: Select .==. String = LOGICAL
///
public func .==. <TS: SDAI.SelectType, USt: SDAI.SwiftStringRepresented>(
  lhs: TS?, rhs: USt?) -> SDAI.LOGICAL
{ lhs?.stringValue .==. rhs }

/// String Value NotEqual: Select .!=. String = LOGICAL
///
public func .!=. <TS: SDAI.SelectType, USt: SDAI.SwiftStringRepresented>(
  lhs: TS?, rhs: USt?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }

/// String Value GreaterThan: Select \> String = LOGICAL
///
public func >    <TS: SDAI.SelectType, USt: SDAI.SwiftStringRepresented>(
  lhs: TS?, rhs: USt?) -> SDAI.LOGICAL
{ lhs?.stringValue > rhs }

/// String Value LessThan: select \< String = LOGICAL
///
public func <    <TS: SDAI.SelectType, USt: SDAI.SwiftStringRepresented>(
  lhs: TS?, rhs: USt?) -> SDAI.LOGICAL
{ rhs > lhs }

/// String Value GreaterThanOrEqual: Select \>= String = LOGICAL
///
public func >=   <TS: SDAI.SelectType, USt: SDAI.SwiftStringRepresented>(
  lhs: TS?, rhs: USt?) -> SDAI.LOGICAL
{ (lhs > rhs)||(lhs .==. rhs) }

/// String Value LessThanOrEqual: Select \<=> String = LOGICAL
///
public func <=   <TS: SDAI.SelectType, USt: SDAI.SwiftStringRepresented>(
  lhs: TS?, rhs: USt?) -> SDAI.LOGICAL
{ (lhs < rhs)||(lhs .==. rhs) }


//MARK: string type vs. select type
/// String Value Equal: String .==. Select = LOGICAL
///
public func .==. <TSt: SDAI.SwiftStringRepresented, US: SDAI.SelectType>(
  lhs: TSt?, rhs: US?) -> SDAI.LOGICAL
{ rhs .==. lhs }

/// String Value NotEqual: String .!=. Select = LOGICAL
///
public func .!=. <TSt: SDAI.SwiftStringRepresented, US: SDAI.SelectType>(
  lhs: TSt?, rhs: US?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }

/// String Value GreaterThan: String \> Select = LOGICAL
///
public func >    <TSt: SDAI.SwiftStringRepresented, US: SDAI.SelectType>(
  lhs: TSt?, rhs: US?) -> SDAI.LOGICAL
{ lhs > rhs?.stringValue }

/// String Value LessThan: String \< Select = LOGICAL
///
public func <    <TSt: SDAI.SwiftStringRepresented, US: SDAI.SelectType>(
  lhs: TSt?, rhs: US?) -> SDAI.LOGICAL
{ rhs > lhs }

/// String Value GreaterThanOrEqual: String \>= Select = LOGICAL
///
public func >=   <TSt: SDAI.SwiftStringRepresented, US: SDAI.SelectType>(
  lhs: TSt?, rhs: US?) -> SDAI.LOGICAL
{ (lhs > rhs)||(lhs .==. rhs) }

/// String Value LessThanOrEqual: String \<=> Select = LOGICAL
///
public func <=   <TSt: SDAI.SwiftStringRepresented, US: SDAI.SelectType>(
  lhs: TSt?, rhs: US?) -> SDAI.LOGICAL
{ (lhs < rhs)||(lhs .==. rhs) }

