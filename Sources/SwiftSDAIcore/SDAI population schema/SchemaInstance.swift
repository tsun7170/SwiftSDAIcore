//
//  File.swift
//  
//
//  Created by Yoshida on 2021/03/28.
//

import Foundation


extension SDAIPopulationSchema {
	
	//MARK: (8.4.1)(10.6)
	public class SchemaInstance: SDAI.Object {
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
			super.init()
			self.add(model: SDAIPopulationSchema.SdaiModel.fallBackModel(for: schema))
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
		public func add(model: SdaiModel) { 
			model.associatedWith.insert(SDAI.UnownedReference(self)) 
			self.associatedModels.insert(model)
		}
		
		//MARK: (10.6.4)
		public func remove(model: SdaiModel) { 
			self.associatedModels.remove(model)
			model.associatedWith.remove(SDAI.UnownedReference(self))
		}
		
		//MARK: (10.6.5)
		public func validate(globalRule: SDAIDictionarySchema.GlobalRule) -> SDAI.GlobalRuleValidationResult {
			let record = globalRule.rule(self.allComplexEntities)
			let result = record.reduce(SDAI.TRUE) { (result, tuple) in result && tuple.value }
			return SDAI.GlobalRuleValidationResult(globalRule: globalRule, 
																						 result: result, 
																						 record: record)
		}
		
		//MARK: (10.6.6)
		public func validate(uniquenessRule: SDAIDictionarySchema.UniquenessRule) ->SDAI.UniquenessRuleValidationResult {
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
		public func validateWhereRules() -> SDAI.WhereRuleValidationResult {
			var record:[SDAI.EntityReference:[SDAI.WhereLabel:SDAI.LOGICAL]] = [:]
			for complex in self.allComplexEntities {
				let compResult = complex.validateEntityWhereRules(prefix: "#\(complex.p21name)")
				record.merge(compResult) { (tuple1:[SDAI.WhereLabel : SDAI.LOGICAL], tuple2:[SDAI.WhereLabel : SDAI.LOGICAL]) -> [SDAI.WhereLabel : SDAI.LOGICAL] in
					tuple1.merging(tuple2) { $0 && $1 }
				}
			}
			let result = record.lazy.map{ $1.lazy.map{ $1 } }.joined().reduce(SDAI.TRUE) { $0 && $1 }
			return SDAI.WhereRuleValidationResult(result: result, record: record)
		}
		
		//MARK: (10.6.8)
		public private(set) var globalRuleValidationRecord: [SDAIDictionarySchema.GlobalRule:SDAI.GlobalRuleValidationResult]?
		public private(set) var uniquenessRuleValidationRecord: [SDAIDictionarySchema.UniquenessRule:SDAI.UniquenessRuleValidationResult]?
		public private(set) var whereRuleValidationRecord: SDAI.WhereRuleValidationResult?
		
		public func validateAllConstraints() -> SDAI.LOGICAL {
			var globalrec:[SDAIDictionarySchema.GlobalRule:SDAI.GlobalRuleValidationResult] = [:]
			for globalrule in self.nativeSchema.globalRules.values {
				globalrec[globalrule] = self.validate(globalRule: globalrule)
			}
			globalRuleValidationRecord = globalrec
			
			var uniquerec: [SDAIDictionarySchema.UniquenessRule:SDAI.UniquenessRuleValidationResult] = [:]
			for uniquerule in self.nativeSchema.uniquenessRules {
				uniquerec[uniquerule] = self.validate(uniquenessRule: uniquerule)
			}
			uniquenessRuleValidationRecord = uniquerec
			
			whereRuleValidationRecord = self.validateWhereRules()
			
			var result = SDAI.TRUE
			result = result && globalRuleValidationRecord?.lazy.reduce(SDAI.TRUE) { (result, globalRuleResult) in
				result && globalRuleResult.value.result
			}
			result = result && uniquenessRuleValidationRecord?.lazy.reduce(SDAI.TRUE) { (result, uniqueRuleResult) in
				result && uniqueRuleResult.value.result
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
	}
}
