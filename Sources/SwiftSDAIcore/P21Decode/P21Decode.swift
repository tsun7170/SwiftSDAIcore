//
//  P21Decode.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/31.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

/// ISO 10303-21 Clear Text Encoding of the STEP Exchange Structure
///
/// `P21Decode` is a namespace enumeration that provides type definitions and error handling for decoding STEP Part 21 (ISO 10303-21) files.
/// 
/// STEP Part 21 files are used for exchanging product data in computer-aided design (CAD) and related interoperability contexts.
/// This namespace contains:
/// - Typealiases for key names and types used during decoding, such as entity instance names, value instance names, constant names, and schema names.
/// - A `P21Error` struct for representing errors encountered while parsing a p21 stream, including an error message and line number.
///
/// The namespace does not represent a type with instances, but rather organizes these definitions under a common scope related to p21 decoding.
///
public enum P21Decode {
	// basic type definitions
	public typealias EntityInstanceName = Int
	public typealias ValueInstanceName = Int
	public typealias ConstantName = String
	public typealias SchemaName = ExchangeStructure.HeaderSection.FILE_SCHEMA.SCHEMA_NAME
	public typealias SchemaList = KeyValuePairs<SchemaName,SDAI.SchemaType.Type>
	
	/// p21 stream error info
	public struct P21Error: Error, Equatable {
		public let message: String
		public let lineNumber: Int
	}
}


public extension Character {
	
  /// Returns a Boolean value indicating whether the character belongs to the specified character set.
  ///
  /// - Parameter charset: The `CharacterSet` to check membership against.
  /// - Returns: `true` if the character is a member of `charset`; otherwise, `false`.
  /// - Discussion: This method checks whether the character is contained in the provided character set. 
  ///   It can be useful for validating input, parsing, or performing character classification tasks.
  ///
  /// Example usage:
  /// ```swift
  /// let digit = "5"
  /// if digit.is(.decimalDigits) {
  ///     print("\(digit) is a decimal digit.")
  /// }
  /// ```
  /// - defined in P21Decode/P21Decode
  ///
	func `is`(_ charset: CharacterSet) -> Bool {
		let selfset = CharacterSet(charactersIn: String(self))
		let result = !charset.isDisjoint(with: selfset)
		return result
	}
}
