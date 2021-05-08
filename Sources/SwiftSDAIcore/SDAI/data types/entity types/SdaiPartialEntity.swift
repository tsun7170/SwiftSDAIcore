//
//  File.swift
//  
//
//  Created by Yoshida on 2021/05/08.
//

import Foundation

extension SDAI {
	
	
	//MARK: - PartialEntity
	open class PartialEntity: SDAI.Object {
		public typealias TypeIdentity = SDAIDictionarySchema.EntityDefinition
		
		public override init() {
			super.init()	
		}
		
		// class properties
		open class var entityReferenceType: EntityReference.Type { abstruct() } // abstruct
		
		public class var typeIdentity: TypeIdentity { 
			return self.entityReferenceType.entityDefinition 
		}
		public class var entityName: EntityName { 
			return self.entityReferenceType.entityDefinition.name 
		}
		public class var qualifiedEntityName: EntityName { 
			return self.entityReferenceType.entityDefinition.qualifiedEntityName 
		}
		
		// instance properties
//		public override var definition: SDAIDictionarySchema.EntityDefinition { 
//			return type(of: self).entityReferenceType.entityDefinition
//		}
		
		public var entityName: EntityName { 
			return type(of: self).entityName
		}
		public var qualifiedEntityName: EntityName { 
			return type(of: self).qualifiedEntityName
		}
//		public var complexEntities: Set<UnownedReference<ComplexEntity>> = []
		
//		public override init(model: SDAIPopulationSchema.SdaiModel) {
//			super.init(model: model)
//		}
//		public init() { 
//			let schema = type(of: self).entityReferenceType.entityDefinition.parentSchema!
//			let fallback = SDAIPopulationSchema.SdaiModel.fallBackModel(for: schema)
//			super.init(model:fallback)
//		}
		
		open func hashAsValue(into hasher: inout Hasher, visited complexEntities: inout Set<ComplexEntity>) {
			hasher.combine(Self.typeIdentity)
		}
		
		open func isValueEqual(to rhs: PartialEntity, visited comppairs: inout Set<ComplexPair>) -> Bool {
			return type(of: rhs) == Self.self
		}
		
		open func isValueEqualOptionally(to rhs: PartialEntity, visited comppairs: inout Set<ComplexPair>) -> Bool? {
			return type(of: rhs) == Self.self
		}
		
	}
	
}
