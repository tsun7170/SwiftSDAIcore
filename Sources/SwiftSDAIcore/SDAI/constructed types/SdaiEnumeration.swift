//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation

//MARK: - ENUMERATION TYPE base
public protocol SDAIEnumerationType: SDAIConstructedType, SDAIUnderlyingType
where Value == FundamentalType
//			SwiftType == FundamentalType
{}

public extension SDAIEnumerationType
{
	// SDAIGenericType
	var value: Value { self.asFundamentalType }
	
//	// SDAIUnderlyingType
//	var asSwiftType: SwiftType { self.asFundamentalType }
}

public extension SDAIEnumerationType
where Self: SDAIValue
{
	// SDAIValue
	func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool 
	{
		if let rhs = rhs as? Self { return self == rhs }
		return false
	}
}

extension SDAI {
	public typealias ENUMERATION = Int
	
}
