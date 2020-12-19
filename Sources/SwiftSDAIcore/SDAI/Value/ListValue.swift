//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation

//MARK: - Value comparison support
extension SDAI {
	public struct _ListValue<ELEMENT: SDAIGenericType>: SDAIValue
	{
		typealias ElementValue = ELEMENT.Value

		var hiIndex: Int
		var size: Int { hiIndex }
		var elements: AnySequence<ElementValue>
		
		// Equatable \Hashable\SDAIValue
		public static func == (lhs: _ListValue<ELEMENT>, rhs: _ListValue<ELEMENT>) -> Bool {
			return lhs.isValueEqual(to: rhs)
		}
		
		// Hashable \SDAIValue
		public func hash(into hasher: inout Hasher) {
			hasher.combine(hiIndex)
			elements.forEach { hasher.combine($0) }
		}
		
		// SDAIValue
		public func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool {
			guard let rav = rhs as? Self else { return false }
			if rav.hiIndex != self.hiIndex { return false }

			return self.elements.elementsEqual(rav.elements) { (le, re) -> Bool in
				return le.isValueEqual(to: re)
			}
		}

		// _ListValue specific
		init(from list: LIST<ELEMENT>) {
			hiIndex = list.hiIndex
			elements = AnySequence( list.lazy.map{ $0.value } )
		}
	}
}

