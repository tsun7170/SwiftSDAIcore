//
//  SDAIPopulationSchema.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/24.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

/// ISO 10303-22 (8) SDAI population schema
/// 
/// The SDAI population schema defines a structure for the organization, creation and management of instances of EXPRESS entities. This schema is interfaced by the SDAI session schema and all items in this schema are resolved into the SDAI session schema in the population of the SDAI dictionary schema (see A.1.1).   
public enum SDAIPopulationSchema {
	public typealias STRING = String
	public typealias SET = Set
	public typealias LOGICAL = SDAI.LOGICAL
	public typealias INTEGER = Int

}
