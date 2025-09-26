//
//  FunctionResultCache.swift
//  
//
//  Created by Yoshida on 2021/08/03.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import Synchronization

//MARK: - SdaiCacheHolder
public protocol SdaiCacheHolder
{
	func notifyReadWriteModeChanged(sdaiModel: SDAIPopulationSchema.SdaiModel)

	func notifyApplicationDomainChanged(relatedTo schemaInstance: SDAIPopulationSchema.SchemaInstance)
}


//MARK: - SdaiCacheableSource
public protocol SdaiCacheableSource
{
	var isCacheable: Bool {get}
}

public extension SdaiCacheableSource where Self: SDAIDefinedType
{
	var isCacheable: Bool { rep.isCacheable }
}


//MARK: - SdaiFunctionResultCacheController
public protocol SdaiFunctionResultCacheController: SdaiCacheableSource, Sendable
{
	func register(cache: SDAI.FunctionResultCache)
	func resetCaches()
}



extension SDAI {
	public typealias ParameterType = SDAIGenericType

	//MARK: - ParameterList
	public struct ParameterList: SdaiCacheableSource, Hashable, Sendable {

		private let params:[(any ParameterType)?]

		public init(_ params:(any ParameterType)? ...) {
			self.params = params
		}
		
		public var isCacheable: Bool {
			for param in params {
				if let param = param  {
					if !param.isCacheable {
						return false
					}
				}
			}
			return true
		}

		public static func ==(lhs:SDAI.ParameterList, rhs:SDAI.ParameterList) -> Bool {
			guard lhs.params.count == rhs.params.count else { return false }
			for idx in 0..<lhs.params.count {
				guard let lhsParam = lhs.params[idx] else {
					guard rhs.params[idx] == nil else { return false }
					continue
				}
				guard lhsParam.isEqual(to: rhs.params[idx]) else { return false }
			}
			return true
		}

		public func hash(into hasher: inout Hasher) {
			hasher.combine(self.params.count)
			for param in self.params {
				param?.hash_(into: &hasher)
			}
		}

	}//struct



	
	//MARK: - FunctionResultCache	
	public final class FunctionResultCache: Sendable
	{
		public enum Result {
			case available(any Sendable)
			case unavailable
		}
		
		private let controller: SdaiFunctionResultCacheController
		private let cache = Mutex<[ParameterList:Result]>([:])

		public init(controller: SdaiFunctionResultCacheController) {
			self.controller = controller
			controller.register(cache: self)			
		}
		
		public func updateCache<T: Sendable>(params:ParameterList, value:T) -> T {
			if controller.isCacheable && params.isCacheable {
				cache.withLock{ $0[params] = Result.available(value) }
			}
			return value
		}
		
		public func cachedValue(params:ParameterList) -> Result {
			guard controller.isCacheable else { return .unavailable }
			guard let cached = cache.withLock({ $0[params] }) else { return .unavailable }
			return cached
		}
		
		public func resetCache() {
			cache.withLock{ $0 = [:] }
		}
		
	}
	
}
