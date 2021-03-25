//
//  File.swift
//  
//
//  Created by Yoshida on 2020/09/10.
//

import Foundation

extension SDAI {
	public static func ABS<Number: SDAINumberType>(_ V: Number?) -> Number? {
		guard let v = V?.asSwiftType else { return nil }
		return Number( abs(v) )  
	}
	public static func ABS<Number: SDAISelectType>(_ V: Number?) -> SDAI.NUMBER? {
		return ABS(V?.numberValue)
	}
	
	public static func ACOS<Number: SwiftDoubleConvertible>(_ V: Number?) -> REAL? {
		guard let r = V?.asSwiftDouble else { return nil }
		return REAL( acos(r) )
	}
	
	public static func ASIN<Number: SwiftDoubleConvertible>(_ V: Number?) -> REAL? {
		guard let r = V?.asSwiftDouble else { return nil }
		return REAL( asin(r) )
	}
	
	public static func ATAN<Number1: SwiftDoubleConvertible, Number2: SwiftDoubleConvertible>
	(V1: Number1?, V2: Number2?) -> REAL? {
		guard let r1 = V1?.asSwiftDouble, let r2 = V2?.asSwiftDouble else { return nil }
		return REAL( atan2(r1, r2) )
	}
	
	public static func BLENGTH<Binary: SDAIBinaryType>(_ V:Binary?) -> INTEGER? {
		return INTEGER( V?.blength )
	}
	public static func BLENGTH<Binary: SDAISelectType>(_ V:Binary?) -> INTEGER? {
		return BLENGTH(V?.binaryValue)
	}
	
	public static func COS<Number: SwiftDoubleConvertible>(_ V: Number?) -> REAL? {
		guard let r = V?.asSwiftDouble else { return nil }
		return REAL( cos(r) )
	}
	
	public static func EXISTS<Generic: SDAIGenericType>(_ V: Generic?) -> BOOLEAN {
		return BOOLEAN( V != nil )
	}
	
	public static func EXP<Number: SwiftDoubleConvertible>(_ V: Number?) -> REAL? {
		guard let r = V?.asSwiftDouble else { return nil }
		return REAL( exp(r) )
	}

	
	public static func FORMAT<Number: SDAINumberType, Str: SwiftStringConvertible>(N: Number?, F: Str?) -> STRING? {
		guard let v = N?.asSwiftType else { return nil }
		//TODO: - to respect format command
		return STRING( String(describing: v) )			
	}
	public static func FORMAT<Number: SDAISelectType, Str: SwiftStringConvertible>(N: Number?, F: Str?) -> STRING? {
		if let intval = N?.integerValue { return FORMAT(N: intval, F: F) }
		return FORMAT(N: N?.numberValue, F: F)
	}

	
	public static func HIBOUND<Aggregate: SDAIAggregationBehavior>(_ V: Aggregate?) -> INTEGER? {
		return INTEGER(V?.aggregationHiBound)
	}
	
	public static func HIINDEX<Aggregate: SDAIAggregationBehavior>(_ V: Aggregate?) -> INTEGER? {
		return INTEGER(V?.aggregationHiIndex)
	}
	
	public static func LENGTH<Str: SwiftStringConvertible>(_ V: Str?) -> INTEGER? {
		return INTEGER(V?.possiblyAsSwiftString?.count)
	}
	
	public static func LOBOUND<Aggregate: SDAIAggregationBehavior>(_ V: Aggregate?) -> INTEGER? {
		return INTEGER(V?.aggregationLoBound)
	}
	
	public static func LOG<Number: SwiftDoubleConvertible>(_ V: Number?) -> REAL? {
		guard let r = V?.asSwiftDouble else { return nil }
		return REAL( log(r) )
	}
	
	public static func LOG2<Number: SwiftDoubleConvertible>(_ V: Number?) -> REAL? {
		guard let r = V?.asSwiftDouble else { return nil }
		return REAL( log(r)/log(2) )
	}
	
	public static func LOG10<Number: SwiftDoubleConvertible>(_ V: Number?) -> REAL? {
		guard let r = V?.asSwiftDouble else { return nil }
		return REAL( log10(r) )
	}
	
	public static func LOINDEX<Aggregate: SDAIAggregationBehavior>(_ V: Aggregate?) -> INTEGER? {
		return INTEGER(V?.aggregationLoIndex)
	}

	public static func NVL<GEN1: SDAIUnderlyingType>(V: GEN1?, SUBSTITUTE: GEN1.FundamentalType?) -> GEN1? {
		return V ?? GEN1(fundamental: UNWRAP(SUBSTITUTE))
	}
	public static func NVL<GEN1: SDAISimpleType>(V: GEN1?, SUBSTITUTE: GEN1.SwiftType?) -> GEN1? {
		return V ?? GEN1(UNWRAP(SUBSTITUTE))
	}
	public static func NVL<GEN1: SDAI.EntityReference>(V: GEN1?, SUBSTITUTE: SDAI.EntityReference?) -> GEN1? {
		return V ?? UNWRAP(GEN1.cast(from:SUBSTITUTE))
	}
	public static func NVL<GEN1: SDAI.EntityReference>(V: GEN1?, SUBSTITUTE: SDAI.ComplexEntity?) -> GEN1? {
		return V ?? UNWRAP(GEN1(complex: SUBSTITUTE))
	}
	public static func NVL<GEN1: SDAISelectType>(V: GEN1?, SUBSTITUTE: SDAI.ComplexEntity?) -> GEN1? {
		return V ?? UNWRAP(GEN1(possiblyFrom: SUBSTITUTE))
	}
	public static func NVL<GEN1: SDAISelectType, GEN2: SDAI.EntityReference>(V: GEN1?, SUBSTITUTE: GEN2?) -> GEN1? {
		return V ?? UNWRAP(GEN1(possiblyFrom: SUBSTITUTE))
	}
	public static func NVL<GEN1: SDAISelectType, GEN2: SDAIUnderlyingType>(V: GEN1?, SUBSTITUTE: GEN2?) -> GEN1? {
		return V ?? UNWRAP(GEN1(possiblyFrom: SUBSTITUTE))
	}
	public static func NVL<GEN1: SDAISelectType, GEN2: SDAISelectType>(V: GEN1?, SUBSTITUTE: GEN2?) -> GEN1? {
		return V ?? UNWRAP(GEN1(possiblyFrom: SUBSTITUTE))
	}
	
	public static func ODD<Integer: SwiftIntConvertible>(_ V: Integer?) -> LOGICAL {
		guard let i = V?.asSwiftInt else { return UNKNOWN }
		return LOGICAL( i % 2 == 1 )
	}
	
	public static func ROLESOF(_ V: EntityReference?) -> SET<STRING> {
		guard let complex = V?.complexEntity else { return SET<STRING>() }
		return SET<STRING>(from: complex.roles)
	}
	public static func ROLESOF<SEL:SDAISelectType>(_ V: SEL?) -> SET<STRING> {
		return ROLESOF(V?.entityReference)
	}
	
	public static func SIN<Number: SwiftDoubleConvertible>(_ V: Number?) -> REAL? {
		guard let r = V?.asSwiftDouble else { return nil }
		return REAL( sin(r) )
	}

	public static func SIZEOF<Aggregate: SDAIAggregationBehavior>(_ V: Aggregate?) -> INTEGER? {
		return INTEGER(V?.aggregationSize)
	}
	
	public static func SIZEOF<AI: SDAIAggregationInitializer>(_ V: AI?) -> INTEGER?
	{
		return INTEGER(  V?.reduce(0, {$0 + $1.count})  )
	}

	

	public static func SQRT<Number: SwiftDoubleConvertible>(_ V: Number?) -> REAL? {
		guard let r = V?.asSwiftDouble else { return nil }
		return REAL( sqrt(r) )
	}
	
	public static func TAN<Number: SwiftDoubleConvertible>(_ V: Number?) -> REAL? {
		guard let r = V?.asSwiftDouble else { return nil }
		return REAL( tan(r) )
	}
	
	public static func TYPEOF<Generic: SDAIGenericType>(_ V: Generic?) -> SET<STRING> {
		guard let v = V else { return SET<STRING>() }
		return SET<STRING>(from: v.typeMembers )
	}
	public static func TYPEOF<Generic: SDAIGenericType, T: SDAIGenericType>(_ V: Generic? , IS typename: T.Type) -> LOGICAL {
		guard let V = V else { return UNKNOWN }
		return LOGICAL( T(fromGeneric: V) != nil )
	}
	

	public static func USEDIN<GEN:SDAIGenericType>(T: GEN?) -> BAG<EntityReference>? {
		abstruct()
	}
	public static func USEDIN<GEN:SDAIGenericType, ENT:EntityReference, R:SDAIGenericType>(T: GEN?, ROLE: KeyPath<ENT,R>) -> BAG<ENT>? {
		abstruct()
	}
	public static func USEDIN<GEN:SDAIGenericType, ENT:EntityReference, R:SDAIGenericType>(T: GEN?, ROLE: KeyPath<ENT,R?>) -> BAG<ENT>? {
		abstruct()
	}
	
	public static func VALUE<Str: SwiftStringConvertible>(_ V: Str?) -> NUMBER? {
		guard let str = V?.possiblyAsSwiftString, let double = Double(str) else { return nil }
		return NUMBER(double)
	}
	
	public static func VALUE_IN<Aggregate: SDAIAggregationType, GEN1: SDAIGenericType>(C: Aggregate?, V: GEN1?) -> LOGICAL 
	where Aggregate.Element == Aggregate.ELEMENT?, Aggregate.ELEMENT: SDAIGenericType 
	{
		guard let C = C, let V = V else { return UNKNOWN }
		var isin = false
		for element in C {
			if let element = element {
				if element.value.isValueEqual(to: V.value) { isin = true }
			}
			else {
				assert(element == nil)
				return UNKNOWN
			}
		}
		return LOGICAL(isin)
	}
	public static func VALUE_IN<Aggregate: SDAIAggregationType, GEN1: SDAIGenericType>(C: Aggregate?, V: GEN1?) -> LOGICAL 
	where Aggregate.Element == Aggregate.ELEMENT, Aggregate.ELEMENT: SDAIGenericType {
		guard let C = C, let V = V else { return LOGICAL(nil) }
		for element in C {
			if element.value.isValueEqual(to: V.value) { return LOGICAL(true) }
		}
		return LOGICAL(false)
	}
	
	public static func VALUE_UNIQUE<Aggregate: SDAIAggregationType>(_ V: Aggregate?) -> LOGICAL 
	where Aggregate.Element == Aggregate.ELEMENT?, Aggregate.ELEMENT: SDAIGenericType 
	{
		guard let V = V, !V.contains(nil) else { return LOGICAL(nil) }
		let unique = Set( V.map{ $0!.value } )
		return LOGICAL(unique.count == V.size)
	}
	public static func VALUE_UNIQUE<Aggregate: SDAIAggregationType>(_ V: Aggregate?) -> LOGICAL 
	where Aggregate.Element == Aggregate.ELEMENT, Aggregate.ELEMENT: SDAIGenericType 
	{
		guard let V = V else { return LOGICAL(nil) }
		let unique = Set( V.map{ $0.value } )
		return LOGICAL(unique.count == V.size)
	}
}
