//
//  SdaiEntityReferenceYielding.swift
//  SwiftSDAIcore
//
//  Created by Yoshida on 2025/09/22.
//

import Foundation

extension SDAI {
  /// A protocol for types that can yield references to SDAI entities, 
  /// as well as persistent entity references. 
  /// Types conforming to this protocol can provide sequences of entity references, 
  /// persistent entity references, and determine if a particular entity reference 
  /// is currently held by the conforming instance.
  ///
  /// Conformers should implement property accessors for non-persistent and persistent 
  /// entity references, and a membership test for entity references.
  ///
  /// - Note: The references yielded are not necessarily exhaustive, nor are they 
  /// guaranteed to remain valid outside the scope of their original context. 
  /// Persistent entity references are expected to be suitable for long-term, 
  /// stable identification of referenced entities.
  ///
  /// - SeeAlso: `SDAI.EntityReference`, `SDAI.GenericPersistentEntityReference`
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
