//
//  SdaiDefinedType.swift
//  
//
//  Created by Yoshida on 2020/09/22.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - Underlying Type base (8.6.3)
public protocol SDAISelectCompatibleUnderlyingTypeBase: SDAIGenericType 
where FundamentalType: SDAISelectCompatibleUnderlyingTypeBase
{
//	static var typeName: String {get}
}



//MARK: - Underlying Type excluding select type
public protocol SDAIUnderlyingType: SDAISelectCompatibleUnderlyingTypeBase, InitializableByDefinedtype 
{}
public extension SDAIUnderlyingType 
{	
	init?<T: SDAIUnderlyingType>(possiblyFrom underlyingType: T?) 
	{
		if let fundamental = underlyingType?.asFundamentalType as? FundamentalType {
			self.init(fundamental: fundamental)
		}
		else {
			self.init(fromGeneric: underlyingType)
		}
	}

}



//MARK: - Defined Type (8.3.2)
public protocol SDAIDefinedType: SDAINamedType, SDAISelectCompatibleUnderlyingTypeBase
{
	associatedtype Supertype: SDAISelectCompatibleUnderlyingTypeBase 
	where FundamentalType == Supertype.FundamentalType,
				Value == Supertype.Value
	
	var rep: Supertype {get set}	
}
public extension SDAIDefinedType
{ 
	var asFundamentalType: FundamentalType { return rep.asFundamentalType }
}

public extension SDAIDefinedType where Self: Equatable, FundamentalType: Equatable
{
	static func ==<T:SDAIUnderlyingType> (lhs: Self, rhs: T) -> Bool
	where FundamentalType == T.FundamentalType
	{ 
		return lhs.asFundamentalType == rhs.asFundamentalType
	}

	static func ==<T:SDAIUnderlyingType> (lhs: T, rhs: Self) -> Bool
	where FundamentalType == T.FundamentalType
	{ 
		return lhs.asFundamentalType == rhs.asFundamentalType
	}
}

public extension SDAIDefinedType where Self: Sequence, FundamentalType: Sequence
{
	func makeIterator() -> FundamentalType.Iterator { return self.asFundamentalType.makeIterator() }

}
