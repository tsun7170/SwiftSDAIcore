//
//  SDAIParameterDataSchema.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/24.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

/// ISO 10303-22 (9) SDAI parameter data schema
/// 
/// The SDAI parameter data schema provides conceptual descriptions of the data that is passed as parameters or manipulated through the SDAI.   
public enum SDAIParameterDataSchema {
	
	public typealias STRING = String
	public typealias BOOLEAN = Bool
	public typealias LIST = AnyRandomAccessCollection
	public typealias Primitive = SDAIGenericType
		
	
	/// ISO 10303-22 (9.4.2) entity_instance
	public typealias EntityInstance = SDAI.EntityReference

	
	/// ISO 10303-22 (9.4.3) application_instance
	public typealias ApplicationInstance = SDAI.EntityReference
	
}
