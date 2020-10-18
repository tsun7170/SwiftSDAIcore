//
//  File.swift
//  
//
//  Created by Yoshida on 2020/09/10.
//

import Foundation

extension SDAI {
	public func ABS<Number: SDAI__NUMBER__type>(_ V: Number?) -> Number? {
		guard let v = V?.asSwiftType else { return nil }
		return Number( abs(v) )  
	}
	
	public func ACOS<Number: SDAI__NUMBER__type>(_ V: Number?) -> REAL? {
		guard let r = V?.asSwiftDouble else { return nil }
		return REAL( acos(r) )
	}
	
	public func ASIN<Number: SDAI__NUMBER__type>(_ V: Number?) -> REAL? {
		guard let r = V?.asSwiftDouble else { return nil }
		return REAL( asin(r) )
	}
	
	public func ATAN<Number1: SDAI__NUMBER__type, Number2: SDAI__NUMBER__type>
	(V1: Number1?, V2: Number2?) -> REAL? {
		guard let r1 = V1?.asSwiftDouble, let r2 = V2?.asSwiftDouble else { return nil }
		return REAL( atan2(r1, r2) )
	}
	
	public func BLENGTH<Binary: SDAI__BINARY__type>(_ V:Binary?) -> INTEGER? {
		guard let s = V?.asSwiftType else { return nil }
		return INTEGER( s.count )
	}
	
	public func COS<Number: SDAI__NUMBER__type>(_ V: Number?) -> REAL? {
		guard let r = V?.asSwiftDouble else { return nil }
		return REAL( cos(r) )
	}
	
	public func EXISTS<Generic: SDAIGenericType>(_ V: Generic?) -> BOOLEAN {
		return BOOLEAN( V != nil )
	}
	
	public func EXP<Number: SDAI__NUMBER__type>(_ V: Number?) -> REAL? {
		guard let r = V?.asSwiftDouble else { return nil }
		return REAL( exp(r) )
	}

	public func FORMAT<Number: SDAI__NUMBER__type, Str: SDAI__STRING__type>(N: Number?, F: Str?) -> STRING? {
		guard let v = N?.asSwiftType else { return nil }
		//TODO: - to respect format command
		return STRING( String(describing: v) )			
	}
	
	public func HIBOUND<Aggregate: SDAIAggregationType>(_ V: Aggregate?) -> INTEGER? {
		return INTEGER(V?.hiBound)
	}
	
	public func HIINDEX<Aggregate: SDAIAggregationType>(_ V: Aggregate?) -> INTEGER? {
		return INTEGER(V?.hiIndex)
	}
	
	public func LENGTH<Str: SDAI__STRING__type>(_ V: Str?) -> INTEGER? {
		return INTEGER(V?.length)
	}
	
	public func LOBOUND<Aggregate: SDAIAggregationType>(_ V: Aggregate?) -> INTEGER? {
		return INTEGER(V?.loBound)
	}
	
	public func LOG<Number: SDAI__NUMBER__type>(_ V: Number?) -> REAL? {
		guard let r = V?.asSwiftDouble else { return nil }
		return REAL( log(r) )
	}
	
	public func LOG2<Number: SDAI__NUMBER__type>(_ V: Number?) -> REAL? {
		guard let r = V?.asSwiftDouble else { return nil }
		return REAL( log(r)/log(2) )
	}
	
	public func LOG10<Number: SDAI__NUMBER__type>(_ V: Number?) -> REAL? {
		guard let r = V?.asSwiftDouble else { return nil }
		return REAL( log10(r) )
	}
	
	public func LOINDEX<Aggregate: SDAIAggregationType>(_ V: Aggregate?) -> INTEGER? {
		return INTEGER(V?.loIndex)
	}

	public func NVL<GEN1: SDAIGenericType>(V: GEN1?, SUBSTITUTE: GEN1) -> GEN1 {
		return V ?? SUBSTITUTE
	}
	public func NVL<GEN1: SDAIUnderlyingType>(V: GEN1?, SUBSTITUTE: GEN1.FundamentalType) -> GEN1 {
		return V ?? GEN1(SUBSTITUTE)
	}
	public func NVL<GEN1: SDAISimpleType>(V: GEN1?, SUBSTITUTE: GEN1.SwiftType) -> GEN1 {
		return V ?? GEN1(SUBSTITUTE)
	}
	
	public func ODD<Integer: SDAI__INTEGER__type>(_ V: Integer?) -> LOGICAL {
		guard let i = V?.asSwiftType else { return LOGICAL(nil) }
		return LOGICAL( i % 2 == 1 )
	}
	
	public func ROLESOF(_ V: EntityReference?) -> SET<STRING> {
		guard let complex = V?.complexEntity else { return SET<STRING>(from: []) }
		return SET<STRING>(from: complex.roles)
	}
	
	public func SIN<Number: SDAI__NUMBER__type>(_ V: Number?) -> REAL? {
		guard let r = V?.asSwiftDouble else { return nil }
		return REAL( sin(r) )
	}

	public func SIZEOF<Aggregate: SDAIAggregationType>(_ V: Aggregate?) -> INTEGER? {
		return INTEGER(V?.size)
	}
	
	public func SQRT<Number: SDAI__NUMBER__type>(_ V: Number?) -> REAL? {
		guard let r = V?.asSwiftDouble else { return nil }
		return REAL( sqrt(r) )
	}
	
	public func TAN<Number: SDAI__NUMBER__type>(_ V: Number?) -> REAL? {
		guard let r = V?.asSwiftDouble else { return nil }
		return REAL( tan(r) )
	}
	
	public func TYPEOF<Generic: SDAIGenericType>(_ V: Generic?) -> SET<STRING> {
		guard let v = V else { return SET<STRING>(from: []) }
		return SET<STRING>(from: v.typeMembers )
	}

	public func USEDIN(T: EntityReference?, R: STRING?) -> BAG<EntityReference> {
		guard let complex = T?.complexEntity, let role = R else { return BAG(from: []) }
		return BAG(from: complex.usedIn(role: role.asSwiftType))
	}
	
	public func VALUE(_ V: STRING?) -> NUMBER? {
		guard let V = V, let double = Double(V.asSwiftType) else { return nil }
		return NUMBER(double)
	}
	
	public func VALUE_IN<Aggregate: SDAIAggregationType, GEN1: SDAIGenericType>(C: Aggregate?, V: GEN1?) -> LOGICAL 
	where Aggregate.Element == GEN1? {
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
	public func VALUE_IN<Aggregate: SDAIAggregationType, GEN1: SDAIGenericType>(C: Aggregate?, V: GEN1?) -> LOGICAL 
	where Aggregate.Element == GEN1 {
		guard let C = C, let V = V else { return LOGICAL(nil) }
		for element in C {
			if element.value.isValueEqual(to: V.value) { return LOGICAL(true) }
		}
		return LOGICAL(false)
	}
	
	public func VALUE_UNIQUE<Aggregate: SDAIAggregationType>(_ V: Aggregate?) -> LOGICAL 
	where Aggregate.Element == Aggregate.ELEMENT? {
		guard let V = V, !V.contains(nil) else { return LOGICAL(nil) }
		let unique = Set( V.map{ $0!.value } )
		return LOGICAL(unique.count == V.size)
	}
	public func VALUE_UNIQUE<Aggregate: SDAIAggregationType>(_ V: Aggregate?) -> LOGICAL 
	where Aggregate.Element == Aggregate.ELEMENT {
		guard let V = V else { return LOGICAL(nil) }
		let unique = Set( V.map{ $0.value } )
		return LOGICAL(unique.count == V.size)
	}
}
