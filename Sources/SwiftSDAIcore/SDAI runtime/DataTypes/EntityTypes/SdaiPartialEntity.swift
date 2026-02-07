//
//  SdaiPartialEntity.swift
//  
//
//  Created by Yoshida on 2021/05/08.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAI {
	
	
	//MARK: - PartialEntity
  /// `PartialEntity` is an abstract superclass representing a fundamental, incomplete
  /// building block of an entity in the SDAI (Standard Data Access Interface) framework.
  /// 
  /// This class is designed to be subclassed by concrete entity types, and cannot be 
  /// instantiated directly. It provides essential reflection, identity, and comparison 
  /// behaviors common to all entity types, as well as support for exchange structure 
  /// decoding, dynamic attribute management, and complex entity aggregation.
  /// 
  /// - Note: This class conforms to `CustomStringConvertible` for debugging and logging,
  ///   and is marked `@unchecked Sendable` to allow subclassing for concurrent use, 
  ///   though concrete subclasses should ensure their own safety.
  /// 
  /// - Key Responsibilities:
  ///   - Declares core type and identity properties for entity reflection and schema
  ///     integration.
  ///   - Provides initializers for abstract usage, copying, and exchange structure decoding.
  ///   - Supplies customizable mechanisms for hashing, equality, and optional equality
  ///     required by value semantics in complex entities.
  ///   - Offers hooks for notification when a partial entity is added to or removed from
  ///     a complex entity aggregation.
  ///   - Exposes a method to allow subclasses to fix up attributes when complex entities
  ///     are composed or derived.
  /// 
  /// Subclasses must define concrete implementations for the abstract properties and 
  /// behaviors, particularly the static `entityReferenceType` property.
  ///
	open class PartialEntity: SDAI.Object, CustomStringConvertible, @unchecked Sendable
	{
		public typealias TypeIdentity = SDAIDictionarySchema.EntityDefinition
		
		public init(asAbstractSuperclass:()) {
			assert(type(of:self) != PartialEntity.self, "abstract class instantiated")
		}
		
		public required convenience init?(
			parameters: [P21Decode.ExchangeStructure.Parameter],
			exchangeStructure: P21Decode.ExchangeStructure)
		{
			self.init(asAbstractSuperclass:())
		}

		public required convenience init(from original:SDAI.PartialEntity)
		{
			self.init(asAbstractSuperclass:())
		}

		//MARK: CustomStringConvertible
		public var description: String {
			var str = "\(self.qualifiedEntityName)\n"
			
			let mirror = Mirror(reflecting: self)
			for child in mirror.children {
				str += "\t\(child.label ?? "<unnamed>"): \t\(child.value)\n"
			}
			
			return str			
		}
		
		//MARK: class properties
		open class var entityReferenceType: EntityReference.Type { abstract() } // abstruct
		
		public class var typeIdentity: TypeIdentity { 
			return self.entityReferenceType.entityDefinition 
		}
		public class var entityDefinition: SDAIDictionarySchema.EntityDefinition {
			return self.entityReferenceType.entityDefinition 
		}
		public class var entityName: EntityName { 
			return self.entityReferenceType.entityDefinition.name 
		}
		public class var qualifiedEntityName: EntityName { 
			return self.entityReferenceType.entityDefinition.qualifiedEntityName 
		}
		public class var typeName: String { self.qualifiedEntityName }
		
		//MARK: instance properties
		public var entityName: EntityName {
			return type(of: self).entityName
		}
		public var qualifiedEntityName: EntityName { 
			return type(of: self).qualifiedEntityName
		}
		open var typeMembers: Set<SDAI.STRING> { [] }

		
		open func hashAsValue(into hasher: inout Hasher, visited complexEntities: inout Set<ComplexEntity>) {
			hasher.combine(Self.typeIdentity)
		}
		
		open func isValueEqual(to rhs: PartialEntity, visited comppairs: inout Set<ComplexPair>) -> Bool {
			return type(of: rhs) == Self.self
		}
		
		open func isValueEqualOptionally(to rhs: PartialEntity, visited comppairs: inout Set<ComplexPair>) -> Bool? {
			return type(of: rhs) == Self.self
		}
		
		//MARK: attribute observer support
		open func broadcast(addedToComplex complex: ComplexEntity) {
		}
		open func broadcast(removedFromComplex complex: ComplexEntity) {
		}
		
		//MARK: dynamic attribute support
		open class func fixupPartialComplexEntityAttributes(partialComplex: SDAI.ComplexEntity, baseComplex: SDAI.ComplexEntity) {}
	}
	
}
