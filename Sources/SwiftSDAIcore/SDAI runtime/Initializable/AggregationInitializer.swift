//
//  AggregationInitializer.swift
//
//
//  Created by Yoshida on 2020/12/18.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - empty aggregation literal
extension SDAI {

  /// A value type representing an empty aggregate literal, used to initialize collections or aggregates
  /// with no elements. 
  ///
  /// `EmptyAggregateLiteral` is primarily utilized as a marker or placeholder to distinguish initializations
  /// or conversions where an empty collection is explicitly intended, particularly in generic aggregation contexts.
  /// 
  /// For example, types conforming to `InitializableByEmptyListLiteral` or `InitializableByEmptyArrayLiteral`
  /// may receive this type as a special argument signaling the construction of an empty aggregate, possibly with
  /// explicit bounds.
  /// 
  /// - SeeAlso: `SDAI.Initializable.ByEmptyListLiteral`, `SDAI.Initializable.ByEmptyArrayLiteral`
	public struct EmptyAggregateLiteral: Sendable {}
	public static let EMPTY_AGGREGATE = EmptyAggregateLiteral()
}

//MARK: - from empty list (with optional bounds)
extension SDAI.Initializable {
  /// from empty list (with optional bounds)
  public protocol ByEmptyListLiteral
  {
    init<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible>(
      bound1: I1, bound2: I2?, _ emptyLiteral: SDAI.EmptyAggregateLiteral)
  }
}

public extension SDAI.Initializable.ByEmptyListLiteral
{
	init(_ emptyLiteral: SDAI.EmptyAggregateLiteral = SDAI.EMPTY_AGGREGATE) {
		self.init(bound1: 0, bound2: nil as Int?, emptyLiteral)
	}
}

//MARK: - from empty array (with required bounds)
extension SDAI.Initializable {
  /// from empty array (with required bounds)
  public protocol ByEmptyArrayLiteral
  {
    init<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible>(
      bound1: I1, bound2: I2, _ emptyLiteral: SDAI.EmptyAggregateLiteral)
  }
}





//MARK: - Aggregation Initializer Element type
extension SDAI.TypeHierarchy {
  /// A protocol that defines the requirements for an aggregation initializer element type.
  /// 
  /// Types conforming to `AIE__ElementType` are used to wrap or represent individual elements within aggregation initializers. 
  /// This protocol provides a mechanism for handling both actual aggregation values and potential optionals, and is central to generic handling of sequences of wrapped or unwrapped values.
  ///
  /// Conforming types must:
  /// - Be `Hashable`.
  /// - Specify a `Wrapped` associated type, which must conform to `SDAI.GenericType`. This type represents the underlying value being wrapped.
  /// - Provide an `unsafelyUnwrapped` property, which exposes the underlying `Wrapped` value.
  /// - Implement an initializer that constructs an instance from a given `Wrapped` value.
  ///
  /// `AIE__ElementType` is typically used to generalize how elements are stored and accessed in aggregate types, allowing consistent behavior even when elements may be wrapped in optionals or other container types.
  ///
  /// - SeeAlso: `SDAI.GenericType`, `SDAI.TypeHierarchy.AIE__TypeBehavior`
  public protocol AIE__ElementType: Hashable {
    associatedtype Wrapped: SDAI.GenericType
    var unsafelyUnwrapped: Wrapped {get}
    init(_ some: Wrapped)
  }

  /// A protocol that defines the behavior of types used as elements in aggregation initializers.
  ///
  /// Types conforming to `AIE__TypeBehavior` represent sequences whose elements conform to 
  /// `SDAI.TypeHierarchy.AIE__ElementType`, generalizing how aggregated values are accessed,
  /// iterated, or counted in collection-like constructs.
  ///
  /// Specifically, conforming types:
  /// - Must be `Sequence`s whose elements conform to `AIE__ElementType`.
  /// - Expose a `count` property for the number of aggregate elements.
  /// - Define an associated type `ELEMENT` representing the wrapped type of their elements.
  ///
  /// This protocol is central to the generic handling of sequences of aggregation initializer elements,
  /// providing a consistent interface for working with collections whose values may be wrapped or optional.
  ///
  /// - SeeAlso: `SDAI.TypeHierarchy.AIE__ElementType`, `SDAI.AggregationInitializer`
  public protocol AIE__TypeBehavior: Sequence
  where Element: SDAI.TypeHierarchy.AIE__ElementType
  {
    associatedtype ELEMENT = Element.Wrapped
    var count: Int {get}
  }
}

extension Optional: SDAI.TypeHierarchy.AIE__ElementType
where Wrapped: SDAI.GenericType
{}
extension SDAI.AggregationInitializerElement: SDAI.TypeHierarchy.AIE__TypeBehavior where Element: SDAI.TypeHierarchy.AIE__ElementType {}

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
  /// A protocol representing an aggregation initializer, which defines requirements for types that can be initialized from a sequence of aggregation elements.
  /// 
  /// Conforming types must satisfy the following:
  /// - Conform to `Sequence`.
  /// - Conform to `SDAI.SwiftDictRepresentable`.
  /// - Conform to `SDAI.AggregationSequence`.
  /// - Its `Element` must conform to `SDAI.AIE__TypeBehavior`.
  /// - Its `ELEMENT` associated type is the unwrapped type of `Element`.
  ///
  /// `AggregationInitializer` is typically used to represent collections that aggregate values,
  /// supporting operations such as element containment checks, queries using logical expressions,
  /// and conversion to dictionary or aggregation sequence representations. 
  ///
  /// Extensions provide specialized containment logic based on the nature of `ELEMENT` (e.g., select types, entity types, defined types, Swift types).
  ///
  /// - SeeAlso: `SDAI.AIE__TypeBehavior`, `SDAI.SwiftDictRepresentable`, `SDAI.AggregationSequence`
  public protocol AggregationInitializer: Sequence, SDAI.SwiftDictRepresentable, SDAI.AggregationSequence
  where Element: SDAI.TypeHierarchy.AIE__TypeBehavior, ELEMENT == Element.Element.Wrapped
  {}
}

extension Array: SDAI.AggregationInitializer, SDAI.SwiftDictRepresentable, SDAI.AggregationSequence
where Element: SDAI.TypeHierarchy.AIE__TypeBehavior
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
where ELEMENT: SDAI.Initializable.BySelectType
{
	func CONTAINS<T: SDAI.SelectType>(_ elem: T?) -> SDAI.LOGICAL {
		return self.CONTAINS(elem: ELEMENT.convert(sibling: elem))
	}
}

public extension SDAI.AggregationInitializer 
where ELEMENT: SDAI.Initializable.ByComplexEntity
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
where ELEMENT: SDAI.Initializable.ByDefinedType
{
	func CONTAINS<T: SDAI.UnderlyingType>(_ elem: T?) -> SDAI.LOGICAL {
		return self.CONTAINS(elem: ELEMENT.convert(sibling: elem))
	}
}

public extension SDAI.AggregationInitializer 
where ELEMENT: SDAI.Initializable.BySwiftType
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
extension SDAI.Initializable {
  /// from list literal (with optional bounds)
  public protocol ByListLiteral
  {
    init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, E: SDAI.GenericType>(
      bound1: I1, bound2: I2?, _ elements: [SDAI.AggregationInitializerElement<E>])
  }
}

public extension SDAI.Initializable.ByListLiteral
{
	init?<E: SDAI.GenericType>(_ elements: [SDAI.AggregationInitializerElement<E>]) 
	{
		self.init(bound1: 0, bound2: nil as Int?, elements)
	}
}

//MARK: - from array literal (with required bounds)
extension SDAI.Initializable {
  /// from array literal (with required bounds)
  public protocol ByArrayLiteral
  {
    init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, E: SDAI.GenericType>(
      bound1: I1, bound2: I2, _ elements: [SDAI.AggregationInitializerElement<E>])
  }
}
