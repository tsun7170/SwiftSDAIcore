//
//  AgregationInitializer.swift
//  
//
//  Created by Yoshida on 2020/12/18.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - empty aggregation literal
extension SDAI {
	public struct EmptyAggregateLiteral: Sendable {}
	public static let EMPTY_AGGREGATE = EmptyAggregateLiteral()
}

//MARK: - from empty list (with optional bounds)
extension SDAI {
  public protocol InitializableByEmptyListLiteral
  {
    init<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible>(
      bound1: I1, bound2: I2?, _ emptyLiteral: SDAI.EmptyAggregateLiteral)
  }
}

public extension SDAI.InitializableByEmptyListLiteral
{
	init(_ emptyLiteral: SDAI.EmptyAggregateLiteral = SDAI.EMPTY_AGGREGATE) {
		self.init(bound1: 0, bound2: nil as Int?, emptyLiteral)
	}
}

//MARK: - from empty array (with required bounds)
extension SDAI {
  public protocol InitializableByEmptyArrayLiteral
  {
    init<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible>(
      bound1: I1, bound2: I2, _ emptyLiteral: SDAI.EmptyAggregateLiteral)
  }
}





//MARK: - Aggregation Initializer Element type
extension SDAI {
  public protocol AIE__ElementType: Hashable {
    associatedtype Wrapped: SDAI.GenericType
    var unsafelyUnwrapped: Wrapped {get}
    init(_ some: Wrapped)
  }

  public protocol AIE__TypeBehavior: Sequence
  where Element: SDAI.AIE__ElementType
  {
    associatedtype ELEMENT = Element.Wrapped
    var count: Int {get}
  }
}

extension Optional: SDAI.AIE__ElementType
where Wrapped: SDAI.GenericType
{}
extension SDAI.AggregationInitializerElement: SDAI.AIE__TypeBehavior where Element: SDAI.AIE__ElementType {}

public extension SDAI {
	typealias AggregationInitializerElement<E> = Repeated<E?>
	
	//MARK: SDAI.GenericType AIE
	static func AIE<E:SDAI.GenericType, I:SDAI.SwiftIntConvertible>(_ element: E, repeat n: I) -> AggregationInitializerElement<E> {
		return repeatElement(element as E?, count: n.asSwiftInt)
	}
	static func AIE<E:SDAI.GenericType, I:SDAI.SwiftIntConvertible>(_ element: E, repeat n: I?) -> AggregationInitializerElement<E> {
		return repeatElement(element as E?, count: n?.asSwiftInt ?? 1)
	}
	static func AIE<E:SDAI.GenericType>(_ element: E) -> AggregationInitializerElement<E> {
		return AIE(element, repeat: 1)
	}
	
	static func AIE<E:SDAI.GenericType, I:SDAI.SwiftIntConvertible>(_ element: E?, repeat n: I) -> AggregationInitializerElement<E> {
		return repeatElement(element, count: n.asSwiftInt)
	}
	static func AIE<E:SDAI.GenericType, I:SDAI.SwiftIntConvertible>(_ element: E?, repeat n: I?) -> AggregationInitializerElement<E> {
		return repeatElement(element, count: n?.asSwiftInt ?? 1)
	}
	static func AIE<E:SDAI.GenericType>(_ element: E?) -> AggregationInitializerElement<E> {
		return AIE(element, repeat: 1)
	}

}


//MARK: - Aggregation Initializer
extension SDAI {
  public protocol AggregationInitializer: Sequence, SDAI.SwiftDictRepresentable, SDAI.AggregationSequence
  where Element: SDAI.AIE__TypeBehavior, ELEMENT == Element.Element.Wrapped
  {}
}

extension Array: SDAI.AggregationInitializer, SDAI.SwiftDictRepresentable, SDAI.AggregationSequence
where Element: SDAI.AIE__TypeBehavior
{
	public typealias ELEMENT = Element.Element.Wrapped
}

public extension SDAI.AggregationInitializer
{
	func CONTAINS(elem: ELEMENT?) -> SDAI.LOGICAL {
		guard let elem = elem else { return SDAI.UNKNOWN }
		for aie in self {
			if aie.contains(Element.Element(elem)) { return SDAI.TRUE }
		}
		return SDAI.FALSE
	}

	typealias RESULT_AGGREGATE = SDAI.LIST<ELEMENT>
	func QUERY(logical_expression: (ELEMENT) -> SDAI.LOGICAL ) -> RESULT_AGGREGATE {
		let result = self.asAggregationSequence.filter { logical_expression($0).isTRUE }
		return RESULT_AGGREGATE(from: result)
	}
	
	// SDAI.SwiftDictRepresentable
	var asSwiftDict: Dictionary<ELEMENT.FundamentalType, Int> {
		return Dictionary<ELEMENT.FundamentalType,Int>( self.asAggregationSequence.lazy.map{($0.asFundamentalType, 1)} ){$0 + $1}
	}
	
	var asValueDict: Dictionary<ELEMENT.Value,Int> {
		return Dictionary<ELEMENT.Value,Int>( self.asAggregationSequence.lazy.map{($0.value, 1)} ){$0 + $1}
	}
	
	// SDAI.AggregationSequence
	var asAggregationSequence: AnySequence<ELEMENT> {
		return AnySequence(self.lazy.flatMap({ $0 }).compactMap({ $0 as? ELEMENT }))
	}
}


//MARK: - extension per ELEMENT type
public extension SDAI.AggregationInitializer 
where ELEMENT: SDAI.InitializableBySelectType
{
	func CONTAINS<T: SDAI.SelectType>(_ elem: T?) -> SDAI.LOGICAL {
		return self.CONTAINS(elem: ELEMENT.convert(sibling: elem))
	}
}

public extension SDAI.AggregationInitializer 
where ELEMENT: SDAI.InitializableByComplexEntity
{
	func CONTAINS(_ elem: SDAI.EntityReference?) -> SDAI.LOGICAL {
		if let elem = elem as? ELEMENT {
			return self.CONTAINS(elem: elem)
		}
		else {
			return self.CONTAINS(elem: ELEMENT.convert(sibling: elem))			
		}
	}
}

public extension SDAI.AggregationInitializer 
where ELEMENT: SDAI.InitializableByDefinedType
{
	func CONTAINS<T: SDAI.UnderlyingType>(_ elem: T?) -> SDAI.LOGICAL {
		return self.CONTAINS(elem: ELEMENT.convert(sibling: elem))
	}
}

public extension SDAI.AggregationInitializer 
where ELEMENT: SDAI.InitializableBySwiftType
{
	func CONTAINS<T>(_ elem: T?) -> SDAI.LOGICAL 
	where T == ELEMENT.SwiftType
	{
		return self.CONTAINS(elem: ELEMENT(from: elem))
	}
}

public extension SDAI.AggregationInitializer
where ELEMENT: SDAI.SwiftType
{
	func CONTAINS<T: SDAI.SwiftTypeRepresented>(_ elem: T?) -> SDAI.LOGICAL 
	where T.SwiftType == ELEMENT
	{
		return self.CONTAINS(elem: elem?.asSwiftType)
	}
}


//MARK: - from list literal (with optional bounds)
extension SDAI {
  public protocol InitializableByListLiteral
  {
    init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, E: SDAI.GenericType>(
      bound1: I1, bound2: I2?, _ elements: [SDAI.AggregationInitializerElement<E>])
  }
}

public extension SDAI.InitializableByListLiteral
{
	init?<E: SDAI.GenericType>(_ elements: [SDAI.AggregationInitializerElement<E>]) 
	{
		self.init(bound1: 0, bound2: nil as Int?, elements)
	}
}

//MARK: - from array literal (with required bounds)
extension SDAI {
  public protocol InitializableByArrayLiteral
  {
    init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, E: SDAI.GenericType>(
      bound1: I1, bound2: I2, _ elements: [SDAI.AggregationInitializerElement<E>])
  }
}
