//
//  SdaiAggregation.swift
//  
//
//  Created by Yoshida on 2020/09/13.
//

import Foundation

//MARK: - empty aggregation literal
extension SDAI {
	public struct EmptyAggregateLiteral {}
	public static let EMPLY_AGGREGATE = EmptyAggregateLiteral()
}

//MARK: - Aggregation Initializer Element type
public protocol SDAI__AIE__type {
	associatedtype ELEMENT
	var count: Int {get}
}
extension SDAI.AggregationInitializerElement: SDAI__AIE__type 
{
	public typealias ELEMENT = Element
}

public extension SDAI {
	typealias AggregationInitializerElement<T> = Repeated<T>
	static func AIE<T>(_ element: T, repeat n: Int = 1) -> AggregationInitializerElement<T> {
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
	subscript(index: Int?) -> ELEMENT? {get}
	
	func CONTAINS(_ elem: ELEMENT?) -> SDAI.LOGICAL	// Express membership operator 'IN' translation
	
	associatedtype RESULT_AGGREGATE: SDAIAggregationType where RESULT_AGGREGATE.ELEMENT == ELEMENT
	func QUERY(logical_expression: (ELEMENT) -> SDAI.LOGICAL ) -> RESULT_AGGREGATE
	
	typealias EntityReferenceObserver = (_ removing: SDAI.EntityReference?, _ adding: SDAI.EntityReference?) -> Void
	var _observer: EntityReferenceObserver? { get set }
}
public extension SDAIAggregationType
{
	subscript<I: SDAI__INTEGER__type>(index: I?) -> ELEMENT? {
		return self[index?.asSwiftType]
	}

}
public extension SDAIAggregationType where Element: SDAI.EntityReference 
{
	var observer: EntityReferenceObserver? {
		get { 
			return _observer
		}
		set {
			_observer = newValue
			if let entityObserver = newValue {
				for entity in self {
					entityObserver( nil, entity )
				}
			}
		}
	}
	
	func teardown() {
		if let entityObserver = observer {
			for entity in self {
				entityObserver( entity, nil )
			}
		}
	}
	
	mutating func resetObserver() {
		_observer = nil
	}
}


public extension SDAIAggregationType where Element: SDAIUnderlyingType, Element.FundamentalType: SDAISelectType 
{
	var observer: EntityReferenceObserver? {
		get { 
			return _observer
//			switch(_observer) {
//			case entityObserver(let entityObserver): return entityObserver
//			default: return nil
//			} 			
		}
		set {
			_observer = newValue
			if let entityObserver = newValue {
				for select in self {
					entityObserver( nil, select.asFundamentalType.entityReference )
				}
			}
		}
	}
	
	func teardown() {
		if let entityObserver = observer {
			for select in self {
				entityObserver( select.asFundamentalType.entityReference, nil )
			}
		}
	}
	
	mutating func resetObserver() {
		_observer = nil
	}
}

public extension SDAIDefinedType 
where Self: SDAIAggregationType, 
			Supertype: SDAIAggregationType, 
			Supertype.ELEMENT == ELEMENT
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
	func CONTAINS(_ elem: ELEMENT?) -> SDAI.LOGICAL { return rep.CONTAINS(elem) }
	func QUERY(logical_expression: (ELEMENT) -> SDAI.LOGICAL ) -> Supertype.RESULT_AGGREGATE {
		return rep.QUERY(logical_expression: logical_expression)
	}

}

//MARK: - swift Array type extension
public extension Array where Element: SDAI__AIE__type//, Element.ELEMENT: SDAI.EntityReference
{
	typealias ELEMENT = Element.ELEMENT
	func CONTAINS(_ elem: ELEMENT?) -> SDAI.LOGICAL {
		abstruct()
	}

//	typealias RESULT_AGGREGATE = SDAI.LIST<ELEMENT>
//	func QUERY(logical_expression: (ELEMENT) -> SDAI.LOGICAL ) -> RESULT_AGGREGATE {
//		abstruct()
//	}
}

//public extension Array where Element: SDAI__AIE__type, Element.ELEMENT: SDAIUnderlyingType
//{
//	typealias ELEMENT = Element.ELEMENT
//	func CONTAINS(_ elem: ELEMENT?) -> SDAI.LOGICAL {
//		abstruct()
//	}
//
//	typealias RESULT_AGGREGATE = SDAI.LIST<ELEMENT>
//	func QUERY(logical_expression: (ELEMENT) -> SDAI.LOGICAL ) -> RESULT_AGGREGATE {
//		abstruct()
//	}
//}



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

