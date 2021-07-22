//
//  EntityValue.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
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
		public init(_ complex: ComplexEntity) {
			self.complexEntity = complex
		}
		
		// Equatable \Hashable\SDAIValue
		public static func == (lhs: _ComplexEntityValue, rhs: _ComplexEntityValue) -> Bool {
			return lhs.isValueEqual(to: rhs)
		}
		
		// Hashable \SDAIValue
		public func hash(into hasher: inout Hasher) {
			var visited = Set<ComplexEntity>()
			self.hashAsValue(into: &hasher, visited: &visited)
		}
		
		// SDAIValue
		public func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool {
			var visited = Set<ComplexPair>()
			return self.isValueEqual(to: rhs, visited: &visited)
		}
		
		public func isValueEqualOptionally<T: SDAIValue>(to rhs: T?) -> Bool? {
			var visited = Set<ComplexPair>()
			return self.isValueEqualOptionally(to: rhs, visited: &visited)
		}

		public func hashAsValue(into hasher: inout Hasher, visited complexEntities: inout Set<SDAI.ComplexEntity>) {
			complexEntity.hashAsValue(into: &hasher, visited: &complexEntities)
		}
		
		public func isValueEqual<T: SDAIValue>(to rhs: T, visited comppairs: inout Set<SDAI.ComplexPair>) -> Bool {
			guard let rhs = rhs as? Self else { return false }
			return self.complexEntity.isValueEqual(to: rhs.complexEntity, visited: &comppairs)
		}
		
		public func isValueEqualOptionally<T: SDAIValue>(to rhs: T?, visited comppairs: inout Set<SDAI.ComplexPair>) -> Bool? {
			if rhs == nil { return nil }
			guard let rhs = rhs as? Self else { return false }
			return self.complexEntity.isValueEqualOptionally(to: rhs.complexEntity, visited: &comppairs)			
		}
		
	}
	
}
