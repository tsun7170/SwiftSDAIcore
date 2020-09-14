//
//  SdaiAggregation.swift
//  
//
//  Created by Yoshida on 2020/09/13.
//

import Foundation


public protocol SDAIAggregationType: SDAIGenericType, Sequence 
{
	associatedtype Element
	
	typealias EntityReferenceObserver = (_ removing: SDAI.EntityReference?, _ adding: SDAI.EntityReference?) -> Void
	var _observer: EntityReferenceObserver? { get set }
	
	var hiBound: SDAI.INTEGER? {get}
	var hiIndex: SDAI.INTEGER {get}
	var loBound: SDAI.INTEGER {get}
	var loIndex: SDAI.INTEGER {get}
	
}
public extension SDAIAggregationType where Element: SDAI.EntityReference {
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


extension SDAI {
	public struct AGGREGATE<Element,S:LazySequenceProtocol>: SDAIAggregationType 
	where S.Element==Element 
	{
		public var hiBound: SDAI.INTEGER? { return nil }
		public var hiIndex: SDAI.INTEGER {
			var count = 0
			for _ in content { count += 1 }
			return SDAI.INTEGER(count)
		}
		public var loBound: SDAI.INTEGER { return SDAI.INTEGER(0) }
		public var loIndex: SDAI.INTEGER { return SDAI.INTEGER(0) }
		
		public func makeIterator() -> S.Iterator { return content.makeIterator() }
		public var asSwiftType: Array<Element> { return Array(content) }
		public var _observer: EntityReferenceObserver?
		
		
		private var content: S
		public init(from base: S) {
			self.content = base
		}
		public init(_ swiftValue: Array<Element>) {
			self.init(from: swiftValue.lazy as! S)
		}
		
		public func QUERY(logical_expression:@escaping (Element) -> LOGICAL ) -> AGGREGATE<Element,LazyFilterSequence<S.Elements>> {
			return AGGREGATE<Element,LazyFilterSequence<S.Elements>>(from: content.filter{ logical_expression($0).isTRUE })
		}
	}
}

