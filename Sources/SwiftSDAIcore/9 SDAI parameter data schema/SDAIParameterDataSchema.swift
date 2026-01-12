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
		
	
	/// ISO 10303-22 (9.4.2) entity_instance
	public enum EntityInstance: Sendable {
		case applicationInstance(ApplicationInstance)

		case sdaiSession(SDAISessionSchema.SdaiSession)
		case sdaiRepository(SDAISessionSchema.SdaiRepository)
		case sdaiTransaction(SDAISessionSchema.SdaiTransaction)

		case sdaiModel(SDAIPopulationSchema.SdaiModel)
		case sdaiSchemaInstance(SDAIPopulationSchema.SchemaInstance)

		case sdaiEntityDefinition(SDAIDictionarySchema.EntityDefinition)
		case sdaiAttribute(SDAIAttributeType)
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
