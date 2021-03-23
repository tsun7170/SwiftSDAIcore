//
//  SdaiEntity.swift
//  
//
//  Created by Yoshida on 2020/10/18.
//

import Foundation


extension SDAI {
	
	public typealias EntityName = SDAIDictionarySchema.ExpressId

	
	//MARK: - PartialEntity
	open class PartialEntity: SDAI.Object {
		public typealias TypeIdentity = EntityName
		public class var typeIdentity: TypeIdentity { abstruct() }
		public class var entityName: EntityName { abstruct() }
		public class var qualifiedEntityName: EntityName { abstruct() }
		public var entityName: EntityName { abstruct() }
		public var qualifiedEntityName: EntityName { abstruct() }
		public var complexEntities: Set<ComplexEntity> { abstruct() }
		
		public override init() { abstruct() }
		
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
	open class ComplexEntity: SDAI.Object//, SDAIGenericType 
	{
		public var partialEntities: [PartialEntity] {
			_partialEntities.values.map{ (pe) in pe.instance }
		}
		private var _partialEntities: Dictionary<PartialEntity.TypeIdentity,(instance:PartialEntity,reference:EntityReference?)> = [:]
		
		public init(entities:[PartialEntity]) {
			super.init()
			
			for pe in entities {
				_partialEntities[type(of: pe).typeIdentity] = (instance:pe, reference:nil)	
			}
		}
		
		public func partialEntityInstance<PENT:PartialEntity>(_ peType:PENT.Type) -> PENT? {
			if let (pe,_) = _partialEntities[peType.typeIdentity] {
				return pe as? PENT
			}
			return nil
		}
		
		public func resolvePartialEntityInstance(from namelist:[PartialEntity.TypeIdentity]) -> PartialEntity? {
			for typeIdentity in namelist {
				if let (pe,_) = _partialEntities[typeIdentity] {
					return pe
				}
			}
			return nil
		}
		
		public func entityReference<EREF:EntityReference>(_ erType:EREF.Type) -> EREF? {
			if let (pe,eref) = _partialEntities[erType.partialEntityType.typeIdentity] {
				if eref != nil { return eref as? EREF }
				
				if let eref = EREF(complex:self) {
					_partialEntities[erType.partialEntityType.typeIdentity] = (pe,eref)
					return eref
				}
			}
			return nil
		}
		
		public var roles: Set<STRING> { abstruct() }
		public func usedIn<ENT:EntityReference>(entity:ENT.Type, attr: String) -> [ENT] { abstruct() }
		public func usedIn() -> [EntityReference] { abstruct() }

		public var typeMembers: Set<SDAI.STRING> { 
			Set( _partialEntities.values.map{ (pe) -> STRING in STRING(stringLiteral: pe.instance.qualifiedEntityName) } ) 
		}
		
		public typealias Value = _ComplexEntityValue
		public var value: Value { abstruct() }

		func hashAsValue(into hasher: inout Hasher, visited complexEntities: inout Set<ComplexEntity>) {
			guard !complexEntities.contains(self) else { return }
			complexEntities.insert(self)
			for (pe,_) in _partialEntities.values {
				pe.hashAsValue(into: &hasher, visited: &complexEntities)
			}
		}
		
		func isValueEqual(to rhs: ComplexEntity, visited comppairs: inout Set<ComplexPair>) -> Bool {
			// per (12.2.1.7)
			if self === rhs { return true }
			let lr = ComplexPair(l: self, r: rhs)
			let rl = ComplexPair(l: rhs, r: self)
			if comppairs.contains( lr ) { return true }
			if self._partialEntities.count != rhs._partialEntities.count { return false }
			
			comppairs.insert(lr); comppairs.insert(rl)
			for (typeIdentity, (lpe,_)) in self._partialEntities {
				guard let (rpe,_) = rhs._partialEntities[typeIdentity] else { return false }
				if lpe === rpe { continue }
				if !lpe.isValueEqual(to: rpe, visited: &comppairs) { return false }
			}
			return true
		}
		
		func isValueEqualOptionally(to rhs: ComplexEntity?, visited comppairs: inout Set<ComplexPair>) -> Bool? {
			// per (12.2.1.7)
			guard let rhs = rhs else{ return nil }
			if self === rhs { return true }
			let lr = ComplexPair(l: self, r: rhs)
			let rl = ComplexPair(l: rhs, r: self)
			if comppairs.contains( lr ) { return true }
			if self._partialEntities.count != rhs._partialEntities.count { return false }
			
			comppairs.insert(lr); comppairs.insert(rl)
			var isequal: Bool? = true
			for (typeIdentity, (lpe,_)) in self._partialEntities {
				guard let (rpe,_) = rhs._partialEntities[typeIdentity] else { return false }
				if lpe === rpe { continue }
				if let result = lpe.isValueEqualOptionally(to: rpe, visited: &comppairs), !result { return false }
				else { isequal = nil }
			}
			return isequal
		}
	}
	
	
	//MARK: - EntityReference
	open class EntityReference: SDAI.ObjectReference<ComplexEntity>, SDAIGenericType, InitializableByEntity, SDAIObservableAggregateElement 
	{		
		public var complexEntity: ComplexEntity {self.object}
		
		// SDAIGenericType
		public typealias Value = ComplexEntity.Value
		public typealias FundamentalType = EntityReference
		
		public var asFundamentalType: FundamentalType { return self }	

		public var typeMembers: Set<STRING> { complexEntity.typeMembers }
		public var value: ComplexEntity.Value { complexEntity.value }
		
		public var entityReference: SDAI.EntityReference? { self }	
		public var stringValue: SDAI.STRING? {nil}
		public var binaryValue: SDAI.BINARY? {nil}
		public var logicalValue: SDAI.LOGICAL? {nil}
		public var booleanValue: SDAI.BOOLEAN? {nil}
		public var numberValue: SDAI.NUMBER? {nil}
		public var realValue: SDAI.REAL? {nil}
		public var integerValue: SDAI.INTEGER? {nil}
		public var genericEnumValue: SDAI.GenericEnumValue? {nil}

		public func arrayOptionalValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY_OPTIONAL<ELEM>? {nil}
		public func arrayValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>? {nil}
		public func listValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.LIST<ELEM>? {nil}
		public func bagValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.BAG<ELEM>? {nil}
		public func setValue<ELEM:SDAIGenericType>(elementType:ELEM.Type) -> SDAI.SET<ELEM>? {nil}
		public func enumValue<ENUM:SDAIEnumerationType>(enumType:ENUM.Type) -> ENUM? {nil}

		// SDAIObservableAggregateElement
		public var entityReferences: AnySequence<SDAI.EntityReference> { 
			AnySequence<SDAI.EntityReference>(CollectionOfOne<SDAI.EntityReference>(self))
		}

		
		// EntityReference specific
		public static var partialEntityType: PartialEntity.Type { abstruct() }
		
		
		public required init?(complex complexEntity: ComplexEntity?) {
			guard let complexEntity = complexEntity else { return nil }
			super.init(object: complexEntity)
		}
		
		// SDAI.GENERIC_ENTITY
		public init(_ entityRef: EntityReference) {
			super.init(object: entityRef.complexEntity)
		}
		public convenience init?(_ entityRef: EntityReference?) {
			guard let entityRef = entityRef else { return nil }
			self.init(entityRef)
		}
		
		// InitializableByGenerictype
		required public convenience init?<G: SDAIGenericType>(fromGeneric generic: G?) {
			guard let entityRef = generic?.entityReference else { return nil }
			self.init(complex: entityRef.complexEntity)
		}
		
		public static func cast<EREF:EntityReference>( from source: EREF? ) -> Self? {
			return source?.complexEntity.entityReference(self)
		}
	}
}

