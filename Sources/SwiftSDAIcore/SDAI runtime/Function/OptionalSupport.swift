//
//  OptionalSupport.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAI {
	//MARK: - support functions
  public static func UNWRAP<T>(
    _ val:T?,
    file: StaticString = #fileID,
    line: UInt = #line,
    functionID: StaticString = #function
  ) -> T
  {
    guard let unwrapped = val
    else {
      SDAI.raiseErrorAndTrap(.VA_NEXS,
                             detail: "failed to unwrap \(T.self) optional value",
                             file: file, line: line, functionID: functionID)
    }
    return unwrapped
  }

  public static func UNWRAP<T: SDAI.InitializableBySwiftType> (
    _ val:T?,
    file: StaticString = #fileID,
    line: UInt = #line,
    functionID: StaticString = #function
  ) -> T
  where T.SwiftType: InitializableByVoid
  {
    if let unwrapped = val { return unwrapped }

    let fallback = T()
    SDAI.raiseErrorAndContinue(.VA_NEXS,
                               detail: "failed to unwrap \(T.self) optional value; fall back to the default value[\(fallback)]",
                               file: file, line: line, functionID: functionID)
    return fallback
  }

  public static func UNWRAP<T:SDAIBaseType>(_ val:T) -> T { return val }

	public static func FORCE_OPTIONAL<T>(_ val:T?) -> T? { return val }
	public static func FORCE_OPTIONAL<T>(_ val:T) -> T? { return val }
	
	public static func IS_TRUE<T: SDAILogicalType>(_ logical: T?) -> Bool { logical?.isTRUE ?? false }
	public static func IS_FALSE<T: SDAILogicalType>(_ logical: T?) -> Bool { logical?.isFALSE ?? false }
	public static func IS_UNKNOWN<T: SDAILogicalType>(_ logical: T?) -> Bool { logical?.isUNKNOWN ?? true }
	
	public static func UNWRAP<A:Sequence>(seq: A?) -> A 
	where A: InitializableByVoid {
		if let seq = seq { return seq }
		return A()
	}

	public static func UNWRAP<EREF>(_ pref:PersistentEntityReference<EREF>?) -> PersistentEntityReference<EREF>
	where EREF: EntityReference
	{
		if let pref = pref { return pref }
		return PersistentEntityReference(nil as EREF?)
	}
}
