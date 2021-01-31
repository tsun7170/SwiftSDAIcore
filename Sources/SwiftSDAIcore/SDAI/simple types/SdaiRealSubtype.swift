//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation


//MARK: - REAL subtype
public protocol SDAI__REAL__subtype: SDAI__REAL__type, SDAIDefinedType
where Supertype: SDAI__REAL__type
//			Supertype.FundamentalType == SDAI.REAL
{}
public extension SDAI__REAL__subtype
{
//	// SDAIGenericType
//	init?<S: SDAISelectType>(possiblyFrom select: S?) {
//		guard let fundamental = FundamentalType(possiblyFrom: select) else { return nil }
//		self.init(fundamental: fundamental)
//	}
	// InitializableByGenerictype
	init?<G: SDAIGenericType>(fromGeneric generic: G?) {
		guard let fundamental = Fundamental(fromGeneric: generic) else { return nil }
		self.init(fundamental: fundamental)
	}
	
	// SDAISimpleType \SDAI__NUMBER__type\SDAI__REAL__type\SDAI__REAL__subtype
	init(_ swiftValue: SwiftType) {
		self.init(FundamentalType(swiftValue))
	}
}

