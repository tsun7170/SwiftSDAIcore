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

  /// A base class for monitoring the progress and results of schema instance validation.
  /// 
  /// Subclass this type to observe or record events during the validation process, such as
  /// when rules are about to be validated, after they complete, and after each individual rule
  /// or instance reference domain check.
  /// 
  /// This class is `@unchecked Sendable` to support use with Swift concurrency, but subclasses 
  /// should ensure thread safety if needed.
  /// 
  /// #### Usage
  /// Override the appropriate methods in this class to observe validation events. Each method
  /// provides relevant context, such as the rules or entities being validated, and the results 
  /// of validation steps.
  ///
  /// - Note: The `terminateValidation` property can be overridden to provide custom termination
  ///   logic. By default, validation is terminated if the current Swift concurrency task is cancelled.
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

  /// An option that specifies how validation results should be recorded during schema instance validation.
  ///
  /// Use this enumeration to control whether all validation results or only failures are recorded,
  /// allowing you to optimize for performance or detail level during validation monitoring.
  ///
  /// - `recordFailureOnly`: Record only validation failures. This option reduces memory usage and
  ///   processing time by omitting successful results from the log, providing a focused summary of issues.
  /// - `recordAll`: Record all validation results, including both successes and failures. This option
  ///   produces a comprehensive log useful for auditing or detailed diagnostics.
  public enum ValidationRecordingOption: Sendable {
		case recordFailureOnly
		case recordAll
	}


	public typealias GlobalRuleSignature = (_ allComplexEntities: AnySequence<SDAI.ComplexEntity>) -> WhereRuleValidationRecords

  public typealias WhereRuleValidationRecords = [WhereLabel:SDAI.LOGICAL]

  /// Represents the result of validating a global rule against a set of complex entities in a schema instance.
  ///
  /// This structure encapsulates the rule that was validated, its overall Boolean result, and a detailed record
  /// of results for each checked WHERE label within the rule. It is useful for monitoring, reporting, or
  /// analyzing the outcome of schema instance validation processes.
  ///
  /// - Parameters:
  ///   - globalRule: The global rule instance that was validated.
  ///   - result: The overall Boolean result of the validation (`TRUE`, `FALSE`, or `UNKNOWN`), as defined by the EXPRESS specification.
  ///   - record: A mapping from WHERE rule labels to their individual Boolean results (`LOGICAL`), providing per-label detail of the validation outcome.
  ///
  /// - Note: The `description` property yields a human-readable summary of the global rule, its overall result,
  ///   and the individual WHERE rule results.
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

  /// Represents the result of validating a uniqueness rule against a set of entity instances in a schema instance.
  ///
  /// This structure encapsulates the uniqueness rule that was validated, its Boolean result, and a record of
  /// the count of unique values and the total number of instances checked. It is useful for monitoring,
  /// reporting, or analyzing the outcome of schema instance uniqueness validations.
  ///
  /// - Parameters:
  ///   - uniquenessRule: The uniqueness rule instance that was validated.
  ///   - result: The overall Boolean result of the validation (`TRUE`, `FALSE`, or `UNKNOWN`), as defined by the EXPRESS specification.
  ///   - record: A tuple containing the count of unique values and the total number of instances checked for the rule.
  ///
  /// - Note: This structure does not provide a textual description by default. For custom reporting, you may
  ///   extend it or manually construct a string representation as needed.
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



  /// Represents the result of validating WHERE rules on a complex entity or set of entities.
  ///
  /// This structure encapsulates the overall Boolean result of the validation, as well as a detailed record
  /// of individual results for each WHERE rule label checked. It is useful for monitoring, reporting, or
  /// analyzing the outcome of schema instance WHERE rule validation steps.
  ///
  /// - Parameters:
  ///   - result: The overall Boolean result of all validated WHERE rules (`TRUE`, `FALSE`, or `UNKNOWN`), as defined by the EXPRESS specification.
  ///   - record: A mapping from WHERE rule labels to their individual Boolean results (`LOGICAL`). Each entry in this dictionary provides the outcome for a specific WHERE label.
  ///
  /// - Note: The `description` property yields a human-readable summary of the overall result and each individual WHERE label's result.
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

  /// Represents the result of validating the domain of instance references for an application instance in a schema.
  /// 
  /// This structure encapsulates both the overall Boolean result of the domain validation and a detailed record
  /// of results for each attribute checked. It is useful for monitoring, reporting, or analyzing the outcome of 
  /// instance reference domain validation steps, such as ensuring that the referenced entities conform to the expected types.
  /// 
  /// - Parameters:
  ///   - result: The overall Boolean result of the validation (`TRUE`, `FALSE`, or `UNKNOWN`), as defined by the EXPRESS specification.
  ///   - record: An array of tuples, each containing:
  ///       - `definition`: The attribute type definition being validated.
  ///       - `value`: The value of the attribute that was checked (or `nil` if not present).
  ///       - `result`: The Boolean result for that attribute's domain validation.
  /// 
  /// - Note: The `description` property yields a human-readable summary of the overall result and each attribute's validation outcome.
  ///   This structure is `Sendable` to support use with Swift concurrency.
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
	public typealias WhereLabel            = SDAIPopulationSchema.WhereLabel

  public typealias WhereRuleValidationRecords        =  SDAIPopulationSchema.WhereRuleValidationRecords

  public typealias GlobalRuleSignature = SDAIPopulationSchema.GlobalRuleSignature

	public typealias UniquenessRuleSignature = SDAIPopulationSchema.UniquenessRuleSignature
}
