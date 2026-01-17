//
//  SdaiLogicalOperation.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - Logical operators (12.4)

//MARK: Logical NOT(!) Operator
/// Logical NOT: !Logical? = LOGICAL
///
public prefix func ! <T1: SDAI.LogicalType>(
  logical: T1?) -> SDAI.LOGICAL
{
	return !SDAI.LOGICAL(logical)
}

/// Logical NOT: !Logical = LOGICAL
///
private prefix func ! <T2: SDAI.LogicalType>(
  logical: T2) -> SDAI.LOGICAL
{
	guard let bool = logical.possiblyAsSwiftBool else { return SDAI.UNKNOWN }
	return bool ? SDAI.FALSE : SDAI.TRUE
}

/// Logical NOT: !Select? = LOGICAL
///
public prefix func ! <T3: SDAI.SelectType>(
  select: T3?) -> SDAI.LOGICAL
{
  return !SDAI.LOGICAL(select)
}



//MARK: Logical AND(&&) Operator
/// Logical AND: Logical? && Logical? = LOGICAL
///
public func && <T1: SDAI.LogicalType, U1: SDAI.LogicalType>(
  lhs: T1?, rhs: U1?) -> SDAI.LOGICAL
{
	return SDAI.LOGICAL(lhs) && SDAI.LOGICAL(rhs)
}

/// Logical AND: Logical && Logical? = LOGICAL
///
//public func && <T2: SDAI.LogicalType, U2: SDAI.LogicalType>(
//  lhs: T2 , rhs: U2?) -> SDAI.LOGICAL
//{
//	return lhs && SDAI.LOGICAL(rhs)
//}

/// Logical AND: Logical? && Logical = LOGICAL
///
//public func && <T3: SDAI.LogicalType, U3: SDAI.LogicalType>(
//  lhs: T3?, rhs: U3 ) -> SDAI.LOGICAL {
//	return SDAI.LOGICAL(lhs) && rhs
//}

/// Logical AND: Logical && Logical? = LOGICAL
///
/// designated _logical and_ operator for the SDAI.LogicalType
/// - TRUE && TRUE -> TRUE
/// - TRUE && UNKNOWN -> UNKNOWN
/// - TRUE && FALSE -> FALSE
/// - UNKNOWN && UNKNOWN -> UNKNOWN
/// - UNKNOWN && FALSE -> FALSE
/// - FALSE && FALSE -> FALSE
///
/// - Parameters:
///   - lhs: logical value
///   - rhs: logical value
/// - Returns: lhs && rhs value
///
private func && <T4: SDAI.LogicalType, U4: SDAI.LogicalType>(
  lhs: T4 , rhs: U4 ) -> SDAI.LOGICAL
{
	let lhs = SDAI.cardinal(logical: lhs)
	let rhs = SDAI.cardinal(logical: rhs)
	return SDAI.LOGICAL(fromCardinal: min(lhs,rhs) )
}

/// Logical AND: Logical? && Select? = LOGICAL
///
public func && <T5: SDAI.LogicalType, U5: SDAI.SelectType>(
  lhs: T5?, rhs: U5?) -> SDAI.LOGICAL
{
  return SDAI.LOGICAL(lhs) && SDAI.LOGICAL(rhs)
}

/// Logical AND: Select? && Logical? = LOGICAL
///
public func && <T6: SDAI.SelectType, U6: SDAI.LogicalType>(
  lhs: T6?, rhs: U6?) -> SDAI.LOGICAL
{
  return SDAI.LOGICAL(lhs) && SDAI.LOGICAL(rhs)
}

/// Logical AND: Select? && Select? = LOGICAL
///
public func && <T7: SDAI.SelectType, U7: SDAI.SelectType>(
  lhs: T7?, rhs: U7?) -> SDAI.LOGICAL
{
  return SDAI.LOGICAL(lhs) && SDAI.LOGICAL(rhs)
}



//MARK: Logical OR(||) Operator
/// Logical OR: Logical? || Logical? = LOGICAL
///
public func || <T1: SDAI.LogicalType, U1: SDAI.LogicalType>(
  lhs: T1?, rhs: U1?) -> SDAI.LOGICAL
{
	return SDAI.LOGICAL(lhs) || SDAI.LOGICAL(rhs)
}

/// Logical OR: Logical || Logical? = LOGICAL
///
//public func || <T2: SDAI.LogicalType, U2: SDAI.LogicalType>(
//  lhs: T2 , rhs: U2?) -> SDAI.LOGICAL
//{
//	return lhs || SDAI.LOGICAL(rhs)
//}

/// Logical OR: Logical? || Logical = LOGICAL
///
//public func || <T3: SDAI.LogicalType, U3: SDAI.LogicalType>(
//  lhs: T3?, rhs: U3 ) -> SDAI.LOGICAL
//{
//	return SDAI.LOGICAL(lhs) || rhs
//}

/// Logical OR: Logical || Logical = LOGICAL
///
/// designated _logical or_ operator for the SDAI.LogicalType
/// - TRUE || TRUE -> TRUE
/// - TRUE || UNKNOWN -> TRUE
/// - TRUE || FALSE -> TRUE
/// - UNKNOWN || UNKNOWN -> UNKNOWN
/// - UNKNOWN || FALSE -> UNKNOWN
/// - FALSE || FALSE -> FALSE
///
/// - Parameters:
///   - lhs: logical value
///   - rhs: logical value
/// - Returns: lhs || rhs value
/// 
private func || <T4: SDAI.LogicalType, U4: SDAI.LogicalType>(
  lhs: T4 , rhs: U4 ) -> SDAI.LOGICAL
{
	let lhs = SDAI.cardinal(logical: lhs)
	let rhs = SDAI.cardinal(logical: rhs)
	return SDAI.LOGICAL(fromCardinal: max(lhs,rhs) )
}

/// Logical OR: Logical? || Select? = LOGICAL
///
public func || <T5: SDAI.LogicalType, U5: SDAI.SelectType>(
  lhs: T5?, rhs: U5?) -> SDAI.LOGICAL
{
  return SDAI.LOGICAL(lhs) || SDAI.LOGICAL(rhs)
}

/// Logical OR: Select? || Logical? = LOGICAL
///
public func || <T6: SDAI.SelectType, U6: SDAI.LogicalType>(
  lhs: T6?, rhs: U6?) -> SDAI.LOGICAL
{
  return SDAI.LOGICAL(lhs) || SDAI.LOGICAL(rhs)
}

/// Logical OR: Select? || Select? = LOGICAL
///
public func || <T7: SDAI.SelectType, U7: SDAI.SelectType>(
  lhs: T7?, rhs: U7?) -> SDAI.LOGICAL
{
  return SDAI.LOGICAL(lhs) || SDAI.LOGICAL(rhs)
}


//MARK: Logical XOR(.!=.) Operator
// see logical not equal operator

