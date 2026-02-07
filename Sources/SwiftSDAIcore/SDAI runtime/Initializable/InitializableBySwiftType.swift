//
//  InitializableBySwifttype.swift
//  
//
//  Created by Yoshida on 2020/12/18.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - from swift type scalar
extension SDAI.Initializable {
  /// from swift type scalar
  public protocol BySwiftType
  {
    associatedtype SwiftType

    init(from swiftValue: SwiftType)
  }
}
public extension SDAI.Initializable.BySwiftType
{
	init?(from swiftValue: SwiftType?) {
		guard let swiftvalue = swiftValue else { return nil }
		self.init(from: swiftvalue)
	}
}


//MARK: - from swift type as list (with optional bounds)
extension SDAI.Initializable {

  /// from swift type as list (with optional bounds)
  public protocol BySwifttypeAsList
  {
    associatedtype SwiftType

    init<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible>(
      from swiftValue: SwiftType,
      bound1: I1,
      bound2: I2?)
  }
}
public extension SDAI.Initializable.BySwifttypeAsList
{
	init(from swiftValue: SwiftType) { 
		self.init(from: swiftValue, bound1: 0, bound2: nil as Int?) 
	}
	init<I2: SDAI.SwiftIntConvertible>(from swiftValue: SwiftType, bound2: I2?) {
		self.init(from: swiftValue, bound1: 0, bound2: bound2) 
	}
	init<I1: SDAI.SwiftIntConvertible>(from swiftValue: SwiftType, bound1: I1) {
		self.init(from: swiftValue, bound1: bound1, bound2: nil as Int?) 
	}
}

//MARK: - from swift type as array (with required bounds)
extension SDAI.Initializable {
  
  /// from swift type as array (with required bounds)
  public protocol BySwifttypeAsArray
  {
    associatedtype SwiftType
    
    init<I1, I2>(
      from swiftValue: SwiftType, bound1: I1, bound2: I2?)
    where I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible

  }
}

