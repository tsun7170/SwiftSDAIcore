//
//  SdaiList.swift
//  
//
//  Created by Yoshida on 2020/10/04.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation





//MARK: - list type (8.2.2)
public protocol SDAIListType: SDAIAggregationType, SDAIAggregateIndexingSettable, 
															SDAIUnderlyingType, SDAISwiftTypeRepresented,
															InitializableByEmptyListLiteral, InitializableBySwifttypeAsList, InitializableBySelecttypeAsList, InitializableByListLiteral, InitializableByGenericList
{
	// Built-in procedure support
	mutating func insert(element: ELEMENT, at position: Int)
	mutating func remove(at position: Int)
}


//MARK: - LIST type
public protocol SDAI__LIST__type: SDAIListType
where Element == ELEMENT,
			FundamentalType == SDAI.LIST<ELEMENT>,
			Value == FundamentalType.Value,
			SwiftType == FundamentalType.SwiftType
{
	// Aggregation operator support
	func unionWith<U: SDAIListType>(rhs: U) -> SDAI.LIST<ELEMENT>? 
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
	func unionWith<U: SDAIGenericType>(rhs: U) -> SDAI.LIST<ELEMENT>? 
	where ELEMENT.FundamentalType == U.FundamentalType
	func unionWith<U: SDAIGenericType>(lhs: U) -> SDAI.LIST<ELEMENT>? 
	where ELEMENT.FundamentalType == U.FundamentalType
	func unionWith<U: SDAI__GENERIC__type>(rhs: U) -> SDAI.LIST<ELEMENT>?
	func unionWith<U: SDAI__GENERIC__type>(lhs: U) -> SDAI.LIST<ELEMENT>?
	func unionWith<U: SDAIAggregationInitializer>(rhs: U) -> SDAI.LIST<ELEMENT>? 
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
	func unionWith<U: SDAIAggregationInitializer>(lhs: U) -> SDAI.LIST<ELEMENT>? 
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
	
}


extension SDAI {
	
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
		
		public var entityReference: SDAI.EntityReference? {nil}	
		public var stringValue: SDAI.STRING? {nil}
		public var binaryValue: SDAI.BINARY? {nil}
		public var logicalValue: SDAI.LOGICAL? {nil}
		public var booleanValue: SDAI.BOOLEAN? {nil}
		public var numberValue: SDAI.NUMBER? {nil}
		public var realValue: SDAI.REAL? {nil}
		public var integerValue: SDAI.INTEGER? {nil}
		public var genericEnumValue: SDAI.GenericEnumValue? {nil}

		public func arrayOptionalValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY_OPTIONAL<ELEM>? {nil}
		public func arrayValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>? {nil}
		
		public func listValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.LIST<ELEM>? {
			if let value = self as? LIST<ELEM> { return value.copy() }
			return LIST<ELEM>(bound1: self.loBound, bound2: self.hiBound, [self]) { ELEM.convert(fromGeneric: $0.copy()) }
		}
		
		public func bagValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.BAG<ELEM>? {nil}
		public func setValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.SET<ELEM>? {nil}
		public func enumValue<ENUM:SDAIEnumerationType>(enumType:ENUM.Type) -> ENUM? {nil}

		public static func validateWhereRules(instance:Self?, prefix:SDAI.WhereLabel) -> [SDAI.WhereLabel:SDAI.LOGICAL] {
			return SDAI.validateAggregateElementsWhereRules(instance, prefix: prefix)
		}


		// SDAIUnderlyingType
		public static var typeName: String { return "LIST" }
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
			self.init(from: fundamental.asSwiftType, bound1: fundamental.loBound, bound2: fundamental.hiBound)
		}
		
		// Sequence \SDAIAggregationType
		public func makeIterator() -> SwiftType.Iterator { return self.copy().rep.makeIterator() }

		// SDAIAggregationType
		public var hiBound: Int? { return bound2 }
		public var hiIndex: Int { return size }
		public var loBound: Int { return bound1 }
		public var loIndex: Int { return 1 }
		public var size: Int { return rep.count }
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

		public func QUERY(logical_expression: @escaping (ELEMENT) -> LOGICAL ) -> LIST<ELEMENT> {
			return LIST(from: SwiftType(rep.lazy.filter{ logical_expression($0).isTRUE }.map{ $0.copy() }), 
									bound1: self.loBound, bound2: self.hiBound)
		}
		
		
		// LIST specific
		public func map<T:SDAIGenericType>(_ transform: (ELEMENT) -> T ) -> LIST<T> {
			let mapped = self.rep.map(transform)
			return LIST<T>(from:mapped, bound1:self.bound1, bound2:self.bound2)
		}
		
		private init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, S:Sequence>(bound1: I1, bound2: I2?, _ elements: [S], conv: (S.Element) -> ELEMENT? )
		{
			var swiftValue = SwiftType()
			if let hi = bound2?.possiblyAsSwiftInt {
				swiftValue.reserveCapacity(hi)
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
			guard let fundamental = generic?.listValue(elementType: ELEMENT.self) else { return nil }
			self.init(fundamental: fundamental)
		}

		// InitializableByGenericList
		public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__LIST__type>(bound1: I1, bound2: I2?, generic listtype: T?) 
		{
			guard let listtype = listtype else { return nil }
			self.init(bound1: bound1, bound2: bound2, [listtype]) { ELEMENT.convert(fromGeneric: $0) }
		}
		
		// InitializableByEmptyListLiteral
		public init<I1: SwiftIntConvertible, I2: SwiftIntConvertible>(bound1: I1, bound2: I2?, _ emptyLiteral: SDAI.EmptyAggregateLiteral = SDAI.EMPLY_AGGREGATE) {
			self.init(from: SwiftType(), bound1: bound1, bound2: bound2)
		} 

		// InitializableBySwifttypeAsList
		public init<I1: SwiftIntConvertible, I2: SwiftIntConvertible>(from swiftValue: SwiftType, bound1: I1, bound2: I2?) {
			self.bound1 = bound1.possiblyAsSwiftInt ?? 0
			self.bound2 = bound2?.possiblyAsSwiftInt
			self.rep = swiftValue
		}
		
		// InitializableBySelecttypeAsList
		public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, S: SDAISelectType>(bound1: I1, bound2: I2?, _ select: S?) {
			guard let fundamental = Self.init(possiblyFrom: select) else { return nil }
			self.init(from: fundamental.asSwiftType, bound1:bound1, bound2:bound2)
		}

		// InitializableByListLiteral
		public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E: SDAIGenericType>(bound1: I1, bound2: I2?, _ elements: [SDAI.AggregationInitializerElement<E>]) {
			self.init(bound1: bound1, bound2: bound2, elements){ ELEMENT.convert(fromGeneric: $0) }
		} 

		// Built-in procedure support
		public mutating func insert(element: ELEMENT, at position: Int) {
			var element = element
			assert(position >= 0)
			assert(position <= self.size)

			if let observer = self.observer, 
				 var observableElement = element as? SDAIObservableAggregateElement 
			{
				observableElement.configure(with: observer)
				element = observableElement as! ELEMENT
			}

			self.rep.insert(element, at: position)
		}
		
		public mutating func remove(at position: Int) {
			assert(position >= 1)
			assert(position <= self.size)
			
			if let observer = self.observer,
				 let observableElement = rep[position-1] as? SDAIObservableAggregateElement 
			{
				observer.observe(removing: observableElement.entityReferences, adding: [])
			}

			self.rep.remove(at: position-1)
		}

		//MARK: Aggregation operator support
		// Union
		private func append<S: SDAIAggregationSequence>(other: S) -> SwiftType
		where S.ELEMENT.FundamentalType == ELEMENT.FundamentalType {
			assert(self.observer == nil)
			var result = self.rep
			result.append(contentsOf: other.asAggregationSequence.lazy.map{ ELEMENT.convert(from: $0.asFundamentalType) } )
			return result
		}
		private func prepend<S: SDAIAggregationSequence>(other: S) -> SwiftType
		where S.ELEMENT.FundamentalType == ELEMENT.FundamentalType {
			assert(self.observer == nil)
			var result = self.rep
			result.insert(contentsOf: other.asAggregationSequence.lazy.map{ ELEMENT.convert(from: $0.asFundamentalType) }, at: 0 )
			return result
		}
		
		public func unionWith<U: SDAIListType>(rhs: U) -> SDAI.LIST<ELEMENT>? 
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			assert(self.observer == nil)
			let result = self.append(other: rhs)
			return LIST(from: result, bound1: 0, bound2: _Infinity)
		}
		public func unionWith<U: SDAIGenericType>(rhs: U) -> SDAI.LIST<ELEMENT>? 
		where ELEMENT.FundamentalType == U.FundamentalType {
			assert(self.observer == nil)
			var result = self.rep
			result.append(ELEMENT.convert(from: rhs.asFundamentalType))
			return LIST(from: result, bound1: 0, bound2: _Infinity)
		}
		public func unionWith<U: SDAIGenericType>(lhs: U) -> SDAI.LIST<ELEMENT>? 
		where ELEMENT.FundamentalType == U.FundamentalType {
			assert(self.observer == nil)
			var result = self.rep
			result.insert(ELEMENT.convert(from: lhs.asFundamentalType), at: 0 )
			return LIST(from: result, bound1: 0, bound2: _Infinity)
		}
		public func unionWith<U: SDAI__GENERIC__type>(rhs: U) -> SDAI.LIST<ELEMENT>? {
			assert(self.observer == nil)
			if let rhs = rhs.listValue(elementType: ELEMENT.self) {
				return self.unionWith(rhs: rhs)
			}
			else if let rhs = ELEMENT.convert(fromGeneric: rhs) {
				return self.unionWith(rhs: rhs)
			}
			return nil
		}
		public func unionWith<U: SDAI__GENERIC__type>(lhs: U) -> SDAI.LIST<ELEMENT>? {
			assert(self.observer == nil)
			if let lhs = lhs.listValue(elementType: ELEMENT.self) {
				let result = self.prepend(other: lhs)
				return LIST(from: result, bound1: 0, bound2: _Infinity)
			}
			else if let lhs = ELEMENT.convert(fromGeneric: lhs) {
				return self.unionWith(lhs: lhs)
			}
			return nil
		}
		public func unionWith<U: SDAIAggregationInitializer>(rhs: U) -> SDAI.LIST<ELEMENT>? 
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			assert(self.observer == nil)
			let result = self.append(other: rhs)
			return LIST(from: result, bound1: 0, bound2: _Infinity)
		}
		public func unionWith<U: SDAIAggregationInitializer>(lhs: U) -> SDAI.LIST<ELEMENT>? 
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			assert(self.observer == nil)
			let result = self.prepend(other: lhs)
			return LIST(from: result, bound1: 0, bound2: _Infinity)
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
				self.init(from: array)
				
			case .rhsOccurenceName(let rhsname):
				switch rhsname {
				case .constantValueName(let name):
					guard let generic = exchangeStructure.resolve(constantValueName: name) else {exchangeStructure.add(errorContext: "while resolving \(Self.bareTypeName) value"); return nil }
					guard let listValue = generic.listValue(elementType: ELEMENT.self) else { exchangeStructure.error = "constant value(\(name): \(generic)) is not compatible with \(Self.bareTypeName)[\(ELEMENT.self)]"; return nil }
					self.init(listValue)
				
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

		public init(p21omittedParamfrom exchangeStructure: P21Decode.ExchangeStructure) {
			self.init(from: SwiftType())
		}
		

	}
}


extension SDAI.LIST: SDAIObservableAggregate, SDAIObservableAggregateElement
where ELEMENT: SDAIObservableAggregateElement
{
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

extension SDAI.LIST: InitializableBySelecttypeList
where ELEMENT: InitializableBySelecttype
{	
	public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__LIST__type>(bound1: I1, bound2: I2?, _ listtype: T?) 
	where T.ELEMENT: SDAISelectType
	{
		guard let listtype = listtype else { return nil }
		self.init(bound1: bound1, bound2: bound2, [listtype]){ ELEMENT.convert(sibling: $0) }
	}
}


extension SDAI.LIST: InitializableByEntityList
where ELEMENT: InitializableByEntity
{
	public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__LIST__type>(bound1: I1, bound2: I2?, _ listtype: T?) 
	where T.ELEMENT: SDAI.EntityReference
	{
		guard let listtype = listtype else { return nil }
		self.init(bound1: bound1, bound2: bound2, [listtype]) { 
			return ELEMENT.convert(sibling: $0) 
		}		
	}
}


extension SDAI.LIST: InitializableByDefinedtypeList
where ELEMENT: InitializableByDefinedtype
{
	public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__LIST__type>(bound1: I1, bound2: I2?, _ listtype: T?) 
	where T.ELEMENT: SDAIUnderlyingType
	{
		guard let listtype = listtype else { return nil }
		self.init(bound1:bound1, bound2:bound2, [listtype]) {
			return ELEMENT.convert(sibling: $0) 
		}
	}
}

