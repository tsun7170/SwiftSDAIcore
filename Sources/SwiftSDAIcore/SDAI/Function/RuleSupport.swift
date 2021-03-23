//
//  File.swift
//  
//
//  Created by Yoshida on 2021/01/21.
//

import Foundation

//MARK: - Rule (9.6) Implicit declaration

extension SDAI {
	public static func POPULATION<ENTITY: SDAI.EntityReference>(OF entityType: ENTITY.Type, FROM complexEntities: Set<SDAI.ComplexEntity>) -> SDAI.SET<ENTITY> {
		let filtered = complexEntities.lazy.compactMap { $0.entityReference(entityType) }
		return SET(from: Set(filtered))
	}
}
