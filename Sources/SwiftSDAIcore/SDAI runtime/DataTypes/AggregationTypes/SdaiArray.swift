//
//  SdaiArray.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation


//MARK: - array type (8.2.1)
extension SDAI {
  /// A protocol representing an ARRAY aggregation type as defined in the SDAI standard (ISO 10303-11, 8.2.1).
  ///
  /// Conforming types must provide the necessary interfaces for aggregate behavior, indexing, type representation,
  /// and initialization from Swift types and array literals. This protocol is intended for types that represent
  /// fixed or variable-size collections of homogeneous values, with optional and uniqueness characteristics
  /// specified at the type level.
  ///
  /// - Conforms to:
  ///   - `SDAI.AggregationType`: Basic aggregation (collection) interface.
  ///   - `SDAI.AggregateIndexingSettable`: Allows mutation of elements by index.
  ///   - `SDAI.UnderlyingType`: Identifies the underlying fundamental type for the array.
  ///   - `SDAI.SwiftTypeRepresented`: Supports conversion to and from a native Swift representation.
  ///   - `SDAI.Initializable.BySwifttypeAsArray`: Can be initialized from a native Swift array type.
  ///   - `SDAI.Initializable.ByArrayLiteral`: Can be initialized using Swift array literals.
  ///   - `SDAI.Initializable.ByGenericArray`: Can be initialized from another generic array type.
  ///
  /// - SDAIDictionarySchema support:
  ///   - `uniqueFlag`: Indicates whether the aggregate enforces uniqueness of its elements.
  ///   - `optionalFlag`: Indicates whether the aggregate allows optional (absent) elements.
  public protocol ArrayType:
    SDAI.AggregationType, SDAI.AggregateIndexingSettable,
    SDAI.UnderlyingType, SDAI.SwiftTypeRepresented,
    SDAI.Initializable.BySwifttypeAsArray, SDAI.Initializable.ByArrayLiteral, SDAI.Initializable.ByGenericArray
  {
    // SDAIDictionarySchema support
    static var uniqueFlag: SDAI.BOOLEAN {get}
    static var optionalFlag: SDAI.BOOLEAN {get}
  }
}

extension SDAI.ArrayType {
  public var isCacheable: Bool {
    for elem in self.asAggregationSequence {
      if !elem.isCacheable { return false }
    }
    return true
  }
}


//MARK: - ARRAY type
extension SDAI.TypeHierarchy {
  /// A protocol representing the specialized behavior for the SDAI ARRAY aggregation type.
  /// 
  /// `ARRAY__TypeBehavior` refines the `SDAI.ArrayType` protocol by constraining its associated types
  /// to align with the generic `SDAI.ARRAY` structure. This ensures that conforming types have a
  /// well-defined element type, a matching fundamental collection type, and consistent value and Swift
  /// representation types. It is intended for use with types that model the ISO 10303-11 ARRAY concept,
  /// providing array semantics and aggregation behavior suitable for EXPRESS schemas.
  /// 
  /// - Requirements:
  ///   - The `Element` type must match the `ELEMENT` generic parameter.
  ///   - The `FundamentalType` must be `SDAI.ARRAY<ELEMENT>`.
  ///   - The `Value` and `SwiftType` associated types must be inherited from `FundamentalType`.
  ///
  /// - SeeAlso:
  ///   - `SDAI.ARRAY`
  ///   - `SDAI.ArrayType`
  ///   - [ISO 10303-11, 8.2.1 ARRAY aggregation type](https://www.steptools.com/stds/stp_aim/html/t_expgeneric_array.html)
  public protocol ARRAY__TypeBehavior: SDAI.ArrayType
  where Element == ELEMENT,
        FundamentalType == SDAI.ARRAY<ELEMENT>,
        Value == FundamentalType.Value,
        SwiftType == FundamentalType.SwiftType
  {}
}

//MARK: - SDAI.ARRAY
extension SDAI {
	
  /// A generic fixed-size or variable-size array type conforming to the SDAI (ISO 10303-11) ARRAY aggregation concept.
  ///
  /// The `ARRAY` structure provides storage for a collection of homogeneous elements with user-specified lower and upper bounds,
  /// and supports random access via integer indices. The bounds may be fixed or variable at runtime, and the element type must
  /// conform to `SDAI.GenericType`.
  ///
  /// - Generic Parameter:
  ///   - ELEMENT: The type of elements contained in the array. Must conform to `SDAI.GenericType`.
  ///
  /// - Aggregation Semantics:
  ///   - Indices run from a configurable lower bound (`bound1`) to upper bound (`bound2`), inclusive.
  ///   - The size of the array is `bound2 - bound1 + 1`.
  ///   - Implements value semantics and supports copy-on-write via struct copying.
  ///   - Conforms to protocols enabling conversion to and from Swift array types, array literals, and generic SDAI arrays.
  ///   - Provides interfaces for aggregate-specific behavior, such as querying, mapping, and membership testing.
  ///
  /// - Example Usage:
  ///   ```swift
  ///   let arr = SDAI.ARRAY<SDAI.INTEGER>(from: [1, 2, 3], bound1: 1, bound2: 3)
  ///   let value = arr[2] // Access element at index 2
  ///   ```
  ///
  /// - Standard References:
  ///   - ISO 10303-11: 8.2.1 ARRAY aggregation type
  ///
  /// - Conforms To:
  ///   - `SDAI.ARRAY__TypeBehavior`
  ///   - `Equatable`, `Hashable`
  ///   - `SDAI.GenericType` and related array/initialization protocols
  ///
  /// - SeeAlso:
  ///   - `SDAI.ArrayType`
  ///   - `SDAI.ARRAY_OPTIONAL`
  ///   - `SDAI.LIST`, `SDAI.BAG`, `SDAI.SET`
  ///   - [ISO 10303-11, 8.2.1](https://www.steptools.com/stds/stp_aim/html/t_expgeneric_array.html)
  public struct ARRAY<ELEMENT:SDAI.GenericType>: SDAI.TypeHierarchy.ARRAY__TypeBehavior
	{
		public typealias SwiftType = Array<ELEMENT>
		public typealias FundamentalType = Self
		
		fileprivate var rep: SwiftType
		private let bound1: Int
		private let bound2: Int

		// Equatable \Hashable\SDAI.GenericType
		public static func == (lhs: SDAI.ARRAY<ELEMENT>, rhs: SDAI.ARRAY<ELEMENT>) -> Bool {
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
		
		public func arrayOptionalValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.ARRAY_OPTIONAL<ELEM>? {
			return ARRAY_OPTIONAL<ELEM>(bound1: self.loIndex, bound2: self.hiIndex, [self]) {
				guard let conv = ELEM.convert(fromGeneric: $0) else { return (false,nil) }
				return (true, conv.copy())
			}
		}
		public func arrayValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>? {
			if let value = self as? ARRAY<ELEM> { return value.copy() }
			return ARRAY<ELEM>(bound1: self.loIndex, bound2: self.hiIndex, [self]) { ELEM.convert(fromGeneric: $0.copy()) }
		}
		
		public func listValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.LIST<ELEM>? {nil}
		public func bagValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.BAG<ELEM>? {nil}
		public func setValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.SET<ELEM>? {nil}
		public func enumValue<ENUM:SDAI.EnumerationType>(enumType:ENUM.Type) -> ENUM? {nil}

		public static func validateWhereRules(instance:Self?, prefix:SDAIPopulationSchema.WhereLabel) -> SDAIPopulationSchema.WhereRuleValidationRecords {
			return SDAI.validateAggregateElementsWhereRules(instance, prefix: prefix)
		}


		// SDAI.UnderlyingType \SDAI.AggregationType\SDAI__ARRAY_OPTIONAL__type\SDAI__ARRAY__type
		public static var typeName: String { return "ARRAY" }
		public var asSwiftType: SwiftType { return self.copy().rep }
		
		// SDAI.GenericType
		public func copy() -> Self {
			return self
		}
		
		public var asFundamentalType: FundamentalType { return self.copy() }
		
		public init(fundamental: FundamentalType) {
			self.init(from: fundamental.asSwiftType, bound1: fundamental.loIndex, bound2: fundamental.hiIndex)
		}
		
		// Sequence \SDAI.AggregationType
		public func makeIterator() -> SwiftType.Iterator { return self.copy().rep.makeIterator() }

		// SDAI.AggregationType
		public var hiBound: Int? { return bound2 }
		public var hiIndex: Int { return bound2 }
		public var loBound: Int { return bound1 }
		public var loIndex: Int { return bound1 }
		public var size: Int { return bound2 - bound1 + 1 }
		public var isEmpty: Bool { return size <= 0 }

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
		
		public func QUERY(logical_expression: (ELEMENT) -> LOGICAL ) -> ARRAY_OPTIONAL<ELEMENT> {
			let filtered = rep.map { (elem) -> ELEMENT? in
				if logical_expression(elem).isTRUE { return elem.copy() }
				else { return nil }
			}
			return ARRAY_OPTIONAL(from: filtered, bound1: self.loIndex ,bound2: self.hiIndex)
		}

		// SDAI.ArrayOptionalType
		public static var uniqueFlag: SDAI.BOOLEAN { false }
		public static var optionalFlag: SDAI.BOOLEAN { false }
	
		// ARRAY specific
		public func map<T:SDAI.GenericType>(_ transform: (ELEMENT) -> T ) -> ARRAY<T> {
			let mapped = self.rep.map(transform)
			return ARRAY<T>(from:mapped, bound1:self.bound1, bound2:self.bound2)
		}

		private init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, S:Sequence>(
			bound1: I1, bound2: I2,
			_ elements: [S], conv: (S.Element) -> ELEMENT? )
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
		public init?<G: SDAI.GenericType>(fromGeneric generic: G?) {
			guard let fundamental = generic?.arrayValue(elementType: ELEMENT.self) else { return nil }
			self.init(fundamental: fundamental)
		}

		// InitializableByGenericArray
    public init?<T: SDAI.TypeHierarchy.ARRAY__TypeBehavior>(generic arraytype: T?) {
			guard let arraytype = arraytype else { return nil }
			self.init(bound1: arraytype.loIndex, bound2: arraytype.hiIndex, [arraytype]) { ELEMENT.convert(fromGeneric: $0) }
		}
		
		
		// InitializableBySwifttypeAsArray
		public init<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible>(
			from swiftValue: SwiftType, bound1: I1, bound2: I2)
		{
			self.bound1 = bound1.asSwiftInt
			self.bound2 = bound2.asSwiftInt
			self.rep = swiftValue
			assert(rep.count == self.size)
		} 

		// SDAI.Initializable.ByArrayLiteral
		public init?<I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible, E:SDAI.GenericType>(
			bound1: I1, bound2: I2, _ elements: [SDAI.AggregationInitializerElement<E>])
		{
			self.init(bound1: bound1, bound2: bound2, elements){ ELEMENT.convert(fromGeneric: $0) }
		} 
		
		// InitializableByP21Parameter
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
				self.init(from: array, bound1: 1, bound2: array.count)
				
			case .rhsOccurrenceName(let rhsname):
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

extension SDAI.ARRAY: SDAI.FundamentalAggregationType {}

extension SDAI.ARRAY: SDAI.EntityReferenceYielding
where ELEMENT: SDAI.EntityReferenceYielding
{}


extension SDAI.ARRAY: SDAI.DualModeReference
where ELEMENT: SDAI.DualModeReference
{
	public var pRef: SDAI.ARRAY<ELEMENT.PRef> {
		let converted = self.map{ $0.pRef }
		return converted
	}
}

extension SDAI.ARRAY: SDAI.PersistentReference
where ELEMENT: SDAI.PersistentReference
{
	public var aRef: SDAI.ARRAY<ELEMENT.ARef> {
		let converted = self.map{ $0.aRef }
		return converted
	}

	public var optionalARef: SDAI.ARRAY<ELEMENT.ARef>? {
		let converted = self.compactMap{ $0.optionalARef }
		guard converted.count == self.size else { return nil }
		return SDAI.ARRAY(from: converted, bound1: self.bound1, bound2: self.bound2)
	}
}


extension SDAI.ARRAY: SDAI.Initializable.BySelecttypeArray
where ELEMENT: SDAI.Initializable.BySelectType
{
  public init?<T: SDAI.TypeHierarchy.ARRAY__TypeBehavior>(_ arraytype: T?)
	where T.ELEMENT: SDAI.SelectType
	{
		guard let arraytype = arraytype else { return nil }
		self.init(bound1: arraytype.loIndex, bound2: arraytype.hiIndex, [arraytype]){ ELEMENT.convert(sibling: $0) }
	}
}



extension SDAI.ARRAY: SDAI.Initializable.ByEntityArray
where ELEMENT: SDAI.Initializable.ByComplexEntity
{
  public init?<T: SDAI.TypeHierarchy.ARRAY__TypeBehavior>(_ arraytype: T?)
	where T.ELEMENT: SDAI.EntityReference
	{
		guard let arraytype = arraytype else { return nil }
		self.init(bound1: arraytype.loIndex, bound2: arraytype.hiIndex, [arraytype]) { 
				return ELEMENT.convert(sibling: $0) 
		}
	}		
}



extension SDAI.ARRAY: SDAI.Initializable.ByDefinedtypeArray
where ELEMENT: SDAI.Initializable.ByDefinedType
{
  public init?<T: SDAI.TypeHierarchy.ARRAY__TypeBehavior>(_ arraytype: T?)
	where T.ELEMENT: SDAI.UnderlyingType
	{
		guard let arraytype = arraytype else { return nil }
		self.init(bound1: arraytype.loIndex, bound2: arraytype.hiIndex, [arraytype]) { ELEMENT.convert(sibling: $0) }
	}
}


