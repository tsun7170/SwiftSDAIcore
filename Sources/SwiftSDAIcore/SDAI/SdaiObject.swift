//
//  SdaiObject.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/23.
//  Copyright © 2020 Minokamo, Japan. All rights reserved.
//

import Foundation


public protocol SDAIGenericType {
	associatedtype SwiftType
	
	var asSwiftType: SwiftType {get}
	init(_ swiftValue: SwiftType)
}

public protocol SDAISimpleType: SDAIGenericType 
{
}



public protocol SDAIBagType: SDAIAggregationType {
	mutating func add(member: Element?)
	mutating func remove(member: Element?)
}

public protocol SDAINamedType {
	
}

public protocol SDAIEnumerationType: Hashable {
	
}
public protocol SDAISelectType: Hashable {
	
}

//MARK: - SDAI namespace
public enum SDAI {
	
	public typealias EntityName = SDAIDictionarySchema.ExpressId

	public static let TRUE:LOGICAL = true
	public static let FALSE:LOGICAL = false
	public static let UNKNOWN:LOGICAL = nil
	
	
	
		
	
	
	public typealias ENUMERATION = Int
	
	
	
	public struct ARRAY<ELEMENT>: SDAIAggregationType {
		public typealias Element = ELEMENT?
		
		public var hiBound: SDAI.INTEGER? { return SDAI.INTEGER(bound2) }
		public var hiIndex: SDAI.INTEGER { return self.hiIndex }
		public var loBound: SDAI.INTEGER { return SDAI.INTEGER(bound1) }
		public var loIndex: SDAI.INTEGER { return self.loBound }
		
		public func makeIterator() -> Array<ELEMENT?>.Iterator { return content.makeIterator() }
		public var asSwiftType: Array<ELEMENT?> { return content }
		public var _observer: EntityReferenceObserver?
		
		private var bound1: Int
		private var bound2: Int
		private var content: Array<ELEMENT?>
		public init(bound1: Int, bound2:Int) {
			self.bound1 = bound1
			self.bound2 = bound2
			content = Array(repeating: nil, count: bound2 - bound1 + 1)
		}
		public init(_ swiftValue: Array<ELEMENT?>) {
			content = swiftValue
		}
	}
	
	
	public struct LIST<Element>: SDAIAggregationType {
		public var hiBound: SDAI.INTEGER?
		
		public var hiIndex: SDAI.INTEGER
		
		public var loBound: SDAI.INTEGER
		
		public var loIndex: SDAI.INTEGER
		
		public func makeIterator() -> Array<Element>.Iterator { return content.makeIterator() }
		public var asSwiftType: Array<Element> { return content }
		public var _observer: EntityReferenceObserver?
		
		private var content: Array<Element> = []
		public init(_ swiftValue: Array<Element>) {
			content = swiftValue
		}
		
		public func QUERY(logical_expression: (Element) -> LOGICAL ) -> LIST<Element> {
			return LIST(from: content.filter{ logical_expression($0).isTRUE })
		}
		
	}
	
	
	public struct BAG<Element:Hashable>: SDAIBagType {
		public func makeIterator() -> Array<Element>.Iterator { return content.makeIterator() }
		public var asSwiftType: Array<Element> { return content }
		public var _observer: EntityReferenceObserver?

		private var content: Array<Element> = []
		public init(from swiftArray: Array<Element>) {
			content = swiftArray
		}

		public func QUERY(logical_expression: (Element) -> LOGICAL ) -> BAG<Element> {
			return BAG(from: content.filter{ logical_expression($0).isTRUE })
		}
		
		public mutating func add(member: Element?) {
			guard let member = member else {return}
			content.append(member)
		}
		
		public mutating func remove(member: Element?) {
			guard let member = member else {return}
			if let index = content.lastIndex(of: member) {
				content.remove(at: index)
			}
		}
		
	}
	
	
	public struct SET<Element:Hashable>: SDAIBagType {
		public func makeIterator() -> Set<Element>.Iterator { return content.makeIterator() }
		public var asSwiftType: Array<Element> { return Array(content) }
		public var _observer: EntityReferenceObserver?
		
		private var content: Set<Element> = []
		public init(from swiftSet: Set<Element>) {
			content = swiftSet
		}
		
		public func QUERY(logical_expression: (Element) -> LOGICAL ) -> SET<Element> {
			return SET(from: content.filter{ logical_expression($0).isTRUE })
		}

		public mutating func add(member: Element?) {
			guard let member = member else {return}
			content.insert(member)
		}
		
		public mutating func remove(member: Element?) {
			guard let member = member else {return}
			content.remove(member)
		}
		
	}
	
	
	/// root class for SDAI entities.
	/// used as the implementation of entity_instance in SDAI parameter data schema
	public class SdaiObject: NSObject {
		
	}
	

	//MARK: - PartialEntity
	open class PartialEntity: NSObject {
		public static var entityName: EntityName { abstruct() }
	}
	
	
	//MARK: - ComplexEntity
	open class ComplexEntity: NSObject {
		private var partialEntities: Dictionary<EntityName,(instance:PartialEntity,reference:EntityReference?)> = [:]

		public init(entities:[PartialEntity]) {
			super.init()
			
			for pe in entities {
				partialEntities[type(of: pe).entityName] = (instance:pe, reference:nil)	
			}
		}
		
		public func partialEntityInstance<PENT:PartialEntity>(_ peType:PENT.Type) -> PENT? {
			if let (pe,_) = partialEntities[peType.entityName] {
				return pe as? PENT
			}
			return nil
		}
		
		public func resolvePartialEntityInstance(from namelist:[EntityName]) -> PartialEntity? {
			for entityName in namelist {
				if let (pe,_) = partialEntities[entityName] {
					return pe
				}
			}
			return nil
		}
		
		public func entityReference<EREF:EntityReference>(_ erType:EREF.Type) -> EREF? {
			if let (pe,eref) = partialEntities[erType.partialEntityType.entityName] {
				if eref != nil { return eref as? EREF }
				
				if let eref = EREF(self) {
					partialEntities[erType.partialEntityType.entityName] = (pe,eref)
					return eref
				}
			}
			return nil
		}
		
	}
	
	//MARK: - EntityReference
	open class EntityReference: NSObject {
		public static var partialEntityType: PartialEntity.Type { abstruct() }
					
		public let complexEntity: ComplexEntity
		
		public required init?(_ complexEntity: ComplexEntity) {
			self.complexEntity = complexEntity
			super.init()
		}
		
		public static func cast<EREF:EntityReference>( from source: EREF ) -> Self? {
			return source.complexEntity.entityReference(self)
		}
	}
	
}

