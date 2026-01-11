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
/// Numeric Instance Equal: Int .===. Int = LOGICAL
///
public func .===. <TI: SDAIIntRepresentedNumberType, UI: SDAIIntRepresentedNumberType>(
  lhs: TI?, rhs: UI?) -> SDAI.LOGICAL
{ lhs .==. rhs }

/// Numeric Instance NotEqual: Int .!==. Int = LOGICAL
///
public func .!==. <T: SDAIIntRepresentedNumberType, U: SDAIIntRepresentedNumberType>(
  lhs: T?, rhs: U?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }



/// Numeric Instance Equal: Int .===. Double = LOGICAL
///
public func .===. <TI: SDAIIntRepresentedNumberType, UD: SDAIDoubleRepresentedNumberType>(
  lhs: TI?, rhs: UD?) -> SDAI.LOGICAL
{ lhs .==. rhs }

/// Numeric Instance NotEqual: Int .!==. Double = LOGICAL
///
public func .!==. <TI: SDAIIntRepresentedNumberType, UD: SDAIDoubleRepresentedNumberType>(
  lhs: TI?, rhs: UD?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }



/// Numeric Instance Equal: Double .===. Double = LOGICAL
///
public func .===. <TD: SDAIDoubleRepresentedNumberType, UD: SDAIDoubleRepresentedNumberType>(
  lhs: TD?, rhs: UD?) -> SDAI.LOGICAL
{ lhs .==. rhs }

/// Numeric Instance NotEqual: Double .!==. Double = LOGICAL
///
public func .!==. <TD: SDAIDoubleRepresentedNumberType, UD: SDAIDoubleRepresentedNumberType>(
  lhs: TD?, rhs: UD?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }



/// Numeric Instance Equal: Double .===. Int = LOGICAL
///
public func .===. <TD: SDAIDoubleRepresentedNumberType, UI: SDAIIntRepresentedNumberType>(
  lhs: TD?, rhs: UI?) -> SDAI.LOGICAL
{ lhs .==. rhs }

/// Numeric Instance NotEqual: Double .!==. Int = LOGICAL
///
public func .!==. <TD: SDAIDoubleRepresentedNumberType, UI: SDAIIntRepresentedNumberType>(
  lhs: TD?, rhs: UI?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


//MARK: numeric vs. select
/// Numeric Instance Equal: Int .===. Select = LOGICAL
///
public func .===. <TI: SDAIIntRepresentedNumberType, US: SDAISelectType>(
  lhs: TI?, rhs: US?) -> SDAI.LOGICAL
{ lhs .==. rhs }

/// Numeric Instance NotEqual: Int .!==. Select = LOGICAL
///
public func .!==. <TI: SDAIIntRepresentedNumberType, US: SDAISelectType>(
  lhs: TI?, rhs: US?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


/// Numeric Instance Equal: Double .===. Select = LOGICAL
///
public func .===. <TD: SDAIDoubleRepresentedNumberType, US: SDAISelectType>(
  lhs: TD?, rhs: US?) -> SDAI.LOGICAL
{ lhs .==. rhs }

/// Numeric Instance NotEqual: Double .!==. Select = LOGICAL
///
public func .!==. <TD: SDAIDoubleRepresentedNumberType, US: SDAISelectType>(
  lhs: TD?, rhs: US?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


//MARK: select vs. numeric
/// Numeric Instance Equal: Select .===. Int = LOGICAL
///
public func .===. <TS: SDAISelectType, UI: SDAIIntRepresentedNumberType>(
  lhs: TS?, rhs: UI?) -> SDAI.LOGICAL
{ rhs .===. lhs }

/// Numeric Instance NotEqual: Select .!==. Int = LOGICAL
///
public func .!==. <TS: SDAISelectType, UI: SDAIIntRepresentedNumberType>(
  lhs: TS?, rhs: UI?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


/// Numeric Instance Equal: Select .===. Double = LOGICAL
///
public func .===. <TS: SDAISelectType, UD: SDAIDoubleRepresentedNumberType>(
  lhs: TS?, rhs: UD?) -> SDAI.LOGICAL
{ rhs .===. lhs }

/// Numeric Instance NotEqual: Select .!==. Double = LOGICAL
///
public func .!==. <TS: SDAISelectType, UD: SDAIDoubleRepresentedNumberType>(
  lhs: TS?, rhs: UD?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


//MARK: logical type vs. logical type
/// Logical Instance Equal: Logical .===. Logical = LOGICAL
///
public func .===. <TL: SDAILogicalType, UL: SDAILogicalType>(
  lhs: TL?, rhs: UL?) -> SDAI.LOGICAL
{ lhs .==. rhs }

/// Logical Instance NotEqual: Logical .!==. Logical = LOGICAL
///
public func .!==. <TL: SDAILogicalType, UL: SDAILogicalType>(
  lhs: TL?, rhs: UL?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


//MARK: logical type vs. select
/// Logical Instance Equal: Logical .===. Select = LOGICAL
///
public func .===. <TL: SDAILogicalType, US: SDAISelectType>(
  lhs: TL?, rhs: US?) -> SDAI.LOGICAL
{ lhs .==. rhs }

/// Logical Instance NotEqual: Logical .!==. Select = LOGICAL
///
public func .!==. <TL: SDAILogicalType, US: SDAISelectType>(
  lhs: TL?, rhs: US?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


//MARK: select vs. logical type
/// Logical Instance Equal: Select .===. Logical = LOGICAL
///
public func .===. <TS: SDAISelectType, UL: SDAILogicalType>(
  lhs: TS?, rhs: UL?) -> SDAI.LOGICAL
{ rhs .===. lhs }

/// Logical Instance NotEqual: Select .!==. Logical = LOGICAL
///
public func .!==. <TS: SDAISelectType, UL: SDAILogicalType>(
  lhs: TS?, rhs: UL?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


//MARK: string type vs. string type
/// String Instance Equal: String .===. String = LOGICAL
///
public func .===. <TX: SwiftStringRepresented, UX: SwiftStringRepresented>(
  lhs: TX?, rhs: UX?) -> SDAI.LOGICAL
{ lhs .==. rhs }

/// String Instance NotEqual: String .!==. String = LOGICAL
///
public func .!==. <TX: SwiftStringRepresented, UX: SwiftStringRepresented>(
  lhs: TX?, rhs: UX?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


//MARK: string type vs. select
/// String Instance Equal: String .===. Select = LOGICAL
///
public func .===. <TX: SwiftStringRepresented, US: SDAISelectType>(
  lhs: TX?, rhs: US?) -> SDAI.LOGICAL
{ lhs .==. rhs }

/// String Instance NotEqual: String .!==. Select = LOGICAL
///
public func .!==. <TX: SwiftStringRepresented, US: SDAISelectType>(
  lhs: TX?, rhs: US?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


//MARK: select vs. string type
/// String Instance Equal: Select .===. String = LOGICAL
///
public func .===. <TS: SDAISelectType, UX: SwiftStringRepresented>(
  lhs: TS?, rhs: UX?) -> SDAI.LOGICAL
{ rhs .===. lhs }

/// String Instance NotEqual: Select .!==. String = LOGICAL
///
public func .!==. <TS: SDAISelectType, UX: SwiftStringRepresented>(
  lhs: TS?, rhs: UX?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


//MARK: binary type vs. binary type
/// Binary Instance Equal: Binary .===. Binary = LOGICAL
///
public func .===. <TB: SDAIBinaryType, UB: SDAIBinaryType>(
  lhs: TB?, rhs: UB?) -> SDAI.LOGICAL
{ lhs .==. rhs }

/// Binary Instance NotEqual: Binary .!==. Binary = LOGICAL
///
public func .!==. <TB: SDAIBinaryType, UB: SDAIBinaryType>(
  lhs: TB?, rhs: UB?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


//MARK: binary type vs. select
/// Binary Instance Equal: Binary .===. Select = LOGICAL
///
public func .===. <TB: SDAIBinaryType, US: SDAISelectType>(
  lhs: TB?, rhs: US?) -> SDAI.LOGICAL
{ lhs .==. rhs }

/// Binary Instance NotEqual: Binary .!==. Select = LOGICAL
///
public func .!==. <TB: SDAIBinaryType, US: SDAISelectType>(
  lhs: TB?, rhs: US?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


//MARK: select vs. binary type
/// Binary Instance Equal: Select .===. Binary = LOGICAL
///
public func .===. <TS: SDAISelectType, UB: SDAIBinaryType>(
  lhs: TS?, rhs: UB?) -> SDAI.LOGICAL
{ rhs .===. lhs }

/// Binary Instance NotEqual: Select .!==. Binary = LOGICAL
///
public func .!==. <TS: SDAISelectType, UB: SDAIBinaryType>(
  lhs: TS?, rhs: UB?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


//MARK: enum type vs. enum type
/// Enumeration Instance Equal: Enum .===. Enum = LOGICAL
///
public func .===. <TE: SDAIEnumerationType, UE: SDAIEnumerationType>(
  lhs: TE?, rhs: UE?) -> SDAI.LOGICAL
where TE.FundamentalType == UE.FundamentalType
{ lhs .==. rhs }

/// Enumeration Instance NotEqual: Enum .!==. Enum = LOGICAL
///
public func .!==. <TE: SDAIEnumerationType, UE: SDAIEnumerationType>(
  lhs: TE?, rhs: UE?) -> SDAI.LOGICAL
where TE.FundamentalType == UE.FundamentalType
{ !(lhs .===. rhs) }


//MARK: enum type vs. select
/// Enumeration Instance Equal: Enum .===. Select = LOGICAL
///
public func .===. <TE: SDAIEnumerationType,US: SDAISelectType>(
  lhs: TE?, rhs: US?) -> SDAI.LOGICAL
{ lhs .==. rhs }

/// Enumeration Instance NotEqual: Enum .!==. Select = LOGICAL
///
public func .!==. <TE: SDAIEnumerationType,US: SDAISelectType>(
  lhs: TE?, rhs: US?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


//MARK: select vs. enum type
/// Enumeration Instance Equal: Select .===. Enum = LOGICAL
///
public func .===. <TS: SDAISelectType,UE: SDAIEnumerationType>(
  lhs: TS?, rhs: UE?) -> SDAI.LOGICAL
{ rhs .===. lhs }

/// Enumeration Instance NotEqual: Select .!==. Enum = LOGICAL
///
public func .!==. <TS: SDAISelectType,UE: SDAIEnumerationType>(
  lhs: TS?, rhs: UE?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


//MARK: select vs. select
/// Generic Instance Equal: Select .===. Select = LOGICAL
///
public func .===. <TS: SDAISelectType, US: SDAISelectType>(
  lhs: TS?, rhs: US?) -> SDAI.LOGICAL
{
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	return SDAI.GENERIC(lhs) .===. SDAI.GENERIC(rhs)
}

/// Generic Instance NotEqual: Select .!==. Select = LOGICAL
///
public func .!==. <TS: SDAISelectType, US: SDAISelectType>(
  lhs: TS?, rhs: US?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


//MARK: GENERIC vs. GENERIC
/// Generic Instance Equal: GENERIC .===. GENERIC = LOGICAL
///
public func .===. (
  lhs: SDAI.GENERIC?, rhs: SDAI.GENERIC?) -> SDAI.LOGICAL
{
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

/// Generic Instance NotEqual: GENERIC .!==. GENERIC = LOGICAL
///
public func .!==. (
  lhs: SDAI.GENERIC?, rhs: SDAI.GENERIC?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }
