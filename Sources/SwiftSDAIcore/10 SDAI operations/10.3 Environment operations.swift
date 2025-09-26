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
		errorEventCallback: SDAISessionSchema.SdaiSession.ErrorEventCallback? = nil
	) -> SDAISessionSchema.SdaiSession
	{
		let session = SDAISessionSchema.SdaiSession(
			repositories: knownServers,
			errorEventCallback: errorEventCallback)

		return session
	}

}//SDAI
