//
//  SdaiSwiftTypeRepresented.swift
//  
//
//  Created by Yoshida on 2021/05/21.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation


extension SDAI {
  public protocol SwiftType
  {}
}
extension String: SDAI.SwiftType {}
extension Int: SDAI.SwiftType {}
extension Double: SDAI.SwiftType {}
extension Bool: SDAI.SwiftType {}


extension SDAI {
  public protocol SwiftTypeRepresented
  {
    associatedtype SwiftType
    var asSwiftType: SwiftType {get}
  }
}

public extension SDAI.DefinedType 
where Supertype: SDAI.SwiftTypeRepresented, Self: SDAI.SwiftTypeRepresented, SwiftType == Supertype.SwiftType
{
	var asSwiftType: SwiftType { return rep.asSwiftType }
}


