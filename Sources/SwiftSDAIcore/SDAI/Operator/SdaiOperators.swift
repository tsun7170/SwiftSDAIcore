//
//  File.swift
//  
//
//  Created by Yoshida on 2020/11/04.
//

import Foundation

infix operator ** : BitwiseShiftPrecedence
infix operator ./. : MultiplicationPrecedence
infix operator .==. : ComparisonPrecedence
infix operator .!=. : ComparisonPrecedence
infix operator .===. : ComparisonPrecedence
infix operator .!==. : ComparisonPrecedence
infix operator .||. : AdditionPrecedence

//MARK: - index range support
public func ... <T: SDAIIntRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> ClosedRange<Int>? { abstruct() }
public func ... <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Int?) -> ClosedRange<Int>? { abstruct() }
public func ... <U: SDAIIntRepresentedNumberType>(lhs: Int?, rhs: U?) -> ClosedRange<Int>? { abstruct() }

//MARK: - Arithmetic operators
 public prefix func + <T: SDAINumberType>(number: T?) -> T? {
	return number
}

 public prefix func - <T: SDAINumberType>(number: T?) -> T? {
	guard let number = number else { return nil }
	return T( -(number.asSwiftType) )
}

public func +   <T: SDAIIntRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { abstruct() }
public func -   <T: SDAIIntRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { abstruct() }
public func *   <T: SDAIIntRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { abstruct() }
public func /   <T: SDAIIntRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.REAL? { abstruct() }
public func **  <T: SDAIIntRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { abstruct() }
public func ./. <T: SDAIIntRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { abstruct() }
public func %   <T: SDAIIntRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { abstruct() }

public func +   <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.INTEGER? { abstruct() }
public func -   <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.INTEGER? { abstruct() }
public func *   <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.INTEGER? { abstruct() }
public func /   <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.REAL? { abstruct() }
public func **  <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.INTEGER? { abstruct() }
public func ./. <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.INTEGER? { abstruct() }
public func %   <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.INTEGER? { abstruct() }

public func +   <U: SDAIIntRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.INTEGER? { abstruct() }
public func -   <U: SDAIIntRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.INTEGER? { abstruct() }
public func *   <U: SDAIIntRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.INTEGER? { abstruct() }
public func /   <U: SDAIIntRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.REAL? { abstruct() }
public func **  <U: SDAIIntRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.INTEGER? { abstruct() }
public func ./. <U: SDAIIntRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.INTEGER? { abstruct() }
public func %   <U: SDAIIntRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.INTEGER? { abstruct() }


public func +   <T: SDAIIntRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.REAL? { abstruct() }
public func -   <T: SDAIIntRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.REAL? { abstruct() }
public func *   <T: SDAIIntRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.REAL? { abstruct() }
public func /   <T: SDAIIntRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.REAL? { abstruct() }
public func **  <T: SDAIIntRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.REAL? { abstruct() }
public func ./. <T: SDAIIntRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { abstruct() }
public func %   <T: SDAIIntRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { abstruct() }

public func +   <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.REAL? { abstruct() }
public func -   <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.REAL? { abstruct() }
public func *   <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.REAL? { abstruct() }
public func /   <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.REAL? { abstruct() }
public func **  <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.REAL? { abstruct() }
public func ./. <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.INTEGER? { abstruct() }
public func %   <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.INTEGER? { abstruct() }

public func +   <U: SDAIDoubleRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.REAL? { abstruct() }
public func -   <U: SDAIDoubleRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.REAL? { abstruct() }
public func *   <U: SDAIDoubleRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.REAL? { abstruct() }
public func /   <U: SDAIDoubleRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.REAL? { abstruct() }
public func **  <U: SDAIDoubleRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.REAL? { abstruct() }
public func ./. <U: SDAIDoubleRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.INTEGER? { abstruct() }
public func %   <U: SDAIDoubleRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.INTEGER? { abstruct() }


public func +   <T: SDAIDoubleRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.REAL? { abstruct() }
public func -   <T: SDAIDoubleRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.REAL? { abstruct() }
public func *   <T: SDAIDoubleRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.REAL? { abstruct() }
public func /   <T: SDAIDoubleRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.REAL? { abstruct() }
public func **  <T: SDAIDoubleRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.REAL? { abstruct() }
public func ./. <T: SDAIDoubleRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { abstruct() }
public func %   <T: SDAIDoubleRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { abstruct() }

public func +   <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.REAL? { abstruct() }
public func -   <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.REAL? { abstruct() }
public func *   <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.REAL? { abstruct() }
public func /   <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.REAL? { abstruct() }
public func **  <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.REAL? { abstruct() }
public func ./. <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.INTEGER? { abstruct() }
public func %   <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.INTEGER? { abstruct() }

public func +   <U: SDAIDoubleRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.REAL? { abstruct() }
public func -   <U: SDAIDoubleRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.REAL? { abstruct() }
public func *   <U: SDAIDoubleRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.REAL? { abstruct() }
public func /   <U: SDAIDoubleRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.REAL? { abstruct() }
public func **  <U: SDAIDoubleRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.REAL? { abstruct() }
public func ./. <U: SDAIDoubleRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.INTEGER? { abstruct() }
public func %   <U: SDAIDoubleRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.INTEGER? { abstruct() }


public func +   <T: SDAIDoubleRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.REAL? { abstruct() }
public func -   <T: SDAIDoubleRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.REAL? { abstruct() }
public func *   <T: SDAIDoubleRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.REAL? { abstruct() }
public func /   <T: SDAIDoubleRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.REAL? { abstruct() }
public func **  <T: SDAIDoubleRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.REAL? { abstruct() }
public func ./. <T: SDAIDoubleRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { abstruct() }
public func %   <T: SDAIDoubleRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { abstruct() }

public func +   <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.REAL? { abstruct() }
public func -   <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.REAL? { abstruct() }
public func *   <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.REAL? { abstruct() }
public func /   <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.REAL? { abstruct() }
public func **  <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.REAL? { abstruct() }
public func ./. <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.INTEGER? { abstruct() }
public func %   <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.INTEGER? { abstruct() }

public func +   <U: SDAIIntRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.REAL? { abstruct() }
public func -   <U: SDAIIntRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.REAL? { abstruct() }
public func *   <U: SDAIIntRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.REAL? { abstruct() }
public func /   <U: SDAIIntRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.REAL? { abstruct() }
public func **  <U: SDAIIntRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.REAL? { abstruct() }
public func ./. <U: SDAIIntRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.INTEGER? { abstruct() }
public func %   <U: SDAIIntRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.INTEGER? { abstruct() }


//MARK: - Value comparison operators
//MARK: - Numeric comparisons
public func .==. <T: SDAIIntRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAIIntRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >    <T: SDAIIntRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <    <T: SDAIIntRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >=   <T: SDAIIntRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <=   <T: SDAIIntRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .==. <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.LOGICAL { abstruct() }
public func >    <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.LOGICAL { abstruct() }
public func <    <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.LOGICAL { abstruct() }
public func >=   <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.LOGICAL { abstruct() }
public func <=   <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.LOGICAL { abstruct() }

public func .==. <U: SDAIIntRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <U: SDAIIntRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >    <U: SDAIIntRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <    <U: SDAIIntRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >=   <U: SDAIIntRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <=   <U: SDAIIntRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.LOGICAL { abstruct() }


public func .==. <T: SDAIIntRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAIIntRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >    <T: SDAIIntRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <    <T: SDAIIntRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >=   <T: SDAIIntRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <=   <T: SDAIIntRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .==. <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.LOGICAL { abstruct() }
public func >    <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.LOGICAL { abstruct() }
public func <    <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.LOGICAL { abstruct() }
public func >=   <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.LOGICAL { abstruct() }
public func <=   <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.LOGICAL { abstruct() }

public func .==. <U: SDAIDoubleRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <U: SDAIDoubleRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >    <U: SDAIDoubleRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <    <U: SDAIDoubleRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >=   <U: SDAIDoubleRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <=   <U: SDAIDoubleRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.LOGICAL { abstruct() }


public func .==. <T: SDAIDoubleRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAIDoubleRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >    <T: SDAIDoubleRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <    <T: SDAIDoubleRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >=   <T: SDAIDoubleRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <=   <T: SDAIDoubleRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .==. <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.LOGICAL { abstruct() }
public func >    <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.LOGICAL { abstruct() }
public func <    <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.LOGICAL { abstruct() }
public func >=   <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.LOGICAL { abstruct() }
public func <=   <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.LOGICAL { abstruct() }

public func .==. <U: SDAIDoubleRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <U: SDAIDoubleRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >    <U: SDAIDoubleRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <    <U: SDAIDoubleRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >=   <U: SDAIDoubleRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <=   <U: SDAIDoubleRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.LOGICAL { abstruct() }


public func .==. <T: SDAIDoubleRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAIDoubleRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >    <T: SDAIDoubleRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <    <T: SDAIDoubleRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >=   <T: SDAIDoubleRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <=   <T: SDAIDoubleRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .==. <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.LOGICAL { abstruct() }
public func >    <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.LOGICAL { abstruct() }
public func <    <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.LOGICAL { abstruct() }
public func >=   <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.LOGICAL { abstruct() }
public func <=   <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.LOGICAL { abstruct() }

public func .==. <U: SDAIIntRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <U: SDAIIntRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >    <U: SDAIIntRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <    <U: SDAIIntRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >=   <U: SDAIIntRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <=   <U: SDAIIntRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.LOGICAL { abstruct() }


//MARK: - Binary comparisons
public func .==. <T: SDAIBinaryType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAIBinaryType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >    <T: SDAIBinaryType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <    <T: SDAIBinaryType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >=   <T: SDAIBinaryType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <=   <T: SDAIBinaryType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .==. <T: SDAIBinaryType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAIBinaryType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }
public func >    <T: SDAIBinaryType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }
public func <    <T: SDAIBinaryType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }
public func >=   <T: SDAIBinaryType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }
public func <=   <T: SDAIBinaryType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }

public func .==. <U: SDAIBinaryType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <U: SDAIBinaryType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >    <U: SDAIBinaryType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <    <U: SDAIBinaryType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >=   <U: SDAIBinaryType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <=   <U: SDAIBinaryType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

//MARK: - Logical comparisons
public func .==. <T: SDAILogicalType, U: SDAILogicalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAILogicalType, U: SDAILogicalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >    <T: SDAILogicalType, U: SDAILogicalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <    <T: SDAILogicalType, U: SDAILogicalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >=   <T: SDAILogicalType, U: SDAILogicalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <=   <T: SDAILogicalType, U: SDAILogicalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

//MARK: - String comparisons
public func .==. <T: SDAIStringType, U: SDAIStringType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAIStringType, U: SDAIStringType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >    <T: SDAIStringType, U: SDAIStringType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <    <T: SDAIStringType, U: SDAIStringType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >=   <T: SDAIStringType, U: SDAIStringType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <=   <T: SDAIStringType, U: SDAIStringType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .==. <T: SDAIStringType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAIStringType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }
public func >    <T: SDAIStringType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }
public func <    <T: SDAIStringType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }
public func >=   <T: SDAIStringType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }
public func <=   <T: SDAIStringType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }

public func .==. <U: SDAIStringType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <U: SDAIStringType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >    <U: SDAIStringType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <    <U: SDAIStringType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >=   <U: SDAIStringType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <=   <U: SDAIStringType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

//MARK: - Enumeration item comparisons
public func .==. <T: SDAIEnumerationType,U: SDAIEnumerationType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL where T.FundamentalType == U.FundamentalType { abstruct() }
public func .!=. <T: SDAIEnumerationType,U: SDAIEnumerationType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL where T.FundamentalType == U.FundamentalType { abstruct() }
public func >    <T: SDAIEnumerationType,U: SDAIEnumerationType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL where T.FundamentalType == U.FundamentalType { abstruct() }
public func <    <T: SDAIEnumerationType,U: SDAIEnumerationType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL where T.FundamentalType == U.FundamentalType { abstruct() }
public func >=   <T: SDAIEnumerationType,U: SDAIEnumerationType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL where T.FundamentalType == U.FundamentalType { abstruct() }
public func <=   <T: SDAIEnumerationType,U: SDAIEnumerationType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL where T.FundamentalType == U.FundamentalType { abstruct() }

//MARK: - Aggregate value comparisons
public func .==. <T: SDAIArrayOptionalType, U: SDAIArrayOptionalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAIArrayOptionalType, U: SDAIArrayOptionalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .==. <T: SDAIListType, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAIListType, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .==. <T: SDAIBagType, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAIBagType, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

//MARK: - Entity value comparisons
public func .==. (lhs: SDAI.EntityReference?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL { abstruct() }
public func .!=. (lhs: SDAI.EntityReference?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL { abstruct() }

public func .==. <U: SDAISelectType>(lhs: SDAI.EntityReference?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <U: SDAISelectType>(lhs: SDAI.EntityReference?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .==. (lhs: SDAI.EntityReference?, rhs: SDAI.PartialEntity?) -> SDAI.LOGICAL { abstruct() }
public func .!=. (lhs: SDAI.EntityReference?, rhs: SDAI.PartialEntity?) -> SDAI.LOGICAL { abstruct() }


public func .==. <T: SDAISelectType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAISelectType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .==. <T: SDAISelectType>(lhs: T?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAISelectType>(lhs: T?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL { abstruct() }

public func .==. <T: SDAISelectType>(lhs: T?, rhs: SDAI.PartialEntity?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAISelectType>(lhs: T?, rhs: SDAI.PartialEntity?) -> SDAI.LOGICAL { abstruct() }


public func .==. (lhs: SDAI.PartialEntity?, rhs: SDAI.PartialEntity?) -> SDAI.LOGICAL { abstruct() }
public func .!=. (lhs: SDAI.PartialEntity?, rhs: SDAI.PartialEntity?) -> SDAI.LOGICAL { abstruct() }

public func .==. (lhs: SDAI.PartialEntity?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL { abstruct() }
public func .!=. (lhs: SDAI.PartialEntity?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL { abstruct() }

public func .==. <U: SDAISelectType>(lhs: SDAI.PartialEntity?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <U: SDAISelectType>(lhs: SDAI.PartialEntity?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

//MARK: - Instance comparison operators (numeric, logical, string, binary and enumeration)
public func .===. <T: SDAIIntRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!==. <T: SDAIIntRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .===. <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.LOGICAL { abstruct() }
public func .!==. <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.LOGICAL { abstruct() }
public func .===. <U: SDAIIntRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!==. <U: SDAIIntRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .===. <T: SDAIIntRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!==. <T: SDAIIntRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .===. <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.LOGICAL { abstruct() }
public func .!==. <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.LOGICAL { abstruct() }
public func .===. <U: SDAIDoubleRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!==. <U: SDAIDoubleRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .===. <T: SDAIDoubleRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!==. <T: SDAIDoubleRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .===. <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.LOGICAL { abstruct() }
public func .!==. <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.LOGICAL { abstruct() }
public func .===. <U: SDAIDoubleRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!==. <U: SDAIDoubleRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .===. <T: SDAIDoubleRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!==. <T: SDAIDoubleRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .===. <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.LOGICAL { abstruct() }
public func .!==. <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.LOGICAL { abstruct() }
public func .===. <U: SDAIIntRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!==. <U: SDAIIntRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .===. <T: SDAILogicalType, U: SDAILogicalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!==. <T: SDAILogicalType, U: SDAILogicalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .===. <T: SDAIStringType, U: SDAIStringType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!==. <T: SDAIStringType, U: SDAIStringType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .===. <T: SDAIStringType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }
public func .!==. <T: SDAIStringType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }
public func .===. <U: SDAIStringType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!==. <U: SDAIStringType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .===. <T: SDAIBinaryType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!==. <T: SDAIBinaryType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .===. <T: SDAIBinaryType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }
public func .!==. <T: SDAIBinaryType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { abstruct() }
public func .===. <U: SDAIBinaryType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!==. <U: SDAIBinaryType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .===. <T: SDAIEnumerationType>(lhs: T?, rhs: T?) -> SDAI.LOGICAL { abstruct() }
public func .!==. <T: SDAIEnumerationType>(lhs: T?, rhs: T?) -> SDAI.LOGICAL { abstruct() }


//MARK: - Aggregate instance comparison
public func .===. <T: SDAIArrayOptionalType, U: SDAIArrayOptionalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!==. <T: SDAIArrayOptionalType, U: SDAIArrayOptionalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .===. <T: SDAIListType, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!==. <T: SDAIListType, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .===. <T: SDAIBagType, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!==. <T: SDAIBagType, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

//MARK: - Entity instance comparison
public func .===. (lhs: SDAI.EntityReference?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL { abstruct() }
public func .!==. (lhs: SDAI.EntityReference?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL { abstruct() }

public func .===. <U: SDAISelectType>(lhs: SDAI.EntityReference?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!==. <U: SDAISelectType>(lhs: SDAI.EntityReference?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .===. (lhs: SDAI.EntityReference?, rhs: SDAI.PartialEntity?) -> SDAI.LOGICAL { abstruct() }
public func .!==. (lhs: SDAI.EntityReference?, rhs: SDAI.PartialEntity?) -> SDAI.LOGICAL { abstruct() }


public func .===. <T: SDAISelectType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!==. <T: SDAISelectType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .===. <T: SDAISelectType>(lhs: T?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL { abstruct() }
public func .!==. <T: SDAISelectType>(lhs: T?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL { abstruct() }

public func .===. <T: SDAISelectType>(lhs: T?, rhs: SDAI.PartialEntity?) -> SDAI.LOGICAL { abstruct() }
public func .!==. <T: SDAISelectType>(lhs: T?, rhs: SDAI.PartialEntity?) -> SDAI.LOGICAL { abstruct() }


public func .===. (lhs: SDAI.PartialEntity?, rhs: SDAI.PartialEntity?) -> SDAI.LOGICAL { abstruct() }
public func .!==. (lhs: SDAI.PartialEntity?, rhs: SDAI.PartialEntity?) -> SDAI.LOGICAL { abstruct() }

public func .===. (lhs: SDAI.PartialEntity?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL { abstruct() }
public func .!==. (lhs: SDAI.PartialEntity?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL { abstruct() }

public func .===. <U: SDAISelectType>(lhs: SDAI.PartialEntity?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!==. <U: SDAISelectType>(lhs: SDAI.PartialEntity?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

//MARK: - Binary concatenation operator
public func + <T: SDAIBinaryType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.BINARY? { abstruct() }
public func + <T: SDAIBinaryType>(lhs: T?, rhs: String?) -> SDAI.BINARY? { abstruct() }
public func + <U: SDAIBinaryType>(lhs: String?, rhs: U?) -> SDAI.BINARY? { abstruct() }

//MARK: - Logical operators
public prefix func ! <T: SDAILogicalType>(logical: T?) -> SDAI.LOGICAL { abstruct() }

public func && <T: SDAILogicalType, U: SDAILogicalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func || <T: SDAILogicalType, U: SDAILogicalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

//MARK: - String concatenation operator
public func + <T: SDAIStringType, U: SDAIStringType>(lhs: T?, rhs: U?) -> SDAI.STRING? { abstruct() }
public func + <T: SDAIStringType>(lhs: T?, rhs: String?) -> SDAI.STRING? { abstruct() }
public func + <U: SDAIStringType>(lhs: String?, rhs: U?) -> SDAI.STRING? { abstruct() }

//MARK: - Aggregate operators
//MARK: - Intersection operator
public func * <T: SDAI__BAG__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
public func * <T: SDAI__BAG__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType, U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }

public func * <T: SDAI__SET__type, U: SDAI__AIE__type>(lhs: T?, rhs: [U]) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType,U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }
public func * <T: SDAI__AIE__type, U: SDAI__SET__type>(lhs: [T], rhs: U?) -> SDAI.SET<U.ELEMENT>? where T.ELEMENT:SDAIUnderlyingType,U.ELEMENT:SDAIUnderlyingType, T.ELEMENT.FundamentalType == U.ELEMENT.FundamentalType { abstruct() }

public func * <T: SDAI__BAG__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAI.EntityReference { abstruct() }
public func * <T: SDAI__BAG__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAI.EntityReference { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAI.EntityReference { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference, U.ELEMENT:SDAI.EntityReference { abstruct() }

public func * <T: SDAI__SET__type, U: SDAI__AIE__type>(lhs: T?, rhs: [U]) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAI.EntityReference,U.ELEMENT:SDAI.EntityReference { abstruct() }
public func * <T: SDAI__AIE__type, U: SDAI__SET__type>(lhs: [T], rhs: U?) -> SDAI.SET<U.ELEMENT>? where T.ELEMENT:SDAI.EntityReference,U.ELEMENT:SDAI.EntityReference { abstruct() }

public func * <T: SDAI__BAG__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIGenericType { abstruct() }
public func * <T: SDAI__BAG__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIGenericType { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIGenericType { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIGenericType { abstruct() }

public func * <T: SDAI__SET__type, U: SDAI__AIE__type>(lhs: T?, rhs: [U]) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIGenericType { abstruct() }
public func * <T: SDAI__AIE__type, U: SDAI__SET__type>(lhs: [T], rhs: U?) -> SDAI.SET<U.ELEMENT>? where T.ELEMENT:SDAISelectType, U.ELEMENT:SDAIGenericType { abstruct() }

public func * <T: SDAI__BAG__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT:SDAIGenericType, U.ELEMENT:SDAISelectType { abstruct() }
public func * <T: SDAI__BAG__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIGenericType, U.ELEMENT:SDAISelectType { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIGenericType, U.ELEMENT:SDAISelectType { abstruct() }
public func * <T: SDAI__SET__type, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIGenericType, U.ELEMENT:SDAISelectType { abstruct() }

public func * <T: SDAI__SET__type, U: SDAI__AIE__type>(lhs: T?, rhs: [U]) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT:SDAIGenericType, U.ELEMENT:SDAISelectType { abstruct() }
public func * <T: SDAI__AIE__type, U: SDAI__SET__type>(lhs: [T], rhs: U?) -> SDAI.SET<U.ELEMENT>? where T.ELEMENT:SDAIGenericType, U.ELEMENT:SDAISelectType { abstruct() }

public func * <T: SDAI__SET__type, U: SDAI__AIE__type>(lhs: T?, rhs: [U]) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT: SDAIStringType, U.ELEMENT == String { abstruct() }
public func * <T: SDAI__AIE__type, U: SDAI__SET__type>(lhs: [T], rhs: U?) -> SDAI.SET<U.ELEMENT>? where T.ELEMENT == String, U.ELEMENT: SDAIStringType { abstruct() }

//MARK: - Union operator
public func + <T: SDAI__BAG__type, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT == U.ELEMENT { abstruct() }
public func + <T: SDAI__BAG__type, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT == U.ELEMENT { abstruct() }
public func + <T: SDAI__BAG__type, U>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT == U { abstruct() }
public func + <T, U: SDAI__BAG__type>(lhs: T?, rhs: U?) -> SDAI.BAG<T>? where T == U.ELEMENT { abstruct() }

public func + <T: SDAI__SET__type, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT == U.ELEMENT { abstruct() }
public func + <T: SDAI__SET__type, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT == U.ELEMENT { abstruct() }
public func + <T: SDAI__SET__type, U>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT == U { abstruct() }
public func + <T, U: SDAI__SET__type>(lhs: T?, rhs: U?) -> SDAI.SET<T>? where T == U.ELEMENT { abstruct() }

public func + <T: SDAIListType, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>? where T.ELEMENT == U.ELEMENT { abstruct() }
public func + <T: SDAIListType, U>(lhs: T?, rhs: U?) -> SDAI.LIST<T.ELEMENT>? where T.ELEMENT == U { abstruct() }
public func + <T, U: SDAIListType>(lhs: T?, rhs: U?) -> SDAI.LIST<T>? where T == U.ELEMENT { abstruct() }

//MARK: - Difference operator
public func - <T: SDAI__BAG__type, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT == U.ELEMENT { abstruct() }
public func - <T: SDAI__BAG__type, U>(lhs: T?, rhs: U?) -> SDAI.BAG<T.ELEMENT>? where T.ELEMENT == U { abstruct() }

public func - <T: SDAI__SET__type, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT == U.ELEMENT { abstruct() }
public func - <T: SDAI__SET__type, U>(lhs: T?, rhs: U?) -> SDAI.SET<T.ELEMENT>? where T.ELEMENT == U { abstruct() }

//MARK: - Subset operator
public func <=   <T: SDAIBagType, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

//MARK: - Superset operator
public func >=   <T: SDAIBagType, U: SDAIBagType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { return rhs <= lhs }

//MARK: - Complex entity instance construction operator
public func .||. (lhs: SDAI.PartialEntity?, rhs: SDAI.PartialEntity?) -> SDAI.ComplexEntity?  { abstruct() }
public func .||. (lhs: SDAI.PartialEntity?, rhs: SDAI.EntityReference?) -> SDAI.ComplexEntity?  { abstruct() }
public func .||. (lhs: SDAI.PartialEntity?, rhs: SDAI.ComplexEntity?) -> SDAI.ComplexEntity?  { abstruct() }

public func .||. (lhs: SDAI.EntityReference?, rhs: SDAI.PartialEntity?) -> SDAI.ComplexEntity?  { abstruct() }
public func .||. (lhs: SDAI.EntityReference?, rhs: SDAI.EntityReference?) -> SDAI.ComplexEntity?  { abstruct() }
public func .||. (lhs: SDAI.EntityReference?, rhs: SDAI.ComplexEntity?) -> SDAI.ComplexEntity?  { abstruct() }

public func .||. (lhs: SDAI.ComplexEntity?, rhs: SDAI.PartialEntity?) -> SDAI.ComplexEntity?  { abstruct() }
public func .||. (lhs: SDAI.ComplexEntity?, rhs: SDAI.EntityReference?) -> SDAI.ComplexEntity?  { abstruct() }
//public func .||. (lhs: SDAI.ComplexEntity?, rhs: SDAI.ComplexEntity?) -> SDAI.ComplexEntity?  { abstruct() }





extension SDAI {
	
}
