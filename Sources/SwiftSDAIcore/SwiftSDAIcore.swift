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
public let loggerSDAI = Logger(subsystem: logSubsystem, category: "SDAI")

public func abstract( file: StaticString = #file, line: UInt = #line) -> Never {
	fatalError("abstract called",file:file,line:line)
}

extension Array {
  public mutating func popLast(_ maxLength: Int) -> Array {
    let k = Swift.min(self.count, maxLength)

    let popped = Array(self.suffix(maxLength))
    self.removeLast(k)
    return popped
  }
}
