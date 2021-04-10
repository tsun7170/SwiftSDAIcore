//
//  SDAIParameterDataSchema.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/24.
//  Copyright © 2020 Minokamo, Japan. All rights reserved.
//

import Foundation

////MARK: (9.4.3)
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
	

	//MARK: (9.4.2)
	open class _PartialEntityBase: SDAI.Object {
		public unowned var owningModel: SDAIPopulationSchema.SdaiModel { abstruct() }
		public var definition: SDAIDictionarySchema.EntityDefinition { abstruct() }		
		
		//MARK: P21 support
		public var p21name: P21Decode.EntityInstanceName? { abstruct() }
	}
	
	open class _ComplexEntityBase: SDAI.Object {
		public unowned var owningModel: SDAIPopulationSchema.SdaiModel { abstruct() }
		//MARK: P21 support
		public var p21name: P21Decode.EntityInstanceName? { abstruct() }		
	}
	
	open class EntityInstance: SDAI.ObjectReference<SDAI.ComplexEntity> {
		public unowned var owningModel: SDAIPopulationSchema.SdaiModel { return self.object.owningModel }
		public var definition: SDAIDictionarySchema.EntityDefinition { return Self.entityDefinition }
//		public var values: [SDAIAttributeValueType] { abstruct() }
		
		public static let entityDefinition: SDAIDictionarySchema.EntityDefinition = createEntityDefinition()
		open class func createEntityDefinition() -> SDAIDictionarySchema.EntityDefinition { abstruct() }
	}

	//MARK: (9.4.3)
	open class ApplicationInstance: EntityInstance {
		public var persistentLabel: STRING? { 
			guard let p21name = self.object.p21name else { return nil }
			return "#\(p21name)" 
		}
	}
	
//	//MARK: (9.4.7)
//	public class AttributeValue<T: SDAIGenericType>: SDAI.Object, SDAIAttributeValueType {
//		public var dataValue: T? { abstruct() }
//		public var attributeDefinition: SDAIDictionarySchema.Attribute { abstruct() }
//		public var valueSet: Bool  { dataValue != nil }
//		
//		public unowned var owningEntity: EntityInstance { abstruct() }
//	}
}
