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

//MARK: - from empty list (with optional bounds)
public protocol InitializableByEmptyListLiteral
{
	init<I1: SwiftIntConvertible, I2: SwiftIntConvertible>(bound1: I1, bound2: I2?, _ emptyLiteral: SDAI.EmptyAggregateLiteral) 
}
public extension InitializableByEmptyListLiteral
{
	init(_ emptyLiteral: SDAI.EmptyAggregateLiteral = SDAI.EMPLY_AGGREGATE) {
		self.init(bound1: 0, bound2: nil as Int?, emptyLiteral)
	}
}

//MARK: - from empty array (with required bounds)
public protocol InitializableByEmptyArrayLiteral
{
	init<I1: SwiftIntConvertible, I2: SwiftIntConvertible>(bound1: I1, bound2: I2, _ emptyLiteral: SDAI.EmptyAggregateLiteral) 
}






//MARK: - Aggregation Initializer Element type
public protocol SDAI__AIE__element: Hashable {
	associatedtype Wrapped: Hashable
	var unsafelyUnwrapped: Wrapped {get}
	init(_ some: Wrapped)
}

public protocol SDAI__AIE__type: Sequence where Element: SDAI__AIE__element{
	associatedtype ELEMENT = Element.Wrapped
	var count: Int {get}
}
extension Optional: SDAI__AIE__element 
where Wrapped: Hashable
{}
extension SDAI.AggregationInitializerElement: SDAI__AIE__type where Element: SDAI__AIE__element {}

public extension SDAI {
	typealias AggregationInitializerElement<E> = Repeated<E?>
	
	//MARK: SDAIGenericType AIE
	static func AIE<E:SDAIGenericType, I:SwiftIntConvertible>(_ element: E, repeat n: I) -> AggregationInitializerElement<E> {
		return repeatElement(element as E?, count: n.possiblyAsSwiftInt ?? 1)
	}
	static func AIE<E:SDAIGenericType, I:SwiftIntConvertible>(_ element: E, repeat n: I?) -> AggregationInitializerElement<E> {
		return repeatElement(element as E?, count: n!.possiblyAsSwiftInt ?? 1)
	}
	static func AIE<E:SDAIGenericType>(_ element: E) -> AggregationInitializerElement<E> {
		return AIE(element, repeat: 1)
	}
	
	static func AIE<E:SDAIGenericType, I:SwiftIntConvertible>(_ element: E?, repeat n: I) -> AggregationInitializerElement<E> {
		return repeatElement(element, count: n.possiblyAsSwiftInt ?? 1)
	}
	static func AIE<E:SDAIGenericType, I:SwiftIntConvertible>(_ element: E?, repeat n: I?) -> AggregationInitializerElement<E> {
		return repeatElement(element, count: n!.possiblyAsSwiftInt ?? 1)
	}
	static func AIE<E:SDAIGenericType>(_ element: E?) -> AggregationInitializerElement<E> {
		return AIE(element, repeat: 1)
	}

	//MARK: SwiftType AIE
	static func AIE<E:SDAISwiftType, I:SwiftIntConvertible>(_ element: E, repeat n: I) -> AggregationInitializerElement<E> {
		return repeatElement(element as E?, count: n.possiblyAsSwiftInt ?? 1)
	}
	static func AIE<E:SDAISwiftType, I:SwiftIntConvertible>(_ element: E, repeat n: I?) -> AggregationInitializerElement<E> {
		return repeatElement(element as E?, count: n!.possiblyAsSwiftInt ?? 1)
	}
	static func AIE<E:SDAISwiftType>(_ element: E) -> AggregationInitializerElement<E> {
		return AIE(element, repeat: 1)
	}
	
	static func AIE<E:SDAISwiftType, I:SwiftIntConvertible>(_ element: E?, repeat n: I) -> AggregationInitializerElement<E> {
		return repeatElement(element, count: n.possiblyAsSwiftInt ?? 1)
	}
	static func AIE<E:SDAISwiftType, I:SwiftIntConvertible>(_ element: E?, repeat n: I?) -> AggregationInitializerElement<E> {
		return repeatElement(element, count: n!.possiblyAsSwiftInt ?? 1)
	}
	static func AIE<E:SDAISwiftType>(_ element: E?) -> AggregationInitializerElement<E> {
		return AIE(element, repeat: 1)
	}
}


//MARK: - Aggregation Initializer
public protocol SDAIAggregationInitializer: Sequence
where Element: SDAI__AIE__type
{
	typealias ELEMENT = Element.Element.Wrapped
}

extension Array: SDAIAggregationInitializer 
where Element: SDAI__AIE__type
{}

public extension SDAIAggregationInitializer
{
	func CONTAINS(elem: ELEMENT?) -> SDAI.LOGICAL {
		guard let elem = elem else { return SDAI.UNKNOWN }
		for aie in self {
			if aie.contains(Element.Element(elem)) { return SDAI.TRUE }
		}
		return SDAI.FALSE
	}
}

public extension SDAIAggregationInitializer 
where ELEMENT: SDAIGenericType
{
	typealias RESULT_AGGREGATE = SDAI.LIST<ELEMENT>
	func QUERY(logical_expression: (ELEMENT) -> SDAI.LOGICAL ) -> RESULT_AGGREGATE {
		abstruct()
	}
}


//MARK: - extension per ELEMENT type
public extension SDAIAggregationInitializer 
where ELEMENT: InitializableBySelecttype
{
	func CONTAINS<T: SDAISelectType>(_ elem: T?) -> SDAI.LOGICAL {
		return self.CONTAINS(elem: ELEMENT(possiblyFrom: elem))
	}
}

public extension SDAIAggregationInitializer 
where ELEMENT: InitializableByEntity
{
	func CONTAINS(_ elem: SDAI.EntityReference?) -> SDAI.LOGICAL {
		return self.CONTAINS(elem: ELEMENT(possiblyFrom: elem))
	}
}

public extension SDAIAggregationInitializer 
where ELEMENT: InitializableByDefinedtype
{
	func CONTAINS<T: SDAIUnderlyingType>(_ elem: T?) -> SDAI.LOGICAL {
		return self.CONTAINS(elem: ELEMENT(possiblyFrom: elem))
	}
}

public extension SDAIAggregationInitializer 
where ELEMENT: InitializableBySwifttype
{
	func CONTAINS<T>(_ elem: T?) -> SDAI.LOGICAL 
	where T == ELEMENT.SwiftType
	{
		return self.CONTAINS(elem: ELEMENT(elem))
	}
}

public extension SDAIAggregationInitializer
where ELEMENT: SDAISwiftType
{
	func CONTAINS<T: SDAISwiftTypeRepresented>(_ elem: T?) -> SDAI.LOGICAL 
	where T.SwiftType == ELEMENT
	{
		return self.CONTAINS(elem: elem?.asSwiftType)
	}
}

//MARK: - from list literal (with optional bounds)
public protocol InitializableByListLiteral
{
	associatedtype ELEMENT
	
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible>(bound1: I1, bound2: I2?, _ elements: [SDAI.AggregationInitializerElement<ELEMENT>]) 
}
public extension InitializableByListLiteral
{
	init?(_ elements: [SDAI.AggregationInitializerElement<ELEMENT>]) {
		self.init(bound1: 0, bound2: nil as Int?, elements)
	}
}

//MARK: - from array literal (with required bounds)
public protocol InitializableByArrayLiteral
{
	associatedtype ELEMENT

	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible>(bound1: I1, bound2: I2, _ elements: [SDAI.AggregationInitializerElement<ELEMENT>]) 	
}
