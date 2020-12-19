//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/18.
//

import Foundation

//MARK: - empty aggregation literal
extension SDAI {
	public struct EmptyAggregateLiteral {}
	public static let EMPLY_AGGREGATE = EmptyAggregateLiteral()
}

//MARK: - Aggregation Initializer Element type
public protocol SDAI__AIE__element {
	associatedtype Wrapped
	var unsafelyUnwrapped: Wrapped {get}
}

public protocol SDAI__AIE__type: Sequence where Element: SDAI__AIE__element{
	associatedtype ELEMENT = Element.Wrapped
	var count: Int {get}
}
extension Optional: SDAI__AIE__element {}
extension SDAI.AggregationInitializerElement: SDAI__AIE__type where Element: SDAI__AIE__element
{
//	public typealias ELEMENT = Element.Wrapped
}

public extension SDAI {
	typealias AggregationInitializerElement<E> = Repeated<E?>
	static func AIE<E:SDAIGenericType>(_ element: E, repeat n: Int = 1) -> AggregationInitializerElement<E> {
		return repeatElement(element as E?, count: n)
	}
	static func AIE<E:SDAIGenericType>(_ element: E?, repeat n: Int = 1) -> AggregationInitializerElement<E> {
		return repeatElement(element, count: n)
	}

	static func AIE<E:SDAISwiftType>(_ element: E, repeat n: Int = 1) -> AggregationInitializerElement<E> {
		return repeatElement(element as E?, count: n)
	}
	static func AIE<E:SDAISwiftType>(_ element: E?, repeat n: Int = 1) -> AggregationInitializerElement<E> {
		return repeatElement(element, count: n)
	}
}
