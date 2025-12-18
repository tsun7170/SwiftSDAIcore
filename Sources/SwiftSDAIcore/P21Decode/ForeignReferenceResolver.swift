//
//  ForeignReferenceResolver.swift
//  
//
//  Created by Yoshida on 2021/05/13.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension P21Decode {
	
	/// to resolve the foreign references, called from the decoder when the decoder encounters the foreign references.
	open class ForeignReferenceResolver: @unchecked Sendable {
		public typealias ParameterRecoveryResult = P21Decode.ExchangeStructure.ParameterRecoveryResult
		
		public var error: String?
		
		public init() {}
		
		/// resolve the resource as a value reference
		/// - Parameter valueReference: resource specification
		/// - Returns: resolved value reference
		open func resolve(valueReference: ExchangeStructure.Resource) -> ExchangeStructure.Parameter? {
			self.error = "foreign value reference(\(valueReference)) can not be resolved"
			return nil
		}		
		
		/// resolve the resource as an entity reference
		/// - Parameter entityReference: resource specification
		/// - Returns: resolved complex entity
		open func resolve(entityReference: ExchangeStructure.Resource) -> ParameterRecoveryResult<SDAI.ComplexEntity?> {
			self.error = "foreign entity reference(\(entityReference)) can not be resolved"
			return .failure
		}
		
		/// resolve the simple record as a user defined entity
		/// - Parameter simpleRec: simple record specification
		/// - Returns: resolved user defined partial entity
		open func recover(userDefinedEntity simpleRec:ExchangeStructure.SimpleRecord) -> SDAI.PartialEntity? {
			self.error = "foreign user defined entity(\(simpleRec)) can not be resolved"
			return nil
		}
		
		/// convert a user defined entity specification from internal mapping to external mapping
		/// - Parameters:
		///   - internalMapping: internal mapping specification
		///   - dataSection: the data section containing the user defined entity specification
		/// - Returns: converted external mapping specification
		open func convertToExternalMapping(from internalMapping:ExchangeStructure.SimpleRecord, dataSection: ExchangeStructure.DataSection) -> ExchangeStructure.SubsuperRecord? {
			self.error = "foreign user defined entity(\(internalMapping)) can not be resolved"
			return nil
		}
		
	}	
}
