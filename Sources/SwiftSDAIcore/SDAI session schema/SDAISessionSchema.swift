//
//  SDAISessionSchema.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/24.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

public enum SDAISessionSchema {
	public typealias STRING = String
	public typealias INTEGER = Int
	public typealias LIST = Array
	public typealias SET = Set
	public typealias BOOLEAN = Bool
	public typealias TimeStamp = Date
	
	public enum AccessType {
		case readOnly, readWrite	
	}
	
	
	
	
	
	public class SdaiTransaction: SDAI.Object {
		
	}
	public class ErrorEvent: SDAI.Object {
		
	}
}

