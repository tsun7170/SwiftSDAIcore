//
//  AttributeDefinition.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/24.
//  Copyright © 2020 Minokamo, Japan. All rights reserved.
//

import Foundation

extension SDAIDictionarySchema {
	
	public class Attribute: SDAI.Object {
		
		public var name: ExpressId { abstruct() }
		public unowned var parentEntity: EntityDefinition { abstruct() }
		
		
	}
	
	public class ExplicitAttribute: Attribute {
//		public var domain: BaseType
//		public var redeclaring: ExplicitAttribute?
//		public var optionalFlag: SDAI.BOOLEAN
		
	}
	
	public class DerivedAttribute: Attribute {
//		public var domain: BaseType
//		public var redeclaring: ExplicitOrDerived?
		
	}
	
	
	public enum ExplicitOrDerived//: SDAISelectType 
	{
		case explicitAttribute(ExplicitAttribute)
		case derivedAttribute(DerivedAttribute)
	}

	public class InverseAttribute: Attribute {
//		public var domain: EntityDefinition
//		public var redeclaring: InverseAttribute?
//		public var invertedAttr: ExplicitAttribute
//		public var minCardinality: Bound?
//		public var maxCardinality: Bound?
//		public var duplicates: SDAI.BOOLEAN
	}
	

	
	
	
}

