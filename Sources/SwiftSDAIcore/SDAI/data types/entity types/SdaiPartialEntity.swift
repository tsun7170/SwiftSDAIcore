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
		
		public required convenience init?(parameters: [P21Decode.ExchangeStructure.Parameter], exchangeStructure: P21Decode.ExchangeStructure) {
			self.init()
		}
		
		// class properties
		open class var entityReferenceType: EntityReference.Type { abstruct() } // abstruct
		
		public class var typeIdentity: TypeIdentity { 
			return self.entityReferenceType.entityDefinition 
		}
		public class var entityDefinition: SDAIDictionarySchema.EntityDefinition {
			return self.entityReferenceType.entityDefinition 
		}
		public class var entityName: EntityName { 
			return self.entityReferenceType.entityDefinition.name 
		}
		public class var qualifiedEntityName: EntityName { 
			return self.entityReferenceType.entityDefinition.qualifiedEntityName 
		}
		
		// instance properties
		public var entityName: EntityName { 
			return type(of: self).entityName
		}
		public var qualifiedEntityName: EntityName { 
			return type(of: self).qualifiedEntityName
		}

		
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
