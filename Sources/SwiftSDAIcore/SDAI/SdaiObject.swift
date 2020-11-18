//
//  SdaiObject.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/23.
//  Copyright © 2020 Minokamo, Japan. All rights reserved.
//

import Foundation

public protocol SDAIValue: Hashable
{
	func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool
	func isValueEqualOptionally<T: SDAIValue>(to rhs: T?) -> Bool?
}
public extension SDAIValue
{
	func isValueEqualOptionally<T: SDAIValue>(to rhs: T?) -> Bool? {
		guard let rhs = rhs else { return nil }
		return self.isValueEqual(to: rhs)
	}
}


public protocol SDAIGenericType: Hashable 
{
	associatedtype Value: SDAIValue
	
	var typeMembers: Set<SDAI.STRING> {get}
	var value: Value {get}
	init?<S: SDAISelectType>(possiblyFrom select: S)
}


public protocol SDAINamedType 
{}




//MARK: - SDAI namespace
public enum SDAI {
	

	public static let TRUE:LOGICAL = true
	public static let FALSE:LOGICAL = false
	public static let UNKNOWN:LOGICAL = nil
	
	public static let CONST_E:REAL = REAL(exp(1.0))
	public static let PI:REAL = REAL(Double.pi)
	
	//MARK: - support functions
	public static func UNWRAP<T>(_ val:T?) -> T { return val! }
	public static func UNWRAP<T>(_ val:T) -> T { return val }

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


