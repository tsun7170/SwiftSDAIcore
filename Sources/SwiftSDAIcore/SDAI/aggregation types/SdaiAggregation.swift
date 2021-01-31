//
//  SdaiAggregation.swift
//  
//
//  Created by Yoshida on 2020/09/13.
//

import Foundation

public protocol SDAIAggregateIndexingGettable {
	associatedtype ELEMENT
	subscript<I: SDAI__INTEGER__type>(index: I?) -> ELEMENT? {get}
	subscript(index: Int?) -> ELEMENT? {get}
}
public protocol SDAIAggregateIndexingSettable {
	associatedtype ELEMENT
	subscript<I: SDAI__INTEGER__type>(index: I?) -> ELEMENT? {get set}
	subscript(index: Int?) -> ELEMENT? {get set}
}

//MARK: - Aggregation type
public protocol SDAIAggregationType: SDAISelectCompatibleUnderlyingTypeBase, Sequence
{	
	associatedtype ELEMENT
	
	var hiBound: Int? {get}
	var hiIndex: Int {get}
	var loBound: Int {get}
	var loIndex: Int {get}
	var size: Int {get}
	
//	subscript<I: SDAI__INTEGER__type>(index: I?) -> ELEMENT? {get set}
//	subscript(index: Int?) -> ELEMENT? {get set}
	
	func forEachELEMENT(do task: (_ elem: ELEMENT) -> SDAI.IterControl )
	
	func CONTAINS(elem: ELEMENT?) -> SDAI.LOGICAL	// Express membership operator 'IN' translation
	
	associatedtype RESULT_AGGREGATE: SDAIAggregationType where RESULT_AGGREGATE.ELEMENT == ELEMENT
	func QUERY(logical_expression: (ELEMENT) -> SDAI.LOGICAL ) -> RESULT_AGGREGATE
	
	typealias EntityReferenceObserver = (_ removing: SDAI.EntityReference?, _ adding: SDAI.EntityReference?) -> Void
	var _observer: EntityReferenceObserver? { get set }
}

extension SDAI {
	public enum IterControl {
		case next
		case stop
	}
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

public extension SDAIAggregationType
where Element == ELEMENT
{
	func forEachELEMENT(do task: (_ elem: ELEMENT) -> SDAI.IterControl ) {
		for elem in self {
			if task(elem) == .stop { break }
		}
	}
}
public extension SDAIAggregationType
where Element == ELEMENT?
{
	func forEachELEMENT(do task: (_ elem: ELEMENT) -> SDAI.IterControl ) {
		for elem in self {
			guard let elem = elem else { continue }
			if task(elem) == .stop { break }
		}
	}
}


//MARK: - extension per ELEMENT type
public extension SDAIAggregationType
where ELEMENT: InitializableBySelecttype
{
	func CONTAINS<T: SDAISelectType>(_ elem: T?) -> SDAI.LOGICAL {
		return self.CONTAINS(elem: ELEMENT(possiblyFrom: elem))
	}
}

public extension SDAIAggregationType
where ELEMENT: InitializableByEntity
{
	func CONTAINS(_ elem: SDAI.EntityReference?) -> SDAI.LOGICAL {
		return self.CONTAINS(elem: ELEMENT(possiblyFrom: elem))
	}
}

public extension SDAIAggregationType
where ELEMENT: InitializableByDefinedtype
{
	func CONTAINS<T: SDAIUnderlyingType>(_ elem: T?) -> SDAI.LOGICAL {
		return self.CONTAINS(elem: ELEMENT(possiblyFrom: elem))
	}
}

public extension SDAIAggregationType
where ELEMENT: InitializableBySwifttype
{
	func CONTAINS<T>(_ elem: T?) -> SDAI.LOGICAL 
	where T == ELEMENT.SwiftType
	{
		return self.CONTAINS(elem: ELEMENT(elem))
	}
}


//MARK: - extension for EntityReferenceObserver
public protocol SDAIObservableAggregate: SDAIAggregationType 
where ELEMENT: SDAIObservableAggregateElement
{
	var observer: EntityReferenceObserver? {get set}
	func teardown()
	mutating func resetObserver()
}

public protocol SDAIObservableAggregateElement
{
	var entityReference: SDAI.EntityReference? { get }
}

public extension SDAIObservableAggregate 
{
	var observer: EntityReferenceObserver? {
		get { 
			return _observer
		}
		set {
			_observer = newValue
			if let entityObserver = newValue {
				self.forEachELEMENT { elem in
					entityObserver( nil, elem.entityReference )
					return .next
				}
			}
		}
	}
	
	func teardown() {
		if let entityObserver = observer {
			self.forEachELEMENT { elem in
				entityObserver( elem.entityReference, nil )
				return .next
			}
		}
	}
	
	mutating func resetObserver() {
		_observer = nil
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

	// SDAIAggregationType
	var hiBound: Int? { return rep.hiBound }
	var hiIndex: Int { return rep.hiIndex }
	var loBound: Int { return rep.loBound }
	var loIndex: Int { return rep.loIndex }
	var size: Int { return rep.size }
	var _observer: EntityReferenceObserver? {
		get { return rep._observer }
		set { rep._observer = newValue }
	}
//	subscript(index: Int?) -> ELEMENT? { 
//		get{ return rep[index] }
//		set{ rep[index] = newValue }
//	}
	func CONTAINS(elem: ELEMENT?) -> SDAI.LOGICAL { return rep.CONTAINS(elem: elem) }
	func QUERY(logical_expression: (ELEMENT) -> SDAI.LOGICAL ) -> Supertype.RESULT_AGGREGATE {
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
