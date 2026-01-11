//
//  SdaiSimpleType.swift
//  
//
//  Created by Yoshida on 2020/09/22.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - Simple data types (8.1)

public protocol SDAISimpleType: SDAIUnderlyingType, SDAIBaseType, SDAI.InitializableBySwiftType, SDAISwiftTypeRepresented 
{}

public extension SDAISimpleType 
{
	func copy() -> Self { return self }
	var isCacheable: Bool { return true }
}
