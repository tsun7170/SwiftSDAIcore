//
//  SdaiSet.swift
//  
//
//  Created by Yoshida on 2020/10/10.
//

import Foundation


//MARK: - set type
public protocol SDAISetType: SDAIBagType
{}

//MARK: - SET type
public protocol SDAI__SET__type: SDAISetType
where Element == ELEMENT,
			FundamentalType == SDAI.SET<ELEMENT>,
			Value == FundamentalType.Value,
			SwiftType == FundamentalType.SwiftType
{}

extension SDAI {
	public struct SET<ELEMENT:SDAIGenericType>: SDAI__SET__type
	{
		public typealias SwiftType = Set<ELEMENT>
		public typealias FundamentalType = Self
		
		fileprivate var rep: SwiftType
		private var bound1: Int
		private var bound2: Int?
		
		// Equatable \Hashable\SDAIGenericType
		public static func == (lhs: SDAI.SET<ELEMENT>, rhs: SDAI.SET<ELEMENT>) -> Bool {
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
		public var value: _BagValue<ELEMENT> {
			return _BagValue(from: self)
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
		
		public func CONTAINS(elem: ELEMENT?) -> SDAI.LOGICAL {
			guard let elem = elem else { return UNKNOWN }
			return LOGICAL(rep.contains(elem))
		}
		
		public func QUERY(logical_expression: (ELEMENT) -> LOGICAL ) -> SET<ELEMENT> {
			return SET(from: rep.filter{ logical_expression($0).isTRUE }, bound1:self.loBound, bound2: self.hiBound)
		}
		
		// SDAIBagType
		public mutating func add(member: ELEMENT?) {
			guard let member = member else {return}
			rep.insert(member)
		}
		
		public mutating func remove(member: ELEMENT?) {
			guard let member = member else {return}
			rep.remove(member)
		}
		
		// SET specific
		private init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, S:Sequence>(bound1: I1, bound2: I2?, _ elements: [S], conv: (S.Element) -> ELEMENT? )
		{
			var swiftValue = SwiftType()
			if let hi = bound2 {
				swiftValue.reserveCapacity(hi.asSwiftInt)
			}
			for aie in elements {
				for elem in aie {
					guard let converted = conv(elem) else { return nil }
					swiftValue.insert( converted )
				}
			}
			self.init(from: swiftValue, bound1: bound1, bound2: bound2)
		}
		
		// InitializableBySelecttype
		public init?<S: SDAISelectType>(possiblyFrom select: S?) {
			guard let fundamental = select?.setValue(elementType: ELEMENT.self) else { return nil }
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


extension SDAI.SET: SDAIObservableAggregate
where ELEMENT: SDAIObservableAggregateElement
{}

extension SDAI.SET: InitializableBySelecttypeListLiteral, InitializableBySelecttypeSet
where ELEMENT: InitializableBySelecttype
{
	public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E: SDAISelectType>(bound1: I1, bound2: I2?, _ elements: [SDAI.AggregationInitializerElement<E>]) {
		self.init(bound1: bound1, bound2: bound2, elements){ ELEMENT(possiblyFrom: $0) }
	} 
	
	public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__SET__type>(bound1: I1, bound2: I2?, _ settype: T?) 
	where T.ELEMENT: SDAISelectType
	{
		guard let settype = settype else { return nil }
		self.init(bound1: bound1, bound2: bound2, [settype]){ ELEMENT(possiblyFrom: $0) }
	}		
}





extension SDAI.SET: InitializableByEntityListLiteral, InitializableByEntitySet
where ELEMENT: InitializableByEntity
{
	public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E: SDAI.EntityReference>(bound1: I1, bound2: I2?, _ elements: [SDAI.AggregationInitializerElement<E>]) {
		self.init(bound1: bound1, bound2: bound2, elements) { ELEMENT(possiblyFrom: $0) }
	}

	public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__SET__type>(bound1: I1, bound2: I2?, _ settype: T?) 
	where T.ELEMENT: SDAI.EntityReference
	{
		guard let settype = settype else { return nil }
		self.init(bound1: bound1, bound2: bound2, [settype]) { ELEMENT(possiblyFrom: $0) }		
	}
}


extension SDAI.SET: InitializableByDefinedtypeListLiteral, InitializableByDefinedtypeSet
where ELEMENT: InitializableByDefinedtype
{
	public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E:SDAIUnderlyingType>(bound1: I1, bound2: I2?, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	{
		self.init(bound1: bound1, bound2: bound2, elements){ ELEMENT(possiblyFrom: $0) }
	}		
	
	public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__SET__type>(bound1: I1, bound2: I2?, _ settype: T?) 
	where T.ELEMENT: SDAIUnderlyingType
	{
		guard let settype = settype else { return nil }
		self.init(bound1:bound1, bound2:bound2, [settype]) { ELEMENT(possiblyFrom: $0) }
	}
}



extension SDAI.SET: InitializableBySwiftListLiteral 
where ELEMENT: InitializableBySwifttype
{
	public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E>(bound1: I1, bound2: I2?, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E == ELEMENT.SwiftType
	{
		self.init(bound1: bound1, bound2: bound2, elements){ ELEMENT($0) }
	}
}

