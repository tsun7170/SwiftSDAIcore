//
//  SDAI.swift
//  SwiftSDAIcore
//
//  Created by Yoshida on 2026/01/06.
//

import Foundation

//MARK: - SDAI namespace

/// SDAI(Standard Data Access Interface) runtime foundation
///
public enum SDAI {
  public typealias GENERIC_ENTITY = EntityReference

  public static let TRUE:LOGICAL = true
  public static let FALSE:LOGICAL = false
  public static let UNKNOWN:LOGICAL = nil

  public static let CONST_E:REAL = REAL(exp(1.0))
  public static let PI:REAL = REAL(Double.pi)

  public static let _Infinity:INTEGER? = nil;

}
