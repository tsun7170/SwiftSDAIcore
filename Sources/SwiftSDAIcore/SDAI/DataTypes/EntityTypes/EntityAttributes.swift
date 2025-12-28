//
//  EntityAttributes.swift
//  
//
//  Created by Yoshida on 2021/07/04.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAI.EntityReference {
	
	public typealias AttributeTuple = (definition: SDAIAttributeType, value: SDAI.GENERIC?)

	public class AttributeList : CustomStringConvertible 
	{
		public var description: String {
			var str = ""
			for (i,tuple) in attributeValues.enumerated() {
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

		public private(set) var attributeValues: [AttributeTuple] = []
		
    internal init(
      entity: SDAI.EntityReference,
      attributeDefs: some Collection<SDAIAttributeType>)
    {
			for attrDef in attributeDefs {
//				loggerSDAI.debug("evaluating attribute[\(attrDef.name)] of entity[\(entityDef.name)] #\(entity.complexEntity.p21name) ")
				let attrValue = attrDef.genericValue(for: entity)
				let tuple = (definition: attrDef, value: attrValue)
				attributeValues.append(tuple)
			}
		}
	}
	
}
