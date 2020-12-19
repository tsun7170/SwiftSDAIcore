//
//  SdaiDefinedType.swift
//  
//
//  Created by Yoshida on 2020/09/22.
//

import Foundation

//MARK: - Underlying Type
public protocol SDAIUnderlyingSelectType: SDAIGenericType
{
	associatedtype FundamentalType: SDAIUnderlyingSelectType
	associatedtype SwiftType
	
	static var typeName: String {get}

	var asFundamentalType: FundamentalType {get}
	var asSwiftType: SwiftType {get}
	
	init?(fundamental: FundamentalType?)
	init(fundamental: FundamentalType)
}

public extension SDAIUnderlyingSelectType
{
	init?(fundamental: FundamentalType?) {
		guard let fundamental = fundamental else { return nil }
		self.init(fundamental: fundamental)
	}	
}

public protocol SDAIUnderlyingType: SDAIUnderlyingSelectType 
{
//	init?(_ fundamental: FundamentalType?)
//	init(_ fundamental: FundamentalType)
	init?<T: SDAIUnderlyingSelectType>(_ sibling: T?) where T.FundamentalType == FundamentalType
	init<T: SDAIUnderlyingSelectType>(_ sibling: T) where T.FundamentalType == FundamentalType
	
}

public extension SDAIUnderlyingType 
{
//	init?(_ fundamental: FundamentalType?) {
//		guard let fundamental = fundamental else { return nil }
//		self.init(fundamental)
//	}
	
	init?<T: SDAIUnderlyingSelectType>(_ sibling: T?) where T.FundamentalType == FundamentalType {
		guard let sibling = sibling else { return nil }
		self.init(sibling)
	}
	
	init<T: SDAIUnderlyingSelectType>(_ sibling: T) where T.FundamentalType == FundamentalType {
		self.init(fundamental: sibling.asFundamentalType)	
	}
}


//MARK: - Defined Type
public protocol SDAIDefinedType: SDAINamedType, SDAIUnderlyingSelectType
{
	associatedtype Supertype: SDAIUnderlyingSelectType 
	where Supertype.FundamentalType: SDAIUnderlyingSelectType,
				FundamentalType == Supertype.FundamentalType,
				SwiftType == FundamentalType.SwiftType
	
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
