//
//  SdaiEntityValueComparison.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - Entity value comparisons (12.2.1.7)

//MARK: entity ref vs. entity ref
public func .==. (lhs: SDAI.EntityReference?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL { 
	return SDAI.LOGICAL( lhs?.value.isValueEqualOptionally(to: rhs?.value) )
}
public func .!=. (lhs: SDAI.EntityReference?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL { !(lhs .==. rhs) }

//MARK: entity ref vs. select
public func .==. <U: SDAISelectType>(lhs: SDAI.EntityReference?, rhs: U?) -> SDAI.LOGICAL { lhs .==. rhs?.entityReference }
public func .!=. <U: SDAISelectType>(lhs: SDAI.EntityReference?, rhs: U?) -> SDAI.LOGICAL { !(lhs .==. rhs) }

//MARK: select vs. entity ref
public func .==. <T: SDAISelectType>(lhs: T?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL { rhs .==. lhs }
public func .!=. <T: SDAISelectType>(lhs: T?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL { !(lhs .==. rhs) }


//MARK: pref vs. pref
public func .==. <T,U>(lhs: SDAI.PersistentEntityReference<T>?, rhs: SDAI.PersistentEntityReference<U>?) -> SDAI.LOGICAL
{ lhs?.eval .==. rhs?.eval }
public func .!=. <T,U>(lhs: SDAI.PersistentEntityReference<T>?, rhs: SDAI.PersistentEntityReference<U>?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }


//MARK: pref vs. entity ref
public func .==. <T>(lhs: SDAI.PersistentEntityReference<T>?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL
{ lhs?.eval .==. rhs }
public func .!=. <T>(lhs: SDAI.PersistentEntityReference<T>?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }

//MARK: entity ref vs. pref
public func .==. <U>(lhs: SDAI.EntityReference?, rhs: SDAI.PersistentEntityReference<U>?) -> SDAI.LOGICAL
{ rhs .==. lhs }
public func .!=. <U>(lhs: SDAI.EntityReference?, rhs: SDAI.PersistentEntityReference<U>?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }


//MARK: pref vs. select
public func .==. <T,U:SDAISelectType>(lhs: SDAI.PersistentEntityReference<T>?, rhs: U?) -> SDAI.LOGICAL
{ lhs?.eval .==. rhs }
public func .!=. <T,U:SDAISelectType>(lhs: SDAI.PersistentEntityReference<T>?, rhs: U?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }

//MARK: select vs. pref
public func .==. <T:SDAISelectType,U>(lhs: T?, rhs: SDAI.PersistentEntityReference<U>?) -> SDAI.LOGICAL
{ rhs .==. lhs }
public func .!=. <T:SDAISelectType,U>(lhs: T?, rhs: SDAI.PersistentEntityReference<U>?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }

