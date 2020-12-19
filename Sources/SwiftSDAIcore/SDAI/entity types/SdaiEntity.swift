//
//  SdaiEntity.swift
//  
//
//  Created by Yoshida on 2020/10/18.
//

import Foundation


extension SDAI {
	
	public typealias EntityName = SDAIDictionarySchema.ExpressId

	
	//MARK: - PartialEntity
	open class PartialEntity: SDAI.Object {
		public typealias TypeIdentity = EntityName
		public class var typeIdentity: TypeIdentity { abstruct() }
		public class var entityName: EntityName { abstruct() }
		public class var qualifiedEntityName: EntityName { abstruct() }
		public var entityName: EntityName { abstruct() }
		public var qualifiedEntityName: EntityName { abstruct() }
		public var complexEntities: Set<ComplexEntity> { abstruct() }
		
		public override init() { abstruct() }
		
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
	
	
	//MARK: - ComplexEntity
	open class ComplexEntity: SDAI.Object {
		private var partialEntities: Dictionary<PartialEntity.TypeIdentity,(instance:PartialEntity,reference:EntityReference?)> = [:]
		
		public init(entities:[PartialEntity]) {
			super.init()
			
			for pe in entities {
				partialEntities[type(of: pe).typeIdentity] = (instance:pe, reference:nil)	
			}
		}
		
		public func partialEntityInstance<PENT:PartialEntity>(_ peType:PENT.Type) -> PENT? {
			if let (pe,_) = partialEntities[peType.typeIdentity] {
				return pe as? PENT
			}
			return nil
		}
		
		public func resolvePartialEntityInstance(from namelist:[PartialEntity.TypeIdentity]) -> PartialEntity? {
			for typeIdentity in namelist {
				if let (pe,_) = partialEntities[typeIdentity] {
					return pe
				}
			}
			return nil
		}
		
		public func entityReference<EREF:EntityReference>(_ erType:EREF.Type) -> EREF? {
			if let (pe,eref) = partialEntities[erType.partialEntityType.typeIdentity] {
				if eref != nil { return eref as? EREF }
				
				if let eref = EREF(complex:self) {
					partialEntities[erType.partialEntityType.typeIdentity] = (pe,eref)
					return eref
				}
			}
			return nil
		}
		
		public var roles: Set<STRING> { abstruct() }
		public func usedIn<ENT:EntityReference>(entity:ENT.Type, attr: String) -> [ENT] { abstruct() }
		public func usedIn() -> [EntityReference] { abstruct() }

		
		// EntityReference SDAIGenericType support
		var typeMembers: Set<SDAI.STRING> { 
			Set( partialEntities.values.map{ (pe) -> STRING in STRING(stringLiteral: pe.instance.qualifiedEntityName) } ) 
		}
		
		public typealias Value = _ComplexEntityValue
		var value: Value { abstruct() }
		
		func hashAsValue(into hasher: inout Hasher, visited complexEntities: inout Set<ComplexEntity>) {
			guard !complexEntities.contains(self) else { return }
			complexEntities.insert(self)
			for (pe,_) in partialEntities.values {
				pe.hashAsValue(into: &hasher, visited: &complexEntities)
			}
		}
		
		func isValueEqual(to rhs: ComplexEntity, visited comppairs: inout Set<ComplexPair>) -> Bool {
			if self === rhs { return true }
			let lr = ComplexPair(l: self, r: rhs)
			if comppairs.contains( lr ) { return true }
			if self.partialEntities.count != rhs.partialEntities.count { return false }
			
			comppairs.insert(lr)
			for (typeIdentity, (lpe,_)) in self.partialEntities {
				guard let (rpe,_) = rhs.partialEntities[typeIdentity] else { return false }
				if lpe === rpe { continue }
				if !lpe.isValueEqual(to: rpe, visited: &comppairs) { return false }
			}
			return true
		}
		
		func isValueEqualOptionally(to rhs: ComplexEntity?, visited comppairs: inout Set<ComplexPair>) -> Bool? {
			guard let rhs = rhs else{ return nil }
			if self === rhs { return true }
			let lr = ComplexPair(l: self, r: rhs)
			if comppairs.contains( lr ) { return true }
			if self.partialEntities.count != rhs.partialEntities.count { return false }
			
			comppairs.insert(lr)
			var isequal: Bool? = true
			for (typeIdentity, (lpe,_)) in self.partialEntities {
				guard let (rpe,_) = rhs.partialEntities[typeIdentity] else { return false }
				if lpe === rpe { continue }
				if let result = lpe.isValueEqualOptionally(to: rpe, visited: &comppairs), !result { return false }
				else { isequal = nil }
			}
			return isequal
		}
	}
	
	
	//MARK: - EntityReference
	open class EntityReference: SDAI.Object, SDAIGenericType {		
		public let complexEntity: ComplexEntity
		
		// SDAIGenericType
		public typealias Value = ComplexEntity.Value
		public typealias FundamentalType = EntityReference
		
		public var typeMembers: Set<STRING> { complexEntity.typeMembers }
		public var value: ComplexEntity.Value { complexEntity.value }
		
		
		// EntityReference specific
		public static var partialEntityType: PartialEntity.Type { abstruct() }
		
		
		public required init?(complex complexEntity: ComplexEntity?) {
			guard let complexEntity = complexEntity else { return nil }
			self.complexEntity = complexEntity
			super.init()
		}
		
		public required convenience init?<S: SDAISelectType>(possiblyFrom select: S?) {
			guard let entityRef = select?.entityReference else { return nil }
			self.init(complex: entityRef.complexEntity)
		}
		
		public static func cast<EREF:EntityReference>( from source: EREF? ) -> Self? {
			return source?.complexEntity.entityReference(self)
		}
	}
}

