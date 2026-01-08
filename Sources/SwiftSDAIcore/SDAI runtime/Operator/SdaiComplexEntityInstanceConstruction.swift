//
//  SdaiComplexEntityInstanceConstruction.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation


//MARK: - Complex entity instance construction operator (12.10)

//MARK: partial vs. xxx
public func .||. (  // DESIGNATED
	partialL: SDAI.PartialEntity, partialR: SDAI.PartialEntity
) -> SDAI.ComplexEntity
{
	return SDAI.ComplexEntity(entities: [partialL,partialR])
}

public func .||. (  // DESIGNATED
	partial: SDAI.PartialEntity, eref: SDAI.EntityReference?
) -> SDAI.ComplexEntity
{
  let pes = [partial] + (eref?.complexEntity.partialEntities ?? [])
  return SDAI.ComplexEntity(entities: pes)
}

public func .||. (  // DESIGNATED
	partial: SDAI.PartialEntity, complex: SDAI.ComplexEntity
) -> SDAI.ComplexEntity
{
	let pes = complex.partialEntities + [partial]
	return SDAI.ComplexEntity(entities: pes)
}

public func .||. <R> (
	partial: SDAI.PartialEntity, pref: SDAI.PersistentEntityReference<R>?
) -> SDAI.ComplexEntity
{ partial .||. pref?.eval }



//MARK: entity ref vs. xxx
public func .||. (
	eref: SDAI.EntityReference?, partial: SDAI.PartialEntity
) -> SDAI.ComplexEntity
{ partial .||. eref }

public func .||. (  // DESIGNATED
	erefL: SDAI.EntityReference?, erefR: SDAI.EntityReference?
) -> SDAI.ComplexEntity
{
  let pes =
  (erefL?.complexEntity.partialEntities ?? []) +
  (erefR?.complexEntity.partialEntities ?? [])
	return SDAI.ComplexEntity(entities: pes)
}

public func .||. (  // DESIGNATED
	eref: SDAI.EntityReference?, complex: SDAI.ComplexEntity
) -> SDAI.ComplexEntity
{
	let pes = (eref?.complexEntity.partialEntities ?? []) + complex.partialEntities
	return SDAI.ComplexEntity(entities: pes)
}

public func .||. <R> (
	eref: SDAI.EntityReference?, pref: SDAI.PersistentEntityReference<R>?
) -> SDAI.ComplexEntity
{ eref .||. pref?.eval }



//MARK: complex vs. xxx
public func .||. (
	complex: SDAI.ComplexEntity, partial: SDAI.PartialEntity
) -> SDAI.ComplexEntity
{ partial .||. complex }

public func .||. (
	complex: SDAI.ComplexEntity, eref: SDAI.EntityReference?
) -> SDAI.ComplexEntity
{ eref .||. complex }

public func .||. (  // DESIGNATED
	complexL: SDAI.ComplexEntity, complexR: SDAI.ComplexEntity
) -> SDAI.ComplexEntity
{
	let pes = complexL.partialEntities + complexR.partialEntities
	return SDAI.ComplexEntity(entities: pes)
}

public func .||. <R> (
	complex: SDAI.ComplexEntity, pref: SDAI.PersistentEntityReference<R>?
) -> SDAI.ComplexEntity
{ complex .||. pref?.eval }



//MARK: persistent reference vs. xxx
public func .||. <L> (
	pref: SDAI.PersistentEntityReference<L>?, partial: SDAI.PartialEntity
) -> SDAI.ComplexEntity
{ pref?.eval .||. partial }

public func .||. <L> (
	pref: SDAI.PersistentEntityReference<L>?, eref: SDAI.EntityReference?
) -> SDAI.ComplexEntity
{ pref?.eval .||. eref }


public func .||. <L> (
	pref: SDAI.PersistentEntityReference<L>?, complex: SDAI.ComplexEntity
) -> SDAI.ComplexEntity
{ pref?.eval .||. complex }

public func .||. <L,R> (
	prefL: SDAI.PersistentEntityReference<L>?, prefR: SDAI.PersistentEntityReference<R>
) -> SDAI.ComplexEntity
{ prefL?.eval .||. prefR.eval }

