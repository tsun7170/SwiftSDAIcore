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
	func notifyReadWriteModeChanged(sdaiModel: SDAIPopulationSchema.SdaiModel) async

	func notifyApplicationDomainChanged(relatedTo schemaInstance: SDAIPopulationSchema.SchemaInstance) async

  func terminateCachingTask()

  func toCompleteCachingTask() async
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
  var approximationLevel: Int {get}
	func register(cache: SDAI.FunctionResultCache)
	func resetCaches() async
}



extension SDAI {
	public typealias ParameterType = SDAIGenericType

	//MARK: - ParameterList
	public struct ParameterList: SdaiCacheableSource, Hashable, Sendable {

		private let params:[(any ParameterType)?]

    private let hashedParams: Int

    fileprivate typealias LaneNo = Int
    fileprivate var laneNo: LaneNo {
      LaneNo(self.hashedParams & 0b11)
    }

		public init(_ params:(any ParameterType)? ...) {
			self.params = params

      var hasher = Hasher()
      hasher.combine(params.count)
      for param in params {
        param?.hash_(into: &hasher)
      }
      self.hashedParams = hasher.finalize()
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
      hasher.combine(self.hashedParams)
		}

	}//struct



	
	//MARK: - FunctionResultCache	
	public actor FunctionResultCache: Sendable
	{
		public enum Result {
			case available(any Sendable)
			case unavailable
		}

    public let label: String
		private let controller: SdaiFunctionResultCacheController

    private typealias CacheValue = (value:any Sendable, level:Int)

    private let cache0 =
    Mutex<[ParameterList : CacheValue]>([:])
    private let cache1 =
    Mutex<[ParameterList : CacheValue]>([:])
    private let cache2 =
    Mutex<[ParameterList : CacheValue]>([:])
    private let cache3 =
    Mutex<[ParameterList : CacheValue]>([:])

    private var updateTasks: [ParameterList :
                                (task:Task<Void,Never>,level:Int) ] = [:]

    private func addTask(
      for params: ParameterList,
      level: Int,
      operation: @Sendable @escaping ()async->Void ) async
    {
      while let prevTask = updateTasks[params] {
        if prevTask.level <= level { return }
        prevTask.task.cancel()
        await prevTask.task.value
      }

      let task = Task(name: "SDAI.function_result_cache_update")
      {
        await operation()
        self.removeTask(for: params)
      }

      let prevTask = updateTasks.updateValue( (task:task, level:level),
                                              forKey: params )

      assert(prevTask == nil)
    }

    private func removeTask(for params:ParameterList)
    {
      let _ = updateTasks.removeValue(forKey: params)
    }

    func terminateCachingTasks()
    {
      for running in updateTasks.values {
        running.task.cancel()
      }
    }

    func toCompleteCachingTasks() async
    {
      for running in updateTasks.values {
        await running.task.value
      }
    }



    public init(
      label: String,
      controller: SdaiFunctionResultCacheController)
    {
      self.label = label
      self.controller = controller
      controller.register(cache: self)
    }


    nonisolated
		public func updateCache<T: Sendable>(
      params:ParameterList,
      value:T) -> T
    {
      guard controller.isCacheable, params.isCacheable
      else { return value }

      let currentLevel = controller.approximationLevel

      if attemptToUpdate() != nil { return value }

      Task(name: "SDAI.FunctionResultCache_DeferredUpdate--\(self.label)") {
        let session = SDAISessionSchema.activeSession
        let maxAttempts = session?.maxCacheUpdateAttempts ?? 1000

        await self.addTask(for: params, level: currentLevel)
        {
          for _ in 1 ... maxAttempts {
            if Task.isCancelled { return }

            if attemptToUpdate() != nil { return }
            await Task.yield()
          }//for

          loggerSDAI.info("\(#function): failed to update function result cache[\(self.label) @level:\(currentLevel)] for \(maxAttempts) attempts")
        }//addTask
      }//Task

      return value

      @Sendable func attemptToUpdate() -> Void?
      {
        let updated:Void?
        switch params.laneNo {
          case 1:
            updated = self.cache1.withLockIfAvailable{updateKarnel(cache:&$0)}
          case 2:
            updated = self.cache2.withLockIfAvailable{updateKarnel(cache:&$0)}
          case 3:
            updated = self.cache3.withLockIfAvailable{updateKarnel(cache:&$0)}

          default:
            updated = self.cache0.withLockIfAvailable{updateKarnel(cache:&$0)}
        }
        return updated
      }

      @Sendable func updateKarnel(
        cache: inout [ParameterList : CacheValue])
      {
        if let cached = cache[params],
           cached.level <= currentLevel
        { return }

        cache[params] = (value: value, level: currentLevel)
      }
    }

    nonisolated
		public func cachedValue(params:ParameterList) -> Result
    {
			guard controller.isCacheable else { return .unavailable }

      let cached: CacheValue?
      switch params.laneNo {
        case 1:
          cached = cache1.withLock{ $0[params] }
        case 2:
          cached = cache2.withLock{ $0[params] }
        case 3:
          cached = cache3.withLock{ $0[params] }

        default:
          cached = cache0.withLock{ $0[params] }
      }

			guard let cached = cached,
            cached.level <= controller.approximationLevel
      else { return .unavailable }

      return .available(cached.value)
		}
		
		public func resetCache() async
    {
      self.terminateCachingTasks()
      await self.toCompleteCachingTasks()

      cache0.withLock{ $0 = [:] }
      cache1.withLock{ $0 = [:] }
      cache2.withLock{ $0 = [:] }
			cache3.withLock{ $0 = [:] }
		}
		
	}
	
}
