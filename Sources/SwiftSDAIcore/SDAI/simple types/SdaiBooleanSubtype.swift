//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation

//MARK: - BOOLEAN subtype
public protocol SDAI__BOOLEAN__subtype: SDAI__BOOLEAN__type, SDAIDefinedType
where Supertype: SDAI__BOOLEAN__type,
			Supertype.FundamentalType == SDAI.BOOLEAN
{}
public extension SDAI__BOOLEAN__subtype
{
	// SDAIGenericType
	init?<S: SDAISelectType>(possiblyFrom select: S?) {
		guard let fundamental = FundamentalType(possiblyFrom: select) else { return nil }
		self.init(fundamental: fundamental)
	}
	
	// SDAISimpleType \SDAI__LOGICAL__type\SDAI__BOOLEAN__type\SDAI__BOOLEAN__subtype
	init(_ swiftValue: SwiftType) {
		self.init(FundamentalType(swiftValue))
	}
}
