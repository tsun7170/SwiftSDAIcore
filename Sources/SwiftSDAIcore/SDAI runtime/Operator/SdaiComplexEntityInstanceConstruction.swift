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
/// Complex Entity Instance Construction: Partial .||. Partial = Complex
///
public func .||. (  // DESIGNATED
	partialL: SDAI.PartialEntity, partialR: SDAI.PartialEntity
) -> SDAI.ComplexEntity
{
	return SDAI.ComplexEntity(entities: [partialL,partialR])
}

/// Complex Entity Instance Construction: Partial .||. ERef = Complex
///
public func .||. (  // DESIGNATED
	partial: SDAI.PartialEntity, eref: SDAI.EntityReference?
) -> SDAI.ComplexEntity
{
  let pes = [partial] + (eref?.complexEntity.partialEntities ?? [])
  return SDAI.ComplexEntity(entities: pes)
}

/// Complex Entity Instance Construction: Partial .||. Complex = Complex
///
public func .||. (  // DESIGNATED
	partial: SDAI.PartialEntity, complex: SDAI.ComplexEntity
) -> SDAI.ComplexEntity
{
	let pes = complex.partialEntities + [partial]
	return SDAI.ComplexEntity(entities: pes)
}

/// Complex Entity Instance Construction: Partial .||. PRef = Complex
///
public func .||. <R> (
	partial: SDAI.PartialEntity, pref: SDAI.PersistentEntityReference<R>?
) -> SDAI.ComplexEntity
{ partial .||. pref?.eval }



//MARK: entity ref vs. xxx

/// Complex Entity Instance Construction: ERef .||. Partial = Complex
///
public func .||. (
	eref: SDAI.EntityReference?, partial: SDAI.PartialEntity
) -> SDAI.ComplexEntity
{ partial .||. eref }

/// Complex Entity Instance Construction: ERef .||. ERef = Complex
///
public func .||. (  // DESIGNATED
	erefL: SDAI.EntityReference?, erefR: SDAI.EntityReference?
) -> SDAI.ComplexEntity
{
  let pes =
  (erefL?.complexEntity.partialEntities ?? []) +
  (erefR?.complexEntity.partialEntities ?? [])
	return SDAI.ComplexEntity(entities: pes)
}

/// Complex Entity Instance Construction: ERef .||. Complex = Complex
///
public func .||. (  // DESIGNATED
	eref: SDAI.EntityReference?, complex: SDAI.ComplexEntity
) -> SDAI.ComplexEntity
{
	let pes = (eref?.complexEntity.partialEntities ?? []) + complex.partialEntities
	return SDAI.ComplexEntity(entities: pes)
}

/// Complex Entity Instance Construction: ERef .||. PRef = Complex
///
public func .||. <R> (
	eref: SDAI.EntityReference?, pref: SDAI.PersistentEntityReference<R>?
) -> SDAI.ComplexEntity
{ eref .||. pref?.eval }



//MARK: complex vs. xxx

/// Complex Entity Instance Construction: Complex .||. Partial = Complex
///
public func .||. (
	complex: SDAI.ComplexEntity, partial: SDAI.PartialEntity
) -> SDAI.ComplexEntity
{ partial .||. complex }

/// Complex Entity Instance Construction: Complex .||. ERef = Complex
///
public func .||. (
	complex: SDAI.ComplexEntity, eref: SDAI.EntityReference?
) -> SDAI.ComplexEntity
{ eref .||. complex }

/// Complex Entity Instance Construction: Complex .||. Complex = Complex
///
public func .||. (  // DESIGNATED
	complexL: SDAI.ComplexEntity, complexR: SDAI.ComplexEntity
) -> SDAI.ComplexEntity
{
	let pes = complexL.partialEntities + complexR.partialEntities
	return SDAI.ComplexEntity(entities: pes)
}

/// Complex Entity Instance Construction: Complex .||. PRef = Complex
///
public func .||. <R> (
	complex: SDAI.ComplexEntity, pref: SDAI.PersistentEntityReference<R>?
) -> SDAI.ComplexEntity
{ complex .||. pref?.eval }



//MARK: persistent reference vs. xxx

/// Complex Entity Instance Construction: PRef .||. Partial = Complex
///
public func .||. <L> (
	pref: SDAI.PersistentEntityReference<L>?, partial: SDAI.PartialEntity
) -> SDAI.ComplexEntity
{ pref?.eval .||. partial }

/// Complex Entity Instance Construction: PRef .||. ERef = Complex
///
public func .||. <L> (
	pref: SDAI.PersistentEntityReference<L>?, eref: SDAI.EntityReference?
) -> SDAI.ComplexEntity
{ pref?.eval .||. eref }


/// Complex Entity Instance Construction: PRef .||. Complex = Complex
///
public func .||. <L> (
	pref: SDAI.PersistentEntityReference<L>?, complex: SDAI.ComplexEntity
) -> SDAI.ComplexEntity
{ pref?.eval .||. complex }

/// Complex Entity Instance Construction: PRef .||. PRef = Complex
///
public func .||. <L,R> (
	prefL: SDAI.PersistentEntityReference<L>?, prefR: SDAI.PersistentEntityReference<R>
) -> SDAI.ComplexEntity
{ prefL?.eval .||. prefR.eval }

