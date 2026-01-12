//
//  SdaiSimpleType.swift
//  
//
//  Created by Yoshida on 2020/09/22.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - Simple data types (8.1)

extension SDAI {
  public protocol SimpleType: SDAI.UnderlyingType, SDAI.BaseType, SDAI.InitializableBySwiftType, SDAI.SwiftTypeRepresented
  {}
}

public extension SDAI.SimpleType
{
	func copy() -> Self { return self }
	var isCacheable: Bool { return true }
}
