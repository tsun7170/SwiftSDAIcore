//
//  SdaiObject.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/23.
//  Copyright © 2020 Minokamo, Japan. All rights reserved.
//

import Foundation


public protocol SDAIGenericType: Hashable 
{
	associatedtype Value: SDAIValue
//	associatedtype FundamentalType: SDAIGenericType
	
	var typeMembers: Set<SDAI.STRING> {get}
	var value: Value {get}
//	var asFundamentalType: FundamentalType {get}
	
	init?<S: SDAISelectType>(possiblyFrom select: S?)
}
//extension SDAIGenericType where FundamentalType == Self
//{
//	public var asFundamentalType: FundamentalType {
//		return self
//	}
//}


public protocol SDAINamedType 
{}

public protocol SDAISwiftType
{}
extension String: SDAISwiftType {}
extension Int: SDAISwiftType {}
extension Double: SDAISwiftType {}
extension Bool: SDAISwiftType {}


//MARK: - SDAI namespace
public enum SDAI {
	public typealias GENERIC = Any
	public typealias GENERIC_ENTITY = EntityReference

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


