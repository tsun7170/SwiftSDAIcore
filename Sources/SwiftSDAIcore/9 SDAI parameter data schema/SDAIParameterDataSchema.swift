//
//  SDAIParameterDataSchema.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/24.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

/// ISO 10303-22 (9) SDAI parameter data schema
/// 
/// The SDAI parameter data schema provides conceptual descriptions of the data that is passed as parameters or manipulated through the SDAI.   
public enum SDAIParameterDataSchema {
	
	public typealias Primitive = SDAI.GenericType
	public typealias StringValue = String
	public typealias IntegerValue = Int
	public typealias BooleanValue = Bool

	public typealias SetInstance = Set
	public typealias ListInstance = Array
		
	
  /// Represents an SDAI entity instance as specified in ISO 10303-22 (9.4.2).
  ///
  /// `EntityInstance` encapsulates the different types of entities manipulated or passed as parameters
  /// within the SDAI parameter data schema. These include application-defined instances, as well as
  /// a range of core SDAI objects such as sessions, repositories, transactions, models, schema instances,
  /// entity definitions, attributes, and bounds.
  ///
  /// - Cases:
  ///   - `applicationInstance(ApplicationInstance)`: An application-defined entity instance.
  ///   - `sdaiSession(SDAISessionSchema.SdaiSession)`: An SDAI session object.
  ///   - `sdaiRepository(SDAISessionSchema.SdaiRepository)`: An SDAI repository object.
  ///   - `sdaiTransaction(SDAISessionSchema.SdaiTransaction)`: An SDAI transaction object.
  ///   - `sdaiModel(SDAIPopulationSchema.SdaiModel)`: An SDAI model object.
  ///   - `sdaiSchemaInstance(SDAIPopulationSchema.SchemaInstance)`: An SDAI schema instance object.
  ///   - `sdaiEntityDefinition(SDAIDictionarySchema.EntityDefinition)`: An SDAI entity definition object.
  ///   - `sdaiAttribute(SDAIDictionarySchema.AttributeType)`: An SDAI attribute type object.
  ///   - `sdaiBound(SDAIDictionarySchema.Bound)`: An SDAI bound object.
  ///
  /// Conforms to `Sendable` for concurrency safety.
	public enum EntityInstance: Sendable {
		case applicationInstance(ApplicationInstance)

		case sdaiSession(SDAISessionSchema.SdaiSession)
		case sdaiRepository(SDAISessionSchema.SdaiRepository)
		case sdaiTransaction(SDAISessionSchema.SdaiTransaction)

		case sdaiModel(SDAIPopulationSchema.SdaiModel)
		case sdaiSchemaInstance(SDAIPopulationSchema.SchemaInstance)

		case sdaiEntityDefinition(SDAIDictionarySchema.EntityDefinition)
		case sdaiAttribute(SDAIDictionarySchema.AttributeType)
		case sdaiBound(SDAIDictionarySchema.Bound)

	}

	
	/// ISO 10303-22 (9.4.3) application_instance
	public typealias ApplicationInstance = SDAI.EntityReference

	/// ISO 10303-22 (9.4.11) aggregate_instance
	public struct AggregateInstance: Sendable {
		public let definition: any SDAI.AggregationType.Type
		public let contents: any SDAI.AggregationType

		public init<AGG: SDAI.AggregationType>(_ aggregate: AGG) {
			self.definition = AGG.self
			self.contents = aggregate
		}
	}

//	public protocol UnorderedCollection: AggregateInstance {
//
//	}
//
//	public protocol SetInstance: UnorderedCollection {
//
//	}
//
//	public protocol BagInstance: UnorderedCollection {
//
//	}
//
//	public protocol OrderedCollection: AggregateInstance {
//
//	}
//
//	public protocol ListInstance: OrderedCollection {
//
//	}
//
//	public protocol ArrayInstance: OrderedCollection {
//
//	}

}
