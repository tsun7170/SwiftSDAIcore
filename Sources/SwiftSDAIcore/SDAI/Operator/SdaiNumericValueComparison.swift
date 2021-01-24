//
//  File.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//

import Foundation

//MARK: - Value comparison operators
//MARK: - Numeric comparisons
// integer vs. integer
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

// integer vs. double
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

//double vs. double
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

// double vs. integer
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

// integer vs. select
public func .==. <T: SDAIIntRepresentedNumberType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAIIntRepresentedNumberType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >    <T: SDAIIntRepresentedNumberType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <    <T: SDAIIntRepresentedNumberType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >=   <T: SDAIIntRepresentedNumberType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <=   <T: SDAIIntRepresentedNumberType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .==. <U: SDAISelectType>(lhs: Int?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <U: SDAISelectType>(lhs: Int?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >    <U: SDAISelectType>(lhs: Int?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <    <U: SDAISelectType>(lhs: Int?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >=   <U: SDAISelectType>(lhs: Int?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <=   <U: SDAISelectType>(lhs: Int?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

// double vs. select
public func .==. <T: SDAIDoubleRepresentedNumberType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAIDoubleRepresentedNumberType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >    <T: SDAIDoubleRepresentedNumberType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <    <T: SDAIDoubleRepresentedNumberType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >=   <T: SDAIDoubleRepresentedNumberType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <=   <T: SDAIDoubleRepresentedNumberType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .==. <U: SDAISelectType>(lhs: Double?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <U: SDAISelectType>(lhs: Double?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >    <U: SDAISelectType>(lhs: Double?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <    <U: SDAISelectType>(lhs: Double?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >=   <U: SDAISelectType>(lhs: Double?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <=   <U: SDAISelectType>(lhs: Double?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

// select vs. select
public func .==. <T: SDAISelectType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAISelectType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >    <T: SDAISelectType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <    <T: SDAISelectType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >=   <T: SDAISelectType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <=   <T: SDAISelectType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

// select vs. integer
public func .==. <T: SDAISelectType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAISelectType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >    <T: SDAISelectType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <    <T: SDAISelectType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >=   <T: SDAISelectType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <=   <T: SDAISelectType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .==. <T: SDAISelectType>(lhs: T?, rhs: Int?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAISelectType>(lhs: T?, rhs: Int?) -> SDAI.LOGICAL { abstruct() }
public func >    <T: SDAISelectType>(lhs: T?, rhs: Int?) -> SDAI.LOGICAL { abstruct() }
public func <    <T: SDAISelectType>(lhs: T?, rhs: Int?) -> SDAI.LOGICAL { abstruct() }
public func >=   <T: SDAISelectType>(lhs: T?, rhs: Int?) -> SDAI.LOGICAL { abstruct() }
public func <=   <T: SDAISelectType>(lhs: T?, rhs: Int?) -> SDAI.LOGICAL { abstruct() }

// select vs. double
public func .==. <T: SDAISelectType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAISelectType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >    <T: SDAISelectType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <    <T: SDAISelectType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func >=   <T: SDAISelectType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }
public func <=   <T: SDAISelectType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { abstruct() }

public func .==. <T: SDAISelectType>(lhs: T?, rhs: Double?) -> SDAI.LOGICAL { abstruct() }
public func .!=. <T: SDAISelectType>(lhs: T?, rhs: Double?) -> SDAI.LOGICAL { abstruct() }
public func >    <T: SDAISelectType>(lhs: T?, rhs: Double?) -> SDAI.LOGICAL { abstruct() }
public func <    <T: SDAISelectType>(lhs: T?, rhs: Double?) -> SDAI.LOGICAL { abstruct() }
public func >=   <T: SDAISelectType>(lhs: T?, rhs: Double?) -> SDAI.LOGICAL { abstruct() }
public func <=   <T: SDAISelectType>(lhs: T?, rhs: Double?) -> SDAI.LOGICAL { abstruct() }

