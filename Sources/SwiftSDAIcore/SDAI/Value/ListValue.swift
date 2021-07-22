//
//  ListValue.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
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
			var visited = Set<SDAI.ComplexEntity>()
			self.hashAsValue(into: &hasher, visited: &visited)
		}
		
		// SDAIValue
		public func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool {
			var visited = Set<SDAI.ComplexPair>()
			return self.isValueEqual(to: rhs, visited: &visited)
		}

		public func hashAsValue(into hasher: inout Hasher, visited complexEntities: inout Set<SDAI.ComplexEntity>) {
			hiIndex.hash(into: &hasher)
			elements.forEach { $0.hashAsValue(into: &hasher, visited: &complexEntities) }
		}
		
		public func isValueEqual<T: SDAIValue>(to rhs: T, visited comppairs: inout Set<SDAI.ComplexPair>) -> Bool {
			guard let rav = rhs as? Self else { return false }
			if rav.hiIndex != self.hiIndex { return false }

			return self.elements.elementsEqual(rav.elements) { (le, re) -> Bool in
				return le.isValueEqual(to: re, visited: &comppairs)
			}
		}
		
		public func isValueEqualOptionally<T: SDAIValue>(to rhs: T?, visited comppairs: inout Set<SDAI.ComplexPair>) -> Bool? {
			guard let rhs = rhs else { return nil }
			return self.isValueEqual(to: rhs, visited: &comppairs)
		}

		// _ListValue specific
		init(from list: LIST<ELEMENT>) {
			hiIndex = list.hiIndex
			elements = AnySequence( list.lazy.map{ $0.value } )
		}
	}
}

