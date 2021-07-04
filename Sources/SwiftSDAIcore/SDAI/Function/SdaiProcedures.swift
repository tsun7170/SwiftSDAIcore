//
//  File.swift
//  
//
//  Created by Yoshida on 2021/01/01.
//

import Foundation

//MARK: Built-in Procedures (16)

extension SDAI {
	public static func INSERT<LISTTYPE: SDAIListType, GEN: SDAIGenericType, Integer: SwiftIntConvertible>( L: inout LISTTYPE?, E: GEN?, P: Integer? ) 
	{
		guard let E = LISTTYPE.ELEMENT.convert(fromGeneric: E), let P = P?.possiblyAsSwiftInt else { return }
		L?.insert(element: E, at: P)
	}
	
	public static func REMOVE<LISTTYPE: SDAIListType, Integer: SwiftIntConvertible>( L: inout LISTTYPE?, P: Integer? ) 
	{
		guard let P = P?.possiblyAsSwiftInt else { return }
		L?.remove(at: P)
	}
}
