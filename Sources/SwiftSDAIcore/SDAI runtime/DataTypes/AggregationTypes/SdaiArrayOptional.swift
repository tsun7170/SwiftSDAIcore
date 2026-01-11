//
//  SdaiArrayOptional.swift
//  
//
//  Created by Yoshida on 2020/09/22.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation



//MARK: - array optional type (8.2.1)
public protocol SDAIArrayOptionalType: SDAIArrayType, SDAI.InitializableByVoid
{}


//MARK: - ARRAY_OPTIONAL type
public protocol SDAI__ARRAY_OPTIONAL__type:
  SDAIArrayOptionalType, SDAI.InitializableByEmptyArrayLiteral, SDAI.InitializableByGenericArrayOptional
where Element == ELEMENT?,
			FundamentalType == SDAI.ARRAY_OPTIONAL<ELEMENT>,
			Value == FundamentalType.Value,
			SwiftType == FundamentalType.SwiftType
{}


//MARK: - SDAI.ARRAY_OPTIONAL
extension SDAI {
	
	public struct ARRAY_OPTIONAL<ELEMENT:SDAIGenericType>: SDAI__ARRAY_OPTIONAL__type
	{
		public typealias SwiftType = Array<ELEMENT?>
		public typealias FundamentalType = Self
		
		fileprivate var rep: SwiftType
		private var bound1: Int
		private var bound2: Int
		
		// Equatable \Hashable\SDAIGenericType
		public static func == (lhs: SDAI.ARRAY_OPTIONAL<ELEMENT>, rhs: SDAI.ARRAY_OPTIONAL<ELEMENT>) -> Bool {
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
			if let value = self as? ARRAY_OPTIONAL<ELEM> { return value.copy() }
			return ARRAY_OPTIONAL<ELEM>(bound1: self.loIndex, bound2: self.hiIndex, [self]) { 
					if( $0 == nil ) { return (true,nil) }
					guard let conv = ELEM.convert(fromGeneric: $0) else { return (false,nil) }
				return (true, conv.copy())
				}
		}
		
		public func arrayValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>? {nil}
		public func listValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.LIST<ELEM>? {nil}
		public func bagValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.BAG<ELEM>? {nil}
		public func setValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.SET<ELEM>? {nil}
		public func enumValue<ENUM:SDAIEnumerationType>(enumType:ENUM.Type) -> ENUM? {nil}

		public static func validateWhereRules(instance:Self?, prefix:SDAIPopulationSchema.WhereLabel) -> SDAIPopulationSchema.WhereRuleValidationRecords {
			return SDAI.validateAggregateElementsWhereRules(instance, prefix: prefix)
		}
		
		// SDAIUnderlyingType
		public static var typeName: String { return "ARRAY" }
		public var asSwiftType: SwiftType { return self.copy().rep }
		
		// SDAIGenericType
		public func copy() -> Self {
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

		// SDAIArrayOptionalType
		public static var uniqueFlag: SDAI.BOOLEAN { false }
		public static var optionalFlag: SDAI.BOOLEAN { true }
		
		// ARRAY_OPTIONAL specific
		public func map<T:SDAIGenericType>(_ transform: (ELEMENT?) -> T? ) -> ARRAY_OPTIONAL<T> {
			let mapped = self.rep.map { (elem) -> T? in
				if let elem = elem { return transform(elem) }
				else { return nil }
			}
			return ARRAY_OPTIONAL<T>(from:mapped, bound1:self.bound1, bound2:self.bound2)
		}

		internal init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, S:Sequence>(
			bound1: I1, bound2: I2,
			_ elements: [S], conv: (S.Element) -> (Bool,ELEMENT?) )
		{
			var swiftValue = SwiftType()
			if let b2 = bound2.possiblyAsSwiftInt, let b1 = bound1.possiblyAsSwiftInt {
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
		
		// InitializableByGenerictype
		public init?<G: SDAIGenericType>(fromGeneric generic: G?) {
			guard let fundamental = generic?.arrayOptionalValue(elementType: ELEMENT.self) else { return nil }
			self.init(fundamental: fundamental)
		}

		// InitializableByGenericArray
		public init?<T: SDAI__ARRAY__type>(generic arraytype: T?) {
			guard let arraytype = arraytype else { return nil }
			self.init(bound1: arraytype.loIndex, bound2: arraytype.hiIndex, [arraytype]){ 
				guard let conv = ELEMENT.convert(fromGeneric: $0) else { return (false,nil) }
				return (true, conv)				
			}
		} 

		// InitializableByGenericArrayOptional
		public init?<T: SDAI__ARRAY_OPTIONAL__type>(generic arraytype: T?) {
			guard let arraytype = arraytype else { return nil }
			self.init(bound1: arraytype.loIndex, bound2: arraytype.hiIndex, [arraytype]) { 
				if( $0 == nil ) { return (true,nil) }
				guard let conv = ELEMENT.convert(fromGeneric: $0) else { return (false,nil) }
				return (true, conv)
			}
		}
		
		
		// InitializableByEmptyArrayLiteral
		public init<I1: SwiftIntConvertible, I2: SwiftIntConvertible>(
			bound1: I1, bound2: I2, _ emptyLiteral: SDAI.EmptyAggregateLiteral = SDAI.EMPTY_AGGREGATE)
		{
			self.init(from: SwiftType(repeating: nil, count: bound2.asSwiftInt - bound1.asSwiftInt + 1), bound1: bound1, bound2: bound2)
		} 
		
		// InitializableBySwifttypeAsArray
		public init<I1: SwiftIntConvertible, I2: SwiftIntConvertible>(
			from swiftValue: SwiftType, bound1: I1, bound2: I2)
		{
			self.bound1 = bound1.asSwiftInt
			self.bound2 = bound2.asSwiftInt
			self.rep = swiftValue
			assert(rep.count == self.size)
		} 
		
		// InitializableByArrayLiteral
		public init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E: SDAIGenericType>(
			bound1: I1, bound2: I2, _ elements: [SDAI.AggregationInitializerElement<E>])
		{
			self.init(bound1: bound1, bound2: bound2, elements){
				if let elem = ELEMENT.convert(fromGeneric: $0){ return (true,elem) }
				else{ return (false,nil) }
			}
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
		
    // InitializableByVoid 
    public init() {
      self.init(bound1: 1, bound2: 1)
    }

  }
}



extension SDAI.ARRAY_OPTIONAL: SDAIFundamentalAggregationType {}

extension SDAI.ARRAY_OPTIONAL: SDAIEntityReferenceYielding
where ELEMENT: SDAIEntityReferenceYielding
{ }


extension SDAI.ARRAY_OPTIONAL: SDAIDualModeReference
where ELEMENT: SDAIDualModeReference
{
	public var pRef: SDAI.ARRAY_OPTIONAL<ELEMENT.PRef> {
		let converted = self.map{ $0?.pRef }
		return converted
	}
}

extension SDAI.ARRAY_OPTIONAL: SDAIPersistentReference
where ELEMENT: SDAIPersistentReference
{
	public var aRef: SDAI.ARRAY_OPTIONAL<ELEMENT.ARef> {
		let converted = self.map{ $0?.aRef }
		return converted
	}

	public var optionalARef: SDAI.ARRAY_OPTIONAL<ELEMENT.ARef>? {
		self.aRef
	}
}


extension SDAI.ARRAY_OPTIONAL: SDAI.InitializableBySelecttypeArrayOptional, SDAI.InitializableBySelecttypeArray
where ELEMENT: SDAI.InitializableBySelectType
{
	public init?<T: SDAI__ARRAY_OPTIONAL__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAISelectType
	{
		guard let arraytype = arraytype else { return nil }
		self.init(bound1: arraytype.loIndex, bound2: arraytype.hiIndex, [arraytype]){ 
			if( $0 == nil ) { return (true,nil) }
			guard let conv = ELEMENT.convert(sibling: $0) else { return (false,nil) }
			return (true, conv)
		}
	}
	
	public init?<T: SDAI__ARRAY__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAISelectType
	{
		guard let arraytype = arraytype else { return nil }
		self.init(bound1: arraytype.loIndex, bound2: arraytype.hiIndex, [arraytype]){ 
			guard let conv = ELEMENT.convert(sibling: $0) else { return (false,nil) }
			return (true, conv)
		}
	}
}



extension SDAI.ARRAY_OPTIONAL: SDAI.InitializableByEntityArrayOptional, SDAI.InitializableByEntityArray
where ELEMENT: SDAI.InitializableByComplexEntity
{
	public init?<T: SDAI__ARRAY_OPTIONAL__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAI.EntityReference
	{
		guard let arraytype = arraytype else { return nil }
		self.init(bound1: arraytype.loIndex, bound2: arraytype.hiIndex, [arraytype]) { 
			if( $0 == nil ) { return (true,nil) }
				guard let conv = ELEMENT.convert(sibling: $0) else { return (false,nil) }
			return (true, conv)
		}
	}
	
	public init?<T: SDAI__ARRAY__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAI.EntityReference
	{
		guard let arraytype = arraytype else { return nil }
		self.init(bound1: arraytype.loIndex, bound2: arraytype.hiIndex, [arraytype]) { 
			guard let conv = ELEMENT.convert(sibling: $0) else { return (false,nil) }
			return (true, conv)
		}
	}			
}



extension SDAI.ARRAY_OPTIONAL: SDAI.InitializableByDefinedtypeArrayOptional, SDAI.InitializableByDefinedtypeArray
where ELEMENT: SDAI.InitializableByDefinedType
{
	 public init?<T: SDAI__ARRAY_OPTIONAL__type>(_ arraytype: T?) 
	 where T.ELEMENT: SDAIUnderlyingType
	 {
		guard let arraytype = arraytype else { return nil }
		 self.init(bound1: arraytype.loIndex, bound2: arraytype.hiIndex, [arraytype]) { 
			if( $0 == nil ) { return (true,nil) }
			guard let conv = ELEMENT.convert(sibling: $0) else { return (false,nil) }
			return (true, conv)
		}
	 }
	
	public init?<T: SDAI__ARRAY__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAIUnderlyingType
	{
		guard let arraytype = arraytype else { return nil }
		self.init(bound1:arraytype.loIndex, bound2:arraytype.hiIndex, [arraytype]) { 
			guard let conv = ELEMENT.convert(sibling: $0) else { return (false,nil) }
			return (true, conv)
		}
	}
}


