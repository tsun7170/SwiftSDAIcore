//
//  SdaiLogicalSubtype.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
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
		guard let fundamental = FundamentalType.convert(fromGeneric: generic) else { return nil }
		self.init(fundamental: fundamental)
	}
	
	// SDAISimpleType \SDAI__LOGICAL__type\SDAI__LOGICAL__subtype
	init(from swiftValue: SwiftType) {
		self.init(fundamental: FundamentalType(from: swiftValue))
	}
}
