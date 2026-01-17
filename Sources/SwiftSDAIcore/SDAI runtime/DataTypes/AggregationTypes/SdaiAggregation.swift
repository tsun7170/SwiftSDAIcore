//
//  SdaiAggregation.swift
//  
//
//  Created by Yoshida on 2020/09/13.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - Aggregate indexing (12.6.1)
extension SDAI {

  /// A protocol that enables read-only, index-based access to elements in an aggregate collection using integer-based indices.
  ///
  /// Conforming types provide subscripting capabilities that allow clients to access elements at specific positions, 
  /// either by passing a value conforming to `SDAI.INTEGER__TypeBehavior` or a plain `Int`.
  ///
  /// Indices can be `nil`—in which case `nil` is always returned—or any valid integer value. If the index is out of bounds
  /// or otherwise invalid, the subscript returns `nil` instead of failing.
  ///
  /// - Associatedtype:
  ///   - `ELEMENT`: The type of elements contained within the aggregate.
  ///
  /// ## Requirements:
  /// - Subscript access using an index conforming to `SDAI.INTEGER__TypeBehavior`.
  /// - Subscript access using a plain Swift `Int` index.
  /// - Both subscripts must handle `nil` or out-of-bounds indices gracefully by returning `nil`.
  ///
  /// ## Use Case:
  /// Use this protocol for types representing collections in STEP/EXPRESS aggregation constructs 
  /// (such as sets, bags, lists, or arrays) where read-only, index-based retrieval is needed.
  ///
  /// ## See Also:
  /// - `AggregateIndexingSettable` for read-write aggregate access.
  ///
  public protocol AggregateIndexingGettable {
    associatedtype ELEMENT

    /// Accesses the element at the specified integer index, if it exists.
    ///
    /// - Parameter index: An optional integer index of the element to access. If `nil` or the index is out of bounds, returns `nil`.
    /// - Returns: The element at the provided index, or `nil` if the index is invalid or not present.
    subscript<I: SDAI.INTEGER__TypeBehavior>(index: I?) -> ELEMENT? {get}

    /// Accesses the element at the specified integer index, if it exists.
    ///
    /// - Parameter index: An optional integer index of the element to access. If `nil` or the index is out of bounds, returns `nil`.
    /// - Returns: The element at the provided index, or `nil` if the index is invalid or not present.
    subscript(index: Int?) -> ELEMENT? {get}
  }

  /// A protocol that extends `AggregateIndexingGettable` to support both getting and setting elements by index in a collection-like aggregate.
  /// 
  /// Types conforming to this protocol provide subscript access to their elements using an integer or an `SDAI.INTEGER__TypeBehavior` index, allowing both retrieval and assignment. 
  /// Returning or setting `nil` handles out-of-bounds or invalid indices gracefully without crashing.
  ///
  /// - Note: `ELEMENT` represents the type of elements contained in the aggregate.
  ///
  /// ## Requirements:
  /// - Two subscript methods allowing get and set access to elements:
  ///   - By an index conforming to `SDAI.INTEGER__TypeBehavior` (`index: I?`)
  ///   - By a plain `Int` index (`index: Int?`)
  /// - Setting an element to `nil` can be used to remove or clear that element, depending on the conforming type's semantics.
  /// - Getting with an out-of-bounds or `nil` index returns `nil`.
  ///
  /// ## See Also:
  /// - `AggregateIndexingGettable` for read-only aggregate access.
  ///
  public protocol AggregateIndexingSettable: SDAI.AggregateIndexingGettable {
    associatedtype ELEMENT

    /// Accesses the element at the specified integer index, if it exists.
    /// - Parameter index: An optional integer index of the element to access. If `nil` or out of bounds, returns `nil`.
    /// - Returns: The element at the provided index, or `nil` if the index is invalid or not present.
    subscript<I: SDAI.INTEGER__TypeBehavior>(index: I?) -> ELEMENT? {get set}

    /// Accesses the element at the specified integer index, if it exists.
    /// - Parameter index: An optional integer index of the element to access. If `nil` or the index is out of bounds, returns `nil`.
    /// - Returns: The element at the provided index, or `nil` if the index is invalid or not present.
    subscript(index: Int?) -> ELEMENT? {get set}
  }
}

public extension SDAI.AggregateIndexingGettable
{
	subscript<I: SDAI.INTEGER__TypeBehavior>(index: I?) -> ELEMENT? {
		get{
			return self[index?.asSwiftType]
		}
	}
}

public extension SDAI.AggregateIndexingSettable
{
	subscript<I: SDAI.INTEGER__TypeBehavior>(index: I?) -> ELEMENT? {
		get{
			return self[index?.asSwiftType]
		}
		set{
			self[index?.asSwiftType] = newValue
		}
	}
}


//MARK: - aggregation behavior
extension SDAI {
  /// A protocol that defines common properties for describing aggregate collection bounds and size within an SDAI aggregation context.
  ///
  /// Types conforming to `AggregationBehavior` provide metadata about their collection boundaries (such as lower and upper bounds or indices) and the current size of their aggregation.
  /// These properties are essential for expressing EXPRESS aggregation semantics and enable introspection of an aggregate's structure, such as bounds for valid indices and the number of contained elements.
  ///
  /// ## Properties:
  /// - `aggregationHiBound`: The upper bound (maximum index) allowed in the aggregate, or `nil` if unbounded.
  /// - `aggregationHiIndex`: The highest index currently present in the aggregate, or `nil` if the aggregate is empty or undefined.
  /// - `aggregationLoBound`: The lower bound (minimum index) allowed in the aggregate, or `nil` if unbounded.
  /// - `aggregationLoIndex`: The lowest index currently present in the aggregate, or `nil` if the aggregate is empty or undefined.
  /// - `aggregationSize`: The current number of elements contained in the aggregate, or `nil` if not computable.
  ///
  /// ## Use Case:
  /// Use this protocol to inspect or enforce constraints on aggregate types (such as arrays, sets, lists, or bags) in STEP/EXPRESS modeling,
  /// where the concept of bounds and size is fundamental for data validation, iteration, and serialization.
  ///
  /// ## See Also:
  /// - `AggregationType` for aggregate collections with element access and membership semantics.
  /// - EXPRESS aggregation specifications (ISO 10303-11).
  public protocol AggregationBehavior {
    var aggregationHiBound: Int? {get}
    var aggregationHiIndex: Int? {get}
    var aggregationLoBound: Int? {get}
    var aggregationLoIndex: Int? {get}
    var aggregationSize: Int? {get}
  }
}

public extension SDAI.AggregationType
{
	var aggregationHiBound: Int? { self.hiBound }
	var aggregationHiIndex: Int? { self.hiIndex }
	var aggregationLoBound: Int? { self.loBound }
	var aggregationLoIndex: Int? { self.loIndex }
	var aggregationSize: Int? { self.size }
}

public extension SDAI.AggregationBehavior where Self: SDAI.DefinedType, Supertype: SDAI.SelectType
{
	var aggregationHiBound: Int? { rep.aggregationHiBound }
	var aggregationHiIndex: Int? { rep.aggregationHiIndex }
	var aggregationLoBound: Int? { rep.aggregationLoBound }
	var aggregationLoIndex: Int? { rep.aggregationLoIndex }
	var aggregationSize   : Int? { rep.aggregationSize    }
}

//MARK: - aggregation sequence
extension SDAI {
  /// A protocol that enables an SDAI aggregation to provide its elements as a general-purpose sequence.
  ///
  /// Types conforming to `AggregationSequence` expose their contained elements as an `AnySequence` of the element type, enabling
  /// generic iteration and functional operations (such as `map`, `filter`, etc.) over the aggregation's elements.
  /// 
  /// This protocol is intended for use with aggregation types (such as lists, sets, bags, or arrays) in the context of 
  /// STEP/EXPRESS modeling, providing a uniform interface for traversing aggregate contents regardless of their specific representation.
  /// 
  /// ## Associated Types:
  /// - `ELEMENT`: The type of the elements contained within the aggregation. Must conform to `SDAI.GenericType`.
  ///
  /// ## Requirements:
  /// - A computed property `asAggregationSequence` that yields an `AnySequence` of `ELEMENT`.
  ///
  /// ## Use Case:
  /// Use this protocol to generically consume or manipulate the elements of an aggregation type, particularly when the concrete
  /// type of the aggregate is not known at compile time or when conforming to higher-level collection abstractions.
  ///
  /// ## See Also:
  /// - `SDAI.AggregationType` for the primary aggregate protocol including element access and query semantics.
  /// - Swift's `Sequence` protocol for additional sequence operations.
  public protocol AggregationSequence
  {
    associatedtype ELEMENT: SDAI.GenericType
    var asAggregationSequence: AnySequence<ELEMENT> {get}
  }
}

//MARK: - dict representable
extension SDAI {
  /// A protocol that allows an aggregate or collection type to expose its contents as Swift dictionary representations.
  ///
  /// Types conforming to `SwiftDictRepresentable` provide two computed properties for expressing their elements as dictionaries:
  /// - `asSwiftDict`: A dictionary mapping each element's fundamental value (as defined by `ELEMENT.FundamentalType`) to an integer,
  ///   which may represent the element's index, count, or another semantic depending on the aggregate's nature.
  /// - `asValueDict`: A dictionary mapping each element's wrapped value (as defined by `ELEMENT.Value`) to an integer.
  ///
  /// These dictionary representations enable efficient lookup and bridging between EXPRESS aggregation constructs and native Swift
  /// dictionary types, facilitating operations such as membership testing, reverse lookup, or serialization to key-value formats.
  ///
  /// ## Associated Types:
  /// - `ELEMENT`: The type of elements contained within the aggregate. Must conform to `SDAI.GenericType`.
  ///
  /// ## Use Case:
  /// Use this protocol for aggregate types (such as sets, bags, or lists) that may need to be exposed as dictionaries for interoperability
  /// with Swift APIs or for optimized element lookup and manipulation.
  ///
  /// ## See Also:
  /// - `SDAI.GenericType`
  /// - Swift's `Dictionary` type
  public protocol SwiftDictRepresentable {
    associatedtype ELEMENT: SDAI.GenericType
    var asSwiftDict: Dictionary<ELEMENT.FundamentalType,Int> {get}
    var asValueDict: Dictionary<ELEMENT.Value,Int> {get}
  }
}

public extension SDAI.DefinedType
where Supertype: SDAI.SwiftDictRepresentable, Self: SDAI.SwiftDictRepresentable, 
			Supertype.ELEMENT.FundamentalType == Self.ELEMENT.FundamentalType,
			Supertype.ELEMENT.Value == Self.ELEMENT.Value
{
	var asSwiftDict: Dictionary<ELEMENT.FundamentalType,Int> { return rep.asSwiftDict }
	var asValueDict: Dictionary<ELEMENT.Value,Int> { return rep.asValueDict }
}

//MARK: - Aggregation type (8.2)
extension SDAI {
  /// A protocol that defines an aggregate collection type in the context of STEP/EXPRESS modeling, 
  /// supporting a range of operations and behaviors such as element access, membership testing, 
  /// query expressions, and aggregate introspection.
  ///
  /// Types conforming to `AggregationType` provide the core interface for EXPRESS-style aggregates, 
  /// including arrays, lists, sets, and bags. These aggregates offer index-based access, sequence traversal,
  /// semantic bounds, and EXPRESS-specific collection operators such as membership and query filters. 
  ///
  /// Conforming types are required to provide:
  /// - Read-only index access to elements, both by numeric index and EXPRESS-style integer type.
  /// - Properties describing the logical and current index bounds, aggregate size, and emptiness.
  /// - Static properties reflecting the EXPRESS-defined minimum and maximum logical bounds for the aggregate type.
  /// - Methods for element membership checking (`CONTAINS`) and filtered aggregate construction (`QUERY`).
  /// - Sequence conformance for traversal, and EXPRESS compatibility for select and base type relations.
  /// - Thread safety via conformance to `Sendable`.
  ///
  /// ## Associated Types:
  /// - `ELEMENT`: The type of elements contained in the aggregation, conforming to `SDAI.GenericType`.
  /// - `RESULT_AGGREGATE`: The type returned by the `QUERY` method. Must also conform to `AggregationType` with the same element type.
  ///
  /// ## Properties:
  /// - `hiBound`: The upper logical bound of the index range, or `nil` if unbounded.
  /// - `hiIndex`: The maximum (current) index currently present in the aggregate.
  /// - `loBound`: The lower logical bound of the index range.
  /// - `loIndex`: The minimum (current) index currently present in the aggregate.
  /// - `size`: The number of elements currently in the aggregate.
  /// - `isEmpty`: Boolean value indicating if the aggregate contains no elements.
  /// - `asAggregationSequence`: The contents as a general-purpose sequence.
  /// - `lowerBound`/`upperBound`: Static logical bounds for the aggregate type, reflecting EXPRESS schema bounds.
  ///
  /// ## Methods:
  /// - `CONTAINS(elem:)`: Tests if an element exists in the aggregate, returning an `SDAI.LOGICAL` value.
  /// - `QUERY(logical_expression:)`: Returns a new aggregate containing elements for which a logical predicate evaluates to `.TRUE`.
  ///
  /// ## Use Case:
  /// Use this protocol to represent and manipulate EXPRESS aggregates, supporting both EXPRESS semantics and idiomatic Swift sequence behaviors.
  /// It is the essential abstraction for advanced aggregation constructs within STEP/EXPRESS models, ensuring interoperability, introspection, and 
  /// type safety for EXPRESS-defined collections.
  ///
  /// ## See Also:
  /// - EXPRESS ISO 10303-11, section 8.2 and 12.6
  /// - `SDAI.AggregateIndexingGettable`
  /// - `SDAI.AggregationBehavior`
  /// - `SDAI.AggregationSequence`
  /// - `SDAI.BaseType`
  /// - `Sequence`
  public protocol AggregationType:
    SDAI.BaseType, SDAI.SelectCompatibleUnderlyingTypeBase, Sequence,
    SDAI.AggregateIndexingGettable, SDAI.AggregationBehavior, SDAI.AggregationSequence,
    Sendable
  {
    var hiBound: Int? {get}
    var hiIndex: Int {get}
    var loBound: Int {get}
    var loIndex: Int {get}
    var size: Int {get}
    var isEmpty: Bool {get}

    static var lowerBound: SDAIDictionarySchema.Bound {get}	// ISO 10303-22 (6.4.31)
    static var upperBound: SDAIDictionarySchema.Bound? {get}	// ISO 10303-22 (6.4.31)

    //MARK: Membership operator (12.2.3)
    /// Determines whether the aggregate contains the specified element.
    ///
    /// This method checks if the given element exists within the receiver aggregate, conforming to the EXPRESS `IN` membership operator semantics.  
    /// - Parameter elem: An optional value of type `ELEMENT` to search for within the aggregate. If `nil`, the result typically indicates absence (see type semantics).
    /// - Returns: An `SDAI.LOGICAL` value indicating whether the element is present in the aggregate (`.TRUE` if present, `.FALSE` if not, or `.UNKNOWN` if indeterminate).
    /// - SeeAlso: [ISO 10303-11, 12.2.3 Membership operator]
    /// 
    func CONTAINS(elem: ELEMENT?) -> SDAI.LOGICAL	// Express membership operator 'IN' translation

    //MARK: Query expression (12.6.7)
    associatedtype RESULT_AGGREGATE: SDAI.AggregationType
    where RESULT_AGGREGATE.ELEMENT == ELEMENT

    /// Returns a new aggregate containing the elements for which the given logical expression evaluates to `true`.
    ///
    /// This method implements the EXPRESS `QUERY` operation and allows you to filter the elements of the aggregation
    /// based on a predicate expressed as a closure returning `SDAI.LOGICAL`.
    /// 
    /// - Parameter logical_expression: 
    ///     A closure that takes an element of type `ELEMENT` and returns a value of type `SDAI.LOGICAL`. 
    ///     Elements for which this closure returns `.TRUE` will be included in the resulting aggregate.
    ///
    /// - Returns: 
    ///     An aggregate of type `RESULT_AGGREGATE` containing those elements for which the logical expression 
    ///     evaluated to `.TRUE`.
    ///
    /// - Note: 
    ///     The resulting aggregate is guaranteed to have the same element type as the receiver.
    ///
    /// - SeeAlso: 
    ///     EXPRESS query expressions (ISO 10303-11, 12.6.7).
    ///
    func QUERY(logical_expression: @escaping (ELEMENT) -> SDAI.LOGICAL ) -> RESULT_AGGREGATE
  }
}

public extension SDAI.AggregationType
{
	static var lowerBound: SDAIDictionarySchema.Bound { 0 }
	static var upperBound: SDAIDictionarySchema.Bound? { nil }
}

extension SDAI {
  /// A marker protocol indicating a fundamental aggregate collection type in the context of STEP/EXPRESS modeling.
  ///
  /// `FundamentalAggregationType` is used to distinguish aggregate types that are considered "fundamental" within the SDAI/EXPRESS universe,
  /// typically representing native EXPRESS collection constructs such as `ARRAY`, `LIST`, `SET`, or `BAG` with direct EXPRESS semantics.
  ///
  /// This protocol inherits from `SDAI.AggregationType` and imposes no additional requirements or properties.
  /// Use it to specialize generic behaviors, provide protocol extensions, or constrain APIs to only work with fundamental aggregate types,
  /// as opposed to user-defined or wrapped aggregates (e.g., specializations, select types, or defined types).
  ///
  /// ## Use Case:
  /// Use `FundamentalAggregationType` to extend or constrain operations for core EXPRESS aggregate types, for example,
  /// enabling introspection, serialization, or EXPRESS-specific collection algorithms only for those aggregates that are not user-defined wrappers.
  ///
  /// ## See Also:
  /// - `SDAI.AggregationType`
  /// - EXPRESS ISO 10303-11, section 8.2 and 12.6
  public protocol FundamentalAggregationType: SDAI.AggregationType
  {}
}


//MARK: - generic aggregate
extension SDAI {
	public typealias AGGREGATE<ELEMENT> = LIST<ELEMENT> where ELEMENT : SDAI.GenericType
}



//MARK: - extension per ELEMENT type
public extension SDAI.AggregationType
where ELEMENT: SDAI.InitializableBySelectType
{
	func CONTAINS<T: SDAI.SelectType>(_ elem: T?) -> SDAI.LOGICAL {
		return self.CONTAINS(elem: ELEMENT.convert(sibling: elem))
	}
}

public extension SDAI.AggregationType
where ELEMENT: SDAI.InitializableByComplexEntity
{
	func CONTAINS(_ elem: SDAI.EntityReference?) -> SDAI.LOGICAL
	{
		if let elem = elem as? ELEMENT {
			return self.CONTAINS(elem: elem )
		}
		else {
			return self.CONTAINS(elem: ELEMENT.convert(sibling: elem))
		}
	}

	func CONTAINS<PREF>(_ pref:PREF?) -> SDAI.LOGICAL
	where PREF: SDAI.PersistentReference,
				PREF.ARef: SDAI.EntityReference
	{
		if let elem = pref?.aRef as? ELEMENT {
			return self.CONTAINS(elem: elem )
		}
		else {
			return self.CONTAINS(elem: ELEMENT.convert(sibling: pref))
		}
	}
}

public extension SDAI.AggregationType
where ELEMENT: SDAI.InitializableByDefinedType
{
	func CONTAINS<T: SDAI.UnderlyingType>(_ elem: T?) -> SDAI.LOGICAL {
		return self.CONTAINS(elem: ELEMENT.convert(sibling: elem))
	}
}

public extension SDAI.AggregationType
where ELEMENT: SDAI.InitializableBySwiftType
{
	func CONTAINS<T>(_ elem: T?) -> SDAI.LOGICAL 
	where T == ELEMENT.SwiftType
	{
		return self.CONTAINS(elem: ELEMENT(from: elem))
	}
}


public extension SDAI.FundamentalAggregationType
where ELEMENT: SDAI.EntityReferenceYielding
{
  var entityReferences: AnySequence<SDAI.EntityReference> {
    AnySequence( self.asAggregationSequence.lazy.flatMap{ $0.entityReferences } )
  }

  var persistentEntityReferences: AnySequence<SDAI.GenericPersistentEntityReference> {
    AnySequence( self.asAggregationSequence.lazy.flatMap{ $0.persistentEntityReferences } )
  }

  func isHolding( entityReference: SDAI.EntityReference ) -> Bool
  {
    for elem in self.asAggregationSequence {
      if elem.isHolding(entityReference: entityReference) { return true }
    }
    return false
  }
}

public extension SDAI.FundamentalAggregationType
where ELEMENT: SDAI.EntityReference
{
  var entityReferences: AnySequence<SDAI.EntityReference> {
    self.asAggregationSequence as! AnySequence<SDAI.EntityReference>
  }

  var persistentEntityReferences: AnySequence<SDAI.GenericPersistentEntityReference> {
    AnySequence( self.asAggregationSequence.map{ SDAI.GenericPersistentEntityReference($0) } )
  }

  func isHolding( entityReference: SDAI.EntityReference ) -> Bool
  {
    for elem in self.asAggregationSequence {
      if elem.isHolding(entityReference: entityReference) { return true }
    }
    return false
  }
}

public extension SDAI.FundamentalAggregationType
where ELEMENT: SDAI.GenericPersistentEntityReference
{
  var entityReferences: AnySequence<SDAI.EntityReference> {
    AnySequence( self.asAggregationSequence.compactMap{ $0.asGenericEntityReference } )
  }

  var persistentEntityReferences: AnySequence<SDAI.GenericPersistentEntityReference> {
    self.asAggregationSequence as! AnySequence<SDAI.GenericPersistentEntityReference>
  }

  func isHolding( entityReference: SDAI.EntityReference ) -> Bool
  {
    for elem in self.asAggregationSequence {
      if let eref = elem.asGenericEntityReference,
        eref.isHolding(entityReference: entityReference)
      { return true }
    }
    return false
  }
}



//MARK: - aggregation subtypes
public extension SDAI.DefinedType 
where Self: SDAI.AggregationType, 
			Supertype: SDAI.AggregationType, 
			ELEMENT == Supertype.ELEMENT
{
	// Sequence \SDAI.AggregationType
	func makeIterator() -> Supertype.Iterator { return rep.makeIterator() }

	// SDAIGenericTypeBase
	func copy() -> Self {
		var copied = self
		copied.rep = rep.copy()
		return copied
	}
	
	// SDAI.AggregationType
	var hiBound: Int? { return rep.hiBound }
	var hiIndex: Int { return rep.hiIndex }
	var loBound: Int { return rep.loBound }
	var loIndex: Int { return rep.loIndex }
	var size: Int { return rep.size }
	var isEmpty: Bool { return rep.isEmpty }

	var asAggregationSequence: AnySequence<ELEMENT> { return rep.asAggregationSequence }

	func CONTAINS(elem: ELEMENT?) -> SDAI.LOGICAL { return rep.CONTAINS(elem: elem) }
	func QUERY(logical_expression: @escaping (ELEMENT) -> SDAI.LOGICAL ) -> Supertype.RESULT_AGGREGATE {
		return rep.QUERY(logical_expression: logical_expression)
	}
}

public extension SDAI.DefinedType
where Self: SDAI.AggregateIndexingGettable, 
			Supertype: SDAI.AggregateIndexingGettable, 
			ELEMENT == Supertype.ELEMENT
{
	subscript(index: Int?) -> ELEMENT? { 
		get{ return rep[index] }
	}
}

public extension SDAI.DefinedType
where Self: SDAI.AggregateIndexingSettable, 
			Supertype: SDAI.AggregateIndexingSettable, 
			ELEMENT == Supertype.ELEMENT
{
	subscript(index: Int?) -> ELEMENT? { 
		get{ return rep[index] }
		set{ rep[index] = newValue }
	}
}
