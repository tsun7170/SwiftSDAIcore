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
		public enum Disposition<Output: Sendable>: Sendable {
			case commit(Output)
			case abort

			public static var commit: Disposition<Void> {
				.commit(Void())
			}
		}

		//MARK: Attribute definitions:

		/// the read-only or read-write access provided by the transaction within the sdai_session.
		public var mode: AccessType { .readOnly }
    
    /// to indicate the possibility of SDAI-models to be in read-write access mode.
    internal var modelsMayBeMutable: Bool { false }

		/// the sdai_session within which the transaction is active.
		public fileprivate(set) unowned var owningSession: SdaiSession?




		//MARK: swift language binding
    internal typealias ID = ObjectIdentifier

    internal var id: ID { ObjectIdentifier(self) }


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

    // MARK: transaction termination related
    public func terminate() {
      self.terminationHandler?()
    }

    internal var terminationHandler: (() -> Void)?

    //MARK: sdai-model reference cache related
    internal func lookupModelCache(
      modelID: SDAIModelID) -> SdaiModel?
    {
      return nil
    }

    internal func updateModelCache(
      modelID: SDAIModelID,
      value: SdaiModel?)
    {}

    //MARK: complex entity reference cache related
    internal func lookupComplexCache(
      complexID: ComplexEntityID,
      modelID: SDAIModelID) -> SDAI.ComplexEntity?
    {
      return nil
    }

    internal func updateComplexCache(
      complexID: ComplexEntityID,
      modelID: SDAIModelID,
      value: SDAI.ComplexEntity?)
    {}

	}//class

	//MARK: - Read-Only Transaction
	/// ISO 10303-22 (7.4.5) sdai_transaction (read-only)
	///
	/// An sdai_transaction describes the currently available access to data (RW or RO) within an sdai_session. Transaction shall not exist outside of a session and only one transaction shall be active at any given time. Transactions are required only of SDAI implementations supporting transaction level 3 (see 13.1.1).
	///
	/// This implementation class SdaiTransactionRO represents read-only (RO) transaction.
	///
	public class SdaiTransactionRO: SdaiTransaction, @unchecked Sendable
	{
    //MARK: thread local cache related
    private let CACHE_KEY = "threadLocalCache.SdaiTransactionRO.SDAISessionSchema.SwiftSDAIcore"

    private func threadLocalCache(
      transactionID: SdaiTransaction.ID) -> ThreadLocalCache
    {
      let threadDict = Thread.current.threadDictionary

      if let cache = threadDict[CACHE_KEY] as? ThreadLocalCache,
         cache.transactionID == transactionID {
        return cache
      }

      let cache = ThreadLocalCache(transactionID: transactionID)
      threadDict[CACHE_KEY] = cache
      return cache
    }

    internal override func postAction() {
      let threadDict = Thread.current.threadDictionary
      threadDict[CACHE_KEY] = nil

      super.postAction()
    }

    internal override func lookupModelCache(
      modelID: SDAIModelID) -> SdaiModel?
    {
      self.threadLocalCache(transactionID: self.id)
        .lookup(modelID: modelID)
    }

    internal override func updateModelCache(
      modelID: SDAIModelID,
      value: SdaiModel?)
    {
      self.threadLocalCache(transactionID: self.id)
        .update(modelID: modelID, value: value)
    }

    internal override func lookupComplexCache(
      complexID: ComplexEntityID,
      modelID: SDAIModelID) -> SDAI.ComplexEntity?
    {
      self.threadLocalCache(transactionID: self.id)
        .lookup(complexID: complexID, modelID: modelID)
    }

    internal override func updateComplexCache(
      complexID: ComplexEntityID,
      modelID: SDAIModelID,
      value: SDAI.ComplexEntity?)
    {
      self.threadLocalCache(transactionID: self.id)
        .update(complexID: complexID, modelID: modelID, value: value)
    }


    private final class ThreadLocalCache {
      let transactionID: SdaiTransaction.ID
      let label: String

      init(transactionID: SdaiTransaction.ID) {
        self.transactionID = transactionID
        self.label = Task.name ?? "<unnamed>"
      }

      //MARK: sdai-model cache related
      private var modelCache: [SDAIModelID:SdaiModel] = [:]
      private var modelCacheStatistics = CacheStatistics()

      func lookup(
        modelID: SDAIModelID) -> SdaiModel?
      {
        let result = modelCache[modelID]
        modelCacheStatistics.update(with: result)
        return result
      }

      func update(modelID: SDAIModelID, value: SdaiModel?)
      {
        modelCache[modelID] = value
      }

      //MARK: complex entity cache related
      private var complexCache: [PersistentComplexKey:SDAI.ComplexEntity] = [:]
      private var complexCacheStatistics = CacheStatistics()

      func lookup(
        complexID: ComplexEntityID,
        modelID: SDAIModelID) -> SDAI.ComplexEntity?
      {
        let complexKey = PersistentComplexKey(
          complexID: complexID, modelID: modelID)

        let result = complexCache[complexKey]
        complexCacheStatistics.update(with: result)
        return result
      }

      func update(complexID: ComplexEntityID, modelID: SDAIModelID, value: SDAI.ComplexEntity?)
      {
        let complexKey = PersistentComplexKey(
          complexID: complexID, modelID: modelID)

        complexCache[complexKey] = value
      }

      private struct PersistentComplexKey: Hashable {
        let complexID: ComplexEntityID
        let modelID: SDAIModelID
      }

      //MARK: statistics presentation
      var statisticsDescription: String {
        """
        SDAI Thread Local Cache Statistics [\(self.label)]
         complex cache[\(self.complexCache.count)]:\t \(self.complexCacheStatistics)
         model   cache[\(self.modelCache.count  )]:\t \(self.modelCacheStatistics)
        """
      }

      deinit {
        loggerSDAI.info("\n\(self.statisticsDescription)\n")
      }


      private struct CacheStatistics: CustomStringConvertible {
        var numLookup: Int = 0
        var numHit: Int = 0

        mutating func update<T>(with result: T?) {
          numLookup += 1
          if result != nil { numHit += 1 }
        }


        var description: String {
          let str = "#lookups: \(numLookup), #hits: \(numHit), %hit rate: \((Double(numHit * 100)/Double(numLookup)).formatted())%"
          return str
        }
      }
    }//class

  }//class

	//MARK: - Read-Write Transaction

	/// ISO 10303-22 (7.4.5) sdai_transaction (read-write)
	///
	/// An sdai_transaction describes the currently available access to data (RW or RO) within an sdai_session. Transaction shall not exist outside of a session and only one transaction shall be active at any given time. Transactions are required only of SDAI implementations supporting transaction level 3 (see 13.1.1).
	///
	/// This implementation class SdaiTransactionRW represents read-write (RW) transaction.
	///
	public final class SdaiTransactionRW: SdaiTransaction, @unchecked Sendable
	{
		//MARK: swift language binding

		public override var mode: AccessType { .readWrite }

    internal override var modelsMayBeMutable: Bool { true }

		public func notifyApplicationDomainChanged(
			relatedTo schemaInstance: SDAIPopulationSchema.SchemaInstance	// in RW mode
		) async
		{
			guard let session = self.owningSession else {
				SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "An SDAI session is not open.")
				return
			}

			guard session.activeSchemaInstanceInfo(for: schemaInstance.schemaInstanceID)?.mode == .readWrite else {
				SDAI.raiseErrorAndContinue(.SX_NRW(schemaInstance), detail: "The schema instance is not in read-write mode.")
				return
			}

			for model in schemaInstance.associatedModels {
        await model.notifyApplicationDomainChanged(relatedTo: schemaInstance)
			}
			schemaInstance.resetValidationRecords()
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


//MARK: - Schema Instance Read-Write Transaction for Validations

/// Subset of ISO 10303-22 (7.4.5) sdai_transaction (read-write) for validation activities
///
/// An sdai_transaction describes the currently available access to data (RW or RO) within an sdai_session. Transaction shall not exist outside of a session and only one transaction shall be active at any given time. Transactions are required only of SDAI implementations supporting transaction level 3 (see 13.1.1).
///
/// This implementation class SdaiTransactionVA represents a subset of read-write (RW) transaction specifically tailored for schema instance validations. Only the read-write operations for schema instances are allowed.
///
public final class SdaiTransactionVA: SdaiTransactionRO, @unchecked Sendable
{
  //MARK: swift language binding

  public override var mode: AccessType { .readWrite }

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

}//class
}

//MARK: - SdaiSession transaction supports

extension SDAISessionSchema.SdaiSession {
	public typealias SdaiTransaction = SDAISessionSchema.SdaiTransaction
	public typealias Disposition = SDAISessionSchema.SdaiTransaction.Disposition

	internal func perform<T: SdaiTransaction, Output: Sendable>(
		transaction: T,
		async action: @Sendable @escaping (_ transaction: T) async -> Disposition<Output>
	) async -> Disposition<Output>
	{
		self.activeTransaction = transaction

    let task = Task(name: "\(type(of: transaction))") {
      transaction.preAction()

      let disposition = await SDAISessionSchema.$activeSession
        .withValue(self)
      {
        let disposition =  await action(transaction)

        self.terminateCachingTasks()
        await self.toCompleteCachingTasks()

        switch disposition {
          case .commit: transaction.performCommit(closingAccesses: true)
          case .abort: transaction.performAbort(closingAccesses: true)
        }

        return disposition
      }//withValue

      transaction.postAction()
      return disposition
    }//Task

    transaction.terminationHandler = {
      task.cancel()
    }
    let disposition = await task.value

		transaction.owningSession = nil
		self.activeTransaction = nil

		return disposition
	}

}

