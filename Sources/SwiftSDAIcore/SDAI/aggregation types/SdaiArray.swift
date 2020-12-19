//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation


//MARK: - ARRAY type
public protocol SDAIArrayType: SDAIArrayOptionalType
{}

public protocol SDAI__ARRAY__type: SDAIArrayType, InitializableBySelecttypeArray
{}

extension SDAI {
	public typealias ARRAY_UNIQUE<ELEMENT> = ARRAY<ELEMENT> where ELEMENT: SDAIGenericType

	public struct ARRAY<ELEMENT:SDAIGenericType>: SDAI__ARRAY__type, SDAIValue
	{
		public typealias SwiftType = Array<ELEMENT>
		public typealias FundamentalType = Self
		fileprivate var rep: SwiftType
		private var bound1: Int
		private var bound2: Int
		
		// Equatable \Hashable\SDAIGenericType\SDAIUnderlyingType \SDAIAggregationType\SDAI__ARRAY_OPTIONAL__type\SDAI__ARRAY__type
		public static func == (lhs: SDAI.ARRAY<ELEMENT>, rhs: SDAI.ARRAY<ELEMENT>) -> Bool {
			return lhs.rep == rhs.rep &&
				lhs.bound1 == rhs.bound1 &&
				lhs.bound2 == rhs.bound2
		}
		
		// Hashable \SDAIGenericType\SDAIUnderlyingType \SDAIAggregationType\SDAI__ARRAY_OPTIONAL__type\SDAI__ARRAY__type
		public func hash(into hasher: inout Hasher) {
			hasher.combine(rep)
			hasher.combine(bound1)
			hasher.combine(bound2)
		}

		// SDAIGenericType \SDAIUnderlyingType\SDAIAggregationType\SDAI__ARRAY_OPTIONAL__type\SDAI__ARRAY__type
		public var typeMembers: Set<SDAI.STRING> {
			return [SDAI.STRING(Self.typeName)]
		}
		public var value: _ArrayValue<ELEMENT> {
			return _ArrayValue(from: self)
		}
		public init?<S>(possiblyFrom select: S?) where S : SDAISelectType {
			if let base = select?.arrayValue(elementType: ELEMENT.self) {
				self.init(base)
			}
			else { return nil }
		}

		// SDAIUnderlyingType \SDAIAggregationType\SDAI__ARRAY_OPTIONAL__type\SDAI__ARRAY__type
		public static var typeName: String { return "ARRAY" }
		public var asSwiftType: SwiftType { return rep }
		public var asFundamentalType: FundamentalType { return self }
		public init(fundamental: FundamentalType) {
			self.init(from: fundamental.asSwiftType, bound1: fundamental.loIndex, bound2: fundamental.hiIndex)
		}
		
		// Sequence \SDAIAggregationType\SDAI__ARRAY_OPTIONAL__type\SDAI__ARRAY__type
		public func makeIterator() -> SwiftType.Iterator { return rep.makeIterator() }

		// SDAIAggregationType \SDAI__ARRAY_OPTIONAL__type\SDAI__ARRAY__type
		public var hiBound: Int? { return bound2 }
		public var hiIndex: Int { return bound2 }
		public var loBound: Int { return bound1 }
		public var loIndex: Int { return bound1 }
		public var size: Int { return bound2 - bound1 + 1 }
		public var _observer: EntityReferenceObserver?
		
		public subscript(index: Int?) -> ELEMENT? {
			guard let index = index, index >= loIndex, index <= hiIndex else { return nil }
			return rep[index - loIndex]
		}
		
		public func CONTAINS(_ elem: ELEMENT?) -> SDAI.LOGICAL {
			guard let elem = elem else { return UNKNOWN }
			return LOGICAL(rep.contains(elem))
		}
		
		public func QUERY(logical_expression: (ELEMENT) -> LOGICAL ) -> ARRAY_OPTIONAL<ELEMENT> {
			let filtered = rep.map { (elem) -> ELEMENT? in
				if logical_expression(elem).isTRUE { return elem }
				else { return nil }
			}
			return ARRAY_OPTIONAL(from: filtered, bound1: self.loIndex ,bound2: self.hiIndex)
		}

		// SDAI__ARRAY_OPTIONAL__type \SDAI__ARRAY__type
		public init(from swiftValue: SwiftType, bound1: Int, bound2: Int) {
			self.bound1 = bound1
			self.bound2 = bound2
			self.rep = swiftValue
			assert(rep.count == self.size)
		} 

		// InitializableBySelecttypeArray
		public init<E: SDAISelectType>(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<E>]) {
			self.init(bound1:bound1, bound2:bound2, elements){ ELEMENT(possiblyFrom: $0)! }
		} 
		
		public init<T: SDAI__ARRAY__type>(_ arraytype: T) 
		where T.ELEMENT: SDAISelectType, T.Element == T.ELEMENT
		{
			self.init(bound1:arraytype.loIndex, bound2:arraytype.hiIndex, [arraytype]){ ELEMENT(possiblyFrom: $0)! }
		}
	
		// ARRAY specific
		private init<S:Sequence>(bound1: Int, bound2: Int, _ elements: [S], conv: (S.Element) -> ELEMENT )
		{
			var swiftValue = SwiftType()
			swiftValue.reserveCapacity(bound2 - bound1 + 1)
			for aie in elements {
				for elem in aie {
					swiftValue.append(conv(elem))
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

extension SDAI.ARRAY: InitializableByEntityArray
where ELEMENT: SDAI.EntityReference
{
	// InitializableByArray \SDAI__ARRAY_OPTIONAL__type\SDAI__ARRAY__type
	public init(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<SDAI.EntityReference>]) {
		self.init(bound1:bound1, bound2:bound2, elements){ ($0?.complexEntity.entityReference(ELEMENT.self))! }
	} 

	public init<T: SDAI__ARRAY__type>(_ arraytype: T) 
	where T.ELEMENT: SDAI.EntityReference, T.Element == T.ELEMENT
	{
		self.init(bound1:arraytype.loIndex, bound2:arraytype.hiIndex, [arraytype]) { $0.complexEntity.entityReference(ELEMENT.self)! }
	}		
}

extension SDAI.ARRAY: InitializableByDefinedtypeArray 
where ELEMENT: SDAIUnderlyingType
{
	// InitializableBySubtypeArray \SDAI__ARRAY_OPTIONAL__type\SDAI__ARRAY__type
	public init<E: SDAIUnderlyingType>(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E.FundamentalType == ELEMENT.FundamentalType
	{
		self.init(bound1:bound1, bound2:bound2, elements){ ELEMENT(fundamental: $0!.asFundamentalType) }
	}		
	
	public init<T: SDAI__ARRAY__type>(_ arraytype: T) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element
	{
		self.init(bound1:arraytype.loIndex, bound2:arraytype.hiIndex, [arraytype]) { ELEMENT($0) }
	}
}

extension SDAI.ARRAY
where ELEMENT: SDAISelectType
{
	init<E: SDAI.EntityReference>(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<E>])
	{
		self.init(bound1:bound1, bound2:bound2, elements){ ELEMENT(possiblyFrom: $0)! }
	}
	init<E: SDAIUnderlyingType>(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<E>])
	{
		self.init(bound1:bound1, bound2:bound2, elements){ ELEMENT(possiblyFrom: $0)! }
	}
	init<E: SDAISelectType>(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<E>])
	{
		self.init(bound1:bound1, bound2:bound2, elements){ ELEMENT(possiblyFrom: $0)! }
	}
	
	init?<T: SDAI__ARRAY__type>(_ arraytype: T?) 
	where T.Element == T.ELEMENT, T.ELEMENT: SDAI.EntityReference
	{
		guard let arraytype = arraytype else { return nil }
		self.init(arraytype)
	}
	init?<T: SDAI__ARRAY__type>(_ arraytype: T?) 
	where T.Element == T.ELEMENT, T.ELEMENT: SDAIUnderlyingType
	{
		guard let arraytype = arraytype else { return nil }
		self.init(arraytype)
	}
	init?<T: SDAI__ARRAY__type>(_ arraytype: T?) 
	where T.Element == T.ELEMENT, T.ELEMENT: SDAISelectType
	{
		guard let arraytype = arraytype else { return nil }
		self.init(arraytype)
	}

	init<T: SDAI__ARRAY__type>(_ arraytype: T) 
	where T.Element == T.ELEMENT, T.ELEMENT: SDAI.EntityReference
	{
		self.init(bound1:arraytype.loIndex, bound2:arraytype.hiIndex, [arraytype]){ ELEMENT(possiblyFrom: $0)! }
	}
	init<T: SDAI__ARRAY__type>(_ arraytype: T) 
	where T.Element == T.ELEMENT, T.ELEMENT: SDAIUnderlyingType
	{
		self.init(bound1:arraytype.loIndex, bound2:arraytype.hiIndex, [arraytype]){ ELEMENT(possiblyFrom: $0)! }
	}
	init<T: SDAI__ARRAY__type>(_ arraytype: T) 
	where T.Element == T.ELEMENT, T.ELEMENT: SDAISelectType
	{
		self.init(bound1:arraytype.loIndex, bound2:arraytype.hiIndex, [arraytype]){ ELEMENT(possiblyFrom: $0)! }
	}
}

extension SDAI.ARRAY: InitializableByOptionalSwiftArrayLiteral 
where ELEMENT: SDAISimpleType
{
	public init<E>(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E == ELEMENT.SwiftType
	{
		self.init(bound1:bound1, bound2:bound2, elements){ ELEMENT($0!) }
	}
}


