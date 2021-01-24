//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation

extension SDAI {
	//MARK: - support functions
	public static func UNWRAP<T>(_ val:T?) -> T { return val! }
	public static func UNWRAP<T>(_ val:T) -> T { return val }
	
	public static func FORCE_OPTIONAL<T>(_ val:T?) -> T? { return val }
	public static func FORCE_OPTIONAL<T>(_ val:T) -> T? { return val }
	
	public static func IS_TRUE<T: SDAILogicalType>(_ logical: T?) -> Bool { logical?.isTRUE ?? false }
}

