//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation


//MARK: - array type
public protocol SDAIArrayType: SDAIArrayOptionalType
{}


//MARK: - ARRAY type
public protocol SDAI__ARRAY__type: SDAIArrayType
where Element == ELEMENT,
			FundamentalType == SDAI.ARRAY<ELEMENT>,
			Value == FundamentalType.Value,
			SwiftType == FundamentalType.SwiftType
{}

extension SDAI {
	public typealias ARRAY_UNIQUE<ELEMENT> = ARRAY<ELEMENT> 
	where ELEMENT: SDAIGenericType

	
	public struct ARRAY<ELEMENT:SDAIGenericType>: SDAI__ARRAY__type
	{
		public typealias SwiftType = Array<ELEMENT>
		public typealias FundamentalType = Self
		
		fileprivate var rep: SwiftType
		private var bound1: Int
		private var bound2: Int
		
		// Equatable \Hashable\SDAIGenericType
		public static func == (lhs: SDAI.ARRAY<ELEMENT>, rhs: SDAI.ARRAY<ELEMENT>) -> Bool {
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
		
		public var entityReference: SDAI.EntityReference? {nil}	
		public var stringValue: SDAI.STRING? {nil}
		public var binaryValue: SDAI.BINARY? {nil}
		public var logicalValue: SDAI.LOGICAL? {nil}
		public var booleanValue: SDAI.BOOLEAN? {nil}
		public var numberValue: SDAI.NUMBER? {nil}
		public var realValue: SDAI.REAL? {nil}
		public var integerValue: SDAI.INTEGER? {nil}
		public func arrayOptionalValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY_OPTIONAL<ELEM>? {nil}
		public func arrayValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>? {nil}
		public func listValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.LIST<ELEM>? {nil}
		public func bagValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.BAG<ELEM>? {nil}
		public func setValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.SET<ELEM>? {nil}
		public func enumValue<ENUM:SDAIEnumerationType>(enumType:ENUM.Type) -> ENUM? {nil}


		// SDAIUnderlyingType \SDAIAggregationType\SDAI__ARRAY_OPTIONAL__type\SDAI__ARRAY__type
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
			get{
				guard let index = index, index >= loIndex, index <= hiIndex else { return nil }
				return rep[index - loIndex]
			}
			set{
				guard let index = index, index >= loIndex, index <= hiIndex else { return }
				guard let newValue = newValue else { return }
				rep[index - loIndex] = newValue
			}
		}
		
		public func CONTAINS(elem: ELEMENT?) -> SDAI.LOGICAL {
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


	
		// ARRAY specific
		private init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, S:Sequence>(bound1: I1, bound2: I2, _ elements: [S], conv: (S.Element) -> ELEMENT? )
		{
			var swiftValue = SwiftType()
			swiftValue.reserveCapacity(bound2.asSwiftInt - bound1.asSwiftInt + 1)
			for aie in elements {
				for elem in aie {
					guard let converted = conv(elem) else { return nil }
					swiftValue.append( converted )
				}
			}
			self.init(from: swiftValue, bound1: bound1, bound2: bound2)
		}
		
//		// InitializableBySelecttype
//		public init?<S: SDAISelectType>(possiblyFrom select: S?) {
//			self.init(fromGeneric:select)
////			guard let fundamental = select?.arrayValue(elementType: ELEMENT.self) else { return nil }
////			self.init(fundamental: fundamental)
//		}
		// InitializableByGenerictype
		public init?<G: SDAIGenericType>(fromGeneric generic: G?) {
			guard let fundamental = generic?.arrayValue(elementType: ELEMENT.self) else { return nil }
			self.init(fundamental: fundamental)
		}

		
		// InitializableBySwifttypeAsArray
		public init<I1: SwiftIntConvertible, I2: SwiftIntConvertible>(from swiftValue: SwiftType, bound1: I1, bound2: I2) {
			self.bound1 = bound1.asSwiftInt
			self.bound2 = bound2.asSwiftInt
			self.rep = swiftValue
			assert(rep.count == self.size)
		} 

		// InitializableByArrayLiteral
		public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible>(bound1: I1, bound2: I2, _ elements: [SDAI.AggregationInitializerElement<ELEMENT>]) {
			self.init(bound1: bound1, bound2: bound2, elements){ $0 }
		} 
	}
}

extension SDAI.ARRAY: SDAIObservableAggregate
where ELEMENT: SDAIObservableAggregateElement
{}



extension SDAI.ARRAY: InitializableBySelecttypeArray
where ELEMENT: InitializableBySelecttype
{
//	public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E: SDAISelectType>(bound1: I1, bound2: I2, _ elements: [SDAI.AggregationInitializerElement<E>]) {
//		self.init(bound1: bound1, bound2: bound2, elements){ ELEMENT(possiblyFrom: $0) }
//	} 
	
	public init?<T: SDAI__ARRAY__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAISelectType
	{
		guard let arraytype = arraytype else { return nil }
		self.init(bound1: arraytype.loIndex, bound2: arraytype.hiIndex, [arraytype]){ ELEMENT(possiblyFrom: $0) }
	}
}



extension SDAI.ARRAY: InitializableByEntityArray
where ELEMENT: InitializableByEntity
{
//	public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E: SDAI.EntityReference>(bound1: I1, bound2: I2, _ elements: [SDAI.AggregationInitializerElement<E>]) {
//		self.init(bound1: bound1, bound2: bound2, elements){ ELEMENT(possiblyFrom: $0) }
//	} 

	public init?<T: SDAI__ARRAY__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAI.EntityReference
	{
		guard let arraytype = arraytype else { return nil }
		self.init(bound1: arraytype.loIndex, bound2: arraytype.hiIndex, [arraytype]) { ELEMENT(possiblyFrom: $0) }
	}		
}



extension SDAI.ARRAY: InitializableByDefinedtypeArray 
where ELEMENT: InitializableByDefinedtype
{
//	public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E: SDAIUnderlyingType>(bound1: I1, bound2: I2, _ elements: [SDAI.AggregationInitializerElement<E>]) 
//	{
//		self.init(bound1: bound1, bound2: bound2, elements){ ELEMENT(possiblyFrom: $0) }
//	}		
	
	public init?<T: SDAI__ARRAY__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAIUnderlyingType
	{
		guard let arraytype = arraytype else { return nil }
		self.init(bound1: arraytype.loIndex, bound2: arraytype.hiIndex, [arraytype]) { ELEMENT(possiblyFrom: $0) }
	}
}

//extension SDAI.ARRAY: InitializableByOptionalSwiftArrayLiteral 
//where ELEMENT: InitializableBySwifttype
//{
//	public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E>(bound1: I1, bound2: I2, _ elements: [SDAI.AggregationInitializerElement<E>]) 
//	where E == ELEMENT.SwiftType
//	{
//		self.init(bound1: bound1, bound2: bound2, elements){ ELEMENT($0) }
//	}
//}


