//
//  SdaiEnumeration.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - ENUMERATION TYPE base (8.4.1)

extension SDAI {
  public protocol EnumerationType: SDAI.ConstructedType, SDAI.UnderlyingType
  where Value == FundamentalType,
          FundamentalType: SDAI.EnumerationType,
          FundamentalType: RawRepresentable,
          FundamentalType.RawValue == SDAI.ENUMERATION
  {}
}

public extension SDAI.EnumerationType
{
	// SDAI.GenericType
	func copy() -> Self { return self }
	var isCacheable: Bool { return true }
	var value: Value { self.asFundamentalType }
}

public extension SDAI.EnumerationType
where Self: SDAIValue
{
	// SDAIValue
	func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool 
	{
		if let rhs = rhs as? Self { return self == rhs }
		return false
	}
}


//MARK: - GenericEnumValue

extension SDAI {
	public typealias ENUMERATION = Int
	
	public struct GenericEnumValue: Hashable
	{
		let typeId: Any.Type
		let enumCardinal: ENUMERATION
		
		public init<T>(_ enumeration: T) where T: RawRepresentable, T.RawValue == ENUMERATION
		{
			typeId = T.self
			enumCardinal = enumeration.rawValue
		}
		
		public static func == (lhs: GenericEnumValue, rhs: GenericEnumValue) -> Bool {
			return lhs.typeId == rhs.typeId && lhs.enumCardinal == rhs.enumCardinal
		}
		
		public func hash(into hasher: inout Hasher) {
			withUnsafePointer(to: typeId) { (p) -> Void in
				hasher.combine(p.hashValue)
			}
			hasher.combine(enumCardinal)
		}
	}

}
