//
//  SdaiList.swift
//  
//
//  Created by Yoshida on 2020/10/04.
//

import Foundation





//MARK: - list type
public protocol SDAIListType: SDAIAggregationType, SDAIUnderlyingType, SDAISwiftTypeRepresented,
															InitializableByEmptyListLiteral, InitializableBySwifttypeAsList, InitializableBySelecttypeAsList
where ELEMENT: SDAIGenericType
{}


//MARK: - LIST type
public protocol SDAI__LIST__type: SDAIListType
where Element == ELEMENT,
			FundamentalType == SDAI.LIST<ELEMENT>,
			Value == FundamentalType.Value,
			SwiftType == FundamentalType.SwiftType
{}


extension SDAI {
	public typealias LIST_UNIQUE<ELEMENT> = LIST<ELEMENT> 
	where ELEMENT: SDAIGenericType

	
	public struct LIST<ELEMENT:SDAIGenericType>: SDAI__LIST__type
	{
		public typealias SwiftType = Array<ELEMENT>
		public typealias FundamentalType = Self
		
		fileprivate var rep: SwiftType
		private var bound1: Int
		private var bound2: Int?

		// Equatable \Hashable\SDAIGenericType
		public static func == (lhs: SDAI.LIST<ELEMENT>, rhs: SDAI.LIST<ELEMENT>) -> Bool {
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
		public var value: _ListValue<ELEMENT> {
			return _ListValue(from: self)
		}

		// SDAIUnderlyingType
		public static var typeName: String { return "LIST" }
		public var asSwiftType: SwiftType { return rep }
		public var asFundamentalType: FundamentalType { return self }
		public init(fundamental: FundamentalType) {
			self.init(from: fundamental.asSwiftType, bound1: fundamental.loBound, bound2: fundamental.hiBound)
		}
		
		// Sequence \SDAIAggregationType
		public func makeIterator() -> SwiftType.Iterator { return rep.makeIterator() }

		// SDAIAggregationType
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
		
		public func CONTAINS(elem: ELEMENT?) -> SDAI.LOGICAL {
			guard let elem = elem else { return UNKNOWN }
			return LOGICAL(rep.contains(elem))
		}

		public func QUERY(logical_expression: (ELEMENT) -> LOGICAL ) -> LIST<ELEMENT> {
			return LIST(from: rep.filter{ logical_expression($0).isTRUE }, bound1: self.loBound, bound2: self.hiBound)
		}
		
		
		// LIST specific
		private init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, S:Sequence>(bound1: I1, bound2: I2?, _ elements: [S], conv: (S.Element) -> ELEMENT? )
		{
			var swiftValue = SwiftType()
			if let hi = bound2 {
				swiftValue.reserveCapacity(hi.asSwiftInt)
			}
			for aie in elements {
				for elem in aie {
					guard let converted = conv(elem) else { return nil }
					swiftValue.append( converted )
				}
			}
			self.init(from: swiftValue, bound1: bound1, bound2: bound2)
		}
		
		
		// InitializableBySelecttype
		public init?<S: SDAISelectType>(possiblyFrom select: S?) {
			guard let fundamental = select?.listValue(elementType: ELEMENT.self) else { return nil }
			self.init(fundamental: fundamental)
		}

		// InitializableByEmptyListLiteral
		public init<I1: SwiftIntConvertible, I2: SwiftIntConvertible>(bound1: I1, bound2: I2?, _ emptyLiteral: SDAI.EmptyAggregateLiteral = SDAI.EMPLY_AGGREGATE) {
			self.init(from: SwiftType(), bound1: bound1, bound2: bound2)
		} 

		// InitializableBySwifttypeAsList
		public init<I1: SwiftIntConvertible, I2: SwiftIntConvertible>(from swiftValue: SwiftType, bound1: I1, bound2: I2?) {
			self.bound1 = bound1.asSwiftInt
			self.bound2 = bound2?.asSwiftInt
			self.rep = swiftValue
		}
		
		// InitializableBySelecttypeAsList
		public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, S: SDAISelectType>(bound1: I1, bound2: I2?, _ select: S?) {
			guard let fundamental = Self.init(possiblyFrom: select) else { return nil }
			self.init(from: fundamental.asSwiftType, bound1:bound1, bound2:bound2)
		}

	}
}


extension SDAI.LIST: SDAIObservableAggregate
where ELEMENT: SDAIObservableAggregateElement
{}

extension SDAI.LIST: InitializableBySelecttypeListLiteral, InitializableBySelecttypeList
where ELEMENT: InitializableBySelecttype
{
	public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E: SDAISelectType>(bound1: I1, bound2: I2?, _ elements: [SDAI.AggregationInitializerElement<E>]) {
		self.init(bound1: bound1, bound2: bound2, elements){ ELEMENT(possiblyFrom: $0) }
	} 
	
	public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__LIST__type>(bound1: I1, bound2: I2?, _ listtype: T?) 
	where T.ELEMENT: SDAISelectType
	{
		guard let listtype = listtype else { return nil }
		self.init(bound1: bound1, bound2: bound2, [listtype]){ ELEMENT(possiblyFrom: $0) }
	}
}


extension SDAI.LIST: InitializableByEntityListLiteral, InitializableByEntityList
where ELEMENT: InitializableByEntity
{
	public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E: SDAI.EntityReference>(bound1: I1, bound2: I2?, _ elements: [SDAI.AggregationInitializerElement<E>]) {
		self.init(bound1: bound1, bound2: bound2, elements) { ELEMENT(possiblyFrom: $0) }
	}

	public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__LIST__type>(bound1: I1, bound2: I2?, _ listtype: T?) 
	where T.ELEMENT: SDAI.EntityReference
	{
		guard let listtype = listtype else { return nil }
		self.init(bound1: bound1, bound2: bound2, [listtype]) { ELEMENT(possiblyFrom: $0) }		
	}
}


extension SDAI.LIST: InitializableByDefinedtypeListLiteral, InitializableByDefinedtypeList
where ELEMENT: InitializableByDefinedtype
{
	public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E: SDAIUnderlyingType>(bound1: I1, bound2: I2?, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	{
		self.init(bound1:bound1, bound2:bound2, elements){ ELEMENT(possiblyFrom: $0) }
	}		

	public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__LIST__type>(bound1: I1, bound2: I2?, _ listtype: T?) 
	where T.ELEMENT: SDAIUnderlyingType
	{
		guard let listtype = listtype else { return nil }
		self.init(bound1:bound1, bound2:bound2, [listtype]) { ELEMENT(possiblyFrom: $0) }
	}
}


extension SDAI.LIST: InitializableBySwiftListLiteral 
where ELEMENT: InitializableBySwifttype
{
	public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E>(bound1: I1, bound2: I2?, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E == ELEMENT.SwiftType
	{
		self.init(bound1: bound1, bound2: bound2, elements){ ELEMENT($0) }
	}
}

