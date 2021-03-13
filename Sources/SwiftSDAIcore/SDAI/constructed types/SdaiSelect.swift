//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation

//MARK: - SELECT TYPE base
public protocol SDAISelectType: SDAIConstructedType, InitializableByDefinedtype, InitializableByEntity,
																SwiftDoubleConvertible, SwiftIntConvertible, SwiftStringConvertible, SwiftBoolConvertible, 
																SDAIObservableAggregateElement, SDAIAggregationBehavior
																
where Value == FundamentalType,
			FundamentalType: SDAISelectType
{}

public extension SDAISelectType
{
	// SDAIGenericType
	var value: Value { self.asFundamentalType }
	
	init?<G: SDAI.EntityReference>(_ generic: G?){
		guard let generic = generic else { return nil }
		self.init(possiblyFrom: generic)
	}
	
	// SwiftDoubleConvertible
	var possiblyAsSwiftDouble: Double? { self.realValue?.asSwiftType }
	var asSwiftDouble: Double { self.possiblyAsSwiftDouble! }
	
	// SwiftIntConvertible,
	var possiblyAsSwiftInt: Int? { self.integerValue?.asSwiftType }
	var asSwiftInt: Int { self.possiblyAsSwiftInt! }
	
	// SwiftStringConvertible, 
	var possiblyAsSwiftString: String? { self.stringValue?.asSwiftType }
	var asSwiftString: String { self.possiblyAsSwiftString! }
	
	// SwiftBoolConvertible
	var possiblyAsSwiftBool: Bool? { self.logicalValue?.asSwiftType }
	var asSwiftBool: Bool { self.possiblyAsSwiftBool! }	
}


