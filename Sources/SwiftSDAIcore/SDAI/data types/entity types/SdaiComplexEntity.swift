//
//  File.swift
//  
//
//  Created by Yoshida on 2021/05/08.
//

import Foundation

extension SDAI {
	
	
	//MARK: - ComplexEntity
	open class ComplexEntity: SDAI.Object, CustomReflectable
	{
		private enum EntityReferenceStatus {
			case unknown
			case resolved(EntityReference)
			case invalid
		}
		private var _partialEntities: Dictionary<PartialEntity.TypeIdentity,(instance:PartialEntity,reference:EntityReferenceStatus)> = [:]
		
		public var customMirror: Mirror {
			return Mirror(self, 
										children: [	"name" : self.qualifiedName, 
																 "partialEntities" : self.partialEntities], 
										displayStyle: .struct, 
										ancestorRepresentation: .suppressed)
		}
		
		public init(entities:[PartialEntity], model:SDAIPopulationSchema.SdaiModel, name:P21Decode.EntityInstanceName) {
			self.owningModel = model
			self.p21name = name
			super.init()
			if !model.contents.add(complex: self) {
				self.isTemporary = true
//				fatalError("SdaiModel(\(model.name)) refused to register complex entity")
			}
			for pe in entities {
				_partialEntities[type(of: pe).typeIdentity] = (instance:pe, reference:.unknown)	
			}
		}
		public convenience init(entities:[PartialEntity]) {
			let pe = entities.first!
			let schema = type(of: pe).entityDefinition.parentSchema!
			let fallback = SDAIPopulationSchema.SdaiModel.fallBackModel(for: schema)
			let name = fallback.uniqueName
			self.init(entities:entities, model:fallback, name:name)
		}
		
		public unowned let owningModel: SDAIPopulationSchema.SdaiModel
		
		// P21 support
		public let p21name: P21Decode.EntityInstanceName
		public internal(set) var isTemporary: Bool = false
		
		public var qualifiedName: String { "\(self.owningModel.name)#\(self.p21name)\(isTemporary ? "(temporary)" : "")" }

		//MARK: partial entity access
		public var partialEntities: [PartialEntity] {
			_partialEntities.values.map{ (tuple) in tuple.instance }
		}
		
		public func partialEntityInstance<PENT:PartialEntity>(_ peType:PENT.Type) -> PENT? {
			if let tuple = _partialEntities[peType.typeIdentity] {
				return tuple.instance as? PENT
			}
			return nil
		}
		
		public func resolvePartialEntityInstance(from namelist:[PartialEntity.TypeIdentity]) -> PartialEntity? {
			for typeIdentity in namelist {
				if let tuple = _partialEntities[typeIdentity] {
					return tuple.instance
				}
			}
			return nil
		}
		
		//MARK: entity reference access
		public var entityReferences: [EntityReference] {
			var result:[EntityReference] = []
			
			for tuple in _partialEntities.values {
				if let eref = self.entityReference(type(of:tuple.instance).entityReferenceType) {
					result.append(eref)
				}
			}
			return result
		}
		
		public func entityReference<EREF:EntityReference>(_ erefType:EREF.Type) -> EREF? {
			let typeid = erefType.partialEntityType.typeIdentity
			if let tuple = _partialEntities[typeid] {
				switch tuple.reference {
				case .resolved(let eref):
					if let eref = eref as? EREF {
						return eref
					}
					else {
						fatalError("internal error")
					}
				
				case .invalid:
					return nil
				
				case .unknown:
					let pe = tuple.instance
					if let eref = erefType.init(complex:self) {
						return eref
					}
					else {
						_partialEntities[typeid] = (instance:pe, reference:.invalid)
						return nil
					}
				}
			}
			return nil
		}
		
		internal func updateEntityReference(_ eref: EntityReference) -> Bool {
			let typeid = type(of: eref).partialEntityType.typeIdentity
			guard let tuple = _partialEntities[typeid] else { return false }
			
			switch tuple.reference {
			case .resolved(let registered):
				eref.unify(with: registered)
				return true
				
			case .invalid:
				return false
				
			case .unknown:
				if self.isTemporary {
					eref.retainer = self
				}
				else {
					_partialEntities[typeid] = (instance:tuple.instance, reference:.resolved(eref))
				}
				return true
			}
		}
		
		//MARK: express built-in function support
		private func findRoles(in entity: SDAI.EntityReference) -> [SDAIAttributeType] {
			var roles:[SDAIAttributeType] = []
			let entityDef = entity.definition
			for attrDef in entityDef.attributes.values {
				if !attrDef.mayYieldEntityReference { continue } 
				if attrDef.kind == .derived || attrDef.kind == .derivedRedeclaring { continue }
				guard let attrYieldingEntities = attrDef.genericValue(for: entity)?.entityReferences else { continue }
				for attrEntity in attrYieldingEntities {
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
				for complex in schemaInstance.allComplexEntities {
					for entity in complex.entityReferences {
						result.formUnion( self.findRoles(in: entity).lazy.map{ (attrDef) in
							return STRING(from: attrDef.qualifiedAttributeName) 
						} )
					}
				}
			}
			return result
		}
		
		
		private var _usedInCache: [SDAIPopulationSchema.SchemaInstance:[EntityReference]] = [:]
		public func resetCache(relatedTo schemaInstance: SDAIPopulationSchema.SchemaInstance) {
			_usedInCache[schemaInstance] = nil
			for entity in self.entityReferences {
				entity.resetCache()
			}
		}
		
		public func usedIn() -> [EntityReference] { 
			var result: [EntityReference] = []
			let model = self.owningModel
			for schemaInstance in model.associatedWith {				
				var schemaResult: [EntityReference] = []
				if let cached = self._usedInCache[schemaInstance] {
					schemaResult = cached
				}
				else {
					for complex in schemaInstance.allComplexEntities {
						for entity in complex.entityReferences {
							
							let entityDef = entity.definition
							for attrDef in entityDef.attributes.values {
								if !attrDef.mayYieldEntityReference { continue }
								if attrDef.source != .thisEntity { continue }
								if attrDef.kind == .derived || attrDef.kind == .derivedRedeclaring { continue }
								guard let attrValue = attrDef.genericValue(for: entity) else { continue } 
								let attrYieldingEntities = attrValue.entityReferences
								for attrEntity in attrYieldingEntities {
									if self === attrEntity.complexEntity {
										schemaResult.append(entity)
									}
								}
							}
							
						}
					}
					if schemaInstance.mode == .readOnly {
						_usedInCache[schemaInstance] = schemaResult
					}
				}
				
				result.append(contentsOf: schemaResult)
			}
			return result
		}
		
		public func usedIn<ENT:EntityReference, R:SDAIGenericType>(as role: KeyPath<ENT,R>) -> [ENT] { 
			var result: [ENT] = []
			let model = self.owningModel
			for schemaInstance in model.associatedWith {
				for complex in schemaInstance.allComplexEntities {
//					if complex === self { continue }
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
				for complex in schemaInstance.allComplexEntities {
//					if complex === self { continue }
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
			Set( _partialEntities.values.map{ (tuple) -> STRING in STRING(from: tuple.instance.qualifiedEntityName) } ) 
		}
		
		public typealias Value = _ComplexEntityValue
		public var value: Value { _ComplexEntityValue(self) }

		func hashAsValue(into hasher: inout Hasher, visited complexEntities: inout Set<ComplexEntity>) {
			guard !complexEntities.contains(self) else { return }
			complexEntities.insert(self)
			for tuple in _partialEntities.values {
				tuple.instance.hashAsValue(into: &hasher, visited: &complexEntities)
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
			for (typeIdentity, ltuple) in self._partialEntities {
				guard let rtuple = rhs._partialEntities[typeIdentity] else { return false }
				if ltuple.instance === rtuple.instance { continue }
				if !ltuple.instance.isValueEqual(to: rtuple.instance, visited: &comppairs) { return false }
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
			for (typeIdentity, ltuple) in self._partialEntities {
				guard let rtuple = rhs._partialEntities[typeIdentity] else { return false }
				if ltuple.instance === rtuple.instance { continue }
				if let result = ltuple.instance.isValueEqualOptionally(to: rtuple.instance, visited: &comppairs), !result { return false }
				else { isequal = nil }
			}
			return isequal
		}
		
		//MARK: where rule validation support
		public func validateEntityWhereRules(prefix:SDAI.WhereLabel, round:ValidationRound) -> [SDAI.EntityReference:[SDAI.WhereLabel:SDAI.LOGICAL]] {
			var result: [SDAI.EntityReference:[SDAI.WhereLabel:SDAI.LOGICAL]] = [:]
			for tuple in _partialEntities.values {
				let etype = type(of: tuple.instance).entityReferenceType
				if let eref = self.entityReference(etype) {
//				if let eref = etype.init(complex: self) {
					let peResult = etype.validateWhereRules(instance:eref, prefix: prefix + "\\" + tuple.instance.entityName, round: round)
					if !peResult.isEmpty {
						result[eref] = peResult
					}
				}
			}
			return result
		}

	}
	
}
