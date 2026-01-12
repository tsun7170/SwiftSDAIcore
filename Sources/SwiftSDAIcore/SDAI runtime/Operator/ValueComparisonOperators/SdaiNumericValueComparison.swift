//
//  SdaiNumericValueComparison.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - Numeric value comparisons (12.2.1.1)

//MARK: integer vs. integer
/// Numeric Value Equal: Int .==. Int = LOGICAL
///
public func .==. <TI: SDAI.IntRepresentedNumberType, UI: SDAI.IntRepresentedNumberType>(
  lhs: TI?, rhs: UI?) -> SDAI.LOGICAL
{
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	return SDAI.LOGICAL( lhs.asSwiftInt == rhs.asSwiftInt )
}

/// Numeric Value NotEqual: Int .!=. Int = LOGICAL
///
public func .!=. <TI: SDAI.IntRepresentedNumberType, UI: SDAI.IntRepresentedNumberType>(
  lhs: TI?, rhs: UI?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }

/// Numeric Value GreaterThan: Int \> Int = LOGICAL
///
public func >    <TI: SDAI.IntRepresentedNumberType, UI: SDAI.IntRepresentedNumberType>(
  lhs: TI?, rhs: UI?) -> SDAI.LOGICAL
{
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	return SDAI.LOGICAL( lhs.asSwiftInt > rhs.asSwiftInt )
}

/// Numeric Value LessThan: Int \< Int = LOGICAL
///
public func <    <TI: SDAI.IntRepresentedNumberType, UI: SDAI.IntRepresentedNumberType>(
  lhs: TI?, rhs: UI?) -> SDAI.LOGICAL
{ rhs > lhs }

/// Numeric Value GreaterThanOrEqual: Int \>= Int = LOGICAL
///
public func >=   <TI: SDAI.IntRepresentedNumberType, UI: SDAI.IntRepresentedNumberType>(
  lhs: TI?, rhs: UI?) -> SDAI.LOGICAL
{ (lhs > rhs)||(lhs .==. rhs) }

/// Numeric Value LessThanOrEqual: Int \<= Int = LOGICAL
///
public func <=   <TI: SDAI.IntRepresentedNumberType, UI: SDAI.IntRepresentedNumberType>(
  lhs: TI?, rhs: UI?) -> SDAI.LOGICAL
{ (lhs < rhs)||(lhs .==. rhs) }


//MARK: integer vs. double
/// Numeric Value Equal: Int .==. Double = LOGICAL
///
public func .==. <TI: SDAI.IntRepresentedNumberType, UD: SDAI.DoubleRepresentedNumberType>(
  lhs: TI?, rhs: UD?) -> SDAI.LOGICAL
{ SDAI.REAL(lhs) .==. rhs }

/// Numeric Value NotEqual: Int .!=. Double = LOGICAL
///
public func .!=. <TI: SDAI.IntRepresentedNumberType, UD: SDAI.DoubleRepresentedNumberType>(
  lhs: TI?, rhs: UD?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }

/// Numeric Value GreaterThan: Int \> Double = LOGICAL
///
public func >    <TI: SDAI.IntRepresentedNumberType, UD: SDAI.DoubleRepresentedNumberType>(
  lhs: TI?, rhs: UD?) -> SDAI.LOGICAL
{ SDAI.REAL(lhs) > rhs }

/// Numeric Value LessThan: Int \< Double = LOGICAL
///
public func <    <TI: SDAI.IntRepresentedNumberType, UD: SDAI.DoubleRepresentedNumberType>(
  lhs: TI?, rhs: UD?) -> SDAI.LOGICAL
{ rhs > lhs }

/// Numeric Value GreaterThanOrEqual: Int \>= Double = LOGICAL
///
public func >=   <TI: SDAI.IntRepresentedNumberType, UD: SDAI.DoubleRepresentedNumberType>(
  lhs: TI?, rhs: UD?) -> SDAI.LOGICAL
{ (lhs > rhs)||(lhs .==. rhs) }

/// Numeric Value LessThanOrEqual: Int \<= Double = LOGICAL
///
public func <=   <TI: SDAI.IntRepresentedNumberType, UD: SDAI.DoubleRepresentedNumberType>(
  lhs: TI?, rhs: UD?) -> SDAI.LOGICAL
{ (lhs < rhs)||(lhs .==. rhs) }


//MARK: double vs. double
/// Numeric Value Equal: Double .==. Double = LOGICAL
///
public func .==. <TD: SDAI.DoubleRepresentedNumberType, UD: SDAI.DoubleRepresentedNumberType>(
  lhs: TD?, rhs: UD?) -> SDAI.LOGICAL
{
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	return SDAI.LOGICAL( lhs.asSwiftDouble == rhs.asSwiftDouble )
}

/// Numeric Value NotEqual: Double .!=. Double = LOGICAL
///
public func .!=. <TD: SDAI.DoubleRepresentedNumberType, UD: SDAI.DoubleRepresentedNumberType>(
  lhs: TD?, rhs: UD?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }

/// Numeric Value GreaterThan: Double \> Double = LOGICAL
///
public func >    <TD: SDAI.DoubleRepresentedNumberType, UD: SDAI.DoubleRepresentedNumberType>(
  lhs: TD?, rhs: UD?) -> SDAI.LOGICAL
{
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	return SDAI.LOGICAL( lhs.asSwiftDouble > rhs.asSwiftDouble )
}

/// Numeric Value LessThan: Double \< Double = LOGICAL
///
public func <    <TD: SDAI.DoubleRepresentedNumberType, UD: SDAI.DoubleRepresentedNumberType>(
  lhs: TD?, rhs: UD?) -> SDAI.LOGICAL
{ rhs > lhs }

/// Numeric Value GreaterThanOrEqual: Double \>= Double = LOGICAL
///
public func >=   <TD: SDAI.DoubleRepresentedNumberType, UD: SDAI.DoubleRepresentedNumberType>(
  lhs: TD?, rhs: UD?) -> SDAI.LOGICAL
{ (lhs > rhs)||(lhs .==. rhs) }

/// Numeric Value LessThanOrEqual: Double \<= Double = LOGICAL
///
public func <=   <TD: SDAI.DoubleRepresentedNumberType, UD: SDAI.DoubleRepresentedNumberType>(
  lhs: TD?, rhs: UD?) -> SDAI.LOGICAL
{ (lhs < rhs)||(lhs .==. rhs) }


//MARK: double vs. integer
/// Numeric Value Equal: Double .==. Int = LOGICAL
///
public func .==. <TD: SDAI.DoubleRepresentedNumberType, UI: SDAI.IntRepresentedNumberType>(
  lhs: TD?, rhs: UI?) -> SDAI.LOGICAL
{ lhs .==. SDAI.REAL(rhs) }

/// Numeric Value NotEqual: Double .!=. Int = LOGICAL
///
public func .!=. <TD: SDAI.DoubleRepresentedNumberType, UI: SDAI.IntRepresentedNumberType>(
  lhs: TD?, rhs: UI?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }

/// Numeric Value GreaterThan: Double \> Int = LOGICAL
///
public func >    <TD: SDAI.DoubleRepresentedNumberType, UI: SDAI.IntRepresentedNumberType>(
  lhs: TD?, rhs: UI?) -> SDAI.LOGICAL
{ lhs > SDAI.REAL(rhs) }

/// Numeric Value LessThan: Double \< Int = LOGICAL
///
public func <    <TD: SDAI.DoubleRepresentedNumberType, UI: SDAI.IntRepresentedNumberType>(
  lhs: TD?, rhs: UI?) -> SDAI.LOGICAL
{ rhs > lhs }

/// Numeric Value GreaterThanOrEqual: Double \>= Int = LOGICAL
///
public func >=   <TD: SDAI.DoubleRepresentedNumberType, UI: SDAI.IntRepresentedNumberType>(
  lhs: TD?, rhs: UI?) -> SDAI.LOGICAL
{ (lhs > rhs)||(lhs .==. rhs) }

/// Numeric Value LessThanOrEqual: Double \<= Int = LOGICAL
///
public func <=   <TD: SDAI.DoubleRepresentedNumberType, UI: SDAI.IntRepresentedNumberType>(
  lhs: TD?, rhs: UI?) -> SDAI.LOGICAL
{ (lhs < rhs)||(lhs .==. rhs) }


//MARK: integer vs. select
/// Numeric Value Equal: Int .==. Select = LOGICAL
///
public func .==. <TI: SDAI.IntRepresentedNumberType, US: SDAI.SelectType>(
  lhs: TI?, rhs: US?) -> SDAI.LOGICAL
{
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	if let rhs = rhs.possiblyAsSwiftInt {
		return SDAI.LOGICAL( lhs.asSwiftInt == rhs )
	}
	else if let rhs = rhs.possiblyAsSwiftDouble {
		return SDAI.LOGICAL( lhs.asSwiftDouble == rhs )
	}
	return SDAI.FALSE
}

/// Numeric Value NotEqual: Int .!=. Select = LOGICAL
///
public func .!=. <TI: SDAI.IntRepresentedNumberType, US: SDAI.SelectType>(
  lhs: TI?, rhs: US?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }

/// Numeric Value GreaterThan: Int \> Select = LOGICAL
///
public func >    <TI: SDAI.IntRepresentedNumberType, US: SDAI.SelectType>(
  lhs: TI?, rhs: US?) -> SDAI.LOGICAL
{
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	if let rhs = rhs.possiblyAsSwiftInt {
		return SDAI.LOGICAL( lhs.asSwiftInt > rhs )
	}
	else if let rhs = rhs.possiblyAsSwiftDouble {
		return SDAI.LOGICAL( lhs.asSwiftDouble > rhs )
	}
	return SDAI.UNKNOWN
}

/// Numeric Value LessThan: Int \< Select = LOGICAL
///
public func <    <TI: SDAI.IntRepresentedNumberType, US: SDAI.SelectType>(
  lhs: TI?, rhs: US?) -> SDAI.LOGICAL
{ rhs > lhs }

/// Numeric Value GreaterThanOrEqual: Int \>= Select = LOGICAL
///
public func >=   <TI: SDAI.IntRepresentedNumberType, US: SDAI.SelectType>(
  lhs: TI?, rhs: US?) -> SDAI.LOGICAL
{ (lhs > rhs)||(lhs .==. rhs) }

/// Numeric Value LessThanOrEqual: Int \<= Select = LOGICAL
///
public func <=   <TI: SDAI.IntRepresentedNumberType, US: SDAI.SelectType>(
  lhs: TI?, rhs: US?) -> SDAI.LOGICAL
{ (lhs < rhs)||(lhs .==. rhs) }


//MARK: double vs. select
/// Numeric Value Equal: Double .==. Select = LOGICAL
///
public func .==. <TD: SDAI.DoubleRepresentedNumberType, US: SDAI.SelectType>(
  lhs: TD?, rhs: US?) -> SDAI.LOGICAL
{
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	if let rhs = rhs.possiblyAsSwiftDouble {
		return SDAI.LOGICAL( lhs.asSwiftDouble == rhs )
	}
	return SDAI.FALSE
}

/// Numeric Value NotEqual: Double .!=. Select = LOGICAL
///
public func .!=. <TD: SDAI.DoubleRepresentedNumberType, US: SDAI.SelectType>(
  lhs: TD?, rhs: US?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }

/// Numeric Value GreaterThan: Double \> Select = LOGICAL
///
public func >    <TD: SDAI.DoubleRepresentedNumberType, US: SDAI.SelectType>(
  lhs: TD?, rhs: US?) -> SDAI.LOGICAL
{
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	if let rhs = rhs.possiblyAsSwiftDouble {
		return SDAI.LOGICAL( lhs.asSwiftDouble > rhs )
	}
	return SDAI.UNKNOWN
}

/// Numeric Value LessThan: Double \< Select = LOGICAL
///
public func <    <TD: SDAI.DoubleRepresentedNumberType, US: SDAI.SelectType>(
  lhs: TD?, rhs: US?) -> SDAI.LOGICAL
{ rhs > lhs }

/// Numeric Value GreaterThanOrEqual: Double \>= Select = LOGICAL
///
public func >=   <TD: SDAI.DoubleRepresentedNumberType, US: SDAI.SelectType>(
  lhs: TD?, rhs: US?) -> SDAI.LOGICAL
{ (lhs > rhs)||(lhs .==. rhs) }

/// Numeric Value LessThanOrEqual: Double \<= Select = LOGICAL
///
public func <=   <TD: SDAI.DoubleRepresentedNumberType, US: SDAI.SelectType>(
  lhs: TD?, rhs: US?) -> SDAI.LOGICAL
{ (lhs < rhs)||(lhs .==. rhs) }


//MARK: select vs. select
/// Numeric Value Equal: Select .==. Select = LOGICAL
///
public func .==. <TS: SDAI.SelectType, US: SDAI.SelectType>(
  lhs: TS?, rhs: US?) -> SDAI.LOGICAL
{ SDAI.GENERIC(lhs) .==. SDAI.GENERIC(rhs) }

/// Numeric Value NotEqual: Select .!=. Select = LOGICAL
///
public func .!=. <TS: SDAI.SelectType, US: SDAI.SelectType>(
  lhs: TS?, rhs: US?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }

/// Numeric Value GreaterThan: Select \> Select = LOGICAL
///
public func >    <TS: SDAI.SelectType, US: SDAI.SelectType>(
  lhs: TS?, rhs: US?) -> SDAI.LOGICAL
{ SDAI.GENERIC(lhs) > SDAI.GENERIC(rhs) }

/// Numeric Value LessThan: Select \< Select = LOGICAL
///
public func <    <TS: SDAI.SelectType, US: SDAI.SelectType>(
  lhs: TS?, rhs: US?) -> SDAI.LOGICAL
{ rhs > lhs }

/// Numeric Value GreaterThanOrEqual: Select \>= Select = LOGICAL
///
public func >=   <TS: SDAI.SelectType, US: SDAI.SelectType>(
  lhs: TS?, rhs: US?) -> SDAI.LOGICAL
{ (lhs > rhs)||(lhs .==. rhs) }

/// Numeric Value LessThanOrEqual: Select \<= Select = LOGICAL
///
public func <=   <TS: SDAI.SelectType, US: SDAI.SelectType>(
  lhs: TS?, rhs: US?) -> SDAI.LOGICAL
{ (lhs < rhs)||(lhs .==. rhs) }


//MARK: select vs. integer
/// Numeric Value Equal: Select .==. Int = LOGICAL
///
public func .==. <TS: SDAI.SelectType, UI: SDAI.IntRepresentedNumberType>(
  lhs: TS?, rhs: UI?) -> SDAI.LOGICAL
{ rhs .==. lhs }

/// Numeric Value NotEqual: Select .!=. Int = LOGICAL
///
public func .!=. <TS: SDAI.SelectType, UI: SDAI.IntRepresentedNumberType>(
  lhs: TS?, rhs: UI?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }

/// Numeric Value GreaterThan: Select \> Int = LOGICAL
///
public func >    <TS: SDAI.SelectType, UI: SDAI.IntRepresentedNumberType>(
  lhs: TS?, rhs: UI?) -> SDAI.LOGICAL
{
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	if let lhs = lhs.possiblyAsSwiftInt {
		return SDAI.LOGICAL( lhs > rhs.asSwiftInt )
	}
	else if let lhs = lhs.possiblyAsSwiftDouble {
		return SDAI.LOGICAL( lhs > rhs.asSwiftDouble )
	}
	return SDAI.UNKNOWN
}

/// Numeric Value LessThan: Select \< Int = LOGICAL
///
public func <    <TS: SDAI.SelectType, UI: SDAI.IntRepresentedNumberType>(
  lhs: TS?, rhs: UI?) -> SDAI.LOGICAL
{ rhs > lhs }

/// Numeric Value GreaterThanOrEqual: Select \>= Int = LOGICAL
///
public func >=   <TS: SDAI.SelectType, UI: SDAI.IntRepresentedNumberType>(
  lhs: TS?, rhs: UI?) -> SDAI.LOGICAL
{ (lhs > rhs)||(lhs .==. rhs) }

/// Numeric Value LessThanOrEqual: Select \<= Int = LOGICAL
///
public func <=   <TS: SDAI.SelectType, UI: SDAI.IntRepresentedNumberType>(
  lhs: TS?, rhs: UI?) -> SDAI.LOGICAL
{ (lhs < rhs)||(lhs .==. rhs) }


//MARK: select vs. double
/// Numeric Value Equal: Select .==. Double = LOGICAL
///
public func .==. <TS: SDAI.SelectType, UD: SDAI.DoubleRepresentedNumberType>(
  lhs: TS?, rhs: UD?) -> SDAI.LOGICAL
{ rhs .==. lhs }

/// Numeric Value NotEqual: Select .!=. Double = LOGICAL
///
public func .!=. <TS: SDAI.SelectType, UD: SDAI.DoubleRepresentedNumberType>(
  lhs: TS?, rhs: UD?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }

/// Numeric Value GreaterThan: Select \> Double = LOGICAL
///
public func >    <TS: SDAI.SelectType, UD: SDAI.DoubleRepresentedNumberType>(
  lhs: TS?, rhs: UD?) -> SDAI.LOGICAL
{
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	if let lhs = lhs.possiblyAsSwiftDouble {
		return SDAI.LOGICAL( lhs > rhs.asSwiftDouble )
	}
	return SDAI.UNKNOWN
}

/// Numeric Value LessThan: Select \< Double = LOGICAL
///
public func <    <TS: SDAI.SelectType, UD: SDAI.DoubleRepresentedNumberType>(
  lhs: TS?, rhs: UD?) -> SDAI.LOGICAL
{ rhs > lhs }

/// Numeric Value GreaterThanOrEqual: Select \>= Double = LOGICAL
///
public func >=   <TS: SDAI.SelectType, UD: SDAI.DoubleRepresentedNumberType>(
  lhs: TS?, rhs: UD?) -> SDAI.LOGICAL
{ (lhs > rhs)||(lhs .==. rhs) }

/// Numeric Value LessThanOrEqual: Select \<= Double = LOGICAL
///
public func <=   <TS: SDAI.SelectType, UD: SDAI.DoubleRepresentedNumberType>(
  lhs: TS?, rhs: UD?) -> SDAI.LOGICAL
{ (lhs < rhs)||(lhs .==. rhs) }


