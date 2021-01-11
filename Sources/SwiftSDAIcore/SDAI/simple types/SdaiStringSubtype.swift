//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation

//MARK: - STRING subtype
public protocol SDAI__STRING__subtype: SDAI__STRING__type, SDAIDefinedType
where Supertype: SDAI__STRING__type
//			Supertype.FundamentalType == SDAI.STRING
{}
public extension SDAI__STRING__subtype
{
	// SDAIGenericType
	init?<S: SDAISelectType>(possiblyFrom select: S?) {
		guard let fundamental = FundamentalType(possiblyFrom: select) else { return nil }
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
