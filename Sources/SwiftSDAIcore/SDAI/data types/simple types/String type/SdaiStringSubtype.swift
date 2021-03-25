//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation

//MARK: - STRING subtype (8.1.6, 8.3.2)
public protocol SDAI__STRING__subtype: SDAI__STRING__type, SDAIDefinedType
where Supertype: SDAI__STRING__type
{}
public extension SDAI__STRING__subtype
{
	// InitializableByGenerictype
	init?<G: SDAIGenericType>(fromGeneric generic: G?) {
		guard let fundamental = FundamentalType(fromGeneric: generic) else { return nil }
		self.init(fundamental: fundamental)
	}
	
	// SDAISimpleType \SDAI__STRING__type\SDAI__STRING__subtype
	init(_ swiftValue: SwiftType) {
		self.init(FundamentalType(swiftValue))
	}

	// SDAI__STRING__type \SDAI__STRING__subtype
	var length: Int { return rep.length }
	subscript(index: Int?) -> SDAI.STRING? { return rep[index] }
	subscript(range: ClosedRange<Int>?) -> SDAI.STRING? { return rep[range] }
	func ISLIKE(PATTERN substring: SwiftType? ) -> SDAI.LOGICAL { rep.ISLIKE(PATTERN: substring) }
}
