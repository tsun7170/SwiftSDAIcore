//
//  SdaiSelect.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - SELECT TYPE base (8.4.2)

extension SDAI {
  /// A protocol that defines the requirements for SDAI "SELECT" types, which are types that can hold values from a specified set of other types (e.g., defined types, entities, or primitive types).
  ///
  /// `SelectType` serves as the base protocol for all types conforming to the EXPRESS "SELECT" specification. It integrates capabilities for initialization, conversion, and aggregation for select-type values in SDAI-based data models.
  ///
  /// ### Conformance
  /// Types conforming to `SelectType` must also conform to:
  /// - `SDAI.ConstructedType`
  /// - `SDAI.InitializableByDefinedType`
  /// - `SDAI.InitializableByComplexEntity`
  /// - `SDAI.SwiftDoubleConvertible`
  /// - `SDAI.SwiftIntConvertible`
  /// - `SDAI.SwiftStringConvertible`
  /// - `SDAI.SwiftBoolConvertible`
  /// - `SDAI.EntityReferenceYielding`
  /// - `SDAI.AggregationBehavior`
  ///
  /// ### Associated Types
  /// - `Value` is required to be equal to `FundamentalType`.
  /// - `FundamentalType` must itself conform to `SDAI.SelectType`.
  ///
  /// This protocol is typically used to represent the base for all custom SELECT types in an SDAI schema implementation, providing the necessary behaviors for value conversion, initialization, and type safety.
  ///
  /// ### Usage
  /// Implement this protocol for custom types that need to behave as SELECT types within the SDAI framework, ensuring interoperability and correct type conversions when interacting with EXPRESS-based data.
  ///
  /// - SeeAlso: [ISO 10303-11:1994, Section 8.4.2 "SELECT Type"](https://www.steptools.com/stds/smrl/docs/iso-10303-11/sect8.4.2.html)
  public protocol SelectType:
    SDAI.ConstructedType,
    SDAI.InitializableByDefinedType, SDAI.InitializableByComplexEntity,
    SDAI.SwiftDoubleConvertible, SDAI.SwiftIntConvertible, SDAI.SwiftStringConvertible, SDAI.SwiftBoolConvertible,
    SDAI.EntityReferenceYielding,
    SDAI.AggregationBehavior
  where Value == FundamentalType,
        FundamentalType: SDAI.SelectType
  {}
}

public extension SDAI.SelectType
{
	// SDAI.CacheableSource
	var isCacheable: Bool {
		for pref in self.persistentEntityReferences {
			if !pref.isCacheable { return false }
		}
		return true
	}
	
	// SDAI.GenericType
	var value: Value { self.asFundamentalType }
	
	init?<G: SDAI.EntityReference>(_ generic: G?){
		guard let generic = generic else { return nil }
		self.init(possiblyFrom: generic)
	}

	init?<PREF>(_ pref: PREF?)
	where PREF: SDAI.PersistentReference,
	PREF.ARef: SDAI.EntityReference
	{
		self.init(pref?.optionalARef)
	}


	// SDAI.SwiftDoubleConvertible
	var possiblyAsSwiftDouble: Double? { self.realValue?.asSwiftType }
	var asSwiftDouble: Double { SDAI.UNWRAP(self.possiblyAsSwiftDouble) }
	
	// SDAI.SwiftIntConvertible,
	var possiblyAsSwiftInt: Int? { self.integerValue?.asSwiftType }
	var asSwiftInt: Int { SDAI.UNWRAP(self.possiblyAsSwiftInt) }
	
	// SDAI.SwiftStringConvertible, 
	var possiblyAsSwiftString: String? { self.stringValue?.asSwiftType }
	var asSwiftString: String { SDAI.UNWRAP(self.possiblyAsSwiftString) }
	
	// SDAI.SwiftBoolConvertible
	var possiblyAsSwiftBool: Bool? { self.logicalValue?.asSwiftType }
	var asSwiftBool: Bool { SDAI.UNWRAP(self.possiblyAsSwiftBool) }	
	
	// group reference
	func GROUP_REF<SUPER:SDAI.EntityReference & SDAI.DualModeReference>(
		_ entity_ref: SUPER.Type) -> SUPER.PRef?
	{
		guard let complex = self.entityReference?.complexEntity else { return nil }
		return complex.partialComplexEntity(entity_ref)?.pRef
	}
	
}

public extension SDAI.DefinedType where Self: SDAI.SelectType {
	// SDAIGenericTypeBase
	func copy() -> Self {
		var copied = self
		copied.rep = rep.copy()
		return copied
	}
}

