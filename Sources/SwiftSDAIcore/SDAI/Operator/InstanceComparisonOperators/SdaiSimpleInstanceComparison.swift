//
//  SdaiSimpleInstanceComparison.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - Instance comparison operators (numeric, logical, string, binary and enumeration) (12.2.2)

//MARK: numeric type vs. numeric type
public func .===. <T: SDAIIntRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs .==. rhs }
public func .!==. <T: SDAIIntRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

public func .===. <T: SDAIIntRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs .==. rhs }
public func .!==. <T: SDAIIntRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

public func .===. <T: SDAIDoubleRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs .==. rhs }
public func .!==. <T: SDAIDoubleRepresentedNumberType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

public func .===. <T: SDAIDoubleRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs .==. rhs }
public func .!==. <T: SDAIDoubleRepresentedNumberType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

//MARK: numeric vs. select
public func .===. <T: SDAIIntRepresentedNumberType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs .==. rhs }
public func .!==. <T: SDAIIntRepresentedNumberType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

public func .===. <T: SDAIDoubleRepresentedNumberType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs .==. rhs }
public func .!==. <T: SDAIDoubleRepresentedNumberType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

//MARK: select vs. numeric
public func .===. <T: SDAISelectType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs .===. lhs }
public func .!==. <T: SDAISelectType, U: SDAIIntRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

public func .===. <T: SDAISelectType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs .===. lhs }
public func .!==. <T: SDAISelectType, U: SDAIDoubleRepresentedNumberType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }


//MARK: logical type vs. logival type
public func .===. <T: SDAILogicalType, U: SDAILogicalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs .==. rhs }
public func .!==. <T: SDAILogicalType, U: SDAILogicalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

//MARK: logical type vs. select
public func .===. <T: SDAILogicalType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs .==. rhs }
public func .!==. <T: SDAILogicalType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

//MARK: select vs. logical type
public func .===. <T: SDAISelectType, U: SDAILogicalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs .===. lhs }
public func .!==. <T: SDAISelectType, U: SDAILogicalType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }


//MARK: string type vs. string type
public func .===. <T: SwiftStringRepresented, U: SwiftStringRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs .==. rhs }
public func .!==. <T: SwiftStringRepresented, U: SwiftStringRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

//MARK: string type vs. select
public func .===. <T: SwiftStringRepresented, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs .==. rhs }
public func .!==. <T: SwiftStringRepresented, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

//MARK: select vs. string type
public func .===. <T: SDAISelectType, U: SwiftStringRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs .===. lhs }
public func .!==. <T: SDAISelectType, U: SwiftStringRepresented>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }


//MARK: binary type vs. binary type
public func .===. <T: SDAIBinaryType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs .==. rhs }
public func .!==. <T: SDAIBinaryType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

//MARK: binary type vs. select
public func .===. <T: SDAIBinaryType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs .==. rhs }
public func .!==. <T: SDAIBinaryType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

//MARK: select vs. binary type
public func .===. <T: SDAISelectType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs .===. lhs }
public func .!==. <T: SDAISelectType, U: SDAIBinaryType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }


//MARK: enum type vs. enum type
public func .===. <T: SDAIEnumerationType, U: SDAIEnumerationType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL where T.FundamentalType == U.FundamentalType { lhs .==. rhs }
public func .!==. <T: SDAIEnumerationType, U: SDAIEnumerationType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL where T.FundamentalType == U.FundamentalType { !(lhs .===. rhs) }

//MARK: enum type vs. select
public func .===. <T: SDAIEnumerationType,U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { lhs .==. rhs }
public func .!==. <T: SDAIEnumerationType,U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

//MARK: select vs. enum type
public func .===. <T: SDAISelectType,U: SDAIEnumerationType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { rhs .===. lhs }
public func .!==. <T: SDAISelectType,U: SDAIEnumerationType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }


//MARK: select vs. select
public func .===. <T: SDAISelectType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { 
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	return SDAI.GENERIC(lhs) .===. SDAI.GENERIC(rhs)
}
public func .!==. <T: SDAISelectType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }


//MARK: GENERIC vs. GENERIC
public func .===. (lhs: SDAI.GENERIC?, rhs: SDAI.GENERIC?) -> SDAI.LOGICAL {
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	
	if let lhs = lhs.entityReference, let rhs = rhs.entityReference {
		return lhs .===. rhs
	}
	if let lhs = lhs.stringValue, let rhs = rhs.stringValue {
		return lhs .===. rhs
	}
	if let lhs = lhs.arrayOptionalValue(elementType: SDAI.GENERIC.self), 
		 let rhs = rhs.arrayOptionalValue(elementType: SDAI.GENERIC.self) {
		return lhs .===. rhs
	}
	if let lhs = lhs.listValue(elementType: SDAI.GENERIC.self), 
		 let rhs = rhs.listValue(elementType: SDAI.GENERIC.self) {
		return lhs .===. rhs
	}
	if let lhs = lhs.bagValue(elementType: SDAI.GENERIC.self), 
		 let rhs = rhs.bagValue(elementType: SDAI.GENERIC.self) {
		return lhs .===. rhs
	}
	return lhs .==. rhs	
}
public func .!==. (lhs: SDAI.GENERIC?, rhs: SDAI.GENERIC?) -> SDAI.LOGICAL { !(lhs .===. rhs) }
