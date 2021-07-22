//
//  BagValue.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - Value comparison support
extension SDAI {
	public struct _BagValue<ELEMENT: SDAIGenericType>: SDAIValue
	{
		typealias ElementValue = ELEMENT.Value
		typealias CountedSet = Dictionary<ElementValue,Int>

		var hiIndex: Int
		var size: Int { hiIndex }
		var elements: AnySequence<ElementValue>
		
		// Equatable \Hashable\SDAIValue
		public static func == (lhs: _BagValue<ELEMENT>, rhs: _BagValue<ELEMENT>) -> Bool {
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
		
		private var asCountedSet: CountedSet {
			var cset = CountedSet(minimumCapacity: self.size)
			for e in self.elements {
				if let count = cset[e] { cset[e] = count + 1 }
				else { cset[e] = 1 }
			}
			return cset
		}

		public func hashAsValue(into hasher: inout Hasher, visited complexEntities: inout Set<SDAI.ComplexEntity>) {
			hiIndex.hash(into: &hasher)
			elements.forEach { $0.hashAsValue(into: &hasher, visited: &complexEntities) }
		}
		
		public func isValueEqual<T: SDAIValue>(to rhs: T, visited comppairs: inout Set<SDAI.ComplexPair>) -> Bool {
			guard let rav = rhs as? Self else { return false }
			if rav.hiIndex != self.hiIndex { return false }

			var cset = self.asCountedSet
			for re in rav.elements {
				if let lcount = cset[re] {
					if lcount > 1 { cset[re] = lcount - 1 }
					else { cset[re] = nil }
				}
				else { return false }
			}
			return cset.isEmpty
		}
		
		public func isValueEqualOptionally<T: SDAIValue>(to rhs: T?, visited comppairs: inout Set<SDAI.ComplexPair>) -> Bool? {
			guard let rhs = rhs else { return nil }
			return self.isValueEqual(to: rhs, visited: &comppairs)
		}

		
		// _BagValue specific
		init(from bag: BAG<ELEMENT>) {
			hiIndex = bag.hiIndex
			elements = AnySequence( bag.lazy.map{ $0.value } )
		}

		init(from set: SET<ELEMENT>) {
			hiIndex = set.hiIndex
			elements = AnySequence( set.lazy.map{ $0.value } )
		}
	}
}

