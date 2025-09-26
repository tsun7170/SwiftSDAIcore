//
//  SdaiSelect.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - SELECT TYPE base (8.4.2)

public protocol SDAISelectType: SDAIConstructedType,
																	InitializableByDefinedType, InitializableByEntity,
																SwiftDoubleConvertible, SwiftIntConvertible, SwiftStringConvertible, SwiftBoolConvertible,
																SDAIEntityReferenceYielding,
//																SDAIObservableAggregateElement,
																SDAIAggregationBehavior

where Value == FundamentalType,
			FundamentalType: SDAISelectType
{}

public extension SDAISelectType
{
	// SdaiCacheableSource
	var isCacheable: Bool {
		for elem in self.entityReferences {
			if !elem.isCacheable { return false }
		}
		return true
	}
	
	// SDAIGenericType
	var value: Value { self.asFundamentalType }
	
	init?<G: SDAI.EntityReference>(_ generic: G?){
		guard let generic = generic else { return nil }
		self.init(possiblyFrom: generic)
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
	func GROUP_REF<EREF:SDAI.EntityReference>(_ entity_ref: EREF.Type) -> EREF? {
		guard let complex = self.entityReference?.complexEntity else { return nil }
		return complex.partialComplexEntity(entity_ref)
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

