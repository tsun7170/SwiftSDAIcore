//
//  SdaiNamedType.swift
//  
//
//  Created by Yoshida on 2021/05/21.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAI {
  
  /// A protocol representing a named type within the SDAI (STEP Data Access Interface) framework.
  /// 
  /// Named types are types that have a distinct name within a schema, such as an alias, enumeration, or select type,
  /// as defined by the EXPRESS data modeling language used in STEP (ISO 10303) standards.
  /// 
  /// Conforming types are expected to provide additional semantic meaning on top of basic types,
  /// facilitating schema-level type distinctions and constraints.
  ///
  /// `NamedType` inherits from `SDAI.BaseType`, ensuring interoperability within the SDAI type system.
  public protocol NamedType: SDAI.BaseType
  {}
}

