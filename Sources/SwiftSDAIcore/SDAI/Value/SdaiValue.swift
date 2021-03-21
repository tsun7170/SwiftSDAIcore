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
	
	func hashAsValue(into hasher: inout Hasher, visited complexEntities: inout Set<SDAI.ComplexEntity>)
	func isValueEqual<T: SDAIValue>(to rhs: T, visited comppairs: inout Set<SDAI.ComplexPair>) -> Bool
	func isValueEqualOptionally<T: SDAIValue>(to rhs: T?, visited comppairs: inout Set<SDAI.ComplexPair>) -> Bool?
}
public extension SDAIValue
{
	func isValueEqualOptionally<T: SDAIValue>(to rhs: T?) -> Bool? {
		guard let rhs = rhs else { return nil }
		return self.isValueEqual(to: rhs)
	}
	
	func hashAsValue(into hasher: inout Hasher, visited complexEntities: inout Set<SDAI.ComplexEntity>) {
		self.hash(into: &hasher)
	}
	func isValueEqual<T: SDAIValue>(to rhs: T, visited comppairs: inout Set<SDAI.ComplexPair>) -> Bool {
		self.isValueEqual(to: rhs)
	}
	func isValueEqualOptionally<T: SDAIValue>(to rhs: T?, visited comppairs: inout Set<SDAI.ComplexPair>) -> Bool? {
		self.isValueEqualOptionally(to: rhs)
	}

}


//MARK: - Generic Value
extension SDAI
{
	public typealias GenericValue = AnyHashable	
}

extension SDAI.GenericValue: SDAIValue
{
	public func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool {
		return self == rhs as AnyHashable
	}

}
