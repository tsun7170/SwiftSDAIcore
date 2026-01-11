//
//  SdaiBinaryConcatenation.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation



//MARK: - Binary indexing operator support (12.3.1)
/// Binary Indexing: IntRep ... IntRep
///
public func ... <T1: SDAIIntRepresentedNumberType, U1: SDAIIntRepresentedNumberType>(
  lhs: T1?, rhs: U1?) -> ClosedRange<Int>?
{
  guard let lhs = lhs, let rhs = rhs else { return nil }
  return lhs.asSwiftInt ... rhs.asSwiftInt
}

/// Binary Indexing: IntRep ... Int
///
public func ... <T2: SDAIIntRepresentedNumberType>(
  lhs: T2?, rhs: Int?) -> ClosedRange<Int>?
{
  guard let lhs = lhs, let rhs = rhs else { return nil }
  return lhs.asSwiftInt ... rhs.asSwiftInt
}

/// Binary Indexing: Int ... IntRep
///
public func ... <U3: SDAIIntRepresentedNumberType>(
  lhs: Int?, rhs: U3?) -> ClosedRange<Int>?
{
  guard let lhs = lhs, let rhs = rhs else { return nil }
  return lhs.asSwiftInt ... rhs.asSwiftInt
}




//MARK: - Binary concatenation operator (12.3.2)

/// Binary Concatenation: Binary + Binary = BINARY
/// 
public func + <T: SDAI__BINARY__type, U: SDAI__BINARY__type>(
  lhs: T?, rhs: U?) -> SDAI.BINARY?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return SDAI.BINARY( from: lhs.asSwiftType + rhs.asSwiftType )
}

