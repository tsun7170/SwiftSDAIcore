//
//  SdaiConstructedType.swift
//  
//
//  Created by Yoshida on 2020/10/18.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - Constructed data types (8.4)

extension SDAI {
  /// A marker protocol representing an EXPRESS constructed data type.
  ///
  /// Constructed types in EXPRESS (ISO 10303-11) are types that are composed of multiple values
  /// or encapsulate collections of values, as opposed to simple atomic values. Examples include
  /// arrays, sets, bags, lists, and entities. This protocol is adopted by all types that map to
  /// such EXPRESS constructed types, providing a common interface for generic handling within
  /// the SDAI (Standard Data Access Interface) framework.
  ///
  /// Types conforming to `ConstructedType` are also required to conform to
  /// `SDAI.SelectCompatibleUnderlyingTypeBase`, enabling compatibility with EXPRESS SELECT types.
  ///
  /// - Note: This protocol does not specify any requirements beyond conformance, and acts purely
  ///         as a semantic marker for type constraints and polymorphism within the SDAI framework.
  ///         
  public protocol ConstructedType: SDAI.SelectCompatibleUnderlyingTypeBase
  {}
}



