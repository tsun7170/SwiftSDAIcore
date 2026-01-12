//
//  InitializableByVoid.swift
//  SwiftSDAIcore
//
//  Created by Yoshida on 2025/11/26.
//

import Foundation

extension SDAI {
  public protocol InitializableByVoid {
    init()
  }
}

extension AnySequence: SDAI.InitializableByVoid
{
  public init() {
    self.init([Element]())
  }
}

extension Int: SDAI.InitializableByVoid {}
extension Double: SDAI.InitializableByVoid {}
extension Float: SDAI.InitializableByVoid {}
extension String: SDAI.InitializableByVoid {}
extension Bool: SDAI.InitializableByVoid {}

extension Array: SDAI.InitializableByVoid {}
extension Dictionary: SDAI.InitializableByVoid {}
extension Set: SDAI.InitializableByVoid {}

extension SDAI.InitializableBySwiftType
where SwiftType: SDAI.InitializableByVoid
{
  public init() {
    self.init(from: SwiftType())
  }
}

public extension SDAI.InitializableByVoid
where Self: SDAI.DefinedType, Supertype: SDAI.InitializableByVoid
{
  init() {
    let supertype = Supertype()
    self.init(fundamental: supertype.asFundamentalType)
  }
}
