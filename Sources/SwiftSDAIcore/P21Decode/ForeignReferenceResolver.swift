//
//  File.swift
//  
//
//  Created by Yoshida on 2021/05/13.
//

import Foundation

extension P21Decode {
	
	public class ForeignReferenceResolver {
		public typealias ParameterRecoveryResult = P21Decode.ExchangeStructure.ParameterRecoveryResult
		
		public var error: String?
		
		public init() {}
		
		open func resolve(valueReference: ExchangeStructure.Resource) -> ExchangeStructure.Parameter? {
			self.error = "foreign value reference(\(valueReference)) can not be resolved"
			return nil
		}		
		
		open func resolve(entityReference: ExchangeStructure.Resource) -> ParameterRecoveryResult<SDAI.ComplexEntity?> {
			self.error = "foreign entity reference(\(entityReference)) can not be resolved"
			return .failure
		}
		
		open func recover(userDefinedEntity simpleRec:ExchangeStructure.SimpleRecord) -> SDAI.PartialEntity? {
			self.error = "foreign user defined entity(\(simpleRec)) can not be resolved"
			return nil
		}
		
		open func convertToExternalMapping(from internalMapping:ExchangeStructure.SimpleRecord, dataSection: ExchangeStructure.DataSection) -> ExchangeStructure.SubsuperRecord? {
			self.error = "foreign user defined entity(\(internalMapping)) can not be resolved"
			return nil
		}
		
	}	
}
