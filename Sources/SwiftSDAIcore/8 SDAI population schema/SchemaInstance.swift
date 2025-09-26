//
//  SchemaInstance.swift
//  
//
//  Created by Yoshida on 2021/03/28.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import Synchronization


extension SDAIPopulationSchema {
	
	//MARK: - SchemaInstance
	/// ISO 10303-22 (8.4.1)
	/// A SchemaInstance is a logical collection of SdaiModels.
	///  
	/// It is used as the domain for global rule validation, as domain over which references between entity instances in different SdaiModels are supported and as the domain for uniqueness validation.
	///  
	/// A SchemaInstance is based upon one schema. Associating SdaiModels with the SchemaInstance shall be supported when the SdaiModel is based upon the same schema as the SchemaInstance.
	///  
	///  Associating SdaiModels with the SchemaInstance when the SdaiModel is based upon another schema shall also be supported provided the schema upon which the SdaiModel is based contains constructs declared as domain equivalent with constructs in the schema upon which the SchemaInstance is based.
	///
	/// Although a SchemaInstance exists in one repository, associating SdaiModels from any repository with the SchemaInstance shall be supported.
	/// # Formal propositions:
	/// UR1: The name shall be unique within the repository containing the schema instance.
	///
	public final class SchemaInstance: SDAI.Object, Sendable
	{

		//MARK: Attribute definitions:

		/// the name of the SchemaInstance. The name is case sensitive.
		public internal(set) var name: STRING {
			get {
				_name.withLock{ $0 }
			}
			set {
				_name.withLock{ $0 = newValue }
			}
		}
		private let _name = Mutex<STRING>("")

		/// the SdaiModels associated with the schema instance.
		public var associatedModels: some Collection<SdaiModel> {
			get {
				var result: [SdaiModel] = []
				guard let session = SDAISessionSchema.activeSession
				else { return result }

				for modelID in self.associatedModelIDs.withLock({$0}) {
					if let model = session.findAndActivateSdaiModel(modelID: modelID) {
						result.append(model)
					}
				}
				return result
			}
		}
		internal let associatedModelIDs = Mutex<Set<SdaiModel.SDAIModelID>>([])

		internal func isAssociatedWith(
			modelWithID modelID: SdaiModel.SDAIModelID
		) -> Bool
		{
			self.associatedModelIDs.withLock{ $0.contains(modelID) }
		}

		internal func associatedModel(
			withID modelID: SdaiModel.SDAIModelID
		) -> SdaiModel?
		{
			guard self.isAssociatedWith(modelWithID: modelID),
						let session = SDAISessionSchema.activeSession
			else { return nil }
			
			let model = session.findAndActivateSdaiModel(modelID: modelID)
			return model
		}

		/// the schema upon which the schema instance is based.
		public let nativeSchema: SDAIDictionarySchema.SchemaDefinition
		
		/// the repository within which the schema instance was created.
		public let repository: SDAISessionSchema.SdaiRepository
		
		/// if present, the creation date or date of the most recent add or remove of an SdaiModel from the current schema instance.
		public var changeDate: SDAISessionSchema.TimeStamp {
			self._changeDate.withLock{ $0 }
		}
		private let _changeDate = Mutex<SDAISessionSchema.TimeStamp>(Date())

		internal func updateChangeDate() {
			self._changeDate.withLock{ $0 = Date() }
		}

		/// the date of the most recent Validate schema instance operation performed on the current schema instance.
		public var validationDate: SDAISessionSchema.TimeStamp {
			self._validationDate.withLock{ $0 }
		}
		private let _validationDate = Mutex<SDAISessionSchema.TimeStamp>(Date())

		/// the result of the most recent Validate schema instance operation performed on the current schema instance.
		public var validationResult: LOGICAL { self.currentValidationResult }

		/// the level of expression evaluation for validation of the implementation that performed the most recent Validate schema instance operation on the current schema instance (see 13.1.2).
		public let validationLevel: INTEGER





		//MARK: swift language binding
		internal typealias SchemaInstanceID = UUID

		internal let schemaInstanceID = SchemaInstanceID()

		public var globalRuleValidationRecord: [GlobalRuleValidationResult]? {
			self._globalRuleValidationRecord.withLock{ $0 }
		}
		private let _globalRuleValidationRecord = Mutex<[GlobalRuleValidationResult]?>(nil)

		public var uniquenessRuleValidationRecord: [UniquenessRuleValidationResult]? {
			self._uniquenessRuleValidationRecord.withLock{ $0 }
		}
		private let _uniquenessRuleValidationRecord = Mutex<[UniquenessRuleValidationResult]?>(nil)

		public var whereRuleValidationRecord: WhereRuleValidationResult? {
			self._whereRuleValidationRecord.withLock{ $0 }
		}
		private let _whereRuleValidationRecord = Mutex<WhereRuleValidationResult?>(nil)

		public var instanceReferenceDomainValidationRecord: InstanceReferenceDomainValidationResult? {
			self._instanceReferenceDomainValidationRecord.withLock{ $0 }
		}
		private let _instanceReferenceDomainValidationRecord = Mutex<InstanceReferenceDomainValidationResult?>(nil)

		internal init(
			repository: SDAISessionSchema.SdaiRepository,
			name: STRING,
			schema: SDAIDictionarySchema.SchemaDefinition,
			session: SDAISessionSchema.SdaiSession
		)
		{
			self.repository = repository
			self._name.withLock{ $0 = name }
			self.nativeSchema = schema
			let current = Date()
			self._changeDate.withLock{ $0 = current }
			self._validationDate.withLock{ $0 = current }
			self.validationLevel = session.sdaiImplementation.expressionLevel

			self.associate(
				with: session.fallBackModel(for: schema))
		}

		internal func teardown()
		{
			for model in self.associatedModels {
//				model.notifyApplicationDomainChanged(relatedTo: self)
				self.dissociate(from: model)
			}
		}

		private init(from original: SchemaInstance) {
			self.repository = original.repository
			self._name.withLock{ $0 = original.name }
			self.associatedModelIDs.withLock{ $0 = original.associatedModelIDs.withLock{$0} }
			self.nativeSchema = original.nativeSchema
			self._changeDate.withLock{ $0 = original.changeDate }
			self._validationDate.withLock{ $0 = original.validationDate }
			self.validationLevel = original.validationLevel

			self._globalRuleValidationRecord.withLock{ $0 = original.globalRuleValidationRecord }
			self._uniquenessRuleValidationRecord.withLock{ $0 = original.uniquenessRuleValidationRecord }
			self._whereRuleValidationRecord.withLock{ $0 = original.whereRuleValidationRecord }
			self._instanceReferenceDomainValidationRecord.withLock{ $0 = original.instanceReferenceDomainValidationRecord }

		}

		internal func clone() -> SchemaInstance {
			let cloned = Self.init(from: self)
			return cloned
		}


		internal func associate(with model: SdaiModel) {
			self.associatedModelIDs.withLock{ $0.insert(model.modelID); return }

//			for model in associatedModels {
//				model.notifyApplicationDomainChanged(relatedTo: self)
//			}
		}

		internal func dissociate(from model: SdaiModel) {
			self.associatedModelIDs.withLock{ $0.remove(model.modelID); return }

//			for model in associatedModels {
//				model.notifyApplicationDomainChanged(relatedTo: self)
//			}
		}

		public var allComplexEntities: some Collection<SDAI.ComplexEntity> {
			get {
				return associatedModels.lazy
					.map{ $0.contents.allComplexEntities }
					.joined()
			}
		}
		
		public var applicationInstances: some Collection<SDAIParameterDataSchema.ApplicationInstance> {
			get {
				return associatedModels.lazy
					.map{ $0.contents.instances }
					.joined()
			}
		}

		public func entityExtent<ENT>(
			type: ENT.Type
//		) -> some Collection<ENT>
		) -> some Sequence<ENT>
		where ENT:SDAIParameterDataSchema.ApplicationInstance
		{
			let result = associatedModels.lazy
				.map{ $0.contents.entityExtent(type:type) }
				.joined()
			return result
		}

		//MARK: - validation related

		internal func resetValidationRecords() {
			self._globalRuleValidationRecord.withLock{ $0 = nil}
			self._uniquenessRuleValidationRecord.withLock{ $0 = nil}
			self._whereRuleValidationRecord.withLock{ $0 = nil}
			self._instanceReferenceDomainValidationRecord.withLock{ $0 = nil}

			self._validationDate.withLock{ $0 = Date() }
		}


		internal var currentValidationResult: SDAI.LOGICAL {
			var result = SDAI.TRUE

			result = result && globalRuleValidationRecord?
				.reduce(SDAI.TRUE) { (result, globalRuleResult) in
				result && globalRuleResult.result
			}

			result = result && uniquenessRuleValidationRecord?
				.reduce(SDAI.TRUE) { (result, uniqueRuleResult) in
				result && uniqueRuleResult.result
			}

			result = result && whereRuleValidationRecord?.result

			result = result && instanceReferenceDomainValidationRecord?.result

			return result
		}


		//MARK: instance reference domain validation
		internal func instanceReferenceDomainNonConformances(
			entity: SDAIParameterDataSchema.ApplicationInstance
		) -> (result:SDAI.LOGICAL, records:[InstanceReferenceDomainValidationRecord])
		{
			var result = SDAI.TRUE

			let nonConf: [InstanceReferenceDomainValidationRecord] =
			entity.allAttributes.attributes.compactMap {
				let attrDef = $0.definition
				let attrVal = $0.value
				guard attrDef.mayYieldEntityReference else { return nil }
				guard let val = attrVal else {
					if result == SDAI.TRUE { result = SDAI.UNKNOWN }
					return (attrDef, attrVal, SDAI.UNKNOWN)
				}

				if let entityRef = val.entityReference {
					let modelRef = entityRef.owningModel.modelID
					if self.isAssociatedWith(modelWithID: modelRef) { return nil }
					result = SDAI.FALSE
					return (attrDef, attrVal, SDAI.FALSE)
				}

				for entityRef in val.entityReferences {
					let modelRef = entityRef.owningModel.modelID
					if !self.isAssociatedWith(modelWithID: modelRef) {
						result = SDAI.FALSE
						return (attrDef, attrVal, SDAI.FALSE)
					}
				}
				return nil
			}

			return (result,nonConf)
		}

		internal func validateAllInstanceReferenceDomain(
			recording option: ValidationRecordingOption,
			monitor: ValidationMonitor
		) -> InstanceReferenceDomainValidationResult
		{
			var overallResult = SDAI.TRUE
			var nonConfs:[InstanceReferenceDomainValidationRecord] = []

			let applicationInstances = self.applicationInstances
			monitor.willValidateInstanceReferenceDomain(for: applicationInstances)

			for entity in applicationInstances {
				if monitor.terminateValidation {
					return InstanceReferenceDomainValidationResult(
						result: SDAI.UNKNOWN, record: nonConfs) }

				let (result,nonconf) =
				self.instanceReferenceDomainNonConformances(entity: entity)
				monitor.didValidateInstanceReferenceDomain(
					for: entity,
					result: InstanceReferenceDomainValidationResult(result: result, record: nonconf))

				nonConfs.append(contentsOf: nonconf)
				overallResult = overallResult && result
			}

			return InstanceReferenceDomainValidationResult(
				result: overallResult,
				record: nonConfs)
		}

		internal func performValidateAllInstanceReferenceDomain(
			recording option: ValidationRecordingOption,
			monitor: ValidationMonitor
		)
		{
			let result = self.validateAllInstanceReferenceDomain(
				recording: option, monitor: monitor)

			guard !monitor.terminateValidation else { return }
			self._instanceReferenceDomainValidationRecord.withLock{ $0 = result }
			self._validationDate.withLock{ $0 = Date() }
		}


//MARK: global rule validation
		internal func validate(
			globalRule rule: SDAIDictionarySchema.GlobalRule,
			recording option: ValidationRecordingOption
		) -> GlobalRuleValidationResult
		{
			let allComplexEntities = self.allComplexEntities

			var validationRecords = rule.ruleBody(AnySequence(allComplexEntities)) // apply rule to all complex entities within the schema instance

			switch option {
				case .recordFailureOnly:
					validationRecords = validationRecords.filter { $0.value == SDAI.FALSE }

				case .recordAll:
					break
			}

			let overallResult = validationRecords.reduce(SDAI.TRUE) { (result,tuple) in
				result && tuple.value }

			return SDAIPopulationSchema.GlobalRuleValidationResult(
				globalRule: rule,
				result: overallResult,
				record: validationRecords)
		}

		internal func validateGlobalRules(
			recording: ValidationRecordingOption,
			monitor: ValidationMonitor
		) -> [GlobalRuleValidationResult]
		{
			var globalRec:[GlobalRuleValidationResult] = []
			monitor.willValidate(globalRules: self.nativeSchema.globalRules.values)
			
			for globalRule in self.nativeSchema.globalRules.values {
				if monitor.terminateValidation { return globalRec }
				
				let result = self.validate(globalRule: globalRule, recording: recording)
				monitor.didValidateGlobalRule(for: self, result: result)
				
				switch recording {
				case .recordFailureOnly:
					if result.result == SDAI.FALSE { globalRec.append(result) }
				case .recordAll:
					globalRec.append(result)
				}
			}
			return globalRec			
		}

		internal func performValidateGlobalRules(
			recording option: ValidationRecordingOption,
			monitor: ValidationMonitor
		)
		{
			let result = self.validateGlobalRules(recording: option, monitor: monitor)

			guard !monitor.terminateValidation else { return }
			self._globalRuleValidationRecord.withLock{ $0 = result }
			self._validationDate.withLock{ $0 = Date() }
		}


//MARK: uniqueness rule validation
		internal func validate(
			uniquenessRule rule: SDAIDictionarySchema.UniquenessRule
		) -> UniquenessRuleValidationResult
		{
			let entityType = rule.parentEntity.type
			var instanceCount = 0
			var unknown = SDAI.TRUE

			let entityExtent = self.entityExtent(type: entityType)

			let uniqueCombinations =
			Set<AnyHashable>(
				entityExtent.lazy.compactMap { entity in
					guard let attrCombination = rule.ruleBody(entity)
					else { unknown = SDAI.UNKNOWN; return nil }

					instanceCount += 1
					return attrCombination
				}
			)

			let uniqueCount = uniqueCombinations.count
			let overallResult = SDAI.LOGICAL(from: uniqueCount == instanceCount) && unknown

			return UniquenessRuleValidationResult(
				uniquenessRule: rule,
				result: overallResult,
				record: (uniqueCount, instanceCount))
//			fatalError()
		}

		internal func validateUniquenessRules(
			recording: ValidationRecordingOption,
			monitor: ValidationMonitor
		) -> [UniquenessRuleValidationResult]
		{
			var uniqueRec: [UniquenessRuleValidationResult] = []
			monitor.willValidate(uniquenessRules: self.nativeSchema.uniquenessRules)
			
			for uniqueRule in self.nativeSchema.uniquenessRules {
				if monitor.terminateValidation { return uniqueRec }
				
				let result = self.validate(uniquenessRule: uniqueRule)
				monitor.didValidateUniquenessRule(for: self, result: result)
				
				switch recording {
				case .recordFailureOnly:
					if result.result == SDAI.FALSE { uniqueRec.append(result) }
				case .recordAll:
					uniqueRec.append(result)
				}
			}
			return uniqueRec
		}

		internal func performValidateUniquenessRules(
			recording option: ValidationRecordingOption,
			monitor: ValidationMonitor
		)
		{
			let result = self.validateUniquenessRules(
				recording: option, monitor: monitor)

			guard !monitor.terminateValidation else { return }
			self._uniquenessRuleValidationRecord.withLock{ $0 = result }
			self._validationDate.withLock{ $0 = Date() }
		}

		//MARK: where rule validation
		internal func validateAllWhereRules(
			recording option: ValidationRecordingOption,
			monitor: ValidationMonitor
		) -> WhereRuleValidationResult
		{
			var record: WhereRuleValidationRecords = [:]

			let allComplexEntities = self.allComplexEntities

			monitor.willValidateWhereRules(for: allComplexEntities)
			
			for complex in allComplexEntities {
				if monitor.terminateValidation { return WhereRuleValidationResult(result: SDAI.UNKNOWN, record: record) }
				
				let compResult = complex.validateEntityWhereRules(prefix: "", recording: option)
				monitor.didValidateWhereRule(for: complex, result: compResult)
				
				record.merge(compResult) { (tuple1:SDAI.LOGICAL, tuple2:SDAI.LOGICAL) ->  SDAI.LOGICAL in
					tuple1 && tuple2
				}
			}
			let result = record.lazy.map{ $1 }.reduce(SDAI.TRUE) { $0 && $1 }
			
			return WhereRuleValidationResult(result: result, record: record)
		}

		internal func performValidateAllWhereRules(
			recording option: ValidationRecordingOption,
			monitor: ValidationMonitor
		)
		{
			let result = self.validateAllWhereRules(
				recording: option, monitor: monitor)

			guard !monitor.terminateValidation else { return }
			self._whereRuleValidationRecord.withLock{ $0 = result }
			self._validationDate.withLock{ $0 = Date() }
		}

	}
}
