//
//  File.swift
//  
//
//  Created by Yoshida on 2021/07/04.
//

import Foundation

extension SDAI.EntityReference {
	
	public struct AttributeList: CustomStringConvertible {
		public var description: String {
			var str = ""
			for tuple in attributes {
				print("\(tuple.definition.name) (\(tuple.definition.kind)): \(tuple.definition.domain) = ", to: &str)
				if let value = tuple.value?.base {
					print("\(value)\n", to: &str)
				}
				else {
					print("null\n", to: &str)
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
