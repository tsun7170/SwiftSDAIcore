//
//  TypeDefinitions.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/24.
//  Copyright © 2020 Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAIDictionarySchema {
	
	
//	public class TypeDescriptor: SDAI.Object {
//
//		public enum PrimitiveType:Int {
//			case 
//					sdaiINTEGER     = 0x0001,
//					sdaiREAL        = 0x0002,
//					sdaiBOOLEAN     = 0x0004,
//					sdaiLOGICAL     = 0x0008,
//					sdaiSTRING      = 0x0010,
//					sdaiBINARY      = 0x0020,
//					sdaiENUMERATION = 0x0040,
//					sdaiSELECT      = 0x0080,
//					sdaiINSTANCE    = 0x0100,
//					sdaiAGGR        = 0x0200,
//					sdaiNUMBER      = 0x0400,
//			// The elements defined below are not part of part 23
//			// (IMS: these should not be used as bitmask fields)
//					ARRAY_TYPE,     // DAS
//					BAG_TYPE,       // DAS
//					SET_TYPE,       // DAS
//					LIST_TYPE,      // DAS
//					GENERIC_TYPE,
//					REFERENCE_TYPE,
//					UNKNOWN_TYPE
//		}
//	}

	
//	public enum BaseType//: SDAISelectType 
//	{
//		case simpleType(SimpleType)
//		case aggregationType(AggregationType)
//		case namedType(NamedType)
//	}

	
//	public enum UnderlyingType//: SDAISelectType 
//	{
//		case simpleType(SimpleType)
//		case aggregationType(AggregationType)
//		case definedType(DefinedType)
//		case constructedType(ConstructedType)
//	}
	
//	public enum ConstructedType//: SDAISelectType 
//	{
//		case enumerationType(EnumerationType)
//		case selectType(SelectType)
//	}

	
//	public class SimpleType: TypeDescriptor {
//		
//	}

	
//	public class EnumerationType: TypeDescriptor {
////		public var elements: SDAI.LIST<ExpressId>
//	}
	
//	public class SelectType: TypeDescriptor {
////		public var selections: SDAI.SET<NamedType>
//	}

	
//	public class AggregationType: TypeDescriptor {
////		public var elementType: BaseType
//	}
	
	
//MARK: (6.4.10)
	public class NamedType: SDAI.Object {
		public init(name: ExpressId) {
			self.name = name
			super.init()
		}	
		
		public let name: ExpressId
//		public var whereRules: SDAI.LIST<WhereRule> = []
		public unowned var parentSchema: SchemaDefinition!
	}
	
	
//	public class DefinedType : NamedType {
////		public var domain: UnderlyingType
//	}

	
}
