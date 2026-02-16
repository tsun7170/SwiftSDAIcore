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
    /// The STEP Part 21 (P21) exchange file identifier for this complex entity instance.
    ///
    /// This property holds the unique entity instance name (such as `#123`) as
    /// defined in a STEP P21 file, representing this entity's identifier within
    /// its owning model's exchange context. It is used for serialization,
    /// deserialization, cross-referencing, and stable identity across import/export
    /// operations.
    ///
    /// - Returns: The P21 instance name assigned to this complex entity.
    /// - Note: For persistent entities, this corresponds to a model-unique identifier.
    ///         For temporary or in-memory entities, the value may be generated on demand.
    /// - SeeAlso: [ISO 10303-21: Industrial automation systems and integration—Product data representation and exchange—Part 21: Implementation methods: Clear text encoding of the exchange structure](https://www.iso.org/standard/63141.html)
    /// - SeeAlso: ``SDAI/ComplexEntity/qualifiedName`` for a composite identifier including the owning model context.
		public let p21name: P21Decode.EntityInstanceName

    /// A Boolean property indicating whether this complex entity instance is temporary.
    ///
    /// Temporary complex entities are created for transient or intermediate data processing needs and are
    /// not persisted to the underlying model or database. Such entities are typically used internally
    /// by the SDAI framework for tasks like schema traversal, query evaluation, or on-demand transformations.
    ///
    /// - Returns: `true` if the complex entity is a temporary (in-memory, non-persistent) instance; `false` if it is a persistent entity registered with its owning model.
    ///
    /// - Important: Temporary entities do not participate in model persistence, consistency checking,
    ///   or other permanent storage operations. Their lifetime is limited to the context or computation in which they are created.
    ///
    /// - SeeAlso: ``SDAI/PartialComplexEntity``
    /// - SeeAlso: ``SDAI/ComplexEntity/init(entities:)``
    /// - SeeAlso: SDAI specification for temporary and persistent entity management.
		public let isTemporary: Bool

    /// A composite identifier that uniquely qualifies this complex entity instance within its owning model context.
    ///
    /// This property combines the name of the owning model and the entity's Part 21 (P21) instance name,
    /// providing a stable and human-readable reference for the entity in serialization, debugging, and cross-referencing scenarios.
    /// If the entity is temporary (not persisted to the model), the identifier is suffixed with "(temporary)" to distinguish its transient nature.
    ///
    /// - Returns: A string of the form `<modelName>#<p21name>` for persistent entities,
    ///            or `<modelName>#<p21name>(temporary)` for temporary entities.
    /// - SeeAlso: ``SDAI/ComplexEntity/p21name`` for the raw P21 identifier.
    /// - SeeAlso: [ISO 10303-21: Implementation methods: Clear text encoding of the exchange structure](https://www.iso.org/standard/63141.html)
    /// - Important: The `qualifiedName` is guaranteed to be unique within the context of the owning model.
		public var qualifiedName: String { "\(self.owningModel.name)#\(self.p21name)\(isTemporary ? "(temporary)" : "")" }

		//MARK: - partial entity access
    /// An array containing all constituent partial entities that make up this complex entity instance.
    ///
    /// Each element in the array represents a participating partial entity, corresponding to a specific entity type
    /// within the complex entity’s type composition as defined by the EXPRESS schema. The order of partial entities is
    /// stable and matches the construction order provided during initialization.
    ///
    /// - Returns: An array of ``SDAI/PartialEntity`` instances that together define the full state of this complex entity.
    /// - Note: The collection includes all partial entities, from supertype (most general) to leaf (most specific), as
    ///         determined by the complex entity’s schema definition.
    /// - SeeAlso: ``SDAI/ComplexEntity/partialEntityInstance(_:)`` for typed access to specific partial entities.
    /// - SeeAlso: SDAI specification for complex entity decomposition and population rules.
		public var partialEntities: [PartialEntity] {
			_partialEntities.values.map{ (tuple) in tuple.instance }
		}
		
    /// Returns the partial entity instance of a specified type, if present within this complex entity.
    ///
    /// This method provides type-safe access to a constituent partial entity that matches the requested type.
    /// If the complex entity contains a partial entity of the given type, it is returned as the specified type;
    /// otherwise, the method returns `nil`.
    ///
    /// - Parameter peType: The type of the partial entity to retrieve. This must be a subtype of ``SDAI/PartialEntity``.
    /// - Returns: An instance of the requested partial entity type if present in the complex entity; otherwise, `nil`.
    ///
    /// - Note: Use this accessor when you need to retrieve a specific participating partial entity from the complex entity,
    ///   as defined by the EXPRESS schema's complex type composition.
    /// - SeeAlso: ``SDAI/ComplexEntity/partialEntities`` for an array of all partial entities.
    /// - SeeAlso: ``SDAI/ComplexEntity/resolvePartialEntityInstance(from:)`` for lookup by ordered type identity list.
		public func partialEntityInstance<PENT:PartialEntity>(_ peType:PENT.Type) -> PENT? {
			if let tuple = _partialEntities[peType.typeIdentity] {
				return tuple.instance as? PENT
			}
			return nil
		}
		
    /// Resolves and returns the first partial entity instance matching any of the specified type identities.
    ///
    /// This method accepts an ordered list of type identities corresponding to possible `PartialEntity` types that may participate in this complex entity.
    /// It searches for and returns the first constituent partial entity whose type identity matches an entry in the provided list.
    ///
    /// - Parameter namelist: An array of ``SDAI/PartialEntity/TypeIdentity`` values, each representing a candidate partial entity type to locate within this complex entity.
    ///                       The search is performed in the order specified by this array.
    /// - Returns: The first matching ``SDAI/PartialEntity`` instance found in this complex entity, or `nil` if none are present.
    ///
    /// - Note: This is useful for schema-driven navigation or when resolving a partial entity from a set of possible types,
    ///         particularly in the context of complex type hierarchies or dynamic queries.
    /// - SeeAlso: ``SDAI/ComplexEntity/partialEntityInstance(_:)`` for type-safe access using a single type.
		public func resolvePartialEntityInstance(from namelist:[PartialEntity.TypeIdentity]) -> PartialEntity? {
			for typeIdentity in namelist {
				if let tuple = _partialEntities[typeIdentity] {
					return tuple.instance
				}
			}
			return nil
		}
		
		//MARK: - entity reference access
    /// An array containing persistent entity references corresponding to each partial entity in this complex entity.
    ///
    /// This property transforms the resolved entity references for each partial entity into their persistent (model-stable) representations,
    /// encapsulated as `GenericPersistentEntityReference` values. These references are suitable for persistence, stable identity, and
    /// cross-model or serialization scenarios.
    ///
    /// - Returns: An array of `GenericPersistentEntityReference` objects, each wrapping an entity reference for a constituent partial entity.
    ///            The order of the references matches the order in which the partial entities are stored internally.
    /// - Note: The references are resolved on demand and may involve cache initialization or lookups as required.
    ///
    /// - SeeAlso: ``entityReferences`` for the underlying resolved entity references.
    /// - SeeAlso: ``GenericPersistentEntityReference``
    public var persistentEntityReferences: [GenericPersistentEntityReference] {
      return self.entityReferences.map{ GenericPersistentEntityReference($0) }
    }

    /// An array containing the resolved entity references for each partial entity in this complex entity.
    ///
    /// This property traverses the constituent partial entities of the complex entity and invokes their respective
    /// entity reference constructors to build and collect the corresponding `EntityReference` instances. Each reference
    /// represents a specific participating entity within the complex type instance.
    ///
    /// - Returns: An array of `EntityReference` objects, each corresponding to a partial entity in the complex entity.
    ///            The order of the references matches the order in which the partial entities are stored internally.
    /// - Note: The references are resolved on demand and may trigger initialization or cache-filling steps.
    /// - SeeAlso: ``leafEntityReferences`` for references corresponding to only the leaf (most-derived) entities.
		public var entityReferences: [EntityReference] {
			var result:[EntityReference] = []
			
			for tuple in _partialEntities.values {
				if let eref = self.entityReference(type(of:tuple.instance).entityReferenceType) {
					result.append(eref)
				}
			}
			return result
		}
		
    /// An array containing the entity references corresponding to the leaf (most-derived) participating entities in this complex entity.
    ///
    /// Each element in this array represents an entity reference for a partial entity that is a leaf in the inheritance hierarchy of the complex entity’s
    /// type composition, as determined by the EXPRESS schema. Leaf entities are those that do not have any further subtypes among the set of participating
    /// entities in this complex instance.
    ///
    /// - Returns: An array of ``SDAI/EntityReference`` objects, each corresponding to a leaf-level partial entity in the complex entity.
    /// - Note: This property is useful for determining the most specific (derived) entities present in a complex entity instance. The references are
    ///         resolved based on schema-defined inheritance and may not include all participating entities if some are not leaf nodes in the hierarchy.
    ///
    /// - SeeAlso: ``SDAI/ComplexEntity/entityReferences`` for all participating entities, including supertypes.
    /// - SeeAlso: [ISO 10303-11: EXPRESS—Language Reference Manual](https://www.iso.org/standard/63142.html) for the definition of complex entity population and inheritance.
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

    /// Returns the entity reference of the specified type for this complex entity, if available.
    ///
    /// This method retrieves or constructs an `EntityReference` instance of the requested type (`erefType`) that corresponds
    /// to one of the constituent partial entities comprising this complex entity. If the requested type is `GENERIC_ENTITY.self`,
    /// the method uses the representative entity reference type for this complex entity.
    ///
    /// The entity reference is resolved according to the underlying partial entity's type and cached for future accesses.
    /// If a matching reference has already been resolved and cached, it is returned directly. If the requested reference cannot
    /// be created (such as due to type mismatch or invalid state), the method returns `nil`.
    ///
    /// - Parameter erefType: The type of entity reference to retrieve. Must conform to ``SDAI/EntityReference``.
    /// - Returns: An instance of the requested `EntityReference` type if available, or `nil` if not present or not resolvable.
    ///
    /// - Note: This method is primarily used for schema-driven navigation, dynamic query evaluation, and when specific
    ///         reference semantics are needed for a partial entity within a complex entity instance.
    /// - Warning: If the requested reference type does not correspond to a participating partial entity or cannot be constructed,
    ///            the method returns `nil`. Attempting to retrieve an unsupported or invalid entity reference type may trigger
    ///            internal errors or assertions in debug builds.
    /// - SeeAlso: ``SDAI/ComplexEntity/entityReferences`` for retrieving all resolved entity references.
    /// - SeeAlso: ``SDAI/ComplexEntity/partialEntityInstance(_:)`` for direct partial entity access.
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
    /// A Boolean property indicating whether this complex entity instance represents a partial (incomplete) entity.
    ///
    /// Partial complex entities are typically used internally during schema traversal, intermediate transformations,
    /// or when only a subset of the complete entity definition is present or relevant in a given context.
    /// When `true`, the complex entity does not represent a fully populated instance and may omit certain behaviors,
    /// such as event broadcasting or persistent registration.
    ///
    /// - Returns: `true` if the complex entity is a partial (incomplete or temporary) entity instance; `false` if it is fully defined and persistent.
    /// - Important: Most users of the SDAI API will interact with fully defined complex entities, and should not need to query this property
    ///   except when implementing advanced schema navigation or custom transformation logic.
    /// - SeeAlso: ``SDAI/PartialComplexEntity`` for the specialized type always reporting `isPartial == true`.
    /// - SeeAlso: ``SDAI/ComplexEntity`` for the base class where the default is `false`.
		open var isPartial: Bool { false }
		
    /// Creates and returns an entity reference of the specified type, backed by a temporary partial complex entity.
    ///
    /// This method is intended for advanced schema navigation and transformation scenarios where an entity reference is needed
    /// for a partial "view" or subset of a complex entity, rather than for the full persistent complex entity instance.
    /// It constructs a temporary ``PartialComplexEntity`` composed of the supertypes (as partial entities) required by the given
    /// entity reference type, and returns an entity reference of the requested type if possible.
    ///
    /// The resulting entity reference is valid for the lifetime of the temporary partial complex entity, and is not registered
    /// with the persistent model or subject to model consistency guarantees. This is useful for intermediate processing,
    /// schema traversal, or scenarios where only a subset of the full entity composition is relevant.
    ///
    /// - Parameter erefType: The type of entity reference to create, which must correspond to a derived entity within the complex entity's schema composition.
    /// - Returns: An entity reference of the requested type if all required supertypes are present in the complex entity; otherwise, `nil`.
    ///
    /// - Important: The returned reference is backed by a temporary, in-memory partial complex entity and should not be used for persistent storage or cross-model references.
    ///   Attribute fix-up is performed for the temporary entity to ensure correct reflection of values from the base complex entity.
    ///
    /// - Note: Most users will not need this API except for advanced EXPRESS schema manipulation, view construction, or temporary partial entity scenarios.
    /// - SeeAlso: ``SDAI/PartialComplexEntity``
    /// - SeeAlso: ``SDAI/ComplexEntity/partialEntityInstance(_:)``
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
    /// A collection representing the application domain models associated with this complex entity instance.
    ///
    /// This property computes the set of ``SDAIPopulationSchema.SdaiModel`` instances that constitute the "used-in" domain
    /// for this complex entity. The domain is determined by aggregating all models that are directly or indirectly associated 
    /// with the owning model of this complex entity, as well as including the owning model itself. This is commonly used 
    /// for evaluating used-in queries, determining the scope of reference traversal, and supporting EXPRESS schema navigation.
    ///
    /// - Returns: A collection of ``SDAIPopulationSchema.SdaiModel`` instances associated with this entity, including the owning model.
    /// - Note: The resulting collection may contain models from multiple associated domains, ensuring comprehensive coverage for 
    ///         reference and relationship analysis.
    /// - Concurrency: The collection is `Sendable`, making it suitable for concurrent and asynchronous query operations.
    /// - SeeAlso: ``SDAI/ComplexEntity/usedIn(domain:)`` for performing used-in lookups within this domain.
    /// - SeeAlso: SDAI specification for used-in domain computation and model association handling.
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
		
    /// Computes the set of essential attribute roles associated with this complex entity across a specified application domain.
    ///
    /// This method traverses all complex entities within the provided domain of SDAI models, examining their constituent entity references
    /// to discover essential attribute roles (attributes that yield or reference this complex entity). It aggregates and returns the unique
    /// set of qualified role (attribute) names, as defined by the EXPRESS schema, that are relevant in the scope of the provided models.
    ///
    /// - Parameter domain: A collection of ``SDAIPopulationSchema.SdaiModel`` instances representing the application domain to search for attribute roles.
    ///                    The collection must conform to both `Collection` and `Sendable` for concurrency support.
    /// - Returns: A `Set<STRING>` containing the unique qualified names of all essential roles (attributes) that are associated with this complex entity
    ///            in the given domain.
    ///
    /// - Note: This function is intended for schema analysis, query, and reporting scenarios, and may be used to understand or audit
    ///         the possible attribute relationships and usage patterns of the complex entity within the application domain.
    /// - SeeAlso: ``SDAI/ComplexEntity/usedIn(domain:)`` for discovering usage relationships, and ``SDAI/ComplexEntity/findEssentialRoles(in:)`` for internal role analysis.
    /// - Concurrency: Safe for concurrent invocation as the input domain is required to be `Sendable`.
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
    /// Notifies the complex entity instance that the application domain associated with the specified schema instance has changed.
    ///
    /// This method is invoked when a change occurs in the application domain—such as schema reload, population update,
    /// or model association change—that may affect the caches or internal state maintained by the complex entity or its references.
    /// Upon notification, the complex entity resets any cached values or lookup tables that depend on the provided schema instance,
    /// ensuring that subsequent queries and computations are based on the latest schema information.
    /// 
    /// The method also propagates the notification to all constituent entity references of the complex entity, allowing them
    /// to refresh or invalidate their own caches as needed. This ensures consistency and correctness across the entire object graph,
    /// especially in multi-model or schema-evolving scenarios.
    ///
    /// - Parameter schemaInstance: The `SDAIPopulationSchema.SchemaInstance` related to the domain change event.
    ///                            If `nil`, all caches and schema-dependent state are reset unconditionally.
    ///
    /// - Concurrency: This method is asynchronous and safe for concurrent use. It awaits the completion of notification
    ///                propagation to all entity references.
    ///
    /// - Note: This function is typically invoked by the SDAI framework in response to schema or domain changes, and is not
    ///         intended for direct use by ordinary API consumers.
    ///
    /// - SeeAlso: ``SDAI/ComplexEntity/notifyReadWriteModeChanged(sdaiModel:)``
    /// - SeeAlso: ``SDAI/ComplexEntity/resetCache(relatedTo:)``
		public func notifyApplicationDomainChanged(
			relatedTo schemaInstance: SDAIPopulationSchema.SchemaInstance
		) async
		{
			self.resetCache(relatedTo: schemaInstance)

			for entity in self.entityReferences {
        await entity.notifyApplicationDomainChanged(relatedTo: schemaInstance)
			}
		}

    /// Notifies this complex entity that the read/write mode of the specified SDAI model has changed.
    ///
    /// This method is invoked when the read/write mode (such as transitioning between read-only and read-write states)
    /// of the given SDAI model is updated. It resets any internal caches associated with all schema instances
    /// linked to the provided model, ensuring that stale or invalidated state related to the previous mode is cleared.
    ///
    /// The method also propagates the notification to all constituent entity references of this complex entity,
    /// allowing them to appropriately handle the mode change as needed—ensuring consistency across the entity's
    /// object graph and its references.
    ///
    /// - Parameter sdaiModel: The `SDAIPopulationSchema.SdaiModel` instance whose read/write mode has changed.
    ///
    /// - Note: This function is typically used internally by the SDAI framework in response to model access mode changes,
    ///         and should not generally be called directly by application code.
    ///
    /// - SeeAlso: ``SDAI/ComplexEntity/notifyApplicationDomainChanged(relatedTo:)`` for notifications related to domain or schema changes.
    /// - SeeAlso: ``SDAI/ComplexEntity/resetCache(relatedTo:)`` for details on cache invalidation.
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

    /// Terminates any ongoing caching tasks associated with this complex entity and its constituent entity references.
    ///
    /// This method iterates through all entity references contained within the complex entity and invokes their respective
    /// `terminateCachingTask()` methods, ensuring that any background or asynchronous caching operations are halted.
    ///
    /// - Important: This function is intended for use by the SDAI framework to ensure resource cleanup and to avoid
    ///   orphaned or lingering cache operations, especially when the complex entity is being deinitialized or when
    ///   the application domain is changing.
    ///
    /// - Note: Typical users of the SDAI API do not need to call this method directly. It is primarily used internally
    ///   for concurrency control, cleanup, and in response to schema or model lifecycle events.
    ///
    /// - SeeAlso: ``SDAI/ComplexEntity/toCompleteCachingTask()``
    /// - SeeAlso: ``SDAI/EntityReference/terminateCachingTask()``
    public func terminateCachingTask()
    {
      for entity in self.entityReferences {
        entity.terminateCachingTask()
      }
    }

    /// Awaits the completion of any in-progress caching tasks for this complex entity and its constituent entity references.
    ///
    /// This asynchronous method iterates through all entity references contained within the complex entity and invokes their `toCompleteCachingTask()` methods,
    /// ensuring that each background or asynchronous caching operation associated with the entity or its references is awaited and completed before returning.
    ///
    /// - Important: This function is intended for use by the SDAI framework to guarantee that all pending caching activities are finished, such as during model teardown,
    ///   schema transitions, or before performing operations that require a consistent and fully updated cache state.
    ///
    /// - Note: Typical users of the SDAI API do not need to call this method directly. It is primarily used internally for concurrency control, resource cleanup,
    ///   and ensuring that asynchronous caching work has been completed.
    ///
    /// - Concurrency: This method is safe to call from concurrent contexts and coordinates with any ongoing asynchronous cache operations.
    ///
    /// - SeeAlso: ``SDAI/ComplexEntity/terminateCachingTask()`` for forcefully terminating caching tasks without waiting for their completion.
    /// - SeeAlso: ``SDAI/EntityReference/toCompleteCachingTask()`` for the per-entity reference completion method.
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
