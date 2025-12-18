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

		internal let schemaInstanceID: SchemaInstanceID //= SchemaInstanceID()

		public var globalRuleValidationRecord: [GlobalRuleValidationResult]? {
			self._globalRuleValidationRecord.withLock{ $0 }
		}
		private let _globalRuleValidationRecord = Mutex<[GlobalRuleValidationResult]?>(nil)
		
		public var globalRuleValidationRecordDescription: String {
			let recs = self.globalRuleValidationRecord
			var str = "GlobalRuleValidationResult \(recs?.count, default: "nil") records\n"

			if let recs = recs {
				for (i,grvRec) in recs.enumerated() {
					str += "[\(i)]\(grvRec.result)\t\(grvRec.globalRule.name):\t"
					for whereRec in grvRec.record {
						str += "(\(whereRec.key): \(whereRec.value)) "
					}
					str += "\n"
				}
			}

			str += "\n"
			return str
		}


		public var uniquenessRuleValidationRecord: [UniquenessRuleValidationResult]? {
			self._uniquenessRuleValidationRecord.withLock{ $0 }
		}
		private let _uniquenessRuleValidationRecord = Mutex<[UniquenessRuleValidationResult]?>(nil)

		public var uniquenessRuleValidationRecordDescription: String {
			let recs = self.uniquenessRuleValidationRecord
			var str = "UniquenessRuleValidationResult  \(recs?.count, default: "nil") records\n"

			if let recs = recs {
				for (i,urvRec) in recs.enumerated() {
					str += "[\(i)]\(urvRec.result)\t\(urvRec.uniquenessRule): #duplicates(\(urvRec.record.instanceCount - urvRec.record.uniqueCount)) / #instances(\(urvRec.record.instanceCount))\n"
				}
			}

			str += "\n"
			return str
		}


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
			self.schemaInstanceID = SchemaInstanceID()
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
			self.schemaInstanceID = original.schemaInstanceID
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
		}

		internal func dissociate(from model: SdaiModel) {
			self.associatedModelIDs.withLock{ $0.remove(model.modelID); return }
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
		) -> some Sequence<ENT>
		where ENT:SDAIParameterDataSchema.ApplicationInstance
    {
      let result = associatedModels.lazy
        .compactMap{ $0.contents.folders[type.entityDefinition]?
          .instances.compactMap{$0 as? ENT} }
        .joined()
      return result
    }

    //MARK: USEDIN cache related

    public func terminateCachingTasks() {
      for model in associatedModels {
        model.terminateCachingTask()
      }
    }

    public func toCompleteCachingTasks() async {
      for model in associatedModels {
        await model.toCompleteCachingTask()
      }
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
		public func instanceReferenceDomainNonConformances(
			entity: SDAIParameterDataSchema.ApplicationInstance,
			recording option: ValidationRecordingOption
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
					switch option {
						case .recordFailureOnly:
							return nil
						case .recordAll:
							return (attrDef, attrVal, SDAI.UNKNOWN)
					}
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

		public func validateAllInstanceReferenceDomain(
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
            result: SDAI.UNKNOWN, record: nonConfs)
        }

				let (result,nonconf) =
				self.instanceReferenceDomainNonConformances(entity: entity, recording: option)

				monitor.didValidateInstanceReferenceDomain(
					for: self,
					applicationInstance: entity,
					result: InstanceReferenceDomainValidationResult(result: result, record: nonconf))

				nonConfs.append(contentsOf: nonconf)
				overallResult = overallResult && result
			}

      monitor.completedToValidateInstanceReferenceDomain(for: applicationInstances)

			return InstanceReferenceDomainValidationResult(
				result: overallResult,
				record: nonConfs)
		}

    private func chunkSize(for targetCount: Int, session: SDAISessionSchema.SdaiSession) -> Int
    {
      let result = max(
        session.minValidationTaskChunkSize,
        targetCount / session.maxValidationTaskSegmentation )

      return result
    }

    public func validateAllInstanceReferenceDomainAsync(
      recording option: ValidationRecordingOption,
      monitor: ValidationMonitor,
      session: SDAISessionSchema.SdaiSession
    ) async -> InstanceReferenceDomainValidationResult
    {
      var overallResult = SDAI.TRUE
      var nonConfs:[InstanceReferenceDomainValidationRecord] = []

      let applicationInstances = self.applicationInstances

      monitor.willValidateInstanceReferenceDomain(for: applicationInstances)

      await withTaskGroup(
        of: [(SDAI.EntityReference,
             SDAI.LOGICAL,
             [SDAIPopulationSchema.InstanceReferenceDomainValidationRecord])].self)
      { taskgroup in
        var targetApplicationInstances = Array(applicationInstances)
        let chunkSize = chunkSize(for: targetApplicationInstances.count, session: session)

        for _ in 1 ... session.maxConcurrency {
          if monitor.terminateValidation { return }

          let entities = targetApplicationInstances.popLast(chunkSize)
          guard !entities.isEmpty else { break }

          addTask(entities: entities)
        }//for

        for await results in taskgroup {
          if monitor.terminateValidation { return }

          let entities = targetApplicationInstances.popLast(chunkSize)
          if !entities.isEmpty {
            addTask(entities: entities)
          }

          for (entity,result,nonconf) in results {
            monitor.didValidateInstanceReferenceDomain(
              for: self,
              applicationInstance: entity,
              result: InstanceReferenceDomainValidationResult(result: result, record: nonconf))

            nonConfs.append(contentsOf: nonconf)
            overallResult = overallResult && result
          }
        }

        func addTask(entities: [SDAI.EntityReference])
        {
          taskgroup.addTask(
            name: "SDAI.RefDomainValidation_\(targetApplicationInstances.count)")
          {
            var results:[(SDAI.EntityReference,
                          SDAI.LOGICAL,
                          [SDAIPopulationSchema.InstanceReferenceDomainValidationRecord])] = []

            for entity in entities {
              if monitor.terminateValidation { return results }

              let (result,nonconf) =
              self.instanceReferenceDomainNonConformances(entity: entity, recording: option)
              results.append( (entity,result,nonconf) )
            }//for

            return results
          }//addTask
        }
      }//withTaskGroup

      if monitor.terminateValidation {
        return InstanceReferenceDomainValidationResult(
          result: SDAI.UNKNOWN, record: nonConfs)
      }

      monitor.completedToValidateInstanceReferenceDomain(for: applicationInstances)

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

		internal func performValidateAllInstanceReferenceDomainAsync(
			recording option: ValidationRecordingOption,
			monitor: ValidationMonitor,
      session: SDAISessionSchema.SdaiSession
		) async
		{
      let result = await self.validateAllInstanceReferenceDomainAsync(
        recording: option, monitor: monitor, session: session)

			guard !monitor.terminateValidation else { return }
			self._instanceReferenceDomainValidationRecord.withLock{ $0 = result }
			self._validationDate.withLock{ $0 = Date() }
		}


//MARK: global rule validation
		public func validate(
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

		public func validateAllGlobalRules(
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

      monitor.completedToValidate(globalRules: self.nativeSchema.globalRules.values)

			return globalRec
		}

    public func validateAllGlobalRulesAsync(
      recording: ValidationRecordingOption,
      monitor: ValidationMonitor,
      session: SDAISessionSchema.SdaiSession
    ) async -> [GlobalRuleValidationResult]
    {
      var globalRec:[GlobalRuleValidationResult] = []

      monitor.willValidate(globalRules: self.nativeSchema.globalRules.values)

      await withTaskGroup(
        of: [SDAIPopulationSchema.GlobalRuleValidationResult].self)
      { taskgroup in
        var targetGlobalRules = Array(nativeSchema.globalRules.values)
        let chunkSize = chunkSize(for: targetGlobalRules.count, session: session)

        for _ in 1 ... session.maxConcurrency {
          if monitor.terminateValidation { return }

          let globalRules = targetGlobalRules.popLast(chunkSize)
          guard !globalRules.isEmpty else { break }

          addTask(globalRules: globalRules)
        }//for

        for await results in taskgroup {
          if monitor.terminateValidation { return }

          let globalRules = targetGlobalRules.popLast(chunkSize)
          if !globalRules.isEmpty {
            addTask(globalRules: globalRules)
          }

          for result in results {
            monitor.didValidateGlobalRule(for: self, result: result)

            switch recording {
              case .recordFailureOnly:
                if result.result == SDAI.FALSE { globalRec.append(result) }
              case .recordAll:
                globalRec.append(result)
            }
          }

        }//for await

        func addTask(globalRules: [SDAIDictionarySchema.GlobalRule])
        {
          taskgroup.addTask(
            name: "SDAI.GlobalRuleValidation_\(targetGlobalRules.count)")
          {
            var results: [SDAIPopulationSchema.GlobalRuleValidationResult] = []

            for globalRule in globalRules {
              if monitor.terminateValidation { return results }

              let result = self.validate(globalRule: globalRule, recording: recording)
              results.append(result)
            }

            return results
          }//addTask
        }
      }//withTaskGroup

      if monitor.terminateValidation { return globalRec }

      monitor.completedToValidate(globalRules: self.nativeSchema.globalRules.values)

      return globalRec
    }

    internal func performValidateAllGlobalRules(
      recording option: ValidationRecordingOption,
      monitor: ValidationMonitor
    )
    {
      let result = self.validateAllGlobalRules(recording: option, monitor: monitor)

      guard !monitor.terminateValidation else { return }
      self._globalRuleValidationRecord.withLock{ $0 = result }
      self._validationDate.withLock{ $0 = Date() }
    }

		internal func performValidateAllGlobalRulesAsync(
			recording option: ValidationRecordingOption,
			monitor: ValidationMonitor,
      session: SDAISessionSchema.SdaiSession
		) async
		{
      let result = await self.validateAllGlobalRulesAsync(recording: option, monitor: monitor, session: session)

			guard !monitor.terminateValidation else { return }
			self._globalRuleValidationRecord.withLock{ $0 = result }
			self._validationDate.withLock{ $0 = Date() }
		}


//MARK: uniqueness rule validation
		public func validate(
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

		public func validateAllUniquenessRules(
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

      monitor.completedToValidate(uniquenessRules: self.nativeSchema.uniquenessRules)

			return uniqueRec
		}

    public func validateAllUniquenessRulesAsync(
      recording: ValidationRecordingOption,
      monitor: ValidationMonitor,
      session: SDAISessionSchema.SdaiSession
    ) async -> [UniquenessRuleValidationResult]
    {
      var uniqueRec: [UniquenessRuleValidationResult] = []

      monitor.willValidate(uniquenessRules: self.nativeSchema.uniquenessRules)

      await withTaskGroup(
        of: [SDAIPopulationSchema.UniquenessRuleValidationResult].self)
      { taskgroup in
        var targetUniquenessRules = Array(nativeSchema.uniquenessRules)
        let chunkSize = chunkSize(for: targetUniquenessRules.count, session: session)

        for _ in 1 ... session.maxConcurrency {
          if monitor.terminateValidation { return }

          let uniqueRules = targetUniquenessRules.popLast(chunkSize)
          guard !uniqueRules.isEmpty else { break }

          addTask(uniqueRules: uniqueRules)
        }//for

        for await results in taskgroup {
          if monitor.terminateValidation { return }

          let uniqueRules = targetUniquenessRules.popLast(chunkSize)
          if !uniqueRules.isEmpty {
            addTask(uniqueRules: uniqueRules)
          }

          for result in results {
            monitor.didValidateUniquenessRule(for: self, result: result)
            
            switch recording {
              case .recordFailureOnly:
                if result.result == SDAI.FALSE { uniqueRec.append(result) }
              case .recordAll:
                uniqueRec.append(result)
            }
          }

        }//for await

        func addTask(uniqueRules: [SDAIDictionarySchema.UniquenessRule])
        {
          taskgroup.addTask(
            name: "SDAI.UniqueRuleValidation_\(targetUniquenessRules.count)")
          {
            var results: [SDAIPopulationSchema.UniquenessRuleValidationResult] = []

            for uniqueRule in uniqueRules {
              if monitor.terminateValidation { return results }

              let result = self.validate(uniquenessRule: uniqueRule)
              results.append(result)
            }

            return results
          }//addTask
        }
      }//withTaskGroup

      if monitor.terminateValidation { return uniqueRec }

      monitor.completedToValidate(uniquenessRules: self.nativeSchema.uniquenessRules)

      return uniqueRec
    }

    internal func performValidateAllUniquenessRules(
      recording option: ValidationRecordingOption,
      monitor: ValidationMonitor
    )
    {
      let result = self.validateAllUniquenessRules(
        recording: option, monitor: monitor)

      guard !monitor.terminateValidation else { return }
      self._uniquenessRuleValidationRecord.withLock{ $0 = result }
      self._validationDate.withLock{ $0 = Date() }
    }

		internal func performValidateAllUniquenessRulesAsync(
			recording option: ValidationRecordingOption,
			monitor: ValidationMonitor,
      session: SDAISessionSchema.SdaiSession
		) async
		{
      let result = await self.validateAllUniquenessRulesAsync(
        recording: option, monitor: monitor, session: session)

			guard !monitor.terminateValidation else { return }
			self._uniquenessRuleValidationRecord.withLock{ $0 = result }
			self._validationDate.withLock{ $0 = Date() }
		}

		//MARK: where rule validation
		public func validateAllWhereRules(
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

      monitor.completedToValidateWhereRules(for: allComplexEntities)

			let overallResult = record.lazy.map{ $1 }.reduce(SDAI.TRUE) { $0 && $1 }

			return WhereRuleValidationResult(result: overallResult, record: record)
		}

    public func validateAllWhereRulesAsync(
      recording option: ValidationRecordingOption,
      monitor: ValidationMonitor,
      session: SDAISessionSchema.SdaiSession
    ) async -> WhereRuleValidationResult
    {
      var record: WhereRuleValidationRecords = [:]

      let allComplexEntities = self.allComplexEntities
      monitor.willValidateWhereRules(for: allComplexEntities)

      await withTaskGroup(
        of: [(SDAI.ComplexEntity,
             [SDAIPopulationSchema.WhereLabel : SDAI.LOGICAL])].self)
      { taskgroup in
        var targetComplexEntities = Array(allComplexEntities)
        let chunkSize = chunkSize(for: targetComplexEntities.count, session: session)

        for _ in 1 ... session.maxConcurrency {
          if monitor.terminateValidation { return }

          let complexes = targetComplexEntities.popLast(chunkSize)
          guard !complexes.isEmpty else { break }

          addTask(complexes: complexes)
        }//for

        for await results in taskgroup {
          if monitor.terminateValidation { return }

          let complexes = targetComplexEntities.popLast(chunkSize)
          if !complexes.isEmpty {
            addTask(complexes: complexes)
          }

          for (complex, compResult) in results {
            monitor.didValidateWhereRule(for: complex, result: compResult)

            record.merge(compResult) { (tuple1:SDAI.LOGICAL, tuple2:SDAI.LOGICAL) ->  SDAI.LOGICAL in
              tuple1 && tuple2
            }
          }

        }//for await

        func addTask(complexes: [SDAI.ComplexEntity])
        {
          taskgroup.addTask(
            name: "SDAI.WhereRuleValidation_\(targetComplexEntities.count)")
          {
            var results: [(SDAI.ComplexEntity,
                           [SDAIPopulationSchema.WhereLabel : SDAI.LOGICAL])] = []

            for complex in complexes {
              if monitor.terminateValidation { return results }

              let compResult = complex.validateEntityWhereRules(prefix: "", recording: option)

              results.append( (complex, compResult) )
            }

            return results
          }//addTask
        }
      }//withTaskGroup

      if monitor.terminateValidation { return WhereRuleValidationResult(result: SDAI.UNKNOWN, record: record) }

      monitor.completedToValidateWhereRules(for: allComplexEntities)

      let overallResult = record.lazy.map{ $1 }.reduce(SDAI.TRUE) { $0 && $1 }

      return WhereRuleValidationResult(result: overallResult, record: record)
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

		internal func performValidateAllWhereRulesAsync(
			recording option: ValidationRecordingOption,
			monitor: ValidationMonitor,
      session: SDAISessionSchema.SdaiSession
		) async
		{
      let result = await self.validateAllWhereRulesAsync(
        recording: option, monitor: monitor, session: session)

			guard !monitor.terminateValidation else { return }
			self._whereRuleValidationRecord.withLock{ $0 = result }
			self._validationDate.withLock{ $0 = Date() }
		}

	}
}
