//
//  SdaiEntityReferenceYielding.swift
//  SwiftSDAIcore
//
//  Created by Yoshida on 2025/09/22.
//

import Foundation

public protocol SDAIEntityReferenceYielding
{
	var entityReferences: AnySequence<SDAI.EntityReference> { get }

	func isHolding(entityReference: SDAI.EntityReference) -> Bool
}

//MARK: - SDAIDefinedType extension
public extension SDAIDefinedType
where Self: SDAIEntityReferenceYielding,
			Supertype: SDAIEntityReferenceYielding
{
	var entityReferences: AnySequence<SDAI.EntityReference> { return rep.entityReferences }

	func isHolding(entityReference: SDAI.EntityReference) -> Bool
	{
		rep.isHolding(entityReference: entityReference)
	}
}
