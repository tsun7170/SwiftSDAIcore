//
//  SdaiDefinedType.swift
//  
//
//  Created by Yoshida on 2020/09/22.
//

import Foundation

//MARK: - Underlying Type
public protocol SDAIUnderlyingType: SDAIGenericType
{
	associatedtype FundamentalType: SDAIUnderlyingType
	associatedtype SwiftType
	
	static var typeName: String {get}

	var asFundamentalType: FundamentalType {get}
	var asSwiftType: SwiftType {get}
	
	init?(_ fundamental: FundamentalType?)
	init(_ fundamental: FundamentalType)
	init?<T: SDAIUnderlyingType>(_ sibling: T?) where T.FundamentalType == FundamentalType
	init<T: SDAIUnderlyingType>(_ sibling: T) where T.FundamentalType == FundamentalType
	
}
public extension SDAIUnderlyingType 
{
	init?(_ fundamental: FundamentalType?) {
		guard let fundamental = fundamental else { return nil }
		self.init(fundamental)
	}
	
	init?<T: SDAIUnderlyingType>(_ sibling: T?) where T.FundamentalType == FundamentalType {
		guard let sibling = sibling else { return nil }
		self.init(sibling)
	}
	
	init<T: SDAIUnderlyingType>(_ sibling: T) where T.FundamentalType == FundamentalType {
		self.init(sibling.asFundamentalType)	
	}

}


//MARK: - Defined Type
public protocol SDAIDefinedType: SDAINamedType, SDAIUnderlyingType
{
	associatedtype Supertype: SDAIUnderlyingType 
	where FundamentalType == Supertype.FundamentalType,
				SwiftType == Supertype.SwiftType
	
	var rep: Supertype {get set}
}
public extension SDAIDefinedType
{ 
	// SDAIGenericType \SDAIUnderlyingType\SDAIDefinedType
	var asSwiftType: Supertype.SwiftType { return rep.asSwiftType }
	var asFundamentalType: FundamentalType { return rep.asFundamentalType }
	var typeMembers: Set<SDAI.STRING> {
		var members = rep.typeMembers
		members.insert(SDAI.STRING(Self.typeName))
		return members
	}
}
