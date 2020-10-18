//
//  SdaiList.swift
//  
//
//  Created by Yoshida on 2020/10/04.
//

import Foundation

//MARK: - Value comparison support
extension SDAI {
	public struct _ListValue<ELEMENT: SDAIGenericType>: SDAIValue
	{
		typealias ElementValue = ELEMENT.Value

		var hiIndex: Int
		var size: Int { hiIndex }
		var elements: AnySequence<ElementValue>
		
		// Equatable \Hashable\SDAIValue
		public static func == (lhs: _ListValue<ELEMENT>, rhs: _ListValue<ELEMENT>) -> Bool {
			return lhs.isValueEqual(to: rhs)
		}
		
		// Hashable \SDAIValue
		public func hash(into hasher: inout Hasher) {
			hasher.combine(hiIndex)
			elements.forEach { hasher.combine($0) }
		}
		
		// SDAIValue
		public func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool {
			guard let rav = rhs as? Self else { return false }
			if rav.hiIndex != self.hiIndex { return false }

			return self.elements.elementsEqual(rav.elements) { (le, re) -> Bool in
				return le.isValueEqual(to: re)
			}
		}

		// _ListValue specific
		init(from list: LIST<ELEMENT>) {
			hiIndex = list.hiIndex
			elements = AnySequence( list.lazy.map{ $0.value } )
		}
	}
}

//MARK: -
public protocol InitializableBySubtypeList: InitializableBySubtypeListLiteral
{
	init?<T: SDAI__LIST__type>(_ subtype: T?) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element

	init<T: SDAI__LIST__type>(_ subtype: T) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element	
}
public extension InitializableBySubtypeList
{
	init?<T: SDAI__LIST__type>(_ subtype: T?) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element
	{
		guard let subtype = subtype else { return nil}
		self.init(subtype)
	}
}

public protocol InitializableBySubtypeListLiteral
{
	associatedtype ELEMENT: SDAIUnderlyingType

	init<E: SDAIUnderlyingType>(bound1: Int, bound2: Int?, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E.FundamentalType == ELEMENT.FundamentalType
}

public protocol InitializableBySwiftListLiteral
{
	associatedtype ELEMENT: SDAISimpleType

	init<E>(bound1: Int, bound2: Int?, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E == ELEMENT.SwiftType
}


//MARK: - LIST type
public protocol SDAI__LIST__type: SDAIAggregationType
{
	init(bound1: Int, bound2: Int?, _ elements: [SDAI.AggregationInitializerElement<ELEMENT>]) 

	init?<T: SDAI__LIST__type>(_ listtype: T?) 
	where T.ELEMENT == ELEMENT, T.ELEMENT == T.Element

	init<T: SDAI__LIST__type>(_ listtype: T) 
	where T.ELEMENT == ELEMENT, T.ELEMENT == T.Element

	init(from swiftValue: SwiftType, loBound: Int, hiBound: Int?) 
}
public extension SDAI__LIST__type
{
	init?<T: SDAI__LIST__type>(_ listtype: T?) 
	where T.ELEMENT == ELEMENT, T.ELEMENT == T.Element
	{
		guard let listtype = listtype else { return nil }
		self.init(listtype)
	}
}

extension SDAI {
	public struct LIST<ELEMENT:SDAIGenericType>: SDAI__LIST__type, SDAIValue 
	{
		public typealias SwiftType = Array<ELEMENT>
		public typealias FundamentalType = Self
		fileprivate var rep: SwiftType
		private var bound1: Int
		private var bound2: Int?

		// Equatable \Hashable\SDAIGenericType\SDAIUnderlyingType \SDAIAggregationType\SDAI__LIST__type
		public static func == (lhs: SDAI.LIST<ELEMENT>, rhs: SDAI.LIST<ELEMENT>) -> Bool {
			return lhs.rep == rhs.rep &&
				lhs.bound1 == rhs.bound1 &&
				lhs.bound2 == rhs.bound2
		}
		
		// Hashable \SDAIGenericType\SDAIUnderlyingType \SDAIAggregationType\SDAI__LIST__type
		public func hash(into hasher: inout Hasher) {
			hasher.combine(rep)
			hasher.combine(bound1)
			hasher.combine(bound2)
		}

		// SDAIGenericType \SDAIUnderlyingType\SDAIAggregationType\SDAI__LIST__type
		public static var typeName: String { return "LIST" }
		public var asSwiftType: SwiftType { return rep }
		public var asFundamentalType: FundamentalType { return self }
		public var typeMembers: Set<SDAI.STRING> {
			return [SDAI.STRING(Self.typeName)]
		}
		public var value: _ListValue<ELEMENT> {
			return _ListValue(from: self)
		}
		public init(_ fundamental: FundamentalType) {
			rep = fundamental.rep
			bound1 = fundamental.bound1
			bound2 = fundamental.bound2
		}
		
		// Sequence \SDAIAggregationType\SDAI__LIST__type
		public func makeIterator() -> SwiftType.Iterator { return rep.makeIterator() }

		// SDAIAggregationType \SDAI__LIST__type
		public var hiBound: Int? { return bound2 }
		public var hiIndex: Int { return size }
		public var loBound: Int { return bound1 }
		public var loIndex: Int { return 1 }
		public var size: Int { return rep.count }
		public var _observer: EntityReferenceObserver?

		public subscript<I: SDAI__INTEGER__type>(index: I?) -> ELEMENT? {
			guard let index = index?.asSwiftType, index >= loIndex, index <= hiIndex else { return nil }
			return rep[index - loIndex]
		}
		
		public func QUERY(logical_expression: (ELEMENT) -> LOGICAL ) -> LIST<ELEMENT> {
			return LIST(from: rep.filter{ logical_expression($0).isTRUE }, hiBound: self.hiBound)
		}
		
		// SDAI__LIST__type
		public init(bound1: Int, bound2: Int?, _ elements: [SDAI.AggregationInitializerElement<ELEMENT>])
		{
			self.init(bound1:bound1, bound2:bound2, elements){ $0 }
		}

		public init<T: SDAI__LIST__type>(_ listtype: T) 
		where T.ELEMENT == ELEMENT, T.ELEMENT == T.Element
		{
			self.init(bound1:listtype.loBound, bound2:listtype.hiBound, [listtype]) { $0 }
		}

		public init(from swiftValue: SwiftType, loBound: Int = 0, hiBound: Int? = nil) 
		{
			bound1 = loBound
			bound2 = hiBound
			rep = swiftValue
		}
		
		// LIST specific
		private init<S:Sequence>(bound1: Int, bound2: Int?, _ elements: [S], conv: (S.Element) -> ELEMENT )
		{
			self.bound1 = bound1
			self.bound2 = bound2
			self.rep = []
			if let hi = bound2 {
				rep.reserveCapacity(hi)
			}
			for aie in elements {
				for elem in aie {
					rep.append(conv(elem))
				}
			}
		}
		
		// SDAIValue
		public func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool 
		{
			if let rhs = rhs as? Self { return self == rhs }
			return false
		}

	}
}
extension SDAI.LIST: InitializableBySubtypeList, InitializableBySubtypeListLiteral 
where ELEMENT: SDAIUnderlyingType
{
	// InitializableBySubtypeList
	public init<E: SDAIUnderlyingType>(bound1: Int = 0, bound2: Int? = nil, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E.FundamentalType == ELEMENT.FundamentalType
	{
		self.init(bound1:bound1, bound2:bound2, elements){ ELEMENT($0.asFundamentalType) }
	}		

	public init<T: SDAI__LIST__type>(_ subtype: T) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element
	{
		self.init(bound1:subtype.loBound, bound2:subtype.hiBound, [subtype]) { ELEMENT($0) }
	}
}
extension SDAI.LIST: InitializableBySwiftListLiteral 
where ELEMENT: SDAISimpleType
{
	public init<E>(bound1: Int, bound2: Int?, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E == ELEMENT.SwiftType
	{
		self.init(bound1:bound1, bound2:bound2, elements){ ELEMENT($0) }
	}
}

//MARK: -
public protocol SDAI__LIST__subtype: SDAI__LIST__type, SDAIDefinedType
where Supertype: SDAI__LIST__type,
			Supertype.ELEMENT == ELEMENT,
			Supertype.FundamentalType == SDAI.LIST<ELEMENT>,
			Supertype.SwiftType == SDAI.LIST<ELEMENT>.SwiftType
{}
public extension SDAI__LIST__subtype
{
	// SDAI__LIST__type \SDAI__LIST__subtype
	init?<T:SDAI__LIST__type>(_ subtype: T?) {
		guard let subtype = subtype else { return nil}
		self.init(subtype)
	}
}
public extension SDAI__LIST__subtype
{
	// Sequence \SDAIAggregationType\SDAI__LIST__type\SDAI__LIST__subtype
	func makeIterator() -> Supertype.Iterator { return rep.makeIterator() }

	// SDAIAggregationType \SDAI__LIST__type\SDAI__LIST__subtype
	var hiBound: Int? { return rep.hiBound }
	var hiIndex: Int { return rep.hiIndex }
	var loBound: Int { return rep.loBound }
	var loIndex: Int { return rep.loIndex }
	var size: Int { return rep.size }
	var _observer: EntityReferenceObserver? {
		get { return rep._observer }
		set { rep._observer = newValue }
	}

	subscript<I: SDAI__INTEGER__type>(index: I?) -> ELEMENT? {
		return rep[index]
	}

	func QUERY(logical_expression: (ELEMENT) -> SDAI.LOGICAL ) -> Supertype.RESULT_AGGREGATE {
		return rep.QUERY(logical_expression: logical_expression)
	}
		
	// SDAI__LIST__type \SDAI__LIST__subtype
	init(bound1: Int, bound2: Int?, _ elements: [SDAI.AggregationInitializerElement<ELEMENT>]) {
		self.init( Supertype(bound1: bound1, bound2: bound2, elements) )
	}
	
	init<T: SDAI__LIST__type>(_ listtype: T) 
	where T.ELEMENT == ELEMENT, T.ELEMENT == T.Element
	{
		self.init( Supertype(listtype) )
	}
	
	init(from swiftValue: SwiftType, loBound: Int = 0, hiBound: Int? = nil) {
		self.init( Supertype(from: swiftValue, loBound: loBound, hiBound: hiBound) )
	} 
}

public extension SDAI__LIST__subtype
where Supertype: InitializableBySubtypeList
{
	init<E: SDAIUnderlyingType>(bound1: Int = 0, bound2: Int? = nil, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E.FundamentalType == ELEMENT.FundamentalType
	{
		self.init( Supertype(bound1: bound1, bound2: bound2, elements) )
	}

	init<T:SDAI__LIST__type>(_ subtype: T) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element
	{
		self.init( Supertype(subtype).asFundamentalType )
	}
}

public extension SDAI__LIST__subtype
where Supertype: InitializableBySwiftListLiteral
{
	init<E>(bound1: Int = 0, bound2: Int? = nil, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E == ELEMENT.SwiftType
	{
		self.init( Supertype(bound1:bound1, bound2:bound2, elements) )
	}
}

