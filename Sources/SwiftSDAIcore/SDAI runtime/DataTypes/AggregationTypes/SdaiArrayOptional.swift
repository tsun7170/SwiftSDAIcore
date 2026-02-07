//
//  SdaiArrayOptional.swift
//  
//
//  Created by Yoshida on 2020/09/22.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation



//MARK: - array optional type (8.2.1)
extension SDAI {
  /// A protocol representing the optional array type in the SDAI standard (ISO 10303-11, section 8.2.1).
  ///
  /// `ArrayOptionalType` is a protocol to be adopted by types that model an aggregate whose elements can be either the specified element type or nil.
  /// This corresponds to the EXPRESS `ARRAY [lo:hi] OF OPTIONAL Element` construct, where each element in the collection may be absent (`nil`).
  ///
  /// Types conforming to this protocol:
  /// - Must also conform to `SDAI.ArrayType` and support initialization by the void value (`SDAI.Initializable.ByVoid`).
  /// - Provide basic behaviors and conversions for handling EXPRESS optional array values in Swift.
  ///
  /// See also:
  /// - [ISO 10303-11:2004, Section 8.2.1 ARRAY data type](https://www.iso.org/standard/38046.html)
  /// - `SDAI.ARRAY_OPTIONAL`
  /// - `SDAI.ArrayType`
  /// - `SDAI.Initializable.ByVoid`
  ///
  public protocol ArrayOptionalType:
    SDAI.ArrayType,
    SDAI.Initializable.ByEmptyArrayLiteral, SDAI.Initializable.ByVoid
  {}
}


//MARK: - ARRAY_OPTIONAL type
extension SDAI.TypeHierarchy {
  /// A protocol describing the behavior required for types conforming to the EXPRESS `ARRAY [lo:hi] OF OPTIONAL Element` data type (`ARRAY_OPTIONAL` in the SDAI standard).
  ///
  /// Types conforming to `ARRAY_OPTIONAL__TypeBehavior`:
  /// - Represent an ordered collection (array) where each element may be either a value of the specified `ELEMENT` type or nil, matching the EXPRESS notion of an optional array element.
  /// - Must conform to `SDAI.ArrayOptionalType`, indicating support for optional elements, as well as array-specific behaviors.
  /// - Must be initializable by an empty array literal and by a generic array with optional elements, to allow for flexible creation and conversion among various aggregate types.
  /// - Provide type aliases aligning their element, fundamental, value, and Swift type representations with the underlying `SDAI.ARRAY_OPTIONAL` type.
  /// - Support aggregate operations and EXPRESS-compatible semantics for optional arrays, enabling EXPRESS-defined behaviors in Swift.
  ///
  /// This protocol is typically adopted by generic wrappers and aggregate types that need to exhibit EXPRESS-compliant optional array semantics, including initialization, copying, conversion, and value extraction.
  ///
  /// - SeeAlso:
  ///   - `SDAI.ARRAY_OPTIONAL`
  ///   - `SDAI.ArrayOptionalType`
  ///   - [ISO 10303-11:2004, Section 8.2.1 ARRAY data type](https://www.iso.org/standard/38046.html)
  ///
  public protocol ARRAY_OPTIONAL__TypeBehavior: SDAI.ArrayOptionalType
  where Element == ELEMENT?,
        FundamentalType == SDAI.ARRAY_OPTIONAL<ELEMENT>,
        Value == FundamentalType.Value,
        SwiftType == FundamentalType.SwiftType
  {}
}


//MARK: - SDAI.ARRAY_OPTIONAL
extension SDAI {
	
  /// A generic struct representing the `ARRAY [lo:hi] OF OPTIONAL Element` construct in the SDAI (ISO 10303-11) standard.
  ///
  /// `ARRAY_OPTIONAL` is used to describe collections where each element can either be a value of the specified `ELEMENT` type or be absent (i.e., `nil`). This enables modeling EXPRESS arrays of optional elements, where the bounds (`bound1`, `bound2`) define the index range, and each element within this range is optional.
  ///
  /// - Parameters:
  ///   - ELEMENT: The element type of the array, conforming to `SDAI.GenericType`.
  ///
  /// # Key Features
  /// - Conforms to `SDAI.ArrayOptionalType`, supporting initialization by the void value and empty array literals.
  /// - Provides indexed access to elements, including support for Swift-style subscripting and index bounds.
  /// - Supports aggregate behaviors such as mapping, filtering (QUERY), and copying.
  /// - Enables EXPRESS-compatible conversions and initialization from generic types, select types, entity arrays, and more.
  /// - Integrates with P21 (STEP Physical File) decoding, including construction from P21 parameters and exchange structures.
  /// - Complies with the semantics of EXPRESS ARRAY where elements may be individually omitted (nil).
  ///
  /// # EXPRESS Reference
  /// - [ISO 10303-11:2004, Section 8.2.1 ARRAY data type](https://www.iso.org/standard/38046.html)
  ///
  /// # Example
  /// ```swift
  /// let arr = SDAI.ARRAY_OPTIONAL<MyType>(bound1: 1, bound2: 5, [nil, value1, value2, nil, value3])
  /// let firstElement = arr[1] // May be nil or a value of MyType
  /// ```
  ///
  /// - SeeAlso:
  ///   - `SDAI.ArrayOptionalType`
  ///   - `SDAI.ArrayType`
  ///   - `SDAI.Initializable.ByVoid`
  ///
  public struct ARRAY_OPTIONAL<ELEMENT:SDAI.GenericType>: SDAI.TypeHierarchy.ARRAY_OPTIONAL__TypeBehavior
	{
		public typealias SwiftType = Array<ELEMENT?>
		public typealias FundamentalType = Self
		
		fileprivate var rep: SwiftType
		private let bound1: Int
		private let bound2: Int

		//MARK: Equatable \Hashable\SDAI.GenericType
		public static func == (lhs: SDAI.ARRAY_OPTIONAL<ELEMENT>, rhs: SDAI.ARRAY_OPTIONAL<ELEMENT>) -> Bool {
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
		
		public func arrayOptionalValue<ELEM>(
      elementType:ELEM.Type) -> SDAI.ARRAY_OPTIONAL<ELEM>?
    where ELEM:SDAI.GenericType
    {
			if let value = self as? ARRAY_OPTIONAL<ELEM> { return value.copy() }

			return ARRAY_OPTIONAL<ELEM>(
        bound1: self.loIndex, bound2: self.hiIndex, [self]) {
					if( $0 == nil ) { return (true,nil) }

					guard let conv = ELEM.convert(fromGeneric: $0)
          else { return (false,nil) }

				return (true, conv.copy())
				}
		}
		
		public func arrayValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>? {nil}
		public func listValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.LIST<ELEM>? {nil}
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
		public static var typeName: String { return "ARRAY" }
		public var asSwiftType: SwiftType { return self.copy().rep }
		
		//MARK: SDAI.GenericType
		public func copy() -> Self {
			return self
		}
		
		public var asFundamentalType: FundamentalType { return self.copy() }
		
		public init(fundamental: FundamentalType) {
			self.init(from: fundamental.asSwiftType, bound1: fundamental.loIndex, bound2: fundamental.hiIndex)
		}
		
		//MARK: Sequence \SDAI.AggregationType
		public func makeIterator() -> SwiftType.Iterator { return self.copy().rep.makeIterator() }

		//MARK: SDAI.AggregationType
		public var hiBound: Int? { return bound2 }
		public var hiIndex: Int { return bound2 }
		public var loBound: Int { return bound1 }
		public var loIndex: Int { return bound1 }
		public var size: Int { return bound2 - bound1 + 1 }
		public var isEmpty: Bool { return size <= 0 }

		public subscript(index: Int?) -> ELEMENT? {
			get{
				guard let index = index, index >= loIndex, index <= hiIndex else { return nil }
				return rep[index - loIndex]?.copy()
			}
			set{
				guard let index = index, index >= loIndex, index <= hiIndex else { return }
				rep[index - loIndex] = newValue
			}
		}
		
		public var asAggregationSequence: AnySequence<ELEMENT> { return AnySequence(rep.lazy.compactMap{$0?.copy()}) }

		public func CONTAINS(elem: ELEMENT?) -> SDAI.LOGICAL {
			guard let elem = elem else { return UNKNOWN }
			return LOGICAL(rep.contains(elem))
		}
		
		public func QUERY(logical_expression: (ELEMENT) -> LOGICAL ) -> ARRAY_OPTIONAL<ELEMENT> {
			let filtered = rep.map { (elem) -> ELEMENT? in
				guard let elem = elem else { return nil }
				if logical_expression(elem).isTRUE { return elem.copy() }
				else { return nil }
			}
			return ARRAY_OPTIONAL(from: filtered, bound1: self.loIndex ,bound2: self.hiIndex)
		}

		//MARK: SDAI.ArrayOptionalType
		public static var uniqueFlag: SDAI.BOOLEAN { false }
		public static var optionalFlag: SDAI.BOOLEAN { true }
		
		//MARK: ARRAY_OPTIONAL specific
		public func map<T:SDAI.GenericType>(_ transform: (ELEMENT?) -> T? ) -> ARRAY_OPTIONAL<T> {
			let mapped = self.rep.map { (elem) -> T? in
				if let elem = elem { return transform(elem) }
				else { return nil }
			}
			return ARRAY_OPTIONAL<T>(from:mapped, bound1:self.bound1, bound2:self.bound2)
		}

		internal init?<I1, I2, S>(
			bound1: I1, bound2: I2?,
			_ elements: [S], conv: (S.Element) -> (Bool,ELEMENT?) )
    where
    I1: SDAI.SwiftIntConvertible,
    I2: SDAI.SwiftIntConvertible,
    S: Sequence
		{
			var swiftValue = SwiftType()
			if let b2 = bound2?.possiblyAsSwiftInt, let b1 = bound1.possiblyAsSwiftInt {
				swiftValue.reserveCapacity(b2 - b1 + 1)
			}
			for aie in elements {
				for elem in aie {
					let (good,converted) = conv(elem)
					if good { swiftValue.append( converted ) }
					else { return nil }
				}
			}
			self.init(from: swiftValue, bound1: bound1, bound2: bound2)
		}
		
		//MARK: InitializableByGenerictype
		public init?<G: SDAI.GenericType>(fromGeneric generic: G?) {
			guard let fundamental = generic?.arrayOptionalValue(elementType: ELEMENT.self) else { return nil }
			self.init(fundamental: fundamental)
		}

		//MARK: InitializableByGenericArray
    public init?<I1, I2, T>(
      bound1: I1, bound2: I2?, generic arraytype: T?)
    where
    I1: SDAI.SwiftIntConvertible,
    I2: SDAI.SwiftIntConvertible,
    T: SDAI.TypeHierarchy.ARRAY__TypeBehavior
    {
      guard let arraytype = arraytype else { return nil }
      let hiIndex = bound1.asSwiftInt + arraytype.size - 1
      if let bound2, bound2.asSwiftInt != hiIndex {
        SDAI.raiseErrorAndContinue(.VA_NVLD, detail: "inconsistent bound2(\(bound2.asSwiftInt)) specified. should be (\(hiIndex)) from the source arraytype value.")
      }

      self.init(bound1: bound1, bound2: hiIndex, [arraytype]){
        guard let conv = ELEMENT.convert(fromGeneric: $0) else { return (false,nil) }
        return (true, conv)
      }
    }


		//MARK: InitializableByGenericArrayOptional
      public init?<I1, I2, T>(
        bound1: I1, bound2: I2?, generic arraytype: T?)
      where
      I1: SDAI.SwiftIntConvertible,
      I2: SDAI.SwiftIntConvertible,
      T: SDAI.TypeHierarchy.ARRAY_OPTIONAL__TypeBehavior
      {
        guard let arraytype = arraytype else { return nil }
        let hiIndex = bound1.asSwiftInt + arraytype.size - 1
        if let bound2, bound2.asSwiftInt != hiIndex {
          SDAI.raiseErrorAndContinue(.VA_NVLD, detail: "inconsistent bound2(\(bound2.asSwiftInt)) specified. should be (\(hiIndex)) from the source arraytype value.")
        }

        self.init(bound1: bound1, bound2: hiIndex, [arraytype]){
          guard let conv = ELEMENT.convert(fromGeneric: $0) else { return (false,nil) }
          return (true, conv)
        }
      }


		
		//MARK: InitializableByEmptyArrayLiteral
		public init<I1, I2>(
			bound1: I1, bound2: I2,
      _ emptyLiteral: SDAI.EmptyAggregateLiteral = SDAI.EMPTY_AGGREGATE)
    where
    I1: SDAI.SwiftIntConvertible,
    I2: SDAI.SwiftIntConvertible
		{
			self.init(from: SwiftType(repeating: nil, count: bound2.asSwiftInt - bound1.asSwiftInt + 1), bound1: bound1, bound2: bound2)
		} 
		
		//MARK: InitializableBySwifttypeAsArray
		public init<I1, I2>(
			from swiftValue: SwiftType, bound1: I1, bound2: I2?)
    where I1: SDAI.SwiftIntConvertible, I2: SDAI.SwiftIntConvertible
    {
      let b1 = bound1.asSwiftInt
      self.bound1 = b1

      let b2:Int
      if let bound2 {
        b2 = bound2.asSwiftInt
      }
      else {
        b2 = swiftValue.count + b1 - 1
      }
      self.bound2 = b2

      self.rep = swiftValue
      assert(rep.count == self.size)
    }

		//MARK: SDAI.Initializable.ByArrayLiteral
		public init?<I1, I2, E>(
			bound1: I1, bound2: I2?, _ elements: [SDAI.AggregationInitializerElement<E>])
    where
    I1: SDAI.SwiftIntConvertible,
    I2: SDAI.SwiftIntConvertible,
    E: SDAI.GenericType
		{
			self.init(bound1: bound1, bound2: bound2, elements){
				if let elem = ELEMENT.convert(fromGeneric: $0){ return (true,elem) }
				else{ return (false,nil) }
			}
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
					let elem = ELEMENT(p21param: param, from: exchangeStructure)
					guard exchangeStructure.error == nil else { exchangeStructure.add(errorContext: "while resolving \(Self.bareTypeName) element value"); return nil }
					array.append(elem)
				}
				self.init(from: array, bound1: 1, bound2: array.count)
				
			case .rhsOccurrenceName(let rhsname):
				switch rhsname {
				case .constantValueName(let name):
					guard let generic = exchangeStructure.resolve(constantValueName: name) else {exchangeStructure.add(errorContext: "while resolving \(Self.bareTypeName) value"); return nil }
					guard let arrayValue = generic.arrayOptionalValue(elementType: ELEMENT.self) else { exchangeStructure.error = "constant value(\(name): \(generic)) is not compatible with \(Self.bareTypeName)[\(ELEMENT.self)]"; return nil }
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

		public init(p21omittedParamfrom exchangeStructure: P21Decode.ExchangeStructure) {
			self.init()
		}
		
    //MARK: InitializableByVoid
    public init() {
      self.init(bound1: 1, bound2: 1)
    }

  }
}



extension SDAI.ARRAY_OPTIONAL: SDAI.FundamentalAggregationType {}

extension SDAI.ARRAY_OPTIONAL: SDAI.EntityReferenceYielding
where ELEMENT: SDAI.EntityReferenceYielding
{ }


//MARK: - for SDAI.DualModeReference ELEMENT
extension SDAI.ARRAY_OPTIONAL: SDAI.DualModeReference
where ELEMENT: SDAI.DualModeReference
{
	public var pRef: SDAI.ARRAY_OPTIONAL<ELEMENT.PRef> {
		let converted = self.map{ $0?.pRef }
		return converted
	}
}

//MARK: - for SDAI.PersistentReference ELEMENT
extension SDAI.ARRAY_OPTIONAL: SDAI.PersistentReference
where ELEMENT: SDAI.PersistentReference
{
	public var aRef: SDAI.ARRAY_OPTIONAL<ELEMENT.ARef> {
		let converted = self.map{ $0?.aRef }
		return converted
	}

	public var optionalARef: SDAI.ARRAY_OPTIONAL<ELEMENT.ARef>? {
		self.aRef
	}
}


//MARK: - for SDAI.Initializable.BySelectType ELEMENT
extension SDAI.ARRAY_OPTIONAL: SDAI.Initializable.BySelecttypeArrayOptional, SDAI.Initializable.BySelecttypeArray
where ELEMENT: SDAI.Initializable.BySelectType
{
  public init?<I1, I2, T>(
    bound1: I1, bound2: I2?, _ arraytype: T?)
  where
  I1: SDAI.SwiftIntConvertible,
  I2: SDAI.SwiftIntConvertible,
  T: SDAI.TypeHierarchy.ARRAY_OPTIONAL__TypeBehavior,
  T.ELEMENT: SDAI.SelectType
  {
    guard let arraytype = arraytype else { return nil }
    let hiIndex = bound1.asSwiftInt + arraytype.size - 1
    if let bound2, bound2.asSwiftInt != hiIndex {
      SDAI.raiseErrorAndContinue(.VA_NVLD, detail: "inconsistent bound2(\(bound2.asSwiftInt)) specified. should be (\(hiIndex)) from the source arraytype value.")
    }

    self.init(bound1: bound1, bound2: hiIndex, [arraytype]){
      if( $0 == nil ) { return (true,nil) }
      guard let conv = ELEMENT.convert(sibling: $0) else { return (false,nil) }
      return (true, conv)
    }
  }



  public init?<I1, I2, T>(
    bound1: I1, bound2: I2?, _ arraytype: T?)
  where
  I1: SDAI.SwiftIntConvertible,
  I2: SDAI.SwiftIntConvertible,
  T: SDAI.TypeHierarchy.ARRAY__TypeBehavior,
  T.ELEMENT: SDAI.SelectType
  {
    guard let arraytype = arraytype else { return nil }
    let hiIndex = bound1.asSwiftInt + arraytype.size - 1
    if let bound2, bound2.asSwiftInt != hiIndex {
      SDAI.raiseErrorAndContinue(.VA_NVLD, detail: "inconsistent bound2(\(bound2.asSwiftInt)) specified. should be (\(hiIndex)) from the source arraytype value.")
    }

    self.init(bound1: bound1, bound2: hiIndex, [arraytype]){
      guard let conv = ELEMENT.convert(sibling: $0) else { return (false,nil) }
      return (true, conv)
    }
  }

}



//MARK: - for SDAI.Initializable.ByComplexEntity ELEMENT
extension SDAI.ARRAY_OPTIONAL: SDAI.Initializable.ByEntityArrayOptional, SDAI.Initializable.ByEntityArray
where ELEMENT: SDAI.Initializable.ByComplexEntity
{
  public init?<I1, I2, T>(
    bound1: I1, bound2: I2?, _ arraytype: T?)
  where
  I1: SDAI.SwiftIntConvertible,
  I2: SDAI.SwiftIntConvertible,
  T: SDAI.TypeHierarchy.ARRAY_OPTIONAL__TypeBehavior,
  T.ELEMENT: SDAI.EntityReference
  {
    guard let arraytype = arraytype else { return nil }
    let hiIndex = bound1.asSwiftInt + arraytype.size - 1
    if let bound2, bound2.asSwiftInt != hiIndex {
      SDAI.raiseErrorAndContinue(.VA_NVLD, detail: "inconsistent bound2(\(bound2.asSwiftInt)) specified. should be (\(hiIndex)) from the source arraytype value.")
    }

    self.init(bound1: bound1, bound2: hiIndex, [arraytype]) {
      if( $0 == nil ) { return (true,nil) }
      guard let conv = ELEMENT.convert(sibling: $0) else { return (false,nil) }
      return (true, conv)
    }
  }

  public init?<I1, I2, T>(
    bound1: I1, bound2: I2?, _ arraytype: T?)
  where
  I1: SDAI.SwiftIntConvertible,
  I2: SDAI.SwiftIntConvertible,
  T: SDAI.TypeHierarchy.ARRAY_OPTIONAL__TypeBehavior,
  T.ELEMENT: SDAI.PersistentReference,
  T.ELEMENT.ARef: SDAI.EntityReference
  {
    guard let arraytype = arraytype else { return nil }
    let hiIndex = bound1.asSwiftInt + arraytype.size - 1
    if let bound2, bound2.asSwiftInt != hiIndex {
      SDAI.raiseErrorAndContinue(.VA_NVLD, detail: "inconsistent bound2(\(bound2.asSwiftInt)) specified. should be (\(hiIndex)) from the source arraytype value.")
    }

    self.init(bound1: bound1, bound2: hiIndex, [arraytype]) {
      if( $0 == nil ) { return (true,nil) }
      guard let conv = ELEMENT.convert(sibling: $0) else { return (false,nil) }
      return (true, conv)
    }
  }





  public init?<I1, I2, T>(
    bound1: I1, bound2: I2?, _ arraytype: T?)
  where
  I1: SDAI.SwiftIntConvertible,
  I2: SDAI.SwiftIntConvertible,
  T: SDAI.TypeHierarchy.ARRAY__TypeBehavior,
  T.ELEMENT: SDAI.EntityReference
  {
    guard let arraytype = arraytype else { return nil }
    let hiIndex = bound1.asSwiftInt + arraytype.size - 1
    if let bound2, bound2.asSwiftInt != hiIndex {
      SDAI.raiseErrorAndContinue(.VA_NVLD, detail: "inconsistent bound2(\(bound2.asSwiftInt)) specified. should be (\(hiIndex)) from the source arraytype value.")
    }

    self.init(bound1: bound1, bound2: hiIndex, [arraytype]) {
      guard let conv = ELEMENT.convert(sibling: $0) else { return (false,nil) }
      return (true, conv)
    }
  }

  public init?<I1, I2, T>(
    bound1: I1, bound2: I2?, _ arraytype: T?)
  where
  I1: SDAI.SwiftIntConvertible,
  I2: SDAI.SwiftIntConvertible,
  T: SDAI.TypeHierarchy.ARRAY__TypeBehavior,
  T.ELEMENT: SDAI.PersistentReference,
  T.ELEMENT.ARef: SDAI.EntityReference
  {
    guard let arraytype = arraytype else { return nil }
    let hiIndex = bound1.asSwiftInt + arraytype.size - 1
    if let bound2, bound2.asSwiftInt != hiIndex {
      SDAI.raiseErrorAndContinue(.VA_NVLD, detail: "inconsistent bound2(\(bound2.asSwiftInt)) specified. should be (\(hiIndex)) from the source arraytype value.")
    }

    self.init(bound1: bound1, bound2: hiIndex, [arraytype]) {
      guard let conv = ELEMENT.convert(sibling: $0) else { return (false,nil) }
      return (true, conv)
    }
  }

}



//MARK: - for SDAI.Initializable.ByDefinedType ELEMENT
extension SDAI.ARRAY_OPTIONAL: SDAI.Initializable.ByDefinedtypeArrayOptional, SDAI.Initializable.ByDefinedtypeArray
where ELEMENT: SDAI.Initializable.ByDefinedType
{
  public init?<I1, I2, T>(bound1: I1, bound2: I2?, _ arraytype: T?)
  where
  I1: SDAI.SwiftIntConvertible,
  I2: SDAI.SwiftIntConvertible,
  T: SDAI.TypeHierarchy.ARRAY_OPTIONAL__TypeBehavior,
  T.ELEMENT: SDAI.UnderlyingType
  {
    guard let arraytype = arraytype else { return nil }
    let hiIndex = bound1.asSwiftInt + arraytype.size - 1
    if let bound2, bound2.asSwiftInt != hiIndex {
      SDAI.raiseErrorAndContinue(.VA_NVLD, detail: "inconsistent bound2(\(bound2.asSwiftInt)) specified. should be (\(hiIndex)) from the source arraytype value.")
    }

    self.init(bound1: bound1, bound2: hiIndex, [arraytype]) {
      if( $0 == nil ) { return (true,nil) }
      guard let conv = ELEMENT.convert(sibling: $0) else { return (false,nil) }
      return (true, conv)
    }
  }


  public init?<I1, I2, T>(bound1: I1, bound2: I2?, _ arraytype: T?)
  where
  I1: SDAI.SwiftIntConvertible,
  I2: SDAI.SwiftIntConvertible,
  T: SDAI.TypeHierarchy.ARRAY__TypeBehavior,
  T.ELEMENT: SDAI.UnderlyingType
  {
    guard let arraytype = arraytype else { return nil }
    let hiIndex = bound1.asSwiftInt + arraytype.size - 1
    if let bound2, bound2.asSwiftInt != hiIndex {
      SDAI.raiseErrorAndContinue(.VA_NVLD, detail: "inconsistent bound2(\(bound2.asSwiftInt)) specified. should be (\(hiIndex)) from the source arraytype value.")
    }

    self.init(bound1:bound1, bound2:hiIndex, [arraytype]) {
      guard let conv = ELEMENT.convert(sibling: $0) else { return (false,nil) }
      return (true, conv)
    }
  }

}


