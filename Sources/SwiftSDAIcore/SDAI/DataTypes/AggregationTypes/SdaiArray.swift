//
//  SdaiArray.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation


//MARK: - array type (8.2.1)
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
		public var genericEnumValue: SDAI.GenericEnumValue? {nil}
		
		public func arrayOptionalValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY_OPTIONAL<ELEM>? {
			return ARRAY_OPTIONAL<ELEM>(bound1: self.loIndex, bound2: self.hiIndex, [self]) {
				guard let conv = ELEM.convert(fromGeneric: $0) else { return (false,nil) }
				return (true, conv.copy())
			}
		}
		public func arrayValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>? {
			if let value = self as? ARRAY<ELEM> { return value.copy() }
			return ARRAY<ELEM>(bound1: self.loIndex, bound2: self.hiIndex, [self]) { ELEM.convert(fromGeneric: $0.copy()) }
		}
		
		public func listValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.LIST<ELEM>? {nil}
		public func bagValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.BAG<ELEM>? {nil}
		public func setValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.SET<ELEM>? {nil}
		public func enumValue<ENUM:SDAIEnumerationType>(enumType:ENUM.Type) -> ENUM? {nil}

		public static func validateWhereRules(instance:Self?, prefix:SDAI.WhereLabel, round: SDAI.ValidationRound) -> [SDAI.WhereLabel:SDAI.LOGICAL] {
			return SDAI.validateAggregateElementsWhereRules(instance, prefix: prefix, round: round)
		}


		// SDAIUnderlyingType \SDAIAggregationType\SDAI__ARRAY_OPTIONAL__type\SDAI__ARRAY__type
		public static var typeName: String { return "ARRAY" }
		public var asSwiftType: SwiftType { return self.copy().rep }
		
		// SDAIGenericType
		public func copy() -> Self {
			if var observable = self as? SDAIObservableAggregateElement {
				observable.teardownObserver()
				return (observable as Any) as! Self
			}
			return self 
		}
		
		public var asFundamentalType: FundamentalType { return self.copy() }
		
		public init(fundamental: FundamentalType) {
			self.init(from: fundamental.asSwiftType, bound1: fundamental.loIndex, bound2: fundamental.hiIndex)
		}
		
		// Sequence \SDAIAggregationType
		public func makeIterator() -> SwiftType.Iterator { return self.copy().rep.makeIterator() }

		// SDAIAggregationType
		public var hiBound: Int? { return bound2 }
		public var hiIndex: Int { return bound2 }
		public var loBound: Int { return bound1 }
		public var loIndex: Int { return bound1 }
		public var size: Int { return bound2 - bound1 + 1 }
		public var observer: EntityReferenceObserver?
		
		public subscript(index: Int?) -> ELEMENT? {
			get{
				guard let index = index, index >= loIndex, index <= hiIndex else { return nil }
				return rep[index - loIndex].copy()
			}
			set{
				guard let index = index, index >= loIndex, index <= hiIndex else { return }
				guard var newValue = newValue else { return }
				
				if let observer = self.observer, 
					 var newObservable = newValue as? SDAIObservableAggregateElement,
					 var oldObservable = rep[index - loIndex] as? SDAIObservableAggregateElement
				{
					oldObservable.teardownObserver()
					newObservable.configure(with: observer)
					observer.observe(removing: oldObservable.entityReferences, adding: newObservable.entityReferences)
					newValue = newObservable as! ELEMENT
				}
				
				rep[index - loIndex] = newValue
			}
		}
		
		public var asAggregationSequence: AnySequence<ELEMENT> { return AnySequence(self.copy().rep) }

		public func CONTAINS(elem: ELEMENT?) -> SDAI.LOGICAL {
			guard let elem = elem else { return UNKNOWN }
			return LOGICAL(rep.contains(elem))
		}
		
		public func QUERY(logical_expression: (ELEMENT) -> LOGICAL ) -> ARRAY_OPTIONAL<ELEMENT> {
			let filtered = rep.map { (elem) -> ELEMENT? in
				if logical_expression(elem).isTRUE { return elem.copy() }
				else { return nil }
			}
			return ARRAY_OPTIONAL(from: filtered, bound1: self.loIndex ,bound2: self.hiIndex)
		}


	
		// ARRAY specific
		public func map<T:SDAIGenericType>(_ transform: (ELEMENT) -> T ) -> ARRAY<T> {
			let mapped = self.rep.map(transform)
			return ARRAY<T>(from:mapped, bound1:self.bound1, bound2:self.bound2)
		}

		private init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, S:Sequence>(bound1: I1, bound2: I2, _ elements: [S], conv: (S.Element) -> ELEMENT? )
		{
			var swiftValue = SwiftType()
			if let b2 = bound2.possiblyAsSwiftInt, let b1 = bound1.possiblyAsSwiftInt {
				swiftValue.reserveCapacity(b2 - b1 + 1)
			}
			for aie in elements {
				for elem in aie {
					guard let converted = conv(elem) else { return nil }
					swiftValue.append( converted )
				}
			}
			self.init(from: swiftValue, bound1: bound1, bound2: bound2)
		}
		
		// InitializableByGenerictype
		public init?<G: SDAIGenericType>(fromGeneric generic: G?) {
			guard let fundamental = generic?.arrayValue(elementType: ELEMENT.self) else { return nil }
			self.init(fundamental: fundamental)
		}

		// InitializableByGenericArray
		public init?<T: SDAI__ARRAY__type>(generic arraytype: T?) {
			guard let arraytype = arraytype else { return nil }
			self.init(bound1: arraytype.loIndex, bound2: arraytype.hiIndex, [arraytype]) { ELEMENT.convert(fromGeneric: $0) }
		}
		
		
		// InitializableBySwifttypeAsArray
		public init<I1: SwiftIntConvertible, I2: SwiftIntConvertible>(from swiftValue: SwiftType, bound1: I1, bound2: I2) {
			self.bound1 = bound1.asSwiftInt
			self.bound2 = bound2.asSwiftInt
			self.rep = swiftValue
			assert(rep.count == self.size)
		} 

		// InitializableByArrayLiteral
		public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E:SDAIGenericType>(bound1: I1, bound2: I2, _ elements: [SDAI.AggregationInitializerElement<E>]) 
		{
			self.init(bound1: bound1, bound2: bound2, elements){ ELEMENT.convert(fromGeneric: $0) }
		} 
		
		// InitializableByP21Parameter
		public static var bareTypeName: String { self.typeName }
		
		public init?(p21untypedParam: P21Decode.ExchangeStructure.UntypedParameter, from exchangeStructure: P21Decode.ExchangeStructure) {
			switch p21untypedParam {
			case .list(let listval):
				var array: SwiftType = []
				for param in listval {
					guard let elem = ELEMENT(p21param: param, from: exchangeStructure) else { exchangeStructure.add(errorContext: "while resolving \(Self.bareTypeName) element value"); return nil }
					array.append(elem)
				}
				self.init(from: array, bound1: 1, bound2: array.count)
				
			case .rhsOccurenceName(let rhsname):
				switch rhsname {
				case .constantValueName(let name):
					guard let generic = exchangeStructure.resolve(constantValueName: name) else {exchangeStructure.add(errorContext: "while resolving \(Self.bareTypeName) value"); return nil }
					guard let arrayValue = generic.arrayValue(elementType: ELEMENT.self) else { exchangeStructure.error = "constant value(\(name): \(generic)) is not compatible with \(Self.bareTypeName)[\(ELEMENT.self)]"; return nil }
					self.init(arrayValue)
				
				case .valueInstanceName(let name):
					guard let param = exchangeStructure.resolve(valueInstanceName: name) else {exchangeStructure.add(errorContext: "while resolving \(Self.bareTypeName) value from \(rhsname)"); return nil }
					self.init(p21param: param, from: exchangeStructure)
					
				default:
					exchangeStructure.error = "unexpected p21parameter(\(p21untypedParam)) while resolving \(Self.bareTypeName) value"
					return nil
				}
							
			case .noValue:
				return nil
				
			default:
				exchangeStructure.error = "unexpected p21parameter(\(p21untypedParam)) while resolving \(Self.bareTypeName) value"
				return nil
			}
		}

		public init?(p21omittedParamfrom exchangeStructure: P21Decode.ExchangeStructure) {
			guard let elem = ELEMENT(p21omittedParamfrom: exchangeStructure) else { return nil }
			self.init(from: [elem], bound1: 1, bound2: 1)
		}
		

	}
}

extension SDAI.ARRAY: SDAIObservableAggregate, SDAIObservableAggregateElement
where ELEMENT: SDAIObservableAggregateElement
{
//	// SDAIObservableAggregate
//	public var observer: SDAI.EntityReferenceObserver? {
//		get { 
//			return _observer
//		}
//		set {
//			_observer = newValue
//			if let entityObserver = newValue {
//				for elem in self.asAggregationSequence {
//					entityObserver.observe(
//						removing: [], 
//						adding: elem.entityReferences)
//				}
//			}
//		}
//	}
//	
//	public func teardown() {
//		if let entityObserver = observer {
//			for elem in self.asAggregationSequence {
//				entityObserver.observe(
//					removing: elem.entityReferences, 
//					adding: [])
//			}
//		}
//	}
	
	// SDAIObservableAggregateElement
	public var entityReferences: AnySequence<SDAI.EntityReference> { 
		AnySequence<SDAI.EntityReference>(self.lazy.flatMap { $0.entityReferences })
	}
	
	public mutating func configure(with observer: SDAI.EntityReferenceObserver) {
		self.observer = observer
		for i in 0 ..< rep.count {
			rep[i].configure(with: observer)
		}
	}

	public mutating func teardownObserver() {
		self.observer = nil
		for i in 0 ..< rep.count {
			rep[i].teardownObserver()
		}
	}

}


extension SDAI.ARRAY: InitializableBySelecttypeArray
where ELEMENT: InitializableBySelecttype
{
	public init?<T: SDAI__ARRAY__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAISelectType
	{
		guard let arraytype = arraytype else { return nil }
		self.init(bound1: arraytype.loIndex, bound2: arraytype.hiIndex, [arraytype]){ ELEMENT.convert(sibling: $0) }
	}
}



extension SDAI.ARRAY: InitializableByEntityArray
where ELEMENT: InitializableByEntity
{
	public init?<T: SDAI__ARRAY__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAI.EntityReference
	{
		guard let arraytype = arraytype else { return nil }
		self.init(bound1: arraytype.loIndex, bound2: arraytype.hiIndex, [arraytype]) { 
				return ELEMENT.convert(sibling: $0) 
		}
	}		
}



extension SDAI.ARRAY: InitializableByDefinedtypeArray 
where ELEMENT: InitializableByDefinedtype
{
	public init?<T: SDAI__ARRAY__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAIUnderlyingType
	{
		guard let arraytype = arraytype else { return nil }
		self.init(bound1: arraytype.loIndex, bound2: arraytype.hiIndex, [arraytype]) { ELEMENT.convert(sibling: $0) }
	}
}


