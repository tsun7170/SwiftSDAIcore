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

public protocol SDAI__SET__type: SDAISetType, InitializableBySelecttypeSet
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
		public init?<S>(possiblyFrom select: S?) where S : SDAISelectType {
			if let base = select?.setValue(elementType: ELEMENT.self) {
				self.init(base)
			}
			else { return nil }
		}

		// SDAIGenericType \SDAIUnderlyingType\SDAIAggregationType\SDAI__BAG__type\SDAI__SET__type
		public static var typeName: String { return "SET" }
		public var asSwiftType: SwiftType { return rep }
		public var asFundamentalType: FundamentalType { return self }
		public init(fundamental: FundamentalType) {
			self.init(from: fundamental.asSwiftType, bound1: fundamental.loBound, bound2: fundamental.hiBound)
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
			return SET(from: rep.filter{ logical_expression($0).isTRUE }, bound1:self.loBound, bound2: self.hiBound)
		}
		
		// InitializableBySelecttypeSet
		public init<E: SDAISelectType>(bound1: Int = 0, bound2: Int? = nil, _ elements: [SDAI.AggregationInitializerElement<E>]) {
			self.init(bound1:bound1, bound2:bound2, elements){ ELEMENT(possiblyFrom: $0)! }
		} 
		
		public init<T: SDAI__SET__type>(bound1: Int, bound2: Int?, _ settype: T) 
		where T.ELEMENT: SDAISelectType, T.ELEMENT == T.Element
		{
			self.init(bound1:bound1, bound2:bound2, [settype]){ ELEMENT(possiblyFrom: $0)! }
		}		
		
		// SDAI__BAG__type\SDAI__SET__type
		public init(from swiftValue: SwiftType, bound1: Int = 0, bound2: Int? = nil) {
			self.bound1 = bound1
			self.bound2 = bound2
			self.rep = swiftValue
		}
		
		public init(bound1: Int = 0, bound2: Int? = nil, _ emptyLiteral: SDAI.EmptyAggregateLiteral = SDAI.EMPLY_AGGREGATE) {
			self.init(from: SwiftType(), bound1: bound1, bound2: bound2)
		}

		public mutating func set(bound1: Int, bound2: Int?) {
			self.bound1 = bound1
			self.bound2 = bound2
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
			var swiftValue = SwiftType()
			if let hi = bound2 {
				swiftValue.reserveCapacity(hi)
			}
			for aie in elements {
				for elem in aie {
					swiftValue.insert(conv(elem))
				}
			}
			self.init(from: swiftValue, bound1: bound1, bound2: bound2)
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
	public init<T: SDAI__SET__type>(bound1: Int, bound2: Int?, _ setype: T) 
	where T.ELEMENT: SDAI.EntityReference, T.Element == T.ELEMENT
	{
		self.init(bound1: bound1, bound2: bound2, [setype]) { $0.complexEntity.entityReference(ELEMENT.self)! }		
	}
	
	public init(bound1: Int = 0, bound2: Int? = nil, _ elements: [SDAI.AggregationInitializerElement<SDAI.EntityReference>]) {
		self.init(bound1: bound1, bound2: bound2, elements) { ($0?.complexEntity.entityReference(ELEMENT.self))! }
	}
}

extension SDAI.SET: InitializableByDefinedtypeSet
where ELEMENT: SDAIUnderlyingType
{
	// InitializableBySubtypeSet \SDAI__BAG__type\SDAI__SET__type
	public init<T: SDAI__SET__type>(bound1: Int, bound2: Int?, _ settype: T) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element
	{
		self.init(bound1:bound1, bound2:bound2, [settype]) { ELEMENT($0) }
	}
	
	// InitializableBySubtypeListLiteral
	public init<E:SDAIUnderlyingType>(bound1: Int = 0, bound2: Int? = nil, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E.FundamentalType == ELEMENT.FundamentalType
	{
		self.init(bound1:bound1, bound2:bound2, elements){ ELEMENT(fundamental: $0!.asFundamentalType) }
	}		
}


extension SDAI.SET
where ELEMENT: SDAISelectType
{
	init<E: SDAI.EntityReference>(bound1: Int = 0, bound2: Int? = nil, _ elements: [SDAI.AggregationInitializerElement<E>])
	{
		self.init(bound1:bound1, bound2:bound2, elements){ ELEMENT(possiblyFrom: $0)! }
	}
	init<E: SDAIUnderlyingType>(bound1: Int = 0, bound2: Int? = nil, _ elements: [SDAI.AggregationInitializerElement<E>])
	{
		self.init(bound1:bound1, bound2:bound2, elements){ ELEMENT(possiblyFrom: $0)! }
	}
	init<E: SDAISelectType>(bound1: Int = 0, bound2: Int? = nil, _ elements: [SDAI.AggregationInitializerElement<E>])
	{
		self.init(bound1:bound1, bound2:bound2, elements){ ELEMENT(possiblyFrom: $0)! }
	}
	
	init?<T: SDAI__SET__type>(_ settype: T?) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAI.EntityReference
	{
		guard let settype = settype else { return nil }
		self.init(settype)
	}
	init?<T: SDAI__SET__type>(_ settype: T?) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAIUnderlyingType
	{
		guard let settype = settype else { return nil }
		self.init(settype)
	}
	init?<T: SDAI__SET__type>(_ settype: T?) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAISelectType
	{
		guard let settype = settype else { return nil }
		self.init(settype)
	}

	init<T: SDAI__SET__type>(_ settype: T) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAI.EntityReference
	{
		self.init(bound1:settype.loBound, bound2:settype.hiBound, [settype]){ ELEMENT(possiblyFrom: $0)! }
	}
	init<T: SDAI__SET__type>(_ settype: T) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAIUnderlyingType
	{
		self.init(bound1:settype.loBound, bound2:settype.hiBound, [settype]){ ELEMENT(possiblyFrom: $0)! }
	}
	init<T: SDAI__SET__type>(_ settype: T) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAISelectType
	{
		self.init(bound1:settype.loBound, bound2:settype.hiBound, [settype]){ ELEMENT(possiblyFrom: $0)! }
	}
	
	init?<T: SDAI__SET__type>(bound1: Int, bound2: Int?, _ settype: T?) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAI.EntityReference
	{
		guard let settype = settype else { return nil }
		self.init(bound1: bound1, bound2: bound2, settype)
	}
	init?<T: SDAI__SET__type>(bound1: Int, bound2: Int?, _ settype: T?) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAIUnderlyingType
	{
		guard let settype = settype else { return nil }
		self.init(bound1: bound1, bound2: bound2, settype)
	}
	init?<T: SDAI__SET__type>(bound1: Int, bound2: Int?, _ settype: T?) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAISelectType
	{
		guard let settype = settype else { return nil }
		self.init(bound1: bound1, bound2: bound2, settype)
	}

	init<T: SDAI__SET__type>(bound1: Int, bound2: Int?, _ settype: T) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAI.EntityReference
	{
		self.init(bound1:bound1, bound2:bound2, [settype]){ ELEMENT(possiblyFrom: $0)! }
	}
	init<T: SDAI__SET__type>(bound1: Int, bound2: Int?, _ settype: T) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAIUnderlyingType
	{
		self.init(bound1:bound1, bound2:bound2, [settype]){ ELEMENT(possiblyFrom: $0)! }
	}
	init<T: SDAI__SET__type>(bound1: Int, bound2: Int?, _ settype: T) 
	where T.ELEMENT == T.Element, T.ELEMENT: SDAISelectType
	{
		self.init(bound1:bound1, bound2:bound2, [settype]){ ELEMENT(possiblyFrom: $0)! }
	}
}


extension SDAI.SET: InitializableBySwiftListLiteral 
where ELEMENT: SDAISimpleType
{
	public init<E>(bound1: Int = 0, bound2: Int? = nil, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E == ELEMENT.SwiftType
	{
		self.init(bound1:bound1, bound2:bound2, elements){ ELEMENT($0!) }
	}
}

