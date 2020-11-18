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
public protocol InitializableByEntityBag
{
	associatedtype ELEMENT: SDAI.EntityReference

	init(bound1: Int, bound2: Int?, _ elements: [SDAI.AggregationInitializerElement<SDAI.EntityReference>]) 

	init?<T: SDAI__BAG__type>(_ bagtype: T?) 
	where T.ELEMENT: SDAI.EntityReference, T.Element == T.ELEMENT

	init<T: SDAI__BAG__type>(_ bagtype: T) 
	where T.ELEMENT: SDAI.EntityReference, T.Element == T.ELEMENT
}
public extension InitializableByEntityBag
{
	init?<T: SDAI__BAG__type>(_ bagtype: T?) 
	where T.ELEMENT: SDAI.EntityReference, T.Element == T.ELEMENT
	{
		guard let bagtype = bagtype else { return nil }
		self.init(bagtype)
	}
}

public protocol InitializableByDefinedtypeBag
{
	associatedtype ELEMENT: SDAIUnderlyingType

	init<E: SDAIUnderlyingType>(bound1: Int, bound2: Int?, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E.FundamentalType == ELEMENT.FundamentalType

	init?<T: SDAI__BAG__type>(_ subtype: T?) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element
	
	init<T: SDAI__BAG__type>(_ subtype: T) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element
}
public extension InitializableByDefinedtypeBag
{
	init?<T: SDAI__BAG__type>(_ subtype: T?) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element
	{
		guard let subtype = subtype else { return nil }
		self.init(subtype)
	}
}



public protocol InitializableByEntitySet
{
	associatedtype ELEMENT: SDAI.EntityReference

	init(bound1: Int, bound2: Int?, _ elements: [SDAI.AggregationInitializerElement<SDAI.EntityReference>]) 

	init?<T: SDAI__SET__type>(_ setype: T?) 
	where T.ELEMENT: SDAI.EntityReference, T.Element == T.ELEMENT

	init<T: SDAI__SET__type>(_ setype: T) 
	where T.ELEMENT: SDAI.EntityReference, T.Element == T.ELEMENT
}
public extension InitializableByEntitySet
{
	init?<T: SDAI__SET__type>(_ setype: T?) 
	where T.ELEMENT: SDAI.EntityReference, T.Element == T.ELEMENT
	{
		guard let setype = setype else { return nil }
		self.init(setype)
	}
}

public protocol InitializableByDefinedtypeSet
{
	associatedtype ELEMENT: SDAIUnderlyingType

	init<E: SDAIUnderlyingType>(bound1: Int, bound2: Int?, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E.FundamentalType == ELEMENT.FundamentalType

	init?<T: SDAI__SET__type>(_ subtype: T?) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element
	
	init<T: SDAI__SET__type>(_ subtype: T) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element
}
public extension InitializableByDefinedtypeSet
{
	init?<T: SDAI__SET__type>(_ subtype: T?) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element
	{
		guard let subtype = subtype else { return nil}
		self.init(subtype)
	}
}


//MARK: - BAG type
public protocol SDAIBagType: SDAIAggregationType//, InitializableBySet 
{
//	init(bound1: Int, bound2: Int?, _ elements: [SDAI.AggregationInitializerElement<ELEMENT>]) 

	init(from swiftValue: SwiftType, loBound: Int, hiBound: Int?) 
	init(loBound: Int, hiBound: Int?, _ emptyLiteral: SDAI.EmptyAggregateLiteral) 
	
	mutating func add(member: ELEMENT?)
	mutating func remove(member: ELEMENT?)
}

public protocol SDAI__BAG__type: SDAIBagType
{}

extension SDAI {
	public struct BAG<ELEMENT:SDAIGenericType>: SDAI__BAG__type, SDAIValue//, InitializableByBag 
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
		public var typeMembers: Set<SDAI.STRING> {
			return [SDAI.STRING(Self.typeName)]
		}
		public var value: _BagValue<ELEMENT> {
			return _BagValue(from: self)
		}
		public init?<S>(possiblyFrom select: S) where S : SDAISelectType {
			if let base = select.bagValue(elementType: ELEMENT.self) {
				self.init(base)
			}
			else { return nil }
		}
		
		// SDAIUnderlyingType \SDAIAggregationType\SDAI__BAG__type
		public static var typeName: String { return "BAG" }
		public var asSwiftType: SwiftType { return rep }
		public var asFundamentalType: FundamentalType { return self }
		public init(_ fundamental: FundamentalType) {
			self.init(from: fundamental.asSwiftType, loBound: fundamental.loBound, hiBound: fundamental.hiBound)
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

		public subscript(index: Int?) -> ELEMENT? {
			guard let index = index, index >= loIndex, index <= hiIndex else { return nil }
			return rep[index - loIndex]
		}
		
		public func CONTAINS(_ elem: ELEMENT?) -> SDAI.LOGICAL {
			guard let elem = elem else { return UNKNOWN }
			return LOGICAL(rep.contains(elem))
		}
		
		public func QUERY(logical_expression: (ELEMENT) -> LOGICAL ) -> BAG<ELEMENT> {
			return BAG(from: rep.filter{ logical_expression($0).isTRUE }, hiBound: self.hiBound)
		}
		
//		// InitializableBySet \SDAI__BAG__type
//		public init<T: SDAI__SET__type>(_ setype: T) 
//		where T.ELEMENT == ELEMENT, T.ELEMENT == T.Element
//		{
//			self.init(bound1:setype.loBound, bound2:setype.hiBound, [setype]) { $0 }
//		}

		// SDAIBagType
//		public init(bound1: Int, bound2: Int?, _ elements: [SDAI.AggregationInitializerElement<ELEMENT>])
//		{
//			self.init(bound1:bound1, bound2:bound2, elements){ $0 }
//		}
//
		public init(from swiftValue: SwiftType, loBound: Int = 0, hiBound: Int? = nil) 
		{
			bound1 = loBound
			bound2 = hiBound
			rep = swiftValue
		}
		
		public init(loBound: Int = 0, hiBound: Int? = nil, _ emptyLiteral: SDAI.EmptyAggregateLiteral = SDAI.EMPLY_AGGREGATE) 
		{
			self.init(from: SwiftType(), loBound: loBound, hiBound: hiBound)
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
		
//		// InitializableByBag
//		public init<T: SDAI__BAG__type>(_ bagtype: T) 
//		where T.ELEMENT == ELEMENT, T.ELEMENT == T.Element
//		{
//			self.init(bound1:bagtype.loBound, bound2:bagtype.hiBound, [bagtype]) { $0 }
//		}
		
		// BAG specific
		private init<S:Sequence>(bound1: Int, bound2: Int?, _ elements: [S], conv: (S.Element) -> ELEMENT )
		{
//			self.bound1 = bound1
//			self.bound2 = bound2
//			self.rep = []
			var swiftValue = SwiftType()
			if let hi = bound2 {
				swiftValue.reserveCapacity(hi)
			}
			for aie in elements {
				for elem in aie {
					swiftValue.append(conv(elem))
				}
			}
			self.init(from: swiftValue, loBound: bound1, hiBound: bound2)
		}
		
		// SDAIValue
		public func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool 
		{
			if let rhs = rhs as? Self { return self == rhs }
			return false
		}
		
	}
}

extension SDAI.BAG: InitializableByEntitySet, InitializableByEntityBag 
where ELEMENT: SDAI.EntityReference
{
	public init<T: SDAI__SET__type>(_ setype: T) 
	where T.ELEMENT: SDAI.EntityReference, T.Element == T.ELEMENT
	{
		self.init(bound1: setype.loBound, bound2: setype.hiBound, [setype]) { $0.complexEntity.entityReference(ELEMENT.self)! }		
	}
	
	public init<T: SDAI__BAG__type>(_ bagtype: T) 
	where T.ELEMENT: SDAI.EntityReference, T.Element == T.ELEMENT
	{
		self.init(bound1: bagtype.loBound, bound2: bagtype.hiBound, [bagtype]) { $0.complexEntity.entityReference(ELEMENT.self)! }		
	}

	public init(bound1: Int = 0, bound2: Int? = nil, _ elements: [SDAI.AggregationInitializerElement<SDAI.EntityReference>]) {
		self.init(bound1: bound1, bound2: bound2, elements) { $0.complexEntity.entityReference(ELEMENT.self)! }
	}
}

extension SDAI.BAG: InitializableByDefinedtypeSet, InitializableByDefinedtypeBag//, InitializableByDefinedtypeListLiteral
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
	public init<E>(bound1: Int = 0, bound2: Int? = nil, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E == ELEMENT.SwiftType
	{
		self.init(bound1:bound1, bound2:bound2, elements){ ELEMENT($0) }
	}
}

//MARK: -
public protocol SDAI__BAG__subtype: SDAI__BAG__type, SDAIDefinedType//, InitializableByBag
where Supertype == SDAI.BAG<ELEMENT>//: SDAI__BAG__type & InitializableByBag,
//			Supertype.ELEMENT == ELEMENT,
//			Supertype.FundamentalType == SDAI.BAG<ELEMENT>,
//			Supertype.SwiftType == SDAI.BAG<ELEMENT>.SwiftType
{}
public extension SDAI__BAG__subtype
{
//	// Sequence \SDAIAggregationType\SDAI__BAG__type\SDAI__BAG__subtype
//	func makeIterator() -> Supertype.Iterator { return rep.makeIterator() }
//
//	// SDAIAggregationType \SDAI__BAG__type\SDAI__BAG__subtype
//	var hiBound: Int? { return rep.hiBound }
//	var hiIndex: Int { return rep.hiIndex }
//	var loBound: Int { return rep.loBound }
//	var loIndex: Int { return rep.loIndex }
//	var size: Int { return rep.size }
//	var _observer: EntityReferenceObserver? {
//		get { return rep._observer }
//		set { rep._observer = newValue }
//	}
//
//	subscript<I: SDAI__INTEGER__type>(index: I?) -> ELEMENT? {
//		return rep[index]
//	}
//	
//	func QUERY(logical_expression: (ELEMENT) -> SDAI.LOGICAL ) -> Supertype.RESULT_AGGREGATE {
//		return rep.QUERY(logical_expression: logical_expression)
//	}

	// InitializableBySet \SDAI__BAG__type\SDAI__BAG__subtype
//	init<T: SDAI__SET__type>(_ settype: T) 
//	where T.ELEMENT == ELEMENT, T.ELEMENT == T.Element
//	{
//		self.init( Supertype(settype) )
//	}

	// InitializableByBag \SDAI__BAG__subtype
//	init<T: SDAI__BAG__type>(_ bagtype: T) 
//	where T.ELEMENT == ELEMENT, T.ELEMENT == T.Element
//	{
//		self.init( Supertype(bagtype) )
//	}
	
	// SDAI__BAG__type \SDAI__BAG__subtype
//	init(bound1: Int, bound2: Int?, _ elements: [SDAI.AggregationInitializerElement<ELEMENT>]) 
//	{
//		self.init( Supertype(bound1: bound1, bound2: bound2, elements) )
//	}
	
	// SDAIGenericType
	init?<S: SDAISelectType>(possiblyFrom select: S) {
		guard let supertype = Supertype(possiblyFrom: select) else { return nil }
		self.init(supertype)
	}
	
	init(from swiftValue: SwiftType, loBound: Int = 0, hiBound: Int? = nil) {
		self.init( Supertype(from: swiftValue, loBound: loBound, hiBound: hiBound) )
	} 
	
	init(loBound: Int = 0, hiBound: Int? = nil, _ emptyLiteral: SDAI.EmptyAggregateLiteral = SDAI.EMPLY_AGGREGATE) {
		self.init( Supertype(loBound: loBound, hiBound: hiBound, emptyLiteral) )
	} 
}

public extension SDAI__BAG__subtype
where Supertype: InitializableByEntitySet
{
	init<T: SDAI__SET__type>(_ settype: T) 
	where T.ELEMENT: SDAI.EntityReference, T.Element == T.ELEMENT
	{
		self.init( Supertype(settype) )
	}	
	
	init(bound1: Int = 0, bound2: Int? = nil, _ elements: [SDAI.AggregationInitializerElement<SDAI.EntityReference>]) {
		self.init( Supertype(bound1: bound1, bound2: bound2, elements) )
	}
}

public extension SDAI__BAG__subtype
where Supertype: InitializableByEntityBag
{
	init<T: SDAI__BAG__type>(_ bagtype: T) 
	where T.ELEMENT: SDAI.EntityReference, T.Element == T.ELEMENT
	{
		self.init( Supertype(bagtype) )
	}	
}

public extension SDAI__BAG__subtype
where Supertype: InitializableByDefinedtypeSet
{
	init<T:SDAI__SET__type>(_ settype: T) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element
	{
		self.init( Supertype(settype).asFundamentalType )
	}

	init<E:SDAIUnderlyingType>(bound1: Int = 0, bound2: Int? = nil, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E.FundamentalType == ELEMENT.FundamentalType
	{
		self.init( Supertype(bound1: bound1, bound2: bound2, elements) )
	}
}

public extension SDAI__BAG__subtype
where Supertype: InitializableByDefinedtypeBag
{
	init<T:SDAI__BAG__type>(_ bagtype: T) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element
	{
		self.init( Supertype(bagtype).asFundamentalType )
	}	
}

//public extension SDAI__BAG__subtype
//where Supertype: InitializableByDefinedtypeListLiteral
//{
//	// InitializableBySubtypeListLiteral
//	init<E:SDAIUnderlyingType>(bound1: Int = 0, bound2: Int? = nil, _ elements: [SDAI.AggregationInitializerElement<E>]) 
//	where E.FundamentalType == ELEMENT.FundamentalType
//	{
//		self.init( Supertype(bound1: bound1, bound2: bound2, elements) )
//	}
//}

public extension SDAI__BAG__subtype
where Supertype: InitializableBySwiftListLiteral
{
	init<E>(bound1: Int = 0, bound2: Int? = nil, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E == ELEMENT.SwiftType
	{
		self.init( Supertype(bound1:bound1, bound2:bound2, elements) )
	}
}

