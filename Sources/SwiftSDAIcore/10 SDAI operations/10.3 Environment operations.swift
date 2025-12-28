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
	/// This operation initiates the SDAI implementation and commences a new SDAI session. The repository containing the session schema instance and data is opened by this operation and only the Close session operation can close that repository. Access to the session data is available immediately. In implementations supporting access to a data dictionary, the repositories and SDAI-models containing the data dictionary information are not opened by this operation and are not accessible until a transaction has been started.
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
    validateTemporaryEntities: Bool = false,
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
