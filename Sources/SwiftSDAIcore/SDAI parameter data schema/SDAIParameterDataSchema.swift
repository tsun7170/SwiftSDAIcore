//
//  SDAIParameterDataSchema.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/24.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: (9.4.3)
//public protocol SDAIAttributeValueType
//{
//	var genericValue: SDAI.GENERIC? { get }	
//	var attributeDefinition: SDAIDictionarySchema.Attribute { get }
//	var valueSet: Bool  { get }
//	var owningEntity: EntityInstance { get }
//}

public enum SDAIParameterDataSchema {
	
	public typealias STRING = String
	public typealias BOOLEAN = Bool
	public typealias LIST = AnyRandomAccessCollection
	public typealias Primitive = SDAIGenericType
		
	
	//MARK: - (9.4.2)
	public typealias EntityInstance = SDAI.EntityReference
	
//	open class EntityInstance: SDAI.ObjectReference<SDAI.ComplexEntity> {
//		public unowned var owningModel: SDAIPopulationSchema.SdaiModel { return self.object.owningModel }
//		public var definition: SDAIDictionarySchema.EntityDefinition { return Self.entityDefinition }
//		public var values: [SDAIAttributeValueType]
//		
//		public static let entityDefinition: SDAIDictionarySchema.EntityDefinition = createEntityDefinition()
//		open class func createEntityDefinition() -> SDAIDictionarySchema.EntityDefinition { abstruct() }	// abstruct
//	}

	
	//MARK: - (9.4.3)
	public typealias ApplicationInstance = SDAI.EntityReference
	
//	open class ApplicationInstance: EntityInstance {
//		public var persistentLabel: STRING? { 
//			let p21name = self.object.p21name
//			return "\(self.owningModel.name)#\(p21name)" 
//		}
//	}
	
//	//MARK: (9.4.7)
//	public class AttributeValue<T: SDAIGenericType>: SDAI.Object, SDAIAttributeValueType {
//		public var dataValue: T?
//		public var attributeDefinition: SDAIDictionarySchema.Attribute
//		public var valueSet: Bool  { dataValue != nil }
//		
//		public unowned var owningEntity: EntityInstance
//	}
}
