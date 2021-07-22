//
//  ValidationMonitor.swift
//  
//
//  Created by Yoshida on 2021/06/19.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAIPopulationSchema {

	open class ValidationMonitor {
		public init() {}
		
		open func willValidate(globalRules: AnySequence<SDAIDictionarySchema.GlobalRule>) {}
		open func willValidate(uniquenessRules:AnySequence<SDAIDictionarySchema.UniquenessRule>) {}
		open func willValidateWhereRules(for complexEntites: AnySequence<SDAI.ComplexEntity>) {}
		
		open func didValidateGlobalRule(for schemaInstance: SchemaInstance,  result: SDAI.GlobalRuleValidationResult) {}
		open func didValidateUniquenessRule(for schemaInstance: SchemaInstance, result: SDAI.UniquenessRuleValidationResult) {}
		open func didValidateWhereRule(for complexEntity: SDAI.ComplexEntity, result: [SDAI.WhereLabel : SDAI.LOGICAL]) {}
		
		open var terminateValidation: Bool { false }
	}

}
