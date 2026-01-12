//
//  IncrementControl.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - Increment control (13.9.1)

extension SDAI {
	public struct IncrementControl<ELEMENT: SDAI.NumberType>: Sequence, IteratorProtocol
	{
		public typealias SwiftType = ELEMENT.SwiftType

		private let _bound2: SwiftType
		private let _increment: SwiftType
		private let _sign: SwiftType
		private var _current: SwiftType
		
		public init?(bound1: SwiftType?, bound2: SwiftType?, increment: SwiftType? = 1){
			guard let bound1 = bound1, let bound2 = bound2, let increment = increment else { return nil }
			_bound2 = bound2
			_increment = increment
			_sign = increment >= 0 ? 1 : -1
			_current = bound1
		}
		
		public mutating func next() -> ELEMENT? {
			if _current * _sign > _bound2 * _sign {
				return nil
			}
			else {
				defer { _current += _increment }
				return ELEMENT(from: _current)				
			}
		}
	}
	
	public static func FROM<T,U,V>(_ bound1: T?, TO bound2: U?, BY increment: V? ) -> IncrementControl<INTEGER>?
	where T: SDAI.IntRepresented, U: SDAI.IntRepresented, V: SDAI.IntRepresented {
		return IncrementControl<INTEGER>(bound1: bound1?.asSwiftInt, 
																		 bound2: bound2?.asSwiftInt, 
																		 increment: increment?.asSwiftInt)
	}
	
	public static func FROM<T,U>(_ bound1: T?, TO bound2: U? ) -> IncrementControl<INTEGER>?
	where T: SDAI.IntRepresented, U: SDAI.IntRepresented {
		return IncrementControl<INTEGER>(bound1: bound1?.asSwiftInt, 
																		 bound2: bound2?.asSwiftInt)
	}

	public static func FROM<T,U,V>(_ bound1: T?, TO bound2: U?, BY increment: V? ) -> IncrementControl<NUMBER>?
	where T: SDAI.DoubleRepresented, U: SDAI.SwiftDoubleConvertible, V: SDAI.SwiftDoubleConvertible {
		return IncrementControl<NUMBER>(bound1: bound1?.asSwiftDouble, 
																		bound2: bound2?.asSwiftDouble, 
																		increment: increment?.asSwiftDouble)
	}
	
	public static func FROM<T,U,V>(_ bound1: T?, TO bound2: U?, BY increment: V? ) -> IncrementControl<NUMBER>?
	where T: SDAI.SwiftDoubleConvertible, U: SDAI.DoubleRepresented, V: SDAI.SwiftDoubleConvertible {
		return IncrementControl<NUMBER>(bound1: bound1?.asSwiftDouble, 
																		bound2: bound2?.asSwiftDouble, 
																		increment: increment?.asSwiftDouble)
	}
	
	public static func FROM<T,U,V>(_ bound1: T?, TO bound2: U?, BY increment: V? ) -> IncrementControl<NUMBER>?
	where T: SDAI.SwiftDoubleConvertible, U: SDAI.SwiftDoubleConvertible, V: SDAI.DoubleRepresented {
		return IncrementControl<NUMBER>(bound1: bound1?.asSwiftDouble, 
																		bound2: bound2?.asSwiftDouble, 
																		increment: increment?.asSwiftDouble)
	}
	
	public static func FROM<T,U>(_ bound1: T?, TO bound2: U? ) -> IncrementControl<NUMBER>?
	where T: SDAI.DoubleRepresented, U: SDAI.SwiftDoubleConvertible {
		return IncrementControl<NUMBER>(bound1: bound1?.asSwiftDouble, 
																		bound2: bound2?.asSwiftDouble)
	}
	
	public static func FROM<T,U>(_ bound1: T?, TO bound2: U? ) -> IncrementControl<NUMBER>?
	where T: SDAI.SwiftDoubleConvertible, U: SDAI.DoubleRepresented {
		return IncrementControl<NUMBER>(bound1: bound1?.asSwiftDouble, 
																		bound2: bound2?.asSwiftDouble)
	}

}
