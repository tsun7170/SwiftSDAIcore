//
//  EntityAttributes.swift
//  
//
//  Created by Yoshida on 2021/07/04.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAI.EntityReference {
	
	public class AttributeList : CustomStringConvertible 
	{
		public var description: String {
			var str = ""
			for (i,tuple) in attributes.enumerated() {
				print("[\(i)]\t\(tuple.definition.name) (\(tuple.definition.kind)): \(tuple.definition.domain) = ", terminator: "", to: &str)
				if let value = tuple.value?.base {
					print("\(value)", to: &str)
				}
				else {
					print("nil", to: &str)
				}
			}
			return str
		}
		
		public typealias AttributeTuple = (definition: SDAIAttributeType, value: SDAI.GENERIC?)
		public private(set) var attributes: [AttributeTuple] = []
		
		internal init(entity: SDAI.EntityReference) {
			let entityDef = entity.definition
			for attrDef in entityDef.attributes.values {
				let attrValue = attrDef.genericValue(for: entity)
				let tuple = (definition: attrDef, value: attrValue)
				attributes.append(tuple)
			}
		}
	}
	
}
