//
//  SDAISessionSchema.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/24.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

/// ISO 10303-22 (7) SDAI session schema
///  
/// The SDAISessionSchema defines the structure of the data required to manage an SDAI session.
/// The current state of an SDAI session and its interaction with the SDAI implementation such as access modes, transactions, repositories, and session erros are made available b a population of the SDAISessionSchema.
/// As with all schemas available in the data dictionary, the items interfaced into the SDAISessionSchema from the SDAI population schema, SDAI parameter data schema and SDAI dictionary schema through the SDAI population schema shall be resolved into the SDAISessionSchema (see A.1.1).
///  
/// The SDAISessionSchema describes a single application, single user view of information about an SDAI session.
/// The SDAI implementation shall make the instances of SDAI session schema entity data types not interfaced from another schema available in one SDAI-model.
/// That SDAI-model shall be associated with one schema instane.
/// Both the SDAI-model and schema instance shall be based upon the SDAI session schema.
/// The SdaiModel.name of the SDAI-model shall be 'SDAI_SESION_SCHEMA_DATA'.
/// The SchamaInstance.name of the schema instance shall be 'SDAI_SESSION_SCHEMA_INSTANCE'.
/// The SDAI-model and shcema instance need not persist beyond the end of session. 
public enum SDAISessionSchema {
	public typealias STRING = String
	public typealias INTEGER = Int
	public typealias LIST = Array
	public typealias SET = Set
	public typealias BOOLEAN = Bool
	
	
	/// ISO 10303-22 (7.3.1) access_type
	/// 
	/// An AccessType specifies either read-only or read-write access for an SdaiTranaction or SdaiModel. 
	public enum AccessType {
		case readOnly, readWrite	
	}
	
	/// ISO 10303-22 (7.3.3) time_stamp
	/// 
	/// A TimeStamp is date and time specification.
	/// The contents of the string shall correspond to the extended format for the complete calender data as specified in 5.2.1.1 of ISO 8601.
	/// The date and time shall be separated by the capital letter T as specified in 5.4.1 of ISO 8601.
	/// The alternate formats of 5.3.1.1 and 5.3.3 permit the optional includion of a time zone specifier. 
	public typealias TimeStamp = Date
	
	
	
	
	public class SdaiTransaction: SDAI.Object {
		
	}
	public class ErrorEvent: SDAI.Object {
		
	}
}

