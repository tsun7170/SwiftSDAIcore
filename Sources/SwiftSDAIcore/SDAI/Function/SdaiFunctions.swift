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

	public static func FORMAT<Number: SDAINumberType, Str: SDAIStringType>(N: Number?, F: Str?) -> STRING? {
		guard let v = N?.asSwiftType else { return nil }
		//TODO: - to respect format command
		return STRING( String(describing: v) )			
	}
	
	public static func HIBOUND<Aggregate: SDAIAggregationType>(_ V: Aggregate?) -> INTEGER? {
		return INTEGER(V?.hiBound)
	}
	
	public static func HIINDEX<Aggregate: SDAIAggregationType>(_ V: Aggregate?) -> INTEGER? {
		return INTEGER(V?.hiIndex)
	}
	
	public static func LENGTH<Str: SDAIStringType>(_ V: Str?) -> INTEGER? {
		return INTEGER(V?.length)
	}
	
	public static func LOBOUND<Aggregate: SDAIAggregationType>(_ V: Aggregate?) -> INTEGER? {
		return INTEGER(V?.loBound)
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
	
	public static func LOINDEX<Aggregate: SDAIAggregationType>(_ V: Aggregate?) -> INTEGER? {
		return INTEGER(V?.loIndex)
	}

//	public static func NVL<GEN1: SDAIGenericType>(V: GEN1?, SUBSTITUTE: GEN1?) -> GEN1? {
//		return V ?? SUBSTITUTE!
//	}
	public static func NVL<GEN1: SDAIUnderlyingType>(V: GEN1?, SUBSTITUTE: GEN1.FundamentalType?) -> GEN1? {
		return V ?? GEN1(fundamental: SUBSTITUTE!)
	}
	public static func NVL<GEN1: SDAISimpleType>(V: GEN1?, SUBSTITUTE: GEN1.SwiftType?) -> GEN1? {
		return V ?? GEN1(SUBSTITUTE!)
	}
	public static func NVL<GEN1: SDAI.EntityReference>(V: GEN1?, SUBSTITUTE: SDAI.EntityReference?) -> GEN1? {
		return V ?? GEN1.cast(from:SUBSTITUTE)!
	}
	public static func NVL<GEN1: SDAI.EntityReference>(V: GEN1?, SUBSTITUTE: SDAI.ComplexEntity?) -> GEN1? {
		return V ?? GEN1(complex: SUBSTITUTE)!
	}
	public static func NVL<GEN1: SDAISelectType>(V: GEN1?, SUBSTITUTE: SDAI.ComplexEntity?) -> GEN1? {
		return V ?? GEN1(possiblyFrom: SUBSTITUTE)!
	}
	public static func NVL<GEN1: SDAISelectType, GEN2: SDAI.EntityReference>(V: GEN1?, SUBSTITUTE: GEN2?) -> GEN1? {
		return V ?? GEN1(possiblyFrom: SUBSTITUTE)!
	}
	public static func NVL<GEN1: SDAISelectType, GEN2: SDAIUnderlyingType>(V: GEN1?, SUBSTITUTE: GEN2?) -> GEN1? {
		return V ?? GEN1(possiblyFrom: SUBSTITUTE)!
	}
	public static func NVL<GEN1: SDAISelectType, GEN2: SDAISelectType>(V: GEN1?, SUBSTITUTE: GEN2?) -> GEN1? {
		return V ?? GEN1(possiblyFrom: SUBSTITUTE)!
	}
	
	public static func ODD<Integer: SwiftIntConvertible>(_ V: Integer?) -> LOGICAL {
		guard let i = V?.asSwiftInt else { return LOGICAL(nil) }
		return LOGICAL( i % 2 == 1 )
	}
	
	public static func ROLESOF(_ V: EntityReference?) -> SET<STRING>? {
		guard let complex = V?.complexEntity else { return SET<STRING>() }
		return SET<STRING>(from: complex.roles)
	}
	
	public static func SIN<Number: SwiftDoubleConvertible>(_ V: Number?) -> REAL? {
		guard let r = V?.asSwiftDouble else { return nil }
		return REAL( sin(r) )
	}

	public static func SIZEOF<Aggregate: SDAIAggregationType>(_ V: Aggregate?) -> INTEGER? {
		return INTEGER(V?.size)
	}
	
	public static func SIZEOF<AIE: SDAI__AIE__type>(_ V: [AIE]) -> INTEGER? {
		return INTEGER(  V.reduce(0, {$0 + $1.count})  )
	}
	
//	public static func SIZEOF<Select: SDAISelectType>(_ V: Select?) -> INTEGER? {
//		return INTEGER( V?.sizeOfAggregation )
//	}
	

	public static func SQRT<Number: SwiftDoubleConvertible>(_ V: Number?) -> REAL? {
		guard let r = V?.asSwiftDouble else { return nil }
		return REAL( sqrt(r) )
	}
	
	public static func TAN<Number: SwiftDoubleConvertible>(_ V: Number?) -> REAL? {
		guard let r = V?.asSwiftDouble else { return nil }
		return REAL( tan(r) )
	}
	
	public static func TYPEOF<Generic: SDAIGenericType>(_ V: Generic?) -> SET<STRING>? {
		guard let v = V else { return SET<STRING>() }
		return SET<STRING>(from: v.typeMembers )
	}
	public static func TYPEOF<Generic: SDAIGenericType, T: SDAIGenericType>(_ V: Generic? , IS typename: T.Type) -> LOGICAL {
//		guard let v = V else { return SDAI.UNKNOWN }
//		return LOGICAL( v.typeMembers.contains(typename) )
		abstruct()
	}
	

	public static func USEDIN(T: EntityReference?) -> BAG<EntityReference>? {
		guard let complex = T?.complexEntity else { return BAG() }
		return BAG(from: complex.usedIn())
	}
	public static func USEDIN<SEL:SDAISelectType>(T: SEL?) -> BAG<EntityReference>? {
//		guard let complex = T?.complexEntity else { return BAG() }
//		return BAG(from: complex.usedIn())
		abstruct()
	}
	public static func USEDIN<ENT:EntityReference>(T: EntityReference?, ENTITY:ENT.Type, ATTR:String) -> BAG<ENT>? {
		guard let complex = T?.complexEntity else { return BAG() }
		return BAG(from: complex.usedIn(entity: ENTITY, attr: ATTR))
	}
	public static func USEDIN<SEL:SDAISelectType,ENT:EntityReference>(T: SEL?, ENTITY:ENT.Type, ATTR:String) -> BAG<ENT>? {
//		guard let complex = T?.complexEntity else { return BAG() }
//		return BAG(from: complex.usedIn(entity: ENTITY, attr: ATTR))
		abstruct()
	}
	
	
	public static func VALUE<Str: SDAIStringType>(_ V: Str?) -> NUMBER? {
		guard let V = V, let double = Double(V.asSwiftString) else { return nil }
		return NUMBER(double)
	}
	
	public static func VALUE_IN<Aggregate: SDAIAggregationType, GEN1: SDAIGenericType>(C: Aggregate?, V: GEN1?) -> LOGICAL 
	where Aggregate.Element == GEN1?, Aggregate.ELEMENT: SDAIGenericType 
	{
		guard let C = C, let V = V else { return LOGICAL(nil) }
		var isin = false
		for element in C {
			if let element = element as? Aggregate.ELEMENT {
				if element.value.isValueEqual(to: V.value) { isin = true }
			}
			else {
				assert(element == nil)
				return LOGICAL(nil)
			}
		}
		return LOGICAL(isin)
	}
	public static func VALUE_IN<Aggregate: SDAIAggregationType, GEN1: SDAIGenericType>(C: Aggregate?, V: GEN1?) -> LOGICAL 
	where Aggregate.Element == GEN1 {
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
