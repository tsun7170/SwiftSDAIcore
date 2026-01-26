//
//  SdaiArrayUnique.swift
//  
//
//  Created by Yoshida on 2021/06/16.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAI.TypeHierarchy {
  /// Protocol describing the type behavior for ARRAY_UNIQUE types within the SDAI type hierarchy.
  /// 
  /// This protocol is used to represent the EXPRESS `ARRAY UNIQUE` aggregation construct at the type-behavior level,
  /// ensuring that conforming types model the semantic contract of an array whose elements are distinct (unique).
  /// 
  /// Types conforming to `ARRAY_UNIQUE__TypeBehavior` inherit the characteristics of the underlying `ARRAY__Subtype`
  /// while adding the uniqueness constraint required by `ARRAY UNIQUE`.
  /// 
  /// - Note: This protocol is part of the internal infrastructure for mapping EXPRESS type hierarchies into Swift,
  ///   and is typically not used directly in application code.
  public protocol ARRAY_UNIQUE__TypeBehavior: SDAI.TypeHierarchy.ARRAY__Subtype {}

  public protocol ARRAY_UNIQUE__Subtype: SDAI.TypeHierarchy.ARRAY_UNIQUE__TypeBehavior {}
}

//MARK: - SDAI.ARRAY_UNIQUE
extension SDAI {
  /// A collection type representing an ARRAY with unique elements, conforming to the EXPRESS "ARRAY UNIQUE" aggregation construct.
  /// 
  /// `ARRAY_UNIQUE` is a generic, value-semantic type that enforces uniqueness of its elements, as required by the EXPRESS `ARRAY UNIQUE` declaration.
  /// It wraps an underlying `SDAI.ARRAY` and adds a uniqueness constraint, ensuring that all elements in the array are distinct.
  /// 
  /// - Type Parameter:
  ///   - ELEMENT: The type of elements contained in the array, which must conform to `SDAI.GenericType`.
  /// 
  /// ## EXPRESS Reference
  /// In the EXPRESS language, `ARRAY UNIQUE` specifies an array in which all values must be unique. This type helps model such constructs in Swift.
  /// 
  /// ## Features
  /// - Provides value semantics and sequence iteration.
  /// - Enforces uniqueness of elements using a runtime check.
  /// - Offers conformance to relevant SDAI protocols for schema population, entity referencing, and dual mode reference (if applicable).
  /// 
  /// Use `SDAI.ARRAY_UNIQUE` when you need to represent an EXPRESS `ARRAY UNIQUE` type in your Swift-based SDAI model implementations.
  public struct ARRAY_UNIQUE<ELEMENT:SDAI.GenericType>: SDAI.TypeHierarchy.ARRAY_UNIQUE__TypeBehavior
	{
		public typealias Supertype = SDAI.ARRAY<ELEMENT>
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
			guard let repval = generic?.arrayValue(elementType: ELEMENT.self) else { return nil }
			rep = repval
		}

		// SDAI.ArrayOptionalType
		public static var uniqueFlag: SDAI.BOOLEAN { true }
		public static var optionalFlag: SDAI.BOOLEAN { false }
		
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

extension SDAI.ARRAY_UNIQUE: SDAI.EntityReferenceYielding
where ELEMENT: SDAI.EntityReferenceYielding
{}

extension SDAI.ARRAY_UNIQUE: SDAI.DualModeReference
where ELEMENT: SDAI.DualModeReference
{}
