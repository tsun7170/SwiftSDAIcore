//
//  SdaiObject.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/23.
//  Copyright © 2020 Minokamo, Japan. All rights reserved.
//

import Foundation

public protocol SDAIValue: Hashable
{
	func isValueEqual<T: SDAIValue>(to rhs: T) -> Bool
	func isValueEqualOptionally<T: SDAIValue>(to rhs: T?) -> Bool?
}
public extension SDAIValue
{
	func isValueEqualOptionally<T: SDAIValue>(to rhs: T?) -> Bool? {
		guard let rhs = rhs else { return nil }
		return self.isValueEqual(to: rhs)
	}
}

public protocol SDAIGenericType: Hashable 
{
	associatedtype Value: SDAIValue
	
	var typeMembers: Set<SDAI.STRING> {get}
	var value: Value {get}
}



public protocol SDAINamedType {
	
}





public protocol SDAIConstructedType: SDAIUnderlyingType 
{}

public protocol SDAIEnumerationType: SDAIConstructedType {
	
}
public protocol SDAISelectType: SDAIConstructedType {
	
}

//MARK: - SDAI namespace
public enum SDAI {
	
	public typealias EntityName = SDAIDictionarySchema.ExpressId

	public static let TRUE:LOGICAL = true
	public static let FALSE:LOGICAL = false
	public static let UNKNOWN:LOGICAL = nil
	
	
	
		
	
	
	public typealias ENUMERATION = Int
	
	
	
	
	
	
	
	
	
	
	
	
	
	

//MARK: - SDAI.Object	
	open class Object: Hashable {
		public static func == (lhs: SDAI.Object, rhs: SDAI.Object) -> Bool {
			return lhs === rhs
		}
		
		public func hash(into hasher: inout Hasher) {
			withUnsafePointer(to: self) { (p) -> Void in
				hasher.combine(p.hashValue)
			}
		}
	}
		

	//MARK: - PartialEntity
	open class PartialEntity: SDAI.Object {
		public typealias TypeIdentity = EntityName
		public class var typeIdentity: TypeIdentity { abstruct() }
		public class var entityName: EntityName { abstruct() }
		public class var qualifiedEntityName: EntityName { abstruct() }
		public var entityName: EntityName { abstruct() }
		public var qualifiedEntityName: EntityName { abstruct() }
		public var complexEntities: Set<ComplexEntity> { abstruct() }
		
		open func hashAsValue(into hasher: inout Hasher, visited complexEntities: inout Set<ComplexEntity>) {
			hasher.combine(Self.typeIdentity)
		}

		open func isValueEqual(to rhs: PartialEntity, visited comppairs: inout Set<ComplexPair>) -> Bool {
			return type(of: rhs) == Self.self
		}

		open func isValueEqualOptionally(to rhs: PartialEntity, visited comppairs: inout Set<ComplexPair>) -> Bool? {
			return type(of: rhs) == Self.self
		}
		
	}
	
	
	//MARK: - ComplexEntity
	open class ComplexEntity: SDAI.Object {
		private var partialEntities: Dictionary<PartialEntity.TypeIdentity,(instance:PartialEntity,reference:EntityReference?)> = [:]

		public init(entities:[PartialEntity]) {
			super.init()
			
			for pe in entities {
				partialEntities[type(of: pe).typeIdentity] = (instance:pe, reference:nil)	
			}
		}
		
		public func partialEntityInstance<PENT:PartialEntity>(_ peType:PENT.Type) -> PENT? {
			if let (pe,_) = partialEntities[peType.typeIdentity] {
				return pe as? PENT
			}
			return nil
		}
		
		public func resolvePartialEntityInstance(from namelist:[PartialEntity.TypeIdentity]) -> PartialEntity? {
			for typeIdentity in namelist {
				if let (pe,_) = partialEntities[typeIdentity] {
					return pe
				}
			}
			return nil
		}
		
		public func entityReference<EREF:EntityReference>(_ erType:EREF.Type) -> EREF? {
			if let (pe,eref) = partialEntities[erType.partialEntityType.typeIdentity] {
				if eref != nil { return eref as? EREF }
				
				if let eref = EREF(self) {
					partialEntities[erType.partialEntityType.typeIdentity] = (pe,eref)
					return eref
				}
			}
			return nil
		}
		
		public var roles: Set<STRING> { abstruct() }
		public func usedIn(role: String) -> [EntityReference] { abstruct() }
		
		
		// EntityReference SDAIGenericType support
		var typeMembers: Set<SDAI.STRING> { 
			Set( partialEntities.values.map{ (pe) -> STRING in STRING(pe.instance.qualifiedEntityName) } ) 
		}
		
		public typealias Value = _ComplexEntityValue
		var value: Value { abstruct() }

		func hashAsValue(into hasher: inout Hasher, visited complexEntities: inout Set<ComplexEntity>) {
			guard !complexEntities.contains(self) else { return }
			complexEntities.insert(self)
			for (pe,_) in partialEntities.values {
				pe.hashAsValue(into: &hasher, visited: &complexEntities)
			}
		}

		func isValueEqual(to rhs: ComplexEntity, visited comppairs: inout Set<ComplexPair>) -> Bool {
			if self === rhs { return true }
			let lr = ComplexPair(l: self, r: rhs)
			if comppairs.contains( lr ) { return true }
			if self.partialEntities.count != rhs.partialEntities.count { return false }
			
			comppairs.insert(lr)
			for (typeIdentity, (lpe,_)) in self.partialEntities {
				guard let (rpe,_) = rhs.partialEntities[typeIdentity] else { return false }
				if lpe === rpe { continue }
				if !lpe.isValueEqual(to: rpe, visited: &comppairs) { return false }
			}
			return true
		}
		
		func isValueEqualOptionally(to rhs: ComplexEntity?, visited comppairs: inout Set<ComplexPair>) -> Bool? {
			guard let rhs = rhs else{ return nil }
			if self === rhs { return true }
			let lr = ComplexPair(l: self, r: rhs)
			if comppairs.contains( lr ) { return true }
			if self.partialEntities.count != rhs.partialEntities.count { return false }
			
			comppairs.insert(lr)
			var isequal: Bool? = true
			for (typeIdentity, (lpe,_)) in self.partialEntities {
				guard let (rpe,_) = rhs.partialEntities[typeIdentity] else { return false }
				if lpe === rpe { continue }
				if let result = lpe.isValueEqualOptionally(to: rpe, visited: &comppairs), !result { return false }
				else { isequal = nil }
			}
			return isequal
		}
	}
	
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
	
	//MARK: - EntityReference
	open class EntityReference: SDAI.Object, SDAIGenericType {		
		public let complexEntity: ComplexEntity
		
		// SDAIGenericType
		public typealias Value = ComplexEntity.Value
		
		public var typeMembers: Set<STRING> { complexEntity.typeMembers }
		public var value: ComplexEntity.Value { complexEntity.value }


		// EntityReference specific
		public static var partialEntityType: PartialEntity.Type { abstruct() }
					
		
		public required init?(_ complexEntity: ComplexEntity) {
			self.complexEntity = complexEntity
			super.init()
		}
		
		public static func cast<EREF:EntityReference>( from source: EREF ) -> Self? {
			return source.complexEntity.entityReference(self)
		}
	}
	
}



