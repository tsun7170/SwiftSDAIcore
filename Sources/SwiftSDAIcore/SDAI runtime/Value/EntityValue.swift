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

  /// A structure representing a pair of complex entities, typically used to track relationships or comparisons between two complex entity instances.
  ///
  /// `ComplexPair` is commonly employed in algorithms that require keeping track of visited pairs of entities, such as in recursive comparison or hashing implementations, to prevent infinite loops or redundant computations.
  ///
  /// - Parameters:
  ///   - l: The left-hand side complex entity of the pair.
  ///   - r: The right-hand side complex entity of the pair.
	public struct ComplexPair: Hashable {
		public let l: ComplexEntity
		public let r: ComplexEntity
	}
	
	public struct _ComplexEntityValue: SDAI.Value
	{
		
		private let complexEntity: ComplexEntity
		public init(_ complex: ComplexEntity) {
			self.complexEntity = complex
		}
		
		// Equatable \Hashable\SDAI.Value
		public static func == (lhs: _ComplexEntityValue, rhs: _ComplexEntityValue) -> Bool {
			return lhs.isValueEqual(to: rhs)
		}
		
		// Hashable \SDAI.Value
		public func hash(into hasher: inout Hasher) {
			var visited = Set<ComplexEntity>()
			self.hashAsValue(into: &hasher, visited: &visited)
		}
		
		// SDAI.Value
		public func isValueEqual<T: SDAI.Value>(to rhs: T) -> Bool {
			var visited = Set<ComplexPair>()
			return self.isValueEqual(to: rhs, visited: &visited)
		}
		
		public func isValueEqualOptionally<T: SDAI.Value>(to rhs: T?) -> Bool? {
			var visited = Set<ComplexPair>()
			return self.isValueEqualOptionally(to: rhs, visited: &visited)
		}

		public func hashAsValue(into hasher: inout Hasher, visited complexEntities: inout Set<SDAI.ComplexEntity>) {
			complexEntity.hashAsValue(into: &hasher, visited: &complexEntities)
		}
		
		public func isValueEqual<T: SDAI.Value>(to rhs: T, visited comppairs: inout Set<SDAI.ComplexPair>) -> Bool {
			guard let rhs = rhs as? Self else { return false }
			return self.complexEntity.isValueEqual(to: rhs.complexEntity, visited: &comppairs)
		}
		
		public func isValueEqualOptionally<T: SDAI.Value>(to rhs: T?, visited comppairs: inout Set<SDAI.ComplexPair>) -> Bool? {
			if rhs == nil { return nil }
			guard let rhs = rhs as? Self else { return false }
			return self.complexEntity.isValueEqualOptionally(to: rhs.complexEntity, visited: &comppairs)			
		}
		
	}
	
}
