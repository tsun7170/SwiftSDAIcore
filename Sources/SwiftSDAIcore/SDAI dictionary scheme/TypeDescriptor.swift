//
//  TypeDescriptor.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/24.
//  Copyright © 2020 Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAIDictionarySchema {
	
	
	public class TypeDescriptor: hashable {

		enum PrimitiveType:Int {
			case 
					sdaiINTEGER     = 0x0001,
					sdaiREAL        = 0x0002,
					sdaiBOOLEAN     = 0x0004,
					sdaiLOGICAL     = 0x0008,
					sdaiSTRING      = 0x0010,
					sdaiBINARY      = 0x0020,
					sdaiENUMERATION = 0x0040,
					sdaiSELECT      = 0x0080,
					sdaiINSTANCE    = 0x0100,
					sdaiAGGR        = 0x0200,
					sdaiNUMBER      = 0x0400,
			// The elements defined below are not part of part 23
			// (IMS: these should not be used as bitmask fields)
					ARRAY_TYPE,     // DAS
					BAG_TYPE,       // DAS
					SET_TYPE,       // DAS
					LIST_TYPE,      // DAS
					GENERIC_TYPE,
					REFERENCE_TYPE,
					UNKNOWN_TYPE
		}
		
		public init(name: ExpressId, fundamentalType: PrimitiveType, parentSchema:SchemaDefinition, description: String) {
			
		}

	}

	
	public enum BaseType:SDAI.SELECT, SDAISelectType {
		case simpleType(SimpleType)
		case aggregationType(AggregationType)
		case namedType(NamedType)
	}

	
	public enum UnderlyingType: SDAI.SELECT, SDAISelectType {
		case simpleType(SimpleType)
		case aggregationType(AggregationType)
		case definedType(DefinedType)
		case constructedType(ConstructedType)
	}
	
	public enum ConstructedType:SDAI.SELECT, SDAISelectType {
		case enumerationType(EnumerationType)
		case selectType(SelectType)
	}

	
	public class SimpleType: TypeDescriptor {
		
	}

	
	public class EnumerationType: TypeDescriptor {
		public var elements: SDAI.LIST<ExpressId>
	}
	
	public class SelectType: TypeDescriptor {
		public var selections: SDAI.SET<NamedType>
	}

	
	public class AggregationType: TypeDescriptor {
		public var elementType: BaseType
	}
	

	public class NamedType: TypeDescriptor {
		
		public var name: ExpressId
		public var whereRules: SDAI.LIST<WhereRule> = []
		public var parentSchema: SchemaDefinition
		

	}
	
	public class DefinedType : NamedType {
		public var domain: UnderlyingType
	}

	
}
