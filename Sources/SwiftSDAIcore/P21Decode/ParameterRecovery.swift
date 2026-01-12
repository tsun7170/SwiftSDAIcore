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
	
	
	/// recover a required entity attribute value of a given type from a parameter specification
	///
	/// - Parameters:
	///   - type: type of entity attribute
	///   - parameter: parameter specification
	/// - Returns: recovered parameter value
	///
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

  public func recoverRequiredParameter<T: SDAI.GenericType & SDAI.InitializableByVoid>(
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


	/// recover a omittable (due to redeclaration as DERIVEd) required entity attribute value of a given type from a parameter specification
	/// - Parameters:
	///   - type: type of entity attribute
	///   - parameter: parameter specification
	/// - Returns: recovered parameter value
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
	
	/// recover a optional entity attribute value of a given type from a parameter specification
	/// - Parameters:
	///   - type: type of entity attribute
	///   - parameter: parameter specification
	/// - Returns: recovered parameter value
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
	
	/// recover a omittable (due to redeclaration as DERIVEd) optional entity attribute value of a given type from a parameter specification
	/// - Parameters:
	///   - type: type of entity attribute
	///   - parameter: parameter specification
	/// - Returns: recovered parameter value
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
