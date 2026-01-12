//
//  SdaiEntityReferenceYielding.swift
//  SwiftSDAIcore
//
//  Created by Yoshida on 2025/09/22.
//

import Foundation

extension SDAI {
  public protocol EntityReferenceYielding
  {
    var entityReferences: AnySequence<SDAI.EntityReference> { get }

    var persistentEntityReferences: AnySequence<SDAI.GenericPersistentEntityReference> { get }

    func isHolding(entityReference: SDAI.EntityReference) -> Bool

  }
}

//MARK: - SDAI.DefinedType extension
public extension SDAI.DefinedType
where Self: SDAI.EntityReferenceYielding,
			Supertype: SDAI.EntityReferenceYielding
{
  var entityReferences: AnySequence<SDAI.EntityReference> {
    return rep.entityReferences
  }

  var persistentEntityReferences: AnySequence<SDAI.GenericPersistentEntityReference> {
    return rep.persistentEntityReferences
  }

	func isHolding(entityReference: SDAI.EntityReference) -> Bool
	{
		rep.isHolding(entityReference: entityReference)
	}
}
