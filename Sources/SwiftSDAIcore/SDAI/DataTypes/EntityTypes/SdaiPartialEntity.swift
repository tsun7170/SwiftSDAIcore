//
//  SdaiPartialEntity.swift
//  
//
//  Created by Yoshida on 2021/05/08.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAI {
	
	
	//MARK: - PartialEntity
	open class PartialEntity: SDAI.Object, CustomStringConvertible, @unchecked Sendable
	{
		public typealias TypeIdentity = SDAIDictionarySchema.EntityDefinition
		
		public init(asAbstractSuperclass:()) {
			assert(type(of:self) != PartialEntity.self, "abstract class instantiated")
		}
		
		public required convenience init?(
			parameters: [P21Decode.ExchangeStructure.Parameter],
			exchangeStructure: P21Decode.ExchangeStructure)
		{
			self.init(asAbstractSuperclass:())
		}

		public required convenience init(from original:SDAI.PartialEntity)
		{
//			let original = original as! Self
			self.init(asAbstractSuperclass:())
		}

		// CustomStringConvertible
		public var description: String {
			var str = "\(self.qualifiedEntityName)\n"
			
			let mirror = Mirror(reflecting: self)
			for child in mirror.children {
				str += "\t\(child.label ?? "<unnamed>"): \t\(child.value)\n"
			}
			
			return str			
		}
		
		// class properties
		open class var entityReferenceType: EntityReference.Type { abstract() } // abstruct
		
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
		public class var typeName: String { self.qualifiedEntityName }
		
		// instance properties
		public var entityName: EntityName { 
			return type(of: self).entityName
		}
		public var qualifiedEntityName: EntityName { 
			return type(of: self).qualifiedEntityName
		}
		open var typeMembers: Set<SDAI.STRING> { [] }

		
		open func hashAsValue(into hasher: inout Hasher, visited complexEntities: inout Set<ComplexEntity>) {
			hasher.combine(Self.typeIdentity)
		}
		
		open func isValueEqual(to rhs: PartialEntity, visited comppairs: inout Set<ComplexPair>) -> Bool {
			return type(of: rhs) == Self.self
		}
		
		open func isValueEqualOptionally(to rhs: PartialEntity, visited comppairs: inout Set<ComplexPair>) -> Bool? {
			return type(of: rhs) == Self.self
		}
		
		// attribute observer support
		private var _owners: Set<UnownedReference<ComplexEntity>> = []
		public var owners: some Collection<ComplexEntity> { _owners.lazy.map{$0.object} }

		open func broadcast(addedToComplex complex: ComplexEntity) {
			_owners.insert(UnownedReference(complex))
		}
		open func broadcast(removedFromComplex complex: ComplexEntity) {
			_owners.remove(UnownedReference(complex))
		}
		
		// dynamic attribute support
		open class func fixupPartialComplexEntityAttributes(partialComplex: SDAI.ComplexEntity, baseComplex: SDAI.ComplexEntity) {}
	}
	
}
