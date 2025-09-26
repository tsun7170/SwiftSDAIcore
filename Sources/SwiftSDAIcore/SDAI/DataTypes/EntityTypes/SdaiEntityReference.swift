//
//  SdaiEntityReference.swift
//  
//
//  Created by Yoshida on 2020/10/18.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import Synchronization

//MARK: - SDAIEntityReferenceType
public protocol SDAIEntityReferenceType {
	var complexEntity: SDAI.ComplexEntity {get}
	init?(complex complexEntity: SDAI.ComplexEntity?)
}

public extension SDAIEntityReferenceType {
	typealias FundamentalType = Self

	var asFundamentalType: FundamentalType { 
		return self 
	}	

	init(fundamental: FundamentalType) {
		self.init(complex: fundamental.complexEntity)!
	}

}





extension SDAI {
	public typealias EntityName = SDAIDictionarySchema.ExpressId
	public typealias AttributeName = SDAIDictionarySchema.ExpressId


	//MARK: - EntityReference (8.3.1, ISO 10303-11)
	open class EntityReference: SDAI.UnownedReference<SDAI.ComplexEntity>,
															SDAINamedType, SDAIEntityReferenceType, SDAIGenericType,
															InitializableByEntity,
//															SDAIObservableAggregateElement,
															SDAIEntityReferenceYielding,
															SdaiCacheHolder,
															CustomStringConvertible,
															@unchecked Sendable
	{
		// SDAIEntityReferenceType
		public var complexEntity: ComplexEntity {self.object}
		
		public required init?(complex complexEntity: ComplexEntity?) {
			guard let complexEntity = complexEntity else { return nil }
			super.init(complexEntity)
			assert(type(of:self) != EntityReference.self, "abstract class instantiated")
			if !complexEntity.registerEntityReference(self) { return nil }
		}
		
		//CustomStringConvertible
		public var description: String {
			var str = "\(self.definition.name)-> \(self.complexEntity.qualifiedName)"
			if self.complexEntity.isPartial {
				str += "(partial)"
			}
			if self.complexEntity.isTemporary {
				str += "(temporary)" 
			}
			return str
		}
		
		
		//MARK: - (9.4.2, ISO 10303-22)
		public unowned var owningModel: SDAIPopulationSchema.SdaiModel { return self.object.owningModel }

		public var definition: SDAIDictionarySchema.EntityDefinition { return type(of: self).entityDefinition }
		
		open class var entityDefinition: SDAIDictionarySchema.EntityDefinition {
			abstract()
		}

		//MARK: - (9.4.3, ISO 10303-22)
		public var persistentLabel: SDAIParameterDataSchema.StringValue {
			let p21name = self.object.p21name
			return "\(self.owningModel.name)#\(p21name)" 
		}

		// SdaiCachableSource
		public var isCacheable: Bool {
			let complex = self.complexEntity
			if complex.isTemporary { return false }
	
			let model = self.owningModel
			return model.mode == .readOnly
		}
		
		// SDAIGenericType
		public typealias Value = ComplexEntity.Value

		public func copy() -> Self { return self }
		public class var typeName: String { self.entityDefinition.qualifiedEntityName }
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


		// validation related
		open class func validateWhereRules(
			instance:SDAI.EntityReference?,
			prefix:SDAIPopulationSchema.WhereLabel
		) -> SDAIPopulationSchema.WhereRuleValidationRecords
		{
			var result: SDAIPopulationSchema.WhereRuleValidationRecords = [:]
			guard let instance = instance
			else { return result }

			for (attrname, attrdef) in type(of:instance).entityDefinition.attributes {
				if (attrdef.domain as Any) is SDAI.EntityReference { continue }
				
				let attrval = attrdef.genericValue(for: instance)
				let attrresult = SDAI.GENERIC.validateWhereRules(
					instance: attrval, 
					prefix: prefix + " ." + attrname + "\\" + attrdef.bareTypeName)
				result.merge(attrresult) { $0 && $1 }
			}
			return result
		}

		// SDAIObservableAggregateElement, SDAIEntityReferenceYielding
		public final var entityReferences: AnySequence<SDAI.EntityReference> {
			AnySequence( CollectionOfOne<SDAI.EntityReference>(self) )
		}

//		public final func configure(with observer: SDAI.EntityReferenceObserver) {}
//		public final func teardownObserver() {}

		public final func isHolding(
			entityReference: SDAI.EntityReference
		) -> Bool
		{
			return self == entityReference
		}

		// EntityReference specific
		open class var partialEntityType: PartialEntity.Type { abstract() }	// abstract

		nonisolated(unsafe)
		internal var retainer: ComplexEntity? = nil // for temporary complex entity lifetime control

		internal func unify(
			with other:EntityReference
		)
		{
			self.derivedAttributeCache = other.derivedAttributeCache
		}

		// group reference
		public func GROUP_REF<EREF:EntityReference>(
			_ entity_ref: EREF.Type
		) -> EREF?
		{
			let complex = self.complexEntity
			return complex.partialComplexEntity(entity_ref)
		} 

		//MARK: inverse attribute support
		public func referencingEntities<SourceEntity,AttributeValue>(
			for attribute: KeyPath<SourceEntity,AttributeValue>
		) -> some Collection<SourceEntity>
		where SourceEntity: EntityReference,
					AttributeValue: SDAIEntityReferenceYielding
		{
			guard let session = SDAISessionSchema.activeSession else {
				SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "can not access SDAISessionSchema.activeSession")
				return []
			}

			let activeInstances = Set(session.activeSchemaInstances)
			let associatedInstances = self.complexEntity.owningModel.associatedWith

			for schemaInstance in associatedInstances {
				guard activeInstances.contains(schemaInstance)
				else { continue }

				let sources = schemaInstance.entityExtent(type: SourceEntity.self)

				let referencing = sources.flatMap{ source in
					let attributeValue = source[keyPath: attribute]

					return attributeValue.entityReferences.compactMap{
						if $0.complexEntity == self.complexEntity { return source }
						else { return nil }
					}
				}

				if !referencing.isEmpty { return referencing }
			}

			return []
		}


		public func referencingEntities<SourceEntity,AttributeValue>(
			for attribute: KeyPath<SourceEntity,AttributeValue?>
		) -> some Collection<SourceEntity>
		where SourceEntity: EntityReference,
					AttributeValue: SDAIEntityReferenceYielding
		{
			guard let session = SDAISessionSchema.activeSession else {
				SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "can not access SDAISessionSchema.activeSession")
				return []
			}

			let activeInstances = Set(session.activeSchemaInstances)
			let associatedInstances = self.complexEntity.owningModel.associatedWith

			for schemaInstance in associatedInstances {
				guard activeInstances.contains(schemaInstance)
				else { continue }

				let sources = schemaInstance.entityExtent(type: SourceEntity.self)

				let referencing = sources.flatMap{ source in
					guard let attributeValue = source[keyPath: attribute]
					else { return Array<SourceEntity>() }

					return attributeValue.entityReferences.compactMap{
						if $0.complexEntity == self.complexEntity { return source }
						else { return nil }
					}
				}

				if !referencing.isEmpty { return referencing }
			}

			return []
		}

		public func referencingEntity<SourceEntity,AttributeValue>(
			for attribute: KeyPath<SourceEntity,AttributeValue>
		) -> SourceEntity?
		where SourceEntity: EntityReference,
					AttributeValue: SDAIEntityReferenceYielding
		{
			guard let session = SDAISessionSchema.activeSession else {
				SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "can not access SDAISessionSchema.activeSession")
				return nil
			}

			let activeInstances = Set(session.activeSchemaInstances)
			let associatedInstances = self.complexEntity.owningModel.associatedWith

			for schemaInstance in associatedInstances {
				guard activeInstances.contains(schemaInstance)
				else { continue }

				let sources = schemaInstance.entityExtent(type: SourceEntity.self)

				for source in sources {
					let attributeValue = source[keyPath: attribute]
					
					if Set( attributeValue
						.entityReferences.map{$0.complexEntity} )
						.contains(self.complexEntity)
					{
						return source
					}
				}
			}

			return nil
		}

		public func referencingEntity<SourceEntity,AttributeValue>(
			for attribute: KeyPath<SourceEntity,AttributeValue?>
		) -> SourceEntity?
		where SourceEntity: EntityReference,
					AttributeValue: SDAIEntityReferenceYielding
		{
			guard let session = SDAISessionSchema.activeSession else {
				SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "can not access SDAISessionSchema.activeSession")
				return nil
			}

			let activeInstances = Set(session.activeSchemaInstances)
			let associatedInstances = self.complexEntity.owningModel.associatedWith

			for schemaInstance in associatedInstances {
				guard activeInstances.contains(schemaInstance)
				else { continue }

				let sources = schemaInstance.entityExtent(type: SourceEntity.self)

				for source in sources {
					guard let attributeValue = source[keyPath: attribute]
					else { continue }
					
					if Set( attributeValue
						.entityReferences.map{$0.complexEntity} )
						.contains(self.complexEntity)
					{
						return source
					}
				}
			}

			return nil
		}

		//MARK: SdaiCacheHolder related
		public func notifyApplicationDomainChanged(
			relatedTo schemaInstance: SDAIPopulationSchema.SchemaInstance
		)
		{
			self.resetCache()
		}

		public func notifyReadWriteModeChanged(
			sdaiModel: SDAIPopulationSchema.SdaiModel
		)
		{
			//NOOP
		}


		// derived attribute value caching
		public struct CachedValue: Sendable {
			public let value: (any Sendable)?

			fileprivate init(_ value: (some Sendable)?) {
				self.value = value
			}
		}

		nonisolated(unsafe)
		private var derivedAttributeCache: MutexReference<[AttributeName:CachedValue]> = MutexReference([:])

		public func cachedValue(
			derivedAttributeName: AttributeName
		) -> CachedValue?
		{
			let result = derivedAttributeCache.withLock{ $0[derivedAttributeName] }
			return result
		}
		
		public func updateCache(
			derivedAttributeName: AttributeName,
			value: (some Sendable)?
		)
		{
			guard self.complexEntity.owningModel.mode == .readOnly else { return }

			derivedAttributeCache.withLock{ $0[derivedAttributeName] = CachedValue(value) }
		}
		
		public func resetCache()
		{
			derivedAttributeCache.withLock{ $0 = [:] }
		}
		
		// InitializableByGenericType
		required public convenience init?<G: SDAIGenericType>(fromGeneric generic: G?) {
			guard let entityRef = generic?.entityReference else { return nil }
			self.init(complex: entityRef.complexEntity)
		}
		
		public class func convert<G: SDAIGenericType>(fromGeneric generic: G?) -> Self? {
			guard let generic = generic else { return nil }
			
			if let entityref = generic.entityReference {
				if let sametype = entityref as? Self {
					return sametype
				}
				return self.cast(from: entityref)
			}
			return nil
		}

		public static func cast<EREF:EntityReference>(
			from source: EREF?
		) -> Self?
		{
			return source?.complexEntity.entityReference(self)
		}
		
		// InitializableByP21Parameter
		public static var bareTypeName: String { self.entityDefinition.name }
		
		// SDAI entity instance operations
		public var allAttributes: AttributeList {
			return AttributeList(entity: self)
		}
		
	}
}

