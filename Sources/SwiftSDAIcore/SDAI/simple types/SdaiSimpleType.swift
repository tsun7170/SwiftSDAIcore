//
//  File.swift
//  
//
//  Created by Yoshida on 2020/09/22.
//

import Foundation

public protocol SDAISimpleType: SDAIUnderlyingType
where Value == FundamentalType
{
	init?(_ swiftValue: SwiftType?)
	init(_ swiftValue: SwiftType)
}
public extension SDAISimpleType
{
	// SDAIGenericType \SDAIUnderlyingType\SDAISimpleType
	var value: Value { self.asFundamentalType }
	
	// SDAISimpleType
	init?(_ swiftValue: SwiftType?) {
		guard let swiftValue = swiftValue else { return nil }
		self.init(swiftValue)
	}
}
