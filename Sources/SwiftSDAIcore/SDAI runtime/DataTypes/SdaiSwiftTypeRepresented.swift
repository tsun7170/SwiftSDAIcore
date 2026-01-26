//
//  SdaiSwiftTypeRepresented.swift
//  
//
//  Created by Yoshida on 2021/05/21.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation


extension SDAI {

  /// A marker protocol for types that can be used as Swift representations
  /// for STEP-defined data types in the SDAI framework.
  ///
  /// Types conforming to `SwiftType` are valid underlying types for 
  /// EXPRESS-defined data types, and typically include standard Swift types 
  /// such as `String`, `Int`, `Double`, and `Bool`.
  ///
  /// Use this protocol to indicate that a type is suitable as a direct mapping
  /// for an EXPRESS schema data type in your Swift code.
  ///
  /// Conforming to `SwiftType` does not impose any requirements or functionality 
  /// and is intended purely for type safety and expressiveness in the type system.
  public protocol SwiftType
  {}
}
extension String: SDAI.SwiftType {}
extension Int: SDAI.SwiftType {}
extension Double: SDAI.SwiftType {}
extension Bool: SDAI.SwiftType {}


extension SDAI {
  
  /// A protocol for types that are represented by an underlying Swift type in the SDAI framework.
  ///
  /// Types conforming to `SwiftTypeRepresented` define an association with a concrete Swift type,
  /// typically a standard type such as `String`, `Int`, `Double`, or `Bool`, which serves as the 
  /// underlying representation of an EXPRESS-defined data type.
  ///
  /// This protocol is used to bridge EXPRESS schema data types to their native Swift equivalents,
  /// enabling seamless conversion and type safety when interacting with STEP data within the SDAI framework.
  ///
  /// - Associatedtype: `SwiftType`
  ///   The native Swift type that represents the conforming type.
  /// - Property: `asSwiftType`
  ///   A value exposing the conforming instance as its native Swift representation.
  public protocol SwiftTypeRepresented
  {
    associatedtype SwiftType
    var asSwiftType: SwiftType {get}
  }
}

public extension SDAI.DefinedType 
where Supertype: SDAI.SwiftTypeRepresented, Self: SDAI.SwiftTypeRepresented, SwiftType == Supertype.SwiftType
{
	var asSwiftType: SwiftType { return rep.asSwiftType }
}


