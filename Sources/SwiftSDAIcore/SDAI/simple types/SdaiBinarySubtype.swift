//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation

//MARK: - BINARY subtype
public protocol SDAI__BINARY__subtype: SDAI__BINARY__type, SDAIDefinedType
where Supertype: SDAI__BINARY__type
//			FundamentalType == SDAI.BINARY
{}
public extension SDAI__BINARY__subtype
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
	
	// SDAISimpleType \SDAI__BINARY__type\SDAI__BINARY__subtype
	init(_ swiftValue: SwiftType) {
		self.init(FundamentalType(swiftValue))
	}
	
	// ExpressibleByStringLiteral \SDAI__BINARY__type\SDAI__BINARY__subtype
	init(stringLiteral value: StringLiteralType) {
		self.init(FundamentalType(stringLiteral: value))
	}

	// SDAI__BINARY__type
	var blength: Int { return rep.blength }
	subscript(index: Int?) -> SDAI.BINARY? { return rep[index] }
	subscript(range: ClosedRange<Int>?) -> SDAI.BINARY? { return rep[range] }
}
