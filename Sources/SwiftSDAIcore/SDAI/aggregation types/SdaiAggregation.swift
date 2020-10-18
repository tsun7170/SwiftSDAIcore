//
//  SdaiAggregation.swift
//  
//
//  Created by Yoshida on 2020/09/13.
//

import Foundation


//MARK: - Aggregation Initializer Element type
public extension SDAI {
	typealias AggregationInitializerElement<T> = Repeated<T>
	func AIE<T>(_ element: T, repeat n: Int = 1) -> AggregationInitializerElement<T> {
		return repeatElement(element, count: n)
	}
}


//MARK: - Aggregation type
public protocol SDAIAggregationType: SDAIUnderlyingType, Sequence
where SwiftType: Collection
{	
	associatedtype ELEMENT: SDAIGenericType
	
	var hiBound: Int? {get}
	var hiIndex: Int {get}
	var loBound: Int {get}
	var loIndex: Int {get}
	var size: Int {get}
	
	subscript<I: SDAI__INTEGER__type>(index: I?) -> ELEMENT? {get}
	
	associatedtype RESULT_AGGREGATE: SDAIAggregationType where RESULT_AGGREGATE.ELEMENT == ELEMENT
	func QUERY(logical_expression: (ELEMENT) -> SDAI.LOGICAL ) -> RESULT_AGGREGATE
	
	typealias EntityReferenceObserver = (_ removing: SDAI.EntityReference?, _ adding: SDAI.EntityReference?) -> Void
	var _observer: EntityReferenceObserver? { get set }
}

public extension SDAIAggregationType where Element: SDAI.EntityReference 
{
	// SDAIAggregationType
	var observer: EntityReferenceObserver? {
		get { _observer }
		set {
			if let oldObserver = observer, newValue == nil {	// removing observer
				for entity in self {
					oldObserver( entity, nil )
				}
			}
			else if let newObserver = newValue, observer == nil { // setting observer
				for entity in self {
					newObserver( nil, entity )
				}
			}
			else {	// replacing observer
				fatalError("can not replace observer")
			}
		} // setter
	}
	
	mutating func resetObserver() {
		_observer = nil
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

