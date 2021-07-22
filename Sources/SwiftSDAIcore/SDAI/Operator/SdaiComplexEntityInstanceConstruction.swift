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
public func .||. (lhs: SDAI.PartialEntity, rhs: SDAI.PartialEntity) -> SDAI.ComplexEntity  { 
	return SDAI.ComplexEntity(entities: [lhs,rhs])
}

public func .||. (lhs: SDAI.PartialEntity, rhs: SDAI.EntityReference?) -> SDAI.ComplexEntity  { 
	if let complex = rhs?.complexEntity {
		return lhs .||. complex
	}
	return SDAI.ComplexEntity(entities: [lhs])
}

public func .||. (lhs: SDAI.PartialEntity, rhs: SDAI.ComplexEntity) -> SDAI.ComplexEntity  { 
	var pes = rhs.partialEntities
	pes.append(lhs)
	return SDAI.ComplexEntity(entities: pes)
}

//MARK: entity ref vs. xxx
public func .||. (lhs: SDAI.EntityReference?, rhs: SDAI.PartialEntity) -> SDAI.ComplexEntity  { rhs .||. lhs }

public func .||. (lhs: SDAI.EntityReference?, rhs: SDAI.EntityReference?) -> SDAI.ComplexEntity  { 
	var pes: [SDAI.PartialEntity] = []
	if let pe = lhs?.complexEntity.partialEntities {
		pes = pe
	}
	if let pe = rhs?.complexEntity.partialEntities {
		pes.append(contentsOf: pe)
	}
	return SDAI.ComplexEntity(entities: pes)
}

public func .||. (lhs: SDAI.EntityReference?, rhs: SDAI.ComplexEntity) -> SDAI.ComplexEntity  { 
	var pes = rhs.partialEntities
	if let pe = lhs?.complexEntity.partialEntities {
		pes.append(contentsOf: pe)
	}
	return SDAI.ComplexEntity(entities: pes)
}

//MARK: complex vs. xxx
public func .||. (lhs: SDAI.ComplexEntity, rhs: SDAI.PartialEntity) -> SDAI.ComplexEntity  { rhs .||. lhs }

public func .||. (lhs: SDAI.ComplexEntity, rhs: SDAI.EntityReference?) -> SDAI.ComplexEntity  { rhs .||. lhs }

public func .||. (lhs: SDAI.ComplexEntity, rhs: SDAI.ComplexEntity) -> SDAI.ComplexEntity  { 
	let pes = lhs.partialEntities + rhs.partialEntities
	return SDAI.ComplexEntity(entities: pes)
}

