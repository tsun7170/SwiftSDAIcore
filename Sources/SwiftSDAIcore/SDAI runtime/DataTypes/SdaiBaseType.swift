//
//  SdaiBaseType.swift
//  
//
//  Created by Yoshida on 2021/08/08.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAI {
  /// A marker protocol representing a base type in the SDAI (Standard Data Access Interface) model.
  /// 
  /// `BaseType` is intended as a root protocol for all types that form the fundamental building
  /// blocks of the SDAI type system. Types that conform to `BaseType` are recognized as valid 
  /// base types within the SDAI framework.
  ///
  /// - Note: This protocol does not require any particular methods or properties; it serves
  ///         as a type constraint and marker for SDAI-compliant types.
  public protocol BaseType
  {}
}
