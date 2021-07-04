//
//  SdaiBag.swift
//  
//
//  Created by Yoshida on 2020/10/10.
//

import Foundation



//MARK: - bag type (8.2.3)
public protocol SDAIBagType: SDAIAggregationType, 
														 SDAIUnderlyingType, SDAISwiftTypeRepresented, SwiftDictRepresentable,
														 InitializableByEmptyListLiteral, InitializableBySwifttypeAsList,
														 InitializableBySelecttypeAsList, InitializableByListLiteral, InitializableByGenericSet, InitializableByGenericList, InitializableByGenericBag
{
	//entity inverse attribute support
	mutating func add(member: ELEMENT?)
	mutating func remove(member: ELEMENT?)
	
	//aggregate superset operator support
	func isSuperset<BAG: SDAIBagType>(of other: BAG) -> Bool 
	where ELEMENT.FundamentalType == BAG.ELEMENT.FundamentalType
}

public extension SDAIBagType {
	func isSuperset<B: SDAIBagType>(of other: B) -> Bool 
	where ELEMENT.FundamentalType == B.ELEMENT.FundamentalType {
		let selfDict = self.asSwiftDict
		let otherDict = other.asSwiftDict
		for (elem,otherCount) in otherDict {
			let selfCount = selfDict[elem] ?? 0
			if otherCount > selfCount { return false }
		}
		return true
	}
}

//MARK: - bag subtypes
public extension SDAIDefinedType
where Self: SDAIBagType,
			Supertype: SDAIBagType,
			ELEMENT == Supertype.ELEMENT
{
	mutating func add(member: ELEMENT?) { rep.add(member: member) }
	mutating func remove(member: ELEMENT?) { rep.remove(member: member) }
	func isSuperset<BAG: SDAIBagType>(of other: BAG) -> Bool
	where ELEMENT.FundamentalType == BAG.ELEMENT.FundamentalType { rep.isSuperset(of: other) }
}

//MARK: - BAG type
public protocol SDAI__BAG__type: SDAIBagType
where Element == ELEMENT,
			FundamentalType == SDAI.BAG<ELEMENT>,
			Value == FundamentalType.Value,
			SwiftType == FundamentalType.SwiftType
{
	// Aggregation operator support
	func intersectionWith<U: SDAI__BAG__type>(rhs: U) -> SDAI.BAG<ELEMENT>? 
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
	func intersectionWith<U: SDAI__SET__type>(rhs: U) -> SDAI.SET<ELEMENT>? 
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
	func intersectionWith<U: SDAIAggregationInitializer>(rhs: U) -> SDAI.BAG<ELEMENT>? 
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
	
	func unionWith<U: SDAIBagType>(rhs: U) -> SDAI.BAG<ELEMENT>? 
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
	func unionWith<U: SDAIListType>(rhs: U) -> SDAI.BAG<ELEMENT>? 
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
	func unionWith<U: SDAIGenericType>(rhs: U) -> SDAI.BAG<ELEMENT>? 
	where ELEMENT.FundamentalType == U.FundamentalType
	func unionWith<U: SDAI__GENERIC__type>(rhs: U) -> SDAI.BAG<ELEMENT>?
	func unionWith<U: SDAIAggregationInitializer>(rhs: U) -> SDAI.BAG<ELEMENT>? 
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType

	func differenceWith<U: SDAIBagType>(rhs: U) -> SDAI.BAG<ELEMENT>? 
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
	func differenceWith<U: SDAIGenericType>(rhs: U) -> SDAI.BAG<ELEMENT>? 
	where ELEMENT.FundamentalType == U.FundamentalType
	func differenceWith<U: SDAI__GENERIC__type>(rhs: U) -> SDAI.BAG<ELEMENT>?
	func differenceWith<U: SDAIAggregationInitializer>(rhs: U) -> SDAI.BAG<ELEMENT>? 
	where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType

}


extension SDAI {
	public struct BAG<ELEMENT:SDAIGenericType>: SDAI__BAG__type
	{
		public typealias SwiftType = Array<ELEMENT>
		public typealias FundamentalType = Self
		
		fileprivate var rep: SwiftType
		private var bound1: Int
		private var bound2: Int?

		// Equatable \Hashable\SDAIGenericType
		public static func == (lhs: SDAI.BAG<ELEMENT>, rhs: SDAI.BAG<ELEMENT>) -> Bool {
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
			if let value = self as? BAG<ELEM> { return value }
			return BAG<ELEM>(bound1: self.loBound, bound2: self.hiBound, [self]) { ELEM.convert(fromGeneric: $0) }
		}

		public func setValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.SET<ELEM>? {nil}
		public func enumValue<ENUM:SDAIEnumerationType>(enumType:ENUM.Type) -> ENUM? {nil}

		public static func validateWhereRules(instance:Self?, prefix:SDAI.WhereLabel, round: SDAI.ValidationRound) -> [SDAI.WhereLabel:SDAI.LOGICAL] {
			return SDAI.validateAggregateElementsWhereRules(instance, prefix: prefix, round: round)
		}

		
		// SDAIUnderlyingType \SDAIAggregationType\SDAI__BAG__type
		public static var typeName: String { return "BAG" }
		public var asSwiftType: SwiftType { return rep }
		
		// SDAIGenericType
		public var asFundamentalType: FundamentalType { return self }
		public init(fundamental: FundamentalType) {
			self.init(from: fundamental.asSwiftType, bound1: fundamental.loBound, bound2: fundamental.hiBound)
		}

		// Sequence \SDAIAggregationType\SDAI__BAG__type
		public func makeIterator() -> SwiftType.Iterator { return rep.makeIterator() }

		// SDAIAggregationType \SDAI__BAG__type
		public var hiBound: Int? { return bound2 }
		public var hiIndex: Int { return size }
		public var loBound: Int { return bound1 }
		public var loIndex: Int { return 1 }
		public var size: Int { return rep.count }
		public var _observer: EntityReferenceObserver?

		public subscript(index: Int?) -> ELEMENT? {
			get{
				guard let index = index, index >= loIndex, index <= hiIndex else { return nil }
				return rep[index - loIndex]
			}
		}
		
		public var asAggregationSequence: AnySequence<ELEMENT> { return AnySequence(rep) }

		public func CONTAINS(elem: ELEMENT?) -> SDAI.LOGICAL {
			guard let elem = elem else { return UNKNOWN }
			return LOGICAL(rep.contains(elem))
		}
		
		public func QUERY(logical_expression: (ELEMENT) -> LOGICAL ) -> BAG<ELEMENT> {
			return BAG(from: rep.filter{ logical_expression($0).isTRUE }, bound1:self.loBound, bound2: self.hiBound)
		}
		
		// SDAIBagType
		public mutating func add(member: ELEMENT?) {
			guard let member = member else {return}
			rep.append(member)
		}
		
		public mutating func remove(member: ELEMENT?) {
			guard let member = member else {return}
			if let index = rep.lastIndex(of: member) {
				rep.remove(at: index)
			}
		}
		
		// SwiftDictRepresentable
		public var asSwiftDict: Dictionary<ELEMENT.FundamentalType, Int> {
			return Dictionary<ELEMENT.FundamentalType,Int>( self.lazy.map{($0.asFundamentalType, 1)} ){$0 + $1}
		}

		public var asValueDict: Dictionary<ELEMENT.Value,Int> {
			return Dictionary<ELEMENT.Value,Int>( self.lazy.map{($0.value, 1)} ){$0 + $1}
		}
		
		// BAG specific
		internal init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, S:Sequence>(bound1: I1, bound2: I2?, _ elements: [S], conv: (S.Element) -> ELEMENT? )
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
			guard let fundamental = generic?.bagValue(elementType: ELEMENT.self) else { return nil }
			self.init(fundamental: fundamental)
		}

		// InitializableByGenericSet
		public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__SET__type>(bound1: I1, bound2: I2?, generic settype: T?) {
			guard let settype = settype else { return nil }
			self.init(bound1: bound1, bound2: bound2, [settype]){ELEMENT.convert(fromGeneric: $0)}
		}

		// InitializableByGenericBag
		public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__BAG__type>(bound1: I1, bound2: I2?, generic bagtype: T?) {
			guard let bagtype = bagtype else { return nil }
			self.init(bound1: bound1, bound2: bound2, [bagtype]){ELEMENT.convert(fromGeneric: $0)}
		}
		
		// InitializableByGenericList
		public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__LIST__type>(bound1: I1, bound2: I2?, generic listtype: T?) {
			guard let listtype = listtype else { return nil }
			self.init(bound1: bound1, bound2: bound2, [listtype]){ELEMENT.convert(fromGeneric: $0)}
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
		
		
		//MARK: Aggregation operator support
		// Intersection
		private func intersectionWith<S: SwiftDictRepresentable>(other: S) -> [ELEMENT.FundamentalType] 
		where S.ELEMENT.FundamentalType == ELEMENT.FundamentalType {
			var result: [ELEMENT.FundamentalType] = []
			let selfDict = self.asSwiftDict
			let otherDict = other.asSwiftDict
			for (elem,selfCount) in selfDict {
				if let otherCount = otherDict[elem] {
					result.append(contentsOf: repeatElement(elem, count: Swift.min(selfCount,otherCount)) )
				}
			}
			return result
		}
		
		public func intersectionWith<U: SDAI__BAG__type>(rhs: U) -> SDAI.BAG<ELEMENT>? 
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			let result = self.intersectionWith(other: rhs)
			return BAG(bound1: 0, bound2: _Infinity, [result]){ ELEMENT.convert(from: $0) }
		}
		public func intersectionWith<U: SDAI__SET__type>(rhs: U) -> SDAI.SET<ELEMENT>? 
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			let result = self.intersectionWith(other: rhs)
			return SET(bound1: 0, bound2: _Infinity, [result]){ ELEMENT.convert(from: $0) }
		}
		public func intersectionWith<U: SDAIAggregationInitializer>(rhs: U) -> SDAI.BAG<ELEMENT>? 
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			let result = self.intersectionWith(other: rhs )
			return BAG(bound1: 0, bound2: _Infinity, [result]){ ELEMENT.convert(from: $0) }
		}
		
		// Union
		private func unionWith<S: SDAIAggregationSequence>(other: S) -> SwiftType
		where S.ELEMENT: SDAIGenericType, S.ELEMENT.FundamentalType == ELEMENT.FundamentalType {
			var result = self.rep
			result.append(contentsOf: other.asAggregationSequence.lazy.map{ ELEMENT.convert(from: $0.asFundamentalType) } )
			return result
		}
		
		public func unionWith<U: SDAIBagType>(rhs: U) -> SDAI.BAG<ELEMENT>? 
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			let result = self.unionWith(other: rhs)
			return BAG(from: result, bound1: 0, bound2: _Infinity)
		}
		public func unionWith<U: SDAIListType>(rhs: U) -> SDAI.BAG<ELEMENT>? 
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			let result = self.unionWith(other: rhs)
			return BAG(from: result, bound1: 0, bound2: _Infinity)
		}
		public func unionWith<U: SDAIGenericType>(rhs: U) -> SDAI.BAG<ELEMENT>? 
		where ELEMENT.FundamentalType == U.FundamentalType {
			var result = self.rep
			result.append(ELEMENT.convert(from: rhs.asFundamentalType))
			return BAG(from: result, bound1: 0, bound2: _Infinity)
		}
		public func unionWith<U: SDAI__GENERIC__type>(rhs: U) -> SDAI.BAG<ELEMENT>? {
			if let rhs = rhs.listValue(elementType: ELEMENT.self) {
				return self.unionWith(rhs: rhs)
			}
			else if let rhs = rhs.setValue(elementType: ELEMENT.self) {
				return self.unionWith(rhs: rhs)
			}
			else if let rhs = rhs.bagValue(elementType: ELEMENT.self) {
				return self.unionWith(rhs: rhs)
			}
			else if let rhs = ELEMENT.convert(fromGeneric: rhs) {
				return self.unionWith(rhs: rhs)
			}
			return nil
		}
		public func unionWith<U: SDAIAggregationInitializer>(rhs: U) -> SDAI.BAG<ELEMENT>? 
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			let result = self.unionWith(other: rhs)
			return BAG(from: result, bound1: 0, bound2: _Infinity)
		}

		// Difference
		private func differenceWith<S: SwiftDictRepresentable>(other: S) -> [ELEMENT.FundamentalType] 
		where S.ELEMENT.FundamentalType == ELEMENT.FundamentalType {
			var result: [ELEMENT.FundamentalType] = []
			let selfDict = self.asSwiftDict
			let otherDict = other.asSwiftDict
			for (elem,selfCount) in selfDict {
				if let otherCount = otherDict[elem] {
					let subtructed = selfCount - otherCount
					if subtructed > 0 {
						result.append(contentsOf: repeatElement(elem, count: subtructed) )
					}
				}
				else {
					result.append(contentsOf: repeatElement(elem, count: selfCount) )
				}
			}
			return result
		}

		public func differenceWith<U: SDAIBagType>(rhs: U) -> SDAI.BAG<ELEMENT>? 
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			let result = self.differenceWith(other: rhs)
			return BAG(bound1: 0, bound2: _Infinity, [result]){ ELEMENT.convert(from: $0) }
		}
		public func differenceWith<U: SDAIGenericType>(rhs: U) -> SDAI.BAG<ELEMENT>? 
		where ELEMENT.FundamentalType == U.FundamentalType {
			var selfDict = self.asSwiftDict
			if let selfCount = selfDict[rhs.asFundamentalType] {
					selfDict[rhs.asFundamentalType] =  selfCount == 1 ? nil : selfCount - 1
			}
			return BAG(bound1: 0, bound2: _Infinity, selfDict.lazy.map(
									{ (elem,count) in repeatElement(elem, count: count)})
			) { ELEMENT.convert(from: $0) }
		}
		public func differenceWith<U: SDAI__GENERIC__type>(rhs: U) -> SDAI.BAG<ELEMENT>? {
			if let rhs = rhs.setValue(elementType: ELEMENT.self) {
				return self.differenceWith(rhs: rhs)
			}
			else if let rhs = rhs.bagValue(elementType: ELEMENT.self) {
				return self.differenceWith(rhs: rhs)
			}
			else if let rhs = ELEMENT.convert(fromGeneric: rhs) {
				return self.differenceWith(rhs: rhs)
			}
			return nil
		}
		public func differenceWith<U: SDAIAggregationInitializer>(rhs: U) -> SDAI.BAG<ELEMENT>? 
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			let result = self.differenceWith(other: rhs)
			return BAG(bound1: 0, bound2: _Infinity, [result]){ ELEMENT.convert(from: $0) }
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
					guard let bagValue = generic.bagValue(elementType: ELEMENT.self) else { exchangeStructure.error = "constant value(\(name): \(generic)) is not compatible with \(Self.bareTypeName)[\(ELEMENT.self)]"; return nil }
					self.init(bagValue)
				
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


extension SDAI.BAG: SDAIObservableAggregate, SDAIObservableAggregateElement
where ELEMENT: SDAIObservableAggregateElement
{
	public var observer: EntityReferenceObserver? {
		get { 
			return _observer
		}
		set {
			_observer = newValue
			if let entityObserver = newValue {
				for elem in self.asAggregationSequence {
					for entityRef in elem.entityReferences {
						entityObserver( nil, entityRef )
					}
				}
			}
		}
	}
	
	public func teardown() {
		if let entityObserver = observer {
			for elem in self.asAggregationSequence {
				for entityRef in elem.entityReferences {
					entityObserver( entityRef, nil )
				}
			}
		}
	}
	
	public mutating func resetObserver() {
		_observer = nil
	}	
	
	public var entityReferences: AnySequence<SDAI.EntityReference> { 
		AnySequence<SDAI.EntityReference>(self.lazy.flatMap { $0.entityReferences })
	}
	
}

extension SDAI.BAG: InitializableBySelecttypeBag, InitializableBySelecttypeSet
where ELEMENT: InitializableBySelecttype
{
	public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__BAG__type>(bound1: I1, bound2: I2?, _ bagtype: T?) 
	where T.ELEMENT: SDAISelectType
	{
		guard let bagtype = bagtype else { return nil }
		self.init(bound1: bound1, bound2: bound2, [bagtype]){ ELEMENT.convert(sibling: $0) }
	}
	
	public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__SET__type>(bound1: I1, bound2: I2?, _ settype: T?) 
	where T.ELEMENT: SDAISelectType
	{
		guard let settype = settype else { return nil }
		self.init(bound1: bound1, bound2: bound2, [settype]){ ELEMENT.convert(sibling: $0) }
	}
	
}


extension SDAI.BAG: InitializableByEntityBag, InitializableByEntitySet  
where ELEMENT: InitializableByEntity
{
	public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__BAG__type>(bound1: I1, bound2: I2?, _ bagtype: T?) 
	where T.ELEMENT: SDAI.EntityReference
	{
		guard let bagtype = bagtype else { return nil }
		self.init(bound1: bound1, bound2: bound2, [bagtype]) {
			return ELEMENT.convert(sibling: $0) 
		}		
	}

	public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__SET__type>(bound1: I1, bound2: I2?, _ settype: T?) 
	where T.ELEMENT: SDAI.EntityReference
	{
		guard let settype = settype else { return nil }
		self.init(bound1: bound1, bound2: bound2, [settype]) {
				return ELEMENT.convert(sibling: $0) 
		}		
	}
}


extension SDAI.BAG: InitializableByDefinedtypeBag, InitializableByDefinedtypeSet 
where ELEMENT: InitializableByDefinedtype
{
	public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__BAG__type>(bound1: I1, bound2: I2?, _ bagtype: T?) 
	where T.ELEMENT: SDAIUnderlyingType
	{
		guard let bagtype = bagtype else { return nil }
		self.init(bound1: bound1, bound2: bound2, [bagtype]) { ELEMENT.convert(sibling: $0) }
	}
	
	public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__SET__type>(bound1: I1, bound2: I2?, _ settype: T?) 
	where T.ELEMENT: SDAIUnderlyingType
	{
		guard let settype = settype else { return nil }
		self.init(bound1: bound1, bound2: bound2, [settype]) { ELEMENT.convert(sibling: $0) }
	}	
}




