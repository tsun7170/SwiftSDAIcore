//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation

//MARK: - LOGICAL subtype (8.1.4, 8.3.2)
public protocol SDAI__LOGICAL__subtype: SDAI__LOGICAL__type, SDAIDefinedType
where Supertype: SDAI__LOGICAL__type
{}
public extension SDAI__LOGICAL__subtype
{
	// InitializableByGenerictype
	init?<G: SDAIGenericType>(fromGeneric generic: G?) {
		guard let fundamental = FundamentalType(fromGeneric: generic) else { return nil }
		self.init(fundamental: fundamental)
	}
	
	// SDAISimpleType \SDAI__LOGICAL__type\SDAI__LOGICAL__subtype
	init(_ swiftValue: SwiftType) {
		self.init(FundamentalType(swiftValue))
	}
}
