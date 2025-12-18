//
//  SdaiPersistentEntityReference.swift
//  SwiftSDAIcore
//
//  Created by Yoshida on 2025/10/01.
//

import Foundation

extension SDAI {
	//MARK: - persistent entity reference
	@dynamicMemberLookup
	public final class PersistentEntityReference<EREF>:
		SDAIPersistentReference,
		InitializableByComplexEntity,
		SDAIEntityReferenceYielding
	where EREF: SDAI.EntityReference & SDAIDualModeReference & InitializableByP21Parameter
	{
		// SDAIPersistentReference
		public typealias ARef = EREF

		public var aRef: EREF { self.instance }

		public var optionalARef: EREF? { self.optionalInstance }




    private typealias ComplexEntityID = SDAIPopulationSchema.SdaiModel.ComplexEntityID
    private typealias SDAIModelID = SDAIPopulationSchema.SdaiModel.SDAIModelID


		private enum ComplexEntityReference: Hashable, CustomStringConvertible
    {
      case persistent(complexID: ComplexEntityID, modelID: SDAIModelID)
			case temporary(EREF?)

      var description: String {
        switch self {
          case .persistent(let complexID, let modelID):
            return "#\(complexID)_m\(modelID)"
            
          case .temporary(let eREF):
            if let eREF {
              return "\(eREF.complexEntity.qualifiedName)(temporary)"
            }
            else {
              return "(nil)"
            }
        }
      }
		}

		private let complexReference: ComplexEntityReference
    
    /// initialize persistent entity reference from a optional entity reference
    /// - Parameter entityRef: optional entity reference
		public init(_ entityRef: EREF?) {
			guard let entityRef else {
				self.complexReference = .temporary(nil)
				return
			}

			let complexEntity = entityRef.complexEntity
			let owningModel = complexEntity.owningModel

			if complexEntity.isTemporary {
				self.complexReference = .temporary(entityRef)
			}
      else {
        let complexID = complexEntity.p21name
        let modelID = owningModel.modelID

        self.complexReference =
          .persistent(complexID: complexID, modelID: modelID)
      }
		}

		public convenience init?<OTHER>(_ pref: PersistentEntityReference<OTHER>?)
		where OTHER: SDAI.EntityReference & SDAIDualModeReference
		{
			let complex = pref?.eval?.complexEntity
			self.init(complex)
		}

		public convenience init?(_ complex: SDAI.ComplexEntity?)
		{
			let eref = complex?.entityReference(EREF.self)
			self.init(eref)
		}

		public convenience init?(_ genericERef: GENERIC_ENTITY?)
		{
			let complex = genericERef?.complexEntity
			self.init(complex)
		}


		public static func cast<OTHER>(
			from source: PersistentEntityReference<OTHER>?) -> Self?
		where OTHER: EntityReference & SDAIDualModeReference
		{
			Self.init(source)
		}



		public var eval: EREF? { self.optionalInstance }

    private func resolveComplexEntity(
      complexID: ComplexEntityID,
      modelID: SDAIModelID ) -> ComplexEntity?
    {
      guard
        let session = SDAISessionSchema.activeSession
      else { return nil }

      if let complex = session.activeTransaction?
        .lookupComplexCache(complexID: complexID, modelID: modelID) {
        return complex
      }

      guard
        let model = session.findAndActivateSdaiModel(modelID: modelID),
        let complex = model.contents.complexEntity(named: complexID)
      else { return nil }

      return complex
    }

		public var optionalInstance: EREF? {
			switch self.complexReference {
				case .persistent(let complexID, let modelID):
					guard
            let complex = self.resolveComplexEntity(
              complexID: complexID, modelID: modelID)
					else { return nil }

					let eref = complex.entityReference(EREF.self)
					return eref

				case .temporary(let eREF):
					return eREF
			}
		}

		public var instance: EREF {
			switch self.complexReference {
        case .persistent(let complexID, let modelID):
					guard
            let complex = self.resolveComplexEntity(
              complexID: complexID, modelID: modelID)
					else {
						SDAI.raiseErrorAndTrap(.SY_ERR, detail:"can not locate complex entity:#\(complexID) of model:\(modelID) under session:\(String(describing: SDAISessionSchema.activeSession))")
					}

					guard let eref = complex.entityReference(EREF.self)
					else {
						SDAI.raiseErrorAndTrap(.EI_NEXS, detail: "entity reference:\(EREF.self) not found in complex:\(complexID)")
					}
					return eref

				case .temporary(let eREF):
					guard let eref = eREF
					else {
						SDAI.raiseErrorAndTrap(.EI_NEXS, detail: "nil entity reference:\(EREF.self)")
					}
					return eref
			}
		}

		public var complexEntity: ComplexEntity? {
			self.eval?.complexEntity
		}

		public var asGenericEntityReference: GENERIC_ENTITY? {
			self.eval
		}

		// Equatable
		public static func == (
			lhs:PersistentEntityReference, rhs:PersistentEntityReference ) -> Bool
		{
			guard
				lhs.complexReference == rhs.complexReference
			else { return false }
			return true
		}

		// Hashable
		public func hash(into hasher: inout Hasher) {
			hasher.combine(complexReference)
		}

		// dynamic member lookup
		public subscript<T>(dynamicMember keyPath: KeyPath<EREF, T>) -> T? {
			guard let entity = self.eval else { return nil }
			let result = entity[keyPath: keyPath]
      return result
		}

		public subscript<T>(dynamicMember keyPath: KeyPath<EREF, T?>) -> T? {
			guard let entity = self.eval else { return nil }
			let result = entity[keyPath: keyPath]
      return result
		}

		public subscript<U>(dynamicMember keyPath: WritableKeyPath<EREF, U>) -> U? {
			get {
				guard let entity = self.eval else { return nil }
				let result = entity[keyPath: keyPath]
        return result
			}
			set {
				guard var entity = self.eval,
							let newValue = newValue
				else { return }
				entity[keyPath: keyPath] = newValue
			}
		}

		public subscript<U>(dynamicMember keyPath: WritableKeyPath<EREF, U?>) -> U? {
			get {
				guard let entity = self.eval else { return nil }
				let result = entity[keyPath: keyPath]
        return result
			}
			set {
				guard var entity = self.eval
				else { return }
				entity[keyPath: keyPath] = newValue
			}
		}



		// group reference
		public func GROUP_REF<SUPER:EntityReference & SDAIDualModeReference>(
			_ super_ref: SUPER.Type
		) -> SUPER.PRef?
		{
			guard let complex = self.eval?.complexEntity else { return nil }
      let result = complex.entityReference(super_ref)?.pRef
      return result
		}

		// InitializableByComplexEntity
		public convenience init?(possiblyFrom complex: SDAI.ComplexEntity?) {
			self.init(complex)
		}

		// InitializableByGenericType
		public convenience init?<G: SDAIGenericType>(fromGeneric generic: G?) {
			if let pref = generic as? Self {
				self.init(pref)
			}
      else if let eref = generic as? EREF {
        self.init(eref)
      }
      else if let entity = generic as? SDAI.EntityReference {
        let complex = entity.complexEntity
        let eref = complex.entityReference(EREF.self)
        self.init(eref)
			}
      else {
        return nil
      }
		}

		public class func convert<G: SDAIGenericType>(fromGeneric generic: G?) -> Self? {
			guard let eref = EREF.convert(fromGeneric: generic) else { return nil }
			return self.init(eref)
		}

		// InitializableByP21Parameter
		public static var bareTypeName: String {
			EREF.bareTypeName
		}

		public convenience init?(
			p21untypedParam: P21Decode.ExchangeStructure.UntypedParameter,
			from exchangeStructure: P21Decode.ExchangeStructure)
		{
			guard let eref = EREF.init(
				p21untypedParam: p21untypedParam,
				from: exchangeStructure)
			else { return nil }

			self.init(eref)
		}

		public convenience init?(
			p21omittedParamfrom exchangeStructure: P21Decode.ExchangeStructure)
		{
			guard let eref = EREF.init(p21omittedParamfrom: exchangeStructure)
			else { return nil }

			self.init(eref)
		}

		// SDAICacheableSource
		public var isCacheable: Bool { true }

		// SDAIGenericType
		public func copy() -> Self
		{
			self
		}

		public typealias FundamentalType = EREF.FundamentalType

		public var asFundamentalType: FundamentalType {
			self.instance.asFundamentalType
		}

		public convenience init(fundamental other: FundamentalType)
		{
//			debugPrint("\(#function): Self:\(EREF.self), FundamentalType: \(FundamentalType.self)")
			let eref = EREF(fundamental: other)
			self.init(eref)
		}

		public static var typeName: String { EREF.typeName }

    public var typeMembers: Set<SDAI.STRING> {
      guard let eref = self.eval else { return [] }
      let result = eref.typeMembers
      return result
    }

		public var value: some SDAIValue {
			self.instance.value
		}

		public var entityReference: SDAI.EntityReference?  {self.optionalInstance}
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

		public static func validateWhereRules(
			instance:SDAI.PersistentEntityReference<EREF>?,
			prefix:SDAIPopulationSchema.WhereLabel
		) -> SDAIPopulationSchema.WhereRuleValidationRecords
		{
			EREF.validateWhereRules(instance: instance?.eval, prefix: prefix)
		}

		// SDAIEntityReferenceYielding
		public var entityReferences: AnySequence<SDAI.EntityReference> {
			self.eval?.entityReferences ?? AnySequence()
		}

		public func isHolding(entityReference: SDAI.EntityReference) -> Bool {
			self.eval?.isHolding(entityReference: entityReference) ?? false
		}
	}//struct


}//SDAI

extension SDAI.PersistentEntityReference
where EREF: SDAISimpleEntityType
{
	public convenience init?(_ partial: EREF.SimplePartialEntity?)
	{
		guard
			let partial = partial,
			let eref = EREF.init(partial) else { return nil }
		self.init(eref)
	}

}

extension SDAI.PersistentEntityReference: InitializableByVoid
where EREF: InitializableByVoid
{
  public convenience init() {
    let eref = EREF()
    self.init(eref)
  }
}

extension SDAI.PersistentEntityReference: CustomStringConvertible
{
  public var description: String {
    return "\(EREF.entityDefinition.name).PRef=> \(self.complexReference)"
  }
}

