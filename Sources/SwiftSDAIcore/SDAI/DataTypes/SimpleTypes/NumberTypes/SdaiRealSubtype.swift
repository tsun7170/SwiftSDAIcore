//
//  SdaiRealSubtype.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation


//MARK: - REAL subtype (8.1.2, 8.3.2)
public protocol SDAI__REAL__subtype: SDAI__REAL__type, SDAIDefinedType
where Supertype: SDAI__REAL__type
{}
public extension SDAI__REAL__subtype
{
	// InitializableByGenerictype
	init?<G: SDAIGenericType>(fromGeneric generic: G?) {
		guard let fundamental = FundamentalType.convert(fromGeneric: generic) else { return nil }
		self.init(fundamental: fundamental)
	}
	
	// SDAISimpleType \SDAI__NUMBER__type\SDAI__REAL__type\SDAI__REAL__subtype
	init(from swiftValue: SwiftType) {
		self.init(fundamental: FundamentalType(from: swiftValue))
	}
	
	// SDAI__REAL__type
	static var precision: SDAIDictionarySchema.Bound { Supertype.precision }
}

