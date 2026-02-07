//
//  SdaiListUnique.swift
//  
//
//  Created by Yoshida on 2021/06/13.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAI.TypeHierarchy {
  /// Protocol describing the type behavior for the EXPRESS `LIST OF ... UNIQUE` aggregate type.
  ///
  /// Types conforming to `LIST_UNIQUE__TypeBehavior` represent ordered collections of uniquely-valued elements,
  /// corresponding to the EXPRESS `LIST OF ... UNIQUE` construct. This protocol is used within the SDAI type hierarchy
  /// to distinguish list types that enforce element uniqueness, providing a common interface for such collections.
  ///
  /// - Note: Conformance to this protocol signifies that the conforming type ensures no duplicate elements exist in its collection.
  ///
  /// ## EXPRESS Specification Mapping:
  /// - EXPRESS: `LIST [lower:Upper] OF <ELEMENT> UNIQUE`
  /// - Swift: Types conforming to `SDAI.TypeHierarchy.LIST_UNIQUE__TypeBehavior`
  ///
  /// ## See Also:
  /// - `SDAI.LIST_UNIQUE`
  /// - `SDAI.TypeHierarchy.LIST_UNIQUE__Subtype`
  /// - `SDAI.TypeHierarchy.LIST__Subtype`
  ///
  public protocol LIST_UNIQUE__TypeBehavior: SDAI.TypeHierarchy.LIST__Subtype {}

  public protocol LIST_UNIQUE__Subtype: SDAI.TypeHierarchy.LIST_UNIQUE__TypeBehavior {}
}

extension SDAI {
  /// A value type representing a unique-valued ordered collection of elements conforming to `SDAI.GenericType`, 
  /// corresponding to the EXPRESS `LIST OF ... UNIQUE` aggregate.
  /// 
  /// `LIST_UNIQUE` enforces uniqueness of its elements, while preserving their order. 
  /// This aggregate type is commonly used for EXPRESS lists with the `UNIQUE` constraint, 
  /// ensuring no duplicate values exist within the collection.
  /// 
  /// - Note: This is a wrapper around `SDAI.LIST` that asserts uniqueness, and provides EXPRESS-style 
  ///   type name reporting, uniqueness validation, and conformance to related protocols.
  /// 
  /// ## Type Parameters:
  /// - `ELEMENT`: The element type, which must conform to `SDAI.GenericType`.
  /// 
  /// ## EXPRESS Specification Mapping:
  /// - EXPRESS: `LIST [lower:Upper] OF <ELEMENT> UNIQUE`
  /// - Swift: `SDAI.LIST_UNIQUE<ELEMENT>`
  /// 
  /// ## Example:
  /// ```swift
  /// let items = SDAI.LIST_UNIQUE<SDAI.STRING>(fundamental: ["A", "B", "C"])
  /// ```
  /// 
  /// ## Protocol Conformance:
  /// - `SDAI.TypeHierarchy.LIST_UNIQUE__TypeBehavior`
  /// - `SDAI.TypeHierarchy.LIST_UNIQUE__Subtype`
  /// - `SDAI.EntityReferenceYielding` (when `ELEMENT` does)
  /// - `SDAI.DualModeReference` (when `ELEMENT` does)
  /// 
  /// ## See Also:
  /// - `SDAI.LIST`
  /// - `SDAI.SET`
  ///
  /// ## Uniqueness Constraint:
  /// - The static method `UNIQUENESS(SELF:)` checks for element uniqueness, 
  ///   returning an EXPRESS `LOGICAL` value.
  ///
	public struct LIST_UNIQUE<ELEMENT:SDAI.GenericType>: SDAI.TypeHierarchy.LIST_UNIQUE__TypeBehavior
	{
		
		public typealias Supertype = SDAI.LIST<ELEMENT>
		public typealias FundamentalType = Supertype.FundamentalType
		public typealias Value = Supertype.Value
		public typealias SwiftType = Supertype.SwiftType
		public typealias ELEMENT = Supertype.ELEMENT
		public func makeIterator() -> FundamentalType.Iterator { return self.asFundamentalType.makeIterator() }
		public static var typeName: String { return "LIST" }
		public static var bareTypeName: String { self.typeName }
		public var typeMembers: Set<SDAI.STRING> { rep.typeMembers }
		public var rep: Supertype
				
		//MARK: SDAI__LIST__type
		public static var uniqueFlag: BOOLEAN {true}

		public init(fundamental: FundamentalType) {
			rep = Supertype(fundamental: fundamental)
		}
		
		public init?<G: SDAI.GenericType>(fromGeneric generic: G?) {
			guard let repval = generic?.listValue(elementType: ELEMENT.self) else { return nil }
			rep = repval
		}
		
		//MARK: uniqueness constraint
		public static func UNIQUENESS(SELF: Self?) -> SDAI.LOGICAL {
			guard let SELF = SELF else { return SDAI.TRUE }

			let unique = Set(SELF)
			return SDAI.LOGICAL( unique.count == SELF.size )
		}
		
		public static func validateWhereRules(
      instance: Self?,
      prefix: SDAIPopulationSchema.WhereLabel
    ) -> SDAIPopulationSchema.WhereRuleValidationRecords
    {
			let prefix2 = prefix + "\\\(typeName)"
			var result = Supertype.validateWhereRules(instance:instance?.rep, prefix:prefix2)
			
			result[prefix2 + ".UNIQUENESS"] = UNIQUENESS(SELF: instance)
			return result
		}

	}//struct
}


extension SDAI.LIST_UNIQUE: SDAI.EntityReferenceYielding
where ELEMENT: SDAI.EntityReferenceYielding
{}

extension SDAI.LIST_UNIQUE: SDAI.DualModeReference
where ELEMENT: SDAI.DualModeReference
{}
