//
//  TypeDefinitions.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/24.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAIDictionarySchema {
	
	//MARK: - ISO 10303-22 (6.3) SDAI dictionary schema type definitions
	
	/// ISO 10303-22 (6.3.1) base_type
	/// 
	/// A BaseType is a selection of a SimpleType, an AggregationType, or a NamedType.
	/// These are the data types that may be used as the value for an attribute or as an element of an aggregate. 
	public typealias BaseType = SDAI.BaseType

	
	/// ISO 10303-22 (6.3.2) constructed_type
	/// 
	/// A ConstructedType is a selection of an EnumerationType or a SelectType.
	/// These are data types with a syntactic structure that are used to provide a representation of an EXPRESS defined data type. 
	public typealias ConstructedType = SDAI.ConstructedType
	
	
	/// ISO 10303-22 (6.3.3) underlying_type
	/// 
	/// An UnderlyingType is a selection of a SimpleType, an AggregationType, a DefinedType, or a ConstructedType.
	/// These are the data types that are used to provide the representation of an EXPRESS defined data type.  
	public typealias UnderlyingType = SDAI.UnderlyingType

	
	/// ISO 10303-22 (6.3.6) express_id
	/// 
	/// An ExpressId is an EXPRESS identifier (see ISO 10303-11: 7.4) for an item declared in an EXPRESS schema.
	/// Although ISO 10303-11 states that the case of letters is not significant for EXPRESS identifiers, lower case letters shall be used as the values of the attributes of the SDAI dictionary schema whose domain is defined by an express_id (NOT IMPLEMENTED; instead upper case letters are used which is more convenient in many situations in the present implementation).
	public typealias ExpressId = String


	/// ISO 10303-22 (6.3.7) info_object_id
	/// 
	/// An InfoObjectId is an unambiguous information object identifier for an EXPRESS schema in an open system (see annex C). 
	public typealias InfoObjectId = String

	
	//MARK: - ISO 10303-22 (6.4) SDAI dictionary schema entity definitions
	
	/// ISO 10303-22 (6.4.10) named_type
	/// 
	/// A NamedType is an EXPRESS data type that has a name and that may have applicable domain rules. 
	public class NamedType: SDAI.Object, @unchecked Sendable
	{
		//MARK: Attribute definitions:
		
		/// the name of the data type.
		public let name: ExpressId

//		public var whereRules: SDAI.LIST<WhereRule> = []
		
		/// the SchemaDefinition with which the NamedType is associated in the data dictionary.
		public var parentSchema: SchemaDefinition { self._parentSchema! }

		//MARK: swift language binding
		public init(name: ExpressId) {
			self.name = name
//			super.init()
		}
//		public init(byFreezing proto: Prototype) {
//			self.name = proto.name
//			super.init()
//		}

		private unowned var _parentSchema: SchemaDefinition?

		internal func fixup(parentSchema: SchemaDefinition) {
			self._parentSchema = parentSchema
		}


//
//		//MARK: prototype for instance construction
//		public class Prototype
//		{
//			let name: ExpressId
//
//			public init(name: ExpressId) {
//				self.name = name
//			}
//		}
	}

	
	/// ISO 10303-22 (6.4.11) defined_type
	/// 
	/// A DefinedType is a NamedType establishing a type as the result of the EXPRESS TYPE declaration.
	/// A DefinedType has a name and a domain.  
	public typealias DefinedType = SDAI.DefinedType
	
	

	/// ISO 10303-22 (6.4.20) simple_type
	/// 
	/// A SimpleType is an EXPRESS unstructured, built-in base type.  
	public typealias SimpleType = SDAI.SimpleType

	/// ISO 10303-22 (6.4.21) number_type
	/// 
	/// A NumberType is a SimpleType that represents the EXPRESS NUMBER type.  
	public typealias NumberType = SDAI.NUMBER
	

	/// ISO 10303-22 (6.4.22) integer_type
	/// 
	/// An IntegerType is a SimpleType that represents the EXPRESS INTEGER type.
	public typealias IntegerType = SDAI.INTEGER


	/// ISO 10303-22 (6.4.23) real_type
	/// 
	/// A RealType is a SimpleType that represents the EXPRESS REAL type. 
	/// The minimum number of significant digits in a value of the REAL type may be specified(NOT IMPLEMENTED).   
	public typealias RealType = SDAI.REAL


	/// ISO 10303-22 (6.4.24) string_type
	/// 
	/// A StringType is a SimpleType that represents the EXPRESS STRING type.
	/// A STRING is of either fixed ro variable width(NOT IMPLEMENTED).
	/// The width of a STRING may be specified(NOT IMPLEMENTED). 
	public typealias StringType = SDAI.STRING
	

	/// ISO 10303-22 (6.4.25) binary_type
	/// 
	/// A BinaryType is a SimpleType that represents the EXPRESS BINARY type.
	/// A BINARY is of either fixed or variable width(NOT IMPLEMENTED).
	/// The width of a BINARY may be specified(NOT IMPLEMENTED). 
	public typealias BinaryType = SDAI.BINARY


	/// ISO 10303-22 (6.4.26) logical_type
	/// 
	/// A LogicalType is a SimpleType that represents the EXPRESS LOGICAL type. 
	public typealias LogicalType = SDAI.LOGICAL


	/// ISO 10303-22 (6.4.27) boolean_type
	/// 
	/// A BooleanType is a SimpleType that represents the EXPRESS BOOLEAN type. 
	public typealias BooleanType = SDAI.BOOLEAN
	
	
	/// ISO 10303-33 (6.4.28) enumeration_type
	/// 
	/// AN EnumerationType represents the EXPRESS ENUMERATION type.   
	public typealias EnumerationType = SDAI.EnumerationType

	
	/// ISO 10303-22 (6.4.29) select_type
	/// 
	/// A SelectType represents the EXPRESS SELECT type.    
	public typealias SelectType = SDAI.SelectType
	

	/// ISO 10303-22 (6.4.30) aggregation_type
	/// 
	/// An AggregationType is an EXPRESS data type whose values are collections of other values of a given base type.  
	public typealias AggregationType = SDAI.AggregationType
	
	
	/// ISO 10303-22 (6.4.31) variable_size_agregation_type
	/// 
	/// A VariableSizeAggregationType is an AggregationType that may be declared as having a variable number of elements.
	/// The number of elements is bounded from below and may be bounded from above. 
	public typealias VariableSizeAggregationType = SDAI.AggregationType

	
	/// ISO 10303-22 (6.4.32) set_type
	/// 
	/// A SetType is a VariableSizeAggregationType that represents the EXPRESS SET type. 
	public typealias SetType = SDAI.SET


	/// ISO 10303-22 (6.4.33) bag_type
	/// 
	/// A BagType is a VariableSizeAggregationType that represents the EXPRESS BAG type. 
	public typealias BagType = SDAI.BAG


	/// ISO 10303-22 (6.4.34) list_type
	/// 
	///  ListType is a VariableSizeAggregationType that represents the EXPRESS LIST type.
	///  The elements of a list may be required to be unique. 
	public typealias ListType = SDAI.LIST__TypeBehavior



	///ISO 10303-22 (6.4.35) array_type
	///
	///An ArrayType is an AggregationType that represents the EXPRESS ARRAY type.
	///An array has lower and upper index values.
	///The elements of an array are required to be unique if the UNIQUE keyword was specified.
	///An array may contain indeterminate values at one or more index positions if the OPTIONAL keyword was specified. 
	public typealias ArrayType = SDAI.ArrayOptionalType

	
	/// ISO 10303-22 (6.4.36) bound
	/// 
	/// A Bound is a limit on an EXPRESS aggregation, binary, string or real type specified as an integer-valued numeric expression.
	/// The value of the Bound may be based solely on the schema within which it is declared or may depend upon a population of that schema.
	public typealias Bound = Int


	/// ISO 10303-22 (6.4.37) population_dependent_bound
	/// 
	/// A PopulationDependentBound is a Bound whose value depends on a population of the schema within which it is declared.  	
	public typealias PopulationDependentBound = Int


	/// ISO 10303-22 (6.4.38) integer_bound
	/// 
	/// An IntegerBound is a Bound whose value is based solely on the schema within which it is declared. 	
	public typealias IntegerBound = Int

}
