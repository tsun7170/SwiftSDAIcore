//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation

//MARK: - ENUMERATION TYPE base
public protocol SDAIEnumerationType: SDAIConstructedType, SDAIUnderlyingType
{}
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
