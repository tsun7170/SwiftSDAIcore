//
//  SdaiProcedures.swift
//  
//
//  Created by Yoshida on 2021/01/01.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: ISO 10303-11 (16) Built-in Procedures

extension SDAI {
	/// ISO 10303-11 (16.1) Insert
	/// 
	/// The INSERT procedure inserts an element at a particular position in a LIST. 
	/// - Parameters:
	///   - L: L is the LIST value into which an element is to be inserted.
	///   - E: E is the instance to be inserted into L. 
	///   E shall be compatible with the base type of L, as indicated by the type labels in the procedure head.
	///   - P: P is an INTEGER giving the position in L at which E is to be inserted.
	/// # Result : 
	/// L is modified by inserting E into L at the specified position. 
	/// The insertion follows the existing element at position P, so when P = 0, E becomes the first element.
	/// # Conditions : 
	/// 0 ≤ P ≤ SIZEOF(L) 
	public static func INSERT<LISTTYPE: SDAI.ListType, GEN: SDAI.GenericType, Integer: SDAI.SwiftIntConvertible>( L: inout LISTTYPE?, E: GEN?, P: Integer? ) 
	{
		guard let E = LISTTYPE.ELEMENT.convert(fromGeneric: E), let P = P?.possiblyAsSwiftInt else { return }
		L?.insert(element: E, at: P)
	}
	
	/// ISO 10303-11 (16.2) Remove
	/// 
	/// The REMOVE procedure removes an element from a particular position in a LIST. 
	/// - Parameters:
	///   - L: L is the LIST value from which an element is to be removed.
	///   - P: P is an INTEGER giving the position of the element in L to be removed.
	/// # Result : 
	/// L is modified by removing the element found at the specified position P.
	/// # Conditions : 
	/// 1 ≤ P ≤ SIZEOF(L) 
	public static func REMOVE<LISTTYPE: SDAI.ListType, Integer: SDAI.SwiftIntConvertible>( L: inout LISTTYPE?, P: Integer? ) 
	{
		guard let P = P?.possiblyAsSwiftInt else { return }
		L?.remove(at: P)
	}
}
