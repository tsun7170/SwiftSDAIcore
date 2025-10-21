//
//  10.7 SDAI-model operations.swift
//  SwiftSDAIcore
//
//  Created by Yoshida on 2025/09/10.
//

import Foundation

extension SDAISessionSchema.SdaiTransactionRW {
	/// ISO 10303-22 (10.7.1) Delete SDAI-model
	///
	/// This operation deletes an SdaiModel along with all of the entity_instances, aggregate_instances and scopes that it contains.
	/// Any subsequent operation using a reference to the SDAI-model or to any of its contents shall behave as if the reference was unset.
	///
	/// - Parameter model: The SdaiModel to delete.
	/// - Returns: true if operation is successful.
	///
	@discardableResult
	public func deleteSdaiModel(
		model: SDAIPopulationSchema.SdaiModel
	) -> Bool
	{
		guard let session = self.owningSession else {
			SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "An SDAI session is not open.")
			return false
		}
		guard let _ = session.checkRepositoryOpen(relatedTo: model) else {
			return false
		}
		guard let model = session.findAndActivateSdaiModel(modelID: model.modelID) else {
			SDAI.raiseErrorAndContinue(.MO_NEXS, detail: "The SDAI-model does not exist.")
			return false
		}

		session.deleteSdaiModel(modelID: model.modelID)

		for schemaInstance in model.associatedWith {
			let _ = self.notifyApplicationDomainChanged(relatedTo: schemaInstance)
		}

		return true
	}

	/// ISO 10303-22 (10.7.2) Rename SDAI-model
	///
	/// This operation assigns a new name to an sdai_model.
	///
	/// - Parameters:
	///   - model: The sdai_model to rename.
	///   - modelName: The new name for the sdai_model.
	///
	/// - Returns: updated reference to the sdai_model promoted to RW if operation is successful.
	///
	public func renameSdaiModel(
		model: SDAIPopulationSchema.SdaiModel,
		modelName: SDAIParameterDataSchema.StringValue
	) -> SDAIPopulationSchema.SdaiModel?
	{
		guard let session = self.owningSession else {
			SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "An SDAI session is not open.")
			return nil
		}
		guard let repository = session.checkRepositoryOpen(relatedTo: model) else {
			return nil
		}
		guard let model = session.findAndActivateSdaiModel(modelID: model.modelID) else {
			SDAI.raiseErrorAndContinue(.MO_NEXS, detail: "The SDAI-model does not exist.")
			return nil
		}
		if let existing = repository.contents.findSdaiModel(named: modelName) {
			SDAI.raiseErrorAndContinue(.MO_DUP(existing), detail: "A duplicate SDAI-model name exists.")
			return nil
		}

		let promoted = session.promoteSdaiModelToRW(modelID: model.modelID)
		promoted.name = modelName

		return promoted
	}

}//SdaiTransactionRW

extension SDAISessionSchema.SdaiTransaction {

	/// ISO 10303-22 (10.7.3) Start read-only access
	/// 
	///  This operation makes available the instances within an SDAI-model but restricts access to them to be read-only. Any subsequent SDAI operation that attempts to modify instances within the sdai_model shall result in an error.
	/// 
	/// - Parameter model: The sdai_model to access as read-only.
	///
	/// - Returns: true if operation is successful.
	///
	public func startReadOnlyAccess(
		model: SDAIPopulationSchema.SdaiModel
	) -> Bool
	{
		guard let session = self.owningSession else {
			SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "An SDAI session is not open.")
			return false
		}
		guard let _ = session.checkRepositoryOpen(relatedTo: model) else {
			return false
		}
		if session.isDeleted(modelWithID: model.modelID) {
			SDAI.raiseErrorAndContinue(.MO_NEXS, detail: "The SDAI-model does not exist.")
			return false
		}
		if let mode = session.activeModelInfo(for:model.modelID)?.mode {
			switch mode {
				case .readOnly:
					SDAI.raiseErrorAndContinue(.MX_RO(model), detail: "The SDAI-model access is read-only.")
				case .readWrite:
					SDAI.raiseErrorAndContinue(.MX_RW(model), detail: "The SDAI-model access is read-write.")
			}
			return false
		}

		session.startReadOnlyAccess(model: model)
		return true
	}

}//SdaiTransaction


extension SDAISessionSchema.SdaiTransactionRW {
	
	/// ISO 10303-22 (10.7.4) Promote SDAI-model to read-write
	///
	/// This operation allows read-write access to instances within an sdai _model to which the Start read-only access operation had been applied or that had been automatically started with read-only access as the result of a reference to an entity instance within the SDAI-model.
	///
	/// - Parameter model: The sdai_model to which read-write access is to be allowed.
	///
	/// - Returns: updated reference to the sdai_model promoted to RW if operation is successful.
	///
	public func promoteSdaiModelToReadWrite(
		model: SDAIPopulationSchema.SdaiModel
	) -> SDAIPopulationSchema.SdaiModel?
	{
		guard let session = self.owningSession else {
			SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "An SDAI session is not open.")
			return nil
		}
		guard let _ = session.checkRepositoryOpen(relatedTo: model) else {
			return nil
		}
		if session.isDeleted(modelWithID: model.modelID) {
			SDAI.raiseErrorAndContinue(.MO_NEXS, detail: "The SDAI-model does not exist.")
			return nil
		}
		guard model.mode == .readOnly else {
			if model.mode == .readWrite {
				SDAI.raiseErrorAndContinue(.MX_RW(model), detail: "The SDA-model access is read-write.")
			}
			else{
				SDAI.raiseErrorAndContinue(.MX_NDEF(model), detail: "The SDAI-model access is not defined.")
			}
			return nil
		}

		let promoted = session.promoteSdaiModelToRW(modelID: model.modelID)
		return promoted
	}

}//SdaiTransactionRW

extension SDAISessionSchema.SdaiTransaction {

	/// ISO 10303-22 (10.7.5) End read-only access
	///
	/// This operation ends read-only access to an sdai_model. Subsequent operations on the instances contained in the SDAI-model will fail until access to the SDAI-model is started by a Start read-only access or Start read-write access operation, or after automatically starting read-only access to the SDAI-model as the result of using a reference to an entity instance within the SDAI-model.
	///
	/// - Parameter model: The sdai_model to which access is to be terminated.
	///
	/// - Returns: true if operation is successful.
	///
	@discardableResult
	public func endReadOnlyAccess(
		model: SDAIPopulationSchema.SdaiModel
	) -> Bool
	{
		guard let session = self.owningSession else {
			SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "An SDAI session is not open.")
			return false
		}
		guard let _ = session.checkRepositoryOpen(relatedTo: model) else {
			return false
		}
		if session.isDeleted(modelWithID: model.modelID) {
			SDAI.raiseErrorAndContinue(.MO_NEXS, detail: "The SDAI-model does not exist.")
			return false
		}
		guard model.mode == .readOnly else {
			if model.mode == .readWrite {
				SDAI.raiseErrorAndContinue(.MX_RW(model), detail: "The SDA-model access is read-write.")
			}
			else{
				SDAI.raiseErrorAndContinue(.MX_NDEF(model), detail: "The SDAI-model access is not defined.")
			}
			return false
		}

		session.closeSdaiModel(modelID: model.modelID)
		return true
	}

}//SdaiTransaction

extension SDAISessionSchema.SdaiTransactionRW {

	/// ISO 10303-22 (10.7.6) Start read-write access
	///
	/// This operation makes available the instances within an SDAI-model and allows to them to be read-write.
	///
	/// - Parameter model: The sdai_model to which read-write access is to be allowed.
	///
	/// - Returns: updated reference to the sdai_model promoted to RW if operation is successful.
	///
	public func startReadWriteAccess(
		model: SDAIPopulationSchema.SdaiModel
	) -> SDAIPopulationSchema.SdaiModel?
	{
		guard let session = self.owningSession else {
			SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "An SDAI session is not open.")
			return nil
		}
		guard let _ = session.checkRepositoryOpen(relatedTo: model) else {
			return nil
		}
		if session.isDeleted(modelWithID: model.modelID) {
			SDAI.raiseErrorAndContinue(.MO_NEXS, detail: "The SDAI-model does not exist.")
			return nil
		}
		if let mode = session.activeModelInfo(for:model.modelID)?.mode {
			switch mode {
				case .readOnly:
					SDAI.raiseErrorAndContinue(.MX_RO(model), detail: "The SDAI-model access is read-only.")
				case .readWrite:
					SDAI.raiseErrorAndContinue(.MX_RW(model), detail: "The SDAI-model access is read-write.")
			}
			return nil
		}

		guard let _ = session.findAndActivateSdaiModel(modelID: model.modelID) else {
			fatalError("internal logic error")
		}
		let promotedRW = session.promoteSdaiModelToRW(modelID: model.modelID)

		return promotedRW
	}


	/// ISO 10303-22 (10.7.7) End read-write access
	///
	/// This operation ends read-write access to an sdai_model. Subsequent operations on the instances contained in the SDAl-model will fail until access to the SDAI-model is started by a Start read-only access or Start read-write access operation, or after automatically starting read-only access to the SDAI-model as the result of using a reference to an entity instance within the SDAI-model. In implementations supporting transaction level 2, the implementation shall behave as if the Undo changes operation had been performed on the SDAI-model. In implementations supporting transaction level 3, if any application_ instance or scope within the SDAI-model has been created, deleted or modified since the last Commit, Abort or Start transaction read-write access operation, whichever occurred most recently, this operation shall result in the TR_RW error.
	///
	/// - Parameters:
	///   - model: The sdai_model to which access is to be terminated.
	///   - disposition: disposition for the edited SDAI-model before ending the access.
	///
	/// - Returns: true if operation is successful.
	///
	public func endReadWriteAccess(
		model: SDAIPopulationSchema.SdaiModel,
		disposition: SDAISessionSchema.SdaiTransaction.Disposition
	) -> Bool
	{
		guard let session = self.owningSession else {
			SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "An SDAI session is not open.")
			return false
		}
		guard let _ = session.checkRepositoryOpen(relatedTo: model) else {
			return false
		}
		if session.isDeleted(modelWithID: model.modelID) {
			SDAI.raiseErrorAndContinue(.MO_NEXS, detail: "The SDAI-model does not exist.")
			return false
		}
		guard model.mode == .readWrite else {
			if model.mode == .readOnly {
				SDAI.raiseErrorAndContinue(.MX_RO(model), detail: "The SDA-model access is read-only.")
			}
			else{
				SDAI.raiseErrorAndContinue(.MX_NDEF(model), detail: "The SDAI-model access is not defined.")
			}
			return false
		}

		switch disposition {
			case .commit:
				session.persistAndCloseSdaiModel(modelID: model.modelID)
			case .abort:
				session.closeSdaiModel(modelID: model.modelID)
		}
		return true
	}


}//SdaiTransactionRW


