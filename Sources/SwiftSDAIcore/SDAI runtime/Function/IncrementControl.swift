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
  
  /// A sequence and iterator that produces a series of values beginning at an initial bound and incrementing by a specified step toward a final bound.
  /// 
  /// This is a generic structure over `ELEMENT: SDAI.NumberType`, and it can be used to generate sequences of numbers (such as integers or doubles)
  /// given a starting value, an ending value, and an increment. It is typically constructed via the static `SDAI.FROM(_:TO:BY:)` functions.
  ///
  /// The sequence stops (returns `nil` from `next()`) when the next value would exceed the bound in the direction of the increment. For example:
  /// - For increasing sequences (`increment > 0`), iteration ends when `_current > _bound2`.
  /// - For decreasing sequences (`increment < 0`), iteration ends when `_current < _bound2`.
  ///
  /// - Parameters:
  ///   - ELEMENT: The numeric type of the sequence (must conform to `SDAI.NumberType`).
  ///
  /// - Example:
  ///   ```swift
  ///   if var inc = SDAI.FROM(1, TO: 5, BY: 2) {
  ///       while let value = inc.next() {
  ///           print(value)
  ///       }
  ///   }
  ///   // Output: 1, 3, 5
  ///   ```
  ///
  /// - Note: If any parameter to the initializer is `nil`, the result is `nil`.
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
