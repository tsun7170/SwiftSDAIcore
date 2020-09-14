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
		return V?.hiBound ?? nil
	}
	
	public func HIINDEX<Aggregate: SDAIAggregationType>(_ V: Aggregate?) -> INTEGER? {
		return V?.hiIndex ?? nil
	}
	
	public func LENGTH<Str: SDAI__STRING__type>(_ V: Str?) -> INTEGER? {
		return V?.length ?? nil
	}
	
	public func LOBOUND<Aggregate: SDAIAggregationType>(_ V: Aggregate?) -> INTEGER? {
		return V?.loBound ?? nil
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
		return V?.loIndex ?? nil
	}

	public func NVL<GEN1: SDAIGenericType>(V: GEN1?, SUBSTITUTE: GEN1) -> GEN1 {
		return V ?? SUBSTITUTE
	}
	public func NVL<GEN1: SDAIGenericType>(V: GEN1?, SUBSTITUTE: GEN1.SwiftType) -> GEN1 {
		return V ?? GEN1(SUBSTITUTE)
	}
}
