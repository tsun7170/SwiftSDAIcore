//
//  InitializableByVoid.swift
//  SwiftSDAIcore
//
//  Created by Yoshida on 2025/11/26.
//

import Foundation

extension SDAI.Initializable {
  /// from void without any parameter
  public protocol ByVoid {
    init()
  }
}

extension AnySequence: SDAI.Initializable.ByVoid
{
  public init() {
    self.init([Element]())
  }
}

extension Int: SDAI.Initializable.ByVoid {}
extension Double: SDAI.Initializable.ByVoid {}
extension Float: SDAI.Initializable.ByVoid {}
extension String: SDAI.Initializable.ByVoid {}
extension Bool: SDAI.Initializable.ByVoid {}

extension Array: SDAI.Initializable.ByVoid {}
extension Dictionary: SDAI.Initializable.ByVoid {}
extension Set: SDAI.Initializable.ByVoid {}

extension SDAI.Initializable.BySwiftType
where SwiftType: SDAI.Initializable.ByVoid
{
  public init() {
    self.init(from: SwiftType())
  }
}

public extension SDAI.Initializable.ByVoid
where Self: SDAI.DefinedType, Supertype: SDAI.Initializable.ByVoid
{
  init() {
    let supertype = Supertype()
    self.init(fundamental: supertype.asFundamentalType)
  }
}
