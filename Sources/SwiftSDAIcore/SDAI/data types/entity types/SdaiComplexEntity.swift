//
//  File.swift
//  
//
//  Created by Yoshida on 2021/05/08.
//

import Foundation

extension SDAI {
	
	
	//MARK: - ComplexEntity
	open class ComplexEntity: SDAI.Object
	{
		private var _partialEntities: Dictionary<PartialEntity.TypeIdentity,(instance:PartialEntity,reference:EntityReference?)> = [:]
		
		public init(entities:[PartialEntity], model:SDAIPopulationSchema.SdaiModel, name:P21Decode.EntityInstanceName) {
			self.owningModel = model
			self.p21name = name
			super.init()
			model.contents.add(complex: self)
			for pe in entities {
				_partialEntities[type(of: pe).typeIdentity] = (instance:pe, reference:nil)	
			}
		}
		public convenience init(entities:[PartialEntity]) {
			let pe = entities.first!
			let schema = type(of: pe).entityReferenceType.entityDefinition.parentSchema!
			let fallback = SDAIPopulationSchema.SdaiModel.fallBackModel(for: schema)
			let name = fallback.uniqueName
			self.init(entities:entities, model:fallback, name:name)
		}
		
		public unowned let owningModel: SDAIPopulationSchema.SdaiModel
		
		// P21 support
		public let p21name: P21Decode.EntityInstanceName

		//MARK: partial entity access
		public var partialEntities: [PartialEntity] {
			_partialEntities.values.map{ (pe) in pe.instance }
		}
		
		public func partialEntityInstance<PENT:PartialEntity>(_ peType:PENT.Type) -> PENT? {
			if let (pe,_) = _partialEntities[peType.typeIdentity] {
				return pe as? PENT
			}
			return nil
		}
		
		public func resolvePartialEntityInstance(from namelist:[PartialEntity.TypeIdentity]) -> PartialEntity? {
			for typeIdentity in namelist {
				if let (pe,_) = _partialEntities[typeIdentity] {
					return pe
				}
			}
			return nil
		}
		
		//MARK: entity reference access
		public var entityReferences: [EntityReference] {
			var result:[EntityReference] = []
			
			for pe in self.partialEntities {
				if let eref = self.entityReference(type(of: pe).entityReferenceType) {
					result.append(eref)
				}
			}
			return result
		}
		
		public func entityReference<EREF:EntityReference>(_ erefType:EREF.Type) -> EREF? {
			if let (pe,eref) = _partialEntities[erefType.partialEntityType.typeIdentity] {
				if eref != nil { return eref as? EREF }
				
				if let eref = EREF(complex:self) {
					_partialEntities[erefType.partialEntityType.typeIdentity] = (pe,eref)
					return eref
				}
			}
			return nil
		}
		
		//MARK: express built-in function support
		private func findRoles(in entity: SDAI.EntityReference) -> [SDAIAttributeType] {
			var roles:[SDAIAttributeType] = []
			let entityDef = entity.definition
			for (_, attrDef) in entityDef.attributes {
				guard let attrEntitySeq = attrDef.genericValue(for: entity)?.entityReferences else { continue }
				for attrEntity in attrEntitySeq {
					if self === attrEntity.complexEntity {
						roles.append(attrDef)
					}
				}
			}
			return roles
		}
		
		public var roles: Set<STRING> { 
			var result: Set<STRING> = []
			let model = self.owningModel
			for schemaInstance in model.associatedWith {
				for complex in schemaInstance.object.allComplexEntities {
					for entity in complex.entityReferences {
						result.formUnion( self.findRoles(in: entity).lazy.map{ (attrDef) in
							return STRING(attrDef.qualifiedAttributeName) 
						} )
					}
				}
			}
			return result
		}
		
		public func usedIn() -> [EntityReference] { 
			var result: [EntityReference] = []
			let model = self.owningModel
			for schemaInstance in model.associatedWith {
				for complex in schemaInstance.object.allComplexEntities {
					for entity in complex.entityReferences {
						result.append(contentsOf: self.findRoles(in: entity).lazy.map{ _ in entity } )
					}
				}
			}
			return result
		}
		
		public func usedIn<ENT:EntityReference, R:SDAIGenericType>(as role: KeyPath<ENT,R>) -> [ENT] { 
			var result: [ENT] = []
			let model = self.owningModel
			for schemaInstance in model.associatedWith {
				for complex in schemaInstance.object.allComplexEntities {
					guard let entity = complex.entityReference(ENT.self) else { continue }
					let attr = SDAI.GENERIC( entity[keyPath: role] )
					for attrEntity in attr.entityReferences {
						if self === attrEntity.complexEntity {
							result.append(entity)
						}
					}
				}
			}
			return result
		}
		
		public func usedIn<ENT:EntityReference, R:SDAIGenericType>(as role: KeyPath<ENT,R?>) -> [ENT] { 
			var result: [ENT] = []
			let model = self.owningModel
			for schemaInstance in model.associatedWith {
				for complex in schemaInstance.object.allComplexEntities {
					guard let entity = complex.entityReference(ENT.self) else { continue }
					guard let attr = SDAI.GENERIC( entity[keyPath: role] ) else { continue }
					for attrEntity in attr.entityReferences {
						if self === attrEntity.complexEntity {
							result.append(entity)
						}
					}
				}
			}
			return result
		}

		public var typeMembers: Set<SDAI.STRING> { 
			Set( _partialEntities.values.map{ (peTuple) -> STRING in STRING(stringLiteral: peTuple.instance.qualifiedEntityName) } ) 
		}
		
		public typealias Value = _ComplexEntityValue
		public var value: Value { _ComplexEntityValue(self) }

		func hashAsValue(into hasher: inout Hasher, visited complexEntities: inout Set<ComplexEntity>) {
			guard !complexEntities.contains(self) else { return }
			complexEntities.insert(self)
			for (pe,_) in _partialEntities.values {
				pe.hashAsValue(into: &hasher, visited: &complexEntities)
			}
		}
		
		func isValueEqual(to rhs: ComplexEntity, visited comppairs: inout Set<ComplexPair>) -> Bool {
			// per (12.2.1.7)
			if self === rhs { return true }
			let lr = ComplexPair(l: self, r: rhs)
			let rl = ComplexPair(l: rhs, r: self)
			if comppairs.contains( lr ) { return true }
			if self._partialEntities.count != rhs._partialEntities.count { return false }
			
			comppairs.insert(lr); comppairs.insert(rl)
			for (typeIdentity, (lpe,_)) in self._partialEntities {
				guard let (rpe,_) = rhs._partialEntities[typeIdentity] else { return false }
				if lpe === rpe { continue }
				if !lpe.isValueEqual(to: rpe, visited: &comppairs) { return false }
			}
			return true
		}
		
		func isValueEqualOptionally(to rhs: ComplexEntity?, visited comppairs: inout Set<ComplexPair>) -> Bool? {
			// per (12.2.1.7)
			guard let rhs = rhs else{ return nil }
			if self === rhs { return true }
			let lr = ComplexPair(l: self, r: rhs)
			let rl = ComplexPair(l: rhs, r: self)
			if comppairs.contains( lr ) { return true }
			if self._partialEntities.count != rhs._partialEntities.count { return false }
			
			comppairs.insert(lr); comppairs.insert(rl)
			var isequal: Bool? = true
			for (typeIdentity, (lpe,_)) in self._partialEntities {
				guard let (rpe,_) = rhs._partialEntities[typeIdentity] else { return false }
				if lpe === rpe { continue }
				if let result = lpe.isValueEqualOptionally(to: rpe, visited: &comppairs), !result { return false }
				else { isequal = nil }
			}
			return isequal
		}
		
		//MARK: where rule validation support
		public func validateEntityWhereRules(prefix:SDAI.WhereLabel) -> [SDAI.EntityReference:[SDAI.WhereLabel:SDAI.LOGICAL]] {
			var result: [SDAI.EntityReference:[SDAI.WhereLabel:SDAI.LOGICAL]] = [:]
			for (pe,_) in _partialEntities.values {
				if let eref = self.entityReference(type(of: pe).entityReferenceType) {
					let peResult = type(of: eref).validateWhereRules(instance:eref, prefix: prefix + "\\" + pe.entityName, excludingEntity: false)
					if !peResult.isEmpty {
						result[eref] = peResult
					}
				}
			}
			return result
		}

	}
	
}
