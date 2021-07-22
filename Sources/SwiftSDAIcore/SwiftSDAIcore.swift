//
//  SwiftSDAIcore.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/31.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

public func abstruct( file: StaticString = #file, line: UInt = #line) -> Never {
	fatalError("abstruct called",file:file,line:line)
}
