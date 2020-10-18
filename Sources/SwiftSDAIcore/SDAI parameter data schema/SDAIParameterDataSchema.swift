//
//  SDAIParameterDataSchema.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/24.
//  Copyright © 2020 Minokamo, Japan. All rights reserved.
//

import Foundation

public protocol SDAIAttributeValueType
{}

public enum SDAIParameterDataSchema {
	
	public typealias STRING = String
	public typealias BOOLEAN = Bool
	public typealias LIST = AnyRandomAccessCollection
	public typealias Primitive = SDAIGenericType
	
	public class EntityInstance: SDAI.Object {
		public var owningModel: SDAIPopulationSchema.SdaiModel { abstruct() }
		public var definition: SDAIDictionarySchema.EntityDefinition { abstruct() }
		public var values: [SDAIAttributeValueType] { abstruct() }
		
		public var persistentLabel: STRING { abstruct() }
	}

	public class ApplicationInstance: EntityInstance {
	}
	
	public class AttributeValue<T: Primitive>: SDAI.Object, SDAIAttributeValueType {
		public var dataValue: T? { abstruct() }
		public var attributeDefinition: SDAIDictionarySchema.Attribute { abstruct() }
		public var valueSet: Bool  { dataValue != nil }
		
		public unowned var owningEntity: EntityInstance { abstruct() }
	}
}
