//
//  File.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//

import Foundation

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

