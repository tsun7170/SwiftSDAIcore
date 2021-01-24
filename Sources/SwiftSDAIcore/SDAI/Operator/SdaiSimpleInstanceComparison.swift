//
//  File.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//

import Foundation

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

