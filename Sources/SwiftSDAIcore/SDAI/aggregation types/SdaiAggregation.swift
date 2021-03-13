//
//  SdaiAggregation.swift
//  
//
//  Created by Yoshida on 2020/09/13.
//

import Foundation

//MARK: - aggregation indexing
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
	associatedtype ELEMENT
	var asAggregationSequence: AnySequence<ELEMENT> {get}
}

//MARK: - dict representable
public protocol SwiftDictRepresentable {
	associatedtype ELEMENT: SDAIGenericType
	var asSwiftDict: Dictionary<ELEMENT.FundamentalType,Int> {get}
}

public extension SDAIDefinedType
where Supertype: SwiftDictRepresentable, Self: SwiftDictRepresentable, Supertype.ELEMENT.FundamentalType == Self.ELEMENT.FundamentalType
{
	var asSwiftDict: Dictionary<ELEMENT.FundamentalType,Int> { return rep.asSwiftDict }
}

//MARK: - Aggregation type
public protocol SDAIAggregationType: SDAISelectCompatibleUnderlyingTypeBase, Sequence, SDAIAggregateIndexingGettable, SDAIAggregationBehavior, SDAIAggregationSequence
{	
	associatedtype ELEMENT
	
	var hiBound: Int? {get}
	var hiIndex: Int {get}
	var loBound: Int {get}
	var loIndex: Int {get}
	var size: Int {get}
	
//	subscript<I: SDAI__INTEGER__type>(index: I?) -> ELEMENT? {get set}
//	subscript(index: Int?) -> ELEMENT? {get set}
	
//	func forEachELEMENT(do task: (_ elem: ELEMENT) -> SDAI.IterControl )
//	var asAggregationSequence: AnySequence<ELEMENT> {get}
	
	func CONTAINS(elem: ELEMENT?) -> SDAI.LOGICAL	// Express membership operator 'IN' translation
	
	associatedtype RESULT_AGGREGATE: SDAIAggregationType where RESULT_AGGREGATE.ELEMENT == ELEMENT
	func QUERY(logical_expression: (ELEMENT) -> SDAI.LOGICAL ) -> RESULT_AGGREGATE
	
	typealias EntityReferenceObserver = (_ removing: SDAI.EntityReference?, _ adding: SDAI.EntityReference?) -> Void
	var _observer: EntityReferenceObserver? { get set }
}

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

//public extension SDAIAggregationType
//where Element == ELEMENT
//{
//	func forEachELEMENT(do task: (_ elem: ELEMENT) -> SDAI.IterControl ) {
//		for elem in self {
//			if task(elem) == .stop { break }
//		}
//	}
//}
//public extension SDAIAggregationType
//where Element == ELEMENT?
//{
//	func forEachELEMENT(do task: (_ elem: ELEMENT) -> SDAI.IterControl ) {
//		for elem in self {
//			guard let elem = elem else { continue }
//			if task(elem) == .stop { break }
//		}
//	}
//}


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
public protocol SDAIObservableAggregateElement
{
	var entityReferences: AnySequence<SDAI.EntityReference> { get }
}

public extension SDAIDefinedType
where Self: SDAIObservableAggregateElement,
			Supertype: SDAIObservableAggregateElement
{
	var entityReferences: AnySequence<SDAI.EntityReference> { return rep.entityReferences }
}

public protocol SDAIObservableAggregate: SDAIAggregationType, SDAIObservableAggregateElement 
where ELEMENT: SDAIObservableAggregateElement
{
	var observer: EntityReferenceObserver? {get set}
	func teardown()
	mutating func resetObserver()
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
				for elem in self.asAggregationSequence {
					for entityRef in elem.entityReferences {
						entityObserver( nil, entityRef )
					}
				}
//				self.forEachELEMENT { elem in
//					for entityRef in elem.entityReferences {
//						entityObserver( nil, entityRef )
//					}
//					return .next
//				}
			}
		}
	}
	
	func teardown() {
		if let entityObserver = observer {
			for elem in self.asAggregationSequence {
				for entityRef in elem.entityReferences {
					entityObserver( entityRef, nil )
				}
			}
//			self.forEachELEMENT { elem in
//				for entityRef in elem.entityReferences {
//					entityObserver( entityRef, nil )
//				}
//				return .next
//			}
		}
	}
	
	mutating func resetObserver() {
		_observer = nil
	}	
}

public extension SDAIObservableAggregate where Element == ELEMENT
{
	var entityReferences: AnySequence<SDAI.EntityReference> { 
		AnySequence<SDAI.EntityReference>(self.lazy.flatMap { $0.entityReferences })
	}
}

public extension SDAIObservableAggregate where Element == ELEMENT?
{
	var entityReferences: AnySequence<SDAI.EntityReference> { 
		AnySequence<SDAI.EntityReference>(self.lazy.compactMap{$0}.flatMap { $0.entityReferences })
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
	var asAggregationSequence: AnySequence<ELEMENT> { return rep.asAggregationSequence }

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
