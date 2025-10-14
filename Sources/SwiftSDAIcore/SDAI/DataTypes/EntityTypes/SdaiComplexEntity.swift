//
//  SdaiComplexEntity.swift
//  
//
//  Created by Yoshida on 2021/05/08.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAI {
	
	//MARK: - PartialComplexEntity
	public final class PartialComplexEntity: ComplexEntity, @unchecked Sendable
	{
		override fileprivate func broadcastCreated() {}
		
		override fileprivate func broadcastDeleted() {}

		override public var isPartial: Bool { true }
	}
	
	//MARK: - ComplexEntity
	public class ComplexEntity:
		SDAI.Object, SdaiCacheHolder,
		CustomStringConvertible, @unchecked Sendable
	{
		private enum EntityReferenceStatus {
			case unknown
			case resolved(EntityReference)
			case invalid
		}
		private var _partialEntities: Dictionary<PartialEntity.TypeIdentity,
																						 (instance:PartialEntity, reference:EntityReferenceStatus)> = [:]

		// CustomStringConvertible
		public var description: String {
			var str = "\(self.qualifiedName)"
			if self.isPartial {
				str += "(partial)"
			}
			if self.isTemporary {
				str += "(temporary)" 
			}
			str += "\n"
			
			for (i,partial) in self.partialEntities.enumerated() {
				str += " [\(i)]\t\(partial)\n"
			}
			return str
		}
		
		deinit {
			broadcastDeleted()
		}
		
		public init(
			entities:[PartialEntity],
			model:SDAIPopulationSchema.SdaiModel,
			name:P21Decode.EntityInstanceName)
		{
			self.owningModel = model
			self.p21name = name
			if !model.contents.add(complex: self) {
				self.isTemporary = true
			}
			for pe in entities {
				_partialEntities[type(of: pe).typeIdentity] = (instance:pe, reference:.unknown)	
			}
			broadcastCreated()
		}
		public convenience init(entities:[PartialEntity]) {
			guard let session = SDAISessionSchema.activeSession else {
				SDAI.raiseErrorAndTrap(.SS_NAVL, detail: "SdaiSession object not available as TaskLocal")
			}
			let pe = entities.first!
			let schema = type(of: pe).entityDefinition.parentSchema
			let fallback = session.fallBackModel(for: schema)
			let name = fallback.uniqueName
			self.init(entities:entities, model:fallback, name:name)
		}

		internal convenience init(
			from original: ComplexEntity,
			targetModel: SDAIPopulationSchema.SdaiModel)
		{
			let entities = original.partialEntities.map{ type(of: $0).init(from: $0) }
			let name = original.p21name
			self.init(entities: entities, model: targetModel, name: name)
		}

		fileprivate func broadcastCreated() {
			for (pe,_) in _partialEntities.values {
				pe.broadcast(addedToComplex: self)
			}
		}
		
		fileprivate func broadcastDeleted() {
			for (pe,_) in _partialEntities.values {
				pe.broadcast(removedFromComplex: self)
			}
		}
		
		public unowned let owningModel: SDAIPopulationSchema.SdaiModel
		
		// P21 support
		public let p21name: P21Decode.EntityInstanceName
		public internal(set) var isTemporary: Bool = false
		
		public var qualifiedName: String { "\(self.owningModel.name)#\(self.p21name)\(isTemporary ? "(temporary)" : "")" }

		//MARK: - partial entity access
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
		
		//MARK: - entity reference access
		public var entityReferences: [EntityReference] {
			var result:[EntityReference] = []
			
			for tuple in _partialEntities.values {
				if let eref = self.entityReference(type(of:tuple.instance).entityReferenceType) {
					result.append(eref)
				}
			}
			return result
		}
		
		public var leafEntityReferences: [EntityReference] {
			let allEntities = self.entityReferences
			let entitydefs = Set(allEntities.map{$0.definition})
			var leafdefs = entitydefs
			for entitydef in entitydefs {
				let superdefs = entitydef.supertypes.dropLast().map{ $0.entityDefinition }	// excluding leaf entity
				leafdefs.subtract(superdefs)
			}
			assert(leafdefs.count > 0)
			let leafs = allEntities.filter{ leafdefs.contains($0.definition) }
			return leafs
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
						// register the erefType as invalid
						_partialEntities[typeid] = (instance:pe, reference:.invalid)
						return nil
					}
				}
			}
			return nil
		}
		
		/// register the newly created entity reference into the registry
		/// - Parameter eref: entity reference to register
		/// - Returns: true when this is the valid entity reference
		internal func registerEntityReference(_ eref: EntityReference) -> Bool {
			let typeid = type(of: eref).partialEntityType.typeIdentity
			guard let tuple = _partialEntities[typeid] else { return false }
			
			if self.isTemporary {
				eref.retainer = self
			}

			switch tuple.reference {
			case .resolved(let registered):
				eref.unify(with: registered)
				return true
				
			case .invalid:
				return false
				
			case .unknown:
					_partialEntities[typeid] = (instance:tuple.instance, reference:.resolved(eref))
				return true
			}
		}
		
		//MARK: - partial complex entity access
		open var isPartial: Bool { false }
		
		public func partialComplexEntity<EREF:EntityReference>(_ erefType:EREF.Type) -> EREF? {
			let entitydef = erefType.entityDefinition
			var partials: [PartialEntity] = []
			for supertype in entitydef.supertypes {
				guard let pe = self.partialEntityInstance(supertype.partialEntityType) else { return nil }
				partials.append(pe)
			}
			let pce = PartialComplexEntity(entities: partials, 
																		model: self.owningModel, 
																		name: self.owningModel.uniqueName)
			guard let pceref = pce.entityReference(erefType) else { return nil }
			
			for pe in partials {
				type(of: pe).fixupPartialComplexEntityAttributes(partialComplex: pce, baseComplex: self)
			}
			return pceref
		}
		
		//MARK: - express built-in function support
		public var usedInDomain: some Collection<SDAIPopulationSchema.SdaiModel>
		{
			let parentModel = self.owningModel
			var domain = Set(parentModel.associatedWith.lazy.flatMap{ $0.associatedModels })
			domain.insert(parentModel)
			return domain
		}
		
		private func findRoles(in entity: SDAI.EntityReference) -> some Collection<SDAIAttributeType>
		{
			var roles:[SDAIAttributeType] = []
			let entityDef = entity.definition

			for attrDef in entityDef.attributes.values {
				if !attrDef.mayYieldEntityReference { continue } 
				
				guard let attrYieldingEntities = attrDef.genericValue(for: entity)?.entityReferences else { continue }

				for attrEntity in attrYieldingEntities {
					if self === attrEntity.complexEntity {
						roles.append(attrDef)
						break
					}
				}

			}
			return roles
		}
		
		public var roles: Set<STRING> { 
			var result: Set<STRING> = []
			for model in self.usedInDomain {
				for complex in model.contents.allComplexEntities {
					for entity in complex.entityReferences {
						result.formUnion( self.findRoles(in: entity).lazy.map{ (attrDef) in
							return STRING(from: attrDef.qualifiedAttributeName) 
						} )
					}
				}
			}
			return result
		}
		
		//MARK: SdaiCacheHolder related
		public func notifyApplicationDomainChanged(
			relatedTo schemaInstance: SDAIPopulationSchema.SchemaInstance
		)
		{
			self.resetCache(relatedTo: schemaInstance)

			for entity in self.entityReferences {
				entity.notifyApplicationDomainChanged(relatedTo: schemaInstance)
			}
		}

		public func notifyReadWriteModeChanged(
			sdaiModel: SDAIPopulationSchema.SdaiModel
		)
		{
			for schemaInstance in sdaiModel.associatedWith {
				self.resetCache(relatedTo: schemaInstance)
			}

			for entity in self.entityReferences {
				entity.notifyReadWriteModeChanged(sdaiModel: sdaiModel)
			}
		}

		private var usedInValueCache: [SDAIPopulationSchema.SdaiModel:Set<EntityReference>] = [:]

		private func resetCache(
			relatedTo schemaInstance: SDAIPopulationSchema.SchemaInstance?)
		{
			if let schemaInstance = schemaInstance {
				for model in schemaInstance.associatedModels {
					usedInValueCache[model] = nil
				}
			}
			else {
				usedInValueCache = [:]
			}
		}
		
		public func usedIn() -> Array<EntityReference>
		{
			var result: Set<EntityReference> = []

			for model in self.usedInDomain {
				var modelResult: Set<EntityReference> = []

				if let cached = self.usedInValueCache[model] {
					modelResult = cached
				}
				else {
					for complex in model.contents.allComplexEntities {

						entityLoop: for entity in complex.entityReferences {
							if modelResult.contains(entity) { continue }

							let entityDef = entity.definition

							for attrDef in entityDef.attributes.values {
								if !attrDef.mayYieldEntityReference { continue }
								if attrDef.source != .thisEntity { continue }
//								if attrDef.kind == .derived || attrDef.kind == .derivedRedeclaring { continue }
								guard let attrValue = attrDef.genericValue(for: entity) else { continue }

								let attrYieldingEntities = attrValue.entityReferences
								for attrEntity in attrYieldingEntities {
									if self === attrEntity.complexEntity {
										modelResult.insert(entity)
										break entityLoop
									}
								}
							}//attrDef
						}//entity
					}//complex
					if model.mode == .readOnly {
						usedInValueCache[model] = modelResult
					}
				}

				result.formUnion(modelResult)
			}//model
			return Array(result)
		}
		
		public func usedIn<ENT, R>( as role: KeyPath<ENT,R> ) -> Array<ENT.PRef>
		where ENT: EntityReference & SDAIDualModeReference,
					R:   SDAIGenericType
		{
			var result: Set<ENT> = []

			for model in self.usedInDomain {
				for complex in model.contents.allComplexEntities {
					guard let entity = complex.entityReference(ENT.self),
								!result.contains(entity)
					else { continue }

					let attr = SDAI.GENERIC( entity[keyPath: role] )

					for attrEntity in attr.entityReferences {
						if self === attrEntity.complexEntity {
							result.insert(entity)
							break
						}
					}//attrEntity
				}//complex
			}//model
			return  result.map{ $0.pRef }
		}
		
		public func usedIn<ENT, R>( as role: KeyPath<ENT,R?> ) -> Array<ENT.PRef>
		where ENT: EntityReference & SDAIDualModeReference,
					R:   SDAIGenericType
		{
			var result: Set<ENT> = []

			for model in self.usedInDomain {
				for complex in model.contents.allComplexEntities {
					guard let entity = complex.entityReference(ENT.self),
								!result.contains(entity)
					else { continue }
					guard let attr = SDAI.GENERIC( entity[keyPath: role] ) else { continue }

					for attrEntity in attr.entityReferences {
						if self === attrEntity.complexEntity {
							result.insert(entity)
							break
						}
					}//attrEntity
				}//complex
			}//model
			return result.map{ $0.pRef }
		}

		public func usedIn(as role:String) -> Array<EntityReference>
		{
			var result: Set<EntityReference> = []

			let parentModel = self.owningModel
			let roleSpec = role.split(separator: ".", omittingEmptySubsequences: false)
			guard roleSpec.count == 3 else { return Array(result) }
			guard roleSpec[0] == parentModel.underlyingSchema.name else { return Array(result) }
			guard let entityDef = parentModel.underlyingSchema.entities[String(roleSpec[1])] else { return Array(result) }
			guard let attrType = entityDef.attributes[String(roleSpec[2])] else { return Array(result) }

			for model in self.usedInDomain {
				for complex in model.contents.allComplexEntities {
					guard let entity = complex.entityReference(entityDef.type),
								!result.contains(entity)
					else { continue }

					guard let attr = attrType.genericValue(for: entity) else { continue }

					for attrEntity in attr.entityReferences {
						if self === attrEntity.complexEntity {
							result.insert(entity)
							break
						}
					}//attrEntity
				}//complex
			}//model
			return Array(result)
		}
		
		public var typeMembers: Set<SDAI.STRING> { 
			Set( _partialEntities.values
						.lazy
						.map{ (tuple) -> Set<STRING> in tuple.instance.typeMembers }
						.joined() )
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
				if let result = ltuple.instance.isValueEqualOptionally(to: rtuple.instance, visited: &comppairs) {
					if !result { return false }					
				}
				else { isequal = nil }
			}
			return isequal
		}
		
		//MARK: where rule validation support
		public func validateEntityWhereRules(
			prefix: SDAIPopulationSchema.WhereLabel,
			recording: SDAIPopulationSchema.ValidationRecordingOption
		) -> SDAIPopulationSchema.WhereRuleValidationRecords
		{
			var result: SDAIPopulationSchema.WhereRuleValidationRecords = [:]

			for tuple in _partialEntities.values {
				let etype = type(of: tuple.instance).entityReferenceType
				if let eref = self.entityReference(etype) {
					var peResult = etype.validateWhereRules(instance: eref, prefix: prefix)

					switch recording {
						case .recordFailureOnly:
							peResult = peResult.filter{ (label,result) in result == SDAI.FALSE }

						case .recordAll:
							break
					}

					if !peResult.isEmpty {
						result.merge(peResult) { $0 && $1 }
					}
				}
			}
			return result
		}

	}

}
