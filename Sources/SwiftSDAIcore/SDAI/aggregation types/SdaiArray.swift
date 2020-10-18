//
//  SdaiArray.swift
//  
//
//  Created by Yoshida on 2020/09/22.
//

import Foundation

//MARK: - Value comparison support
extension SDAI {
	public struct _ArrayValue<ELEMENT: SDAIGenericType>: SDAIValue
	{
		typealias ElementValue = ELEMENT.Value
		
		var loIndex: Int
		var hiIndex: Int
		var size: Int { hiIndex - loIndex + 1 }
		var elements: AnySequence<ElementValue?>
		
		// Equatable \Hashable\SDAIValue
		public static func == (lhs: _ArrayValue<ELEMENT>, rhs: _ArrayValue<ELEMENT>) -> Bool {
			return lhs.isValueEqual(to: rhs)
		}
		
		// Hashable \SDAIValue
		public func hash(into hasher: inout Hasher) {
			hasher.combine(loIndex)
			hasher.combine(hiIndex)
			elements.forEach { hasher.combine($0) }
		}
		
		// SDAIValue
		public func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool {
			guard let rav = rhs as? Self else { return false }
			if rav.loIndex != self.loIndex || rav.hiIndex != self.hiIndex { return false }

			return self.elements.elementsEqual(rav.elements) { (le, re) -> Bool in
				guard let le = le else { return re == nil }
				guard let re = re else { return false }
				return le.isValueEqual(to: re)
			}
		}
		
		public func isValueEqualOptionally<T: SDAIValue>(to rhs: T?) -> Bool? {
			guard let rhs = rhs else { return nil }
			guard let rav = rhs as? Self else { return false }
			if rav.loIndex != self.loIndex || rav.hiIndex != self.hiIndex { return false }

			var result: Bool? = true
			let riter = rav.elements.makeIterator()
			for le in self.elements {
				let re = riter.next()
				if let le = le, let re = re, let eeq = le.isValueEqualOptionally(to: re), !eeq { return false }
				else { result = nil }
			}
			return result
		}

		// _ArrayValue specific
		init(from array: ARRAY_OPTIONAL<ELEMENT>) {
			loIndex = array.loIndex
			hiIndex = array.hiIndex
			elements = AnySequence( array.lazy.map{ $0?.value } )
		}
		
		init(from array: ARRAY<ELEMENT>) {
			loIndex = array.loIndex
			hiIndex = array.hiIndex
			elements = AnySequence( array.lazy.map{ $0.value } )
		}
		
	}
}

//MARK: -
public protocol InitializableByOptionalArray
{
	associatedtype ELEMENT: SDAIGenericType
	
	init(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<ELEMENT?>]) 

	init?<T: SDAI__ARRAY_OPTIONAL__type>(_ arraytype: T?) 
	where T.ELEMENT == ELEMENT

	init<T: SDAI__ARRAY_OPTIONAL__type>(_ arraytype: T) 
	where T.ELEMENT == ELEMENT
}
public extension InitializableByOptionalArray
{
	init?<T: SDAI__ARRAY_OPTIONAL__type>(_ arraytype: T?) 
	where T.ELEMENT == ELEMENT
	{
		guard let arraytype = arraytype else { return nil }
		self.init(arraytype)
	}
}

public protocol InitializableByOptionalSubtypeArray
{
	associatedtype ELEMENT: SDAIUnderlyingType
	
	init<E: SDAIUnderlyingType>(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<E?>]) 
	where E.FundamentalType == ELEMENT.FundamentalType

	init?<T: SDAI__ARRAY_OPTIONAL__type>(_ subtype: T?) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType

	init<T: SDAI__ARRAY_OPTIONAL__type>(_ subtype: T) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType
}
public extension InitializableByOptionalSubtypeArray
{
	init?<T: SDAI__ARRAY_OPTIONAL__type>(_ subtype: T?) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType
	{
		guard let subtype = subtype else { return nil }
		self.init(subtype)
	}
}

public protocol InitializableByOptionalSwiftArrayLiteral
{
	associatedtype ELEMENT: SDAISimpleType

	init<E>(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<E?>]) 
	where E == ELEMENT.SwiftType
}


//MARK: -
public protocol InitializableByArray
{
	associatedtype ELEMENT: SDAIGenericType
	
	init(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<ELEMENT>]) 

	init?<T: SDAI__ARRAY__type>(_ arraytype: T?) 
	where T.ELEMENT == ELEMENT, T.ELEMENT == T.Element

	init<T: SDAI__ARRAY__type>(_ arraytype: T) 
	where T.ELEMENT == ELEMENT, T.ELEMENT == T.Element
}
public extension InitializableByArray
{
	init?<T: SDAI__ARRAY__type>(_ arraytype: T?) 
	where T.ELEMENT == ELEMENT, T.ELEMENT == T.Element
	{
		guard let arraytype = arraytype else { return nil }
		self.init(arraytype)
	}
}

public protocol InitializableBySubtypeArray
{
	associatedtype ELEMENT: SDAIUnderlyingType
	
	init<E: SDAIUnderlyingType>(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E.FundamentalType == ELEMENT.FundamentalType

	init?<T: SDAI__ARRAY__type>(_ subtype: T?) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element

	init<T: SDAI__ARRAY__type>(_ subtype: T) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element
}
public extension InitializableBySubtypeArray
{
	init?<T: SDAI__ARRAY__type>(_ subtype: T?) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element
	{
		guard let subtype = subtype else { return nil}
		self.init(subtype)
	}
}

public protocol InitializableBySwiftArrayLiteral
{
	associatedtype ELEMENT: SDAISimpleType

	init<E>(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E == ELEMENT.SwiftType
}


//MARK: - ARRAY_OPTIONAL type
public protocol SDAI__ARRAY_OPTIONAL__type: SDAIAggregationType, InitializableByArray
{
	init(from swiftValue: SwiftType, loBound: Int, hiBound: Int) 
}

//MARK: -
extension SDAI {
	public struct ARRAY_OPTIONAL<ELEMENT:SDAIGenericType>: SDAI__ARRAY_OPTIONAL__type, InitializableByOptionalArray 
	{
		public typealias SwiftType = Array<ELEMENT?>
		public typealias FundamentalType = Self
		fileprivate var rep: SwiftType
		private var bound1: Int
		private var bound2: Int
		
		// Equatable \Hashable\SDAIGenericType\SDAIUnderlyingType\SDAIAggregationType\SDAI__ARRAY_OPTIONAL__type
		public static func == (lhs: SDAI.ARRAY_OPTIONAL<ELEMENT>, rhs: SDAI.ARRAY_OPTIONAL<ELEMENT>) -> Bool {
			return lhs.rep == rhs.rep &&
				lhs.bound1 == rhs.bound1 &&
				lhs.bound2 == rhs.bound2
		}
		
		// Hashable \SDAIGenericType\SDAIUnderlyingType\SDAIAggregationType\SDAI__ARRAY_OPTIONAL__type
		public func hash(into hasher: inout Hasher) {
			hasher.combine(rep)
			hasher.combine(bound1)
			hasher.combine(bound2)
		}

		// SDAIGenericType \SDAIUnderlyingType\SDAIAggregationType\SDAI__ARRAY_OPTIONAL__type
		public var typeMembers: Set<SDAI.STRING> {
			return [SDAI.STRING(Self.typeName)]
		}
		public var value: _ArrayValue<ELEMENT> {
			return _ArrayValue(from: self)
		}
		
		// SDAIUnderlyingType \SDAIAggregationType\SDAI__ARRAY_OPTIONAL__type
		public static var typeName: String { return "ARRAY" }
		public var asSwiftType: SwiftType { return rep }
		public var asFundamentalType: FundamentalType { return self }
		
		public init(_ fundamental: FundamentalType) {
			rep = fundamental.rep
			bound1 = fundamental.bound1
			bound2 = fundamental.bound2
		}
		
		// Sequence \SDAIAggregationType\SDAI__ARRAY_OPTIONAL__type
		public func makeIterator() -> SwiftType.Iterator { return rep.makeIterator() }

		// SDAIAggregationType \SDAI__ARRAY_OPTIONAL__type
		public var hiBound: Int? { return bound2 }
		public var hiIndex: Int { return bound2 }
		public var loBound: Int { return bound1 }
		public var loIndex: Int { return bound1 }
		public var size: Int { return bound2 - bound1 + 1 }
		public var _observer: EntityReferenceObserver?
		
		public subscript<I: SDAI__INTEGER__type>(index: I?) -> ELEMENT? {
			guard let index = index?.asSwiftType, index >= loIndex, index <= hiIndex else { return nil }
			return rep[index - loIndex]
		}
		
		public func QUERY(logical_expression: (ELEMENT) -> LOGICAL ) -> ARRAY_OPTIONAL<ELEMENT> {
			let filtered = rep.map { (elem) -> ELEMENT? in
				guard let elem = elem else { return nil }
				if logical_expression(elem).isTRUE { return elem }
				else { return nil }
			}
			return ARRAY_OPTIONAL(from: filtered, loBound: self.loIndex ,hiBound: self.hiIndex)
		}
		
		// InitializableByArray \SDAI__ARRAY_OPTIONAL__type
		public init(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<ELEMENT>]) {
			self.init(bound1:bound1, bound2:bound2, elements){ $0 }
		} 
		
		public init<T: SDAI__ARRAY__type>(_ arraytype: T) 
		where T.ELEMENT == ELEMENT, T.ELEMENT == T.Element
		{
			self.init(bound1:arraytype.loIndex, bound2:arraytype.hiIndex, [arraytype]) { $0 }
		}
				
		// SDAI__ARRAY_OPTIONAL__type
		public init(from swiftValue: SwiftType, loBound: Int, hiBound: Int) {
			rep = swiftValue
			bound1 = loBound
			bound2 = hiBound
		} 
		
		// InitializableByOptionalArray
		public init(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<ELEMENT?>]) {
			self.init(bound1:bound1, bound2:bound2, elements){ $0 }
		} 

		public init<T: SDAI__ARRAY_OPTIONAL__type>(_ arraytype: T) 
		where T.ELEMENT == ELEMENT
		{
			self.init(bound1:arraytype.loIndex, bound2:arraytype.hiIndex, [arraytype]) { $0 as? ELEMENT }
		}
		
		// ARRAY_OPTIONAL specific
		private init<S:Sequence>(bound1: Int, bound2: Int, _ elements: [S], conv: (S.Element) -> ELEMENT? )
		{
			self.bound1 = bound1
			self.bound2 = bound2
			self.rep = []
			rep.reserveCapacity(bound2 - bound1 + 1)
			for aie in elements {
				for elem in aie {
					rep.append(conv(elem))
				}
			}
			assert(rep.count == self.size)
		}
		
	}
}

extension SDAI.ARRAY_OPTIONAL: InitializableByOptionalSubtypeArray, InitializableBySubtypeArray
where ELEMENT: SDAIUnderlyingType
{
	// InitializableByOptionalSubtypeArray
	 public init<E: SDAIUnderlyingType>(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<E?>]) 
	 where E.FundamentalType == ELEMENT.FundamentalType
	 {
		 self.init(bound1:bound1, bound2:bound2, elements){ ELEMENT($0?.asFundamentalType) }
	 }		
	 
	 public init<T: SDAI__ARRAY_OPTIONAL__type>(_ subtype: T) 
	 where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType
	 {
		 self.init(bound1:subtype.loIndex, bound2:subtype.hiIndex, [subtype]) { ELEMENT($0 as? T.ELEMENT) }
	 }
	
	// InitializableBySubtypeArray
	public init<E: SDAIUnderlyingType>(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E.FundamentalType == ELEMENT.FundamentalType
	{
		self.init(bound1:bound1, bound2:bound2, elements){ ELEMENT($0.asFundamentalType) }
	}		
	
	public init<T: SDAI__ARRAY__type>(_ subtype: T) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element
	{
		self.init(bound1:subtype.loIndex, bound2:subtype.hiIndex, [subtype]) { ELEMENT($0) }
	}
	
}

extension SDAI.ARRAY_OPTIONAL: InitializableByOptionalSwiftArrayLiteral, InitializableBySwiftArrayLiteral 
where ELEMENT: SDAISimpleType
{
	public init<E>(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<E?>]) 
	where E == ELEMENT.SwiftType
	{
		self.init(bound1:bound1, bound2:bound2, elements){ ELEMENT($0) }
	}
	
	public init<E>(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E == ELEMENT.SwiftType
	{
		self.init(bound1:bound1, bound2:bound2, elements){ ELEMENT($0) }
	}
}


//MARK: -
public protocol SDAI__ARRAY_OPTIONAL__subtype: SDAI__ARRAY_OPTIONAL__type, SDAIDefinedType, InitializableByOptionalSubtypeArray
where Supertype: SDAI__ARRAY_OPTIONAL__type & InitializableByOptionalSubtypeArray,
			Supertype.ELEMENT == ELEMENT,
			Supertype.FundamentalType == SDAI.ARRAY_OPTIONAL<ELEMENT>,
			Supertype.SwiftType == SDAI.ARRAY_OPTIONAL<ELEMENT>.SwiftType
{}
public extension SDAI__ARRAY_OPTIONAL__subtype
{
	// Sequence \SDAIAggregationType\SDAI__ARRAY_OPTIONAL__type\SDAI__ARRAY_OPTIONAL__subtype
	func makeIterator() -> Supertype.Iterator { return rep.makeIterator() }

	// SDAIAggregationType \SDAI__ARRAY_OPTIONAL__type\SDAI__ARRAY_OPTIONAL__subtype
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

	// InitializableByArray \SDAI__ARRAY_OPTIONAL__type\SDAI__ARRAY_OPTIONAL__subtype
	init(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<ELEMENT>]) {
		self.init( Supertype(bound1: bound1, bound2: bound2, elements) )
	}

	init<T: SDAI__ARRAY__type>(_ arraytype: T) 
	where T.ELEMENT == ELEMENT, T.ELEMENT == T.Element 
	{
		self.init( Supertype(arraytype) )
	}

	// SDAI__ARRAY_OPTIONAL__type \SDAI__ARRAY_OPTIONAL__subtype
	init(from swiftValue: SwiftType, loBound: Int, hiBound: Int) {
		self.init( Supertype(from: swiftValue, loBound: loBound, hiBound: hiBound) )
	} 

	// InitializableByOptionalArray \SDAI__ARRAY_OPTIONAL__subtype
	init(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<ELEMENT?>]) {
		self.init( Supertype(bound1: bound1, bound2: bound2, elements) )
	}

	init<T: SDAI__ARRAY_OPTIONAL__type>(_ arraytype: T) 
	where T.ELEMENT == ELEMENT
	{
		self.init( Supertype(arraytype) )
	}
}

public extension SDAI__ARRAY_OPTIONAL__subtype
where Supertype: InitializableBySubtypeArray
{
	// InitializableBySubtypeArray
	init<E: SDAIUnderlyingType>(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E.FundamentalType == ELEMENT.FundamentalType
	{
		self.init( Supertype(bound1: bound1, bound2: bound2, elements) )
	}

	init<T:SDAI__ARRAY__type>(_ subtype: T) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType
	{
		self.init( Supertype(subtype).asFundamentalType )
	}
}

public extension SDAI__ARRAY_OPTIONAL__subtype
where Supertype: InitializableByOptionalSubtypeArray
{
	// InitializableByOptionalSubtypeArray
	init<E: SDAIUnderlyingType>(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<E?>]) 
	where E.FundamentalType == ELEMENT.FundamentalType
	{
		self.init( Supertype(bound1: bound1, bound2: bound2, elements) )
	}

	init<T:SDAI__ARRAY_OPTIONAL__type>(_ subtype: T) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType
	{
		self.init( Supertype(subtype).asFundamentalType )
	}	
}

public extension SDAI__ARRAY_OPTIONAL__subtype
where Supertype: InitializableByOptionalSwiftArrayLiteral
{
	init<E>(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<E?>]) 
	where E == ELEMENT.SwiftType
	{
		self.init( Supertype(bound1:bound1, bound2:bound2, elements) )
	}
}

public extension SDAI__ARRAY_OPTIONAL__subtype
where Supertype: InitializableBySwiftArrayLiteral
{
	init<E>(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E == ELEMENT.SwiftType
	{
		self.init( Supertype(bound1:bound1, bound2:bound2, elements) )
	}
}


//MARK: - ARRAY type
public protocol SDAI__ARRAY__type: SDAI__ARRAY_OPTIONAL__type
{}

extension SDAI {
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
		public static var typeName: String { return "ARRAY" }
		public var asSwiftType: SwiftType { return rep }
		public var asFundamentalType: FundamentalType { return self }
		public var typeMembers: Set<SDAI.STRING> {
			return [SDAI.STRING(Self.typeName)]
		}
		public var value: _ArrayValue<ELEMENT> {
			return _ArrayValue(from: self)
		}
		public init(_ fundamental: FundamentalType) {
			rep = fundamental.rep
			bound1 = fundamental.bound1
			bound2 = fundamental.bound2
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
		
		public subscript<I: SDAI__INTEGER__type>(index: I?) -> ELEMENT? {
			guard let index = index?.asSwiftType, index >= loIndex, index <= hiIndex else { return nil }
			return rep[index - loIndex]
		}
		
		public func QUERY(logical_expression: (ELEMENT) -> LOGICAL ) -> ARRAY_OPTIONAL<ELEMENT> {
			let filtered = rep.map { (elem) -> ELEMENT? in
				if logical_expression(elem).isTRUE { return elem }
				else { return nil }
			}
			return ARRAY_OPTIONAL(from: filtered, loBound: self.loIndex ,hiBound: self.hiIndex)
		}

		// InitializableByArray \SDAI__ARRAY_OPTIONAL__type\SDAI__ARRAY__type
		public init(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<ELEMENT>]) {
			self.init(bound1:bound1, bound2:bound2, elements){ $0 }
		} 

		public init<T: SDAI__ARRAY__type>(_ arraytype: T) 
	 	where T.ELEMENT == ELEMENT, T.ELEMENT == T.Element
		{
			self.init(bound1:arraytype.loIndex, bound2:arraytype.hiIndex, [arraytype]) { $0 }
		}	
		
		// SDAI__ARRAY_OPTIONAL__type \SDAI__ARRAY__type
		public init(from swiftValue: SwiftType, loBound: Int, hiBound: Int) {
			rep = swiftValue
			bound1 = loBound
			bound2 = hiBound
		} 

		// ARRAY specific
		private init<S:Sequence>(bound1: Int, bound2: Int, _ elements: [S], conv: (S.Element) -> ELEMENT )
		{
			self.bound1 = bound1
			self.bound2 = bound2
			self.rep = []
			rep.reserveCapacity(bound2 - bound1 + 1)
			for aie in elements {
				for elem in aie {
					rep.append(conv(elem))
				}
			}
			assert(rep.count == self.size)
		}
		
		// SDAIValue
		public func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool 
		{
			if let rhs = rhs as? Self { return self == rhs }
			return false
		}
	}
}

extension SDAI.ARRAY: InitializableBySubtypeArray 
where ELEMENT: SDAIUnderlyingType
{
	// InitializableBySubtypeArray \SDAI__ARRAY_OPTIONAL__type\SDAI__ARRAY__type
	public init<E: SDAIUnderlyingType>(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E.FundamentalType == ELEMENT.FundamentalType
	{
		self.init(bound1:bound1, bound2:bound2, elements){ ELEMENT($0.asFundamentalType) }
	}		
	
	public init<T: SDAI__ARRAY__type>(_ subtype: T) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element
	{
		self.init(bound1:subtype.loIndex, bound2:subtype.hiIndex, [subtype]) { ELEMENT($0) }
	}
}

extension SDAI.ARRAY: InitializableBySwiftArrayLiteral 
where ELEMENT: SDAISimpleType
{
	public init<E>(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E == ELEMENT.SwiftType
	{
		self.init(bound1:bound1, bound2:bound2, elements){ ELEMENT($0) }
	}
}


//MARK: -
public protocol SDAI__ARRAY__subtype: SDAI__ARRAY__type, SDAIDefinedType
where Supertype: SDAI__ARRAY__type,
			Supertype.ELEMENT == ELEMENT,
			Supertype.FundamentalType == SDAI.ARRAY<ELEMENT>,
			Supertype.SwiftType == SDAI.ARRAY<ELEMENT>.SwiftType
{}
public extension SDAI__ARRAY__subtype
{
	// SDAI__ARRAY__type \SDAI__ARRAY__subtype
	init?<T:SDAI__ARRAY__type>(_ subtype: T?) {
		guard let subtype = subtype else { return nil}
		self.init(subtype)
	}
}
public extension SDAI__ARRAY__subtype
{
	// Sequence \SDAIAggregationType\SDAI__ARRAY__type\SDAI__ARRAY__subtype
	func makeIterator() -> Supertype.Iterator { return rep.makeIterator() }

	// SDAIAggregationType \SDAI__ARRAY__type\SDAI__ARRAY__subtype
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

	// InitializableByArray \SDAI__ARRAY_OPTIONAL__type\SDAI__ARRAY__type\SDAI__ARRAY__subtype
	init(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<ELEMENT>]) {
		self.init( Supertype(bound1: bound1, bound2: bound2, elements) )
	}

	init<T: SDAI__ARRAY__type>(_ arraytype: T) 
	where T.ELEMENT == ELEMENT, T.ELEMENT == T.Element 
	{
		self.init( Supertype(arraytype) )
	}

	// SDAI__ARRAY_OPTIONAL__type \SDAI__ARRAY__type\SDAI__ARRAY__subtype
	init(from swiftValue: SwiftType, loBound: Int, hiBound: Int) {
		self.init( Supertype(from: swiftValue, loBound: loBound, hiBound: hiBound) )
	} 
}

public extension SDAI__ARRAY__subtype
where Supertype: InitializableBySubtypeArray
{
	// InitializableBySubtypeArray
	init<E: SDAIUnderlyingType>(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E.FundamentalType == ELEMENT.FundamentalType
	{
		self.init( Supertype(bound1: bound1, bound2: bound2, elements) )
	}

	init<T:SDAI__ARRAY__type>(_ subtype: T) 
	where T.ELEMENT: SDAIUnderlyingType, T.ELEMENT.FundamentalType == ELEMENT.FundamentalType, T.ELEMENT == T.Element
	{
		self.init( Supertype(subtype).asFundamentalType )
	}
}

public extension SDAI__ARRAY__subtype
where Supertype: InitializableBySwiftArrayLiteral
{
	init<E>(bound1: Int, bound2: Int, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E == ELEMENT.SwiftType
	{
		self.init( Supertype(bound1:bound1, bound2:bound2, elements) )
	}
}
