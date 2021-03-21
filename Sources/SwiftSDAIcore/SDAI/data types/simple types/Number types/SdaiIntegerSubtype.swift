//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation

//MARK: - INTEGER subtype
public protocol SDAI__INTEGER__subtype: SDAI__INTEGER__type, SDAIDefinedType
where Supertype: SDAI__INTEGER__type
//			Supertype.FundamentalType == SDAI.INTEGER
{}
public extension SDAI__INTEGER__subtype
{
//	// SDAIGenericType
//	init?<S: SDAISelectType>(possiblyFrom select: S?) {
//		guard let fundamental = FundamentalType(possiblyFrom: select) else { return nil }
//		self.init(fundamental: fundamental)
//	}
	// InitializableByGenerictype
	init?<G: SDAIGenericType>(fromGeneric generic: G?) {
		guard let fundamental = FundamentalType(fromGeneric: generic) else { return nil }
		self.init(fundamental: fundamental)
	}
	
	// SDAISimpleType \SDAI__NUMBER__type\SDAI__REAL__type\SDAI__INTEGER__type
	init(_ swiftValue: SwiftType) {
		self.init(FundamentalType(swiftValue))
	}
}	
	
