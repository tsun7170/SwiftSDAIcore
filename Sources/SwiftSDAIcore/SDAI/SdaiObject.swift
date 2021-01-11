//
//  SdaiObject.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/23.
//  Copyright © 2020 Minokamo, Japan. All rights reserved.
//

import Foundation


public protocol SDAIGenericType: Hashable, InitializableBySelecttype 
{
	associatedtype Value: SDAIValue
	var typeMembers: Set<SDAI.STRING> {get}
	var value: Value {get}
}
public extension SDAIDefinedType
where Supertype: SDAIGenericType, Value == Supertype.Value
{
	var typeMembers: Set<SDAI.STRING> {
		var members = rep.typeMembers
		members.insert(SDAI.STRING(Self.typeName))
		return members
	}
	
	var value: Value {rep.value}	
}





public protocol SDAINamedType 
{}




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






//MARK: - SDAI namespace
public enum SDAI {
	public typealias GENERIC = Any
	public typealias GENERIC_ENTITY = EntityReference

//	public static let INDETERMINATE: Any? = nil
	
	public static let TRUE:LOGICAL = true
	public static let FALSE:LOGICAL = false
	public static let UNKNOWN:LOGICAL = nil
	
	public static let CONST_E:REAL = REAL(exp(1.0))
	public static let PI:REAL = REAL(Double.pi)
	
	


	//MARK: - SDAI.Object	
	open class Object: Hashable {
		public static func == (lhs: SDAI.Object, rhs: SDAI.Object) -> Bool {
			return lhs === rhs
		}
		
		public func hash(into hasher: inout Hasher) {
			withUnsafePointer(to: self) { (p) -> Void in
				hasher.combine(p.hashValue)
			}
		}
	}
	
}


