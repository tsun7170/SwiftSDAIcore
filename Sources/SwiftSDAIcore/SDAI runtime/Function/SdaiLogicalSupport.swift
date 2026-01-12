//
//  SdaiLogicalSupport.swift
//  
//
//  Created by Yoshida on 2021/03/14.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAI {
	/// gives cardinal representation for the SDAI.LogicalType
	/// - TRUE: 2
	/// - UNKNOWN: 1
	/// - FALSE: 0
	///
	/// - Parameter logical: logical value
	/// - Returns: cardinal integer
	/// 
	public static func cardinal<T:SDAI.LogicalType>(logical:T) -> Int {
		if let bool = logical.possiblyAsSwiftBool {
			switch bool {
			case false:	return 0
			case true:	return 2
			}
		}
		return 1
	}
}
