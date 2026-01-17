//
//  SdaiArrayOptionalUnique.swift
//  
//
//  Created by Yoshida on 2021/06/16.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAI {
  public protocol ARRAY_OPTIONAL_UNIQUE__TypeBehavior: SDAI.ARRAY_OPTIONAL__Subtype {}

  public protocol ARRAY_OPTIONAL_UNIQUE__Subtype: SDAI.ARRAY_OPTIONAL_UNIQUE__TypeBehavior {}
}

//MARK: - SDAI.ARRAY_OPTIONAL_UNIQUE
extension SDAI {
  /// A concrete implementation of an ARRAY type in SDAI (ISO 10303-11) with optional lower/upper bounds and a uniqueness constraint.
  /// 
  /// `ARRAY_OPTIONAL_UNIQUE` is a value type that models an array whose indices may be optional (i.e., lower and/or upper bounds can be omitted), and elements must be unique. It is parameterized by an element type that conforms to `SDAI.GenericType`.
  ///
  /// - Parameters:
  ///   - ELEMENT: The type of the array's elements, constrained to conform to `SDAI.GenericType`.
  ///
  /// ## Features
  /// - Enforces that all elements are unique (no duplicates).
  /// - Allows for optional lower and upper index bounds, following EXPRESS array semantics.
  /// - Provides type aliases and conveniences for handling the fundamental storage, element, and Swift bridging types.
  /// - Validates uniqueness and other where-rules at runtime.
  ///
  /// ## Usage
  /// Use `ARRAY_OPTIONAL_UNIQUE` when you need to model EXPRESS arrays that are permitted to have optional index bounds and require all elements to be unique.
  ///
  /// ## EXPRESS Specification Reference
  /// - `ARRAY [lo:?..hi:?] OF <element_type> UNIQUE`
	public struct ARRAY_OPTIONAL_UNIQUE<ELEMENT:SDAI.GenericType>: SDAI.ARRAY_OPTIONAL_UNIQUE__TypeBehavior
	{
		
		public typealias Supertype = SDAI.ARRAY_OPTIONAL<ELEMENT>
		public typealias FundamentalType = Supertype.FundamentalType
		public typealias Value = Supertype.Value
		public typealias SwiftType = Supertype.SwiftType
		public typealias ELEMENT = Supertype.ELEMENT
		public func makeIterator() -> FundamentalType.Iterator { return self.asFundamentalType.makeIterator() }
		public static var typeName: String { return "ARRAY" }
		public static var bareTypeName: String { self.typeName }
		public var typeMembers: Set<SDAI.STRING> { rep.typeMembers }
		public var rep: Supertype
		
		public init(fundamental: FundamentalType) {
			rep = Supertype(fundamental: fundamental)
		}
		
		public init?<G: SDAI.GenericType>(fromGeneric generic: G?) {
			guard let repval = generic?.arrayOptionalValue(elementType: ELEMENT.self) else { return nil }
			rep = repval
		}

		// SDAI.ArrayOptionalType
		public static var uniqueFlag: SDAI.BOOLEAN { true }
		public static var optionalFlag: SDAI.BOOLEAN { true }
		
		// uniqueness constraint
		public static func UNIQUENESS(SELF: Self?) -> SDAI.LOGICAL {
			guard let SELF = SELF else { return SDAI.UNKNOWN }

			let unique = Set(SELF)
			return SDAI.LOGICAL( unique.count == SELF.size )
		}
		
		public static func validateWhereRules(instance: Self?, prefix: SDAIPopulationSchema.WhereLabel) -> SDAIPopulationSchema.WhereRuleValidationRecords {
			let prefix2 = prefix + "\\\(typeName)"
			var result = Supertype.validateWhereRules(instance:instance?.rep, prefix:prefix2)
			
			result[prefix2 + ".UNIQUENESS"] = UNIQUENESS(SELF: instance)
			return result
		}
	}
	
}

extension SDAI.ARRAY_OPTIONAL_UNIQUE: SDAI.EntityReferenceYielding
where ELEMENT: SDAI.EntityReferenceYielding
{}

extension SDAI.ARRAY_OPTIONAL_UNIQUE: SDAI.DualModeReference
where ELEMENT: SDAI.DualModeReference
{}

