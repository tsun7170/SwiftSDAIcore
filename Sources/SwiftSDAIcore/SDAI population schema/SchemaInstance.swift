//
//  SchemaInstance.swift
//  
//
//  Created by Yoshida on 2021/03/28.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation


extension SDAIPopulationSchema {
	
	//MARK: (8.4.1)(10.6)
	public final class SchemaInstance: SDAI.Object {
		//MARK: (10.5.2)
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
		
		//MARK: (10.6.1)
//		deinit {
//		}
		
		public let name: STRING	// (10.6.2)
		public private(set) var associatedModels: SET<SdaiModel> = []
		public let nativeSchema: SDAIDictionarySchema.SchemaDefinition
		public let repository: SDAISessionSchema.SdaiRepository
		public private(set) var changeDate: SDAISessionSchema.TimeStamp
		public private(set) var validationDate: SDAISessionSchema.TimeStamp
		public private(set) var validationResult: LOGICAL
		public let validationLevel: INTEGER = 1
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
					}
				}
			}
		}
		
		//MARK: swift binding support
		public var allComplexEntities: AnySequence<SDAI.ComplexEntity> { 
			return AnySequence( associatedModels.lazy.map{ $0.contents.allComplexEntities }.joined() )
		}
		
		public var instances: AnySequence<SDAIParameterDataSchema.EntityInstance> { 
			return AnySequence( associatedModels.lazy.map{ $0.contents.instances }.joined() )
		}

		public func entityExtent<ENT:SDAIParameterDataSchema.EntityInstance>(type: ENT.Type) -> AnySequence<ENT> {
			return AnySequence( associatedModels.lazy.map{ $0.contents.entityExtent(type:type) }.joined() )
		}

		
		//MARK: (10.6.3)
		@discardableResult
		public func add(model: SdaiModel) -> Bool { 
			guard mode == .readWrite else { return false }
			if model.underlyingSchema != self.nativeSchema { return false }
			
			model.associate(with: self)
			self.associatedModels.insert(model)
			return true
		}
		
		//MARK: (10.6.4)
		public func remove(model: SdaiModel) -> Bool { 
			guard mode == .readWrite else { return false }
			self.associatedModels.remove(model)
			model.dissociate(from: self)
			return true
		}
		
		//MARK: (10.6.5)
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
				
				let compResult = complex.validateEntityWhereRules(prefix: complex.qualifiedName, recording: recording)
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
		public func drainTemporaryPool() {
			for model in self.associatedModels {
				model.drainTemporaryPool()
			}
		}
	}
}
