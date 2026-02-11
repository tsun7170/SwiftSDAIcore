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
  /// `PartialComplexEntity` is a specialized subclass of `ComplexEntity` that represents a partial or incomplete complex entity instance within the SDAI data model.
  /// 
  /// This type is primarily used internally to construct entities that are not fully defined or are only partially present in a given context, such as during schema traversal or temporary transformations.
  /// 
  /// - Warning: This class is intended for use by the implementation and should not be instantiated directly by typical users of the SDAI API.
  /// 
  /// ## Characteristics
  /// - Always reports itself as partial via the `isPartial` property.
  /// - Suppresses broadcasting of creation and deletion events (overrides notification methods as no-ops).
  /// - Used for temporary, in-memory complex entities, typically created on demand for intermediate processing.
  /// 
  /// ## Thread Safety
  /// - Marked as `@unchecked Sendable`, indicating that the implementation is designed for concurrent contexts but does not enforce thread safety at compile time.
  /// 
  /// ## See Also
  /// - ``SDAI/ComplexEntity``
  /// - SDAI specification for complex entity handling.
  ///
	public final class PartialComplexEntity: ComplexEntity, @unchecked Sendable
	{
		override fileprivate func broadcastCreated() {}
		
		override fileprivate func broadcastDeleted() {}

		override public var isPartial: Bool { true }
	}
	
	//MARK: - ComplexEntity
  /// `ComplexEntity` represents an instance of a complex entity within the SDAI data model. 
  /// A complex entity in SDAI is composed of multiple partial entities, each corresponding to a participating entity in a complex type definition.
  ///
  /// This class provides mechanisms for accessing the constituent partial entities, entity references, and handling persistence, temporary instances, and caching operations. 
  /// It also includes methods for schema-specific role analysis, usage queries, and where-rule validation, all designed to be thread-safe and efficient for large model populations.
  ///
  /// - Important: This is a base class for complex entity instances and is not intended for direct instantiation except by the SDAI framework.
  ///
  /// ## Characteristics
  /// - Maintains a collection of partial entities that form the complex entity.
  /// - Provides accessors for entity references, including persistent and leaf references.
  /// - Supports creation of both persistent and temporary complex entities, with proper registration in their owning model.
  /// - Offers methods for finding roles, usage (usedIn), and membership queries, respecting schema relationships and associations.
  /// - Implements thread-safe caching for usedIn queries and other expensive computations.
  /// - Adheres to the `SDAI.CacheHolder` protocol for handling schema or domain changes.
  /// - Supports express built-in operations and where-rule validation.
  ///
  /// ## Thread Safety
  /// - Uses a `Mutex` to protect shared mutable state and caches.
  /// - Marked as `@unchecked Sendable`, indicating that it is designed for concurrency but relies on implementation discipline for thread safety.
  ///
  /// ## Usage
  /// Typically constructed internally during model decoding, duplication, or temporary transformations. 
  /// Methods are provided for reading entity state, analyzing schema relationships, and performing queries as needed by the SDAI API.
  ///
  /// ## See Also
  /// - ``SDAI/PartialEntity``
  /// - ``SDAI/PartialComplexEntity``
  /// - SDAI specification for complex entity population and reference handling.
  ///
	public class ComplexEntity:
		SDAI.Object, SDAI.CacheHolder,
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

		//MARK: CustomStringConvertible
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

    //MARK: Initializers
    internal init(
      entities:[PartialEntity],
      model:SDAIPopulationSchema.SdaiModel,
      name:P21Decode.EntityInstanceName,
      repEntityRefType:EntityReference.Type,
      isTemporary: Bool )
    {
      self.representativeEntityRefType = repEntityRefType

      self.owningModel = model
      self.p21name = name
      self.isTemporary = isTemporary

      if !isTemporary {
        guard model.contents.add(complex: self)
        else {
          fatalError("can not create persistent complex entity")
        }
      }

      for pe in entities {
        _partialEntities[type(of: pe).typeIdentity] = (instance:pe, reference:.unknown)
      }

      let _ = self.entityReferences // to fill up _partialEntities[:] to avoid data races
      broadcastCreated()
    }

		/// init for persistent complex entity
		/// - Parameters:
		///   - entities: constituent partial entities
		///   - model: SDAI-Model to own the created complex entity
		///   - name: complex entity identifier
		///
    public convenience init(
			entities:[PartialEntity],
			model:SDAIPopulationSchema.SdaiModel,
			name:P21Decode.EntityInstanceName)
		{
      let pe = entities.last!
      let repERefType  = type(of:pe).entityReferenceType

      self.init(
        entities: entities,
        model: model,
        name: name,
        repEntityRefType: repERefType,
        isTemporary: false)
		}
		
		/// init for temporary complex entity
		/// - Parameter entities: constituent partial entities
		///
		public convenience init(entities:[PartialEntity]) {
			guard let session = SDAISessionSchema.activeSession
			else {
        SDAI.raiseErrorAndTrap(.SS_NOPN, detail: "can not access SDAISessionSchema.activeSession")
			}

			let pe = entities.last!
      let repERefType  = type(of:pe).entityReferenceType

      let schema = type(of: pe).entityDefinition.parentSchema
      let fallback = session.fallBackModel(for: schema)
      let name = fallback.uniqueName

      self.init(
        entities: entities,
        model: fallback,
        name: name,
        repEntityRefType: repERefType,
        isTemporary: true)
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
      let repERefType = original.representativeEntityRefType

      self.init(
        entities: entities,
        model: targetModel,
        name: name,
        repEntityRefType: repERefType,
        isTemporary: false)
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
		
		//MARK: P21 support
		public let p21name: P21Decode.EntityInstanceName

		public let isTemporary: Bool

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
    public var persistentEntityReferences: [GenericPersistentEntityReference] {
      return self.entityReferences.map{ GenericPersistentEntityReference($0) }
    }

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
		
    private let representativeEntityRefType: EntityReference.Type

		public func entityReference<EREF:EntityReference>(
			_ erefType:EREF.Type) -> EREF?
		{
      if erefType == GENERIC_ENTITY.self {
        return self.entityReference(representativeEntityRefType) as? EREF
      }

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
		public var usedInDomain: some Collection<SDAIPopulationSchema.SdaiModel> & Sendable
		{
			let parentModel = self.owningModel
			var domain = Set(parentModel.associatedWith.lazy.flatMap{ $0.associatedModels })
			domain.insert(parentModel)
			return domain
		}
		
		private func findEssentialRoles(
      in entity: SDAI.EntityReference
    ) -> some Collection<SDAIDictionarySchema.AttributeType>
		{
			var roles:[SDAIDictionarySchema.AttributeType] = []
			let entityDef = entity.definition
      let selfPRef = GenericPersistentEntityReference(self)

			for attrDef in entityDef.entityYieldingEssentialAttributes {
				guard let attrYieldingPRefs = attrDef.persistentEntityReferences(for: entity)
        else { continue }

				for attrPRef in attrYieldingPRefs {
					if selfPRef == attrPRef {
						roles.append(attrDef)
						break
					}
				}

			}
			return roles
		}
		
		public func roles(
      domain: some Collection<SDAIPopulationSchema.SdaiModel> & Sendable
    ) -> Set<STRING>
    {
			var result: Set<STRING> = []
			for model in domain {
				for complex in model.contents.allComplexEntities {
					for entity in complex.entityReferences {
						result.formUnion( self.findEssentialRoles(in: entity).lazy.map{ (attrDef) in
							return STRING(from: attrDef.qualifiedAttributeName) 
						} )
					}
				}
			}
			return result
		}
		
		//MARK: SDAI.CacheHolder related
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
    Mutex<[SDAIPopulationSchema.SdaiModel : (level:Int, value:Set<GenericPersistentEntityReference>)]>([:])

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
      domain: some Collection<SDAIPopulationSchema.SdaiModel> & Sendable,
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

          await withTaskGroup(of: Void.self) { taskgroup in
            for _ in 1 ..< session.maxConcurrency {
              if Task.isCancelled { return }

              let chunkSize = max(1, targets.count / session.maxConcurrency)
              let complexes = targets.popLast(chunkSize)
              guard !complexes.isEmpty else { break }
              addTask(complexes: complexes)
            }

            for await _ in taskgroup {
              if Task.isCancelled { return }

              let chunkSize = max(1, targets.count / session.maxConcurrency)
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
                  let _ = complex.usedIn(domain: domain)

                  await Task.yield()
                }
              }
            }
          }//withTaskGroup
        }//addCacheFillingTask
      }//model
    }


		@TaskLocal
		internal static var excluding1:Array<ComplexEntity> = []

		public func usedIn(
      domain: some Collection<SDAIPopulationSchema.SdaiModel> & Sendable
    ) -> Array<GenericPersistentEntityReference>
    {
      guard !Self.excluding1.contains(self),
            !Task.isCancelled
      else { return [] }

      guard let session = SDAISessionSchema.activeSession
      else {
        SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "can not access SDAISessionSchema.activeSession. complex entity = #\(self.p21name), usedIn nesting level = \(Self.excluding1.count)")
        return []
      }


      let result = Self.$excluding1.withValue(Self.excluding1 + [self]) {
        let newLevel = Self.excluding1.count
        if newLevel == 2 {
          Task(name: "SDAI.usedin.kickOffCacheFilling") {
            await self.kickOffCacheFilling(
              excluding: Self.excluding1,
              domain: domain,
              session: session)
          }
        }

        var result: Set<GenericPersistentEntityReference> = []
        if newLevel > session.maxUsedinNesting { return result }

        let selfPRef = GenericPersistentEntityReference(self)

        for model in domain {
          var modelResult: Set<GenericPersistentEntityReference> = []

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

                let entityPRef = GenericPersistentEntityReference(entity)
                if modelResult.contains(entityPRef)
                { continue }

                let entityDef = entity.definition

                for attrDef in entityDef.entityYieldingEssentialAttributes {
//                  if Task.isCancelled { return result }

                  guard let attrYieldingPRefs = attrDef.persistentEntityReferences(for: entity)
                  else { continue }

                  for attrPRef in attrYieldingPRefs {
//                    if Task.isCancelled { return result }
                    if selfPRef == attrPRef {
                      modelResult.insert( entityPRef )
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


    private func entityExtent<ENT>(
      of type: ENT.Type,
      in model: SDAIPopulationSchema.SdaiModel
    ) -> (Array<ENT>)?
    where ENT: EntityReference
    {
      if let (level,cachedPRefs) = self.usedInValueCache.withLock({$0[model]}),
         level == 0
      {
        let extent = cachedPRefs.compactMap {
          $0.complexEntity?.entityReference(type)
        }
        return extent
      }

      guard let entityExtent = model.contents.folders[ENT.entityDefinition]
      else { return nil }

      let extent = entityExtent.instances(of: ENT.self)
      return Array(extent)
    }

		public func usedIn<ENT, R>(
      as role: KeyPath<ENT,R>,
      domain: some Collection<SDAIPopulationSchema.SdaiModel> & Sendable
    ) -> Array<ENT.PRef>
		where ENT: EntityReference & SDAI.DualModeReference,
					R:   SDAI.GenericType
    {
      var result: Set<ENT.PRef> = []

      let selfPRef = GenericPersistentEntityReference(self)

      for model in domain {
        if Task.isCancelled { return Array(result) }

        guard let entityExtent = self.entityExtent(of: ENT.self, in: model)
        else { continue }
        for entity in entityExtent {
          if Task.isCancelled { return Array(result) }

          let entityPRef = entity.pRef
          if result.contains(entityPRef) { continue }

          guard let attr = entity[keyPath: role] as? SDAI.EntityReferenceYielding
          else { continue }

          for attrPRef in attr.persistentEntityReferences {
//            if Task.isCancelled { return Array(result) }

            if selfPRef == attrPRef {
              result.insert(entityPRef)
              break
            }
          }//attrPRef
        }//entity
      }//model
      return Array(result)
    }


		public func usedIn<ENT, R>(
      as role: KeyPath<ENT,R?>,
      domain: some Collection<SDAIPopulationSchema.SdaiModel> & Sendable
    ) -> Array<ENT.PRef>
		where ENT: EntityReference & SDAI.DualModeReference,
					R:   SDAI.GenericType
    {
      var result: Set<ENT.PRef> = []

      let selfPRef = GenericPersistentEntityReference(self)

      for model in domain {
        if Task.isCancelled { return Array(result) }

        guard let entityExtent = self.entityExtent(of: ENT.self, in: model)
        else { continue }
        for entity in entityExtent {
          if Task.isCancelled { return Array(result) }

          let entityPRef = entity.pRef
          if result.contains(entityPRef) { continue }

          guard let attr = entity[keyPath: role] as? SDAI.EntityReferenceYielding
          else { continue }

          for attrPRef in attr.persistentEntityReferences {
//            if Task.isCancelled { return Array(result) }

            if selfPRef == attrPRef {
              result.insert(entityPRef)
              break
            }
          }//attrPRef
        }//entity
      }
      return Array(result)
    }


		public func usedIn(
      as role:String,
      domain: some Collection<SDAIPopulationSchema.SdaiModel> & Sendable
    ) -> Array<GenericPersistentEntityReference>
    {
      let parentModel = self.owningModel
      let roleSpec = role.split(separator: ".", omittingEmptySubsequences: false)

      guard roleSpec.count == 3,
            roleSpec[0] == parentModel.underlyingSchema.name,
            let entityDef = parentModel.underlyingSchema.entities[String(roleSpec[1])],
            let attrType = entityDef.attributes[String(roleSpec[2])],
            attrType.mayYieldEntityReference
      else { return [] }

      var result: Set<GenericPersistentEntityReference> = []

      let selfPRef = GenericPersistentEntityReference(self)

      for model in domain {
        if Task.isCancelled { return Array(result) }

        guard let entityExtent = self.entityExtent(of: entityDef.type, in: model)
        else { continue }

        for entity in entityExtent {
          if Task.isCancelled { return Array(result) }

          let entityPRef = GenericPersistentEntityReference(entity)
          if result.contains(entityPRef) { continue }

          guard let attrYieldingPRefs = attrType.persistentEntityReferences(for: entity)
          else { continue }

          for attrPRef in attrYieldingPRefs {
//            if Task.isCancelled { return Array(result) }

            if selfPRef == attrPRef {
              result.insert(entityPRef)
              break
            }
          }//attrPRef
        }//entity
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
          let prefix2 = prefix + "\(eref)"

          var peResult = etype.validateWhereRules(instance: eref, prefix: prefix2)

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

	}//class
}
