//
//  StringEncodingExtension.swift
//  SwiftSDAIcore
//
//  Created by Yoshida on 2025/11/16.
//

import Foundation
import CoreFoundation

public extension String.Encoding {

  /// Initializes a `String.Encoding` instance from a `CFStringEncodings` value.
  ///
  /// - Parameter cfStringEncoding: The `CFStringEncodings` value to convert to a corresponding `String.Encoding`.
  /// - Note: This initializer uses `CFStringConvertEncodingToNSStringEncoding` to bridge between Core Foundation string encodings and Foundation's `String.Encoding`.
  /// - SeeAlso: [`CFStringEncodings`](https://developer.apple.com/documentation/corefoundation/cfstringencodings)
  /// - defined in P21Decode/Stream/StringEncodingExtension
  /// 
  init(cfStringEncoding enumval: CFStringEncodings) {
    let nsStringEncodingValue = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(enumval.rawValue))

    self.init(rawValue: nsStringEncodingValue)
   }

}
