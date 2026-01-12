//
//  SdaiListUnique.swift
//  
//
//  Created by Yoshida on 2021/06/13.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAI {
  public protocol LIST_UNIQUE__TypeBehavior: SDAI.LIST__Subtype {}

  public protocol LIST_UNIQUE__Subtype: SDAI.LIST_UNIQUE__TypeBehavior {}
}

extension SDAI {
	public struct LIST_UNIQUE<ELEMENT:SDAI.GenericType>: SDAI.LIST_UNIQUE__TypeBehavior
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
				
		// SDAI__LIST__type
		public static var uniqueFlag: BOOLEAN {true}

		public init(fundamental: FundamentalType) {
			rep = Supertype(fundamental: fundamental)
		}
		
		public init?<G: SDAI.GenericType>(fromGeneric generic: G?) {
			guard let repval = generic?.listValue(elementType: ELEMENT.self) else { return nil }
			rep = repval
		}
		
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


extension SDAI.LIST_UNIQUE: SDAI.EntityReferenceYielding
where ELEMENT: SDAI.EntityReferenceYielding
{}

extension SDAI.LIST_UNIQUE: SDAI.DualModeReference
where ELEMENT: SDAI.DualModeReference
{}
