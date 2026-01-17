//
//  SwiftSDAIcore.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/31.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

import OSLog

let logSubsystem = "SwiftSDAIcore"
internal let loggerSDAI = Logger(subsystem: logSubsystem, category: "SDAI")

internal func abstract( file: StaticString = #file, line: UInt = #line) -> Never {
	fatalError("abstract called",file:file,line:line)
}

extension Array {
  /// Removes and returns up to the specified number of elements from the end of the array.
  ///
  /// This method removes the last `maxLength` elements from the array (or as many as are available if the array has fewer than `maxLength` elements),
  /// and returns them as a new array in the order they appeared in the original array.
  ///
  /// - Parameter maxLength: The maximum number of elements to remove and return from the end of the array.
  /// - Returns: An array containing the removed elements, in the same order as they were in the original array. If the array is empty, returns an empty array.
  ///
  /// - Note: If `maxLength` is greater than the number of elements in the array, this method removes and returns all elements.
  ///
  public mutating func popLast(_ maxLength: Int) -> Array {
    let k = Swift.min(self.count, maxLength)

    let popped = Array(self.suffix(maxLength))
    self.removeLast(k)
    return popped
  }
}
