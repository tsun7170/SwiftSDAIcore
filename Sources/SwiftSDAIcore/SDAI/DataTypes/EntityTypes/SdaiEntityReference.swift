//
//  SdaiEntityReference.swift
//  
//
//  Created by Yoshida on 2020/10/18.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

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

	
	//MARK: - EntityReference (8.3.1)
	open class EntityReference: SDAI.UnownedReference<SDAI.ComplexEntity>, CustomStringConvertible,
															SDAINamedType, SDAIEntityReferenceType, SDAIGenericType, InitializableByEntity, SDAIObservableAggregateElement 
	{		
		// SDAIEntityReferenceType
		public var complexEntity: ComplexEntity {self.object}
		
		public required init?(complex complexEntity: ComplexEntity?) {
			guard let complexEntity = complexEntity else { return nil }
			super.init(complexEntity)
			assert(type(of:self) != EntityReference.self, "abstruct class instantiated")	
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
		
		
		//MARK: - (9.4.2)
		public unowned var owningModel: SDAIPopulationSchema.SdaiModel { return self.object.owningModel }
		public var definition: SDAIDictionarySchema.EntityDefinition { return type(of: self).entityDefinition }
		
		open class var entityDefinition: SDAIDictionarySchema.EntityDefinition {
			abstruct()
		}

		//MARK: - (9.4.3)
		public var persistentLabel: SDAIParameterDataSchema.STRING { 
			let p21name = self.object.p21name
			return "\(self.owningModel.name)#\(p21name)" 
		}

		// SdaiCachableSource
		public var isCachable: Bool {
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
//		private var _validated = ValueReference(notValidatedYet)
//		public internal(set) var validated: ValidationRound {
//			get { _validated.value }
//			set { _validated.value = newValue }
//		}
		
		open class func validateWhereRules(instance:SDAI.EntityReference?, prefix:SDAI.WhereLabel) -> [SDAI.WhereLabel:SDAI.LOGICAL] {
			var result: [SDAI.WhereLabel:SDAI.LOGICAL] = [:]
			guard let instance = instance//, instance.validated != round 
			else { return result }
//			instance.validated = round
			
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

		// SDAIObservableAggregateElement
		public final var entityReferences: AnySequence<SDAI.EntityReference> { 
			AnySequence<SDAI.EntityReference>(CollectionOfOne<SDAI.EntityReference>(self))
		}

		public final func configure(with observer: SDAI.EntityReferenceObserver) {}
		public final func teardownObserver() {}

		
		// EntityReference specific
		open class var partialEntityType: PartialEntity.Type { abstruct() }	// abstruct
		
		internal var retainer: ComplexEntity? = nil // for temporary complex entity lifetime control

		internal func unify(with other:EntityReference) {
//			self._validated = other._validated
			self.derivedAttributeCache = other.derivedAttributeCache
		}

		// group reference
		public func GROUP_REF<EREF:EntityReference>(_ entity_ref: EREF.Type) -> EREF? {
			let complex = self.complexEntity
			return complex.partialComplexEntity(entity_ref)
		} 
		
		// derived attribute value caching
		public struct CachedValue {
			public private(set) var value: Any?
			fileprivate init(_ value: Any?) {
				self.value = value
			}
		}
		
		private var derivedAttributeCache: ValueReference<[SDAIDictionarySchema.ExpressId:CachedValue]> = ValueReference([:])
		
		public func cachedValue(derivedAttributeName:SDAIDictionarySchema.ExpressId) -> CachedValue? {
			let result = derivedAttributeCache.value[derivedAttributeName]
			return result
		}
		
		public func updateCache(derivedAttributeName:SDAIDictionarySchema.ExpressId, value:Any?) {
			guard self.complexEntity.owningModel.mode == .readOnly else { return }
			derivedAttributeCache.value[derivedAttributeName] = CachedValue(value)
		}
		
		public func resetCache() {
			derivedAttributeCache.value = [:]
		}
		
		// InitializableByGenerictype
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

		public static func cast<EREF:EntityReference>( from source: EREF? ) -> Self? {
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

