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
	public static func POPULATION<ENTITY: SDAI.EntityReference>(OF entityType: ENTITY.Type, FROM complexEntities: AnySequence<SDAI.ComplexEntity>) -> SDAI.SET<ENTITY> {
		let filtered = complexEntities.lazy.compactMap { $0.entityReference(entityType) }
		return SET(from: Set(filtered))
	}
}
