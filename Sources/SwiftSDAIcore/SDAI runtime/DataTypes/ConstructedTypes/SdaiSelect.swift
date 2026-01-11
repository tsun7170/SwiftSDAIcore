//
//  SdaiSelect.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - SELECT TYPE base (8.4.2)

public protocol SDAISelectType:
	SDAIConstructedType,
  SDAI.InitializableByDefinedType, SDAI.InitializableByComplexEntity,
	SwiftDoubleConvertible, SwiftIntConvertible, SwiftStringConvertible, SwiftBoolConvertible,
	SDAIEntityReferenceYielding,
	SDAIAggregationBehavior
where Value == FundamentalType,
			FundamentalType: SDAISelectType
{}

public extension SDAISelectType
{
	// SdaiCacheableSource
	var isCacheable: Bool {
		for pref in self.persistentEntityReferences {
			if !pref.isCacheable { return false }
		}
		return true
	}
	
	// SDAIGenericType
	var value: Value { self.asFundamentalType }
	
	init?<G: SDAI.EntityReference>(_ generic: G?){
		guard let generic = generic else { return nil }
		self.init(possiblyFrom: generic)
	}

	init?<PREF>(_ pref: PREF?)
	where PREF: SDAIPersistentReference,
	PREF.ARef: SDAI.EntityReference
	{
		self.init(pref?.optionalARef)
	}


	// SwiftDoubleConvertible
	var possiblyAsSwiftDouble: Double? { self.realValue?.asSwiftType }
	var asSwiftDouble: Double { SDAI.UNWRAP(self.possiblyAsSwiftDouble) }
	
	// SwiftIntConvertible,
	var possiblyAsSwiftInt: Int? { self.integerValue?.asSwiftType }
	var asSwiftInt: Int { SDAI.UNWRAP(self.possiblyAsSwiftInt) }
	
	// SwiftStringConvertible, 
	var possiblyAsSwiftString: String? { self.stringValue?.asSwiftType }
	var asSwiftString: String { SDAI.UNWRAP(self.possiblyAsSwiftString) }
	
	// SwiftBoolConvertible
	var possiblyAsSwiftBool: Bool? { self.logicalValue?.asSwiftType }
	var asSwiftBool: Bool { SDAI.UNWRAP(self.possiblyAsSwiftBool) }	
	
	// group reference
	func GROUP_REF<SUPER:SDAI.EntityReference & SDAIDualModeReference>(
		_ entity_ref: SUPER.Type) -> SUPER.PRef?
	{
		guard let complex = self.entityReference?.complexEntity else { return nil }
		return complex.partialComplexEntity(entity_ref)?.pRef
	}
	
}

public extension SDAIDefinedType where Self: SDAISelectType {
	// SDAIGenericTypeBase
	func copy() -> Self {
		var copied = self
		copied.rep = rep.copy()
		return copied
	}
}

