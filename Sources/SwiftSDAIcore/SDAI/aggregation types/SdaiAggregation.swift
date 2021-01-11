//
//  SdaiAggregation.swift
//  
//
//  Created by Yoshida on 2020/09/13.
//

import Foundation



//MARK: - Aggregation type
public protocol SDAIAggregationType: SDAISelectCompatibleUnderlyingTypeBase, Sequence
{	
	associatedtype ELEMENT
	
	var hiBound: Int? {get}
	var hiIndex: Int {get}
	var loBound: Int {get}
	var loIndex: Int {get}
	var size: Int {get}
	
	subscript<I: SDAI__INTEGER__type>(index: I?) -> ELEMENT? {get}
	subscript(index: Int?) -> ELEMENT? {get}
	
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

public extension SDAIAggregationType
{
	subscript<I: SDAI__INTEGER__type>(index: I?) -> ELEMENT? {
		return self[index?.asSwiftType]
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
//where Element == ELEMENT
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
//				for elem in self {
//					entityObserver( nil, elem.entityReference )
//				}
			}
		}
	}
	
	func teardown() {
		if let entityObserver = observer {
			self.forEachELEMENT { elem in
				entityObserver( elem.entityReference, nil )
				return .next
			}
//			for elem in self {
//				entityObserver( elem.entityReference, nil )
//			}
		}
	}
	
	mutating func resetObserver() {
		_observer = nil
	}
}

//public extension SDAIObservableAggregate 
//where Element == ELEMENT?
//{
//	var observer: EntityReferenceObserver? {
//		get { 
//			return _observer
//		}
//		set {
//			_observer = newValue
//			if let entityObserver = newValue {
//				for elem in self {
//					entityObserver( nil, elem?.entityReference )
//				}
//			}
//		}
//	}
//	
//	func teardown() {
//		if let entityObserver = observer {
//			for elem in self {
//				entityObserver( elem?.entityReference, nil )
//			}
//		}
//	}
//	
//	mutating func resetObserver() {
//		_observer = nil
//	}
//}


//public extension SDAIObservableAggregate 
//where ELEMENT: SDAISelectType, 
//			Element == ELEMENT
//{
//	var observer: EntityReferenceObserver? {
//		get { 
//			return _observer
//		}
//		set {
//			_observer = newValue
//			if let entityObserver = newValue {
//				for select in self {
//					entityObserver( nil, select.asFundamentalType.entityReference )
//				}
//			}
//		}
//	}
//	
//	func teardown() {
//		if let entityObserver = observer {
//			for select in self {
//				entityObserver( select.asFundamentalType.entityReference, nil )
//			}
//		}
//	}
//	
//	mutating func resetObserver() {
//		_observer = nil
//	}
//}
//
//public extension SDAIObservableAggregate 
//where ELEMENT: SDAISelectType, 
//			Element == ELEMENT?
//{
//	var observer: EntityReferenceObserver? {
//		get { 
//			return _observer
//		}
//		set {
//			_observer = newValue
//			if let entityObserver = newValue {
//				for select in self {
//					entityObserver( nil, select?.asFundamentalType.entityReference )
//				}
//			}
//		}
//	}
//	
//	func teardown() {
//		if let entityObserver = observer {
//			for select in self {
//				entityObserver( select?.asFundamentalType.entityReference, nil )
//			}
//		}
//	}
//	
//	mutating func resetObserver() {
//		_observer = nil
//	}
//}

//MARK: - aggregation subtypes
public extension SDAIDefinedType 
where Self: SDAIAggregationType, Supertype: SDAIAggregationType, 
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
	subscript(index: Int?) -> ELEMENT? { return rep[index] }
	func CONTAINS(elem: ELEMENT?) -> SDAI.LOGICAL { return rep.CONTAINS(elem: elem) }
	func QUERY(logical_expression: (ELEMENT) -> SDAI.LOGICAL ) -> Supertype.RESULT_AGGREGATE {
		return rep.QUERY(logical_expression: logical_expression)
	}

}






//extension SDAI {
//	public struct AGGREGATE<Element,S:LazySequenceProtocol>: SDAIAggregationType 
//	where S.Element==Element 
//	{
//		public var hiBound: SDAI.INTEGER? { return nil }
//		public var hiIndex: SDAI.INTEGER {
//			var count = 0
//			for _ in content { count += 1 }
//			return SDAI.INTEGER(count)
//		}
//		public var loBound: SDAI.INTEGER { return SDAI.INTEGER(0) }
//		public var loIndex: SDAI.INTEGER { return SDAI.INTEGER(0) }
//		
//		public func makeIterator() -> S.Iterator { return content.makeIterator() }
//		public var asSwiftType: Array<Element> { return Array(content) }
//		public var _observer: EntityReferenceObserver?
//		
//		
//		private var content: S
//		public init(from base: S) {
//			self.content = base
//		}
//		public init(_ swiftValue: Array<Element>) {
//			self.init(from: swiftValue.lazy as! S)
//		}
//		
//		public func QUERY(logical_expression:@escaping (Element) -> LOGICAL ) -> AGGREGATE<Element,LazyFilterSequence<S.Elements>> {
//			return AGGREGATE<Element,LazyFilterSequence<S.Elements>>(from: content.filter{ logical_expression($0).isTRUE })
//		}
//	}
//}

