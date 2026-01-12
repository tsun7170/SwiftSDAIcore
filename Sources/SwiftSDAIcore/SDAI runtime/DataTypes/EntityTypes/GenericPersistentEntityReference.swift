//
//  GenericPersistentEntityReference.swift
//  SwiftSDAIcore
//
//  Created by Yoshida on 2025/12/25.
//

import Foundation

extension SDAI {

  public class GenericPersistentEntityReference: @unchecked Sendable,
  SDAI.GenericType,
  Hashable, CustomStringConvertible
  {
    internal let complexReference: ComplexEntityReference

    private let hashed: Int

    //MARK: CustomStringConvertible
    public var description: String {
      return "SDAI.GENERIC_ENTITY.PRef=> \(self.complexReference)"
    }

    //MARK: Initializers
    public init(_ complexRef: ComplexEntityReference)
    {
      var hasher = Hasher()
      hasher.combine(complexRef)
      self.hashed = hasher.finalize()
      self.complexReference = complexRef
    }

    public convenience init(_ entityRef: EntityReference?)
    {
      let complexRef = ComplexEntityReference(entityRef)
      self.init(complexRef)
    }

    public convenience init?(_ complex: SDAI.ComplexEntity?)
    {
      let eref = complex?.entityReference(EntityReference.self)
      self.init(eref)
    }

    //MARK: Hashable
    public func hash(into hasher: inout Hasher)
    {
      hasher.combine(self.hashed)
    }

    //MARK: Equatable
    public static func == (
      lhs:GenericPersistentEntityReference,
      rhs:GenericPersistentEntityReference ) -> Bool
    {
      guard
        lhs.complexReference == rhs.complexReference
      else { return false }
      return true
    }

    //MARK: dereferencing operations
    internal func resolveComplexEntity(
      complexID: ComplexEntityID,
      modelID: SDAIModelID ) -> ComplexEntity?
    {
      guard let session = SDAISessionSchema.activeSession
      else {
        SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "can not access SDAISessionSchema.activeSession")
        return nil
      }

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

    public var owningModel: SDAIPopulationSchema.SdaiModel? {
      switch self.complexReference {
        case .persistent(_, let modelID):
          guard let session = SDAISessionSchema.activeSession
          else {
            SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "can not access SDAISessionSchema.activeSession")
            return nil
          }

          if let model = session.activeTransaction?.lookupModelCache(modelID: modelID) {
            return model
          }

          guard let model = session.findAndActivateSdaiModel(modelID: modelID)
          else {
            SDAI.raiseErrorAndContinue(.MO_NEXS, detail: "SdaiModel with id:\(modelID) does not exist")
            return nil
          }
          return model

        case .temporary(let eREF):
          let model = eREF?.owningModel
          return model
      }//switch
    }

    internal var modelID: SDAIModelID? {
      switch self.complexReference {
        case .persistent(_, let modelID):
          return modelID

        case .temporary(let eREF):
          let modelID = eREF?.owningModel.modelID
          return modelID
      }//switch
    }

    public var complexEntity: ComplexEntity? {
      switch self.complexReference {
        case .persistent(let complexID, let modelID):
          let complex = self.resolveComplexEntity(
            complexID: complexID, modelID: modelID)
          return complex

        case .temporary(let eREF):
          return eREF?.complexEntity
      }
    }

    public var asGenericEntityReference: EntityReference? {
      switch self.complexReference {
        case .persistent(let complexID, let modelID):
          guard
            let complex = self.resolveComplexEntity(
              complexID: complexID, modelID: modelID)
          else { return nil }

          let eref = complex.entityReference(Self.ERefType.self)
          return eref

        case .temporary(let eREF):
          return eREF
      }
    }

    public var temporaryEntityReference: EntityReference? {
      guard case .temporary(let eREF) = self.complexReference
      else { return nil }
      return eREF
    }

    //MARK: SDAICacheableSource
    public var isCacheable: Bool {
      switch self.complexReference {
        case .persistent:
          return true

        case .temporary:
          return false
      }
    }

    //MAREK: InitializableByGenericType
    public required convenience init?<G: SDAI.GenericType>(fromGeneric generic: G?) {
      if let pref = generic as? Self {
        self.init(pref.complexReference)
      }
      else if let eref = generic as? EntityReference {
        self.init(eref)
      }
      else {
        return nil
      }
    }

    public class func convert<G: SDAI.GenericType>(fromGeneric generic: G?) -> Self?
    {
      guard let eref = ERefType.convert(fromGeneric: generic) else { return nil }

      let converted = self.init(fundamental: eref)
      return converted
    }

    //MARK: InitializableByP21Parameter
    public class var bareTypeName: String {
      ERefType.bareTypeName
    }

    public required convenience init?(
      p21untypedParam: P21Decode.ExchangeStructure.UntypedParameter,
      from exchangeStructure: P21Decode.ExchangeStructure)
    {
      guard let eref = Self.ERefType.init(
        p21untypedParam: p21untypedParam,
        from: exchangeStructure)
      else { return nil }

      self.init(eref)
    }

    public required convenience init?(
      p21omittedParamfrom exchangeStructure: P21Decode.ExchangeStructure)
    {
      guard let eref = Self.ERefType.init(p21omittedParamfrom: exchangeStructure)
      else { return nil }

      self.init(eref)
    }


    //MARK: SDAI.GenericType
    public func copy() -> Self
    {
      self
    }

    public typealias FundamentalType = EntityReference//EREF.FundamentalType

    public var asFundamentalType: FundamentalType {
      //      self.instance.asFundamentalType
      self.asGenericEntityReference!
    }

    public required convenience init(fundamental eref: FundamentalType)
    {
      self.init(eref)
    }

    public class var ERefType: EntityReference.Type { EntityReference.self }
    public class var typeName: String { ERefType.typeName }

    public var typeMembers: Set<SDAI.STRING> {
      guard let complex = self.complexEntity else { return [] }
      let result = complex.typeMembers
      return result
    }

    public var value: some SDAIValue {
      self.complexEntity!.value
    }

    public var entityReference: SDAI.EntityReference?  {self.asGenericEntityReference}
    public var stringValue: SDAI.STRING? {nil}
    public var binaryValue: SDAI.BINARY? {nil}
    public var logicalValue: SDAI.LOGICAL? {nil}
    public var booleanValue: SDAI.BOOLEAN? {nil}
    public var numberValue: SDAI.NUMBER? {nil}
    public var realValue: SDAI.REAL? {nil}
    public var integerValue: SDAI.INTEGER? {nil}
    public var genericEnumValue: SDAI.GenericEnumValue? {nil}

    public func arrayOptionalValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.ARRAY_OPTIONAL<ELEM>? {nil}
    public func arrayValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.ARRAY<ELEM>? {nil}
    public func listValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.LIST<ELEM>? {nil}
    public func bagValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.BAG<ELEM>? {nil}
    public func setValue<ELEM:SDAI.GenericType>(elementType:ELEM.Type) -> SDAI.SET<ELEM>? {nil}
    public func enumValue<ENUM:SDAI.EnumerationType>(enumType:ENUM.Type) -> ENUM? {nil}

    public static func validateWhereRules(
      instance: SDAI.GenericPersistentEntityReference?,
      prefix: SDAIPopulationSchema.WhereLabel
    ) -> SDAIPopulationSchema.WhereRuleValidationRecords
    {
      Self.ERefType.validateWhereRules(instance: instance?.asGenericEntityReference, prefix: prefix)
    }

  }//class
}//extension
