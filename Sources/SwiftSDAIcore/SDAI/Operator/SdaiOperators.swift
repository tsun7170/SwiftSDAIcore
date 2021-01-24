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




