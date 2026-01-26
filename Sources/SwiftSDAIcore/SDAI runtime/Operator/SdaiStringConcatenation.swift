//
//  SdaiStringConcatenation.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - String indexing operator support (12.5.1)
// see Binary indexing operator support


//MARK: - String concatenation operator (12.5.2)

/// String Concatenation: String + String = STRING
///
public func + <T1: SDAI.TypeHierarchy.STRING__TypeBehavior, U1: SDAI.TypeHierarchy.STRING__TypeBehavior>(
  lhs: T1?, rhs: U1?) -> SDAI.STRING?
{
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return SDAI.STRING( lhs.asSwiftType + rhs.asSwiftType )
}

/// String Concatenation: String + Select = STRING
///
public func + <T2: SDAI.TypeHierarchy.STRING__TypeBehavior, U2: SDAI.SelectType>(
  lhs: T2?, rhs: U2?) -> SDAI.STRING?
{ lhs + rhs?.stringValue }

/// String Concatenation: Select + String = STRING
///
public func + <T3: SDAI.SelectType, U3: SDAI.TypeHierarchy.STRING__TypeBehavior>(
  lhs: T3?, rhs: U3?) -> SDAI.STRING?
{ lhs?.stringValue + rhs }

/// String Concatenation: String + StringLiteral = STRING
///
public func + <T4: SDAI.TypeHierarchy.STRING__TypeBehavior>(
  lhs: T4?, rhs: String?) -> SDAI.STRING?
{ lhs + SDAI.STRING(rhs) }

/// String Concatenation: StringLiteral + String = STRING
///
public func + <U5: SDAI.TypeHierarchy.STRING__TypeBehavior>(
  lhs: String?, rhs: U5?) -> SDAI.STRING?
{ SDAI.STRING(lhs) + rhs }
