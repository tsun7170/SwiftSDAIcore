//
//  P21Decode.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/31.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

public enum P21Decode {
	public typealias EntityInstanceName = Int
	public typealias ValueInstanceName = Int
	public typealias ConstantName = String
	public typealias SchemaName = ExchangeStructure.HeaderSection.FILE_SCHEMA.SCHEMA_NAME
	public typealias SchemaList = KeyValuePairs<SchemaName,SDAISchema.Type>

	public struct P21Error: Error, Equatable {
		public let message: String
		public let lineNumber: Int
	}
}


public extension Character {
	func `is`(_ charset: CharacterSet) -> Bool {
		let selfset = CharacterSet(charactersIn: String(self))
		let result = !charset.isDisjoint(with: selfset)
		return result
	}
}
