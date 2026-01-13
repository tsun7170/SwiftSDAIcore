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
  public protocol AggregateIndexingGettable {
    associatedtype ELEMENT
    subscript<I: SDAI.INTEGER__TypeBehavior>(index: I?) -> ELEMENT? {get}
    subscript(index: Int?) -> ELEMENT? {get}
  }

  public protocol AggregateIndexingSettable: SDAI.AggregateIndexingGettable {
    associatedtype ELEMENT
    subscript<I: SDAI.INTEGER__TypeBehavior>(index: I?) -> ELEMENT? {get set}
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
  public protocol AggregationSequence
  {
    associatedtype ELEMENT: SDAI.GenericType
    var asAggregationSequence: AnySequence<ELEMENT> {get}
  }
}

//MARK: - dict representable
extension SDAI {
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

    func CONTAINS(elem: ELEMENT?) -> SDAI.LOGICAL	// Express membership operator 'IN' translation

    //MARK: Query expression (12.6.7)
    associatedtype RESULT_AGGREGATE: SDAI.AggregationType
    where RESULT_AGGREGATE.ELEMENT == ELEMENT

    func QUERY(logical_expression: @escaping (ELEMENT) -> SDAI.LOGICAL ) -> RESULT_AGGREGATE
  }
}

public extension SDAI.AggregationType
{
	static var lowerBound: SDAIDictionarySchema.Bound { 0 }
	static var upperBound: SDAIDictionarySchema.Bound? { nil }
}

extension SDAI {
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
