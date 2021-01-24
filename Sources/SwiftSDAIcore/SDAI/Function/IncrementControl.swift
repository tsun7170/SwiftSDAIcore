//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation

extension SDAI {
	public struct IncrementControl<ELEMENT: SDAINumberType>: Sequence, IteratorProtocol
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
				return ELEMENT(_current)				
			}
		}
	}
	
	public static func FROM<T,U,V>(_ bound1: T?, TO bound2: U?, BY increment: V? ) -> IncrementControl<INTEGER>?
	where T: SDAIIntRepresented, U: SDAIIntRepresented, V: SDAIIntRepresented {
		return IncrementControl<INTEGER>(bound1: bound1?.asSwiftInt, 
																		 bound2: bound2?.asSwiftInt, 
																		 increment: increment?.asSwiftInt)
	}
	
	public static func FROM<T,U>(_ bound1: T?, TO bound2: U? ) -> IncrementControl<INTEGER>?
	where T: SDAIIntRepresented, U: SDAIIntRepresented {
		return IncrementControl<INTEGER>(bound1: bound1?.asSwiftInt, 
																		 bound2: bound2?.asSwiftInt)
	}

	public static func FROM<T,U,V>(_ bound1: T?, TO bound2: U?, BY increment: V? ) -> IncrementControl<NUMBER>?
	where T: SDAIDoubleRepresented, U: SwiftDoubleConvertible, V: SwiftDoubleConvertible {
		return IncrementControl<NUMBER>(bound1: bound1?.asSwiftDouble, 
																		bound2: bound2?.asSwiftDouble, 
																		increment: increment?.asSwiftDouble)
	}
	
	public static func FROM<T,U,V>(_ bound1: T?, TO bound2: U?, BY increment: V? ) -> IncrementControl<NUMBER>?
	where T: SwiftDoubleConvertible, U: SDAIDoubleRepresented, V: SwiftDoubleConvertible {
		return IncrementControl<NUMBER>(bound1: bound1?.asSwiftDouble, 
																		bound2: bound2?.asSwiftDouble, 
																		increment: increment?.asSwiftDouble)
	}
	
	public static func FROM<T,U,V>(_ bound1: T?, TO bound2: U?, BY increment: V? ) -> IncrementControl<NUMBER>?
	where T: SwiftDoubleConvertible, U: SwiftDoubleConvertible, V: SDAIDoubleRepresented {
		return IncrementControl<NUMBER>(bound1: bound1?.asSwiftDouble, 
																		bound2: bound2?.asSwiftDouble, 
																		increment: increment?.asSwiftDouble)
	}
	
	public static func FROM<T,U>(_ bound1: T?, TO bound2: U? ) -> IncrementControl<NUMBER>?
	where T: SDAIDoubleRepresented, U: SwiftDoubleConvertible {
		return IncrementControl<NUMBER>(bound1: bound1?.asSwiftDouble, 
																		bound2: bound2?.asSwiftDouble)
	}
	
	public static func FROM<T,U>(_ bound1: T?, TO bound2: U? ) -> IncrementControl<NUMBER>?
	where T: SwiftDoubleConvertible, U: SDAIDoubleRepresented {
		return IncrementControl<NUMBER>(bound1: bound1?.asSwiftDouble, 
																		bound2: bound2?.asSwiftDouble)
	}


	
//	
//	
//	public static func FROM<T,U,V>(_ bound1: T?, TO bound2: U?, BY increment: V? ) -> StrideThrough<Int>? 
//	where T: SDAI__INTEGER__type, U: SDAI__INTEGER__type, V: SDAI__INTEGER__type {
//		guard let bound1 = bound1?.asSwiftType, 
//					let bound2 = bound2?.asSwiftType, 
//					let increment = increment?.asSwiftType 
//		else { return nil }
//		return stride(from: bound1, through: bound2, by: increment)
//	}
//	public static func FROM<T,U>(_ bound1: T?, TO bound2: U?, BY increment: Int? ) -> StrideThrough<Int>? 
//	where T: SDAI__INTEGER__type, U: SDAI__INTEGER__type {
//		guard let bound1 = bound1?.asSwiftType, 
//					let bound2 = bound2?.asSwiftType, 
//					let increment = increment 
//		else { return nil }
//		return stride(from: bound1, through: bound2, by: increment)
//	}
//	public static func FROM<T,V>(_ bound1: T?, TO bound2: Int?, BY increment: V? ) -> StrideThrough<Int>? 
//	where T: SDAI__INTEGER__type, V: SDAI__INTEGER__type {
//		guard let bound1 = bound1?.asSwiftType, 
//					let bound2 = bound2, 
//					let increment = increment?.asSwiftType 
//		else { return nil }
//		return stride(from: bound1, through: bound2, by: increment)
//	}
//	public static func FROM<U,V>(_ bound1: Int?, TO bound2: U?, BY increment: V? ) -> StrideThrough<Int>? 
//	where U: SDAI__INTEGER__type, V: SDAI__INTEGER__type {
//		guard let bound1 = bound1, 
//					let bound2 = bound2?.asSwiftType, 
//					let increment = increment?.asSwiftType 
//		else { return nil }
//		return stride(from: bound1, through: bound2, by: increment)
//	}
//	public static func FROM<T>(_ bound1: T?, TO bound2: Int?, BY increment: Int? ) -> StrideThrough<Int>? 
//	where T: SDAI__INTEGER__type {
//		guard let bound1 = bound1?.asSwiftType, 
//					let bound2 = bound2, 
//					let increment = increment 
//		else { return nil }
//		return stride(from: bound1, through: bound2, by: increment)
//	}
//	public static func FROM<U>(_ bound1: Int?, TO bound2: U?, BY increment: Int? ) -> StrideThrough<Int>? 
//	where U: SDAI__INTEGER__type {
//		guard let bound1 = bound1, 
//					let bound2 = bound2?.asSwiftType, 
//					let increment = increment 
//		else { return nil }
//		return stride(from: bound1, through: bound2, by: increment)
//	}
//	public static func FROM<V>(_ bound1: Int?, TO bound2: Int?, BY increment: V? ) -> StrideThrough<Int>? 
//	where V: SDAI__INTEGER__type {
//		guard let bound1 = bound1, 
//					let bound2 = bound2, 
//					let increment = increment?.asSwiftType 
//		else { return nil }
//		return stride(from: bound1, through: bound2, by: increment)
//	}
//	public static func FROM(_ bound1: Int?, TO bound2: Int?, BY increment: Int? ) -> StrideThrough<Int>? 
//	{
//		guard let bound1 = bound1, 
//					let bound2 = bound2, 
//					let increment = increment 
//		else { return nil }
//		return stride(from: bound1, through: bound2, by: increment)
//	}
//	
//	public static func FROM<T,U>(_ bound1: T?, TO bound2: U? ) -> StrideThrough<Int>? 
//	where T: SDAI__INTEGER__type, U: SDAI__INTEGER__type {
//		guard let bound1 = bound1?.asSwiftType, 
//					let bound2 = bound2?.asSwiftType 
//		else { return nil }
//		return stride(from: bound1, through: bound2, by: 1)
//	}
//	public static func FROM<T>(_ bound1: T?, TO bound2: Int? ) -> StrideThrough<Int>? 
//	where T: SDAI__INTEGER__type {
//		guard let bound1 = bound1?.asSwiftType, 
//					let bound2 = bound2 
//		else { return nil }
//		return stride(from: bound1, through: bound2, by: 1)
//	}
//	public static func FROM<U>(_ bound1: Int?, TO bound2: U? ) -> StrideThrough<Int>? 
//	where U: SDAI__INTEGER__type {
//		guard let bound1 = bound1, 
//					let bound2 = bound2?.asSwiftType 
//		else { return nil }
//		return stride(from: bound1, through: bound2, by: 1)
//	}
//	public static func FROM(_ bound1: Int?, TO bound2: Int? ) -> StrideThrough<Int>? 
//	{
//		guard let bound1 = bound1, 
//					let bound2 = bound2 
//		else { return nil }
//		return stride(from: bound1, through: bound2, by: 1)
//	}

}
