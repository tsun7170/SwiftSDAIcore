//
//  SdaiAggregation.swift
//  
//
//  Created by Yoshida on 2020/09/13.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - Aggregate indexing (12.6.1)
public protocol SDAIAggregateIndexingGettable {
	associatedtype ELEMENT
	subscript<I: SDAI__INTEGER__type>(index: I?) -> ELEMENT? {get}
	subscript(index: Int?) -> ELEMENT? {get}
}
public protocol SDAIAggregateIndexingSettable: SDAIAggregateIndexingGettable {
	associatedtype ELEMENT
	subscript<I: SDAI__INTEGER__type>(index: I?) -> ELEMENT? {get set}
	subscript(index: Int?) -> ELEMENT? {get set}
}

public extension SDAIAggregateIndexingGettable
{
	subscript<I: SDAI__INTEGER__type>(index: I?) -> ELEMENT? {
		get{
			return self[index?.asSwiftType]
		}
	}
}

public extension SDAIAggregateIndexingSettable
{
	subscript<I: SDAI__INTEGER__type>(index: I?) -> ELEMENT? {
		get{
			return self[index?.asSwiftType]
		}
		set{
			self[index?.asSwiftType] = newValue
		}
	}
}


//MARK: - aggregation behavior
public protocol SDAIAggregationBehavior {
	var aggregationHiBound: Int? {get}
	var aggregationHiIndex: Int? {get}
	var aggregationLoBound: Int? {get}
	var aggregationLoIndex: Int? {get}
	var aggregationSize: Int? {get}
}

public extension SDAIAggregationType
{
	var aggregationHiBound: Int? { self.hiBound }
	var aggregationHiIndex: Int? { self.hiIndex }
	var aggregationLoBound: Int? { self.loBound }
	var aggregationLoIndex: Int? { self.loIndex }
	var aggregationSize: Int? { self.size }
}

public extension SDAIAggregationBehavior where Self: SDAIDefinedType, Supertype: SDAISelectType
{
	var aggregationHiBound: Int? { rep.aggregationHiBound }
	var aggregationHiIndex: Int? { rep.aggregationHiIndex }
	var aggregationLoBound: Int? { rep.aggregationLoBound }
	var aggregationLoIndex: Int? { rep.aggregationLoIndex }
	var aggregationSize   : Int? { rep.aggregationSize    }
}

//MARK: - aggregation sequence
public protocol SDAIAggregationSequence
{
	associatedtype ELEMENT: SDAIGenericType
	var asAggregationSequence: AnySequence<ELEMENT> {get}
}

//MARK: - dict representable
public protocol SwiftDictRepresentable {
	associatedtype ELEMENT: SDAIGenericType
	var asSwiftDict: Dictionary<ELEMENT.FundamentalType,Int> {get}
	var asValueDict: Dictionary<ELEMENT.Value,Int> {get}
}

public extension SDAIDefinedType
where Supertype: SwiftDictRepresentable, Self: SwiftDictRepresentable, 
			Supertype.ELEMENT.FundamentalType == Self.ELEMENT.FundamentalType,
			Supertype.ELEMENT.Value == Self.ELEMENT.Value
{
	var asSwiftDict: Dictionary<ELEMENT.FundamentalType,Int> { return rep.asSwiftDict }
	var asValueDict: Dictionary<ELEMENT.Value,Int> { return rep.asValueDict }
}

//MARK: - Aggregation type (8.2)
public protocol SDAIAggregationType:
	SDAIBaseType, SDAISelectCompatibleUnderlyingTypeBase, Sequence,
	SDAIAggregateIndexingGettable, SDAIAggregationBehavior, SDAIAggregationSequence,
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
	associatedtype RESULT_AGGREGATE: SDAIAggregationType
	where RESULT_AGGREGATE.ELEMENT == ELEMENT

	func QUERY(logical_expression: @escaping (ELEMENT) -> SDAI.LOGICAL ) -> RESULT_AGGREGATE
}

public extension SDAIAggregationType
{
	static var lowerBound: SDAIDictionarySchema.Bound { 0 }
	static var upperBound: SDAIDictionarySchema.Bound? { nil }
}

public protocol SDAIFundamentalAggregationType: SDAIAggregationType
{}


//MARK: - generic aggregate
extension SDAI {
	public typealias AGGREGATE<ELEMENT> = LIST<ELEMENT> where ELEMENT : SDAIGenericType
}


//MARK: - aggregation iteration
extension SDAI {
	public enum IterControl {
		case next
		case stop
	}
}


//MARK: - extension per ELEMENT type
public extension SDAIAggregationType
where ELEMENT: InitializableBySelectType
{
	func CONTAINS<T: SDAISelectType>(_ elem: T?) -> SDAI.LOGICAL {
		return self.CONTAINS(elem: ELEMENT.convert(sibling: elem))
	}
}

public extension SDAIAggregationType
where ELEMENT: InitializableByComplexEntity
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
	where PREF: SDAIPersistentReference,
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

public extension SDAIAggregationType
where ELEMENT: InitializableByDefinedType
{
	func CONTAINS<T: SDAIUnderlyingType>(_ elem: T?) -> SDAI.LOGICAL {
		return self.CONTAINS(elem: ELEMENT.convert(sibling: elem))
	}
}

public extension SDAIAggregationType
where ELEMENT: InitializableBySwiftType
{
	func CONTAINS<T>(_ elem: T?) -> SDAI.LOGICAL 
	where T == ELEMENT.SwiftType
	{
		return self.CONTAINS(elem: ELEMENT(from: elem))
	}
}


public extension SDAIFundamentalAggregationType
where ELEMENT: SDAIEntityReferenceYielding
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

public extension SDAIFundamentalAggregationType
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

public extension SDAIFundamentalAggregationType
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
public extension SDAIDefinedType 
where Self: SDAIAggregationType, 
			Supertype: SDAIAggregationType, 
			ELEMENT == Supertype.ELEMENT
{
	// Sequence \SDAIAggregationType
	func makeIterator() -> Supertype.Iterator { return rep.makeIterator() }

	// SDAIGenericTypeBase
	func copy() -> Self {
		var copied = self
		copied.rep = rep.copy()
		return copied
	}
	
	// SDAIAggregationType
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

public extension SDAIDefinedType
where Self: SDAIAggregateIndexingGettable, 
			Supertype: SDAIAggregateIndexingGettable, 
			ELEMENT == Supertype.ELEMENT
{
	subscript(index: Int?) -> ELEMENT? { 
		get{ return rep[index] }
	}
}

public extension SDAIDefinedType
where Self: SDAIAggregateIndexingSettable, 
			Supertype: SDAIAggregateIndexingSettable, 
			ELEMENT == Supertype.ELEMENT
{
	subscript(index: Int?) -> ELEMENT? { 
		get{ return rep[index] }
		set{ rep[index] = newValue }
	}
}
