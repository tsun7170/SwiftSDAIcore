//
//  SdaiValue.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAI {
  public protocol Value: Hashable//, Sendable
  {
    func isValueEqual<T: SDAI.Value>(
      to rhs: T) -> Bool	// NEED TO IMPLEMENT

    func isValueEqualOptionally<T: SDAI.Value>(
      to rhs: T?) -> Bool?



    func hashAsValue(
      into hasher: inout Hasher,
      visited complexEntities: inout Set<SDAI.ComplexEntity>)

    func isValueEqual<T: SDAI.Value>(
      to rhs: T,
      visited comppairs: inout Set<SDAI.ComplexPair>) -> Bool

    func isValueEqualOptionally<T: SDAI.Value>(
      to rhs: T?,
      visited comppairs: inout Set<SDAI.ComplexPair>) -> Bool?
  }
}

public extension SDAI.Value
{
	func isValueEqualOptionally<T: SDAI.Value>(
		to rhs: T?) -> Bool?
	{
		guard let rhs = rhs else { return nil }
		return self.isValueEqual(to: rhs)
	}
	
	func hashAsValue(
		into hasher: inout Hasher,
		visited complexEntities: inout Set<SDAI.ComplexEntity>)
	{
		self.hash(into: &hasher)
	}

	func isValueEqual<T: SDAI.Value>(
		to rhs: T,
		visited comppairs: inout Set<SDAI.ComplexPair>) -> Bool
	{
		self.isValueEqual(to: rhs)
	}

	func isValueEqualOptionally<T: SDAI.Value>(
		to rhs: T?,
		visited comppairs: inout Set<SDAI.ComplexPair>) -> Bool?
	{
		self.isValueEqualOptionally(to: rhs)
	}

}


//MARK: - Generic Value
extension SDAI
{
	public typealias GenericValue = AnyHashable
}

extension SDAI.GenericValue: SDAI.Value //, @unchecked @retroactive Sendable
{
	public func isValueEqual<T: SDAI.Value>(to rhs: T) -> Bool {
		return self == rhs as AnyHashable
	}

}

//MARK: - Swift Std Lib extensions
//extension AnySequence: @retroactive @unchecked Sendable where Element: Sendable {}
