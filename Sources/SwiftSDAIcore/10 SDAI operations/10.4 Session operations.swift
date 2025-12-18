//
//  10.4 Session operations.swift
//  SwiftSDAIcore
//
//  Created by Yoshida on 2025/09/02.
//

import Foundation

extension SDAISessionSchema.SdaiSession {

	/// ISO 10303-22 (10.4.1) Record error
	///
	/// This operation appends an error event to the SDAI session errors record.
	///
	public func recordError(
		error: SDAI.ErrorIndicator,
		description: SDAISessionSchema.STRING,
		functionID: StaticString=#function
	)
	{
		guard self.recordingActive else {
			SDAI.raiseErrorAndContinue(.ER_NSET, detail: "SdaiSession.recordingActive = FALSE")
			return
		}

		let errorEvent = SDAISessionSchema.ErrorEvent(
			errorIndicator: error, functionID: functionID, detail: description)

		self.append(errorEvent: errorEvent)
		self.errorEventCallback?(errorEvent, #isolation)
    loggerSDAI.error("\(errorEvent.description)")
	}


	/// ISO 10303-22 (10.4.2) Start event recording
	///
	/// This operation enables, or re-enables, event recording by SDAI operations in the SDAI session. Any error events previously recorded during the session remain in the error event record and any new error events recorded are appended to the error event record.
	/// 
	/// - Returns: The SDAI implementation returns TRUE if event recording is supported and enabled; FALSE if not supported.
	///
	public func startEventRecording() -> Bool
	{
		self.recordingActive = true
		return true
	}


	/// ISO 10303-22 (10.4.3) Stop event recording
	/// 
	/// This operation disables event recording for an SDAI session.
	/// 
	/// - Returns: TRUE if event recording is supported and disabled; FALSE if not supported.
	///
	public func stopEventRecording() -> Bool
	{
		self.recordingActive = false
		return true
	}


	/// ISO 10202-22 (10.4.4) Close session
	///
	/// This operation terminates the SDAI session.
	/// Further SDAI operations can be processed only after a subsequent Open session operation.
	/// In implementations supporting transaction level 1 or 2 (see 13.1.1), the implementation shall behave as if the Close repository operation is performed on each repository in session.activeServers.
	/// In an implementation supporting transaction level 3, the implementation shall behave as if the End transaction access and abort operation is performed if a transaction existed in the session followed by the Close repository operation on each open repository regardless of whether a transaction existed or not.
	///
	public func closeSession()
	{
		for repository in self.activeServers.values {
			self.close(repository: repository)
		}

		for repository in self.knownServers.values {
			repository.dissociate(from: self)
		}

		assert(self.knownServers.isEmpty)
	}


	/// ISO 10303-22 (10.4.5) Open repository
	///
	/// This operation makes the contents of a repository available for subsequent access.
	///
	public func open(repository: SDAISessionSchema.SdaiRepository)
	{
		guard activeServers[repository.name] == nil else {
			SDAI.raiseErrorAndContinue(.RP_OPN(repository), detail: "The repository is already open.")
			return
		}

		self._open(repository: repository)
	}




	/// ISO 10303-22 (10.4.6) Start transaction read-write access/
	 /// (10.4.10) End transaction access and commit/
	 /// (10.4.11) End transaction access and abort
	 ///
	 /// (10.4.6)This operation specifies the beginning of a sequence of operations in a session for which access is provided to entity_instances such that changes can be made to those instances.
	 ///
	 /// (10.4.10) This operation ends the sequence of operations started by the Start transaction read-write access or Start transaction read-only access operation. The implementation shall behave as if the Commit operation is performed before ending the transaction access. Further operations accessing entity instances within the session may be processed only after a subsequent Start transaction read-write access or Start transaction read-only access operation.
	 ///
	 /// (10.4.11) This operation ends the sequence of operations started by the Start transaction read-write access or Start transaction read-only access operation. The implementation shall behave as if the Abort operation is performed before ending the transaction access. Further operations accessing entity instances within the session may be processed only after a subsequent Start transaction read-write access or Start transaction read-only access operation.
	 ///
	@discardableResult
	public func performTransactionRW<Output: Sendable>(
		output: Output.Type = Void.self,
		action:@Sendable @escaping (_ transaction: SDAISessionSchema.SdaiTransactionRW) async -> Disposition<Output> ) async -> Disposition<Output>
	 {
		 if let activeTransaction = self.activeTransaction {
			 SDAI.raiseErrorAndContinue(.TR_EXS(activeTransaction), detail: "A transaction has already been started.")
			 return .abort
		 }

		 let transaction = SDAISessionSchema.SdaiTransactionRW(owningSession: self)
		 return await self.perform(transaction: transaction, async: action)
	 }


	 /// ISO 10303-22 (10.4.7) Start transaction read-only access/
	 /// (10.4.10) End transaction access and commit/
	 /// (10.4.11) End transaction access and abort
	 ///
	 /// (10.4.7)This operation specifies the beginning of a sequence of operations in a session for which access is provided to entity_instances such that no changes can be made to those instances.
	 ///
	 /// (10.4.10) This operation ends the sequence of operations started by the Start transaction read-write access or Start transaction read-only access operation. The implementation shall behave as if the Commit operation is performed before ending the transaction access. Further operations accessing entity instances within the session may be processed only after a subsequent Start transaction read-write access or Start transaction read-only access operation.
	 ///
	 /// (10.4.11) This operation ends the sequence of operations started by the Start transaction read-write access or Start transaction read-only access operation. The implementation shall behave as if the Abort operation is performed before ending the transaction access. Further operations accessing entity instances within the session may be processed only after a subsequent Start transaction read-write access or Start transaction read-only access operation.
	 ///
	@discardableResult
	public func performTransactionRO<Output: Sendable>(
		output: Output.Type = Void.self,
		action:@Sendable @escaping (_ transaction: SDAISessionSchema.SdaiTransactionRO) async -> Disposition<Output> ) async -> Disposition<Output>
	 {
		 if let activeTransaction = self.activeTransaction {
			 SDAI.raiseErrorAndContinue(.TR_EXS(activeTransaction), detail: "A transaction has already been started.")
			 return .abort
		 }

		 let transaction = SDAISessionSchema.SdaiTransactionRO(owningSession: self)
		 return await self.perform(transaction: transaction, async: action)
	 }

  /// EXTENSION to: ISO 10303-22 (10.4.6) Start transaction limited read-write access for schema instance validations/
  /// (10.4.10) End transaction access and commit/
  /// (10.4.11) End transaction access and abort
  ///
  /// EXTENSION to:(10.4.6)This operation specifies the beginning of a sequence of operations in a session for which access is provided to schema_instances such that changes can be made to those instances.
  ///
  /// (10.4.10) This operation ends the sequence of operations started by the Start transaction read-write access or Start transaction read-only access operation. The implementation shall behave as if the Commit operation is performed before ending the transaction access. Further operations accessing entity instances within the session may be processed only after a subsequent Start transaction read-write access or Start transaction read-only access operation.
  ///
  /// (10.4.11) This operation ends the sequence of operations started by the Start transaction read-write access or Start transaction read-only access operation. The implementation shall behave as if the Abort operation is performed before ending the transaction access. Further operations accessing entity instances within the session may be processed only after a subsequent Start transaction read-write access or Start transaction read-only access operation.
  ///
  @discardableResult
  public func performTransactionVA<Output: Sendable>(
    output: Output.Type = Void.self,
    action:@Sendable @escaping (_ transaction: SDAISessionSchema.SdaiTransactionVA) async -> Disposition<Output> ) async -> Disposition<Output>
  {
    if let activeTransaction = self.activeTransaction {
      SDAI.raiseErrorAndContinue(.TR_EXS(activeTransaction), detail: "A transaction has already been started.")
      return .abort
    }

    let transaction = SDAISessionSchema.SdaiTransactionVA(owningSession: self)
    return await self.perform(transaction: transaction, async: action)
  }


}//SdaiSession

extension SDAISessionSchema.SdaiTransaction {


	/// ISO 10303-22 (10.4.8) Commit
	 ///
	 /// This operation makes persistent all changes to the contents, SDAI-models and schema instances, of all open repositories made since the last Start transaction with read-write access, Commit of Abort operation, whichever operation occurred most recently.
	 /// - The existing read-write transaction continues to be active.
	 /// - This operation performs no function in the case where the current transaction is read-only.
	 /// - This operation updates or sets the change_date attribute of any schema instance or SDAl-model that has been modified or created.
	 ///
	public func commit() {
		guard let _ = self.owningSession else {
			SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "An SDAI session is not open.")
			return
		}

		self.performCommit(closingAccesses: false)
	}


	 /// ISO 10303-22 (10.4.9) Abort
	 ///
	 /// This operation restores the condition of the contents, SDAI-models and schema instances, of all open repositories to that which existed at the time of the last Start transaction read-write or Commit operation whichever operation occurred most recently. All deleted instances are restored, all created instances no longer exist and all modifications to instances are lost.
	 /// - The existing read-write transaction continues to be active.
	 /// - This operation performs no function in the case where the current transaction is read-only.
	 ///
	public func abort() {
		guard let _ = self.owningSession else {
			SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "An SDAI session is not open.")
			return
		}

		self.performAbort(closingAccesses: false)
	}



}//SdaiTransaction
