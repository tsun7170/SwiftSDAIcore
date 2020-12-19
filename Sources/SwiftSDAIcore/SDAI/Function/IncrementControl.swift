//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation

extension SDAI {
	public static func FROM<T,U,V>(_ bound1: T?, TO bound2: U?, BY increment: V? ) -> StrideThrough<Int>? 
	where T: SDAI__INTEGER__type, U: SDAI__INTEGER__type, V: SDAI__INTEGER__type {
		guard let bound1 = bound1?.asSwiftType, 
					let bound2 = bound2?.asSwiftType, 
					let increment = increment?.asSwiftType 
		else { return nil }
		return stride(from: bound1, through: bound2, by: increment)
	}
	public static func FROM<T,U>(_ bound1: T?, TO bound2: U?, BY increment: Int? ) -> StrideThrough<Int>? 
	where T: SDAI__INTEGER__type, U: SDAI__INTEGER__type {
		guard let bound1 = bound1?.asSwiftType, 
					let bound2 = bound2?.asSwiftType, 
					let increment = increment 
		else { return nil }
		return stride(from: bound1, through: bound2, by: increment)
	}
	public static func FROM<T,V>(_ bound1: T?, TO bound2: Int?, BY increment: V? ) -> StrideThrough<Int>? 
	where T: SDAI__INTEGER__type, V: SDAI__INTEGER__type {
		guard let bound1 = bound1?.asSwiftType, 
					let bound2 = bound2, 
					let increment = increment?.asSwiftType 
		else { return nil }
		return stride(from: bound1, through: bound2, by: increment)
	}
	public static func FROM<U,V>(_ bound1: Int?, TO bound2: U?, BY increment: V? ) -> StrideThrough<Int>? 
	where U: SDAI__INTEGER__type, V: SDAI__INTEGER__type {
		guard let bound1 = bound1, 
					let bound2 = bound2?.asSwiftType, 
					let increment = increment?.asSwiftType 
		else { return nil }
		return stride(from: bound1, through: bound2, by: increment)
	}
	public static func FROM<T>(_ bound1: T?, TO bound2: Int?, BY increment: Int? ) -> StrideThrough<Int>? 
	where T: SDAI__INTEGER__type {
		guard let bound1 = bound1?.asSwiftType, 
					let bound2 = bound2, 
					let increment = increment 
		else { return nil }
		return stride(from: bound1, through: bound2, by: increment)
	}
	public static func FROM<U>(_ bound1: Int?, TO bound2: U?, BY increment: Int? ) -> StrideThrough<Int>? 
	where U: SDAI__INTEGER__type {
		guard let bound1 = bound1, 
					let bound2 = bound2?.asSwiftType, 
					let increment = increment 
		else { return nil }
		return stride(from: bound1, through: bound2, by: increment)
	}
	public static func FROM<V>(_ bound1: Int?, TO bound2: Int?, BY increment: V? ) -> StrideThrough<Int>? 
	where V: SDAI__INTEGER__type {
		guard let bound1 = bound1, 
					let bound2 = bound2, 
					let increment = increment?.asSwiftType 
		else { return nil }
		return stride(from: bound1, through: bound2, by: increment)
	}
	public static func FROM(_ bound1: Int?, TO bound2: Int?, BY increment: Int? ) -> StrideThrough<Int>? 
	{
		guard let bound1 = bound1, 
					let bound2 = bound2, 
					let increment = increment 
		else { return nil }
		return stride(from: bound1, through: bound2, by: increment)
	}
	
	public static func FROM<T,U>(_ bound1: T?, TO bound2: U? ) -> StrideThrough<Int>? 
	where T: SDAI__INTEGER__type, U: SDAI__INTEGER__type {
		guard let bound1 = bound1?.asSwiftType, 
					let bound2 = bound2?.asSwiftType 
		else { return nil }
		return stride(from: bound1, through: bound2, by: 1)
	}
	public static func FROM<T>(_ bound1: T?, TO bound2: Int? ) -> StrideThrough<Int>? 
	where T: SDAI__INTEGER__type {
		guard let bound1 = bound1?.asSwiftType, 
					let bound2 = bound2 
		else { return nil }
		return stride(from: bound1, through: bound2, by: 1)
	}
	public static func FROM<U>(_ bound1: Int?, TO bound2: U? ) -> StrideThrough<Int>? 
	where U: SDAI__INTEGER__type {
		guard let bound1 = bound1, 
					let bound2 = bound2?.asSwiftType 
		else { return nil }
		return stride(from: bound1, through: bound2, by: 1)
	}
	public static func FROM(_ bound1: Int?, TO bound2: Int? ) -> StrideThrough<Int>? 
	{
		guard let bound1 = bound1, 
					let bound2 = bound2 
		else { return nil }
		return stride(from: bound1, through: bound2, by: 1)
	}

}
