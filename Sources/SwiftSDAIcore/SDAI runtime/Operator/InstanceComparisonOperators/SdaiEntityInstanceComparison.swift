//
//  SdaiEntityInstanceComparison.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - Entity instance comparison (12.2.2.2)

//MARK: entity ref vs. entity ref
/// Entity Instance Equal: Entity .===. Entity = LOGICAL
///
public func .===. (
  lhs: SDAI.EntityReference?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL
{
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	let result = lhs.complexEntity === rhs.complexEntity
	return SDAI.LOGICAL( result )
}

/// Entity Instance NotEqual: Entity .!==. Entity = LOGICAL
///
public func .!==. (
  lhs: SDAI.EntityReference?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


//MARK: entity ref vs. select
/// Entity Instance Equal: Entity .===. Select = LOGICAL
///
public func .===. <U: SDAI.SelectType>(
  lhs: SDAI.EntityReference?, rhs: U?) -> SDAI.LOGICAL
{
	return lhs .===. rhs?.entityReference
}

/// Entity Instance NotEqual: Entity .!==. Select = LOGICAL
///
public func .!==. <U: SDAI.SelectType>(
  lhs: SDAI.EntityReference?, rhs: U?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


//MARK: select vs. entity ref
/// Entity Instance Equal: Select .===. Entity = LOGICAL
///
public func .===. <T: SDAI.SelectType>(
  lhs: T?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL
{ rhs .===. lhs }

/// Entity Instance NotEqual: Select .!==. Entity = LOGICAL
///
public func .!==. <T: SDAI.SelectType>(
  lhs: T?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }



//MARK: partial vs. partial
/// Entity Instance Equal: Partial .===. Partial = LOGICAL
///
public func .===. (
  lhs: SDAI.PartialEntity?, rhs: SDAI.PartialEntity?) -> SDAI.LOGICAL
{
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	return SDAI.LOGICAL( lhs === rhs ) 	
}

/// Entity Instance NotEqual: Partial .!==. Partial = LOGICAL
///
public func .!==. (
  lhs: SDAI.PartialEntity?, rhs: SDAI.PartialEntity?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }



//MARK: pref vs. pref
/// Entity Instance Equal: PRef .===. PRef = LOGICAL
///
public func .===. <T,U>(
  lhs: SDAI.PersistentEntityReference<T>?, rhs: SDAI.PersistentEntityReference<U>?) -> SDAI.LOGICAL
{ lhs?.eval .===. rhs?.eval }

/// Entity Instance NotEqual: PRef .!==. PRef = LOGICAL
///
public func .!==. <T,U>(
  lhs: SDAI.PersistentEntityReference<T>?, rhs: SDAI.PersistentEntityReference<U>?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


//MARK: pref vs. entity ref
/// Entity Instance Equal: PRef .===. Entity = LOGICAL
///
public func .===. <T>(
  lhs: SDAI.PersistentEntityReference<T>?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL
{ lhs?.eval .===. rhs }

/// Entity Instance NotEqual: PRef .!==. Entity = LOGICAL
///
public func .!==. <T>(
  lhs: SDAI.PersistentEntityReference<T>?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


//MARK: entity ref vs. pref
/// Entity Instance Equal: Entity .===. PRef = LOGICAL
///
public func .===. <U>(
  lhs: SDAI.EntityReference?, rhs: SDAI.PersistentEntityReference<U>?) -> SDAI.LOGICAL
{ rhs .===. lhs }

/// Entity Instance NotEqual: Entity .!==. PRef = LOGICAL
///
public func .!==. <U>(
  lhs: SDAI.EntityReference?, rhs: SDAI.PersistentEntityReference<U>?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


//MARK: pref vs. select
/// Entity Instance Equal: PRef .===. Select = LOGICAL
///
public func .===. <T,U:SDAI.SelectType>(
  lhs: SDAI.PersistentEntityReference<T>?, rhs: U?) -> SDAI.LOGICAL
{ lhs?.eval .===. rhs }

/// Entity Instance NotEqual: PRef .!==. Select = LOGICAL
///
public func .!==. <T,U:SDAI.SelectType>(
  lhs: SDAI.PersistentEntityReference<T>?, rhs: U?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }


//MARK: select vs. pref
/// Entity Instance Equal: Select .===. PRef = LOGICAL
///
public func .===. <T:SDAI.SelectType,U>(
  lhs: T?, rhs: SDAI.PersistentEntityReference<U>?) -> SDAI.LOGICAL
{ rhs .===. lhs }

/// Entity Instance NotEqual: Select .!==. PRef = LOGICAL
///
public func .!==. <T:SDAI.SelectType,U>(
  lhs: T?, rhs: SDAI.PersistentEntityReference<U>?) -> SDAI.LOGICAL
{ !(lhs .===. rhs) }

