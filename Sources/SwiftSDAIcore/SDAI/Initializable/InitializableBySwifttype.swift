//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/18.
//

import Foundation


public protocol InitializableBySwifttype
{
	associatedtype SwiftType: SDAISwiftType
	
	init?(_ swiftValue: SwiftType?)
	init(_ swiftValue: SwiftType)
}

public protocol InitializableBySwiftListLiteral
{
	associatedtype ELEMENT: SDAISimpleType

	init<E>(bound1: Int, bound2: Int?, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E == ELEMENT.SwiftType
}


public protocol InitializableByOptionalSwiftArrayLiteral
{
	associatedtype ELEMENT: SDAISimpleType

	init<E>(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E == ELEMENT.SwiftType
}


//public protocol InitializableBySwiftArrayLiteral
//{
//	associatedtype ELEMENT: SDAISimpleType
//
//	init<E>(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<E?>]) 
//	where E == ELEMENT.SwiftType
//}

