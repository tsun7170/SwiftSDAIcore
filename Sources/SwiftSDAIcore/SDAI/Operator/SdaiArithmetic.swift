//
//  File.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//

import Foundation

//MARK: - Arithmetic operators
 public prefix func + <T: SDAINumberType>(number: T?) -> T? {
	return number
}

 public prefix func - <T: SDAINumberType>(number: T?) -> T? {
	guard let number = number else { return nil }
	return T( -(number.asSwiftType) )
}

//MARK: Int vs. Int
public func +   <T: SDAIIntRepresentedNumberType, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return SDAI.INTEGER( lhs.asSwiftInt + rhs.asSwiftInt )
}
public func -   <T: SDAIIntRepresentedNumberType, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return SDAI.INTEGER( lhs.asSwiftInt - rhs.asSwiftInt )
}
public func *   <T: SDAIIntRepresentedNumberType, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return SDAI.INTEGER( lhs.asSwiftInt * rhs.asSwiftInt )
}
public func /   <T: SDAIIntRepresentedNumberType, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.REAL? { 
	SDAI.REAL(lhs) / SDAI.REAL(rhs?.asSwiftDouble) 
}
public func **  <T: SDAIIntRepresentedNumberType, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return SDAI.INTEGER(truncating: pow(lhs.asSwiftDouble, rhs.asSwiftDouble) )
}
public func ./. <T: SDAIIntRepresentedNumberType, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return SDAI.INTEGER( lhs.asSwiftInt / rhs.asSwiftInt )
}
public func %   <T: SDAIIntRepresentedNumberType, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	let sign = rhs.asSwiftInt >= 0 ? 1 : -1
	return (lhs - (lhs ./. rhs) * rhs) * sign
}


//MARK: Int vs. Double
public func +   <T: SDAIIntRepresentedNumberType, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.REAL? { 
	SDAI.REAL(lhs) + rhs
}
public func -   <T: SDAIIntRepresentedNumberType, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.REAL? { 
	SDAI.REAL(lhs) - rhs
}
public func *   <T: SDAIIntRepresentedNumberType, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.REAL? { 
	SDAI.REAL(lhs) * rhs
}
public func /   <T: SDAIIntRepresentedNumberType, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.REAL? { 
	SDAI.REAL(lhs) / rhs
}
public func **  <T: SDAIIntRepresentedNumberType, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.REAL? { 
	SDAI.REAL(lhs) ** rhs
}
public func ./. <T: SDAIIntRepresentedNumberType, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { 
	lhs ./. SDAI.INTEGER(truncating: rhs)
}
public func %   <T: SDAIIntRepresentedNumberType, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { 
	lhs % SDAI.INTEGER(truncating: rhs)
}


//MARK: Double vs. Double
public func +   <T: SDAIDoubleRepresentedNumberType, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.REAL? { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return SDAI.REAL( lhs.asSwiftDouble + rhs.asSwiftDouble )
}
public func -   <T: SDAIDoubleRepresentedNumberType, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.REAL? { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return SDAI.REAL( lhs.asSwiftDouble - rhs.asSwiftDouble )
}
public func *   <T: SDAIDoubleRepresentedNumberType, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.REAL? { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return SDAI.REAL( lhs.asSwiftDouble * rhs.asSwiftDouble )
}
public func /   <T: SDAIDoubleRepresentedNumberType, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.REAL? { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return SDAI.REAL( lhs.asSwiftDouble / rhs.asSwiftDouble )
}
public func **  <T: SDAIDoubleRepresentedNumberType, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.REAL? { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return SDAI.REAL( pow(lhs.asSwiftDouble, rhs.asSwiftDouble) )
}
public func ./. <T: SDAIDoubleRepresentedNumberType, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { 
	SDAI.INTEGER(truncating: lhs) ./. SDAI.INTEGER(truncating: rhs)
}
public func %   <T: SDAIDoubleRepresentedNumberType, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { 
	SDAI.INTEGER(truncating: lhs) % SDAI.INTEGER(truncating: rhs)
}


//MARK: Double vs. Int
public func +   <T: SDAIDoubleRepresentedNumberType, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.REAL? { 
	lhs + SDAI.REAL(rhs?.asSwiftDouble)
}
public func -   <T: SDAIDoubleRepresentedNumberType, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.REAL? { 
	lhs - SDAI.REAL(rhs?.asSwiftDouble)
}
public func *   <T: SDAIDoubleRepresentedNumberType, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.REAL? { 
	lhs * SDAI.REAL(rhs?.asSwiftDouble)
}
public func /   <T: SDAIDoubleRepresentedNumberType, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.REAL? { 
	lhs / SDAI.REAL(rhs?.asSwiftDouble)
}
public func **  <T: SDAIDoubleRepresentedNumberType, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.REAL? { 
	lhs ** SDAI.REAL(rhs?.asSwiftDouble)
}
public func ./. <T: SDAIDoubleRepresentedNumberType, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { 
	SDAI.INTEGER(lhs) ./. rhs
}
public func %   <T: SDAIDoubleRepresentedNumberType, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { 
	SDAI.INTEGER(lhs) % rhs
}


//MARK: Double vs. Select
public func +   <T: SDAIDoubleRepresentedNumberType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.REAL? { 
	lhs + rhs?.realValue
}
public func -   <T: SDAIDoubleRepresentedNumberType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.REAL? { 
	lhs - rhs?.realValue
}
public func *   <T: SDAIDoubleRepresentedNumberType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.REAL? { 
	lhs * rhs?.realValue
}
public func /   <T: SDAIDoubleRepresentedNumberType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.REAL? { 
	lhs / rhs?.realValue
}
public func **  <T: SDAIDoubleRepresentedNumberType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.REAL? { 
	lhs ** rhs?.realValue
}
public func ./. <T: SDAIDoubleRepresentedNumberType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { 
	if let rhs = rhs?.integerValue { return lhs ./. rhs }
	return lhs ./. rhs?.realValue
}
public func %   <T: SDAIDoubleRepresentedNumberType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { 
	if let rhs = rhs?.integerValue { return lhs % rhs }
	return lhs % rhs?.realValue
}

//MARK: Select vs. Double
public func +   <T: SDAISelectType, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.REAL? { 
	lhs?.realValue + rhs
}
public func -   <T: SDAISelectType, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.REAL? { 
	lhs?.realValue - rhs
}
public func *   <T: SDAISelectType, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.REAL? { 
	lhs?.realValue * rhs
}
public func /   <T: SDAISelectType, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.REAL? { 
	lhs?.realValue / rhs
}
public func **  <T: SDAISelectType, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.REAL? { 
	lhs?.realValue ** rhs
}
public func ./. <T: SDAISelectType, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { 
	if let lhs = lhs?.integerValue { return lhs ./. rhs }
	return lhs?.realValue ./. rhs
}
public func %   <T: SDAISelectType, U: SDAIDoubleRepresented>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { 
	if let lhs = lhs?.integerValue { return lhs ./. rhs }
	return lhs?.realValue % rhs
}

//MARK: Int vs. Select
public func +   <T: SDAIIntRepresentedNumberType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { 
	lhs + rhs?.integerValue
}
public func -   <T: SDAIIntRepresentedNumberType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { 
	lhs - rhs?.integerValue
}
public func *   <T: SDAIIntRepresentedNumberType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { 
	lhs * rhs?.integerValue
}
public func /   <T: SDAIIntRepresentedNumberType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.REAL? { 
	lhs / rhs?.integerValue
}
public func **  <T: SDAIIntRepresentedNumberType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { 
	lhs ** rhs?.integerValue
}
public func ./. <T: SDAIIntRepresentedNumberType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { 
	lhs ./. rhs?.integerValue
}
public func %   <T: SDAIIntRepresentedNumberType, U: SDAISelectType>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { 
	lhs % rhs?.integerValue
}

//MARK: Select vs. Int
public func +   <T: SDAISelectType, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { 
	lhs?.integerValue + rhs
}
public func -   <T: SDAISelectType, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { 
	lhs?.integerValue - rhs
}
public func *   <T: SDAISelectType, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { 
	lhs?.integerValue * rhs
}
public func /   <T: SDAISelectType, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.REAL? { 
	lhs?.integerValue / rhs
}
public func **  <T: SDAISelectType, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { 
	lhs?.integerValue ** rhs
}
public func ./. <T: SDAISelectType, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { 
	lhs?.integerValue ./. rhs
}
public func %   <T: SDAISelectType, U: SDAIIntRepresented>(lhs: T?, rhs: U?) -> SDAI.INTEGER? { 
	lhs?.integerValue % rhs
}


