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
	open class PartialEntity: SDAIParameterDataSchema._PartialEntityBase {
		public typealias TypeIdentity = EntityName
		
		open class var entityReferenceType: EntityReference.Type { abstruct() }
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
	open class ComplexEntity: SDAIParameterDataSchema._ComplexEntityBase
	{
		private var _partialEntities: Dictionary<PartialEntity.TypeIdentity,(instance:PartialEntity,reference:EntityReference?)> = [:]
		
		public init(entities:[PartialEntity]) {
			super.init()
			
			for pe in entities {
				_partialEntities[type(of: pe).typeIdentity] = (instance:pe, reference:nil)	
			}
		}
		
		//MARK: partial entity access
		public var partialEntities: [PartialEntity] {
			_partialEntities.values.map{ (pe) in pe.instance }
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
		
		//MARK: entity reference access
		public var entityReferences: [EntityReference] {
			var result:[EntityReference] = []
			
			for pe in self.partialEntities {
				if let eref = self.entityReference(type(of: pe).entityReferenceType) {
					result.append(eref)
				}
			}
			return result
		}
		
		public func entityReference<EREF:EntityReference>(_ erefType:EREF.Type) -> EREF? {
			if let (pe,eref) = _partialEntities[erefType.partialEntityType.typeIdentity] {
				if eref != nil { return eref as? EREF }
				
				if let eref = EREF(complex:self) {
					_partialEntities[erefType.partialEntityType.typeIdentity] = (pe,eref)
					return eref
				}
			}
			return nil
		}
		
		//MARK: express built-in function support
		private func findRoles(in entity: SDAI.EntityReference) -> [SDAIAttributeType] {
			var roles:[SDAIAttributeType] = []
			let entityDef = entity.definition
			for (_, attrDef) in entityDef.attributes {
				guard let attrEntitySeq = attrDef.genericValue(for: entity)?.entityReferences else { continue }
				for attrEntity in attrEntitySeq {
					if self === attrEntity.complexEntity {
						roles.append(attrDef)
					}
				}
			}
			return roles
		}
		
		public var roles: Set<STRING> { 
			var result: Set<STRING> = []
			let model = self.owningModel
			let schemaInstance = model.defaultSchemaInstance
			for complex in schemaInstance.allComplexEntities {
				for entity in complex.entityReferences {
					result.formUnion( self.findRoles(in: entity).lazy.map{ (attrDef) in
						return STRING(attrDef.qualifiedAttributeName) 
					} )
				}
			}
			return result
		}
		
		public func usedIn() -> [EntityReference] { 
			var result: [EntityReference] = []
			let model = self.owningModel
			let schemaInstance = model.defaultSchemaInstance
			for complex in schemaInstance.allComplexEntities {
				for entity in complex.entityReferences {
					result.append(contentsOf: self.findRoles(in: entity).lazy.map{ _ in entity } )
				}
			}
			return result
		}
		
		public func usedIn<ENT:EntityReference, R:SDAIGenericType>(as role: KeyPath<ENT,R>) -> [ENT] { 
			var result: [ENT] = []
			let model = self.owningModel
			let schemaInstance = model.defaultSchemaInstance
			for complex in schemaInstance.allComplexEntities {
				guard let entity = complex.entityReference(ENT.self) else { continue }
				let attr = SDAI.GENERIC( entity[keyPath: role] )
				for attrEntity in attr.entityReferences {
					if self === attrEntity.complexEntity {
						result.append(entity)
					}
				}
			}
			return result
		}
		
		public func usedIn<ENT:EntityReference, R:SDAIGenericType>(as role: KeyPath<ENT,R?>) -> [ENT] { 
			var result: [ENT] = []
			let model = self.owningModel
			let schemaInstance = model.defaultSchemaInstance
			for complex in schemaInstance.allComplexEntities {
				guard let entity = complex.entityReference(ENT.self) else { continue }
				guard let attr = SDAI.GENERIC( entity[keyPath: role] ) else { continue }
				for attrEntity in attr.entityReferences {
					if self === attrEntity.complexEntity {
						result.append(entity)
					}
				}
			}
			return result
		}

		public var typeMembers: Set<SDAI.STRING> { 
			Set( _partialEntities.values.map{ (peTuple) -> STRING in STRING(stringLiteral: peTuple.instance.qualifiedEntityName) } ) 
		}
		
		public typealias Value = _ComplexEntityValue
		public var value: Value { _ComplexEntityValue(self) }

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
		
		//MARK: where rule validation support
		public func validateEntityWhereRules(prefix:SDAI.WhereLabel) -> [SDAI.WhereLabel:SDAI.LOGICAL] {
			var result: [SDAI.WhereLabel:SDAI.LOGICAL] = [:]
			for (pe,_) in _partialEntities.values {
				if let eref = self.entityReference(type(of: pe).entityReferenceType) {
					let peResult = type(of: eref).validateWhereRules(instance:eref, prefix: prefix + "\\" + pe.entityName, excludingEntity: false)
					result.merge(peResult) { $0 && $1 }
				}
			}
			return result
		}

	}
	
	
	//MARK: - EntityReference (8.3.1)
	open class EntityReference: SDAIParameterDataSchema.ApplicationInstance, SDAINamedType,
															SDAIGenericType, InitializableByEntity, SDAIObservableAggregateElement 
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

		open class func validateWhereRules(instance:SDAI.EntityReference?, prefix:SDAI.WhereLabel, excludingEntity: Bool) -> [SDAI.WhereLabel:SDAI.LOGICAL] {
			var result: [SDAI.WhereLabel:SDAI.LOGICAL] = [:]
			guard !excludingEntity, let instance = instance else { return result }
			
			for (attrname, attrdef) in self.entityDefinition.attributes {
				let attrval = attrdef.genericValue(for: instance)
				let attrresult = SDAI.GENERIC.validateWhereRules(instance: attrval, prefix: prefix + "." + attrname, excludingEntity: true)
				result.merge(attrresult) { $0 && $1 }
			}
			return result
		}

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

