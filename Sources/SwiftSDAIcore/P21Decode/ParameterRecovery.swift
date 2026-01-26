//
//  ParameterRecovery.swift
//  
//
//  Created by Yoshida on 2021/05/08.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension P21Decode.ExchangeStructure {
	
	/// data structure containing the result of parameter value recovery
	public enum ParameterRecoveryResult<T> {
		case success(T)
		case failure
		
		/// usage example of ParameterRecoveryResult type. this example demonstrate the usage of ParameterRecoveryResult to recover an expected REAL type value from a given parameter specification
		/// - Parameters:
		///   - parameter: parameter specification
		///   - exchangeStructure: exchange structure to ask for the parameter recovery
		/// - Returns: recovered REAL type value when recovery operation is successful
		private static func usage(parameter: Parameter, exchangeStructure: P21Decode.ExchangeStructure) -> SDAI.REAL {
			guard case .success(let recovered) = exchangeStructure.recoverRequiredParameter(as: SDAI.REAL.self, from: parameter)
			else { fatalError() }
			return recovered
		}
	}
	
	
 /// Recovers a required entity attribute value of a specified type from a given parameter specification.
  ///
  /// This function attempts to retrieve and convert the provided parameter into a value of the specified type.
  /// If the parameter is missing, omitted, or cannot be converted to the desired type, the function either returns
  /// `.failure` or falls back to the type’s default initializer if available (when the type conforms to
  /// `SDAI.Initializable.ByVoid`). Error context may be recorded within the current `ExchangeStructure` context
  /// to facilitate debugging and validation.
  ///
  /// - Parameters:
  ///   - type: The expected type of the entity attribute, conforming to `SDAI.GenericType` (and optionally `SDAI.Initializable.ByVoid`).
  ///   - parameter: The parameter specification from which the value should be recovered.
  ///
  /// - Returns: A `ParameterRecoveryResult` containing the recovered value on success, or `.failure` if recovery fails.
  /// - Note: If the value is missing and a default initializer is available, that default value will be returned and an error will be recorded.
  /// - Warning: If conversion fails or the parameter is explicitly omitted, appropriate error states may be set or logged internally.
	public func recoverRequiredParameter<T: SDAI.GenericType>(
		as type: T.Type,
		from parameter: Parameter
	) -> ParameterRecoveryResult<T>
	{
    return _recoverRequiredParameter(
      as: type,
      from: parameter,
      fallback: nil)
	}

  /// Recovers a required entity attribute value of a specified type from a given parameter specification.
  ///
  /// - Parameters:
  ///   - type: The expected type of the entity attribute, conforming to `SDAI.GenericType`.
  ///   - parameter: The parameter specification from which the value should be recovered.
  /// - Returns: A `ParameterRecoveryResult` containing the recovered value on success, or `.failure` if recovery fails. 
  /// - Note: If the value is missing or cannot be recovered, the function may also record error context for debugging or validation.
  /// - Throws: This function does not throw, but may set error states within the current `ExchangeStructure` context.
  public func recoverRequiredParameter<T: SDAI.GenericType & SDAI.Initializable.ByVoid>(
    as type: T.Type,
    from parameter: Parameter
  ) -> ParameterRecoveryResult<T>
  {
    return _recoverRequiredParameter(
      as: type,
      from: parameter,
      fallback: type.init())
  }

  private func _recoverRequiredParameter<T: SDAI.GenericType>(
    as type: T.Type,
    from parameter: Parameter,
    fallback: T?
  ) -> ParameterRecoveryResult<T>
  {
    switch parameter {
      case .typedParameter(let typedParam):
        guard let recovered = T(p21typedParam: typedParam, from: self)
        else { self.add(errorContext: "while recovering required parameter of type(\(T.self))"); return .failure }
        return .success(recovered)

      case .untypedParameter(let untypedParam):
        switch untypedParam {
          case .noValue:
            if let recovered = fallback {
              SDAI.raiseErrorAndContinue(
                .VA_NSET,
                detail: "missing attribute value ($) is detected [ref. 12.2.2 of ISO 10303-21]"
                + ",\n while recovering required parameter of type(\(T.self)),\n while "
                + self.resolutionContextDescription
                + ".\n Fall back to utilize the default initialized data instance.")
              return .success(recovered)
            }
            self.error = "missing attribute value ($) is detected [ref. 12.2.2 of ISO 10303-21]"
            self.add(errorContext: "while recovering required parameter of type(\(T.self))")
            return .failure

          default:
            guard let recovered = T(p21untypedParam: untypedParam, from: self)
            else { self.add(errorContext: "while recovering required parameter of type(\(T.self))"); return .failure }
            return .success(recovered)
        }

      case .omittedParameter:
        self.error = "omitted parameter (*) is detected [ref. 12.2.6 of ISO 10303-21]"
        self.add(errorContext: "while recovering required parameter of type(\(T.self))")
        return .failure

      case .sdaiGeneric(let generic):
        guard let recovered = T.convert(fromGeneric: generic)
        else { self.error = "could not convert generic value(\(generic)) to type(\(T.self))"; return .failure }
        return .success(recovered)
    }
  }


  /// Recovers a value for an omittable required entity attribute of a specified type from a parameter specification.
  ///
  /// This method is intended for entity attributes that are required by schema but may be omitted due to redeclaration as DERIVEd.
  /// It attempts to extract and convert the value from the provided parameter. If the parameter is missing (represented as `$`)
  /// or omitted (represented as `*`), the method handles these cases accordingly, returning `nil` for omitted values and logging or raising errors as appropriate.
  ///
  /// - Parameters:
  ///   - type: The expected type of the entity attribute, conforming to `SDAI.GenericType`.
  ///   - parameter: The parameter specification from which the value should be recovered.
  ///
  /// - Returns: A `ParameterRecoveryResult` containing the recovered value (or `nil` if omitted or missing), or `.failure` if recovery fails.
  /// - Note: If the value is missing, an error may be raised or logged, and `nil` will be returned with a warning or error context.
  /// - Warning: If conversion fails, error context is set or logged for debugging and validation.
	public func recoverOmittableParameter<T: SDAI.GenericType>(as type: T.Type, from parameter: Parameter) -> ParameterRecoveryResult<T?> {
		switch parameter {
		case .typedParameter(let typedParam):
			guard let recovered = T(p21typedParam: typedParam, from: self)
			else { self.add(errorContext: "while recovering omittable parameter of type(\(T.self))"); return .failure }
			return .success(recovered)
			
		case .untypedParameter(let untypedParam):
			switch untypedParam {
			case .noValue:
          SDAI.raiseErrorAndContinue(
            .VA_NSET,
            detail: "missing attribute value ($) is detected [ref. 12.2.2 of ISO 10303-21]"
            + ",\n while recovering omittable parameter of type(\(T.self)),\n while "
            + self.resolutionContextDescription
            + ".\n Assume omitted parameter (*) being specified in place.")
          return .success(nil as T?)

			default:
				guard let recovered = T(p21untypedParam: untypedParam, from: self)
				else { self.add(errorContext: "while recovering omittable parameter of type(\(T.self))"); return .failure }
				return .success(recovered)				
			}
			
		case .omittedParameter:
			return .success(nil as T?)
			
		case .sdaiGeneric(let generic):
			guard let recovered = T.convert(fromGeneric: generic)
			else { self.error = "could not convert generic value(\(generic)) to type(\(T.self))"; return .failure }
			return .success(recovered)
		}
	}
	
 /// Recovers an optional entity attribute value of a specified type from a parameter specification.
  ///
  /// This function attempts to extract and convert the value from the given parameter into an optional of the desired type.
  /// If the parameter represents a missing value (`$` in STEP files), it returns `.success(nil)`.
  /// If the parameter is omitted (`*`), this is considered an unexpected omission for an optional attribute and is treated as a missing value with a warning.
  /// If the value cannot be converted to the expected type, error context is recorded and `.failure` is returned.
  ///
  /// - Parameters:
  ///   - type: The expected type of the entity attribute, conforming to `SDAI.GenericType`.
  ///   - parameter: The parameter specification from which the value should be recovered.
  ///
  /// - Returns: A `ParameterRecoveryResult` containing the recovered value on success (or `nil` if missing or omitted), or `.failure` if recovery fails.
  /// - Note: STEP file conventions allow both missing (`$`) and omitted (`*`) parameter representations.
  /// - Warning: If conversion fails, error context is recorded and `.failure` is returned.
	public func recoverOptionalParameter<T: SDAI.GenericType>(as type: T.Type, from parameter: Parameter) -> ParameterRecoveryResult<T?> {
		switch parameter {
		case .untypedParameter(let untyped):
			if untyped == .noValue {
				return .success(nil)
			}
			fallthrough
		case .typedParameter(_):
			guard let recovered = T(p21param: parameter, from: self)
			else { self.add(errorContext: "while recovering optional parameter of type(\(T.self))"); return .failure }
			return .success(recovered)
			
		case .omittedParameter:
        SDAI.raiseErrorAndContinue(
          .VA_NSET,
          detail: "omitted parameter (*) is detected [ref. 12.2.6 of ISO 10303-21]"
          + ",\n while recovering omittable parameter of type(\(T.self)),\n while "
          + self.resolutionContextDescription
          + ".\n Assume missing attribute parameter ($) being specified in place.")
        return .success(nil)
			
		case .sdaiGeneric(let generic):
			guard let recovered = T.convert(fromGeneric: generic)
			else { self.error = "could not convert generic value(\(generic)) to type(\(T.self))"; return .failure }
			return .success(recovered)
		}
	}
	
  /// Recovers a value for an omittable optional entity attribute of a specified type from a parameter specification.
  ///
  /// This function is designed for attributes that may be omitted—typically due to redeclaration as DERIVEd in the schema—and thus may not always appear in the data.  
  /// It attempts to extract and convert the provided parameter into an optional value of the desired generic type.  
  /// If the parameter is omitted (represented as `*`), the function returns `.success(nil)`.  
  /// If the parameter is present as a typed or untyped value but cannot be converted to the expected type, or if an error occurs during recovery, `.failure` is returned and error context may be recorded.  
  /// If the parameter is a generic representation, a conversion attempt is made.
  ///
  /// - Parameters:
  ///   - type: The expected type of the entity attribute, conforming to `SDAI.GenericType`.
  ///   - parameter: The parameter specification from which to recover the value.
  ///
  /// - Returns: A `ParameterRecoveryResult` containing the recovered value on success (which may be `nil` for omitted attributes), or `.failure` if recovery fails.
  ///
  /// - Note: Omittable optional attributes are valid in cases where schema rules allow omission.  
  /// - Warning: If conversion fails or an error is encountered during recovery, error context may be set or recorded internally for debugging or validation.
	public func recoverOmittableOptionalParameter<T: SDAI.GenericType>(as type: T.Type, from parameter: Parameter) -> ParameterRecoveryResult<T?> {
		switch parameter {
		case .typedParameter(_), .untypedParameter(_):
			let recovered = T(p21param: parameter, from: self)
			guard self.error == nil
			else { self.add(errorContext: "while recovering omittable optional parameter of type(\(T.self))"); return .failure }
			return .success(recovered)
			
		case .omittedParameter:
			return .success(nil as T?)
			
		case .sdaiGeneric(let generic):
			guard let recovered = T.convert(fromGeneric: generic)
			else { self.error = "could not convert generic value(\(generic)) to type(\(T.self))"; return .failure }
			return .success(recovered)
		}
	}

}
