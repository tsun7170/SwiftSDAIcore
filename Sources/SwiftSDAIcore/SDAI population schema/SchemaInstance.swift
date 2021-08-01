//
//  SchemaInstance.swift
//  
//
//  Created by Yoshida on 2021/03/28.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation


extension SDAIPopulationSchema {
	
	//MARK: - SchemaInstance
	/// ISO 10303-22 (8.4.1)
	/// A SchemaInstance is a logical collection of SdaiModels.
	///  
	/// It is used as the domain for global rule validation, as domain over which references between entity instances in different SdaiModels are supported and as the domain for uniqueness validation.
	///  
	/// A SchemaInstance is based upon one schema. Associating SdaiModels with the SchemaInstance shall be supported when the SdaiModel is based upon the same schema as the SchemaInstance.
	///  
	///  Associating SdaiModels whith the SchemaInstance when the SdaiModel is based upon another schema shall also be supported provided the schema upon which the SdaiModel is based contains constructs declared as domain equivalent with constructs in the schema upon which the SchemaInstance is based.
	///  
	/// Although a SchemaInstance exists in one repository, associating SdaiModels from any repository with the SchameInstance shall be supported. 
	/// # Formal propositions:
	/// UR1: The name shall be unique within the repository containing the schema instance.
	public final class SchemaInstance: SDAI.Object {
		
		//MARK Attribute definitions:
		
		/// the name of the SchemaInstance. The name is case sensitive.
		public let name: STRING
		
		/// the SdaiModels associated with the schema instance.
		public private(set) var associatedModels: SET<SdaiModel> = []
		
		/// the schema upon which the schema instance is based.
		public let nativeSchema: SDAIDictionarySchema.SchemaDefinition
		
		/// the repository within which the schema instance was created.
		public let repository: SDAISessionSchema.SdaiRepository
		
		/// if present, the creation date or date of the most recent add or remove of an SdaiModel from the current schema instance.
		public private(set) var changeDate: SDAISessionSchema.TimeStamp
		
		/// the date of the most recent Validate schema instance operation performed on the current schema instance.
		public private(set) var validationDate: SDAISessionSchema.TimeStamp
		
		/// the result of the most recent Validate schema instance operation performed on the current schema instance.
		public private(set) var validationResult: LOGICAL
		
		/// the level of expression evaluation for validation of the implementation that performed the most recent Validate schema instance operation on the current schema instance (see 13.1.2).
		public let validationLevel: INTEGER = 1

		/// ISO 10303-22 (10.5.2) Create schema instance
		///  
		/// This operation establishes a new schema instance. 
		/// - Parameters:
		///   - repository: The repository in which the schema instance is to be created.
		///   - name: The name of the new schema instance.
		///   - schema: The schema upon which the schema instance shall be based.
		/// - Returns: The newly created schema instance.
		public init(repository: SDAISessionSchema.SdaiRepository, 
								name: STRING, 
								schema: SDAIDictionarySchema.SchemaDefinition) { 
			self.repository = repository
			self.name = name
			self.nativeSchema = schema
			let current = Date()
			self.changeDate = current
			self.validationDate = current
			self.validationResult = SDAI.FALSE
			self.mode = .readWrite
			super.init()
//			self.add(model: SDAIPopulationSchema.SdaiModel.fallBackModel(for: schema))
		}

		
		/// ISO 10303-22 (10.6.3) Add SDAI-model
		///  
		/// This operation adds an SDAI-model to the awr od ASI-moswla that are associated with a schema instance.
		/// 
		/// This enables entity instances in the SDAI-model to reference and be referenced by entity instances in other SDAI-models associated with the schema instance.
		///  
		/// This also adds the entity instances in the SDAI-model to the domain for global and uniqueness rule validation defined by the schema instance.
		/// 
		/// If the SDAI-model is not based upon the same schema as the schema instance but is based upon an external schema, then an entity instance in the SDAI-model shall be considered associated with the schema instance only if its entity type is defined as being domain equivalent with and entity type from the native schema upon which the schema instance is based (see A.2). If domain equivalence is not supported and the SDAI-model being added is based upon an external schema, the FN-NAVL error shall result.         
		@discardableResult
		public func add(model: SdaiModel) -> Bool { 
			guard mode == .readWrite else { return false }
			if model.underlyingSchema != self.nativeSchema { return false }
			
			model.associate(with: self)
			self.associatedModels.insert(model)
			return true
		}
		
		/// ISO 10303-22 (10.6.4) Remove SDAI-model
		///  
		/// This operation removes an SDAI-model from the set of SDAI-models that are associated with a schema instance.
		///  
		/// If the SDAI-model no longer has a schema instance in common with another SDAI-model in the schema instance then all references between those two SDAI-models are invalid (see 10.10.7).    
		/// - Parameter model: The SDAI-model that is to be removed from the schema instance.
		/// - Returns: true indicating the success of the operation.
		public func remove(model: SdaiModel) -> Bool { 
			guard mode == .readWrite else { return false }
			self.associatedModels.remove(model)
			model.dissociate(from: self)
			return true
		}
		
		/// ISO 10303-22 (10.6.5) Validate global rule
		///  
		/// This operation determines whether a global rule defined in a schema is satisfied by the population associated with a schema instance.
		///  
		/// The entity instances included in the validation are all entity instances of the entity types to which the global rule applies in all of the SDAI-models that are associated with the schema instance. Entity instances within SDAI-models based upon an external schema are included in the validation if they are instances of entity types defined to ebe domain equivalent with entity types in the native schema by an instance of EnternalSchema. Entity instances so included shall be treated as instances of the native type as defined in DomainEquivalentType.
		///  
		/// If the external entity type lacks properties required to satisfy the rule then the ED-NVLD error results. References to entity instances in SDAI-models that are not associated with the schema instance shall as treated if they are unset.   
		/// - Parameters:
		///   - globalRule: The global rule to validate.
		///   - recording: mode of validation result recording.
		/// - Returns: the result of global rule validation, including logical value indicating TRUE if Rule is satisfied, FALSE if the rule is not satisfied, and UNKNOWN if the expression evaluates to an indeterminate or UNKNOWN value. The result record also contains a list of where_rule within global rule to which SchemaInstance did not conform.
		public func validate(globalRule: SDAIDictionarySchema.GlobalRule,
												 recording: ValidationRecordingOption = .recordFailureOnly) 
		-> SDAI.GlobalRuleValidationResult {
			var record = globalRule.rule(self.allComplexEntities) // apply rule to all complex entities
			
			switch recording {
			case .recordFailureOnly:
				var reduced:[SDAI.WhereLabel : SDAI.LOGICAL] = [:]
				for (label,result) in record {
					if result == SDAI.FALSE { reduced[label] = result }
				}
				record = reduced
				
			case .recordAll:
				break
			}
			
			let result = record.reduce(SDAI.TRUE) { (result, tuple) in result && tuple.value }
			
			return SDAI.GlobalRuleValidationResult(globalRule: globalRule, 
																						 result: result, 
																						 record: record)
		}
		
		//MARK: (10.6.6)
		public func validate(uniquenessRule: SDAIDictionarySchema.UniquenessRule) 
		-> SDAI.UniquenessRuleValidationResult {
			let entityType = uniquenessRule.parentEntity.type
			var instanceCount = 0
			var unknown = SDAI.TRUE
			let unique = Set<AnyHashable>( self.entityExtent(type: entityType).lazy.compactMap{ 
				guard let tuple = uniquenessRule.rule($0) else { unknown = SDAI.UNKNOWN; return nil }
				instanceCount += 1
				return tuple
			} )
			let uniqueCount = unique.count
			let result = SDAI.LOGICAL(from: uniqueCount == instanceCount) && unknown
			
			return SDAI.UniquenessRuleValidationResult(uniquenessRule: uniquenessRule, 
																								 result: result, 
																								 record: (uniqueCount, instanceCount))
		}
		
		//MARK: swift language binding
		public var mode: SDAISessionSchema.AccessType {
			didSet {
				if mode == .readOnly {
					for model in associatedModels {
						model.mode = .readOnly
					}
				}
				else if mode == .readWrite {
					for model in associatedModels {
						model.contents.resetCache(relatedTo: self)
						model.mode = .readWrite
					}
				}
			}
		}

		public var allComplexEntities: AnySequence<SDAI.ComplexEntity> { 
			return AnySequence( associatedModels.lazy.map{ $0.contents.allComplexEntities }.joined() )
		}
		
		public var instances: AnySequence<SDAIParameterDataSchema.EntityInstance> { 
			return AnySequence( associatedModels.lazy.map{ $0.contents.instances }.joined() )
		}

		public func entityExtent<ENT:SDAIParameterDataSchema.EntityInstance>(type: ENT.Type) -> AnySequence<ENT> {
			return AnySequence( associatedModels.lazy.map{ $0.contents.entityExtent(type:type) }.joined() )
		}

		
		//MARK: swift specific
		public enum ValidationRecordingOption {
			case recordFailureOnly
			case recordAll
		}
		
		public func validateGlobalRules(recording: ValidationRecordingOption = .recordFailureOnly,
																		monitor: ValidationMonitor = ValidationMonitor() ) 
		-> [SDAI.GlobalRuleValidationResult] {
			var globalrec:[SDAI.GlobalRuleValidationResult] = []
			monitor.willValidate(globalRules: AnySequence(self.nativeSchema.globalRules.values))
			
			for globalrule in self.nativeSchema.globalRules.values {
				if monitor.terminateValidation { return globalrec }
				
				let result = self.validate(globalRule: globalrule, recording: recording)
				monitor.didValidateGlobalRule(for: self, result: result)
				
				switch recording {
				case .recordFailureOnly:
					if result.result == SDAI.FALSE { globalrec.append(result) }
				case .recordAll:
					globalrec.append(result)
				}
			}
			return globalrec			
		}
		
		public func validateUniquenessRules(recording: ValidationRecordingOption = .recordFailureOnly,
																				monitor: ValidationMonitor = ValidationMonitor() )
		-> [SDAI.UniquenessRuleValidationResult] {
			var uniquerec: [SDAI.UniquenessRuleValidationResult] = []
			monitor.willValidate(uniquenessRules: AnySequence(self.nativeSchema.uniquenessRules))
			
			for uniquerule in self.nativeSchema.uniquenessRules {
				if monitor.terminateValidation { return uniquerec }
				
				let result = self.validate(uniquenessRule: uniquerule)
				monitor.didValidateUniquenessRule(for: self, result: result)
				
				switch recording {
				case .recordFailureOnly:
					if result.result == SDAI.FALSE { uniquerec.append(result) }
				case .recordAll:
					uniquerec.append(result)
				}
			}
			return uniquerec
		}
		
//		private var validationRound: SDAI.ValidationRound = SDAI.notValidatedYet		
		public func validateWhereRules(recording: ValidationRecordingOption = .recordFailureOnly,
																	 monitor: ValidationMonitor = ValidationMonitor() ) 
		-> SDAI.WhereRuleValidationResult {
//			validationRound += 1
			var record:[SDAI.WhereLabel:SDAI.LOGICAL] = [:]
			monitor.willValidateWhereRules(for: self.allComplexEntities)
			
			for complex in self.allComplexEntities {
				if monitor.terminateValidation { return SDAI.WhereRuleValidationResult(result: SDAI.UNKNOWN, record: record) }
				
				let compResult = complex.validateEntityWhereRules(prefix: "", recording: recording)
				monitor.didValidateWhereRule(for: complex, result: compResult)
				
				record.merge(compResult) { (tuple1:SDAI.LOGICAL, tuple2:SDAI.LOGICAL) ->  SDAI.LOGICAL in
					tuple1 && tuple2
				}
			}
			let result = record.lazy.map{ $1 }.reduce(SDAI.TRUE) { $0 && $1 }
			
			return SDAI.WhereRuleValidationResult(result: result, record: record)
		}
		
		//MARK: (10.6.8)
		public private(set) var globalRuleValidationRecord: [SDAI.GlobalRuleValidationResult]?
		
		public private(set) var uniquenessRuleValidationRecord: [SDAI.UniquenessRuleValidationResult]?
		
		public private(set) var whereRuleValidationRecord: SDAI.WhereRuleValidationResult?
		
		public func validateAllConstraints(recording: ValidationRecordingOption = .recordFailureOnly,
																			 monitor: ValidationMonitor = ValidationMonitor() ) 
		-> SDAI.LOGICAL {
			// global rule check
			globalRuleValidationRecord = validateGlobalRules(recording: recording, monitor: monitor)
			
			// uniqueness rule check
			uniquenessRuleValidationRecord = validateUniquenessRules(recording: recording, monitor: monitor)
			
			// where rule check
			whereRuleValidationRecord = validateWhereRules(recording: recording, monitor: monitor)
			
			// post process
			if monitor.terminateValidation { return SDAI.UNKNOWN }
			var result = SDAI.TRUE
			result = result && globalRuleValidationRecord?.lazy.reduce(SDAI.TRUE) { (result, globalRuleResult) in
				result && globalRuleResult.result
			}
			result = result && uniquenessRuleValidationRecord?.lazy.reduce(SDAI.TRUE) { (result, uniqueRuleResult) in
				result && uniqueRuleResult.result
			}
			result = result && whereRuleValidationRecord?.result
			
			validationDate = Date()
			return result
		}
		
		//MARK: (10.6.9)
		public var isValidationCurrent: Bool { 
			return validationDate > changeDate && 
				globalRuleValidationRecord != nil &&
				uniquenessRuleValidationRecord != nil &&
				whereRuleValidationRecord != nil
		}
		
		//MARK: temporary entity pool related
//		public func drainTemporaryPool() {
//			for model in self.associatedModels {
//				model.drainTemporaryPool()
//			}
//		}
	}
}
