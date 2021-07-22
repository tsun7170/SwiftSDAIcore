//
//  SdaiNumberSubtype.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - NUMBER subtype (8.1.1, 8.3.2)
public protocol SDAI__NUMBER__subtype: SDAI__NUMBER__type, SDAIDefinedType
where Supertype: SDAI__NUMBER__type
{}
public extension SDAI__NUMBER__subtype
{
	// InitializableByGenerictype
	init?<G: SDAIGenericType>(fromGeneric generic: G?) {
		guard let fundamental = FundamentalType.convert(fromGeneric: generic) else { return nil }
		self.init(fundamental: fundamental)
	}
	
	// SDAISimpleType \SDAI__NUMBER__type\SDAI__NUMBER__subtype
	init(from swiftValue: SwiftType) {
		self.init(fundamental: FundamentalType(from: swiftValue))
	}
}



