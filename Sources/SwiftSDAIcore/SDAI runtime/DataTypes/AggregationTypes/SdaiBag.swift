//
//  SdaiBag.swift
//  
//
//  Created by Yoshida on 2020/10/10.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation



//MARK: - bag type (8.2.3)
extension SDAI {
  /// A protocol representing the behavior of an SDAI `BAG` aggregate type, which is an unordered collection allowing duplicate elements.
  /// 
  /// `BagType` provides requirements for mutating and querying the bag, 
  /// including adding and removing elements, and checking superset relationships. 
  /// It also adopts several protocols to support initialization from various sources and representations.
  /// 
  /// Conforming types must also fulfill the requirements of:
  /// - `SDAI.AggregationType`
  /// - `SDAI.UnderlyingType`
  /// - `SDAI.SwiftTypeRepresented`
  /// - `SDAI.SwiftDictRepresentable`
  /// - `SDAI.InitializableByEmptyListLiteral`
  /// - `SDAI.InitializableBySwifttypeAsList`
  /// - `SDAI.InitializableBySelecttypeAsList`
  /// - `SDAI.InitializableByListLiteral`
  /// - `SDAI.InitializableByGenericSet`
  /// - `SDAI.InitializableByGenericList`
  /// - `SDAI.InitializableByGenericBag`
  /// - `SDAI.InitializableByVoid`
  ///
  /// ### Requirements
  /// - `add(member:)`: Adds a new element to the bag.
  /// - `remove(member:)`: Removes a single occurrence of the element from the bag, if present.
  /// - `removeAll(member:)`: Removes all occurrences of the element from the bag, if present.
  /// - `isSuperset(of:)`: Determines if the bag is a superset of another bag (i.e., contains all elements of the other bag, with at least as many occurrences for each).
  ///
  /// The `ELEMENT` associated type represents the type of elements in the bag, and must conform to `SDAI.GenericType`. 
  public protocol BagType:
    SDAI.AggregationType, SDAI.UnderlyingType, SDAI.SwiftTypeRepresented, SDAI.SwiftDictRepresentable,
    SDAI.InitializableByEmptyListLiteral, SDAI.InitializableBySwifttypeAsList,
    SDAI.InitializableBySelecttypeAsList, SDAI.InitializableByListLiteral,
    SDAI.InitializableByGenericSet, SDAI.InitializableByGenericList, SDAI.InitializableByGenericBag, SDAI.InitializableByVoid
  {
    mutating func add(member: ELEMENT?)

    /// remove one instance of member from the collection
    /// - Parameter member: member to remove
    /// - Returns: true when operation is successful
    mutating func remove(member: ELEMENT?) -> Bool

    /// remove all instances of member from the collection
    /// - Parameter member: member to remove
    /// - Returns: true when operation is successful
    @discardableResult
    mutating func removeAll(member: ELEMENT?) -> Bool

    //aggregate superset operator support
    @discardableResult
    func isSuperset<BAG: SDAI.BagType>(of other: BAG) -> Bool
    where ELEMENT.FundamentalType == BAG.ELEMENT.FundamentalType
  }
}

extension SDAI.BagType {
	public func isSuperset<B: SDAI.BagType>(of other: B) -> Bool 
	where ELEMENT.FundamentalType == B.ELEMENT.FundamentalType {
		let selfDict = self.asSwiftDict
		let otherDict = other.asSwiftDict
		for (elem,otherCount) in otherDict {
			let selfCount = selfDict[elem] ?? 0
			if otherCount > selfCount { return false }
		}
		return true
	}
	
	public var isCacheable: Bool {
		for elem in self.asAggregationSequence {
			if !elem.isCacheable { return false }
		}
		return true
	}	

}

//MARK: - bag subtypes
public extension SDAI.DefinedType
where Self: SDAI.BagType,
			Supertype: SDAI.BagType,
			ELEMENT == Supertype.ELEMENT
{
	mutating func add(member: ELEMENT?) { rep.add(member: member) }
	@discardableResult
	mutating func remove(member: ELEMENT?) -> Bool { return rep.remove(member: member) }
	@discardableResult
	mutating func removeAll(member: ELEMENT?) -> Bool { return rep.removeAll(member: member) }
	func isSuperset<BAG: SDAI.BagType>(of other: BAG) -> Bool
	where ELEMENT.FundamentalType == BAG.ELEMENT.FundamentalType { rep.isSuperset(of: other) }
}

//MARK: - BAG type
extension SDAI {
  public protocol BAG__TypeBehavior: SDAI.BagType
  where Element == ELEMENT,
        FundamentalType == SDAI.BAG<ELEMENT>,
        Value == FundamentalType.Value,
        SwiftType == FundamentalType.SwiftType
  {
    // Aggregation operator support
    func intersectionWith<U: SDAI.BAG__TypeBehavior>(rhs: U) -> SDAI.BAG<ELEMENT>?
    where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType

    func intersectionWith<U: SDAI.SET__TypeBehavior>(rhs: U) -> SDAI.SET<ELEMENT>?
    where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType

    func intersectionWith<U: SDAI.AggregationInitializer>(rhs: U) -> SDAI.BAG<ELEMENT>?
    where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType


    func unionWith<U: SDAI.BagType>(rhs: U) -> SDAI.BAG<ELEMENT>?
    where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType

    func unionWith<U: SDAI.ListType>(rhs: U) -> SDAI.BAG<ELEMENT>?
    where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType

    func unionWith<U: SDAI.GenericType>(rhs: U) -> SDAI.BAG<ELEMENT>?
    where ELEMENT.FundamentalType == U.FundamentalType

    func unionWith<U: SDAI.GENERIC__TypeBehavior>(rhs: U) -> SDAI.BAG<ELEMENT>?

    func unionWith<U: SDAI.AggregationInitializer>(rhs: U) -> SDAI.BAG<ELEMENT>?
    where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType


    func differenceWith<U: SDAI.BagType>(rhs: U) -> SDAI.BAG<ELEMENT>?
    where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType

    func differenceWith<U: SDAI.GenericType>(rhs: U) -> SDAI.BAG<ELEMENT>?
    where ELEMENT.FundamentalType == U.FundamentalType

    func differenceWith<U: SDAI.GENERIC__TypeBehavior>(rhs: U) -> SDAI.BAG<ELEMENT>?

    func differenceWith<U: SDAI.AggregationInitializer>(rhs: U) -> SDAI.BAG<ELEMENT>?
    where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
  }
}

public extension SDAI.BAG__TypeBehavior
where ELEMENT: SDAI.InitializableByComplexEntity {
	func unionWith(rhs: SDAI.ComplexEntity) -> SDAI.BAG<ELEMENT>? {
		guard let rhs = ELEMENT(possiblyFrom: rhs) else { return nil }
		return self.unionWith(rhs: rhs)
	}
	func differenceWith(rhs: SDAI.ComplexEntity) -> SDAI.BAG<ELEMENT>? {
		guard let rhs = ELEMENT(possiblyFrom: rhs) else { return nil }
		return self.differenceWith(rhs: rhs)
	}
}
public extension SDAI.BAG__TypeBehavior 
where ELEMENT: SDAI.EntityReference {
	func unionWith<U: SDAI.SelectType>(rhs: U) -> SDAI.BAG<ELEMENT>? {
		guard let rhs = ELEMENT(possiblyFrom: rhs) else { return nil }
		return self.unionWith(rhs: rhs)
	}
	func differenceWith<U: SDAI.SelectType>(rhs: U) -> SDAI.BAG<ELEMENT>? {
		guard let rhs = ELEMENT(possiblyFrom: rhs) else { return nil }
		return self.differenceWith(rhs: rhs)
	}
}
public extension SDAI.BAG__TypeBehavior 
where ELEMENT: SDAI.PersistentReference {
	func unionWith<U: SDAI.SelectType>(rhs: U) -> SDAI.BAG<ELEMENT>? {
		guard let rhs = ELEMENT(possiblyFrom: rhs) else { return nil }
		return self.unionWith(rhs: rhs)
	}
	func differenceWith<U: SDAI.SelectType>(rhs: U) -> SDAI.BAG<ELEMENT>? {
		guard let rhs = ELEMENT(possiblyFrom: rhs) else { return nil }
		return self.differenceWith(rhs: rhs)
	}
}


//MARK: - SDAI.BAG
extension SDAI {
  /// `BAG` is a generic structure representing the SDAI `BAG` aggregate type, which is an unordered collection that allows duplicate elements.
  /// 
  /// The `BAG` type conforms to various protocols, allowing it to interoperate with other aggregate and generic types 
  /// in the SDAI framework. Its primary purpose is to model an unordered collection of elements where the same element 
  /// may appear multiple times, and the count of each element is significant.
  /// 
  /// # Generic Parameters
  /// - `ELEMENT`: The element type contained by the `BAG`. This must conform to `SDAI.GenericType`.
  /// 
  /// # Features
  /// - Allows storing multiple instances of the same element.
  /// - Provides protocol conformances for initialization from other aggregates, generic collections, and literals.
  /// - Supports standard aggregate operations such as union, intersection, and difference with other `BAG`-like and aggregate types.
  /// - Maintains lower and optional upper bounds on the number of elements, reflecting EXPRESS aggregate constraints.
  /// - Offers access to elements via subscript and supports sequence iteration.
  /// - Implements methods for adding, removing (single or all instances), and querying elements.
  /// - Provides conversion and mapping utilities to facilitate use in generic aggregate algorithms.
  /// - Integrates with STEP Part 21 (P21) parameter decoding.
  ///
  /// # Usage
  /// Use `SDAI.BAG<ElementType>` to represent unordered collections that can contain duplicate values, 
  /// typically when translating EXPRESS `BAG` types or dealing with data exchange in the SDAI/STEP domain.
	public struct BAG<ELEMENT:SDAI.GenericType>: SDAI.BAG__TypeBehavior
	{
		public typealias SwiftType = Array<ELEMENT>
		public typealias FundamentalType = Self
		
		fileprivate var rep: SwiftType
		private var bound1: Int
		private var bound2: Int?

		// Equatable \Hashable\SDAI.GenericType
		public static func == (lhs: SDAI.BAG<ELEMENT>, rhs: SDAI.BAG<ELEMENT>) -> Bool {
			return lhs.rep == rhs.rep &&
				lhs.bound1 == rhs.bound1 &&
				lhs.bound2 == rhs.bound2
		}
		
		// Hashable \SDAI.GenericType
		public func hash(into hasher: inout Hasher) {
			hasher.combine(rep)
			hasher.combine(bound1)
			hasher.combine(bound2)
		}

		// SDAI.GenericType
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

		public func arrayOptionalValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.ARRAY_OPTIONAL<ELEM>? {nil}
		public func arrayValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>? {nil}
		public func listValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.LIST<ELEM>? {nil}

		public func bagValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.BAG<ELEM>? {
			if let value = self as? BAG<ELEM> { return value.copy() }
			return BAG<ELEM>(bound1: self.loBound, bound2: self.hiBound, [self]) { ELEM.convert(fromGeneric: $0.copy()) }
		}

		public func setValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.SET<ELEM>? {nil}
		public func enumValue<ENUM:SDAI.EnumerationType>(enumType:ENUM.Type) -> ENUM? {nil}

		public static func validateWhereRules(instance:Self?, prefix:SDAIPopulationSchema.WhereLabel) -> SDAIPopulationSchema.WhereRuleValidationRecords {
			return SDAI.validateAggregateElementsWhereRules(instance, prefix: prefix)
		}

		
		// SDAI.UnderlyingType \SDAI.AggregationType\SDAI__BAG__type
		public static var typeName: String { return "BAG" }
		public var asSwiftType: SwiftType { return self.copy().rep }
		
		// SDAI.GenericType
		public func copy() -> Self {
			return self
		}
		
		public var asFundamentalType: FundamentalType { return self.copy() }

		public init(fundamental: FundamentalType) {
			self.init(from: fundamental.asSwiftType, bound1: fundamental.loBound, bound2: fundamental.hiBound)
		}

		// Sequence \SDAI.AggregationType\SDAI__BAG__type
		public func makeIterator() -> SwiftType.Iterator { return self.copy().rep.makeIterator() }

		// SDAI.AggregationType \SDAI__BAG__type
		public var hiBound: Int? { return bound2 }
		public var hiIndex: Int { return size }
		public var loBound: Int { return bound1 }
		public var loIndex: Int { return 1 }
		public var size: Int { return rep.count }
		public var isEmpty: Bool { return rep.isEmpty }

		public subscript(index: Int?) -> ELEMENT? {
			get{
				guard let index = index, index >= loIndex, index <= hiIndex else { return nil }
				return rep[index - loIndex].copy()
			}
		}
		
		public var asAggregationSequence: AnySequence<ELEMENT> { return AnySequence(self.copy().rep) }

		public func CONTAINS(elem: ELEMENT?) -> SDAI.LOGICAL {
			guard let elem = elem else { return UNKNOWN }
			return LOGICAL(rep.contains(elem))
		}
		
		public func QUERY(logical_expression: @escaping (ELEMENT) -> LOGICAL ) -> BAG<ELEMENT> {
			return BAG(from: SwiftType(rep.lazy.filter{ logical_expression($0).isTRUE }.map{ $0.copy() }), 
								 bound1:self.loBound, bound2: self.hiBound)
		}
		
		// SDAI.BagType
		public mutating func add(member: ELEMENT?) {
			guard let member = member else {return}
			rep.append(member)
		}
		
		@discardableResult
		public mutating func remove(member: ELEMENT?) -> Bool {
			guard let member = member else {return false}
			if let index = rep.lastIndex(of: member) {
				rep.remove(at: index)
				return true
			}
			return false
		}
		
		@discardableResult
		public mutating func removeAll(member: ELEMENT?) -> Bool {
			guard let member = member else {return false}
			var result = false
			rep.removeAll { 
				if $0 == member {
					result = true
					return true
				}
				return false
			}
			return result
		}
		
		// SDAI.SwiftDictRepresentable
		public var asSwiftDict: Dictionary<ELEMENT.FundamentalType, Int> {
			return Dictionary<ELEMENT.FundamentalType,Int>( self.lazy.map{($0.asFundamentalType, 1)},
																											uniquingKeysWith: {$0 + $1} )
		}

		public var asValueDict: Dictionary<ELEMENT.Value,Int> {
			return Dictionary<ELEMENT.Value,Int>( self.lazy.map{($0.value, 1)}, 
																						uniquingKeysWith: {$0 + $1} )
		}
		
		// BAG specific
		public func map<T:SDAI.GenericType>(_ transform: (ELEMENT) -> T ) -> BAG<T> {
			let mapped = self.rep.map(transform)
			return BAG<T>(from:mapped, bound1:self.bound1, bound2:self.bound2)
		}
		
		internal init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, S:Sequence>(
			bound1: I1, bound2: I2?,
			_ elements: [S], conv: (S.Element) -> ELEMENT? )
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
		public init?<G: SDAI.GenericType>(fromGeneric generic: G?) {
			guard let fundamental = generic?.bagValue(elementType: ELEMENT.self) else { return nil }
			self.init(fundamental: fundamental)
		}

		// InitializableByGenericSet
		public init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.SET__TypeBehavior>(
			bound1: I1, bound2: I2?, generic settype: T?)
		{
			guard let settype = settype else { return nil }
			self.init(bound1: bound1, bound2: bound2, [settype]){ELEMENT.convert(fromGeneric: $0)}
		}

		// InitializableByGenericBag
		public init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.BAG__TypeBehavior>(
			bound1: I1, bound2: I2?, generic bagtype: T?)
		{
			guard let bagtype = bagtype else { return nil }
			self.init(bound1: bound1, bound2: bound2, [bagtype]){ELEMENT.convert(fromGeneric: $0)}
		}
		
		// InitializableByGenericList
		public init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.LIST__TypeBehavior>(
			bound1: I1, bound2: I2?, generic listtype: T?)
		{
			guard let listtype = listtype else { return nil }
			self.init(bound1: bound1, bound2: bound2, [listtype]){ELEMENT.convert(fromGeneric: $0)}
		}

		// InitializableByEmptyListLiteral
		public init<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible>(
			bound1: I1, bound2: I2?, _ emptyLiteral: SDAI.EmptyAggregateLiteral = SDAI.EMPTY_AGGREGATE)
		{
			self.init(from: SwiftType(), bound1: bound1, bound2: bound2)
		}

		// InitializableBySwifttypeAsList
		public init<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible>(
			from swiftValue: SwiftType, bound1: I1, bound2: I2?)
		{
			self.bound1 = bound1.possiblyAsSwiftInt ?? 0
			self.bound2 = bound2?.possiblyAsSwiftInt
			self.rep = swiftValue
		}

		// SDAI.InitializableBySelecttypeAsList
		public init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, S: SDAI.SelectType>(
			bound1: I1, bound2: I2?, _ select: S?)
		{
			guard let fundamental = Self.init(possiblyFrom: select) else { return nil }
			self.init(from: fundamental.asSwiftType, bound1:bound1, bound2:bound2)
		}

		// SDAI.InitializableByListLiteral
		public init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, E: SDAI.GenericType>(
			bound1: I1, bound2: I2?, _ elements: [SDAI.AggregationInitializerElement<E>])
		{
			self.init(bound1: bound1, bound2: bound2, elements){ ELEMENT.convert(fromGeneric: $0) }
		} 
		
		
		//MARK: Aggregation operator support
		//MARK: Intersection
		private func intersectionWith<S: SDAI.SwiftDictRepresentable>(other: S) -> [ELEMENT.FundamentalType]
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
		
		public func intersectionWith<U: SDAI.BAG__TypeBehavior>(rhs: U) -> SDAI.BAG<ELEMENT>? 
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			let result = self.intersectionWith(other: rhs)
			return BAG(bound1: 0, bound2: _Infinity, [result]){ ELEMENT.convert(from: $0) }
		}

		public func intersectionWith<U: SDAI.SET__TypeBehavior>(rhs: U) -> SDAI.SET<ELEMENT>?
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			let result = self.intersectionWith(other: rhs)
			return SET(bound1: 0, bound2: _Infinity, [result]){ ELEMENT.convert(from: $0) }
		}

		public func intersectionWith<U: SDAI.AggregationInitializer>(rhs: U) -> SDAI.BAG<ELEMENT>?
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			let result = self.intersectionWith(other: rhs )
			return BAG(bound1: 0, bound2: _Infinity, [result]){ ELEMENT.convert(from: $0) }
		}
		
		//MARK: Union
		private func unionWith<S: SDAI.AggregationSequence>(other: S) -> SwiftType
		where S.ELEMENT.FundamentalType == ELEMENT.FundamentalType {
//			assert(self.observer == nil)
			var result = self.rep
			result.append(contentsOf: other.asAggregationSequence.lazy.map{ ELEMENT.convert(from: $0.asFundamentalType) } )
			return result
		}
		
		public func unionWith<U: SDAI.BagType>(rhs: U) -> SDAI.BAG<ELEMENT>? 
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			let result = self.unionWith(other: rhs)
			return BAG(from: result, bound1: 0, bound2: _Infinity)
		}

		public func unionWith<U: SDAI.ListType>(rhs: U) -> SDAI.BAG<ELEMENT>?
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			let result = self.unionWith(other: rhs)
			return BAG(from: result, bound1: 0, bound2: _Infinity)
		}

		public func unionWith<U: SDAI.GenericType>(rhs: U) -> SDAI.BAG<ELEMENT>?
		where ELEMENT.FundamentalType == U.FundamentalType {
			var result = self.rep
			result.append(ELEMENT.convert(from: rhs.asFundamentalType))
			return BAG(from: result, bound1: 0, bound2: _Infinity)
		}

		public func unionWith<U: SDAI.GENERIC__TypeBehavior>(rhs: U) -> SDAI.BAG<ELEMENT>? {
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

		public func unionWith<U: SDAI.AggregationInitializer>(rhs: U) -> SDAI.BAG<ELEMENT>?
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			let result = self.unionWith(other: rhs)
			return BAG(from: result, bound1: 0, bound2: _Infinity)
		}

		//MARK: Difference
		private func differenceWith<S: SDAI.SwiftDictRepresentable>(other: S) -> [ELEMENT.FundamentalType]
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

		public func differenceWith<U: SDAI.BagType>(rhs: U) -> SDAI.BAG<ELEMENT>? 
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			let result = self.differenceWith(other: rhs)
			return BAG(bound1: 0, bound2: _Infinity, [result]){ ELEMENT.convert(from: $0) }
		}

		public func differenceWith<U: SDAI.GenericType>(rhs: U) -> SDAI.BAG<ELEMENT>?
		where ELEMENT.FundamentalType == U.FundamentalType {
			var selfDict = self.asSwiftDict
			if let selfCount = selfDict[rhs.asFundamentalType] {
					selfDict[rhs.asFundamentalType] =  selfCount == 1 ? nil : selfCount - 1
			}
			return BAG(bound1: 0, bound2: _Infinity, selfDict.lazy.map(
									{ (elem,count) in repeatElement(elem, count: count)})
			) { ELEMENT.convert(from: $0) }
		}

		public func differenceWith<U: SDAI.GENERIC__TypeBehavior>(rhs: U) -> SDAI.BAG<ELEMENT>? {
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

		public func differenceWith<U: SDAI.AggregationInitializer>(rhs: U) -> SDAI.BAG<ELEMENT>?
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			let result = self.differenceWith(other: rhs)
			return BAG(bound1: 0, bound2: _Infinity, [result]){ ELEMENT.convert(from: $0) }
		}

		
		//MARK: InitializableByP21Parameter
		public static var bareTypeName: String { self.typeName }
		
		public init?(
			p21untypedParam: P21Decode.ExchangeStructure.UntypedParameter,
			from exchangeStructure: P21Decode.ExchangeStructure)
		{
			switch p21untypedParam {
			case .list(let listval):
				var array: SwiftType = []
				for param in listval {
					guard let elem = ELEMENT(p21param: param, from: exchangeStructure) else { exchangeStructure.add(errorContext: "while resolving \(Self.bareTypeName) element value"); return nil }
					array.append(elem)
				}
				self.init(from: array)
				
			case .rhsOccurrenceName(let rhsname):
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
			self.init()
		}
		

    // InitializableByVoid 
    public init() {
      self.init(from: SwiftType())
    }

  }
}


extension SDAI.BAG: SDAI.FundamentalAggregationType {}

extension SDAI.BAG: SDAI.EntityReferenceYielding
where ELEMENT: SDAI.EntityReferenceYielding
{ }


extension SDAI.BAG: SDAI.DualModeReference
where ELEMENT: SDAI.DualModeReference
{
	public var pRef: SDAI.BAG<ELEMENT.PRef> {
		let converted = self.map{ $0.pRef }
		return converted
	}
}

extension SDAI.BAG: SDAI.PersistentReference
where ELEMENT: SDAI.PersistentReference
{
	public var aRef: SDAI.BAG<ELEMENT.ARef> {
		let converted = self.map{ $0.aRef }
		return converted
	}

	public var optionalARef: SDAI.BAG<ELEMENT.ARef>? {
		let converted = self.compactMap{ $0.optionalARef }
		guard converted.count == self.size else { return nil }
		return SDAI.BAG(from: converted, bound1: self.bound1, bound2: self.bound2)
	}
}



extension SDAI.BAG: SDAI.InitializableBySelecttypeBag, SDAI.InitializableBySelecttypeSet
where ELEMENT: SDAI.InitializableBySelectType
{
	public init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.BAG__TypeBehavior>(
		bound1: I1, bound2: I2?, _ bagtype: T?) 
	where T.ELEMENT: SDAI.SelectType
	{
		guard let bagtype = bagtype else { return nil }
		self.init(bound1: bound1, bound2: bound2, [bagtype]){ ELEMENT.convert(sibling: $0) }
	}
	
	public init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.SET__TypeBehavior>(
		bound1: I1, bound2: I2?, _ settype: T?)
	where T.ELEMENT: SDAI.SelectType
	{
		guard let settype = settype else { return nil }
		self.init(bound1: bound1, bound2: bound2, [settype]){ ELEMENT.convert(sibling: $0) }
	}
	
}


extension SDAI.BAG: SDAI.InitializableByEntityBag, SDAI.InitializableByEntitySet
where ELEMENT: SDAI.InitializableByComplexEntity
{
	public init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.BAG__TypeBehavior>(
		bound1: I1, bound2: I2?, _ bagtype: T?)
	where T.ELEMENT: SDAI.EntityReference
	{
		guard let bagtype = bagtype else { return nil }
		self.init(bound1: bound1, bound2: bound2, [bagtype]) {
			return ELEMENT.convert(sibling: $0) 
		}		
	}

	public init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.SET__TypeBehavior>(
		bound1: I1, bound2: I2?, _ settype: T?)
	where T.ELEMENT: SDAI.EntityReference
	{
		guard let settype = settype else { return nil }
		self.init(bound1: bound1, bound2: bound2, [settype]) {
				return ELEMENT.convert(sibling: $0) 
		}		
	}

	public init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.BAG__TypeBehavior>(
		bound1: I1, bound2: I2?, _ bagtype: T?)
	where T.ELEMENT: SDAI.PersistentReference,
	T.ELEMENT.ARef: SDAI.EntityReference
	{
		guard let bagtype = bagtype else { return nil }
		self.init(bound1: bound1, bound2: bound2, [bagtype]) {
			return ELEMENT.convert(sibling: $0)
		}
	}

	public init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.SET__TypeBehavior>(
		bound1: I1, bound2: I2?, _ settype: T?)
	where T.ELEMENT: SDAI.PersistentReference,
	T.ELEMENT.ARef: SDAI.EntityReference
	{
		guard let settype = settype else { return nil }
		self.init(bound1: bound1, bound2: bound2, [settype]) {
			return ELEMENT.convert(sibling: $0)
		}
	}

}


extension SDAI.BAG: SDAI.InitializableByDefinedtypeBag, SDAI.InitializableByDefinedtypeSet 
where ELEMENT: SDAI.InitializableByDefinedType
{
	public init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.BAG__TypeBehavior>(
		bound1: I1, bound2: I2?, _ bagtype: T?)
	where T.ELEMENT: SDAI.UnderlyingType
	{
		guard let bagtype = bagtype else { return nil }
		self.init(bound1: bound1, bound2: bound2, [bagtype]) { ELEMENT.convert(sibling: $0) }
	}
	
	public init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.SET__TypeBehavior>(
		bound1: I1, bound2: I2?, _ settype: T?) 
	where T.ELEMENT: SDAI.UnderlyingType
	{
		guard let settype = settype else { return nil }
		self.init(bound1: bound1, bound2: bound2, [settype]) { ELEMENT.convert(sibling: $0) }
	}	
}




