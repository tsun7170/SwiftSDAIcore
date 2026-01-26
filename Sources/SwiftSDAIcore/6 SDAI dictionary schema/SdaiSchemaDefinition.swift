//
//  SdaiSchemaDefinition.swift
//  SwiftSDAIcore
//
//  Created by Yoshida on 2020/05/16.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import Synchronization

extension SDAIDictionarySchema {
	
	/// ISO 10303-22 (6.4.1) schema_definition
	/// 
	/// A SchemaDefinition is the representation of an EXPRESS SCHEMA and is the construct upon which SDAI-models and schema instances are based. 
	/// It defines the scope for a collection of entity, type and rule definitions consisting of those definitions found in the current EXPRESS schema and those definitions that are resolved into the current schema as the result of the EXPRESS interface specification.
	/// Items from foreign schemas are resolved into the current schema as described in A.1.1.  
	/// # Formal propositions:
	/// UR1: the object identification for a schema shall be unique.
	///
	public final class SchemaDefinition:  SDAI.Object,
																				SDAI.FunctionResultCacheController,
																				SDAI.CacheHolder,
																				Sendable
  {

    //MARK: Attribute definitions:

    /// the name of the schema.
    public let name: ExpressId

    /// if present, the information object identifier of the schema upon which the SchemaDefinition is based.
    public let identification: InfoObjectId?

    /// the entities declared in or resolved into the schema.
    ///
    public let entities: [ExpressId:EntityDefinition]

    /// the global rules declared in or resolved into the schema.
    public let globalRules: [ExpressId:GlobalRule]

    //public var externalSchema

    //MARK: SDAI operations

    //MARK: swift language binding
    fileprivate init(byFreezing prototype: Prototype) {
      self.name = prototype.name
      self.schema = prototype.schema
      self.identification = prototype.identification

      self.entities = prototype.entities
      self.globalRules = prototype.globalRules
      self.constants = prototype.constants

      self.fixupParentSchemaReferences()
    }

    private func fixupParentSchemaReferences() {
      for entDef in self.entities.values {
        entDef.fixup(parentSchema: self)
      }
      for gRule in self.globalRules.values {
        gRule.fixup(parentSchema: self)
      }
    }

    /// the constants declared in the schema.
    public let constants: [ExpressId: @Sendable () -> SDAI.GENERIC]

    public let schema: SDAI.SchemaType.Type


    public var uniquenessRules: some Collection<SDAIDictionarySchema.UniquenessRule> {
      return self.entities.lazy.map{ $1.uniquenessRules.lazy.map { $1 }}.joined()
    }

    //MARK: prototype for instance construction
    public class Prototype {
      internal let name: ExpressId
      internal let schema: SDAI.SchemaType.Type
      internal var identification: InfoObjectId?
      internal private(set) var entities: [ExpressId:EntityDefinition] = [:]
      internal private(set) var globalRules: [ExpressId:GlobalRule] = [:]
      internal private(set) var constants: [ExpressId:@Sendable () -> SDAI.GENERIC] = [:]

      public init(name: ExpressId, schema: SDAI.SchemaType.Type) {
        self.name = name
        self.schema = schema
      }

      public func freeze() -> SchemaDefinition {
        let schemaDef = SchemaDefinition(byFreezing: self)
        return schemaDef
      }

      public func addEntity(entityDef: EntityDefinition)
      {
        entities[entityDef.name] = entityDef
      }

      public func addGlobalRule(
        name: ExpressId,
        rule: @escaping SDAIPopulationSchema.GlobalRuleSignature)
      {
        let ruleDef = GlobalRule(name: name, rule: rule)
        globalRules[name] = ruleDef
      }

      public func addConstant<T:SDAI.GenericType>(
        name:ExpressId,
        value: @Sendable @escaping @autoclosure () -> T )
      {
        let genericValue = { @Sendable in SDAI.GENERIC(value()) }
        constants[name] = genericValue
      }

    }//class


    //MARK: - function result cache control related

    private let functionCaches = Mutex<[SDAI.FunctionResultCache]>([])

    public func register(cache: SDAI.FunctionResultCache) {
      self.functionCaches.withLock{ $0.append(cache) }
    }

    public func resetCaches() async {
      for cache in self.functionCaches.withLock({$0}) {
        await cache.resetCache()
      }

      await SDAI.sessionFunctionResultCacheController.resetCaches()
    }


    private let _isCacheable = Mutex<Bool?>(nil)

    public var isCacheable: Bool {
      guard let session = SDAISessionSchema.activeSession
      else {
        SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "can not access SDAISessionSchema.activeSession")
        return false
      }

      if let cacheable = _isCacheable.withLock({ $0 }) { return cacheable }

      for modelInfo in session.activeModelInfos {
        guard modelInfo.instance.underlyingSchema == self else { continue }

        if modelInfo.mode == .readWrite {
          _isCacheable.withLock{ $0 = false }
          Task(name:"SDAI.FunctionResultCache_resetter") {
            await self.resetCaches()
          }
          return false
        }
      }

      _isCacheable.withLock{ $0 = true }
      return true
    }

    public var approximationLevel: Int {
      let level = SDAI.ComplexEntity.excluding1.count
      return level
    }

    public func notifyReadWriteModeChanged(
      sdaiModel: SDAIPopulationSchema.SdaiModel
    )
    {
      _isCacheable.withLock{ $0 = nil }
    }

    public func notifyApplicationDomainChanged(
      relatedTo schemaInstance: SDAIPopulationSchema.SchemaInstance
    )
    {
      _isCacheable.withLock{ $0 = nil }
    }

    public func terminateCachingTask()
    {
      Task(name:"SDAI.FunctionResultCache_updateCanceller") {
        for cache in self.functionCaches.withLock({$0}) {
          await cache.terminateCachingTasks()
        }
      }
    }

    public func toCompleteCachingTask() async
    {
      for cache in self.functionCaches.withLock({$0}) {
        await cache.toCompleteCachingTasks()
      }
    }

  }//class
}//extension

