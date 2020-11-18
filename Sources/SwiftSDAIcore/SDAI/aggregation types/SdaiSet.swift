//
//  SdaiSet.swift
//  
//
//  Created by Yoshida on 2020/10/10.
//

import Foundation


//MARK: - SET type
public protocol SDAISetType: SDAIBagType
{}

public protocol SDAI__SET__type: SDAISetType
{}

extension SDAI {
	public struct SET<ELEMENT:SDAIGenericType>: SDAI__SET__type, SDAIValue 
	{
		public typealias SwiftType = Set<ELEMENT>
		public typealias FundamentalType = Self
		fileprivate var rep: SwiftType
		private var bound1: Int
		private var bound2: Int?
		
		// Equatable \Hashable\SDAIGenericType\SDAIUnderlyingType \SDAIAggregationType\SDAI__BAG__type\SDAI__SET__type
		public static func == (lhs: SDAI.SET<ELEMENT>, rhs: SDAI.SET<ELEMENT>) -> Bool {
			return lhs.rep == rhs.rep &&
				lhs.bound1 == rhs.bound1 &&
				lhs.bound2 == rhs.bound2
		}
		
		// Hashable \SDAIGenericType\SDAIUnderlyingType \SDAIAggregationType\SDAI__BAG__type\SDAI__SET__type
		public func hash(into hasher: inout Hasher) {
			hasher.combine(rep)
			hasher.combine(bound1)
			hasher.combine(bound2)
		}

		// SDAIGenericType \SDAIUnderlyingType\SDAIAggregationType\SDAI__BAG__type\SDAI__SET__type
		public var typeMembers: Set<SDAI.STRING> {
			return [SDAI.STRING(Self.typeName)]
		}
		public var value: _BagValue<ELEMENT> {
			return _BagValue(from: self)
		}
		public init?<S>(possiblyFrom select: S) where S : SDAISelectType {
			if let base = select.setValue(elementType: ELEMENT.self) {
				self.init(base)
			}
			else { return nil }
		}

		// SDAIGenericType \SDAIUnderlyingType\SDAIAggregationType\SDAI__BAG__type\SDAI__SET__type
		public static var typeName: String { return "SET" }
		public var asSwiftType: SwiftType { return rep }
		public var asFundamentalType: FundamentalType { return self }
		public init(_ fundamental: FundamentalType) {
			self.init(from: fundamental.asSwiftType, loBound: fundamental.loBound, hiBound: fundamental.hiBound)
		}
	
		// Sequence \SDAIAggregationType\SDAI__BAG__type\SDAI__SET__type
		public func makeIterator() -> SwiftType.Iterator { return rep.makeIterator() }

		// SDAIAggregationType \SDAI__BAG__type\SDAI__SET__type
		public var hiBound: Int? { return bound2 }
		public var hiIndex: Int { return size }
		public var loBound: Int { return bound1 }
		public var loIndex: Int { return 1 }
		public var size: Int { return rep.count }
		public var _observer: EntityReferenceObserver?

		public subscript(index: Int?) -> ELEMENT? {
			guard let index = index, index >= loIndex, index <= hiIndex else { return nil }
			let setIndex = rep.index(rep.startIndex, offsetBy: index - loIndex)
			return rep[setIndex]
		}
		
		public func CONTAINS(_ elem: ELEMENT?) -> SDAI.LOGICAL {
			guard let elem = elem else { return UNKNOWN }
			return LOGICAL(rep.contains(elem))
		}
		
		public func QUERY(logical_expression: (ELEMENT) -> LOGICAL ) -> SET<ELEMENT> {
			return SET(from: rep.filter{ logical_expression($0).isTRUE }, hiBound: self.hiBound)
		}
		
//		// InitializableBySet \SDAI__BAG__type\SDAI__SET__type
//		public init<T: SDAI__SET__type>(_ setype: T) 
//		where T.ELEMENT == ELEMENT, T.ELEMENT == T.Element
//		{
//			self.init(bound1:setype.loBound, bound2:setype.hiBound, [setype]) { $0 }
//		}

		// SDAI__BAG__type\SDAI__SET__type
//		public init(bound1: Int, bound2: Int?, _ elements: [SDAI.AggregationInitializerElement<ELEMENT>]) {
//			self.init(bound1:bound1, bound2:bound2, elements){ $0 }
//		}

		public init(from swiftValue: SwiftType, loBound: Int = 0, hiBound: Int? = nil) {
			self.bound1 = loBound
			self.bound2 = hiBound
			self.rep = swiftValue
		}
		
		public init(loBound: Int = 0, hiBound: Int? = nil, _ emptyLiteral: SDAI.EmptyAggregateLiteral = SDAI.EMPLY_AGGREGATE) {
			self.init(from: SwiftType(), loBound: loBound, hiBound: hiBound)
		}

		public mutating func add(member: ELEMENT?) {
			guard let member = member else {return}
			rep.insert(member)
		}
		
		public mutating func remove(member: ELEMENT?) {
			guard let member = member else {return}
			rep.remove(member)
		}
		
		// SET specific
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
					swiftValue.insert(conv(elem))
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

extension SDAI.SET: InitializableByEntitySet
where ELEMENT: SDAI.EntityReference
{
	public init<T: SDAI__SET__type>(_ setype: T) 
	where T.ELEMENT: SDAI.EntityReference, T.Element == T.ELEMENT
	{
		self.init(bound1: setype.loBound, bound2: setype.hiBound, [setype]) { $0.complexEntity.entityReference(ELEMENT.self)! }		
	}
	
	public init(bound1: Int = 0, bound2: Int? = nil, _ elements: [SDAI.AggregationInitializerElement<SDAI.EntityReference>]) {
		self.init(bound1: bound1, bound2: bound2, elements) { $0.complexEntity.entityReference(ELEMENT.self)! }
	}
}

extension SDAI.SET: InitializableByDefinedtypeSet//, InitializableByDefinedtypeListLiteral
where ELEMENT: SDAIUnderlyingType
{
	// InitializableBySubtypeSet \SDAI__BAG__type\SDAI__SET__type
	public init<T: SDAI__SET__type>(_ subtype: T) 
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

extension SDAI.SET: InitializableBySwiftListLiteral where ELEMENT: SDAISimpleType
{
	public init<E>(bound1: Int = 0, bound2: Int? = nil, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E == ELEMENT.SwiftType
	{
		self.init(bound1:bound1, bound2:bound2, elements){ ELEMENT($0) }
	}
}

//MARK: -
public protocol SDAI__SET__subtype: SDAI__SET__type, SDAIDefinedType
where Supertype == SDAI.SET<ELEMENT>//: SDAI__SET__type,
//			Supertype.ELEMENT == ELEMENT,
//			Supertype.FundamentalType == SDAI.SET<ELEMENT>,
//			Supertype.SwiftType == SDAI.SET<ELEMENT>.SwiftType
{}
public extension SDAI__SET__subtype
{
//	// Sequence \SDAIAggregationType\SDAI__BAG__type\SDAI__SET__type\SDAI__SET__subtype
//	func makeIterator() -> Supertype.Iterator { return rep.makeIterator() }
//
//	// SDAIAggregationType \SDAI__BAG__type\SDAI__SET__type\SDAI__SET__subtype
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

//	// InitializableBySet \SDAI__BAG__type\SDAI__SET__type\SDAI__SET__subtype
//	init<T: SDAI__SET__type>(_ settype: T) 
//	where T.ELEMENT == ELEMENT, T.ELEMENT == T.Element
//	{
//		self.init( Supertype(settype) )
//	}

	// SDAI__BAG__type \SDAI__SET__type\SDAI__SET__subtype
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

public extension SDAI__SET__subtype
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

public extension SDAI__SET__subtype
where Supertype: InitializableByDefinedtypeSet
{
	// InitializableBySubtypeSet
	init<T:SDAI__SET__type>(_ subtype: T) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element
	{
		self.init( Supertype(subtype).asFundamentalType )
	}

	init<E:SDAIUnderlyingType>(bound1: Int = 0, bound2: Int? = nil, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E.FundamentalType == ELEMENT.FundamentalType
	{
		self.init( Supertype(bound1: bound1, bound2: bound2, elements) )
	}
}

//public extension SDAI__SET__subtype
//where Supertype: InitializableByDefinedtypeListLiteral
//{
//	// InitializableBySubtypeListLiteral
//	init<E:SDAIUnderlyingType>(bound1: Int = 0, bound2: Int? = nil, _ elements: [SDAI.AggregationInitializerElement<E>]) 
//	where E.FundamentalType == ELEMENT.FundamentalType
//	{
//		self.init( Supertype(bound1: bound1, bound2: bound2, elements) )
//	}
//}

public extension SDAI__SET__subtype
where Supertype: InitializableBySwiftListLiteral
{
	init<E>(bound1: Int = 0, bound2: Int? = nil, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E == ELEMENT.SwiftType
	{
		self.init( Supertype(bound1:bound1, bound2:bound2, elements) )
	}
}

