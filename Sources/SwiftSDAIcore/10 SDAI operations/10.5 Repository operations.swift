//
//  10.5 Repository operations.swift
//  SwiftSDAIcore
//
//  Created by Yoshida on 2025/09/04.
//

import Foundation

extension SDAISessionSchema.SdaiTransactionRW {

	/// ISO 10303-22 (10.5.1) Create SDAI-model
	/// 
	/// This operation establishes a new SdaiModel within which entity instances can be created and accessed. The new created SdaiModel has no access mode associated with it.
	///
	/// - Parameters:
	///   - repository: The repository in which the SDA-model is to be created.
	///   - modelName: The name of the new SdaiModel.
	///   - schema: The schema upon which the SdaiModel shall be based.
	///
	/// - Returns: The newly created SdaiModel.
	/// 
	public func createSdaiModel(
		repository: SDAISessionSchema.SdaiRepository,
		modelName: SDAISessionSchema.STRING,
		schema: SDAIDictionarySchema.SchemaDefinition
	) -> SDAIPopulationSchema.SdaiModel?
	{
		guard let session = self.owningSession else {
			SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "An SDAI session is not open.")
			return nil
		}
		guard let activeRepo = session.activeServers[repository.name],
					activeRepo == repository else {
			SDAI.raiseErrorAndContinue(.RP_NOPN(repository), detail: "The repository is not open")
			return nil
		}
		if let existingModel = repository.contents.findSdaiModel(named: modelName) {
			SDAI.raiseErrorAndContinue(.MO_DUP(existingModel), detail: "A duplicate SDAI-model name exists")
			return nil
		}

		let model = SDAIPopulationSchema.SdaiModel(
			repository: repository,
			modelName: modelName,
			schema: schema)

		return model
	}


	/// ISO 10303-22 (10.5.2) Create schema instance
	/// 
	/// This operation establishes a new schema instance.
	///
	/// - Parameters:
	///   - repository: The repository in which the schema instance is to be created.
	///   - name: The name of the new schema instance.
	///   - schema: The schema upon which the schema instance shall be based.
	///
	/// - Returns: The newly created schema instance.
	/// 
	public func createSchemaInstance(
		repository: SDAISessionSchema.SdaiRepository,
		name: SDAISessionSchema.STRING,
		schema: SDAIDictionarySchema.SchemaDefinition
	) -> SDAIPopulationSchema.SchemaInstance?
	{
		guard let session = self.owningSession else {
			SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "An SDAI session is not open.")
			return nil
		}
		guard let activeRepo = session.activeServers[repository.name],
					activeRepo == repository else {
			SDAI.raiseErrorAndContinue(.RP_NOPN(repository), detail: "The repository is not open")
			return nil
		}
		if let existingSI = repository.contents.findSchemaInstance(named: name) {
			SDAI.raiseErrorAndContinue(.SI_DUP(existingSI), detail: "A duplicate schema instance name exists.")
			return nil
		}

		let schemaInstance = SDAIPopulationSchema.SchemaInstance(
			repository: repository,
			name: name,
			schema: schema,
			session: session)

		session.activateNew(schemaInstance: schemaInstance)

		return schemaInstance
	}



}//SdaiTransactionRW


extension SDAISessionSchema.SdaiTransaction {

	/// ISO 10303-22 (10.5.3) Close repository
	///
	/// This operation closes an SdaiRepository that has been previously opened.
	/// SDAI-models and schema instances within the repository are no longer available for access.
	///
	/// - Parameters:
	///   - repository: The repository to be closed.
	///   - disposition: disposition on the current transaction before performing the close repository operation.
	///
	public func close(
		repository: SDAISessionSchema.SdaiRepository,
		disposition: SDAISessionSchema.SdaiTransaction.Disposition
	)
	{
		guard let session = self.owningSession else {
			SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "An SDAI session is not open.")
			return
		}
		guard let activeRepo = session.activeServers[repository.name],
					activeRepo == repository else {
			SDAI.raiseErrorAndContinue(.RP_NOPN(repository), detail: "The repository is not open")
			return
		}

		switch disposition {
			case .commit:
				self.commit()
			case .abort:
				self.abort()
		}

		session.close(repository: repository)
	}

}//SdaiTransaction
