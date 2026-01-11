//
//  InitializableByVoid.swift
//  SwiftSDAIcore
//
//  Created by Yoshida on 2025/11/26.
//

import Foundation


public protocol InitializableByVoid {
  init()
}

extension AnySequence: InitializableByVoid
{
  public init() {
    self.init([Element]())
  }
}

extension Int: InitializableByVoid {}
extension Double: InitializableByVoid {}
extension Float: InitializableByVoid {}
extension String: InitializableByVoid {}
extension Bool: InitializableByVoid {}

extension Array: InitializableByVoid {}
extension Dictionary: InitializableByVoid {}
extension Set: InitializableByVoid {}

extension SDAI.InitializableBySwiftType
where SwiftType: InitializableByVoid
{
  public init() {
    self.init(from: SwiftType())
  }
}

public extension InitializableByVoid
where Self: SDAIDefinedType, Supertype: InitializableByVoid
{
  init() {
    let supertype = Supertype()
    self.init(fundamental: supertype.asFundamentalType)
  }
}
