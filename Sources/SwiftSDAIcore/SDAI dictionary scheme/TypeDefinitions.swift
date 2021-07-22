//
//  TypeDefinitions.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/24.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAIDictionarySchema {
	
	
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
