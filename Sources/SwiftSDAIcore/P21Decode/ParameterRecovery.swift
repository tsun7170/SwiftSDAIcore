//
//  ParameterRecovery.swift
//  
//
//  Created by Yoshida on 2021/05/08.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension P21Decode.ExchangeStructure {
	
	public enum ParameterRecoveryResult<T> {
		case success(T)
		case failure
		
		private static func usage(parameter: Parameter, exchangeStructure: P21Decode.ExchangeStructure) -> SDAI.REAL {
			guard case .success(let recovered) = exchangeStructure.recoverRequiredParameter(as: SDAI.REAL.self, from: parameter)
			else { fatalError() }
			return recovered
		}
	}
	
	
	public func recoverRequiredParameter<T: SDAIGenericType>(as type: T.Type, from parameter: Parameter) -> ParameterRecoveryResult<T> {
		switch parameter {
		case .typedParameter(let typedParam):
			guard let recovered = T(p21typedParam: typedParam, from: self)
			else { self.add(errorContext: "while recovering required parameter of type(\(T.self))"); return .failure }
			return .success(recovered)
			
		case .untypedParameter(let untypedParam):
			switch untypedParam {
			case .noValue:
				self.error = "null value is detected"
				self.add(errorContext: "while recovering required parameter of type(\(T.self))")
				return .failure
				
			default:
				guard let recovered = T(p21untypedParam: untypedParam, from: self)
				else { self.add(errorContext: "while recovering required parameter of type(\(T.self))"); return .failure }
				return .success(recovered)				
			}
			
		case .omittedParameter:
			self.error = "omitted parameter is detected"
			self.add(errorContext: "while recovering required parameter of type(\(T.self))")
			return .failure
			
		case .sdaiGeneric(let generic):
			guard let recovered = T.convert(fromGeneric: generic)
			else { self.error = "could not convert generic value(\(generic)) to type(\(T.self))"; return .failure }
			return .success(recovered)
		}
	}
	
	public func recoverOmittableParameter<T: SDAIGenericType>(as type: T.Type, from parameter: Parameter) -> ParameterRecoveryResult<T?> {
		switch parameter {
		case .typedParameter(let typedParam):
			guard let recovered = T(p21typedParam: typedParam, from: self)
			else { self.add(errorContext: "while recovering omittable parameter of type(\(T.self))"); return .failure }
			return .success(recovered)
			
		case .untypedParameter(let untypedParam):
			switch untypedParam {
			case .noValue:
				self.error = "null value is detected"
				self.add(errorContext: "while recovering omittable parameter of type(\(T.self))")
				return .failure
				
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

	public func recoverOptionalParameter<T: SDAIGenericType>(as type: T.Type, from parameter: Parameter) -> ParameterRecoveryResult<T?> {
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
			self.error = "omitted parameter is detected"
			self.add(errorContext: "while recovering optional parameter of type(\(T.self))")
			return .failure
			
		case .sdaiGeneric(let generic):
			guard let recovered = T.convert(fromGeneric: generic)
			else { self.error = "could not convert generic value(\(generic)) to type(\(T.self))"; return .failure }
			return .success(recovered)
		}
	}
	
	public func recoverOmittableOptionalParameter<T: SDAIGenericType>(as type: T.Type, from parameter: Parameter) -> ParameterRecoveryResult<T?> {
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
