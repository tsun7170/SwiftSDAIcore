//
//  ValidationMonitor.swift
//  
//
//  Created by Yoshida on 2021/06/19.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAIPopulationSchema {

	//MARK: - ValidationMonitor
  open class ValidationMonitor: @unchecked Sendable {
		public init() {}
		
		open func willValidate(
			globalRules: some Collection<SDAIDictionarySchema.GlobalRule>) {}

		open func willValidate(
			uniquenessRules:some Collection<SDAIDictionarySchema.UniquenessRule>) {}

		open func willValidateWhereRules(
			for complexEntities: some Collection<SDAI.ComplexEntity>) {}

		open func willValidateInstanceReferenceDomain(
			for applicationInstances: some Collection<SDAI.EntityReference>) {}


    open func completedToValidate(
      globalRules: some Collection<SDAIDictionarySchema.GlobalRule>) {}

    open func completedToValidate(
      uniquenessRules:some Collection<SDAIDictionarySchema.UniquenessRule>) {}

    open func completedToValidateWhereRules(
      for complexEntities: some Collection<SDAI.ComplexEntity>) {}

    open func completedToValidateInstanceReferenceDomain(
      for applicationInstances: some Collection<SDAI.EntityReference>) {}


		open func didValidateGlobalRule(
			for schemaInstance: SchemaInstance,
			result: GlobalRuleValidationResult) {}

		open func didValidateUniquenessRule(
			for schemaInstance: SchemaInstance,
			result: UniquenessRuleValidationResult) {}

		open func didValidateWhereRule(
			for complexEntity: SDAI.ComplexEntity,
			result: WhereRuleValidationRecords) {}

		open func didValidateInstanceReferenceDomain(
			for schemaInstance: SchemaInstance,
			applicationInstance: SDAI.EntityReference,
			result: InstanceReferenceDomainValidationResult) {}

    open var terminateValidation: Bool { Task.isCancelled }
	}

	//MARK: - validation related
	public typealias WhereLabel = SDAIDictionarySchema.ExpressId

  public enum ValidationRecordingOption: Sendable {
		case recordFailureOnly
		case recordAll
	}


	public typealias GlobalRuleSignature = (_ allComplexEntities: AnySequence<SDAI.ComplexEntity>) -> WhereRuleValidationRecords

	public typealias WhereRuleValidationRecords = [WhereLabel:SDAI.LOGICAL]

	public struct GlobalRuleValidationResult:CustomStringConvertible, Sendable {
    public var description: String {
      var str = "GlobalRuleValidationResult(\(globalRule.name) result:\(result)\n"
      for (i,(label,whereResult)) in record
        .sorted(by: { $0.key < $1.key })
        .enumerated() {
        str += "[\(i)]\t\(label): \(whereResult)\n"
      }
      str += ")\n"

      return str
    }

		public var globalRule: SDAIDictionarySchema.GlobalRule
		public var result: SDAI.LOGICAL
		public var record: WhereRuleValidationRecords

    public init(
      globalRule: SDAIDictionarySchema.GlobalRule,
      result: SDAI.LOGICAL = SDAI.UNKNOWN,
      record: WhereRuleValidationRecords = [:]
    )
    {
      self.globalRule = globalRule
      self.result = result
      self.record = record
    }
	}



	public typealias UniquenessRuleSignature = (_ entity: SDAI.EntityReference) -> AnyHashable?

	public struct UniquenessRuleValidationResult: Sendable {
		public var uniquenessRule: SDAIDictionarySchema.UniquenessRule
		public var result: SDAI.LOGICAL
		public var record: (uniqueCount:Int, instanceCount:Int)

    public init(
      uniquenessRule: SDAIDictionarySchema.UniquenessRule,
      result: SDAI.LOGICAL = SDAI.UNKNOWN,
      record: (uniqueCount: Int, instanceCount: Int) = (0,0)
    )
    {
      self.uniquenessRule = uniquenessRule
      self.result = result
      self.record = record
    }
	}



	public struct WhereRuleValidationResult: CustomStringConvertible, Sendable {
		public var description: String {
			var str = "WhereRuleValidationResult( result:\(result)\n"
			for (i,(label,whereResult)) in record
				.sorted(by: { $0.key < $1.key })
				.enumerated() {
					str += "[\(i)]\t\(label): \(whereResult)\n"
				}
			str += "\n"
			return str
		}

		public var result: SDAI.LOGICAL
		public var record: WhereRuleValidationRecords
	}



	public typealias InstanceReferenceDomainValidationRecord =
	(definition: SDAIDictionarySchema.AttributeType, value: SDAI.GENERIC?, result: SDAI.LOGICAL)

	public struct InstanceReferenceDomainValidationResult: CustomStringConvertible, Sendable {
		public var description: String {
			var str = "InstanceReferenceDomainValidationResult( result:\(result)\n"
			for (i, irvRec) in record.enumerated() {
				str += "[\(i)]\(irvRec.result)\t\(irvRec.definition.parentEntity.name).\(irvRec.definition.name):\(irvRec.definition.bareTypeName) = \(irvRec.value, default: "nil")\n"
			}
			str += "\n"
			return str
		}

		public var result: SDAI.LOGICAL
		public var record: [InstanceReferenceDomainValidationRecord]
	}

}

extension SDAI {
	public typealias WhereLabel = SDAIPopulationSchema.WhereLabel

	public typealias GlobalRuleSignature = SDAIPopulationSchema.GlobalRuleSignature

	public typealias UniquenessRuleSignature = SDAIPopulationSchema.UniquenessRuleSignature
}
