//
//  StringEncodingExtension.swift
//  SwiftSDAIcore
//
//  Created by Yoshida on 2025/11/16.
//

import Foundation
import CoreFoundation

public extension String.Encoding {

  init(cfStringEncoding enumval: CFStringEncodings) {
    let nsStringEncodingValue = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(enumval.rawValue))

    self.init(rawValue: nsStringEncodingValue)
   }

}
