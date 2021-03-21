//
//  File.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//

import Foundation


//MARK: - Complex entity instance construction operator
public func .||. (lhs: SDAI.PartialEntity, rhs: SDAI.PartialEntity) -> SDAI.ComplexEntity  { abstruct() }
public func .||. (lhs: SDAI.PartialEntity, rhs: SDAI.EntityReference?) -> SDAI.ComplexEntity  { abstruct() }
public func .||. (lhs: SDAI.PartialEntity, rhs: SDAI.ComplexEntity) -> SDAI.ComplexEntity  { abstruct() }

public func .||. (lhs: SDAI.EntityReference?, rhs: SDAI.PartialEntity) -> SDAI.ComplexEntity  { abstruct() }
public func .||. (lhs: SDAI.EntityReference?, rhs: SDAI.EntityReference?) -> SDAI.ComplexEntity  { abstruct() }
public func .||. (lhs: SDAI.EntityReference?, rhs: SDAI.ComplexEntity) -> SDAI.ComplexEntity  { abstruct() }

public func .||. (lhs: SDAI.ComplexEntity, rhs: SDAI.PartialEntity) -> SDAI.ComplexEntity  { abstruct() }
public func .||. (lhs: SDAI.ComplexEntity, rhs: SDAI.EntityReference?) -> SDAI.ComplexEntity  { abstruct() }
public func .||. (lhs: SDAI.ComplexEntity, rhs: SDAI.ComplexEntity) -> SDAI.ComplexEntity  { abstruct() }

