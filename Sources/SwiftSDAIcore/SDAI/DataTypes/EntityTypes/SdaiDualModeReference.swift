//
//  SdaiDualModeReference.swift
//  SwiftSDAIcore
//
//  Created by Yoshida on 2025/09/26.
//

import Foundation

public protocol SDAIDualModeReference: SDAIGenericType
{
	associatedtype PRef: SDAIPersistentReference

	var pRef: PRef { get }
}

public protocol SDAIPersistentReference: SDAIGenericType
{
	associatedtype ARef: SDAIDualModeReference

	var aRef: ARef { get }

	var optionalARef: ARef? { get }
}


//MARK: - PersistentEntityReference extension
extension SDAI.PersistentEntityReference: SDAIPersistentReference
where EREF: SDAIDualModeReference
{
	public typealias ARef = EREF

	public var aRef: EREF { self.instance }

	public var optionalARef: EREF? { self.optionalInstance }
}


//MARK: - SDAIDefinedType extension
public extension SDAIDefinedType
where Self: SDAIDualModeReference,
			FundamentalType: SDAIDualModeReference
{
	var pRef: FundamentalType.PRef {
		return self.asFundamentalType.pRef
	}
}

