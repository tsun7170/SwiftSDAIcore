//
//  File.swift
//  
//
//  Created by Yoshida on 2021/03/14.
//

import Foundation

extension SDAI {
	public static func cardinal<T:SDAILogicalType>(logical:T) -> Int {
		if let bool = logical.possiblyAsSwiftBool {
			switch bool {
			case false:	return 0
			case true:	return 2
			}
		}
		return 1
	}
}
