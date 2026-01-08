//
//  SdaiSwiftTypeRepresented.swift
//  
//
//  Created by Yoshida on 2021/05/21.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation



public protocol SDAISwiftType
{}
extension String: SDAISwiftType {}
extension Int: SDAISwiftType {}
extension Double: SDAISwiftType {}
extension Bool: SDAISwiftType {}



public protocol SDAISwiftTypeRepresented
{
	associatedtype SwiftType
	var asSwiftType: SwiftType {get}	
}

public extension SDAIDefinedType 
where Supertype: SDAISwiftTypeRepresented, Self: SDAISwiftTypeRepresented, SwiftType == Supertype.SwiftType
{
	var asSwiftType: SwiftType { return rep.asSwiftType }
}


