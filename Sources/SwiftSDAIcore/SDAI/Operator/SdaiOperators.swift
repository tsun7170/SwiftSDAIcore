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

//MARK: - index range support (12.3.1)
public func ... <T: SDAIIntRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> ClosedRange<Int>? { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.asSwiftInt ... rhs.asSwiftInt
}
public func ... <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Int?) -> ClosedRange<Int>? { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.asSwiftInt ... rhs.asSwiftInt
}
public func ... <U: SDAIIntRepresentedNumberType>(lhs: Int?, rhs: U?) -> ClosedRange<Int>? { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return lhs.asSwiftInt ... rhs.asSwiftInt
}




