//
//  SdaiSimpleType.swift
//  
//
//  Created by Yoshida on 2020/09/22.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - Simple data types (8.1)

extension SDAI {
  
  /// A protocol that represents the basic set of simple data types within the SDAI framework (ISO 10303-11, section 8.1).
  ///
  /// `SimpleType` is a marker protocol for types that are considered simple, such as primitive or atomic types
  /// like integers, floats, booleans, or enumerations, as defined in the EXPRESS language specification.
  ///
  /// Conforming types must also conform to:
  /// - ``SDAI.UnderlyingType``: The protocol for types that have a direct mapping to a Swift primitive.
  /// - ``SDAI.BaseType``: The protocol for all EXPRESS base types.
  /// - ``SDAI.Initializable.BySwiftType``: Types that can be initialized from a corresponding Swift type.
  /// - ``SDAI.SwiftTypeRepresented``: Types that can represent themselves as a Swift value.
  ///
  /// Use this protocol to generically refer to any simple EXPRESS types that are used in the SDAI data model.
  ///
  public protocol SimpleType: SDAI.UnderlyingType, SDAI.BaseType, SDAI.Initializable.BySwiftType, SDAI.SwiftTypeRepresented
  {}
}

public extension SDAI.SimpleType
{
	func copy() -> Self { return self }
	var isCacheable: Bool { return true }
}
