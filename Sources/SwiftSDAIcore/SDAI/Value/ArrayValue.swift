//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation

//MARK: - Value comparison support
extension SDAI {
	public struct _ArrayValue<ELEMENT: SDAIGenericType>: SDAIValue
	{
		typealias ElementValue = ELEMENT.Value
		
		var loIndex: Int
		var hiIndex: Int
		var size: Int { hiIndex - loIndex + 1 }
		var elements: AnySequence<ElementValue?>
		
		// Equatable \Hashable\SDAIValue
		public static func == (lhs: _ArrayValue<ELEMENT>, rhs: _ArrayValue<ELEMENT>) -> Bool {
			return lhs.isValueEqual(to: rhs)
		}
		
		// Hashable \SDAIValue
		public func hash(into hasher: inout Hasher) {
			hasher.combine(loIndex)
			hasher.combine(hiIndex)
			elements.forEach { hasher.combine($0) }
		}
		
		// SDAIValue
		public func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool {
			guard let rav = rhs as? Self else { return false }
			if rav.loIndex != self.loIndex || rav.hiIndex != self.hiIndex { return false }

			return self.elements.elementsEqual(rav.elements) { (le, re) -> Bool in
				guard let le = le else { return re == nil }
				guard let re = re else { return false }
				return le.isValueEqual(to: re)
			}
		}
		
		public func isValueEqualOptionally<T: SDAIValue>(to rhs: T?) -> Bool? {
			guard let rhs = rhs else { return nil }
			guard let rav = rhs as? Self else { return false }
			if rav.loIndex != self.loIndex || rav.hiIndex != self.hiIndex { return false }

			var result: Bool? = true
			let riter = rav.elements.makeIterator()
			for le in self.elements {
				let re = riter.next()
				if let le = le, let re = re, let eeq = le.isValueEqualOptionally(to: re), !eeq { return false }
				else { result = nil }
			}
			return result
		}

		// _ArrayValue specific
		init(from array: ARRAY_OPTIONAL<ELEMENT>) {
			loIndex = array.loIndex
			hiIndex = array.hiIndex
			elements = AnySequence( array.lazy.map{ $0?.value } )
		}
		
		init(from array: ARRAY<ELEMENT>) {
			loIndex = array.loIndex
			hiIndex = array.hiIndex
			elements = AnySequence( array.lazy.map{ $0.value } )
		}
		
	}
}
