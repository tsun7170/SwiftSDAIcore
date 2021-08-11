//
//  SdaiSchemaDefinition.swift
//  SwiftSDAIcore
//
//  Created by Yoshida on 2020/05/16.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAIDictionarySchema {
	
	/// ISO 10303-22 (6.4.1) schema_definition
	/// 
	/// A SchemaDefinition is the representation of an EXPRESS SCHEMA and is the construct upon which SDAI-models and schema instances are based. 
	/// It defines the scope for a collection of entity, type and rule definitions consisting of those definitions found in the current EXPRESS shcema and those definitions that are resolved into the current shcema as the result of the EXPRESS interface specification.
	/// Items from foreign schemas are resolved into the current schema as described in A.1.1.  
	/// # Formal propositions:
	/// UR1: the object identification for a schema shall be unique. 
	public final class SchemaDefinition: SDAI.Object, SdaiFunctionResultCacheController {
		
		//MARK: Attribute definitions:
		
		/// the name of the schema.
		public let name: ExpressId
		
		/// if present, the information object identifier of the schema upon which the SchemaDefinition is based.
		public var identification: InfoObjectId?
		
		/// the entities declared in or resolved into the schema.
		public private(set) var entities: [ExpressId:EntityDefinition] = [:]
		
		/// the global rules declared in or resolved into the schema.
		public private(set) var globalRules: [ExpressId:GlobalRule] = [:]
	
		//public var externalSchema
		
		//MARK: swift language binding
		public init(name: ExpressId, schema: SDAISchema.Type) {
			self.name = name
			self.schema = schema
			super.init()
			SDAISessionSchema.SdaiSession.dataDictionary[self.name] = self
		}
		/// the constants declared in the schema.
		public private(set) var constants: [ExpressId:() -> SDAI.GENERIC] = [:]
		
		public let schema: SDAISchema.Type
		
		public func addEntity(entityDef: EntityDefinition) {
			entityDef.parentSchema = self
			entities[entityDef.name] = entityDef
		}
		
		public func addGlobalRule(name: ExpressId, rule:@escaping SDAI.GlobalRuleSignature) {
			let ruleDef = GlobalRule(name: name, rule: rule, schema: self)
			globalRules[name] = ruleDef
		}
		
		public func addConstant<T:SDAIGenericType>(name:ExpressId, value: @escaping @autoclosure () -> T) {
			let genericValue = {SDAI.GENERIC(value())}	
			constants[name] = genericValue
		}
		
		
		public var uniquenessRules: AnySequence<SDAIDictionarySchema.UniquenessRule> {
			return AnySequence( self.entities.lazy.map{ $1.uniquenessRules.lazy.map { $1 }}.joined() )
		}
		
		//MARK:- function result cache control related
		private var models: Set<SDAI.UnownedReference<SDAIPopulationSchema.SdaiModel>> = []
		
		public func addModel(populated model: SDAIPopulationSchema.SdaiModel) {
			self.models.insert(SDAI.UnownedReference(model))
		}
		
		public func removeModel(populated model: SDAIPopulationSchema.SdaiModel) {
			self.models.remove(SDAI.UnownedReference(model))
		}
		
		
		private var functionCaches: [SDAI.FunctionResultCache] = []
		
		public func register(cache: SDAI.FunctionResultCache) {
			self.functionCaches.append(cache)		
		}
		
		public func resetCaches() {
			for cache in self.functionCaches {
				cache.resetCache()
			}
		}
		
		
		private var _isCachable: Bool? = nil
	
		public var isCachable: Bool {
			if let cachable = _isCachable { return cachable }
			
			for modelRef in self.models {
				if modelRef.object.mode == .readWrite { 
					_isCachable = false
					self.resetCaches()
					return false 
				}
			}
			_isCachable = true
			return true
		}

		public func notifyReadWriteModeChanged() {
			_isCachable = nil
		}
		
	}
	
}

