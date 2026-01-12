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

/// Entity Value Equal: Entity .==. Entity = LOGICAL
///
public func .==. (
  lhs: SDAI.EntityReference?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL
{
	return SDAI.LOGICAL( lhs?.value.isValueEqualOptionally(to: rhs?.value) )
}

/// Entity Value NotEqual: Entity .!=. Entity = LOGICAL
///
public func .!=. (
  lhs: SDAI.EntityReference?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }


//MARK: entity ref vs. select

/// Entity Value Equal: Entity .==. Select = LOGICAL
///
public func .==. <US: SDAI.SelectType>(
  lhs: SDAI.EntityReference?, rhs: US?) -> SDAI.LOGICAL
{ lhs .==. rhs?.entityReference }

/// Entity Value NotEqual: Entity .!=. Select = LOGICAL
///
public func .!=. <US: SDAI.SelectType>(
  lhs: SDAI.EntityReference?, rhs: US?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }


//MARK: select vs. entity ref
/// Entity Value Equal: Select .==. Entity = LOGICAL
///
public func .==. <TS: SDAI.SelectType>(
  lhs: TS?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL
{ rhs .==. lhs }

/// Entity Value NotEqual: Select .!=. Entity = LOGICAL
///
public func .!=. <TS: SDAI.SelectType>(
  lhs: TS?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }


//MARK: pref vs. pref
/// Entity Value Equal: PRef .==. PRef = LOGICAL
///
public func .==. <T,U>(
  lhs: SDAI.PersistentEntityReference<T>?, rhs: SDAI.PersistentEntityReference<U>?) -> SDAI.LOGICAL
{ lhs?.eval .==. rhs?.eval }

/// Entity Value NotEqual: PRef .!=. PRef = LOGICAL
///
public func .!=. <T,U>(
  lhs: SDAI.PersistentEntityReference<T>?, rhs: SDAI.PersistentEntityReference<U>?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }


//MARK: pref vs. entity ref
/// Entity Value Equal: PRef .==. Entity = LOGICAL
///
public func .==. <T>(
  lhs: SDAI.PersistentEntityReference<T>?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL
{ lhs?.eval .==. rhs }

/// Entity Value NotEqual: PRef .!=. Entity = LOGICAL
///
public func .!=. <T>(
  lhs: SDAI.PersistentEntityReference<T>?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }


//MARK: entity ref vs. pref
/// Entity Value Equal: Entity .==. PRef = LOGICAL
///
public func .==. <U>(
  lhs: SDAI.EntityReference?, rhs: SDAI.PersistentEntityReference<U>?) -> SDAI.LOGICAL
{ rhs .==. lhs }

/// Entity Value NotEqual: Entity .!=. PRef = LOGICAL
///
public func .!=. <U>(
  lhs: SDAI.EntityReference?, rhs: SDAI.PersistentEntityReference<U>?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }


//MARK: pref vs. select
/// Entity Value Equal: PRef .==. Select = LOGICAL
///
public func .==. <T,US:SDAI.SelectType>(
  lhs: SDAI.PersistentEntityReference<T>?, rhs: US?) -> SDAI.LOGICAL
{ lhs?.eval .==. rhs }

/// Entity Value NotEqual: PRef .!=. Select = LOGICAL
///
public func .!=. <T,US:SDAI.SelectType>(
  lhs: SDAI.PersistentEntityReference<T>?, rhs: US?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }

//MARK: select vs. pref
/// Entity Value Equal: Select .==. PRef = LOGICAL
///
public func .==. <TS:SDAI.SelectType,U>(
  lhs: TS?, rhs: SDAI.PersistentEntityReference<U>?) -> SDAI.LOGICAL
{ rhs .==. lhs }

/// Entity Value NotEqual: Select .!=. PRef = LOGICAL
///
public func .!=. <TS:SDAI.SelectType,U>(
  lhs: TS?, rhs: SDAI.PersistentEntityReference<U>?) -> SDAI.LOGICAL
{ !(lhs .==. rhs) }

