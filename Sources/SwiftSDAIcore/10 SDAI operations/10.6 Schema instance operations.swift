//
//  10.6 Schema instance operations.swift
//  SwiftSDAIcore
//
//  Created by Yoshida on 2025/09/04.
//

import Foundation

extension SDAISessionSchema.SdaiTransactionRW {


	/// ISO 10303-22 (10.6.1) Delete schema instance
	///
	/// This operation deletes a schema instance.
	/// If references between two SDAI-models associated with the schema instance existed and there is not another schema instance with both SDAI-models are associated, then the references between the entity instances in those two SDAI-models are invalid (see 10.10.7).
	///
	/// - Parameter instance: The schema instance to be deleted.
	/// - Returns: true if operation is successful.
	///
	@discardableResult
	public func deleteSchemaInstance(
		instance: SDAIPopulationSchema.SchemaInstance
	) -> Bool
	{
		guard let session = self.owningSession else {
			SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "An SDAI session is not open.")
			return false
		}
		guard session.checkRepositoriesOpen(relatedTo: instance) else {
			return false
		}
		guard let activeSI = session.findAndActivateSchemaInstance(schemaInstanceID: instance.schemaInstanceID),
					activeSI == instance else {
			SDAI.raiseErrorAndContinue(.SI_NEXS, detail: "The schema instance does not exist or already been deleted within the transaction.")
			return false
		}

		let promoted = self.notifyApplicationDomainChanged(relatedTo: instance)
		promoted.teardown()
		session.deleteSchemaInstance(schemaInstanceID: promoted.schemaInstanceID)
		return true
	}


	/// ISO 10303-22 (10.6.2) Rename schema instance
	///
	/// This operation assigns a new name to a schema instance.
	///
	/// - Parameters:
	///   - instance: The schema instance to rename.
	///   - name: The new name for the schema instance.
	/// - Returns: new reference to the modified schema instance if the operation is successful.
	///
	public func renameSchemaInstance(
		instance: SDAIPopulationSchema.SchemaInstance,
		name: SDAIPopulationSchema.STRING
	) -> SDAIPopulationSchema.SchemaInstance?
	{
		guard let session = self.owningSession else {
			SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "An SDAI session is not open.")
			return nil
		}
		guard session.checkRepositoriesOpen(relatedTo: instance) else {
			return nil
		}
		guard let activeSI = session.findAndActivateSchemaInstance(schemaInstanceID: instance.schemaInstanceID),
					activeSI == instance else {
			SDAI.raiseErrorAndContinue(.SI_NEXS, detail: "The schema instance does not exist or already been deleted within the transaction.")
			return nil
		}
		if let repository = session.activeServers[instance.repository.name],
			 let existingSI = repository.contents.findSchemaInstance(named: name) {
			SDAI.raiseErrorAndContinue(.SI_DUP(existingSI), detail: "A duplicate schema instance name exists within the repository.")
			return nil
		}

		let promoted = session.promoteSchemaInstanceToRW(schemaInstanceID: instance.schemaInstanceID)

		promoted.name = name
		return promoted
	}



	/// ISO 10303-22 (10.6.3) Add SDAI-model
	/// 
	///  This operation adds an SDAI-model to the set of SDAI-models that are associated with a schema instance.
	/// 
	///  This enables entity instances in the SDAI-model to reference and be referenced by entity instances in other SDAI-models associated with the schema instance.
	/// 
	///  This also adds the entity instances in the SDAI-model to the domain for global and uniqueness rule validation defined by the schema instance.
	/// 
	///  If the SDAI-model is not based upon the same schema as the schema instance but is based upon an external schema, then an entity instance in the SDAI-model shall be considered associated with the schema instance only if its entity type is defined as being domain equivalent with and entity type from the native schema upon which the schema instance is based (see A.2). If domain equivalence is not supported and the SDAI-model being added is based upon an external schema, the FN-NAVL error shall result.
	/// 
	/// - Parameters:
	///   - instance: The schema instance with which the SDAI-model is to be associated.
	///   - model: The SDAI-model that is to be associated with the schema instance.
	/// - Returns: new references to the modified schema instance and SDAI-model if the operation is successful.
	///
	public func addSdaiModel(
		instance schemaInstance: SDAIPopulationSchema.SchemaInstance,
		model: SDAIPopulationSchema.SdaiModel
	) -> SDAIPopulationSchema.SchemaInstance?
	{
		guard let session = self.owningSession else {
			SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "An SDAI session is not open.")
			return nil
		}
		guard session.checkRepositoriesOpen(relatedTo: schemaInstance) else {
			return nil
		}
		guard let activeSI = session.findAndActivateSchemaInstance(schemaInstanceID: schemaInstance.schemaInstanceID),
					activeSI == schemaInstance else {
			SDAI.raiseErrorAndContinue(.SI_NEXS, detail: "The schema instance does not exist or already been deleted within the transaction.")
			return nil
		}
		guard model.underlyingSchema == schemaInstance.nativeSchema else {
			SDAI.raiseErrorAndContinue(.MO_NDEQ(model), detail: "The SDAI-model is not domain equivalent with the schema instance.")
			SDAI.raiseErrorAndContinue(.FN_NAVL, detail: "Domain equivalence is not supported by this implementation.")
			return nil
		}

		if schemaInstance.isAssociatedWith(modelWithID: model.modelID) {
			return schemaInstance
		}

//		let promotedModel = session.promoteSdaiModelToRW(modelID: model.modelID)
		let promotedSI = session.promoteSchemaInstanceToRW(schemaInstanceID: schemaInstance.schemaInstanceID)

//		promotedModel.associate(with: promotedSI)
		promotedSI.associate(with: model)

		return self.notifyApplicationDomainChanged(relatedTo: promotedSI)
	}



	/// ISO 10303-22 (10.6.4) Remove SDAI-model
	///
	/// This operation removes an SDAI-model from the set of SDAI-models that are associated with a schema instance.
	///
	/// If the SDAI-model no longer has a schema instance in common with another SDAI-model in the schema instance then all references between those two SDAI-models are invalid (see 10.10.7).
	///
	/// - Parameter model: The SDAI-model that is to be removed from the schema instance.
	/// - Returns: true indicating the success of the operation.
	///
	public func removeSdaiModel(
		instance: SDAIPopulationSchema.SchemaInstance,
		model: SDAIPopulationSchema.SdaiModel
	) -> SDAIPopulationSchema.SchemaInstance?
	{
		guard let session = self.owningSession else {
			SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "An SDAI session is not open.")
			return nil
		}
		guard session.checkRepositoriesOpen(relatedTo: instance) else {
			return nil
		}
		guard let activeSI = session.findAndActivateSchemaInstance(schemaInstanceID: instance.schemaInstanceID),
					activeSI == instance else {
			SDAI.raiseErrorAndContinue(.SI_NEXS, detail: "The schema instance does not exist or already been deleted within the transaction.")
			return nil
		}
		guard model.underlyingSchema == instance.nativeSchema else {
			SDAI.raiseErrorAndContinue(.MO_NDEQ(model), detail: "The SDAI-model is not domain equivalent with the schema instance.")
			SDAI.raiseErrorAndContinue(.FN_NAVL, detail: "Domain equivalence is not supported by this implementation.")
			return nil
		}

		if !instance.isAssociatedWith(modelWithID: model.modelID) {
			return instance
		}

//		let promotedModel = session.promoteSdaiModelToRW(modelID: model.modelID)
		let promotedSI = session.promoteSchemaInstanceToRW(schemaInstanceID: instance.schemaInstanceID)

//		promotedModel.dissociate(from: promotedSI)
		promotedSI.dissociate(from: model)

		return self.notifyApplicationDomainChanged(relatedTo: promotedSI)
	}


}//SdaiTransactionRW

extension SDAISessionSchema.SdaiTransaction {
	/// ISO 10303-22 (10.6.5) Validate global rule
	/// 
	/// This operation determines whether a global rule defined in a schema is satisfied by the population associated with a schema instance.
	/// 
	/// The entity instances included in the validation are all entity instances of the entity types to which the global rule applies in all of the SDAI-models that are associated with the schema instance. Entity instances within SDAI-models based upon an external schema are included in the validation if they are instances of entity types defined to be domain equivalent with entity types in the native schema by an instance of ExternalSchema. Entity instances so included shall be treated as instances of the native type as defined in DomainEquivalentType.
	/// 
	/// If the external entity type lacks properties required to satisfy the rule then the ED-NVLD error results. References to entity instances in SDAI-models that are not associated with the schema instance shall as treated if they are unset.
	/// 
	/// - Parameters:
	///   - instance: The schema instance bounding the validation.
	///   - rule: The global rule to validate.
	///   - option: mode of validation result recording.
	///
	/// - Returns: the result of global rule validation, including logical value indicating TRUE if Rule is satisfied, FALSE if the rule is not satisfied, and UNKNOWN if the expression evaluates to an indeterminate or UNKNOWN value. The result record also contains a list of where_rule within global rule to which SchemaInstance did not conform.
	/// 
	public func validateGlobalRule(
		instance: SDAIPopulationSchema.SchemaInstance,
		rule: SDAIDictionarySchema.GlobalRule,
		option: SDAIPopulationSchema.ValidationRecordingOption = .recordFailureOnly
	) -> SDAIPopulationSchema.GlobalRuleValidationResult?
	{
		guard let session = self.owningSession else {
			SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "An SDAI session is not open.")
			return nil
		}
		guard session.checkRepositoriesOpen(relatedTo: instance) else {
			return nil
		}
		guard let activeSI = session.findAndActivateSchemaInstance(schemaInstanceID: instance.schemaInstanceID),
					activeSI == instance else {
			SDAI.raiseErrorAndContinue(.SI_NEXS, detail: "The schema instance does not exist or already been deleted within the transaction.")
			return nil
		}

		let result = instance.validate(globalRule: rule, recording: option)
		return result
	}


	/// ISO 10303-22 (10.6.6) Validate uniqueness rule
	/// 
	///  This operation determines whether a uniqueness rule defined in a schema is satisfied by the population associated with a schema instance.
	/// 
	///  The entity instances included in the validation are all entity instances of the entity type in which the rule was declared in all of the SDAI-models that are associated with the schema instance.
	/// 
	///  Entity instances within SDAI-models based upon an external schema are included in the validation if they are instances of entity types defined to be domain equivalent with entity types in the native schema by an instance of ExternalSchema. Entity instances so included shall be treated as instances of the native type as defined in DomainEquivalentType. If the external entity type lacks properties required to satisfy the rule then the ED-NVLD error results.
	/// 
	///  References to entity instances in SDA-models that are not associated with the schema instance shall as treated if they are unset.
	///
	///  - Parameter instance: The schema instance bounding the validation.
	///  - Parameter rule: The uniqueness rule to be validated.
	///
	///  - Returns: result of validation, including logical value indicating TRUE if the rule is satisfied, FALSE if the rule is not satisfied, and UNKNOWN if an optional explicit attribute was unset, if a derived attribute value was indeterminate or UNKNOWN or if an inverse attribute had no value.
	/// 
	 public func validateUniquenessRule(
		instance: SDAIPopulationSchema.SchemaInstance,
		rule: SDAIDictionarySchema.UniquenessRule
	 ) -> SDAIPopulationSchema.UniquenessRuleValidationResult?
	{
		guard let session = self.owningSession else {
			SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "An SDAI session is not open.")
			return nil
		}
		guard session.checkRepositoriesOpen(relatedTo: instance) else {
			return nil
		}
		guard let activeSI = session.findAndActivateSchemaInstance(schemaInstanceID: instance.schemaInstanceID),
					activeSI == instance else {
			SDAI.raiseErrorAndContinue(.SI_NEXS, detail: "The schema instance does not exist or already been deleted within the transaction.")
			return nil
		}

		let result = instance.validate(uniquenessRule: rule)
		return result
	}


	/// ISO 10303-22 (10.6.7) Validate instance reference domain
	/// 
	/// This operation determines whether all attributes in the specified application instance with a reference to an entity instance as their value refer to entity instances within SDAI-models associated with the specified schema instance.
	/// 
	/// - Parameters:
	///   - instance: The schema instance bounding the test.
	///   - object: The application instance to test.
	///
	/// - Returns: result of validation, including logical value indicating TRUE if all the assigned attributes of _object_ are to entity instances in _instance_, FALSE if not, and UNKNOWN if any required explicit attribute values are unset that could reference an entity instance.
	///
	public func validateInstanceReferenceDomain(
		instance: SDAIPopulationSchema.SchemaInstance,
		object: SDAIParameterDataSchema.ApplicationInstance
	) -> SDAIPopulationSchema.InstanceReferenceDomainValidationResult?
	{
		guard let session = self.owningSession else {
			SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "An SDAI session is not open.")
			return nil
		}
		guard session.checkRepositoriesOpen(relatedTo: instance) else {
			return nil
		}
		guard let activeSI = session.findAndActivateSchemaInstance(schemaInstanceID: instance.schemaInstanceID),
					activeSI == instance else {
			SDAI.raiseErrorAndContinue(.SI_NEXS, detail: "The schema instance does not exist or already been deleted within the transaction.")
			return nil
		}

		let (result,nonconf) =
		instance.instanceReferenceDomainNonConformances(entity: object)

		return SDAIPopulationSchema.InstanceReferenceDomainValidationResult(
			result: result,
			record: nonconf)
	}

}//SdaiTransaction

extension SDAISessionSchema.SdaiTransactionRW {
	/// ISO 10303-22 (10.6.8) Validate schema instance
	/// 
	/// This operation determines whether the population associated with a schema instance conforms to all constraints specified within the schema upon which the scheme instance is based.
	/// 
	/// This operation updates the validation information maintained within the schema instance.
	/// 
	/// - Parameters:
	///   - instance: The schema instance bounding the test.
	///   - option: mode of validation result recording.
	///   - monitor: validation activity monitor object, with which the progress of the validation can be tracked.
	/// - Returns: TRUE if all the constraints from the schema upon which SchemaInstance is based are met, FLASE if any constraint is violated, and UNKNOWN any constraint resulted in UNKNOWN.
	/// 
	public func validateSchemaInstance(
		instance: SDAIPopulationSchema.SchemaInstance,
		option: SDAIPopulationSchema.ValidationRecordingOption = .recordFailureOnly,
		monitor: SDAIPopulationSchema.ValidationMonitor = SDAIPopulationSchema.ValidationMonitor()
	) -> SDAI.LOGICAL
	{
		guard let session = self.owningSession else {
			SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "An SDAI session is not open.")
			return nil
		}
		guard session.checkRepositoriesOpen(relatedTo: instance) else {
			return nil
		}
		guard let activeSI = session.findAndActivateSchemaInstance(schemaInstanceID: instance.schemaInstanceID),
					activeSI == instance else {
			SDAI.raiseErrorAndContinue(.SI_NEXS, detail: "The schema instance does not exist or already been deleted within the transaction.")
			return nil
		}

		let promotedSI = session.promoteSchemaInstanceToRW(schemaInstanceID: instance.schemaInstanceID)

		// instance reference domain check
		promotedSI.performValidateAllInstanceReferenceDomain(recording: option, monitor: monitor)

		// global rule check
		promotedSI.performValidateGlobalRules(recording: option, monitor: monitor)

		// uniqueness rule check
		promotedSI.performValidateUniquenessRules(recording: option, monitor: monitor)

		// where rule check
		promotedSI.performValidateAllWhereRules(recording: option, monitor: monitor)

		return promotedSI.validationResult
	}

}//SdaiTransactionRW


extension SDAISessionSchema.SdaiTransaction {

	/// ISO 10303-22 (10.6.9) Is validation current
	///
	/// This operation determines whether complete validation of a schema instance may be required based on whether the SchemaInstance.validationResult has a value or based on whether any modification to a schema instance or any of the SDAI-models associated with the schema instance has been performed since the most recent Validate schema instance operation was performed.
	/// 
	/// 
	/// - Parameter instance: The schema instance bounding the test.
	///
	/// - Returns: TRUE if SchemaInstance validation result is currently set to TRUE and no modification to SchemaInstance or member of SchemaInstance.associatedModels since the last validation was performed is found, otherwise FALSE.
	/// The validation result not being set or any modification found will result in the operation determining that validation is not current.
	///
	public func isValidationCurrent(
		instance: SDAIPopulationSchema.SchemaInstance
	) -> SDAI.LOGICAL
	{
		guard let session = self.owningSession else {
			SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "An SDAI session is not open.")
			return SDAI.UNKNOWN
		}
		guard session.checkRepositoriesOpen(relatedTo: instance) else {
			return SDAI.UNKNOWN
		}
		guard let activeSI = session.findAndActivateSchemaInstance(schemaInstanceID: instance.schemaInstanceID),
					activeSI == instance else {
			SDAI.raiseErrorAndContinue(.SI_NEXS, detail: "The schema instance does not exist or already been deleted within the transaction.")
			return SDAI.UNKNOWN
		}

		return instance.validationResult
	}

}//SdaiTransaction
