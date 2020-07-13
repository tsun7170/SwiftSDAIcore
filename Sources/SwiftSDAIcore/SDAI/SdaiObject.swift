//
//  SdaiObject.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/23.
//  Copyright © 2020 Minokamo, Japan. All rights reserved.
//

import Foundation


public protocol SDAISimpleType {
}
public protocol SDAINumberType: SDAISimpleType {
	
}
public protocol SDAIRealType: SDAINumberType {
	
}

public protocol SDAILogicalType: SDAISimpleType {
	
}

public protocol SDAIAggregationType: Sequence {
	associatedtype Element
	var asArray: Array<Element> {get}
	
	typealias EntityReferenceObserver = @escaping (_ removing: SDAI.EntityReference?, _ adding: SDAI.EntityReference?) -> Void
	var observer: EntityReferenceObserver? { get set }
	var _observer: EntityReferenceObserver? { get set }
	mutating func resetObserver()

}
extension SDAIAggregationType where Element: SDAI.EntityReference {
	var observer: EntityReferenceObserver? {
		get { _observer }
		set {
			if let oldObserver = observer, newValue == nil {	// removing observer
				for entity in self {
					oldObserver( entity, nil )
				}
			}
			else if let newObserver = newValue, observer == nil { // setting observer
				for entity in self {
					newObserver( nil, entity )
				}
			}
			else {	// replacing observer
				fatalError("can not replace observer")
			}
		} // setter
	}
	mutating func resetObserver() {
		_observer = nil
	}
	
}



public protocol SDAIBagType: SDAIAggregationType {
	func add(member: Element?)
	func remove(member: Element?)
}

public protocol SDAINamedType {
	
}

public protocol SDAIEnumerationType {
	
}
public protocol SDAISelectType {
	
}

public enum SDAI: NameSpace {
	public typealias RawValue = NameSpace
	
	
	public typealias BOOLEAN = Bool
	public typealias LOGICAL = Bool?
	public static let TRUE:BOOLEAN = true
	public static let FALSE:BOOLEAN = false
	public static let UNKNOWN:LOGICAL = nil
	
	public typealias REAL = Double
	public typealias INTEGER = Int
	public typealias STRING = String
	
	public struct BINARY {
		private var content: String = ""
//		public init(_ str: String = "", max: Int = 0 ) {
//			content = str.prefix(max)
//		}
	}
	
	public typealias ENUMERATION = Int
	public typealias SELECT = String
	
	
	public struct ARRAY<Element>: SDAIAggregationType {
		public var bound1: Int
		public var bound2: Int
		private var content: Array<Element> = []
		public init(bound1: Int, bound2:Int) {
			self.bound1 = bound1
			self.bound2 = bound2
			content.reserveCapacity(bound2 - bound1 + 1)
		}
	}
	
	
	public struct LIST<Element>: SDAIAggregationType {
		private var content: [Element] = []
		public init(from swiftArray: [Element]) {
			content = swiftArray
		}
		
		public func QUERY(logical_expression: (Element) -> LOGICAL ) -> LIST<Element> {
			return LIST(from: content.filter{ logical_expression($0) == TRUE })
		}
		
	}
	
	
	public struct BAG<Element:Hashable>: SDAIBagType {
		private var content: [Element] = []
		public init(from swiftArray: [Element]) {
			content = swiftArray
		}

		public func QUERY(logical_expression: (Element) -> LOGICAL ) -> BAG<Element> {
			return BAG(from: content.filter{ logical_expression($0) == TRUE })
		}
		
	}
	
	
	public struct SET<Element:Hashable>: SDAIBagType {
		private var content: Set<Element> = []
		public init(from swiftSet: Set<Element>) {
			content = swiftSet
		}
		
		public func QUERY(logical_expression: (Element) -> LOGICAL ) -> SET<Element> {
			return SET(from: content.filter{ logical_expression($0) == TRUE })
		}
	}
	
	
	/// root class for SDAI entities.
	/// used as the implementation of entity_instance in SDAI parameter data schema
	public class SdaiObject: NSObject {
		
	}
	
//	public class DirectAccessObject: SdaiObject {
//		
//	}
//	public class DirectAccessObjectSDAI: DirectAccessObject {
//		
//	}

	public class PartialEntity {
//		var complexEntity: ComplexEntity
	}
	
	public class ComplexEntity {
		typealias EntityName = SDAIDictionarySchema.ExpressId
//		var partialEntities: Dictionary<PartialEntity.Type,(instance:PartialEntity,reference:EntityReference?)> = [:]
		func partialEntityInstance<PE:PartialEntity>(_ peType:PE.type) -> PE? {
			
		}
	}
	
	public class EntityReference {
		static let partialEntityType: PartialEntity.Type
		
		var complexEntity: ComplexEntity
		var partialEntity: PartialEntity
		var SUPER: Array<EntityReference>
	}
	
}

