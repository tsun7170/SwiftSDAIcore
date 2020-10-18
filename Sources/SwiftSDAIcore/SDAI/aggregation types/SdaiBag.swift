//
//  SdaiBag.swift
//  
//
//  Created by Yoshida on 2020/10/10.
//

import Foundation

//MARK: - Value comparison support
extension SDAI {
	public struct _BagValue<ELEMENT: SDAIGenericType>: SDAIValue
	{
		typealias ElementValue = ELEMENT.Value
		typealias CountedSet = Dictionary<ElementValue,Int>

		var hiIndex: Int
		var size: Int { hiIndex }
		var elements: AnySequence<ElementValue>
		
		// Equatable \Hashable\SDAIValue
		public static func == (lhs: _BagValue<ELEMENT>, rhs: _BagValue<ELEMENT>) -> Bool {
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

			var cset = self.asCountedSet
			for re in rav.elements {
				if let lcount = cset[re] {
					if lcount > 1 { cset[re] = lcount - 1 }
					else { cset[re] = nil }
				}
				else { return false }
			}
			return cset.isEmpty
		}
		
		private var asCountedSet: CountedSet {
			var cset = CountedSet(minimumCapacity: self.size)
			for e in self.elements {
				if let count = cset[e] { cset[e] = count + 1 }
				else { cset[e] = 1 }
			}
			return cset
		}

		// _BagValue specific
		init(from bag: BAG<ELEMENT>) {
			hiIndex = bag.hiIndex
			elements = AnySequence( bag.lazy.map{ $0.value } )
		}

		init(from set: SET<ELEMENT>) {
			hiIndex = set.hiIndex
			elements = AnySequence( set.lazy.map{ $0.value } )
		}
	}
}


//MARK: -
public protocol InitializableByBag
{
	associatedtype ELEMENT: SDAIGenericType

	init?<T: SDAI__BAG__type>(_ bagtype: T?) 
	where T.ELEMENT == ELEMENT, T.ELEMENT == T.Element

	init<T: SDAI__BAG__type>(_ bagtype: T) 
	where T.ELEMENT == ELEMENT, T.ELEMENT == T.Element
}
public extension InitializableByBag
{
	init?<T: SDAI__BAG__type>(_ bagtype: T?) 
	where T.ELEMENT == ELEMENT, T.ELEMENT == T.Element
	{
		guard let bagtype = bagtype else { return nil }
		self.init(bagtype)
	}
}

public protocol InitializableBySubtypeBag
{
	associatedtype ELEMENT: SDAIUnderlyingType

	init?<T: SDAI__BAG__type>(_ subtype: T?) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element
	
	init<T: SDAI__BAG__type>(_ subtype: T) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element
}
public extension InitializableBySubtypeBag
{
	init?<T: SDAI__BAG__type>(_ subtype: T?) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element
	{
		guard let subtype = subtype else { return nil }
		self.init(subtype)
	}
}



public protocol InitializableBySet
{
	associatedtype ELEMENT: SDAIGenericType

	init?<T: SDAI__SET__type>(_ setype: T?) 
	where T.ELEMENT == ELEMENT, T.ELEMENT == T.Element

	init<T: SDAI__SET__type>(_ setype: T) 
	where T.ELEMENT == ELEMENT, T.ELEMENT == T.Element
}
public extension InitializableBySet
{
	init?<T: SDAI__SET__type>(_ setype: T?) 
	where T.ELEMENT == ELEMENT, T.ELEMENT == T.Element
	{
		guard let setype = setype else { return nil }
		self.init(setype)
	}
}

public protocol InitializableBySubtypeSet
{
	associatedtype ELEMENT: SDAIUnderlyingType

	init?<T: SDAI__SET__type>(_ subtype: T?) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element
	
	init<T: SDAI__SET__type>(_ subtype: T) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element
}
public extension InitializableBySubtypeSet
{
	init?<T: SDAI__SET__type>(_ subtype: T?) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element
	{
		guard let subtype = subtype else { return nil}
		self.init(subtype)
	}
}


//MARK: - BAG type
public protocol SDAI__BAG__type: SDAIAggregationType, InitializableBySet 
{
	init(bound1: Int, bound2: Int?, _ elements: [SDAI.AggregationInitializerElement<ELEMENT>]) 

	init(from swiftValue: SwiftType, loBound: Int, hiBound: Int?) 
	
	
	mutating func add(member: ELEMENT?)
	mutating func remove(member: ELEMENT?)
}


extension SDAI {
	public struct BAG<ELEMENT:SDAIGenericType>: SDAI__BAG__type, SDAIValue, InitializableByBag 
	{
		public typealias SwiftType = Array<ELEMENT>
		public typealias FundamentalType = Self
		fileprivate var rep: SwiftType
		private var bound1: Int
		private var bound2: Int?

		// Equatable \Hashable\SDAIGenericType\SDAIUnderlyingType \SDAIAggregationType\SDAI__BAG__type
		public static func == (lhs: SDAI.BAG<ELEMENT>, rhs: SDAI.BAG<ELEMENT>) -> Bool {
			return lhs.rep == rhs.rep &&
				lhs.bound1 == rhs.bound1 &&
				lhs.bound2 == rhs.bound2
		}
		
		// Hashable \SDAIGenericType\SDAIUnderlyingType \SDAIAggregationType\SDAI__BAG__type
		public func hash(into hasher: inout Hasher) {
			hasher.combine(rep)
			hasher.combine(bound1)
			hasher.combine(bound2)
		}

		// SDAIGenericType \SDAIUnderlyingType\SDAIAggregationType\SDAI__BAG__type
		public static var typeName: String { return "BAG" }
		public var asSwiftType: SwiftType { return rep }
		public var asFundamentalType: FundamentalType { return self }
		public var typeMembers: Set<SDAI.STRING> {
			return [SDAI.STRING(Self.typeName)]
		}
		public var value: _BagValue<ELEMENT> {
			return _BagValue(from: self)
		}
		public init(_ fundamental: FundamentalType) {
			rep = fundamental.rep
			bound1 = fundamental.bound1
			bound2 = fundamental.bound2
		}
		
		// Sequence \SDAIAggregationType\SDAI__BAG__type
		public func makeIterator() -> SwiftType.Iterator { return rep.makeIterator() }

		// SDAIAggregationType \SDAI__BAG__type
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
		
		public func QUERY(logical_expression: (ELEMENT) -> LOGICAL ) -> BAG<ELEMENT> {
			return BAG(from: rep.filter{ logical_expression($0).isTRUE }, hiBound: self.hiBound)
		}
		
		// InitializableBySet \SDAI__BAG__type
		public init<T: SDAI__SET__type>(_ setype: T) 
		where T.ELEMENT == ELEMENT, T.ELEMENT == T.Element
		{
			self.init(bound1:setype.loBound, bound2:setype.hiBound, [setype]) { $0 }
		}

		// SDAI__BAG__type
		public init(bound1: Int, bound2: Int?, _ elements: [SDAI.AggregationInitializerElement<ELEMENT>])
		{
			self.init(bound1:bound1, bound2:bound2, elements){ $0 }
		}

		public init(from swiftValue: SwiftType, loBound: Int = 0, hiBound: Int? = nil) 
		{
			bound1 = loBound
			bound2 = hiBound
			rep = swiftValue
		}
		
		public mutating func add(member: ELEMENT?) {
			guard let member = member else {return}
			rep.append(member)
		}
		
		public mutating func remove(member: ELEMENT?) {
			guard let member = member else {return}
			if let index = rep.lastIndex(of: member) {
				rep.remove(at: index)
			}
		}
		
		// InitializableByBag
		public init<T: SDAI__BAG__type>(_ bagtype: T) 
		where T.ELEMENT == ELEMENT, T.ELEMENT == T.Element
		{
			self.init(bound1:bagtype.loBound, bound2:bagtype.hiBound, [bagtype]) { $0 }
		}
		
		// BAG specific
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
extension SDAI.BAG: InitializableBySubtypeSet, InitializableBySubtypeBag, InitializableBySubtypeListLiteral
where ELEMENT: SDAIUnderlyingType
{
	// InitializableBySubtypeSet
	public init<T: SDAI__SET__type>(_ subtype: T) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element
	{
		self.init(bound1:subtype.loBound, bound2:subtype.hiBound, [subtype]) { ELEMENT($0) }
	}
	
	// InitializableBySubtypeBag
	public init<T: SDAI__BAG__type>(_ subtype: T) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element
	{
		self.init(bound1:subtype.loBound, bound2:subtype.hiBound, [subtype]) { ELEMENT($0) }
	}
	
	
	// InitializableBySubtypeListLiteral
	public init<E:SDAIUnderlyingType>(bound1: Int = 0, bound2: Int? = nil, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E.FundamentalType == ELEMENT.FundamentalType
	{
		self.init(bound1:bound1, bound2:bound2, elements){ ELEMENT($0.asFundamentalType) }
	}		
}
extension SDAI.BAG: InitializableBySwiftListLiteral 
where ELEMENT: SDAISimpleType
{
	public init<E>(bound1: Int, bound2: Int?, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E == ELEMENT.SwiftType
	{
		self.init(bound1:bound1, bound2:bound2, elements){ ELEMENT($0) }
	}
}

//MARK: -
public protocol SDAI__BAG__subtype: SDAI__BAG__type, SDAIDefinedType, InitializableByBag
where Supertype: SDAI__BAG__type & InitializableByBag,
			Supertype.ELEMENT == ELEMENT,
			Supertype.FundamentalType == SDAI.BAG<ELEMENT>,
			Supertype.SwiftType == SDAI.BAG<ELEMENT>.SwiftType
{}
public extension SDAI__BAG__subtype
{
	// Sequence \SDAIAggregationType\SDAI__BAG__type\SDAI__BAG__subtype
	func makeIterator() -> Supertype.Iterator { return rep.makeIterator() }

	// SDAIAggregationType \SDAI__BAG__type\SDAI__BAG__subtype
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

	// InitializableBySet \SDAI__BAG__type\SDAI__BAG__subtype
	init<T: SDAI__SET__type>(_ settype: T) 
	where T.ELEMENT == ELEMENT, T.ELEMENT == T.Element
	{
		self.init( Supertype(settype) )
	}

	// InitializableByBag \SDAI__BAG__subtype
	init<T: SDAI__BAG__type>(_ bagtype: T) 
	where T.ELEMENT == ELEMENT, T.ELEMENT == T.Element
	{
		self.init( Supertype(bagtype) )
	}
	
	// SDAI__BAG__type \SDAI__BAG__subtype
	init(bound1: Int, bound2: Int?, _ elements: [SDAI.AggregationInitializerElement<ELEMENT>]) 
	{
		self.init( Supertype(bound1: bound1, bound2: bound2, elements) )
	}
	
	init(from swiftValue: SwiftType, loBound: Int = 0, hiBound: Int? = nil) {
		self.init( Supertype(from: swiftValue, loBound: loBound, hiBound: hiBound) )
	} 
}

public extension SDAI__BAG__subtype
where Supertype: InitializableBySubtypeSet
{
	// InitializableBySubtypeSet
	init<T:SDAI__SET__type>(_ subtype: T) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element
	{
		self.init( Supertype(subtype).asFundamentalType )
	}
}

public extension SDAI__BAG__subtype
where Supertype: InitializableBySubtypeBag
{
	// InitializableBySubtypeBag
	init<T:SDAI__BAG__type>(_ subtype: T) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element
	{
		self.init( Supertype(subtype).asFundamentalType )
	}	
}

public extension SDAI__BAG__subtype
where Supertype: InitializableBySubtypeListLiteral
{
	// InitializableBySubtypeListLiteral
	init<E:SDAIUnderlyingType>(bound1: Int = 0, bound2: Int? = nil, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E.FundamentalType == ELEMENT.FundamentalType
	{
		self.init( Supertype(bound1: bound1, bound2: bound2, elements) )
	}
}

public extension SDAI__BAG__subtype
where Supertype: InitializableBySwiftListLiteral
{
	init<E>(bound1: Int = 0, bound2: Int? = nil, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E == ELEMENT.SwiftType
	{
		self.init( Supertype(bound1:bound1, bound2:bound2, elements) )
	}
}

