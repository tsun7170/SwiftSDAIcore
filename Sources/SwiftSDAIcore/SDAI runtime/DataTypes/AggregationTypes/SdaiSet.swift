//
//  SdaiSet.swift
//  
//
//  Created by Yoshida on 2020/10/10.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation


//MARK: - set type (8.2.4)
extension SDAI {
  /// A protocol representing the SDAI SET type, which is an unordered collection of unique elements.
  /// 
  /// `SetType` conforms to `SDAI.BagType`, inheriting the capabilities of a bag (multi-set), 
  /// but restricts the collection to contain no duplicate elements, thus enforcing set semantics.
  /// 
  /// Use this protocol to represent and work with sets in the context of SDAI aggregate types.
  /// 
  /// - Note: According to the SDAI (Standard Data Access Interface) specification, a SET is an unordered aggregation
  ///   of unique elements, where the cardinality may be bounded or unbounded. 
  /// 
  /// Conformance Requirements:
  /// - Must inherit from `SDAI.BagType`, but must ensure uniqueness of elements.
  /// 
  /// Related types:
  /// - `SDAI.SET` provides a concrete implementation of the set aggregate.
  /// - `SDAI.BagType` provides the base protocol for bag/collection types.
  /// 
  /// See also: ISO 10303-22 (SDAI) Section 8.2.4 "SET aggregate type".
  public protocol SetType: SDAI.BagType
  {}
}

//MARK: - SET type
extension SDAI {
  public protocol SET__TypeBehavior: SDAI.SetType
  where Element == ELEMENT,
        FundamentalType == SDAI.SET<ELEMENT>,
        Value == FundamentalType.Value,
        SwiftType == FundamentalType.SwiftType
  {
    // Aggregation operator support
    func intersectionWith<U: SDAI.BagType>(rhs: U) -> SDAI.SET<ELEMENT>?
    where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType

    func intersectionWith<U: SDAI.AggregationInitializer>(rhs: U) -> SDAI.SET<ELEMENT>?
    where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType


    func unionWith<U: SDAI.BagType>(rhs: U) -> SDAI.SET<ELEMENT>?
    where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType

    func unionWith<U: SDAI.ListType>(rhs: U) -> SDAI.SET<ELEMENT>?
    where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType

    func unionWith<U: SDAI.GenericType>(rhs: U) -> SDAI.SET<ELEMENT>?
    where ELEMENT.FundamentalType == U.FundamentalType

    func unionWith<U: SDAI.GENERIC__TypeBehavior>(rhs: U) -> SDAI.SET<ELEMENT>?

    func unionWith<U: SDAI.AggregationInitializer>(rhs: U) -> SDAI.SET<ELEMENT>?
    where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType


    func differenceWith<U: SDAI.BagType>(rhs: U) -> SDAI.SET<ELEMENT>?
    where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType

    func differenceWith<U: SDAI.GenericType>(rhs: U) -> SDAI.SET<ELEMENT>?
    where ELEMENT.FundamentalType == U.FundamentalType

    func differenceWith<U: SDAI.GENERIC__TypeBehavior>(rhs: U) -> SDAI.SET<ELEMENT>?

    func differenceWith<U: SDAI.AggregationInitializer>(rhs: U) -> SDAI.SET<ELEMENT>?
    where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
  }
}

public extension SDAI.SET__TypeBehavior
where ELEMENT: SDAI.InitializableByComplexEntity {
	func unionWith(rhs: SDAI.ComplexEntity) -> SDAI.SET<ELEMENT>? {
		guard let rhs = ELEMENT(possiblyFrom: rhs) else { return nil }
		return self.unionWith(rhs: rhs)
	}
	func differenceWith(rhs: SDAI.ComplexEntity) -> SDAI.SET<ELEMENT>? {
		guard let rhs = ELEMENT(possiblyFrom: rhs) else { return nil }
		return self.differenceWith(rhs: rhs)
	}
}
public extension SDAI.SET__TypeBehavior 
where ELEMENT: SDAI.EntityReference {
	func unionWith<U: SDAI.SelectType>(rhs: U) -> SDAI.SET<ELEMENT>? {
		guard let rhs = ELEMENT(possiblyFrom: rhs) else { return nil }
		return self.unionWith(rhs: rhs)
	}
	func differenceWith<U: SDAI.SelectType>(rhs: U) -> SDAI.SET<ELEMENT>? {
		guard let rhs = ELEMENT(possiblyFrom: rhs) else { return nil }
		return self.differenceWith(rhs: rhs)
	}
}
public extension SDAI.SET__TypeBehavior 
where ELEMENT: SDAI.PersistentReference {
	func unionWith<U: SDAI.SelectType>(rhs: U) -> SDAI.SET<ELEMENT>? {
		guard let rhs = ELEMENT(possiblyFrom: rhs) else { return nil }
		return self.unionWith(rhs: rhs)
	}
	func differenceWith<U: SDAI.SelectType>(rhs: U) -> SDAI.SET<ELEMENT>? {
		guard let rhs = ELEMENT(possiblyFrom: rhs) else { return nil }
		return self.differenceWith(rhs: rhs)
	}
}


//MARK: - SDAI.SET
extension SDAI {
  /// A concrete implementation of the SDAI `SET` aggregate type, representing an unordered collection of unique elements.
  ///
  /// `SDAI.SET` conforms to the `SDAI.SET__TypeBehavior` protocol and provides the full set of behaviors and operations 
  /// expected from a set in the context of SDAI (Standard Data Access Interface) aggregates:
  ///  - Enforces uniqueness of elements (no duplicates).
  ///  - Maintains unordered storage of elements.
  ///  - Supports queries, set operators (union, intersection, difference), and element containment checks.
  ///  - Allows construction from various sources: other aggregates, Swift sets, sequences, and EXPRESS list literals.
  ///  - Provides conversions to and from generic SDAI types, as well as EXPRESS type system bridging.
  ///
  /// - Type Parameters:
  ///   - `ELEMENT`: The type of elements stored in the set, which must conform to `SDAI.GenericType`.
  ///
  /// - Features:
  ///    - Set algebra: `unionWith`, `intersectionWith`, `differenceWith` for combining and comparing sets.
  ///    - Querying and mapping: `QUERY` for element filtering and `map`/`compactMap` for transformation.
  ///    - EXPRESS-compliant cardinality: optional lower and upper bounds for enforcing element count limits.
  ///    - Support for EXPRESS aggregate initializers and P21 (STEP Physical File) decoding.
  ///
  /// - Notes:
  ///    - The `SET` type is used to express the semantics of the EXPRESS `SET` aggregate type in ISO 10303-22 (SDAI).
  ///    - The type ensures that all stored elements are unique, rejecting insertions of duplicates.
  ///    - As with all SDAI aggregate types, type-safe bridging to and from Swift native types and EXPRESS types is provided.
  ///
  /// - See also:
  ///    - `SDAI.SetType`, the protocol for general set behavior.
  ///    - `SDAI.BagType`, for multisets (with duplicates).
  ///    - ISO 10303-22 (SDAI), section 8.2.4 "SET aggregate type".
	public struct SET<ELEMENT:SDAI.GenericType>: SDAI.SET__TypeBehavior
	{
		public typealias SwiftType = Set<ELEMENT>
		public typealias FundamentalType = Self
		
		fileprivate var rep: SwiftType
		private var bound1: Int
		private var bound2: Int?
		
		// Equatable \Hashable\SDAI.GenericType
		public static func == (lhs: SDAI.SET<ELEMENT>, rhs: SDAI.SET<ELEMENT>) -> Bool {
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
			return [SDAI.STRING(Self.typeName), SDAI.STRING(from: BAG<ELEMENT>.typeName)]
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
			return BAG<ELEM>(bound1: self.loBound, bound2: self.hiBound, [self]) { ELEM.convert(fromGeneric: $0.copy()) }
		}
		public func setValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.SET<ELEM>? {
			if let value = self as? SET<ELEM> { return value.copy() }
			return SET<ELEM>(bound1: self.loBound, bound2: self.hiBound, [self]) { ELEM.convert(fromGeneric: $0.copy()) }
		}

		public func enumValue<ENUM:SDAI.EnumerationType>(enumType:ENUM.Type) -> ENUM? {nil}

		public static func validateWhereRules(instance:Self?, prefix:SDAIPopulationSchema.WhereLabel) -> SDAIPopulationSchema.WhereRuleValidationRecords {
			return SDAI.validateAggregateElementsWhereRules(instance, prefix: prefix)
		}

		

		// SDAI.GenericType \SDAI.UnderlyingType\SDAI.AggregationType\SDAI__BAG__type\SDAI__SET__type
		public static var typeName: String { return "SET" }
		public var asSwiftType: SwiftType { return self.copy().rep }
		
		// SDAI.GenericType
		public func copy() -> Self {
			return self
		}
		
		public var asFundamentalType: FundamentalType { return self.copy() }

		public init(fundamental: FundamentalType) {
			self.init(from: fundamental.asSwiftType, bound1: fundamental.loBound, bound2: fundamental.hiBound)
		}
	
		// Sequence \SDAI.AggregationType\SDAI__BAG__type\SDAI__SET__type
		public func makeIterator() -> SwiftType.Iterator { return self.copy().rep.makeIterator() }

		// SDAI.AggregationType \SDAI__BAG__type\SDAI__SET__type
		public var hiBound: Int? { return bound2 }
		public var hiIndex: Int { return size }
		public var loBound: Int { return bound1 }
		public var loIndex: Int { return 1 }
		public var size: Int { return rep.count }
		public var isEmpty: Bool { return rep.isEmpty }

		public subscript(index: Int?) -> ELEMENT? {
			get{
				guard let index = index, index >= loIndex, index <= hiIndex else { return nil }
				let setIndex = rep.index(rep.startIndex, offsetBy: index - loIndex)
				return rep[setIndex].copy()
			}
		}
		
		public var asAggregationSequence: AnySequence<ELEMENT> { return AnySequence(self.copy().rep) }

		public func CONTAINS(elem: ELEMENT?) -> SDAI.LOGICAL {
			guard let elem = elem else { return UNKNOWN }
			return LOGICAL(rep.contains(elem))
		}
		
		public func QUERY(logical_expression: @escaping (ELEMENT) -> LOGICAL ) -> SET<ELEMENT> {
			return SET(from: SwiftType(rep.lazy.filter{ logical_expression($0).isTRUE }.map{ $0.copy() }), 
								 bound1:self.loBound, bound2: self.hiBound)
		}
		
		// SDAI.BagType
		public mutating func add(member: ELEMENT?) {
			guard let member = member else {return}
			rep.insert(member)
		}
		
		@discardableResult
		public mutating func remove(member: ELEMENT?) -> Bool {
			guard let member = member else { return false }
			let result = rep.remove(member)
			return result != nil
		}
		
		@discardableResult
		public mutating func removeAll(member: ELEMENT?) -> Bool {
			return remove(member: member)
		}

		// SDAI.SwiftDictRepresentable
		public var asSwiftDict: Dictionary<ELEMENT.FundamentalType, Int> {
			return Dictionary<ELEMENT.FundamentalType, Int>(
				uniqueKeysWithValues: self.lazy.map{($0.asFundamentalType, 1)} )
		}

		public var asValueDict: Dictionary<ELEMENT.Value,Int> {
			return Dictionary<ELEMENT.Value,Int>( self.lazy.map{($0.value, 1)}, 
																						uniquingKeysWith: {$0 + $1})
		}

		
		// SET specific
		public func map<T:SDAI.GenericType>(_ transform: (ELEMENT) -> T ) -> SET<T> {
			let mapped = Set<T>( self.rep.map(transform) )
			return SET<T>(from: mapped, bound1: self.bound1, bound2: self.bound2)
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
					swiftValue.insert( converted )
				}
			}
			self.init(from: swiftValue, bound1: bound1, bound2: bound2)
		}
		
		// InitializableByGenerictype
		public init?<G: SDAI.GenericType>(fromGeneric generic: G?) {
			guard let fundamental = generic?.setValue(elementType: ELEMENT.self) else { return nil }
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
		public init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, E:SDAI.GenericType>(
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
			for (elem,_) in selfDict {
				if otherDict[elem] != nil {
					result.append(elem)
				}
			}
			return result
		}

		public func intersectionWith<U: SDAI.BagType>(rhs: U) -> SDAI.SET<ELEMENT>? 
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			if let sametype = rhs as? Self {
				let result = self.rep.intersection(sametype.rep)
				return SET(from: result, bound1: 0, bound2: _Infinity)
			}
			let result = self.intersectionWith(other: rhs)
			return SET(bound1: 0, bound2: _Infinity, [result]){ ELEMENT.convert(from: $0) }
		}

		public func intersectionWith<U: SDAI.AggregationInitializer>(rhs: U) -> SDAI.SET<ELEMENT>?
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			let result = self.intersectionWith(other: rhs)
			return SET(bound1: 0, bound2: _Infinity, [result]){ ELEMENT.convert(from: $0) }
		}
		
		//MARK: Union
		private func unionWith<S: SDAI.AggregationSequence>(other: S) -> SwiftType
		where S.ELEMENT.FundamentalType == ELEMENT.FundamentalType {
			let result = self.rep.union( other.asAggregationSequence.lazy.map{ ELEMENT.convert(from: $0.asFundamentalType) } )
			return result
		}
		
		public func unionWith<U: SDAI.BagType>(rhs: U) -> SDAI.SET<ELEMENT>? 
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			if let sametype = rhs as? Self {
				let result = self.rep.union(sametype.rep)
				return SET(from: result, bound1: 0, bound2: _Infinity)
			}
			let result = self.unionWith(other: rhs)
			return SET(from: result, bound1: 0, bound2: _Infinity)
		}

		public func unionWith<U: SDAI.ListType>(rhs: U) -> SDAI.SET<ELEMENT>?
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			let result = self.unionWith(other: rhs)
			return SET(from: result, bound1: 0, bound2: _Infinity)
		}

		public func unionWith<U: SDAI.GenericType>(rhs: U) -> SDAI.SET<ELEMENT>?
		where ELEMENT.FundamentalType == U.FundamentalType {
			var result = self.rep
			result.insert(ELEMENT.convert(from: rhs.asFundamentalType))
			return SET(from: result, bound1: 0, bound2: _Infinity)
		}

		public func unionWith<U: SDAI.GENERIC__TypeBehavior>(rhs: U) -> SDAI.SET<ELEMENT>? {
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

		public func unionWith<U: SDAI.AggregationInitializer>(rhs: U) -> SDAI.SET<ELEMENT>?
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			let result = self.unionWith(other: rhs)
			return SET(from: result, bound1: 0, bound2: _Infinity)
		}

		//MARK: Difference
		private func differenceWith<S: SDAI.SwiftDictRepresentable>(other: S) -> [ELEMENT.FundamentalType]
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

		public func differenceWith<U: SDAI.BagType>(rhs: U) -> SDAI.SET<ELEMENT>? 
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
		{
			if let sametype = rhs as? Self {
				let result = self.rep.subtracting(sametype.rep)
				return SET(from: result, bound1: 0, bound2: _Infinity)
			}
			let result = self.differenceWith(other: rhs)
			return SET(bound1: 0, bound2: _Infinity, [result]){ ELEMENT.convert(from: $0) }
		}

		public func differenceWith<U: SDAI.GenericType>(rhs: U) -> SDAI.SET<ELEMENT>?
		where ELEMENT.FundamentalType == U.FundamentalType {
			var selfDict = self.asSwiftDict
			if selfDict[rhs.asFundamentalType] != nil {
					selfDict[rhs.asFundamentalType] =  nil
			}
			return SET(bound1: 0, bound2: _Infinity, selfDict.lazy.map(
									{ (elem,_) in CollectionOfOne(elem)})
			) { ELEMENT.convert(from: $0) }
		}

		public func differenceWith<U: SDAI.GENERIC__TypeBehavior>(rhs: U) -> SDAI.SET<ELEMENT>? {
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

		public func differenceWith<U: SDAI.AggregationInitializer>(rhs: U) -> SDAI.SET<ELEMENT>?
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			let result = self.differenceWith(other: rhs)
			return SET(bound1: 0, bound2: _Infinity, [result]){ ELEMENT.convert(from: $0) }
		}

		//MARK: InitializableByP21Parameter
		public static var bareTypeName: String { self.typeName }
		
		public init?(
			p21untypedParam: P21Decode.ExchangeStructure.UntypedParameter,
			from exchangeStructure: P21Decode.ExchangeStructure)
		{
			switch p21untypedParam {
			case .list(let listval):
				var set: SwiftType = []
				for param in listval {
					guard let elem = ELEMENT(p21param: param, from: exchangeStructure) else { exchangeStructure.add(errorContext: "while resolving \(Self.bareTypeName) element value"); return nil }
					let (inserted,_) = set.insert(elem)
					guard inserted else { exchangeStructure.error = "duplicated set element(\(elem)), while resolving \(Self.bareTypeName) element value"; return nil }
				}
				self.init(from: set)
				
			case .rhsOccurrenceName(let rhsname):
				switch rhsname {
				case .constantValueName(let name):
					guard let generic = exchangeStructure.resolve(constantValueName: name) else {exchangeStructure.add(errorContext: "while resolving \(Self.bareTypeName) value"); return nil }
					guard let setValue = generic.setValue(elementType: ELEMENT.self) else { exchangeStructure.error = "constant value(\(name): \(generic)) is not compatible with \(Self.bareTypeName)[\(ELEMENT.self)]"; return nil }
					self.init(setValue)
				
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

  }//struct
}//extension



extension SDAI.SET: SDAI.FundamentalAggregationType{}

extension SDAI.SET: SDAI.EntityReferenceYielding
where ELEMENT: SDAI.EntityReferenceYielding
{ }

extension SDAI.SET: SDAI.DualModeReference
where ELEMENT: SDAI.DualModeReference
{
	public var pRef: SDAI.SET<ELEMENT.PRef> {
		let converted = self.map{ $0.pRef }
		return converted
	}
}

extension SDAI.SET: SDAI.PersistentReference
where ELEMENT: SDAI.PersistentReference
{
	public var aRef: SDAI.SET<ELEMENT.ARef> {
		let converted = self.map{ $0.aRef }
		return converted
	}

	public var optionalARef: SDAI.SET<ELEMENT.ARef>? {
		let converted = self.compactMap{ $0.optionalARef }
//		guard converted.count == self.size else { return nil }
		return SDAI.SET(from: Set(converted), bound1: self.bound1, bound2: self.bound2)
	}
}



extension SDAI.SET: SDAI.InitializableBySelecttypeSet
where ELEMENT: SDAI.InitializableBySelectType
{
	public init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.SET__TypeBehavior>(
		bound1: I1, bound2: I2?, _ settype: T?) 
	where T.ELEMENT: SDAI.SelectType
	{
		guard let settype = settype else { return nil }
		self.init(bound1: bound1, bound2: bound2, [settype]){ ELEMENT.convert(sibling: $0) }
	}		
}





extension SDAI.SET: SDAI.InitializableByEntitySet
where ELEMENT: SDAI.InitializableByComplexEntity
{
	public init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.SET__TypeBehavior>(
		bound1: I1, bound2: I2?, _ settype: T?)
	where T.ELEMENT: SDAI.EntityReference
	{
		guard let settype = settype else { return nil }
		self.init(bound1: bound1, bound2: bound2, [settype]) { ELEMENT.convert(sibling: $0) }		
	}

	public init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.SET__TypeBehavior>(
		bound1: I1, bound2: I2?, _ settype: T?)
	where T.ELEMENT: SDAI.PersistentReference,
	T.ELEMENT.ARef: SDAI.EntityReference
	{
		guard let settype = settype else { return nil }
		self.init(bound1: bound1, bound2: bound2, [settype]) { ELEMENT.convert(sibling: $0) }		
	}
}


extension SDAI.SET: SDAI.InitializableByDefinedtypeSet
where ELEMENT: SDAI.InitializableByDefinedType
{
	public init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.SET__TypeBehavior>(
		bound1: I1, bound2: I2?, _ settype: T?) 
	where T.ELEMENT: SDAI.UnderlyingType
	{
		guard let settype = settype else { return nil }
		self.init(bound1:bound1, bound2:bound2, [settype]) { ELEMENT.convert(sibling: $0) }
	}
}


