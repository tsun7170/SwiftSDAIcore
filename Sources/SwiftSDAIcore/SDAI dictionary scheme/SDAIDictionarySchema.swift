//
//  SDAIDictionarySchema.swift
//  SwiftSDAIcore
//
//  Created by Yoshida on 2020/05/16.
//  Copyright © 2020 Minokamo, Japan. All rights reserved.
//

import Foundation

public enum SDAIDictionarySchema {
	
		
	public typealias ExpressId = String
	public typealias InfoObjectId = String
	
	
	public class NumberType: SimpleType {
		
	}
	
	public class IntegerType: SimpleType {
		
	}
	
	public class RealType: SimpleType {
//		public var precision: Bound?
	}
	
	public class StringType: SimpleType {
//		public var width: Bound?
//		public var fixedWidth: SDAI.BOOLEAN
	}
	
	public class BinaryType: SimpleType {
//		public var width: Bound?
//		public var fixedWidth: SDAI.BOOLEAN
	}
	
	public class LogicalType: SimpleType {
		
	}
	
	public class BooleanType: SimpleType {
		
	}
	
	
	public class VariableSizeAggregationType: AggregationType {
//		public var lowerBound: Bound
//		public var upperBound: Bound?
	}
	
	public class SetType: VariableSizeAggregationType {
		
	}
	
	public class BagType: VariableSizeAggregationType {
		
	}
	
	public class ListType: VariableSizeAggregationType {
//		public var uniqueFlag: SDAI.BOOLEAN
	}
	
	public class ArrayType: AggregationType {
//		public var lowerIndex: Bound
//		public var upperIndex: Bound
//		public var uniqueFlag: SDAI.BOOLEAN
//		public var optionalFlag: SDAI.BOOLEAN
	}
	
	public class Bound {
		
	}
	
	public class PopulationDependentBound: Bound {
		
	}
	
	public class IntegerBound: Bound {
//		public var boundValue: SDAI.INTEGER
	}
	
	
	public class DomainEquivalentType : NSObject {
//		public var externalTypeId: ExpressId	// Hash key (original type name)
//		public var nativeType: NamedType	// renamed type by USE/REFERENCE
//		public var owner: ExternalSchema	// originating schema
//		
//		private var nextRename: DomainEquivalentType?
//		
//		
	}
	
	
	public enum ExplicitOrDerived: SDAISelectType {
		
		case explicitAttribute(ExplicitAttribute)
		case derivedAttribute(DerivedAttribute)
	}
	
	public class ExternalSchema {
//		public var name: ExpressId
//		public var nativeSchema: SchemaDefinition
//		public var forTypes: SDAI.SET<DomainEquivalentType>
	}

	public class UniquenessRule {
//		public var label: ExpressId?
//		public var attributes: SDAI.LIST<Attribute>
//		public unowned var parentEntity: EntityDefinition
	}
	
	public enum TypeOrRule:SDAISelectType {
//		case namedType(NamedType)
//		case globalRule(GlobalRule)
	}
	
	public class WhereRule {
//		public var label: ExpressId?
//		public var parentItem: TypeOrRule
	}

	public class GlobalRule {
//		public var name: ExpressId
//		public var entities: SDAI.LIST<EntityDefinition>
//		public var whereRules: SDAI.LIST<WhereRule>
//		public unowned var parentSchema: SchemaDefinition
	}
	
	
}





