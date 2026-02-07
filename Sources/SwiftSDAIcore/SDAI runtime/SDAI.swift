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

  
  /// A nested namespace within `SDAI` intended for organizing type hierarchy-related utilities and definitions.
  /// 
  /// The `TypeHierarchy` namespace is reserved for tools, protocols, or type aliases that describe or assist with
  /// the EXPRESS type system's inheritance, conformance, and relationships. This can include generic operations,
  /// type introspection, or mechanisms for handling EXPRESS's complex type hierarchies.
  ///
  /// - Note: This namespace is currently a placeholder and is expected to be expanded with future runtime features
  ///   that require awareness of EXPRESS type relationships.
  public enum TypeHierarchy {}

  /// A namespace placeholder for protocols, type aliases, or utilities associated with types that can be initialized
  /// according to EXPRESS language rules within the SDAI runtime.
  ///
  /// The `Initializable` namespace is intended for future expansion with definitions that manage or describe how types
  /// conform to EXPRESS's concept of initializability. This includes mechanisms or requirements for default construction,
  /// value assignment, or other initialization semantics dictated by the EXPRESS language standard.
  ///
  /// - Note: This namespace currently serves as a reserved symbol for future features and may be populated with
  ///   protocols, helper types, or functions as the runtime evolves to support more detailed initialization behavior.
  public enum Initializable {}
}

extension SDAI.BOOLEAN {
  public static let TRUE:SDAI.BOOLEAN = true
  public static let FALSE:SDAI.BOOLEAN = false
}
