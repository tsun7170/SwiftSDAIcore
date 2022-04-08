//
//  FunctionResultCache.swift
//  
//
//  Created by Yoshida on 2021/08/03.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - SdaiCachableSource
public protocol SdaiCachableSource
{
	var isCachable: Bool {get}
}

public extension SdaiCachableSource where Self: SDAIDefinedType
{
	var isCachable: Bool { rep.isCachable }
}


//MARK: - SdaiFunctionResultCacheController
public protocol SdaiFunctionResultCacheController: SdaiCachableSource
{
	func register(cache: SDAI.FunctionResultCache)
	func resetCaches()
}



extension SDAI {
	public typealias ParameterType = AnyHashable
	
	//MARK: - ParameterList
	public struct ParameterList: SdaiCachableSource, Hashable {
		
		private var params:[ParameterType]
		
		public init(_ params:ParameterType...) {
			self.params = params
		}
		
		public var isCachable: Bool {
			for param in params {
				if let param = param as? SdaiCachableSource {
					if !param.isCachable { 
						return false 
					}
				}
			}
			return true
		}
	}
	
	
	//MARK: - FunctionResultCache	
	public final class FunctionResultCache {
		public enum Result {
			case available(Any)
			case unavailable
		}
		
		private var controller: SdaiFunctionResultCacheController
		private var cache: [ParameterList:Result] = [:]
		
		public init(controller: SdaiFunctionResultCacheController) {
			self.controller = controller
			controller.register(cache: self)			
		}
		
		public func updateCache<T>(params:ParameterList, value:T) -> T {
			if controller.isCachable && params.isCachable {
				cache[params] = Result.available(value)
			}
			return value
		}
		
		public func cachedValue(params:ParameterList) -> Result {
			guard controller.isCachable else { return .unavailable }
			guard let cached = cache[params] else { return .unavailable }
			return cached
		}
		
		public func resetCache() {
			cache = [:]
		}
		
	}
	
}
