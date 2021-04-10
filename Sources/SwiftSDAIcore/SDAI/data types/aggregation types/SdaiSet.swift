//
//  SdaiSet.swift
//  
//
//  Created by Yoshida on 2020/10/10.
//

import Foundation


//MARK: - set type (8.2.4)
public protocol SDAISetType: SDAIBagType
{}

//MARK: - SET type
public protocol SDAI__SET__type: SDAISetType
where Element == ELEMENT,
			FundamentalType == SDAI.SET<ELEMENT>,
			Value == FundamentalType.Value,
			SwiftType == FundamentalType.SwiftType
{
	// Aggregation operator support
	func intersectionWith<U: SDAIBagType>(rhs: U) -> SDAI.SET<ELEMENT>? 
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
	func intersectionWith<U: SDAIAggregationInitializer>(rhs: U) -> SDAI.SET<ELEMENT>? 
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
	
	func unionWith<U: SDAIBagType>(rhs: U) -> SDAI.SET<ELEMENT>? 
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
	func unionWith<U: SDAIListType>(rhs: U) -> SDAI.SET<ELEMENT>? 
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
	func unionWith<U: SDAIGenericType>(rhs: U) -> SDAI.SET<ELEMENT>? 
	where ELEMENT.FundamentalType == U.FundamentalType
	func unionWith<U: SDAI__GENERIC__type>(rhs: U) -> SDAI.SET<ELEMENT>?
	func unionWith<U: SDAIAggregationInitializer>(rhs: U) -> SDAI.SET<ELEMENT>? 
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType

	func differenceWith<U: SDAIBagType>(rhs: U) -> SDAI.SET<ELEMENT>? 
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
	func differenceWith<U: SDAIGenericType>(rhs: U) -> SDAI.SET<ELEMENT>? 
	where ELEMENT.FundamentalType == U.FundamentalType
	func differenceWith<U: SDAI__GENERIC__type>(rhs: U) -> SDAI.SET<ELEMENT>?
	func differenceWith<U: SDAIAggregationInitializer>(rhs: U) -> SDAI.SET<ELEMENT>? 
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
	
}

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
		public func listValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.LIST<ELEM>? {nil}

		public func bagValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.BAG<ELEM>? {
			return BAG<ELEM>(bound1: self.loBound, bound2: self.hiBound, [self]) { ELEM(fromGeneric: $0) }
		}
		public func setValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.SET<ELEM>? {
			if let value = self as? SET<ELEM> { return value }
			return SET<ELEM>(bound1: self.loBound, bound2: self.hiBound, [self]) { ELEM(fromGeneric: $0) }
		}

		public func enumValue<ENUM:SDAIEnumerationType>(enumType:ENUM.Type) -> ENUM? {nil}

		public static func validateWhereRules(instance:Self?, prefix:SDAI.WhereLabel, excludingEntity: Bool) -> [SDAI.WhereLabel:SDAI.LOGICAL] {
			return SDAI.validateAggregateElementsWhereRules(instance, prefix: prefix)
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
			get{
				guard let index = index, index >= loIndex, index <= hiIndex else { return nil }
				let setIndex = rep.index(rep.startIndex, offsetBy: index - loIndex)
				return rep[setIndex]
			}
		}
		
		public var asAggregationSequence: AnySequence<ELEMENT> { return AnySequence(rep) }

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
		
		// SwiftDictRepresentable
		public var asSwiftDict: Dictionary<ELEMENT.FundamentalType, Int> {
			return Dictionary<ELEMENT.FundamentalType, Int>(uniqueKeysWithValues: self.lazy.map{($0.asFundamentalType, 1)} )
		}

		public var asValueDict: Dictionary<ELEMENT.Value,Int> {
			return Dictionary<ELEMENT.Value,Int>( self.lazy.map{($0.value, 1)} ){$0 + $1}
		}

		
		// SET specific
		internal init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, S:Sequence>(bound1: I1, bound2: I2?, _ elements: [S], conv: (S.Element) -> ELEMENT? )
		{
			var swiftValue = SwiftType()
			if let hi = bound2?.possiblyAsSwiftInt {
				swiftValue.reserveCapacity(hi)
			}
			for aie in elements {
				for elem in aie {
					guard let converted = conv(elem) else { return nil }
					swiftValue.insert( converted )
				}
			}
			self.init(from: swiftValue, bound1: bound1, bound2: bound2)
		}
		
		// InitializableByGenerictype
		public init?<G: SDAIGenericType>(fromGeneric generic: G?) {
			guard let fundamental = generic?.setValue(elementType: ELEMENT.self) else { return nil }
			self.init(fundamental: fundamental)
		}
		
		// InitializableByGenericSet
		public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__SET__type>(bound1: I1, bound2: I2?, generic settype: T?) {
			guard let settype = settype else { return nil }
			self.init(bound1: bound1, bound2: bound2, [settype]){ELEMENT(fromGeneric: $0)}
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
		public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E:SDAIGenericType>(bound1: I1, bound2: I2?, _ elements: [SDAI.AggregationInitializerElement<E>]) {
			self.init(bound1: bound1, bound2: bound2, elements){ ELEMENT(fromGeneric: $0) }
		} 

		//MARK: Aggregation operator support
		// Intersection
		private func intersectionWith<S: SwiftDictRepresentable>(other: S) -> [ELEMENT.FundamentalType] 
		where S.ELEMENT.FundamentalType == ELEMENT.FundamentalType {
			var result: [ELEMENT.FundamentalType] = []
			let selfDict = self.asSwiftDict
			let otherDict = other.asSwiftDict
			for (elem,_) in selfDict {
				if otherDict[elem] != nil {
					result.append(elem)
				}
			}
			return result
		}

		public func intersectionWith<U: SDAIBagType>(rhs: U) -> SDAI.SET<ELEMENT>? 
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			let result = self.intersectionWith(other: rhs)
			return SET(bound1: 0, bound2: _Infinity, [result]){ ELEMENT(fundamental: $0) }
		}
		public func intersectionWith<U: SDAIAggregationInitializer>(rhs: U) -> SDAI.SET<ELEMENT>? 
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			let result = self.intersectionWith(other: rhs)
			return SET(bound1: 0, bound2: _Infinity, [result]){ ELEMENT(fundamental: $0) }
		}
		
		// Union
		private func unionWith<S: SDAIAggregationSequence>(other: S) -> SwiftType
		where S.ELEMENT: SDAIGenericType, S.ELEMENT.FundamentalType == ELEMENT.FundamentalType {
			let result = self.rep.union( other.asAggregationSequence.lazy.map{ ELEMENT(fundamental: $0.asFundamentalType) } )
			return result
		}
		
		public func unionWith<U: SDAIBagType>(rhs: U) -> SDAI.SET<ELEMENT>? 
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			let result = self.unionWith(other: rhs)
			return SET(from: result, bound1: 0, bound2: _Infinity)
		}
		public func unionWith<U: SDAIListType>(rhs: U) -> SDAI.SET<ELEMENT>? 
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			let result = self.unionWith(other: rhs)
			return SET(from: result, bound1: 0, bound2: _Infinity)
		}
		public func unionWith<U: SDAIGenericType>(rhs: U) -> SDAI.SET<ELEMENT>? 
		where ELEMENT.FundamentalType == U.FundamentalType {
			var result = self.rep
			result.insert(ELEMENT(fundamental: rhs.asFundamentalType))
			return SET(from: result, bound1: 0, bound2: _Infinity)
		}
		public func unionWith<U: SDAI__GENERIC__type>(rhs: U) -> SDAI.SET<ELEMENT>? {
			if let rhs = rhs.listValue(elementType: ELEMENT.self) {
				return self.unionWith(rhs: rhs)
			}
			else if let rhs = rhs.setValue(elementType: ELEMENT.self) {
				return self.unionWith(rhs: rhs)
			}
			else if let rhs = rhs.bagValue(elementType: ELEMENT.self) {
				return self.unionWith(rhs: rhs)
			}
			else if let rhs = ELEMENT(fromGeneric: rhs) {
				return self.unionWith(rhs: rhs)
			}
			return nil
		}
		public func unionWith<U: SDAIAggregationInitializer>(rhs: U) -> SDAI.SET<ELEMENT>? 
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			let result = self.unionWith(other: rhs)
			return SET(from: result, bound1: 0, bound2: _Infinity)
		}

		// Difference
		private func differenceWith<S: SwiftDictRepresentable>(other: S) -> [ELEMENT.FundamentalType] 
		where S.ELEMENT.FundamentalType == ELEMENT.FundamentalType {
			var result: [ELEMENT.FundamentalType] = []
			let selfDict = self.asSwiftDict
			let otherDict = other.asSwiftDict
			for (elem,_) in selfDict {
				if otherDict[elem] == nil {
					result.append(elem)
				}
			}
			return result
		}

		public func differenceWith<U: SDAIBagType>(rhs: U) -> SDAI.SET<ELEMENT>? 
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
		{
			let result = self.differenceWith(other: rhs)
			return SET(bound1: 0, bound2: _Infinity, [result]){ ELEMENT(fundamental: $0) }
		}
		public func differenceWith<U: SDAIGenericType>(rhs: U) -> SDAI.SET<ELEMENT>? 
		where ELEMENT.FundamentalType == U.FundamentalType {
			var selfDict = self.asSwiftDict
			if selfDict[rhs.asFundamentalType] != nil {
					selfDict[rhs.asFundamentalType] =  nil
			}
			return SET(bound1: 0, bound2: _Infinity, selfDict.lazy.map(
									{ (elem,_) in CollectionOfOne(elem)})
			) { ELEMENT(fundamental: $0) }
		}
		public func differenceWith<U: SDAI__GENERIC__type>(rhs: U) -> SDAI.SET<ELEMENT>? {
			if let rhs = rhs.setValue(elementType: ELEMENT.self) {
				return self.differenceWith(rhs: rhs)
			}
			else if let rhs = rhs.bagValue(elementType: ELEMENT.self) {
				return self.differenceWith(rhs: rhs)
			}
			else if let rhs = ELEMENT(fromGeneric: rhs) {
				return self.differenceWith(rhs: rhs)
			}
			return nil
		}
		public func differenceWith<U: SDAIAggregationInitializer>(rhs: U) -> SDAI.SET<ELEMENT>? 
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			let result = self.differenceWith(other: rhs)
			return SET(bound1: 0, bound2: _Infinity, [result]){ ELEMENT(fundamental: $0) }
		}

	}
}


extension SDAI.SET: SDAIObservableAggregate, SDAIObservableAggregateElement
where ELEMENT: SDAIObservableAggregateElement
{}

extension SDAI.SET: InitializableBySelecttypeSet
where ELEMENT: InitializableBySelecttype
{
	public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__SET__type>(bound1: I1, bound2: I2?, _ settype: T?) 
	where T.ELEMENT: SDAISelectType
	{
		guard let settype = settype else { return nil }
		self.init(bound1: bound1, bound2: bound2, [settype]){ ELEMENT(possiblyFrom: $0) }
	}		
}





extension SDAI.SET: InitializableByEntitySet
where ELEMENT: InitializableByEntity
{
	public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__SET__type>(bound1: I1, bound2: I2?, _ settype: T?) 
	where T.ELEMENT: SDAI.EntityReference
	{
		guard let settype = settype else { return nil }
		self.init(bound1: bound1, bound2: bound2, [settype]) { ELEMENT(possiblyFrom: $0) }		
	}
}


extension SDAI.SET: InitializableByDefinedtypeSet
where ELEMENT: InitializableByDefinedtype
{
	public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__SET__type>(bound1: I1, bound2: I2?, _ settype: T?) 
	where T.ELEMENT: SDAIUnderlyingType
	{
		guard let settype = settype else { return nil }
		self.init(bound1:bound1, bound2:bound2, [settype]) { ELEMENT(possiblyFrom: $0) }
	}
}

