//
//  SdaiArray.swift
//  
//
//  Created by Yoshida on 2020/09/22.
//

import Foundation



//MARK: - array optional type
public protocol SDAIArrayOptionalType: SDAIAggregationType, SDAIUnderlyingType, SDAISwiftTypeRepresented,
																			 InitializableBySwifttypeAsArray
where ELEMENT: SDAIGenericType
{}


//MARK: - ARRAY_OPTIONAL type
public protocol SDAI__ARRAY_OPTIONAL__type: SDAIArrayOptionalType, InitializableByEmptyArrayLiteral
where Element == ELEMENT?,
			FundamentalType == SDAI.ARRAY_OPTIONAL<ELEMENT>,
			Value == FundamentalType.Value,
			SwiftType == FundamentalType.SwiftType
{}



extension SDAI {
	public typealias ARRAY_OPTIONAL_UNIQUE<ELEMENT> = ARRAY_OPTIONAL<ELEMENT> 
	where ELEMENT: SDAIGenericType
	
	
	public struct ARRAY_OPTIONAL<ELEMENT:SDAIGenericType>: SDAI__ARRAY_OPTIONAL__type
	{
		public typealias SwiftType = Array<ELEMENT?>
		public typealias FundamentalType = Self
		
		fileprivate var rep: SwiftType
		private var bound1: Int
		private var bound2: Int
		
		// Equatable \Hashable\SDAIGenericType
		public static func == (lhs: SDAI.ARRAY_OPTIONAL<ELEMENT>, rhs: SDAI.ARRAY_OPTIONAL<ELEMENT>) -> Bool {
			return lhs.rep == rhs.rep &&
				lhs.bound1 == rhs.bound1 &&
				lhs.bound2 == rhs.bound2
		}
		
		// Hashable \SDAIGenericType
		public func hash(into hasher: inout Hasher) {
			hasher.combine(rep)
			hasher.combine(bound1)
			hasher.combine(bound2)
		}

		// SDAIGenericType
		public var typeMembers: Set<SDAI.STRING> {
			return [SDAI.STRING(Self.typeName)]
		}
		public var value: _ArrayValue<ELEMENT> {
			return _ArrayValue(from: self)
		}
		
		// SDAIUnderlyingType
		public static var typeName: String { return "ARRAY" }
		public var asSwiftType: SwiftType { return rep }
		public var asFundamentalType: FundamentalType { return self }
		
		public init(fundamental: FundamentalType) {
			self.init(from: fundamental.asSwiftType, bound1: fundamental.loIndex, bound2: fundamental.hiIndex)
		}
		
		// Sequence \SDAIAggregationType
		public func makeIterator() -> SwiftType.Iterator { return rep.makeIterator() }

		// SDAIAggregationType
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
		
		public func CONTAINS(elem: ELEMENT?) -> SDAI.LOGICAL {
			guard let elem = elem else { return UNKNOWN }
			return LOGICAL(rep.contains(elem))
		}
		
		public func QUERY(logical_expression: (ELEMENT) -> LOGICAL ) -> ARRAY_OPTIONAL<ELEMENT> {
			let filtered = rep.map { (elem) -> ELEMENT? in
				guard let elem = elem else { return nil }
				if logical_expression(elem).isTRUE { return elem }
				else { return nil }
			}
			return ARRAY_OPTIONAL(from: filtered, bound1: self.loIndex ,bound2: self.hiIndex)
		}
				
		// ARRAY_OPTIONAL specific
		private init<I1: SwiftIntConvertible, I2: SwiftIntConvertible, S:Sequence>(bound1: I1, bound2: I2, _ elements: [S], conv: (S.Element) -> ELEMENT? )
		{
			var swiftValue = SwiftType()
			swiftValue.reserveCapacity(bound2.asSwiftInt - bound1.asSwiftInt + 1)
			for aie in elements {
				for elem in aie {
					swiftValue.append(conv(elem))
				}
			}
			self.init(from: swiftValue, bound1: bound1, bound2: bound2)
		}
		
		// InitializableBySelecttype
		public init?<S: SDAISelectType>(possiblyFrom select: S?) {
			guard let fundamental = select?.arrayOptionalValue(elementType: ELEMENT.self) else { return nil }
			self.init(fundamental: fundamental)
		}

		// InitializableByEmptyArrayLiteral
		public init<I1: SwiftIntConvertible, I2: SwiftIntConvertible>(bound1: I1, bound2: I2, _ emptyLiteral: SDAI.EmptyAggregateLiteral = SDAI.EMPLY_AGGREGATE) {
			self.init(from: SwiftType(repeating: nil, count: bound2.asSwiftInt - bound1.asSwiftInt + 1), bound1: bound1, bound2: bound2)
		} 
		
		// InitializableBySwifttypeAsArray
		public init<I1: SwiftIntConvertible, I2: SwiftIntConvertible>(from swiftValue: SwiftType, bound1: I1, bound2: I2) {
			self.bound1 = bound1.asSwiftInt
			self.bound2 = bound2.asSwiftInt
			self.rep = swiftValue
			assert(rep.count == self.size)
		} 
		
	}
}


extension SDAI.ARRAY_OPTIONAL: SDAIObservableAggregate
where ELEMENT: SDAIObservableAggregateElement
{}


extension SDAI.ARRAY_OPTIONAL: InitializableBySelecttypeArrayLiteral, InitializableBySelecttypeArrayOptional, InitializableBySelecttypeArray
where ELEMENT: InitializableBySelecttype
{
	public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E: SDAISelectType>(bound1: I1, bound2: I2, _ elements: [SDAI.AggregationInitializerElement<E>]) {
		self.init(bound1: bound1, bound2: bound2, elements){ ELEMENT(possiblyFrom: $0) }
	} 
	
	public init?<T: SDAI__ARRAY_OPTIONAL__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAISelectType
	{
		guard let arraytype = arraytype else { return nil }
		self.init(bound1: arraytype.loIndex, bound2: arraytype.hiIndex, [arraytype]){ ELEMENT(possiblyFrom: $0) }
	}
	
	public init?<T: SDAI__ARRAY__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAISelectType
	{
		guard let arraytype = arraytype else { return nil }
		self.init(bound1: arraytype.loIndex, bound2: arraytype.hiIndex, [arraytype]){ ELEMENT(possiblyFrom: $0) }
	}
}



extension SDAI.ARRAY_OPTIONAL: InitializableByEntityArrayLiteral, InitializableByEntityArrayOptional, InitializableByEntityArray
where ELEMENT: InitializableByEntity
{
	public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible>(bound1: I1, bound2: I2, _ elements: [SDAI.AggregationInitializerElement<SDAI.EntityReference>]) {
		self.init(bound1: bound1, bound2: bound2, elements){ ELEMENT(possiblyFrom: $0) }
	} 

	public init?<T: SDAI__ARRAY_OPTIONAL__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAI.EntityReference
	{
		guard let arraytype = arraytype else { return nil }
		self.init(bound1: arraytype.loIndex, bound2: arraytype.hiIndex, [arraytype]) { ELEMENT(possiblyFrom: $0) }
	}
	
	public init?<T: SDAI__ARRAY__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAI.EntityReference
	{
		guard let arraytype = arraytype else { return nil }
		self.init(bound1: arraytype.loIndex, bound2: arraytype.hiIndex, [arraytype]) { ELEMENT(possiblyFrom: $0) }
	}			
}



extension SDAI.ARRAY_OPTIONAL: InitializableByDefinedtypeArrayLiteral, InitializableByDefinedtypeArrayOptional, InitializableByDefinedtypeArray
where ELEMENT: InitializableByDefinedtype
{
	 public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E: SDAIUnderlyingType>(bound1: I1, bound2: I2, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	 {
		self.init(bound1: bound1, bound2: bound2, elements){ ELEMENT(possiblyFrom: $0) }
	 }		
	 
	 public init?<T: SDAI__ARRAY_OPTIONAL__type>(_ arraytype: T?) 
	 where T.ELEMENT: SDAIUnderlyingType
	 {
		guard let arraytype = arraytype else { return nil }
		 self.init(bound1: arraytype.loIndex, bound2: arraytype.hiIndex, [arraytype]) { ELEMENT(possiblyFrom: $0) }
	 }
	
	public init?<T: SDAI__ARRAY__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAIUnderlyingType
	{
		guard let arraytype = arraytype else { return nil }
		self.init(bound1:arraytype.loIndex, bound2:arraytype.hiIndex, [arraytype]) { ELEMENT(possiblyFrom: $0) }
	}
}

extension SDAI.ARRAY_OPTIONAL: InitializableByOptionalSwiftArrayLiteral
where ELEMENT: InitializableBySwifttype
{
	public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E>(bound1: I1, bound2: I2, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E == ELEMENT.SwiftType
	{
		self.init(bound1: bound1, bound2: bound2, elements){ ELEMENT($0) }
	}
}


