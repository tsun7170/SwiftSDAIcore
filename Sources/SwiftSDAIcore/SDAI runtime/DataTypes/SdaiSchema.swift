//
//  SdaiSchema.swift
//  
//
//  Created by Yoshida on 2021/05/21.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation


//MARK: - schema
extension SDAI {
  
  /// A protocol representing a type that defines an EXPRESS schema within the SDAI framework.
  /// 
  /// Conforming types must provide a static schema definition that describes the EXPRESS schema structure,
  /// enabling type-safe mapping and manipulation of schema elements in Swift.
  ///
  /// Schema types are required to be `Sendable`, ensuring safe use with Swift Concurrency.
  ///
  /// - Note: The static property `schemaDefinition` must return a `SDAIDictionarySchema.SchemaDefinition`,
  ///   which encapsulates the details of the schema.
  ///
  /// Example usage:
  /// ```swift
  /// struct MySchema: SDAI.SchemaType {
  ///     static let schemaDefinition = SDAIDictionarySchema.SchemaDefinition(/* ... */)
  /// }
  /// ```
  public protocol SchemaType: Sendable {
    static var schemaDefinition: SDAIDictionarySchema.SchemaDefinition {get}
  }
}
