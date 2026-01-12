//
//  SdaiArrayUnique.swift
//  
//
//  Created by Yoshida on 2021/06/16.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAI {
  public protocol ARRAY_UNIQUE__TypeBehavior: SDAI.ARRAY__Subtype {}

  public protocol ARRAY_UNIQUE__Subtype: SDAI.ARRAY_UNIQUE__TypeBehavior {}
}

//MARK: - SDAI.ARRAY_UNIQUE
extension SDAI {
	public struct ARRAY_UNIQUE<ELEMENT:SDAI.GenericType>: SDAI.ARRAY_UNIQUE__TypeBehavior
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
