//
//  SdaiArithmetic.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - Arithmetic operators (12.1)
/// Arithmetic Identity
///
 public prefix func + <T: SDAI.NumberType>(
  number: T?) -> T?
{
	return number
}

/// Arithmetic Negation
 public prefix func - <T: SDAI.NumberType>(
  number: T?) -> T?
{
	guard let number = number else { return nil }
	return T( from: -(number.asSwiftType) )
}

//MARK: Int vs. Int
/// Arithmetic Addition: Int + Int = INTEGER
///
public func +   <TI: SDAI.IntRepresentedNumberType, UI: SDAI.IntRepresented>(
  lhs: TI?, rhs: UI?) -> SDAI.INTEGER?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return SDAI.INTEGER( lhs.asSwiftInt + rhs.asSwiftInt )
}

/// Arithmetic Subtraction: Int - Int = INTEGER
///
public func -   <TI: SDAI.IntRepresentedNumberType, UI: SDAI.IntRepresented>(
  lhs: TI?, rhs: UI?) -> SDAI.INTEGER?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return SDAI.INTEGER( lhs.asSwiftInt - rhs.asSwiftInt )
}

/// Arithmetic Multiplication: Int \* Int = INTEGER
///
public func *   <TI: SDAI.IntRepresentedNumberType, UI: SDAI.IntRepresented>(
  lhs: TI?, rhs: UI?) -> SDAI.INTEGER?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return SDAI.INTEGER( lhs.asSwiftInt * rhs.asSwiftInt )
}

/// Arithmetic Real Division: Int / Int = REAL
///
public func /   <TI: SDAI.IntRepresentedNumberType, UI: SDAI.IntRepresented>(
  lhs: TI?, rhs: UI?) -> SDAI.REAL?
{
	SDAI.REAL(lhs) / SDAI.REAL(rhs?.asSwiftDouble)
}

/// Arithmetic Exponentiation: Int \*\* Int = INTEGER
///
public func **  <TI: SDAI.IntRepresentedNumberType, UI: SDAI.IntRepresented>(
  lhs: TI?, rhs: UI?) -> SDAI.INTEGER?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return SDAI.INTEGER(truncating: pow(lhs.asSwiftDouble, rhs.asSwiftDouble) )
}

/// Arithmetic Integer Division (DIV): Int ./. Int = INTEGER
///
public func ./. <TI: SDAI.IntRepresentedNumberType, UI: SDAI.IntRepresented>(
  lhs: TI?, rhs: UI?) -> SDAI.INTEGER?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return SDAI.INTEGER( lhs.asSwiftInt / rhs.asSwiftInt )
}

/// Arithmetic Modulo (MOD): Int % Int = INTEGER
///
public func %   <TI: SDAI.IntRepresentedNumberType, UI: SDAI.IntRepresented>(
  lhs: TI?, rhs: UI?) -> SDAI.INTEGER?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	let sign = rhs.asSwiftInt >= 0 ? 1 : -1
	return (lhs - (lhs ./. rhs) * rhs) * sign
}


//MARK: Int vs. Double
/// Arithmetic Addition: Int + Double = REAL
///
public func +   <TI: SDAI.IntRepresentedNumberType, UD: SDAI.DoubleRepresented>(
  lhs: TI?, rhs: UD?) -> SDAI.REAL?
{
	SDAI.REAL(lhs) + rhs
}

/// Arithmetic Subtraction: Int - Double = REAL
///
public func -   <TI: SDAI.IntRepresentedNumberType, UD: SDAI.DoubleRepresented>(
  lhs: TI?, rhs: UD?) -> SDAI.REAL?
{
	SDAI.REAL(lhs) - rhs
}

/// Arithmetic Multiplication: Int \* Double = REAL
///
public func *   <TI: SDAI.IntRepresentedNumberType, UD: SDAI.DoubleRepresented>(
  lhs: TI?, rhs: UD?) -> SDAI.REAL?
{
	SDAI.REAL(lhs) * rhs
}

/// Arithmetic Real Division: Int / Double = REAL
///
public func /   <TI: SDAI.IntRepresentedNumberType, UD: SDAI.DoubleRepresented>(
  lhs: TI?, rhs: UD?) -> SDAI.REAL?
{
	SDAI.REAL(lhs) / rhs
}

/// Arithmetic Exponentiation: Int \*\* Double = REAL
///
public func **  <TI: SDAI.IntRepresentedNumberType, UD: SDAI.DoubleRepresented>(
  lhs: TI?, rhs: UD?) -> SDAI.REAL?
{
	SDAI.REAL(lhs) ** rhs
}

/// Arithmetic Integer Division (DIV): Int ./. Double = INTEGER
///
public func ./. <TI: SDAI.IntRepresentedNumberType, UD: SDAI.DoubleRepresented>(
  lhs: TI?, rhs: UD?) -> SDAI.INTEGER?
{
	lhs ./. SDAI.INTEGER(truncating: rhs)
}

/// Arithmetic Modulo (MOD): Int % Double = INTEGER
///
public func %   <TI: SDAI.IntRepresentedNumberType, UD: SDAI.DoubleRepresented>(
  lhs: TI?, rhs: UD?) -> SDAI.INTEGER?
{
	lhs % SDAI.INTEGER(truncating: rhs)
}


//MARK: Double vs. Double
/// Arithmetic Addition: Double + Double = REAL
///
public func +   <TD: SDAI.DoubleRepresentedNumberType, UD: SDAI.DoubleRepresented>(
  lhs: TD?, rhs: UD?) -> SDAI.REAL?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return SDAI.REAL( lhs.asSwiftDouble + rhs.asSwiftDouble )
}

/// Arithmetic Subtraction: Double - Double = REAL
///
public func -   <TD: SDAI.DoubleRepresentedNumberType, UD: SDAI.DoubleRepresented>(
  lhs: TD?, rhs: UD?) -> SDAI.REAL?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return SDAI.REAL( lhs.asSwiftDouble - rhs.asSwiftDouble )
}

/// Arithmetic Multiplication: Double \* Double = REAL
///
public func *   <TD: SDAI.DoubleRepresentedNumberType, UD: SDAI.DoubleRepresented>(
  lhs: TD?, rhs: UD?) -> SDAI.REAL?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return SDAI.REAL( lhs.asSwiftDouble * rhs.asSwiftDouble )
}

/// Arithmetic Real Division: Double / Double = REAL
///
public func /   <TD: SDAI.DoubleRepresentedNumberType, UD: SDAI.DoubleRepresented>(
  lhs: TD?, rhs: UD?) -> SDAI.REAL?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return SDAI.REAL( lhs.asSwiftDouble / rhs.asSwiftDouble )
}

/// Arithmetic Exponentiation: Double \*\* Double = REAL
///
public func **  <TD: SDAI.DoubleRepresentedNumberType, UD: SDAI.DoubleRepresented>(
  lhs: TD?, rhs: UD?) -> SDAI.REAL?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return SDAI.REAL( pow(lhs.asSwiftDouble, rhs.asSwiftDouble) )
}

/// Arithmetic Integer Division (DIV): Double ./. Double = INTEGER
///
public func ./. <TD: SDAI.DoubleRepresentedNumberType, UD: SDAI.DoubleRepresented>(
  lhs: TD?, rhs: UD?) -> SDAI.INTEGER?
{
	SDAI.INTEGER(truncating: lhs) ./. SDAI.INTEGER(truncating: rhs)
}

/// Arithmetic Modulo (MOD): Double % Double = INTEGER
///
public func %   <TD: SDAI.DoubleRepresentedNumberType, UD: SDAI.DoubleRepresented>(
  lhs: TD?, rhs: UD?) -> SDAI.INTEGER?
{
	SDAI.INTEGER(truncating: lhs) % SDAI.INTEGER(truncating: rhs)
}


//MARK: Double vs. Int
/// Arithmetic Addition: Double + Int = REAL
///
public func +   <TD: SDAI.DoubleRepresentedNumberType, UI: SDAI.IntRepresented>(
  lhs: TD?, rhs: UI?) -> SDAI.REAL?
{
	lhs + SDAI.REAL(rhs?.asSwiftDouble)
}

/// Arithmetic Subtraction: Double - Int = REAL
///
public func -   <TD: SDAI.DoubleRepresentedNumberType, UI: SDAI.IntRepresented>(
  lhs: TD?, rhs: UI?) -> SDAI.REAL?
{
	lhs - SDAI.REAL(rhs?.asSwiftDouble)
}

/// Arithmetic Multiplication: Double \* Int = REAL
///
public func *   <TD: SDAI.DoubleRepresentedNumberType, UI: SDAI.IntRepresented>(
  lhs: TD?, rhs: UI?) -> SDAI.REAL?
{
	lhs * SDAI.REAL(rhs?.asSwiftDouble)
}

/// Arithmetic Real Division: Double / Int = REAL
///
public func /   <TD: SDAI.DoubleRepresentedNumberType, UI: SDAI.IntRepresented>(
  lhs: TD?, rhs: UI?) -> SDAI.REAL?
{
	lhs / SDAI.REAL(rhs?.asSwiftDouble)
}

/// Arithmetic Exponentiation: Double \*\* Int = REAL
///
public func **  <TD: SDAI.DoubleRepresentedNumberType, UI: SDAI.IntRepresented>(
  lhs: TD?, rhs: UI?) -> SDAI.REAL?
{
	lhs ** SDAI.REAL(rhs?.asSwiftDouble)
}

/// Arithmetic Integer Division (DIV): Double ./. Int = INTEGER
///
public func ./. <TD: SDAI.DoubleRepresentedNumberType, UI: SDAI.IntRepresented>(
  lhs: TD?, rhs: UI?) -> SDAI.INTEGER?
{
	SDAI.INTEGER(lhs) ./. rhs
}

/// Arithmetic Modulo (MOD): Double % Int = INTEGER
///
public func %   <TD: SDAI.DoubleRepresentedNumberType, UI: SDAI.IntRepresented>(
  lhs: TD?, rhs: UI?) -> SDAI.INTEGER?
{
	SDAI.INTEGER(lhs) % rhs
}


//MARK: Double vs. Select
/// Arithmetic Addition: Double + Select = REAL
///
public func +   <TD: SDAI.DoubleRepresentedNumberType, US: SDAI.SelectType>(
  lhs: TD?, rhs: US?) -> SDAI.REAL?
{
	lhs + rhs?.realValue
}

/// Arithmetic Subtraction: Double - Select = REAL
///
public func -   <TD: SDAI.DoubleRepresentedNumberType, US: SDAI.SelectType>(
  lhs: TD?, rhs: US?) -> SDAI.REAL?
{
	lhs - rhs?.realValue
}

/// Arithmetic Multiplication: Double \* Select = REAL
///
public func *   <TD: SDAI.DoubleRepresentedNumberType, US: SDAI.SelectType>(
  lhs: TD?, rhs: US?) -> SDAI.REAL?
{
	lhs * rhs?.realValue
}

/// Arithmetic Real Division: Double / Select = REAL
///
public func /   <TD: SDAI.DoubleRepresentedNumberType, US: SDAI.SelectType>(
  lhs: TD?, rhs: US?) -> SDAI.REAL?
{
	lhs / rhs?.realValue
}

/// Arithmetic Exponentiation: Double \*\* Select = REAL
///
public func **  <TD: SDAI.DoubleRepresentedNumberType, US: SDAI.SelectType>(
  lhs: TD?, rhs: US?) -> SDAI.REAL?
{
	lhs ** rhs?.realValue
}

/// Arithmetic Integer Division (DIV): Double ./. Select = INTEGER
///
public func ./. <TD: SDAI.DoubleRepresentedNumberType, US: SDAI.SelectType>(
  lhs: TD?, rhs: US?) -> SDAI.INTEGER?
{
	if let rhs = rhs?.integerValue { return lhs ./. rhs }
	return lhs ./. rhs?.realValue
}

/// Arithmetic Modulo (MOD): Double % Select = INTEGER
///
public func %   <TD: SDAI.DoubleRepresentedNumberType, US: SDAI.SelectType>(
  lhs: TD?, rhs: US?) -> SDAI.INTEGER?
{
	if let rhs = rhs?.integerValue { return lhs % rhs }
	return lhs % rhs?.realValue
}

//MARK: Select vs. Double
/// Arithmetic Addition: Select + Double = REAL
///
public func +   <TS: SDAI.SelectType, UD: SDAI.DoubleRepresented>(
  lhs: TS?, rhs: UD?) -> SDAI.REAL?
{
	lhs?.realValue + rhs
}

/// Arithmetic Subtraction: Select - Double = REAL
///
public func -   <TS: SDAI.SelectType, UD: SDAI.DoubleRepresented>(
  lhs: TS?, rhs: UD?) -> SDAI.REAL?
{
	lhs?.realValue - rhs
}

/// Arithmetic Multiplication: Select \* Double = REAL
///
public func *   <TS: SDAI.SelectType, UD: SDAI.DoubleRepresented>(
  lhs: TS?, rhs: UD?) -> SDAI.REAL?
{
	lhs?.realValue * rhs
}

/// Arithmetic Real Division: Select / Double = REAL
///
public func /   <TS: SDAI.SelectType, UD: SDAI.DoubleRepresented>(
  lhs: TS?, rhs: UD?) -> SDAI.REAL?
{
	lhs?.realValue / rhs
}

/// Arithmetic Exponentiation: Select \*\* Double = REAL
///
public func **  <TS: SDAI.SelectType, UD: SDAI.DoubleRepresented>(
  lhs: TS?, rhs: UD?) -> SDAI.REAL?
{
	lhs?.realValue ** rhs
}

/// Arithmetic Integer Division (DIV): Select ./. Double = INTEGER
///
public func ./. <TS: SDAI.SelectType, UD: SDAI.DoubleRepresented>(
  lhs: TS?, rhs: UD?) -> SDAI.INTEGER?
{
	if let lhs = lhs?.integerValue { return lhs ./. rhs }
	return lhs?.realValue ./. rhs
}

/// Arithmetic Modulo (MOD): Select % Double = INTEGER
///
public func %   <TS: SDAI.SelectType, UD: SDAI.DoubleRepresented>(
  lhs: TS?, rhs: UD?) -> SDAI.INTEGER?
{
	if let lhs = lhs?.integerValue { return lhs ./. rhs }
	return lhs?.realValue % rhs
}

//MARK: Int vs. Select
/// Arithmetic Addition: Int + Select = INTEGER
///
public func +   <TI: SDAI.IntRepresentedNumberType, US: SDAI.SelectType>(
  lhs: TI?, rhs: US?) -> SDAI.INTEGER?
{
	lhs + rhs?.integerValue
}

/// Arithmetic Subtraction: Int - Select = INTEGER
///
public func -   <TI: SDAI.IntRepresentedNumberType, US: SDAI.SelectType>(
  lhs: TI?, rhs: US?) -> SDAI.INTEGER?
{
	lhs - rhs?.integerValue
}

/// Arithmetic Multiplication: Int \* Select = INTEGER
///
public func *   <TI: SDAI.IntRepresentedNumberType, US: SDAI.SelectType>(
  lhs: TI?, rhs: US?) -> SDAI.INTEGER?
{
	lhs * rhs?.integerValue
}

/// Arithmetic Real Division: Int / Select = REAL
///
public func /   <TI: SDAI.IntRepresentedNumberType, US: SDAI.SelectType>(
  lhs: TI?, rhs: US?) -> SDAI.REAL?
{
	lhs / rhs?.integerValue
}

/// Arithmetic Exponentiation: Int \*\* Select = INTEGER
///
public func **  <TI: SDAI.IntRepresentedNumberType, US: SDAI.SelectType>(
  lhs: TI?, rhs: US?) -> SDAI.INTEGER?
{
	lhs ** rhs?.integerValue
}

/// Arithmetic Integer Division (DIV): Int ./. Select = INTEGER
///
public func ./. <TI: SDAI.IntRepresentedNumberType, US: SDAI.SelectType>(
  lhs: TI?, rhs: US?) -> SDAI.INTEGER?
{
	lhs ./. rhs?.integerValue
}

/// Arithmetic Modulo (MOD): Int % Select = INTEGER
///
public func %   <TI: SDAI.IntRepresentedNumberType, US: SDAI.SelectType>(
  lhs: TI?, rhs: US?) -> SDAI.INTEGER?
{
	lhs % rhs?.integerValue
}

//MARK: Select vs. Int
/// Arithmetic Addition: Select + Int = INTEGER
///
public func +   <TS: SDAI.SelectType, UI: SDAI.IntRepresented>(
  lhs: TS?, rhs: UI?) -> SDAI.INTEGER?
{
	lhs?.integerValue + rhs
}

/// Arithmetic Subtraction: Select - Int = INTEGER
///
public func -   <TS: SDAI.SelectType, UI: SDAI.IntRepresented>(
  lhs: TS?, rhs: UI?) -> SDAI.INTEGER?
{
	lhs?.integerValue - rhs
}

/// Arithmetic Multiplication: Select \* Int = INTEGER
///
public func *   <TS: SDAI.SelectType, UI: SDAI.IntRepresented>(
  lhs: TS?, rhs: UI?) -> SDAI.INTEGER?
{
	lhs?.integerValue * rhs
}

/// Arithmetic Real Division: Select / Int = REAL
///
public func /   <TS: SDAI.SelectType, UI: SDAI.IntRepresented>(
  lhs: TS?, rhs: UI?) -> SDAI.REAL?
{
	lhs?.integerValue / rhs
}

/// Arithmetic Exponentiation: Select \*\* Int = INTEGER
///
public func **  <TS: SDAI.SelectType, UI: SDAI.IntRepresented>(
  lhs: TS?, rhs: UI?) -> SDAI.INTEGER?
{
	lhs?.integerValue ** rhs
}

/// Arithmetic Integer Division (DIV): Select ./. Int = INTEGER
///
public func ./. <TS: SDAI.SelectType, UI: SDAI.IntRepresented>(
  lhs: TS?, rhs: UI?) -> SDAI.INTEGER?
{
	lhs?.integerValue ./. rhs
}

/// Arithmetic Modulo (MOD): Select % Int = INTEGER
///
public func %   <TS: SDAI.SelectType, UI: SDAI.IntRepresented>(
  lhs: TS?, rhs: UI?) -> SDAI.INTEGER?
{
	lhs?.integerValue % rhs
}


