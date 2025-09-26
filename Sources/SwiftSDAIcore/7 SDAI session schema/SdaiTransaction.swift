//
//  SdaiTransaction.swift
//  SwiftSDAIcore
//
//  Created by Yoshida on 2025/08/28.
//  Copyright © 2025 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAISessionSchema {

	/// ISO 10303-22 (7.4.5) sdai_transaction (read-only)
	///
	/// An sdai_transaction describes the currently available access to data (RW or RO) within an sdai_session. Transaction shall not exist outside of a session and only one transaction shall be active at any given time. Transactions are required only of SDAI implementations supporting transaction level 3 (see 13.1.1).
	///
	/// This base implementation class SdaiTransaction represents read-only (RO) transaction.
	///
	public class SdaiTransaction: SDAI.Object, @unchecked Sendable
	{
		public enum Disposition: Sendable {
			case commit
			case abort
		}

		//MARK: Attribute definitions:

		/// the read-only or read-write access provided by the transaction within the sdai_session.
		public var mode: AccessType { .readOnly }

		/// the sdai_session within which the transaction is active.
		public fileprivate(set) unowned var owningSession: SdaiSession?




		//MARK: swift language binding

		internal init(owningSession: SdaiSession) {
			self.owningSession = owningSession
		}

		internal func preAction()  {}

		internal func postAction()
		{
			guard let session = self.owningSession
			else { fatalError("internal logic error") }

			session.revertAndCloseAllModels()
			session.revertAndCloseAllSchemaInstances()
		}

		internal func performCommit(closingAccesses: Bool) {}

		internal func performAbort(closingAccesses: Bool) {}

	}//class

	//MARK: - Read-Only Transaction
	/// ISO 10303-22 (7.4.5) sdai_transaction (read-only)
	///
	/// An sdai_transaction describes the currently available access to data (RW or RO) within an sdai_session. Transaction shall not exist outside of a session and only one transaction shall be active at any given time. Transactions are required only of SDAI implementations supporting transaction level 3 (see 13.1.1).
	///
	/// This implementation class SdaiTransactionRO represents read-only (RO) transaction.
	///
	public final class SdaiTransactionRO: SdaiTransaction, @unchecked Sendable {

	}

	//MARK: - Read-Write Transaction

	/// ISO 10303-22 (7.4.5) sdai_transaction (read-write)
	///
	/// An sdai_transaction describes the currently available access to data (RW or RO) within an sdai_session. Transaction shall not exist outside of a session and only one transaction shall be active at any given time. Transactions are required only of SDAI implementations supporting transaction level 3 (see 13.1.1).
	///
	/// This implementation class SdaiTransactionRW represents read-write (RW) transaction.
	///
	public final class SdaiTransactionRW: SdaiTransaction, @unchecked Sendable {
		//MARK: swift language binding

		public override var mode: AccessType { .readWrite }

		public func notifyApplicationDomainChanged(
			relatedTo schemaInstance: SDAIPopulationSchema.SchemaInstance
		) -> SDAIPopulationSchema.SchemaInstance
		{
			guard let session = self.owningSession else {
				SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "An SDAI session is not open.")
				return schemaInstance
			}

			let promotedSI = session.promoteSchemaInstanceToRW(
				schemaInstanceID: schemaInstance.schemaInstanceID)

			for model in promotedSI.associatedModels {
				model.notifyApplicationDomainChanged(relatedTo: promotedSI)
			}
			promotedSI.resetValidationRecords()
			return promotedSI
		}

		internal override func performCommit(closingAccesses: Bool) {
			guard let session = self.owningSession
			else { fatalError("internal logic error") }

			if closingAccesses {
				session.persistAndCloseAllModels()
				session.persistAndCloseAllSchemaInstances()
			}
			else {
				session.persistAndContinueAllModels()
				session.persistAndContinueAllSchemaInstances()
			}
		}

		internal override func performAbort(closingAccesses: Bool) {
			guard let session = self.owningSession
			else { fatalError("internal logic error") }

			if closingAccesses {
				session.revertAndCloseAllModels()
				session.revertAndCloseAllSchemaInstances()
			}
			else {
				session.revertAndContinueAllModels()
				session.revertAndContinueAllSchemaInstances()
			}
		}

//		internal override func preAction()  {
//
//		}
//
//		internal override func postAction()  {
//
//		}

	}//class
}

//MARK: - SdaiSession transaction supports

extension SDAISessionSchema.SdaiSession {
	public typealias SdaiTransaction = SDAISessionSchema.SdaiTransaction
	public typealias Disposition = SDAISessionSchema.SdaiTransaction.Disposition

	internal func perform<T: SdaiTransaction>(
		transaction: T,
		async action:(_ transaction: T) async -> Disposition ) async
	{
		self.activeTransaction = transaction
		transaction.preAction()

		await SDAISessionSchema.$activeSession
			.withValue(self) {
				let disposition = await action(transaction)

				switch disposition {
					case .commit: transaction.performCommit(closingAccesses: true)
					case .abort: transaction.performAbort(closingAccesses: true)
				}
			}//withValue

		transaction.postAction()
		transaction.owningSession = nil
		self.activeTransaction = nil
	}

}
