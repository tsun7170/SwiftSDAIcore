//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/18.
//

import Foundation

//MARK: - from swift type scalar
public protocol InitializableBySwifttype
{
	associatedtype SwiftType
	
	init(from swiftValue: SwiftType)
}
public extension InitializableBySwifttype
{
	init?(from swiftValue: SwiftType?) {
		guard let swiftvalue = swiftValue else { return nil }
		self.init(from: swiftvalue)
	}
}


//MARK: - from swift type as list (with optional bounds)
public protocol InitializableBySwifttypeAsList
{
	associatedtype SwiftType
	
	init<I1: SwiftIntConvertible, I2: SwiftIntConvertible>(from swiftValue: SwiftType, bound1: I1, bound2: I2?) 
}
public extension InitializableBySwifttypeAsList
{
	init(from swiftValue: SwiftType) { 
		self.init(from: swiftValue, bound1: 0, bound2: nil as Int?) 
	}
	init<I2: SwiftIntConvertible>(from swiftValue: SwiftType, bound2: I2?) {
		self.init(from: swiftValue, bound1: 0, bound2: bound2) 
	}
	init<I1: SwiftIntConvertible>(from swiftValue: SwiftType, bound1: I1) {
		self.init(from: swiftValue, bound1: bound1, bound2: nil as Int?) 
	}
}

//MARK: - from swift type as array (with required bounds)
public protocol InitializableBySwifttypeAsArray
{
	associatedtype SwiftType
	
	init<I1: SwiftIntConvertible, I2: SwiftIntConvertible>(from swiftValue: SwiftType, bound1: I1, bound2: I2) 
}


