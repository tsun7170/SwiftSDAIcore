//
//  File.swift
//  
//
//  Created by Yoshida on 2021/06/15.
//

import Foundation

//MARK: - observable element
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

//MARK: - observable aggregate
public protocol SDAIObservableAggregate: SDAIAggregationType, SDAIObservableAggregateElement 
where ELEMENT: SDAIObservableAggregateElement
{
	var observer: EntityReferenceObserver? {get set}
	func teardown()
	mutating func resetObserver()
}

public extension SDAIDefinedType
where Self: SDAIObservableAggregate,
			Supertype: SDAIObservableAggregate
{
	var observer: EntityReferenceObserver? {
		get { 
			return rep.observer
		}
		set {
			rep.observer = newValue
		}
	}
	
	func teardown() {
		rep.teardown()
	}
	
	mutating func resetObserver() {
		rep.teardown()
	}	
	
}

//public extension SDAIObservableAggregate 
//{
//	var observer: EntityReferenceObserver? {
//		get { 
//			return _observer
//		}
//		set {
//			_observer = newValue
//			if let entityObserver = newValue {
//				for elem in self.asAggregationSequence {
//					for entityRef in elem.entityReferences {
//						entityObserver( nil, entityRef )
//					}
//				}
//			}
//		}
//	}
//	
//	func teardown() {
//		if let entityObserver = observer {
//			for elem in self.asAggregationSequence {
//				for entityRef in elem.entityReferences {
//					entityObserver( entityRef, nil )
//				}
//			}
//		}
//	}
//	
//	mutating func resetObserver() {
//		_observer = nil
//	}	
//}
//
//public extension SDAIObservableAggregate where Element == ELEMENT
//{
//	var entityReferences: AnySequence<SDAI.EntityReference> { 
//		AnySequence<SDAI.EntityReference>(self.lazy.flatMap { $0.entityReferences })
//	}
//}
//
//public extension SDAIObservableAggregate where Element == ELEMENT?
//{
//	var entityReferences: AnySequence<SDAI.EntityReference> { 
//		AnySequence<SDAI.EntityReference>(self.lazy.compactMap{$0}.flatMap { $0.entityReferences })
//	}
//}
