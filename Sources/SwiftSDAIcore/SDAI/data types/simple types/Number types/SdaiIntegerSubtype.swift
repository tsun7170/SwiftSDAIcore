//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation

//MARK: - INTEGER subtype (8.1.3, 8.3.2)
public protocol SDAI__INTEGER__subtype: SDAI__INTEGER__type, SDAIDefinedType
where Supertype: SDAI__INTEGER__type
{}
public extension SDAI__INTEGER__subtype
{
	// InitializableByGenerictype
	init?<G: SDAIGenericType>(fromGeneric generic: G?) {
		guard let fundamental = FundamentalType(fromGeneric: generic) else { return nil }
		self.init(fundamental: fundamental)
	}
	
	// SDAISimpleType \SDAI__NUMBER__type\SDAI__REAL__type\SDAI__INTEGER__type
	init(from swiftValue: SwiftType) {
		self.init(fundamental: FundamentalType(from: swiftValue))
	}
}	
	
