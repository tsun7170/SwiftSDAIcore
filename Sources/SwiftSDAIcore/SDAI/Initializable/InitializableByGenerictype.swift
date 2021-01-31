//
//  File.swift
//  
//
//  Created by Yoshida on 2021/01/31.
//

import Foundation

//MARK: - from generic type scalar
public protocol InitializableByGenerictype
{
	init?<G: SDAIGenericType>(fromGeneric generic: G?)
}
