//
//  File.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//

import Foundation

//MARK: - Instance comparison operators (numeric, logical, string, binary and enumeration) (12.2.2)
//MARK: numeric type vs. numeric type
public func .===. <T: SDAIIntRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs .==. rhs }
public func .!==. <T: SDAIIntRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

public func .===. <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.LOGICAL { lhs .==. rhs }
public func .!==. <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

public func .===. <U: SDAIIntRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.LOGICAL { lhs .==. rhs }
public func .!==. <U: SDAIIntRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

public func .===. <T: SDAIIntRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs .==. rhs }
public func .!==. <T: SDAIIntRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

public func .===. <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.LOGICAL { lhs .==. rhs }
public func .!==. <T: SDAIIntRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

public func .===. <U: SDAIDoubleRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.LOGICAL { lhs .==. rhs }
public func .!==. <U: SDAIDoubleRepresentedNumberType>(lhs: Int?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

public func .===. <T: SDAIDoubleRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs .==. rhs }
public func .!==. <T: SDAIDoubleRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

public func .===. <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.LOGICAL { lhs .==. rhs }
public func .!==. <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Double?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

public func .===. <U: SDAIDoubleRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.LOGICAL { lhs .==. rhs }
public func .!==. <U: SDAIDoubleRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

public func .===. <T: SDAIDoubleRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs .==. rhs }
public func .!==. <T: SDAIDoubleRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

public func .===. <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.LOGICAL { lhs .==. rhs }
public func .!==. <T: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: Int?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

public func .===. <U: SDAIIntRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.LOGICAL { lhs .==. rhs }
public func .!==. <U: SDAIIntRepresentedNumberType>(lhs: Double?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }


//MARK: logical type vs. logival type
public func .===. <T: SDAILogicalType, U: SDAILogicalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs .==. rhs }
public func .!==. <T: SDAILogicalType, U: SDAILogicalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

//MARK: string type vs. string type
public func .===. <T: SDAIStringType, U: SDAIStringType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs .==. rhs }
public func .!==. <T: SDAIStringType, U: SDAIStringType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

public func .===. <T: SDAIStringType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { lhs .==. rhs }
public func .!==. <T: SDAIStringType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

public func .===. <U: SDAIStringType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { lhs .==. rhs }
public func .!==. <U: SDAIStringType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

//MARK: binary type vs. binary type
public func .===. <T: SDAIBinaryType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs .==. rhs }
public func .!==. <T: SDAIBinaryType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

public func .===. <T: SDAIBinaryType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { lhs .==. rhs }
public func .!==. <T: SDAIBinaryType>(lhs: T?, rhs: String?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

public func .===. <U: SDAIBinaryType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { lhs .==. rhs }
public func .!==. <U: SDAIBinaryType>(lhs: String?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

//MARK: enum type vs. enum type
public func .===. <T: SDAIEnumerationType>(lhs: T?, rhs: T?) -> SDAI.LOGICAL { lhs .==. rhs }
public func .!==. <T: SDAIEnumerationType>(lhs: T?, rhs: T?) -> SDAI.LOGICAL { !(lhs .===. rhs) }


//MARK: GENERIC vs. generic type
public func .===. <T: SDAI__GENERIC__type, U: SDAIGenericType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL {
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	if let lhs = lhs.entityReference, let rhs = rhs.entityReference {
		return lhs .===. rhs
	}
	else if let lhs = lhs.stringValue, let rhs = rhs.stringValue {
		return lhs .===. rhs
	}
	else if let lhs = lhs.binaryValue, let rhs = rhs.binaryValue {
		return lhs .===. rhs
	}
	else if let lhs = lhs.booleanValue, let rhs = rhs.booleanValue {
		return lhs .===. rhs
	}
	else if let lhs = lhs.logicalValue, let rhs = rhs.logicalValue {
		return lhs .===. rhs
	}
	else if let lhs = lhs.integerValue, let rhs = rhs.integerValue {
		return lhs .===. rhs
	}
	else if let lhs = lhs.realValue, let rhs = rhs.realValue {
		return lhs .===. rhs
	}
	else if let lhs = lhs.numberValue, let rhs = rhs.numberValue {
		return lhs .===. rhs
	}
	else if let lhs = lhs.arrayOptionalValue(elementType: SDAI.GENERIC.self), 
					let rhs = rhs.arrayOptionalValue(elementType: SDAI.GENERIC.self) {
		return lhs .===. rhs
	}
	else if let lhs = lhs.listValue(elementType: SDAI.GENERIC.self), 
					let rhs = rhs.listValue(elementType: SDAI.GENERIC.self) {
		return lhs .===. rhs
	}
	else if let lhs = lhs.bagValue(elementType: SDAI.GENERIC.self), 
					let rhs = rhs.bagValue(elementType: SDAI.GENERIC.self) {
		return lhs .===. rhs
	}
	return lhs .==. rhs	
}
public func .!==. <T: SDAI__GENERIC__type, U: SDAI__GENERIC__type>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }
