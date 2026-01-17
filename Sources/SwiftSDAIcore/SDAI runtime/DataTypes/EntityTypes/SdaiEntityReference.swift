//
//  SdaiEntityReference.swift
//  
//
//  Created by Yoshida on 2020/10/18.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import Synchronization

//MARK: - SDAI.EntityReferenceType
extension SDAI {
  public protocol EntityReferenceType {
    var complexEntity: SDAI.ComplexEntity {get}
    init?(complex complexEntity: SDAI.ComplexEntity?)
  }
}



//MARK: - SDAI.SimpleEntityType
extension SDAI {
  public protocol SimpleEntityType {
    associatedtype SimplePartialEntity: SDAI.PartialEntity

    init?(_ partial: SimplePartialEntity)
  }
}



//MARK: - SDAI.EntityReference (8.3.1, ISO 10303-11)
extension SDAI {
	public typealias EntityName = SDAIDictionarySchema.ExpressId
	public typealias AttributeName = SDAIDictionarySchema.ExpressId

  /// Represents a reference to an SDAI entity instance within a model's population.
  ///
  /// `EntityReference` is the principal class for referencing and managing
  /// EXPRESS entity instances (as defined in ISO 10303-11 and ISO 10303-22).
  /// It provides functionality for referencing complex entities, managing
  /// persistent and temporary states, cache handling for derived attributes,
  /// and introspection of entity definitions and instance relationships.
  ///
  /// ## Responsibilities
  /// - References a `ComplexEntity` instance and provides access to its model and definition.
  /// - Manages persistent labeling for identification across persistent storage and sessions.
  /// - Provides caching and cache management for derived attribute values.
  /// - Supports referencing and resolving relationships (including inverse attributes) with other entities.
  /// - Enables validation of WHERE rules recursively through entity attributes.
  /// - Supports conversion and initialization from other generic or complex entities.
  /// - Integrates with population and schema models for access and introspection.
  ///
  /// ## Key Properties
  /// - `complexEntity`: The primary complex entity referenced.
  /// - `definition`: The EXPRESS entity definition this reference corresponds to.
  /// - `persistentLabel`: String identifier for persistent storage.
  /// - `entityReferences`: Returns the entity reference(s) represented by this object.
  /// - `cacheController` and cache-related APIs for managing derived attribute values.
  ///
  /// ## Usage
  /// `EntityReference` is typically subclassed for concrete EXPRESS entity types,
  /// and is not intended to be used directly. It underpins the typed entity reference system
  /// and supports generic manipulation of SDAI entity instances.
  ///
  /// ## Conformance
  /// - `SDAI.NamedType`
  /// - `SDAI.EntityReferenceType`
  /// - `SDAI.GenericType`
  /// - `InitializableByComplexEntity`
  /// - `SDAI.EntityReferenceYielding`
  /// - `SDAI.CacheHolder`
  /// - `CustomStringConvertible`
  /// - `@unchecked Sendable`
  ///
  /// ## Standard References
  /// - ISO 10303-11: EXPRESS language
  /// - ISO 10303-22: SDAI interface
	open class EntityReference:
		SDAI.UnownedReference<SDAI.ComplexEntity>,
		SDAI.NamedType, SDAI.EntityReferenceType, SDAI.GenericType,
		InitializableByComplexEntity,
		SDAI.EntityReferenceYielding,
		SDAI.CacheHolder,
		CustomStringConvertible, @unchecked Sendable
	{
		//MARK: SDAI.EntityReferenceType
		public var complexEntity: ComplexEntity {self.object}

    internal var complexReference: ComplexEntityReference {
      ComplexEntityReference(self)
    }

		public required init?(complex complexEntity: ComplexEntity?)
		{
			guard let complexEntity = complexEntity else { return nil }
			super.init(complexEntity)

			if type(of:self) != GENERIC_ENTITY.self {
				if !complexEntity.registerEntityReference(self) { return nil }
			}
		}



		//MARK: CustomStringConvertible
		public var description: String {
			var str = "\(self.definition.name)-> \(self.complexEntity.qualifiedName)"
			if self.complexEntity.isPartial {
				str += "(partial)"
			}
			if self.complexEntity.isTemporary {
				str += "(temporary)" 
			}
			return str
		}
		
		
		//MARK:  (9.4.2, ISO 10303-22)
		public unowned var owningModel: SDAIPopulationSchema.SdaiModel { return self.object.owningModel }

		public var definition: SDAIDictionarySchema.EntityDefinition { return type(of: self).entityDefinition }
		
		open class var entityDefinition: SDAIDictionarySchema.EntityDefinition {
			abstract()
		}

		//MARK:  (9.4.3, ISO 10303-22)
		public var persistentLabel: SDAIParameterDataSchema.StringValue {
			let p21name = self.object.p21name
			return "\(self.owningModel.name)#\(p21name)" 
		}

		//MARK: SdaiCachableSource
		public var isCacheable: Bool {
			let complex = self.complexEntity
			if complex.isTemporary { return false }
	
			let model = self.owningModel
			return model.mode == .readOnly
		}
		
		//MARK: SDAI.GenericType
    public typealias FundamentalType = EntityReference

    public var asFundamentalType: FundamentalType {
      return self
    }

    public required convenience init(fundamental: FundamentalType) {
      //    debugPrint("\(#function): Self:\(Self.self), FundamentalType: \(FundamentalType.self)")
      self.init(complex: fundamental.complexEntity)!
    }

		public typealias Value = ComplexEntity.Value

		public func copy() -> Self { return self }

		public class var typeName: String { self.entityDefinition.qualifiedEntityName }

		public var typeMembers: Set<STRING> { complexEntity.typeMembers }

		public var value: ComplexEntity.Value { complexEntity.value }

		
		public var entityReference: SDAI.EntityReference? { self }
		public var stringValue: SDAI.STRING? {nil}
		public var binaryValue: SDAI.BINARY? {nil}
		public var logicalValue: SDAI.LOGICAL? {nil}
		public var booleanValue: SDAI.BOOLEAN? {nil}
		public var numberValue: SDAI.NUMBER? {nil}
		public var realValue: SDAI.REAL? {nil}
		public var integerValue: SDAI.INTEGER? {nil}
		public var genericEnumValue: SDAI.GenericEnumValue? {nil}

		public var asGenericEntityReference: GENERIC_ENTITY {
			return self
		}

		public func arrayOptionalValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.ARRAY_OPTIONAL<ELEM>? {nil}
		public func arrayValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>? {nil}
		public func listValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.LIST<ELEM>? {nil}
		public func bagValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.BAG<ELEM>? {nil}
		public func setValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.SET<ELEM>? {nil}
		public func enumValue<ENUM:SDAI.EnumerationType>(enumType:ENUM.Type) -> ENUM? {nil}


		//MARK: validation related
		open class func validateWhereRules(
			instance:SDAI.EntityReference?,
			prefix:SDAIPopulationSchema.WhereLabel
		) -> SDAIPopulationSchema.WhereRuleValidationRecords
		{
			var result: SDAIPopulationSchema.WhereRuleValidationRecords = [:]
			guard let instance = instance,
            let session = SDAISessionSchema.activeSession,
            session.validateTemporaryEntities
			else { return result }

			for attrDef in type(of:instance).entityDefinition.entityYieldingEssentialAttributes {
        let attrName = attrDef.name

        guard let attrYieldingPRefs = attrDef.persistentEntityReferences(for: instance)
        else { continue }

        for pref in attrYieldingPRefs {
          guard let tempERef = pref.temporaryEntityReference else { continue }

          let tempERefType = type(of:tempERef)
          let prefix2 = prefix + " ." + attrName + "\\" + tempERef.description

          let attrResult = tempERefType.validateWhereRules(
            instance: tempERef,
            prefix: prefix2)

          result.merge(attrResult) { $0 && $1 }
        }
			}
			return result
		}

		//MARK: SDAI.EntityReferenceYielding
		public final var entityReferences: AnySequence<SDAI.EntityReference> {
			AnySequence( CollectionOfOne(self) )
		}

    public final var persistentEntityReferences: AnySequence<SDAI.GenericPersistentEntityReference> {
      AnySequence( CollectionOfOne(GenericPersistentEntityReference(self)) )
    }

		public final func isHolding( entityReference: SDAI.EntityReference ) -> Bool
		{
			return self == entityReference
		}

		//MARK: EntityReference specific
		open class var partialEntityType: PartialEntity.Type { abstract() }	// abstract

		nonisolated(unsafe)
		internal var retainer: ComplexEntity? = nil // for temporary complex entity lifetime control

		internal func unifyCache( with master:EntityReference )
		{
      self.cacheUpdater = master.cacheUpdater
		}

		//MARK: group reference
		public func GROUP_REF<SUPER:EntityReference & SDAI.DualModeReference>(
			_ super_ref: SUPER.Type
		) -> SUPER.PRef?
		{
			let complex = self.complexEntity
      return complex.entityReference(super_ref)?.pRef
		}

		//MARK: inverse attribute support
		public func referencingEntities<SourceEntity,AttributeValue>(
			for attribute: KeyPath<SourceEntity,AttributeValue>
		) -> some Collection<SourceEntity.PRef>
		where SourceEntity: EntityReference & SDAI.DualModeReference,
					AttributeValue: SDAI.EntityReferenceYielding
		{
			guard let session = SDAISessionSchema.activeSession else {
				SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "can not access SDAISessionSchema.activeSession")
				return []
			}

      let selfPRef = GenericPersistentEntityReference(self)
			let activeInstances = Set(session.activeSchemaInstances)
			let associatedInstances = self.complexEntity.owningModel.associatedWith

			for schemaInstance in associatedInstances {
				guard activeInstances.contains(schemaInstance)
				else { continue }

				let sources = schemaInstance.entityExtent(type: SourceEntity.self)

				let referencing = sources.flatMap{ source in
					let attributeValue = source[keyPath: attribute]

					return attributeValue.persistentEntityReferences.compactMap {
            if $0 == selfPRef { return source.pRef }
            else { return nil }
          }
				}

				if !referencing.isEmpty { return referencing }
			}

			return []
		}


		public func referencingEntities<SourceEntity,AttributeValue>(
			for attribute: KeyPath<SourceEntity,AttributeValue?>
		) -> some Collection<SourceEntity.PRef>
		where SourceEntity: EntityReference & SDAI.DualModeReference,
					AttributeValue: SDAI.EntityReferenceYielding
		{
			guard let session = SDAISessionSchema.activeSession else {
				SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "can not access SDAISessionSchema.activeSession")
				return []
			}

      let selfPRef = GenericPersistentEntityReference(self)
			let activeInstances = Set(session.activeSchemaInstances)
			let associatedInstances = self.complexEntity.owningModel.associatedWith

			for schemaInstance in associatedInstances {
				guard activeInstances.contains(schemaInstance)
				else { continue }

				let sources = schemaInstance.entityExtent(type: SourceEntity.self)

				let referencing = sources.flatMap{ source in
					guard let attributeValue = source[keyPath: attribute]
					else { return Array<SourceEntity.PRef>() }

					return attributeValue.persistentEntityReferences.compactMap{
						if $0 == selfPRef { return source.pRef }
						else { return nil }
					}
				}

				if !referencing.isEmpty { return referencing }
			}

			return []
		}

		public func referencingEntity<SourceEntity,AttributeValue>(
			for attribute: KeyPath<SourceEntity,AttributeValue>
		) -> SourceEntity.PRef?
		where SourceEntity: EntityReference & SDAI.DualModeReference,
					AttributeValue: SDAI.EntityReferenceYielding
		{
			guard let session = SDAISessionSchema.activeSession else {
				SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "can not access SDAISessionSchema.activeSession")
				return nil
			}

      let selfCRef = self.complexReference
			let activeInstances = Set(session.activeSchemaInstances)
			let associatedInstances = self.complexEntity.owningModel.associatedWith

			for schemaInstance in associatedInstances {
				guard activeInstances.contains(schemaInstance)
				else { continue }

				let sources = schemaInstance.entityExtent(type: SourceEntity.self)

				for source in sources {
					let attributeValue = source[keyPath: attribute]
					
					if Set( attributeValue
						.persistentEntityReferences.map{$0.complexReference} )
						.contains(selfCRef)
					{
						return source.pRef
					}
				}
			}

			return nil
		}

		public func referencingEntity<SourceEntity,AttributeValue>(
			for attribute: KeyPath<SourceEntity,AttributeValue?>
		) -> SourceEntity.PRef?
		where SourceEntity: EntityReference & SDAI.DualModeReference,
					AttributeValue: SDAI.EntityReferenceYielding
		{
			guard let session = SDAISessionSchema.activeSession else {
				SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "can not access SDAISessionSchema.activeSession")
				return nil
			}

      let selfCRef = self.complexReference
			let activeInstances = Set(session.activeSchemaInstances)
			let associatedInstances = self.complexEntity.owningModel.associatedWith

			for schemaInstance in associatedInstances {
				guard activeInstances.contains(schemaInstance)
				else { continue }

				let sources = schemaInstance.entityExtent(type: SourceEntity.self)

				for source in sources {
					guard let attributeValue = source[keyPath: attribute]
					else { continue }
					
					if Set( attributeValue
						.persistentEntityReferences.map{$0.complexReference} )
						.contains(selfCRef)
					{
						return source.pRef
					}
				}
			}

			return nil
		}

		//MARK: SDAI.CacheHolder related
		public func notifyApplicationDomainChanged(
			relatedTo schemaInstance: SDAIPopulationSchema.SchemaInstance
		) async
		{
      await self.resetCache()
		}

		public func notifyReadWriteModeChanged(
			sdaiModel: SDAIPopulationSchema.SdaiModel
		)
		{
			//NOOP
		}

    public func terminateCachingTask()
    {
      Task(name: "SDAI.DerivedAttributeCache_updateCanceller") {
        await cacheUpdater.terminateCachingTasks()
      }
    }

    public func toCompleteCachingTask() async
    {
      await cacheUpdater.toCompleteCachingTasks()
    }


		//MARK: derived attribute value caching
    /// Represents a cached value for a derived attribute in an SDAI entity reference.
    ///
    /// `CachedValue` is used to store the result of evaluating a derived attribute,
    /// allowing efficient reuse and avoiding redundant computation. The value is
    /// wrapped in a type-erased, `Sendable` container to support safe concurrency.
    ///
    /// - Important: The underlying value may be any type that conforms to `Sendable`,
    ///   and is typically set and retrieved by the entity's cache management APIs.
    ///
    /// - SeeAlso: `EntityReference.cachedValue(derivedAttributeName:)`
    ///
    /// - Parameters:
    ///   - value: The cached value, type-erased as `any Sendable`. May be `nil` if
    ///     the attribute hasn't been computed or cached yet.
    ///
    /// - Concurrency: `CachedValue` is `Sendable` and can be transported across
    ///   concurrency domains safely.
		public struct CachedValue: Sendable {
			public let value: (any Sendable)?

			fileprivate init(_ value: (some Sendable)?) {
				self.value = value
			}
		}

    private actor CacheUpdater<ENT: EntityReference> {

      private let derivedAttributeCache =
      Mutex<[AttributeName : (value:CachedValue, level:Int)]>([:])

      private var updateTasks: [AttributeName :
                                  (task:Task<Void,Never>,level:Int)] = [:]

      private func addTask(
        for attributeName: AttributeName,
        level: Int,
        operation: @Sendable @escaping ()async->Void ) async
      {
        while let prevTask = updateTasks[attributeName] {
          if prevTask.level <= level { return }
          prevTask.task.cancel()
          await prevTask.task.value
        }

        let task = Task(name: "SDAI.derived_attribute_cache_update")
        {
          await operation()
          self.removeTask(for: attributeName)
        }

        let prevTask = updateTasks.updateValue( (task:task, level:level),
                                                forKey: attributeName)

        assert(prevTask == nil)
      }

      private func removeTask(for attributeName:AttributeName)
      {
        let _ = updateTasks.removeValue(forKey: attributeName)
      }

      func terminateCachingTasks()
      {
        for running in updateTasks.values {
          running.task.cancel()
        }
      }

      func toCompleteCachingTasks() async
      {
        for running in updateTasks.values {
          await running.task.value
        }
      }

      func resetCaches() async
      {
        self.terminateCachingTasks()
        await self.toCompleteCachingTasks()
        derivedAttributeCache.withLock{ $0 = [:] }
      }

      nonisolated func cachedValue(
        for derivedAttributeName: AttributeName
      ) -> (value:CachedValue, level:Int)?
      {
        derivedAttributeCache.withLock{ $0[derivedAttributeName] }
      }

      nonisolated func updateCache(
        for derivedAttributeName: AttributeName,
        value: (some Sendable)?,
        currentLevel: Int )
      {
        if attemptToUpdate() != nil { return }

        Task(name:"SDAI.DerivedAttributeCache_DeferredUpdate--\(ENT.self).\(derivedAttributeName)") {
          let session = SDAISessionSchema.activeSession
          let maxAttempts = session?.maxCacheUpdateAttempts ?? 1000

          await self.addTask(for: derivedAttributeName, level: currentLevel)
          {
            for _ in 1 ... maxAttempts {
              if Task.isCancelled { return }

              if attemptToUpdate() != nil { return }
              await Task.yield()
            }//for

            loggerSDAI.info("\(#function): failed to update derived attribute cache[\(ENT.self).\(derivedAttributeName) @level:\(currentLevel)] for \(maxAttempts) attempts")
          }//addTask
        }//Task

        @Sendable func attemptToUpdate() -> Void?
        {
          let updated:Void? = derivedAttributeCache.withLockIfAvailable
          {
            if let cached = $0[derivedAttributeName],
               cached.level <= currentLevel
            { return }

            $0[derivedAttributeName] = (value:CachedValue(value), level:currentLevel)
          }
          return updated
        }
      }

    }//CacheUpdater


    private var cacheUpdater = CacheUpdater()

		private var cacheController: SDAIDictionarySchema.SchemaDefinition {
			Self.entityDefinition.parentSchema
		}

		public func cachedValue(
			derivedAttributeName: AttributeName
		) -> CachedValue?
    {
      guard let cached = cacheUpdater.cachedValue(for: derivedAttributeName),
            cached.level <= cacheController.approximationLevel
      else { return nil }

      return cached.value
    }
		
		public func updateCache(
			derivedAttributeName: AttributeName,
			value: (some Sendable)?
		)
		{
      guard
        self.cacheController.isCacheable,
        self.complexEntity.owningModel.mode == .readOnly
      else { return }

      cacheUpdater.updateCache(
        for: derivedAttributeName,
        value: value,
        currentLevel: cacheController.approximationLevel)
		}
		
		public func resetCache() async
		{
      await cacheUpdater.resetCaches()
		}

    
		//MARK: InitializableByGenericType
		required public convenience init?<G: SDAI.GenericType>(fromGeneric generic: G?) {
			guard let entityRef = generic?.entityReference else { return nil }
			self.init(complex: entityRef.complexEntity)
		}
		
		public class func convert<G: SDAI.GenericType>(fromGeneric generic: G?) -> Self? {
			guard let generic = generic else { return nil }
			
			if let entityref = generic.entityReference {
				if let sametype = entityref as? Self {
					return sametype
				}
				return self.convert(sibling: entityref)
			}
			return nil
		}

    //MARK: InitializableByComplexEntityType
    public static func convert(fromComplex complex: ComplexEntity?) -> Self?
    {
      complex?.entityReference(self)
    }

		public static func convert<EREF:EntityReference>(sibling source: EREF?) -> Self?
		{
			return source?.complexEntity.entityReference(self)
		}

		public static func convert<PREF>(sibling source: PREF?) -> Self?
		where PREF: SDAI.PersistentReference,
					PREF.ARef: EntityReference
		{
			return self.convert(sibling: source?.optionalARef)
		}

		//MARK: InitializableByP21Parameter
		public static var bareTypeName: String { self.entityDefinition.name }
		
		//MARK: SDAI entity instance operations
		public var allAttributes: AttributeList {
      return AttributeList(
        entity: self,
        attributeDefs: self.definition.attributes.values)
		}

    public var allEntityYieldingEssentialAttributes: AttributeList {
      return AttributeList(
        entity: self,
        attributeDefs: self.definition.entityYieldingEssentialAttributes)
    }
	}
}

