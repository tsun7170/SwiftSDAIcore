//
//  SdaiValue.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation

public protocol SDAIValue: Hashable
{
	func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool
	func isValueEqualOptionally<T: SDAIValue>(to rhs: T?) -> Bool?
}
public extension SDAIValue
{
	func isValueEqualOptionally<T: SDAIValue>(to rhs: T?) -> Bool? {
		guard let rhs = rhs else { return nil }
		return self.isValueEqual(to: rhs)
	}
}
