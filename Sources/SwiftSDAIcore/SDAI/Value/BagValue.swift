//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
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
			hasher.combine(hiIndex)
			elements.forEach { hasher.combine($0) }
		}
		
		// SDAIValue
		public func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool {
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
		
		private var asCountedSet: CountedSet {
			var cset = CountedSet(minimumCapacity: self.size)
			for e in self.elements {
				if let count = cset[e] { cset[e] = count + 1 }
				else { cset[e] = 1 }
			}
			return cset
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

