//
//  SdaiComplexEntity.swift
//  
//
//  Created by Yoshida on 2021/05/08.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import Synchronization

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
			case resolvedAsTemporary
			case invalid
		}
    nonisolated(unsafe)
		private var _partialEntities: [
      PartialEntity.TypeIdentity :
			(instance:PartialEntity, reference:EntityReferenceStatus)
		] = [:]

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
		
		/// init for persistent complex entity
		/// - Parameters:
		///   - entities: constituent partial entities
		///   - model: SDAI-Model to own the created complex entity
		///   - name: complex entity identifier
		///
		public init(
			entities:[PartialEntity],
			model:SDAIPopulationSchema.SdaiModel,
			name:P21Decode.EntityInstanceName)
		{
			self.owningModel = model
			self.p21name = name
			if !model.contents.add(complex: self) {
				fatalError("can not create persistent complex entity")
			}

			for pe in entities {
				_partialEntities[type(of: pe).typeIdentity] = (instance:pe, reference:.unknown)	
			}

      let _ = self.entityReferences // to fill up _partialEntities[:] to avoid data races
			broadcastCreated()
		}
		
		/// init for temporary complex entity
		/// - Parameter entities: constituent partial entities
		///
		public init(entities:[PartialEntity]) {
			guard let session = SDAISessionSchema.activeSession
			else {
				SDAI.raiseErrorAndTrap(.SS_NAVL, detail: "SdaiSession object not available as TaskLocal")
			}
			let pe = entities.first!
			let schema = type(of: pe).entityDefinition.parentSchema
			let fallback = session.fallBackModel(for: schema)
			let name = fallback.uniqueName

			self.owningModel = fallback
			self.p21name = name
			self.isTemporary = true

			for pe in entities {
				_partialEntities[type(of: pe).typeIdentity] = (instance:pe, reference:.unknown)
			}

      let _ = self.entityReferences // to fill up _partialEntities[:] to avoid data races
			broadcastCreated()
		}
		
		/// init for SDAIModel duplication
		/// - Parameters:
		///   - original: original complex entity
		///   - targetModel: target SDAIModel for duplication
		///
		internal convenience init(
			from original: ComplexEntity,
			targetModel: SDAIPopulationSchema.SdaiModel)
		{
			assert(!original.isTemporary)

			let entities = original.partialEntities
				.map{ type(of: $0).init(from: $0) }
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
		
		
		public func entityReference<EREF:EntityReference>(
			_ erefType:EREF.Type) -> EREF?
		{
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

					case .unknown,
							.resolvedAsTemporary:
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
		
		/// register a newly created entity reference into the registry
		/// - Parameter eref: entity reference to register
		/// - Returns: true when this is the valid entity reference
		///
		internal func registerEntityReference(
			_ eref: EntityReference) -> Bool
		{
			let typeid = type(of: eref).partialEntityType.typeIdentity
			guard let tuple = _partialEntities[typeid] else { return false }

			if self.isTemporary {
				eref.retainer = self
			}

			switch tuple.reference {
				case .resolved(let registered):
					assert(!self.isTemporary, "internal logic error")
					eref.unifyCache(with: registered)
					return true

				case .resolvedAsTemporary:
					assert(self.isTemporary, "internal logic error")
					return true

				case .invalid:
					return false

				case .unknown:
					if self.isTemporary {
						_partialEntities[typeid] =
						(instance:tuple.instance, reference:.resolvedAsTemporary)
					}
					else {
						_partialEntities[typeid] =
						(instance:tuple.instance, reference:.resolved(eref))
					}
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

      let pce = PartialComplexEntity(entities: partials) // as temporary entity
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
		) async
		{
			self.resetCache(relatedTo: schemaInstance)

			for entity in self.entityReferences {
        await entity.notifyApplicationDomainChanged(relatedTo: schemaInstance)
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

    public func terminateCachingTask()
    {
      for entity in self.entityReferences {
        entity.terminateCachingTask()
      }
    }

    public func toCompleteCachingTask() async
    {
      for entity in self.entityReferences {
        await entity.toCompleteCachingTask()
      }
    }


		//MARK: usedIn function related
    private let usedInValueCache =
    Mutex<[SDAIPopulationSchema.SdaiModel : (level:Int, value:Set<EntityReference>)]>([:])

		private var cacheController: SDAIDictionarySchema.SchemaDefinition {
			self.owningModel.underlyingSchema
		}

		private func resetCache(
			relatedTo schemaInstance: SDAIPopulationSchema.SchemaInstance?)
		{
			if let schemaInstance = schemaInstance {
				for model in schemaInstance.associatedModels {
          usedInValueCache.withLock{$0[model] = nil}
				}
			}
			else {
        usedInValueCache.withLock{ $0 = [:] }
			}
		}



    private func kickOffCacheFilling(
      excluding: Array<ComplexEntity>,
      session: SDAISessionSchema.SdaiSession
    ) async
    {
      let excluding = Set(excluding)
      guard session.runUsedinCacheWarming,
            session.maxConcurrency > 1
      else { return }

      for model in self.usedInDomain {
        await model.addCacheFillingTask(session: session)
        {
          var targets = model.contents.allComplexEntities
            .filter { !excluding.contains($0) }
            .shuffled()

          let chunkSize = max(1, targets.count / session.maxConcurrency)

          await withTaskGroup(of: Void.self) { taskgroup in
            for _ in 1 ..< session.maxConcurrency {
              if Task.isCancelled { return }

              let complexes = targets.popLast(chunkSize)
              guard !complexes.isEmpty else { break }
              addTask(complexes: complexes)
            }

            for await _ in taskgroup {
              if Task.isCancelled { return }
              
              let complexes = targets.popLast(chunkSize)
              guard !complexes.isEmpty else { break }
              addTask(complexes: complexes)
            }

            func addTask(complexes: [ComplexEntity])
            {
              taskgroup.addTask(name: "SDAI.usedIn _\(targets.count)")
              {
                for complex in complexes {
                  if Task.isCancelled { return }
                  let _ = complex.usedIn()
                }
              }
            }
          }//withTaskGroup
        }//addCacheFillingTask
      }//model
    }


		@TaskLocal
		internal static var excluding1:Array<ComplexEntity> = []

		public func usedIn() -> Array<EntityReference>
		{
			guard !Self.excluding1.contains(self),
            !Task.isCancelled
      else { return [] }

      guard let session = SDAISessionSchema.activeSession
      else {
        SDAI.raiseErrorAndContinue(.SS_NAVL, detail: "active session not available. complex entity = #\(self.p21name), usedIn nesting level = \(Self.excluding1.count)")
        return []
      }


			let result = Self.$excluding1.withValue(Self.excluding1 + [self]) {
        let newLevel = Self.excluding1.count
        if newLevel == 2 {
          Task(name: "SDAI.usedin.kickOffCacheFilling") {
            await self.kickOffCacheFilling(
              excluding: Self.excluding1,
              session: session)
          }
        }

				var result: Set<EntityReference> = []
        if newLevel > session.maxUsedinNesting { return result }

				for model in self.usedInDomain {
					var modelResult: Set<EntityReference> = []

          if let (level,cached) = self.usedInValueCache.withLock({$0[model]}),
             level <= newLevel
          {
						modelResult = cached
					}
					else {
						for complex in model.contents.allComplexEntitiesShuffled {
              if Task.isCancelled { return result }
							if Self.excluding1.contains(complex) { continue }

							entityLoop: for entity in complex.entityReferences {
                if Task.isCancelled { return result }
								if modelResult.contains(entity) { continue }

								let entityDef = entity.definition

								for attrDef in entityDef.attributes.values {
                  if Task.isCancelled { return result }

									if !attrDef.mayYieldEntityReference { continue }
									if attrDef.source != .thisEntity { continue }
									guard let attrValue = attrDef.genericValue(for: entity) else { continue }

                  if Task.isCancelled { return result }
									let attrYieldingEntities = attrValue.entityReferences
									for attrEntity in attrYieldingEntities {
                    if Task.isCancelled { return result }
										if self === attrEntity.complexEntity {
											modelResult.insert(entity)
											break entityLoop
										}
									}
								}//attrDef
							}//entity
						}//complex
						if model.mode == .readOnly {
              usedInValueCache.withLock{
                if let (level,_) = $0[model], level <= newLevel { return }
                $0[model] = (level:newLevel, value:modelResult)
              }
						}
					}

					result.formUnion(modelResult)
				}//model
				return result

			}//withValue

			return Array(result)
		}



		public func usedIn<ENT, R>( as role: KeyPath<ENT,R> ) -> Array<ENT.PRef>
		where ENT: EntityReference & SDAIDualModeReference,
					R:   SDAIGenericType
		{
				var result: Set<ENT> = []

				for model in self.usedInDomain {

          guard let entityExtent = model.contents.folders[ENT.entityDefinition] else { continue }
          for entity in entityExtent.instances(of: ENT.self) {
            if result.contains(entity) { continue }

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

          guard let entityExtent = model.contents.folders[ENT.entityDefinition] else { continue }
          for entity in entityExtent.instances(of: ENT.self) {
            if result.contains(entity) { continue }

            guard let attr = SDAI.GENERIC( entity[keyPath: role] )
            else { continue }

						for attrEntity in attr.entityReferences {
							if self === attrEntity.complexEntity {
								result.insert(entity)
								break
							}
						}//attrEntity
					}//complex
			}
			return result.map{ $0.pRef }
		}


		public func usedIn(as role:String) -> Array<EntityReference>
		{
			let parentModel = self.owningModel
			let roleSpec = role.split(separator: ".", omittingEmptySubsequences: false)
			guard roleSpec.count == 3 else { return [] }
			guard roleSpec[0] == parentModel.underlyingSchema.name else { return [] }
			guard let entityDef = parentModel.underlyingSchema.entities[String(roleSpec[1])] else { return [] }
			guard let attrType = entityDef.attributes[String(roleSpec[2])] else { return [] }

				var result: Set<EntityReference> = []

				for model in self.usedInDomain {

          guard let entityExtent = model.contents.folders[entityDef] else { continue }
          for entity in entityExtent.instances {
            if result.contains(entity) { continue }
						
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


		//MARK: typeMembers
		public var typeMembers: Set<SDAI.STRING> {
			Set( _partialEntities.values
						.lazy
						.map{ (tuple) -> Set<STRING> in tuple.instance.typeMembers }
						.joined() )
		}

		//MARK: value related
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
