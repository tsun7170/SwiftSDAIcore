//
//  10.3 Environment operations.swift
//  SwiftSDAIcore
//
//  Created by Yoshida on 2025/09/02.
//

import Foundation

extension SDAI {
	/// ISO 10303-22 (10.3.1) Open session
	///
  /// Initiates a new SDAI session and opens the provided repositories for schema and data access.
  ///
  /// This operation starts the implementation of SDAI, creating a new session context in which data models and schema information may be accessed and manipulated. The session will open only the repositories explicitly provided in `knownServers`; additional repositories (such as those supporting a data dictionary, if available) are not opened until a transaction is started within the session. Access to session data is immediately available upon invocation.
  ///
  /// The session behavior can be customized with several parameters to control concurrency, caching, validation, and error handling:
  /// - Parameters:
  ///   - knownServers: An array of repositories (`SDAISessionSchema.SdaiRepository`) that the session should manage and open for access.
  ///   - errorEventCallback: An optional closure to receive error events encountered during session operations. If `nil`, errors may be handled through default mechanisms.
  ///   - maxConcurrency: The maximum number of concurrent tasks the session may execute. Defaults to `ProcessInfo.processInfo.processorCount + 2`.
  ///   - maxCacheUpdateAttempts: The maximum number of attempts to update the cache in case of contention or failure. Defaults to 1000.
  ///   - maxUsedinNesting: The maximum depth for used-in reference nesting during model traversal. Defaults to 2.
  ///   - runUsedinCacheWarming: If `true`, the session will precompute and cache used-in references at startup. Defaults to `true`.
  ///   - maxValidationTaskSegmentation: Maximum segmentation size for validation tasks to improve performance on large models. Defaults to 400.
  ///   - minValidationTaskChunkSize: The minimum size of validation task chunks; smaller values may increase task parallelism but add overhead. Defaults to 8.
  ///   - validateTemporaryEntities: Whether temporary entities should be included in validation checks. Defaults to `false`.
  /// - Returns: An initialized `SDAISessionSchema.SdaiSession` configured with the provided repositories and operation parameters.
  ///
  /// - Note: SDAI sessions are scoped to the current Swift concurrency task context using `@TaskLocal`. Multiple sessions may be active at the same time in different concurrent tasks, but only one session may be active per task context (including its child tasks). The session remains available in its task context until explicitly closed using the corresponding close operation. Access to repositories and models not included in `knownServers` will not be possible until a transaction is started or those repositories are subsequently opened.
  ///
  ///- defined in: ``SDAI``
  ///
  public static func openSession(
    knownServers: [SDAISessionSchema.SdaiRepository],
    errorEventCallback: SDAISessionSchema.SdaiSession.ErrorEventCallback? = nil,
    maxConcurrency: Int = ProcessInfo.processInfo.processorCount + 2,
    maxCacheUpdateAttempts: Int = 1000,
    maxUsedinNesting: Int = 2,
    runUsedinCacheWarming: Bool = true,
    maxValidationTaskSegmentation: Int = 400,
    minValidationTaskChunkSize: Int = 8,
    validateTemporaryEntities: Bool = true,
  ) -> SDAISessionSchema.SdaiSession
  {
    let session = SDAISessionSchema.SdaiSession(
      repositories: knownServers,
      errorEventCallback: errorEventCallback,
      maxConcurrency: maxConcurrency,
      maxCacheUpdateAttempts: maxCacheUpdateAttempts,
      maxUsedinNesting: maxUsedinNesting,
      runUsedinCacheWarming: runUsedinCacheWarming,
      maxValidationTaskSegmentation: maxValidationTaskSegmentation,
      minValidationTaskChunkSize: minValidationTaskChunkSize,
      validateTemporaryEntities: validateTemporaryEntities,
    )

    return session
  }

}//SDAI

