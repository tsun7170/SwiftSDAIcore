//
//  SdaiDefinedType.swift
//  
//
//  Created by Yoshida on 2020/09/22.
//

import Foundation

//MARK: - Underlying Type base
public protocol SDAISelectCompatibleUnderlyingTypeBase: SDAIGenericType
{
	associatedtype FundamentalType: SDAISelectCompatibleUnderlyingTypeBase
//	associatedtype SwiftType//: SDAISwiftType
	
	static var typeName: String {get}

	var asFundamentalType: FundamentalType {get}
//	var asSwiftType: SwiftType {get}
	
//	init?(fundamental: FundamentalType?)
	init(fundamental: FundamentalType)
}
public extension SDAISelectCompatibleUnderlyingTypeBase
{
	init?(fundamental: FundamentalType?) {
		guard let fundamental = fundamental else { return nil }
		self.init(fundamental: fundamental)
	}	
}



//MARK: - Underlying Type excluding select type
public protocol SDAIUnderlyingType: SDAISelectCompatibleUnderlyingTypeBase, InitializableByDefinedtype 
{}
public extension SDAIUnderlyingType 
{
	init?<T: SDAIUnderlyingType>(possiblyFrom underlyingType: T?) {
		guard let fundamental = underlyingType as? FundamentalType else { return nil }
		self.init(fundamental: fundamental)
	}

}



//MARK: - Defined Type
public protocol SDAIDefinedType: SDAINamedType, SDAISelectCompatibleUnderlyingTypeBase
{
	associatedtype Supertype: SDAISelectCompatibleUnderlyingTypeBase 
	where //Supertype.FundamentalType: SDAIUnderlyingSelectType,
				FundamentalType == Supertype.FundamentalType,
//				SwiftType == FundamentalType.SwiftType,
				Value == Supertype.Value
	
	var rep: Supertype {get set}	
}
public extension SDAIDefinedType
{ 
	// SDAIGenericType \SDAIUnderlyingType\SDAIDefinedType
//	var asSwiftType: Supertype.SwiftType { return rep.asSwiftType }
	var asFundamentalType: FundamentalType { return rep.asFundamentalType }
//	var typeMembers: Set<SDAI.STRING> {
//		var members = rep.typeMembers
//		members.insert(SDAI.STRING(Self.typeName))
//		return members
//	}
//	var value: Supertype.Value {rep.value}

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

public extension SDAIDefinedType where Self: Sequence, FundamentalType: Sequence//, Element == FundamentalType.Element
{
	func makeIterator() -> FundamentalType.Iterator { return self.asFundamentalType.makeIterator() }

}
