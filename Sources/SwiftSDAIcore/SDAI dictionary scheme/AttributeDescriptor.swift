//
//  AttributeDescriptor.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/24.
//  Copyright © 2020 Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAIDictionarySchema {
	
	/// attribute descriptor
	public class Attribute: NSObject {
		
//		public var name: ExpressId
//		public unowned var parentEntity: EntityDefinition
//		
//		public enum AttributeType {
//			case
//			explicit,
//			inverse,
//			deriving,
//			redefining
//		}
//		
//		public private(set) var domain: BaseType
//
//		public init(name:ExpressId, domain:BaseType, optional:SDAI.LOGICAL, unique:SDAI.LOGICAL, type:AttributeType, parentEntity: EntityDefinition) {
//		}		
		
	}
	
	public class ExplicitAttribute: Attribute {
//		public var domain: BaseType
//		public var redeclaring: ExplicitAttribute?
//		public var optionalFlag: SDAI.BOOLEAN
//		
//		public init(name:ExpressId, domain:BaseType, optional:SDAI.LOGICAL, unique:SDAI.LOGICAL, parentEntity: EntityDefinition) {
//			super.init(name: name, domain: domain, optional: optional, unique: unique, type: .explicit, parentEntity: parentEntity)
//		}
		
	}
	
	public class DerivedAttribute: Attribute {
//		public var domain: BaseType
//		public var redeclaring: ExplicitOrDerived?
//		
//		public init(name:ExpressId, domain:BaseType, optional:SDAI.LOGICAL, unique:SDAI.LOGICAL, parentEntity: EntityDefinition, expression:String) {
//			super.init(name: name, domain: domain, optional: optional, unique: unique, type: .deriving, parentEntity: parentEntity)
//		}

		
	}
	
	public class InverseAttribute: Attribute {
//		public var domain: EntityDefinition
//		public var redeclaring: InverseAttribute?
//		public var invertedAttr: ExplicitAttribute
//		public var minCardinality: Bound?
//		public var maxCardinality: Bound?
//		public var duplicates: SDAI.BOOLEAN
//		
//		
//		public init(name:ExpressId, optional:SDAI.LOGICAL, unique:SDAI.LOGICAL, parentEntity: EntityDefinition, invertedAttr: Attribute) {
//			super.init(name: name, domain: invertedAttr.domain, optional: optional, unique: unique, type: .inverse, parentEntity: parentEntity)
//		}
//		
	}
	

	
	
	
}

