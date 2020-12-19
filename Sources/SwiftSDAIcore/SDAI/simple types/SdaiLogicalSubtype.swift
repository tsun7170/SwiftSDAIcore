//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation

//MARK: - LOGICAL subtype
public protocol SDAI__LOGICAL__subtype: SDAI__LOGICAL__type, SDAIDefinedType
where Supertype: SDAI__LOGICAL__type,
			Supertype.FundamentalType == SDAI.LOGICAL
{}
public extension SDAI__LOGICAL__subtype
{
	// SDAIGenericType
	init?<S: SDAISelectType>(possiblyFrom select: S?) {
		guard let fundamental = FundamentalType(possiblyFrom: select) else { return nil }
		self.init(fundamental: fundamental)
	}
	
	// SDAISimpleType \SDAI__LOGICAL__type\SDAI__LOGICAL__subtype
	init(_ swiftValue: SwiftType) {
		self.init(FundamentalType(swiftValue))
	}
}
