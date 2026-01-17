//
//  SDAI.swift
//  SwiftSDAIcore
//
//  Created by Yoshida on 2026/01/06.
//

import Foundation

//MARK: - SDAI namespace

/// A namespace for the ISO 10303-11 EXPRESS Language Runtime Foundation.
/// 
/// This enumeration provides global definitions, type aliases, and constants used throughout the EXPRESS runtime,
/// which is the foundational standard for representing product data.
/// 
/// The `SDAI` namespace offers the following:
///  - Type aliases for generic EXPRESS types.
///  - Standard EXPRESS constants such as logical `TRUE`, `FALSE`, and `UNKNOWN`.
///  - Frequently used mathematical constants like Euler's number (`CONST_E`) and pi (`PI`).
///  - Internal representations for EXPRESS language constructs.
/// 
/// All EXPRESS runtime-related symbols and constants should be accessed via this namespace.
public enum SDAI {
  public typealias GENERIC_ENTITY = EntityReference

  public static let TRUE:LOGICAL = true
  public static let FALSE:LOGICAL = false
  public static let UNKNOWN:LOGICAL = nil

  public static let CONST_E:REAL = REAL(exp(1.0))
  public static let PI:REAL = REAL(Double.pi)

  public static let _Infinity:INTEGER? = nil;

}
