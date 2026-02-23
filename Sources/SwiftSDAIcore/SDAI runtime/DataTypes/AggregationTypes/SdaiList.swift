//
//  SdaiList.swift
//  
//
//  Created by Yoshida on 2020/10/04.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation





//MARK: - list type (8.2.2)
extension SDAI {
  /// A protocol representing a generic SDAI LIST aggregation type, as defined by the EXPRESS data modeling language.
  /// 
  /// Conforming types must provide standard aggregation behaviors, index-based access, and type conversions, as well as support initialization from various literal and generic sources.
  /// 
  /// - Conforms To:
  ///     - `SDAI.AggregationType`
  ///     - `SDAI.AggregateIndexingSettable`
  ///     - `SDAI.UnderlyingType`
  ///     - `SDAI.SwiftTypeRepresented`
  ///     - `SDAI.Initializable.ByEmptyListLiteral`
  ///     - `SDAI.Initializable.BySwifttypeAsList`
  ///     - `SDAI.Initializable.BySelecttypeAsList`
  ///     - `SDAI.Initializable.ByListLiteral`
  ///     - `SDAI.Initializable.ByGenericList`
  ///     - `SDAI.Initializable.ByVoid`
  ///
  /// You can use the `ListType` protocol to generically represent EXPRESS LIST types in Swift, allowing for:
  /// - Aggregation operations and indexing
  /// - Initialization from various EXPRESS-conformant data sources
  /// - Support for built-in mutating procedures such as `insert(element:at:)` and `remove(at:)`
  ///
  /// ### Required Methods
  /// - `mutating func insert(element: ELEMENT, at position: Int)`
  ///     - Inserts a new element at the specified position.
  /// - `mutating func remove(at position: Int)`
  ///     - Removes the element at the specified position.
  /// 
  /// ### Typical Usage
  /// This protocol is intended for types that model EXPRESS LIST types and need to support the full range of aggregation and mutability operations expected in such lists.
  ///
  public protocol ListType:
    SDAI.AggregationType, SDAI.AggregateIndexingSettable, SDAI.UnderlyingType, SDAI.SwiftTypeRepresented,
    SDAI.Initializable.ByEmptyListLiteral, SDAI.Initializable.BySwifttypeAsList, SDAI.Initializable.BySelecttypeAsList,
    SDAI.Initializable.ByListLiteral, SDAI.Initializable.ByGenericList, SDAI.Initializable.ByVoid
  {
    //MARK: Built-in procedure support

    /// Inserts a new element at the specified position in the list. (ISO 10303-22 10.19.3)
    ///
    /// The new element will appear at the given 1-based position, shifting any existing elements at or after that position to the right.
    ///
    /// - Parameters:
    ///   - element: The element to insert into the list.
    ///   - position: The 1-based index at which to insert the element. Must be greater than or equal to 1 and less than or equal to the current size of the list plus one.
    ///
    /// - Precondition: `position` must be in the range `1...size+1`. If not, a runtime assertion failure will occur.
    ///
    /// - Note: EXPRESS `LIST` types use 1-based indexing. Inserting at position 1 inserts the element at the start of the list.
    mutating func insert(element: ELEMENT, at position: Int)

    /// Removes the element at the specified position in the list. (ISO 10303-22 10.19.7)
    ///
    /// The element at the given 1-based index will be removed, with all subsequent elements shifting one position to the left to fill the gap.
    ///
    /// - Parameter position: The 1-based index of the element to remove. Must be greater than or equal to 1 and less than or equal to the current size of the list.
    /// - Precondition: `position` must be in the range `1...size`. If not, a runtime assertion failure will occur.
    /// - Note: EXPRESS `LIST` types use 1-based indexing. Removing at position 1 removes the first element of the list.
    mutating func remove(at position: Int)
  }
}

extension SDAI.ListType {
	public var isCacheable: Bool {
		for elem in self.asAggregationSequence {
			if !elem.isCacheable { return false }
		}
		return true
	}	
}


//MARK: - LIST type
extension SDAI.TypeHierarchy {
  /// A protocol describing the EXPRESS `LIST` aggregation type's required behaviors within the SDAI system.
  /// 
  /// `LIST__TypeBehavior` defines the fundamental and advanced operations expected of an EXPRESS `LIST` type,
  /// including aggregation, initialization, indexing, and aggregation operators for combining or transforming lists.
  /// 
  /// Conforming types must:
  /// - Provide support for index-based access and mutation
  /// - Define EXPRESS-specific bounds and element types
  /// - Support various forms of initialization, including from generic and list types
  /// - Implement aggregation operators such as append and prepend, enabling EXPRESS-compliant list composition
  /// - Optionally provide schema-level flags such as uniqueness
  /// 
  /// ### Associated Types
  /// - `Element`: The specific element type contained within the list.
  /// - `FundamentalType`: The concrete list type modeled, typically `SDAI.LIST<ELEMENT>`.
  /// - `Value`: The EXPRESS value representation of the list.
  /// - `SwiftType`: The native Swift representation of the list's contents.
  ///
  /// ### Required Static Properties
  /// - `uniqueFlag`: Indicates whether the `LIST` type must enforce element uniqueness (always `false` for standard EXPRESS `LIST`).
  ///
  /// ### Required Methods
  /// - `appendWith(rhs:)`: Produces a new `SDAI.LIST` by appending another list, generic value, or aggregation.
  /// - `prependWith(lhs:)`: Produces a new `SDAI.LIST` by prepending another list, generic value, or aggregation.
  /// 
  /// ### Typical Usage
  /// `LIST__TypeBehavior` is intended to be adopted by types that must fully represent and behave as EXPRESS `LIST` aggregations.
  /// It is primarily used for generic programming over EXPRESS collections, ensuring correct support for EXPRESS aggregation semantics.
  /// 
  /// - SeeAlso: `SDAI.LIST`, `SDAI.ListType`
  /// 
  public protocol LIST__TypeBehavior: SDAI.ListType
  where Element == ELEMENT,
        FundamentalType == SDAI.LIST<ELEMENT>,
        Value == FundamentalType.Value,
        SwiftType == FundamentalType.SwiftType
  {
    //MARK: SDAIDictionarySchema support
    static var uniqueFlag: SDAI.BOOLEAN {get}

    //MARK: Aggregation operator support
    func appendWith<U: SDAI.ListType>(rhs: U) -> SDAI.LIST<ELEMENT>?
    where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType

    func appendWith<U: SDAI.GenericType>(rhs: U) -> SDAI.LIST<ELEMENT>?
    where ELEMENT.FundamentalType == U.FundamentalType

    func prependWith<U: SDAI.GenericType>(lhs: U) -> SDAI.LIST<ELEMENT>?
    where ELEMENT.FundamentalType == U.FundamentalType

    func appendWith<U: SDAI.TypeHierarchy.GENERIC__TypeBehavior>(rhs: U) -> SDAI.LIST<ELEMENT>?

    func prependWith<U: SDAI.TypeHierarchy.GENERIC__TypeBehavior>(lhs: U) -> SDAI.LIST<ELEMENT>?

    func appendWith<U: SDAI.AggregationInitializer>(rhs: U) -> SDAI.LIST<ELEMENT>?
    where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType

    func prependWith<U: SDAI.AggregationInitializer>(lhs: U) -> SDAI.LIST<ELEMENT>?
    where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType
  }
}
public extension SDAI.TypeHierarchy.LIST__TypeBehavior
where ELEMENT: SDAI.Initializable.ByComplexEntity {
	func appendWith(rhs: SDAI.ComplexEntity) -> SDAI.LIST<ELEMENT>? {
		guard let rhs = ELEMENT(possiblyFrom: rhs) else { return nil }
		return self.appendWith(rhs: rhs)
	}
	func prependWith(lhs: SDAI.ComplexEntity) -> SDAI.LIST<ELEMENT>? {
		guard let lhs = ELEMENT(possiblyFrom: lhs) else { return nil }
		return self.prependWith(lhs: lhs)
	}
}

//public extension SDAI.TypeHierarchy.LIST__TypeBehavior
//where ELEMENT: SDAI.EntityReference {
//	func appendWith<U: SDAI.SelectType>(rhs: U) -> SDAI.LIST<ELEMENT>? {
//		guard let rhs = ELEMENT(possiblyFrom: rhs) else { return nil }
//		return self.appendWith(rhs: rhs)
//	}
//	func prependWith<T: SDAI.SelectType>(lhs: T) -> SDAI.LIST<ELEMENT>? {
//		guard let lhs = ELEMENT(possiblyFrom: lhs) else { return nil }
//		return self.prependWith(lhs: lhs)
//	}
//}
//public extension SDAI.TypeHierarchy.LIST__TypeBehavior 
//where ELEMENT: SDAI.PersistentReference {
//	func appendWith<U: SDAI.SelectType>(rhs: U) -> SDAI.LIST<ELEMENT>? {
//		guard let rhs = ELEMENT(possiblyFrom: rhs) else { return nil }
//		return self.appendWith(rhs: rhs)
//	}
//	func prependWith<T: SDAI.SelectType>(lhs: T) -> SDAI.LIST<ELEMENT>? {
//		guard let lhs = ELEMENT(possiblyFrom: lhs) else { return nil }
//		return self.prependWith(lhs: lhs)
//	}
//}


//MARK: - SDAI.LIST
extension SDAI {
	
  /// A concrete type representing the EXPRESS LIST aggregation in the SDAI system.
  ///
  /// The `LIST` type models an ordered, indexable, variable-size collection of elements of a uniform type, as defined by the EXPRESS data modeling language. It provides full support for EXPRESS aggregation semantics, including bounds, insertion and removal, and type conversions.
  ///
  /// - Type Parameter:
  ///   - ELEMENT: The type of elements contained within the list, conforming to `SDAI.GenericType`.
  ///
  /// ## Features
  /// - Index-based access and mutation, following EXPRESS 1-based indexing.
  /// - Initialization from Swift arrays, EXPRESS-compatible sources, and various literal types.
  /// - Conformance to `SDAI.ListType` and related protocols, supporting generic aggregation behaviors.
  /// - EXPRESS built-in procedures `insert(element:at:)` and `remove(at:)`.
  /// - Aggregation operators for combining and transforming lists.
  /// - Optional bounds, allowing for lists with or without upper limits on size.
  /// - Supports EXPRESS type conversions and selection from generic or select types.
  ///
  /// ## Usage
  /// Use `SDAI.LIST` where an ordered, express-compatible collection is required, particularly for EXPRESS `LIST` attributes, parameters, or variables.
  ///
  /// ## Example
  /// ```swift
  /// let numbers = SDAI.LIST<SDAI.INTEGER>(from: [1, 2, 3, 4], bound1: 1, bound2: 4)
  /// numbers.insert(element: 5, at: 5)
  /// let firstElement = numbers[1] // 1-based indexing
  /// ```
	public struct LIST<ELEMENT:SDAI.GenericType>: SDAI.TypeHierarchy.LIST__TypeBehavior
	{
		public typealias SwiftType = Array<ELEMENT>
		public typealias FundamentalType = Self
		
		fileprivate var rep: SwiftType
		private let bound1: Int
		private let bound2: Int?

		//MARK: Equatable \Hashable\SDAI.GenericType
		public static func == (lhs: SDAI.LIST<ELEMENT>, rhs: SDAI.LIST<ELEMENT>) -> Bool {
			return lhs.rep == rhs.rep &&
				lhs.bound1 == rhs.bound1 &&
				lhs.bound2 == rhs.bound2
		}
		
		//MARK: Hashable \SDAI.GenericType
		public func hash(into hasher: inout Hasher) {
			hasher.combine(rep)
			hasher.combine(bound1)
			hasher.combine(bound2)
		}

		//MARK: SDAI.GenericType
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

		public func arrayOptionalValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.ARRAY_OPTIONAL<ELEM>? {nil}
		public func arrayValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>? {nil}
		
		public func listValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.LIST<ELEM>? {
			if let value = self as? LIST<ELEM> { return value.copy() }
			return LIST<ELEM>(bound1: self.loBound, bound2: self.hiBound, [self]) { ELEM.convert(fromGeneric: $0.copy()) }
		}
		
		public func bagValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.BAG<ELEM>? {nil}
		public func setValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.SET<ELEM>? {nil}
		public func enumValue<ENUM:SDAI.EnumerationType>(enumType:ENUM.Type) -> ENUM? {nil}

		public static func validateWhereRules(
      instance:Self?,
      prefix:SDAIPopulationSchema.WhereLabel
    ) -> SDAIPopulationSchema.WhereRuleValidationRecords
    {
			return SDAI.validateAggregateElementsWhereRules(instance, prefix: prefix)
		}


		//MARK: SDAI.UnderlyingType
		public static var typeName: String { return "LIST" }
		public var asSwiftType: SwiftType { return self.copy().rep }
		
		//MARK: SDAI.GenericType
		public func copy() -> Self {
			return self
		}
		
		public var asFundamentalType: FundamentalType { return self.copy() }
		
		public init(fundamental: FundamentalType) {
			self.init(from: fundamental.asSwiftType, bound1: fundamental.loBound, bound2: fundamental.hiBound)
		}
		
		//MARK: Sequence \SDAI.AggregationType
		public func makeIterator() -> SwiftType.Iterator { return self.copy().rep.makeIterator() }

		//MARK: SDAI.AggregationType
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
			set{
				guard let index = index, index >= loIndex, index <= hiIndex else { return }
				guard let newValue = newValue else { return }
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
		
		//MARK: SDAI__LIST__type
		public static var uniqueFlag: BOOLEAN {false}
		
		//MARK: LIST specific
		public func map<T:SDAI.GenericType>(_ transform: (ELEMENT) -> T ) -> LIST<T> {
			let mapped = self.rep.map(transform)
			return LIST<T>(from:mapped, bound1:self.bound1, bound2:self.bound2)
		}
		
		private init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, S:Sequence>(bound1: I1, bound2: I2?, _ elements: [S], conv: (S.Element) -> ELEMENT? )
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
		
		
		//MARK: InitializableByGenerictype
		public init?<G: SDAI.GenericType>(fromGeneric generic: G?) {
			guard let fundamental = generic?.listValue(elementType: ELEMENT.self) else { return nil }
			self.init(fundamental: fundamental)
		}

		//MARK: InitializableByGenericList
		public init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.TypeHierarchy.LIST__TypeBehavior>(
			bound1: I1, bound2: I2?, generic listtype: T?)
		{
			guard let listtype = listtype else { return nil }
			self.init(bound1: bound1, bound2: bound2, [listtype]) { ELEMENT.convert(fromGeneric: $0) }
		}
		
		//MARK: InitializableByEmptyListLiteral
		public init<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible>(
			bound1: I1, bound2: I2?, _ emptyLiteral: SDAI.EmptyAggregateLiteral = SDAI.EMPTY_AGGREGATE)
		{
			self.init(from: SwiftType(), bound1: bound1, bound2: bound2)
		} 

		//MARK: InitializableBySwifttypeAsList
		public init<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible>(
			from swiftValue: SwiftType, bound1: I1, bound2: I2?)
		{
			self.bound1 = bound1.possiblyAsSwiftInt ?? 0
			self.bound2 = bound2?.possiblyAsSwiftInt
			self.rep = swiftValue
		}
		
		//MARK: SDAI.Initializable.BySelecttypeAsList
		public init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, S: SDAI.SelectType>(
			bound1: I1, bound2: I2?, _ select: S?)
		{
			guard let fundamental = Self.init(possiblyFrom: select) else { return nil }
			self.init(from: fundamental.asSwiftType, bound1:bound1, bound2:bound2)
		}

		//MARK: SDAI.Initializable.ByListLiteral
		public init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, E: SDAI.GenericType>(
			bound1: I1, bound2: I2?, _ elements: [SDAI.AggregationInitializerElement<E>])
		{
			self.init(bound1: bound1, bound2: bound2, elements){ ELEMENT.convert(fromGeneric: $0) }
		} 

		//MARK: Built-in procedure support
		public mutating func insert(element: ELEMENT, at position: Int) {
			assert(position >= 0)
			assert(position <= self.size)
			self.rep.insert(element, at: position)
		}
		
		public mutating func remove(at position: Int) {
			assert(position >= 1)
			assert(position <= self.size)
			self.rep.remove(at: position-1)
		}

		//MARK: Aggregation operator support
		//MARK: Union
		private func append<S: SDAI.AggregationSequence>(other: S) -> SwiftType
		where S.ELEMENT.FundamentalType == ELEMENT.FundamentalType {
			var result = self.rep
			result.append(contentsOf: other.asAggregationSequence.lazy.map{ ELEMENT.convert(from: $0.asFundamentalType) } )
			return result
		}

		private func prepend<S: SDAI.AggregationSequence>(other: S) -> SwiftType
		where S.ELEMENT.FundamentalType == ELEMENT.FundamentalType {
			var result = self.rep
			result.insert(contentsOf: other.asAggregationSequence.lazy.map{ ELEMENT.convert(from: $0.asFundamentalType) }, at: 0 )
			return result
		}


		public func appendWith<U: SDAI.ListType>(rhs: U) -> SDAI.LIST<ELEMENT>?
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			let result = self.append(other: rhs)
			return LIST(from: result, bound1: 0, bound2: _Infinity)
		}

		public func appendWith<U: SDAI.GenericType>(rhs: U) -> SDAI.LIST<ELEMENT>?
		where ELEMENT.FundamentalType == U.FundamentalType {
			var result = self.rep
			result.append(ELEMENT.convert(from: rhs.asFundamentalType))
			return LIST(from: result, bound1: 0, bound2: _Infinity)
		}

		public func prependWith<U: SDAI.GenericType>(lhs: U) -> SDAI.LIST<ELEMENT>?
		where ELEMENT.FundamentalType == U.FundamentalType {
			var result = self.rep
			result.insert(ELEMENT.convert(from: lhs.asFundamentalType), at: 0 )
			return LIST(from: result, bound1: 0, bound2: _Infinity)
		}

		public func appendWith<U: SDAI.TypeHierarchy.GENERIC__TypeBehavior>(rhs: U) -> SDAI.LIST<ELEMENT>? {
			if let rhs = rhs.listValue(elementType: ELEMENT.self) {
				return self.appendWith(rhs: rhs)
			}
			else if let rhs = ELEMENT.convert(fromGeneric: rhs) {
				return self.appendWith(rhs: rhs)
			}
			return nil
		}

		public func prependWith<U: SDAI.TypeHierarchy.GENERIC__TypeBehavior>(lhs: U) -> SDAI.LIST<ELEMENT>? {
			if let lhs = lhs.listValue(elementType: ELEMENT.self) {
				let result = self.prepend(other: lhs)
				return LIST(from: result, bound1: 0, bound2: _Infinity)
			}
			else if let lhs = ELEMENT.convert(fromGeneric: lhs) {
				return self.prependWith(lhs: lhs)
			}
			return nil
		}

		public func appendWith<U: SDAI.AggregationInitializer>(rhs: U) -> SDAI.LIST<ELEMENT>?
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			let result = self.append(other: rhs)
			return LIST(from: result, bound1: 0, bound2: _Infinity)
		}

		public func prependWith<U: SDAI.AggregationInitializer>(lhs: U) -> SDAI.LIST<ELEMENT>?
		where ELEMENT.FundamentalType == U.ELEMENT.FundamentalType {
			let result = self.prepend(other: lhs)
			return LIST(from: result, bound1: 0, bound2: _Infinity)
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
			self.init()
		}
		
    //MARK: InitializableByVoid

    /// Creates an empty `SDAI.LIST` with default bounds. (ISO 10303-22 10.19.4)
    ///
    /// This initializer constructs a new, empty list of the appropriate element type with bounds corresponding to a zero-length collection.
    ///
    /// Typically, the lower bound will be set to 0 or the default for the list type, and the upper bound will be `nil` (unbounded), depending on the implementation.
    ///
    /// Use this initializer when you need an empty EXPRESS `LIST` value, such as for default property values or when building up a list incrementally.
    ///
    /// ## Example
    /// ```swift
    /// let emptyList = SDAI.LIST<SDAI.INTEGER>()
    /// #expect(emptyList.isEmpty)
    /// ```
    ///
    /// - Note: This matches the EXPRESS built-in behavior for `LIST` instantiation.
    public init() {
      self.init(from: SwiftType())
    }
  }
}


extension SDAI.LIST: SDAI.FundamentalAggregationType{}

extension SDAI.LIST: SDAI.EntityReferenceYielding
where ELEMENT: SDAI.EntityReferenceYielding
{ }

extension SDAI.LIST: SDAI.DualModeReference
where ELEMENT: SDAI.DualModeReference
{
	public var pRef: SDAI.LIST<ELEMENT.PRef> {
		let converted = self.map{ $0.pRef }
		return converted
	}
}

//MARK: - for SDAI.PersistentReference ELEMENT
extension SDAI.LIST: SDAI.PersistentReference
where ELEMENT: SDAI.PersistentReference
{
	public var aRef: SDAI.LIST<ELEMENT.ARef> {
		let converted = self.map{ $0.aRef }
		return converted
	}

	public var optionalARef: SDAI.LIST<ELEMENT.ARef>? {
		let converted = self.compactMap{ $0.optionalARef }
		guard converted.count == self.size else { return nil }
		return SDAI.LIST(from: converted, bound1: self.bound1, bound2: self.bound2)
	}
}

//MARK: - for SDAI.Initializable.BySelectType ELEMENT
extension SDAI.LIST: SDAI.Initializable.BySelecttypeList
where ELEMENT: SDAI.Initializable.BySelectType
{	
	public init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.TypeHierarchy.LIST__TypeBehavior>(
		bound1: I1, bound2: I2?, _ listtype: T?)
	where T.ELEMENT: SDAI.SelectType
	{
		guard let listtype = listtype else { return nil }
		self.init(bound1: bound1, bound2: bound2, [listtype]){ ELEMENT.convert(sibling: $0) }
	}
}

//MARK: - for SDAI.Initializable.ByComplexEntity ELEMENT
extension SDAI.LIST: SDAI.Initializable.ByEntityList
where ELEMENT: SDAI.Initializable.ByComplexEntity
{
	public init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.TypeHierarchy.LIST__TypeBehavior>(
		bound1: I1, bound2: I2?, _ listtype: T?)
	where T.ELEMENT: SDAI.EntityReference
	{
		guard let listtype = listtype else { return nil }
		self.init(bound1: bound1, bound2: bound2, [listtype]) { 
			return ELEMENT.convert(sibling: $0) 
		}		
	}

	public init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.TypeHierarchy.LIST__TypeBehavior>(
		bound1: I1, bound2: I2?, _ listtype: T?)
	where T.ELEMENT: SDAI.PersistentReference,
	T.ELEMENT.ARef: SDAI.EntityReference
	{
		guard let listtype = listtype else { return nil }
		self.init(bound1: bound1, bound2: bound2, [listtype]) {
			return ELEMENT.convert(sibling: $0)
		}
	}


}

//MARK: - for SDAI.Initializable.ByDefinedType ELEMENT
extension SDAI.LIST: SDAI.Initializable.ByDefinedtypeList
where ELEMENT: SDAI.Initializable.ByDefinedType
{
	public init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, T: SDAI.TypeHierarchy.LIST__TypeBehavior>(
		bound1: I1, bound2: I2?, _ listtype: T?)
	where T.ELEMENT: SDAI.UnderlyingType
	{
		guard let listtype = listtype else { return nil }
		self.init(bound1:bound1, bound2:bound2, [listtype]) {
			return ELEMENT.convert(sibling: $0) 
		}
	}
}

