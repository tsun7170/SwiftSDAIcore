//
//  SdaiEntity.swift
//  
//
//  Created by Yoshida on 2020/10/18.
//

import Foundation


extension SDAI {
	
	public typealias EntityName = SDAIDictionarySchema.ExpressId

	
	//MARK: - EntityReference (8.3.1)
	open class EntityReference: SDAI.UnownedReference<SDAI.ComplexEntity>, SDAINamedType,
															SDAIGenericType, InitializableByEntity, SDAIObservableAggregateElement 
	{		
		public var complexEntity: ComplexEntity {self.object}
		
		//MARK: - (9.4.2)
		public unowned var owningModel: SDAIPopulationSchema.SdaiModel { return self.object.owningModel }
		public var definition: SDAIDictionarySchema.EntityDefinition { return Self.entityDefinition }
		
		public static let entityDefinition: SDAIDictionarySchema.EntityDefinition = createEntityDefinition()
		open class func createEntityDefinition() -> SDAIDictionarySchema.EntityDefinition { abstruct() }	// abstruct

		//MARK: - (9.4.3)
		public var persistentLabel: SDAIParameterDataSchema.STRING { 
			let p21name = self.object.p21name
			return "\(self.owningModel.name)#\(p21name)" 
		}

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
		open class var partialEntityType: PartialEntity.Type { abstruct() }	// abstruct
		
		public required init?(complex complexEntity: ComplexEntity?) {
			guard let complexEntity = complexEntity else { return nil }
			super.init(complexEntity)
		}
		
		// SDAI.GENERIC_ENTITY
		public init(_ entityRef: EntityReference) {
			super.init(entityRef.complexEntity)
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
		
		// InitializableByP21Parameter
		public static var bareTypeName: String { "GENERIC_ENTITY" }
		
	}
}

