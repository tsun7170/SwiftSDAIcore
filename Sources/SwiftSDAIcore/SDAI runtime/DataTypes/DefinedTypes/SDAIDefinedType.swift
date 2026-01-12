//
//  SdaiDefinedType.swift
//  
//
//  Created by Yoshida on 2020/09/22.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - Underlying Type base (8.6.3)
extension SDAI {
  public protocol SelectCompatibleUnderlyingTypeBase: SDAI.GenericType
  where FundamentalType: SDAI.SelectCompatibleUnderlyingTypeBase
  {}
}


//MARK: - Underlying Type excluding select type
extension SDAI {
  public protocol UnderlyingType: SDAI.SelectCompatibleUnderlyingTypeBase, SDAI.InitializableByDefinedType
  {}
}
public extension SDAI.UnderlyingType
{	
	init?<T: SDAI.UnderlyingType>(possiblyFrom underlyingType: T?) 
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
extension SDAI {
  public protocol DefinedType: SDAI.NamedType, SDAI.SelectCompatibleUnderlyingTypeBase
  {
    associatedtype Supertype: SDAI.SelectCompatibleUnderlyingTypeBase
    where FundamentalType == Supertype.FundamentalType,
          Value == Supertype.Value

    var rep: Supertype {get set}
  }
}
public extension SDAI.DefinedType
{ 
	var asFundamentalType: FundamentalType { return rep.asFundamentalType }
}

public extension SDAI.DefinedType where Self: Equatable, FundamentalType: Equatable
{
	static func ==<T:SDAI.UnderlyingType> (lhs: Self, rhs: T) -> Bool
	where FundamentalType == T.FundamentalType
	{ 
		return lhs.asFundamentalType == rhs.asFundamentalType
	}

	static func ==<T:SDAI.UnderlyingType> (lhs: T, rhs: Self) -> Bool
	where FundamentalType == T.FundamentalType
	{ 
		return lhs.asFundamentalType == rhs.asFundamentalType
	}
}

public extension SDAI.DefinedType where Self: Sequence, FundamentalType: Sequence
{
	func makeIterator() -> FundamentalType.Iterator { return self.asFundamentalType.makeIterator() }

}
