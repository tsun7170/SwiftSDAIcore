//
//  AttributeDefinition.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/24.
//  Copyright © 2020 Minokamo, Japan. All rights reserved.
//

import Foundation

public protocol SDAIAttributeType {
	var name: SDAIDictionarySchema.ExpressId { get }
	var parentEntity: SDAIDictionarySchema.EntityDefinition { get }
	var qualifiedAttributeName: SDAIDictionarySchema.ExpressId { get }
	func genericValue(for entity: SDAI.EntityReference) -> SDAI.GENERIC?
}

extension SDAIDictionarySchema {
	
	public class Attribute<ENT: SDAI.EntityReference, T: SDAIGenericType>: SDAI.Object, SDAIAttributeType {
		public init(name: ExpressId, entityDef: EntityDefinition) {
			self.name = name
			self.parentEntity = entityDef
			super.init()
		}
		
	//MARK: (6.4.13)
		public let name: ExpressId
		public unowned let parentEntity: EntityDefinition
		
		//MARK: SDAIAttributeType
		public var qualifiedAttributeName: SDAIDictionarySchema.ExpressId { parentEntity.qualifiedEntityName + "." + self.name }

		public func genericValue(for entity: SDAI.EntityReference) -> SDAI.GENERIC? {
			guard let entity = entity as? ENT else { return nil }
			return SDAI.GENERIC(self.value(for: entity))
		}
		
		//MARK: swift binding support
		open func value(for entity: ENT) -> T? { abstruct() }	// abstruct
	}
	
	public class OptionalAttribute<ENT: SDAI.EntityReference, T: SDAIGenericType>: Attribute<ENT,T> {
		public init(name: ExpressId, entityDef: EntityDefinition, keyPath: KeyPath<ENT,T?>) {
			self.keyPath = keyPath
			super.init(name: name, entityDef: entityDef)
		}
		
		public let keyPath: KeyPath<ENT,T?>

		public override func value(for entity: ENT) -> T? { 
			return entity[keyPath: self.keyPath]
		}
	}

	public class NonOptionalAttribute<ENT: SDAI.EntityReference, T: SDAIGenericType>: Attribute<ENT,T> {
		public init(name: ExpressId, entityDef: EntityDefinition, keyPath: KeyPath<ENT,T>) {
			self.keyPath = keyPath
			super.init(name: name, entityDef: entityDef)
		}
		
		public let keyPath: KeyPath<ENT,T>

		public override func value(for entity: ENT) -> T? { 
			return entity[keyPath: self.keyPath]
		}
}
	
	
//	public class ExplicitAttribute<ENT: SDAI.EntityReference, T: SDAIGenericType>: Attribute<ENT,T> {
////		public var domain: BaseType
////		public var redeclaring: ExplicitAttribute?
////		public var optionalFlag: SDAI.BOOLEAN
//		
//	}
//	
//	public class DerivedAttribute<ENT: SDAI.EntityReference, T: SDAIGenericType>: Attribute<ENT,T> {
////		public var domain: BaseType
////		public var redeclaring: ExplicitOrDerived?
//		
//	}
//	
//	
////	public enum ExplicitOrDerived//: SDAISelectType 
////	{
////		case explicitAttribute(ExplicitAttribute)
////		case derivedAttribute(DerivedAttribute)
////	}
//
//	public class InverseAttribute<ENT: SDAI.EntityReference, T: SDAIGenericType>: Attribute<ENT,T> {
////		public var domain: EntityDefinition
////		public var redeclaring: InverseAttribute?
////		public var invertedAttr: ExplicitAttribute
////		public var minCardinality: Bound?
////		public var maxCardinality: Bound?
////		public var duplicates: SDAI.BOOLEAN
//	}
//	

	
	
	
}

