//
//  FunctionResultCache.swift
//  
//
//  Created by Yoshida on 2021/08/03.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import Synchronization

//MARK: - SDAI.CacheHolder
extension SDAI {
  /// A protocol for objects that hold and manage caches within the SDAI framework,
  /// providing notification hooks for changes in read/write mode and application domain,
  /// as well as methods for managing the lifecycle of caching tasks.
  ///
  /// Conforming types are expected to implement concurrency-safe logic for responding
  /// to changes in model state or schema instance, and to manage asynchronous cache update
  /// tasks, including their termination and completion.
  ///
  /// - Note: All notification and cache management methods are asynchronous and/or
  ///   concurrency-aware, supporting integration with async/await and structured concurrency.
  ///
  /// - SeeAlso: 
  ///   - ``notifyReadWriteModeChanged(sdaiModel:)``
  ///   - ``notifyApplicationDomainChanged(relatedTo:)``
  ///   - ``terminateCachingTask()``
  ///   - ``toCompleteCachingTask()``
  ///
  public protocol CacheHolder
  {
    func notifyReadWriteModeChanged(sdaiModel: SDAIPopulationSchema.SdaiModel) async

    func notifyApplicationDomainChanged(relatedTo schemaInstance: SDAIPopulationSchema.SchemaInstance) async

    func terminateCachingTask()

    func toCompleteCachingTask() async
  }
}


//MARK: - SDAI.CacheableSource
extension SDAI {
  /// A protocol indicating that a type can be considered for caching within the SDAI framework.
  ///
  /// Types conforming to `CacheableSource` specify whether their instances are eligible to have their computed
  /// results cached. This is usually used as a mechanism to optimize function results, reduce recomputation,
  /// and enable efficient reuse of previously computed values while ensuring correctness when cacheability
  /// is dependent on the underlying data's stability or validity.
  ///
  /// - Note: The `isCacheable` property should reflect whether an instance's value is suitable for caching
  ///   based on its current state and structure. For composite or referenced types, cacheability may depend
  ///   on the cacheability of their components.
  ///
  /// - Important: Implementations must ensure that `isCacheable` returns `true` only if the instance
  ///   is immutable or its value is otherwise guaranteed not to change unexpectedly within the caching context.
  ///
  /// - SeeAlso: ``SDAI/FunctionResultCache``, ``SDAI/FunctionResultCacheController``
  public protocol CacheableSource
  {
    var isCacheable: Bool {get}
  }
}

public extension SDAI.CacheableSource
where Self: SDAI.DefinedType
{
	var isCacheable: Bool { rep.isCacheable }
}


//MARK: - SDAI.FunctionResultCacheController
extension SDAI {
  
  /// A protocol that defines the interface for controllers managing one or more function result caches
  /// within the SDAI framework, supporting strategies for cache registration, invalidation, and approximation levels.
  /// 
  /// Conforming types are expected to determine if cached results are valid and reusable, facilitate the
  /// registration of managed caches, and provide mechanisms to reset or invalidate all associated caches when
  /// needed (for example, in response to changes in the model state or application domain).
  ///
  /// The controller also exposes an `approximationLevel` property to allow caching of function results at different
  /// levels of precision or completeness, enabling advanced cache management strategies.
  /// 
  /// - Important: Implementations should guarantee thread- or concurrency-safety for all methods. Additionally,
  ///   cache reset operations should be `async` to allow for the proper suspension and coordination of concurrent tasks.
  /// 
  /// - SeeAlso: 
  ///   - ``SDAI/FunctionResultCache``
  ///   - ``SDAI/CacheableSource``
  ///   - ``SDAI/CacheHolder``
  ///
  /// ## Responsibilities
  /// - Provide a mechanism to determine cacheability of results via ``SDAI/CacheableSource/isCacheable``.
  /// - Advertise the current approximation level for cached results.
  /// - Register and track caches for coordinated reset or invalidation.
  /// - Support cache reset operations that may be invoked asynchronously.
  public protocol FunctionResultCacheController:
    SDAI.CacheableSource,
    AnyObject, Sendable
  {
    var approximationLevel: Int {get}
    func register(cache: SDAI.FunctionResultCache)
    func resetCaches() async
  }
}


extension SDAI {
	public typealias ParameterType = SDAI.GenericType

	//MARK: - ParameterList

  /// A value type that encapsulates a list of function parameters for use with caching
  /// in the SDAI framework. `ParameterList` is used as the key for function result
  /// caches to uniquely identify cached results for a specific set of input parameters.
  ///
  /// Instances are constructed from a variadic list of optional `SDAI.ParameterType`
  /// values, each of which must conform to ``SDAI/CacheableSource`` and be `Hashable`.
  /// This enables the framework to determine if a given parameter combination is suitable
  /// for caching, and to efficiently compare or retrieve cached results.
  ///
  /// - **Hashing & Equality:** Parameter lists are hashed and equated based on the
  ///   sequence and cacheability of all their elements, supporting robust lookup in
  ///   hash-based collections. Internal hashing is precomputed for performance.
  /// - **Cacheability:** The entire list is considered cacheable only if all its
  ///   parameters are themselves cacheable. See ``isCacheable``.
  /// - **Concurrency:** This type is `Sendable` and suitable for use in concurrent code.
  /// - **Lanes:** Each instance includes an internal "lane number" derived from its
  ///   hash, used for sharding cache storage to reduce lock contention.
  /// - Important: Only immutable or otherwise stable parameter values should be included
  ///   in a `ParameterList` to ensure correct and predictable caching behavior.
  ///
  /// - Parameters:
  ///   - params: The ordered list of parameters to be encapsulated, all of which must
  ///     conform to ``SDAI/ParameterType``.
  ///
  /// - SeeAlso: ``SDAI/FunctionResultCache``, ``SDAI/CacheableSource``
	public struct ParameterList: SDAI.CacheableSource, Hashable, Sendable {

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
  /// An actor class that manages the caching of function results for a given set of parameters,
  /// supporting concurrency-safe, multi-lane storage, deferred cache updates, and cache invalidation.
  ///
  /// The cache is designed to work in conjunction with a controller conforming to
  /// ``SDAI/FunctionResultCacheController``, enabling approximated results and cacheability checks.
  ///
  /// - Caching lanes (0–3) are selected based on the hash of the parameter list to minimize lock contention.
  /// - Updates are performed asynchronously, with only one update task per parameter list allowed at a time.
  /// - Cache values are stored with an associated "approximation level", supporting use cases where results
  ///   of varying accuracy or completeness may be cached and retrieved.
  /// - Tasks updating the cache may be cancelled or awaited for completion, enabling robust cache lifecycle management.
  /// - The cache supports resetting and task termination, ensuring stale or obsolete data is efficiently removed.
  /// - This type is `Sendable` and concurrency-safe by design, using Swift actors and mutexes.
	public actor FunctionResultCache: Sendable
	{
		public enum Result {
			case available(any Sendable)
			case unavailable
		}

    public let label: String
		private let controller: SDAI.FunctionResultCacheController

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
      controller: SDAI.FunctionResultCacheController)
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
		
	}//actor

  //MARK: - session cache controller adapter
  public static let sessionFunctionResultCacheController = SessionFunctionResultCacheControllerAdapter()

  /// An adapter class that bridges session-level function result cache control to the currently active session's governing schema controller.
  ///
  /// `SessionFunctionResultCacheControllerAdapter` acts as a proxy for managing multiple `SDAI.FunctionResultCache` instances associated with a session,
  /// supporting cache registration and reset operations. It defers cacheability and approximation level queries to the `governingSchema` of the current active session.
  /// This enables seamless integration of cache management into session lifecycles, ensuring that cache behavior is consistent with the context and schema of the active session.
  ///
  /// - Registers individual function result caches, allowing them to be reset collectively when needed.
  /// - Forwards `isCacheable` and `approximationLevel` properties to the session's governing schema controller, if one is active.
  /// - Provides concurrency-safe cache registration and reset functionality.
  /// - Typically used as a singleton instance via `SDAI.sessionFunctionResultCacheController`.
  public final class SessionFunctionResultCacheControllerAdapter:
    SDAI.FunctionResultCacheController
  {
    private let functionCaches = Mutex<[SDAI.FunctionResultCache]>([])

    public func register(cache: SDAI.FunctionResultCache) {
      self.functionCaches.withLock{ $0.append(cache) }
    }

    public func resetCaches() async {
      for cache in self.functionCaches.withLock({$0}) {
        await cache.resetCache()
      }
    }

    private var activeController: SDAI.FunctionResultCacheController? {
      guard let session = SDAISessionSchema.activeSession
      else { return nil }

      return session.governingSchema
    }

    public var isCacheable: Bool {
      self.activeController?.isCacheable ?? false
    }

    public var approximationLevel: Int {
      self.activeController?.approximationLevel ?? 0
    }


  }//class

}//extension
