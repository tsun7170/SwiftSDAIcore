//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation

extension SDAI {
	//MARK: -
	public struct ComplexPair: Hashable {
		var l: ComplexEntity
		var r: ComplexEntity
	}
	
	public struct _ComplexEntityValue: SDAIValue
	{
		
		private let complexEntity: ComplexEntity
		
		// Equatable \Hashable\SDAIValue
		public static func == (lhs: _ComplexEntityValue, rhs: _ComplexEntityValue) -> Bool {
			return lhs.isValueEqual(to: rhs)
		}
		
		// Hashable \SDAIValue
		public func hash(into hasher: inout Hasher) {
			var visited: Set<ComplexEntity> = []
			complexEntity.hashAsValue(into: &hasher, visited: &visited)
		}
		
		// SDAIValue
		public func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool {
			guard let rhs = rhs as? Self else { return false }
			var visited: Set<ComplexPair> = []
			return self.complexEntity.isValueEqual(to: rhs.complexEntity, visited: &visited)
		}
		
		public func isValueEqualOptionally<T: SDAIValue>(to rhs: T?) -> Bool? {
			if rhs == nil { return nil }
			guard let rhs = rhs as? Self else { return false }
			var visited: Set<ComplexPair> = []
			return self.complexEntity.isValueEqualOptionally(to: rhs.complexEntity, visited: &visited)			
		}
		
	}
	
}
