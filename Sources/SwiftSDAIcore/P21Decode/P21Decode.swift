//
//  P21Decode.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/31.
//  Copyright © 2020 Minokamo, Japan. All rights reserved.
//

import Foundation

public enum P21Decode {
	public typealias EntityInstanceName = Int
	
	public struct P21Error: Error {
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
