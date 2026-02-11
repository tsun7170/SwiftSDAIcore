//
//  10.11 Application instance operations.swift
//  SwiftSDAIcore
//
//  Created by Yoshida on 2025/09/04.
//

import Foundation

extension SDAISessionSchema.SdaiTransaction {

  /// ISO 10303-22 (10.11.7) Get session identifier
  /// 
  /// This operation returns the session identifier for the application instance referenced by the specified persistent label.
  ///
  /// - Parameters:
  ///   - label: The persistent label for Object.
  ///   - repository: The repository where the application instance referenced by Label exists.
  /// - Returns: The application instance whose persistent label is Label.
  ///
  /// - defined in: ``SDAISessionSchema/SdaiTransaction``
  ///
  public func getSessionIdentifier(
    label: SDAIParameterDataSchema.StringValue,
    repository: SDAISessionSchema.SdaiRepository
  ) -> SDAI.EntityReference?
  {
    guard let session = self.owningSession else {
      SDAI.raiseErrorAndContinue(.SS_NOPN, detail: "An SDAI session is not open.")
      return nil
    }

    guard
      let sep = label.firstIndex(of: Character("#")),
      let modelID = SDAI.SDAIModelID(
        uuidString: String(label.prefix(upTo: sep)) ),
      let p21name = SDAI.ComplexEntityID(label.suffix(from: sep).dropFirst())
    else {
      SDAI.raiseErrorAndContinue(.EI_NEXS, detail: "corrupted label[\(label)]")
      return nil
    }

    guard
      Set(repository.session).contains(session)
    else {
      SDAI.raiseErrorAndContinue(.RP_NOPN(repository), detail: "repository is not open")
      return nil
    }

    guard
      let _ = repository.contents.findSdaiModel(withID: modelID)
    else {
      SDAI.raiseErrorAndContinue(.EI_NEXS, detail: "SDAI-model[\(modelID)] does not exist in repository[\(repository)]")
      return nil
    }

    guard
    let model = session.findAndActivateSdaiModel(modelID: modelID),
    let complex = model.contents.complexEntity(named: p21name)
    else {
      SDAI.raiseErrorAndContinue(.EI_NEXS, detail: "complex entity[#\(p21name)] does not exist in model[\(modelID)]")
      return nil
    }
    let eref = complex.entityReference(SDAI.GENERIC_ENTITY.self)
    return eref
  }


  /// ISO 10303-22 (10.11.9) Validate where rule, (10.11.11)(10.11.13)(10.11.14)(10.11.16)(10.11.17)
  ///
  /// Validates the where rules for the specified application instance.
  ///
  /// This operation checks the where rules (entity local rules and defined type constraints) defined for the provided application instance and returns the result as where rule validation records.
  /// This operation also checks the value domain constrains for all attribute values for the specified application instance.
  ///
  /// To perform the validation for one specific where rule on a given object, use the code snippet listed below:
  /// ```swift
  ///       let object: some SDAI.EntityReference
  ///       let result: SDAI.LOGICAL =
  ///       type(of: object.partialEntity)
  ///       .WHERE_wrNN(SELF: object.pRef)
  /// ```
  ///
  /// - Parameters:
  ///   - object: The application instance whose where rules are to be validated.
  ///   - option: The option specifying whether and how the validation results should be recorded.
  /// - Returns: The validation records for the evaluated where rules.
  ///
  /// - SeeAlso: ``SDAIPopulationSchema/ValidationRecordingOption``, ``SDAIPopulationSchema/WhereRuleValidationRecords``
  ///
  /// - defined in: ``SDAISessionSchema/SdaiTransaction``
  ///
  public func validateWhereRules(
    object: SDAIParameterDataSchema.ApplicationInstance,
    recording option: SDAIPopulationSchema.ValidationRecordingOption
  ) -> SDAIPopulationSchema.WhereRuleValidationRecords
  {
    let result = object.complexEntity.validateEntityWhereRules(
      prefix: "",
      recording: option)
    return result
  }


}//SdaiTransaction
