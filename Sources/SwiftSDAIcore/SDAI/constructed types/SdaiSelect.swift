//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation

//MARK: - SELECT TYPE base
public protocol SDAISelectType: SDAIConstructedType, InitializableByDefinedtype, InitializableByEntity, SDAIObservableAggregateElement, SwiftDoubleConvertible, SwiftIntConvertible, SwiftStringConvertible, SwiftBoolConvertible, SDAIAggregationBehavior
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
	
	// SwiftIntConvertible,
	var possiblyAsSwiftInt: Int? { self.integerValue?.asSwiftType }
	
	// SwiftStringConvertible, 
	var possiblyAsSwiftString: String? { self.stringValue?.asSwiftType }
	
	// SwiftBoolConvertible
	var possiblyAsSwiftBool: Bool? { self.logicalValue?.asSwiftType }
	
}


