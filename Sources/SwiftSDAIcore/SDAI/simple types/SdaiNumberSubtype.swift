//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation

//MARK: - NUMBER subtype
public protocol SDAI__NUMBER__subtype: SDAI__NUMBER__type, SDAIDefinedType
where Supertype: SDAI__NUMBER__type
//			Supertype.FundamentalType == SDAI.NUMBER
{}
public extension SDAI__NUMBER__subtype
{
	// SDAIGenericType
	init?<S: SDAISelectType>(possiblyFrom select: S?) {
		guard let fundamental = FundamentalType(possiblyFrom: select) else { return nil }
		self.init(fundamental: fundamental)
	}
	
	// SDAISimpleType \SDAI__NUMBER__type\SDAI__NUMBER__subtype
	init(_ swiftValue: SwiftType) {
		self.init(FundamentalType(swiftValue))
	}
}



