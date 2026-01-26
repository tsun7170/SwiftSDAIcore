//
//  RuleSupport.swift
//  
//
//  Created by Yoshida on 2021/01/21.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - Rule (9.6) Implicit declaration

extension SDAI {

  /// Returns a set containing the persistent references (`PRef`) to entities of the specified type found in the given sequence of complex entities.
  /// 
  /// This function filters the provided sequence of `SDAI.ComplexEntity` objects for those that can be referenced as the given `ENTITY` type,
  /// and collects their persistent references into a `SET`.
  ///
  /// - Parameters:
  ///   - entityType: The type of entity to look for in the provided sequence. Must conform to both `SDAI.EntityReference` and `SDAI.DualModeReference`.
  ///   - complexEntities: A sequence of complex entities to be searched.
  /// - Returns: An `SDAI.SET` containing the persistent references (`PRef`) of the found entities.
  ///
	public static func POPULATION<ENTITY>(
		OF entityType: ENTITY.Type,
		FROM complexEntities: AnySequence<SDAI.ComplexEntity>
	) -> SDAI.SET<ENTITY.PRef>
  where ENTITY: SDAI.EntityReference & SDAI.DualModeReference
	{
		let filtered = complexEntities.lazy.compactMap { $0.entityReference(entityType)?.pRef }
		return SET(from: Set(filtered))
	}
}
