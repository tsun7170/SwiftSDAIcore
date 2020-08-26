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

public protocol SDAIGenericType {
	
}

public protocol SDAIAggregationType: Sequence {
	associatedtype Element
	var asArray: Array<Element> {get}
	
	typealias EntityReferenceObserver = (_ removing: SDAI.EntityReference?, _ adding: SDAI.EntityReference?) -> Void
//	var observer: EntityReferenceObserver? { get set }
	var _observer: EntityReferenceObserver? { get set }
//	mutating func resetObserver()

}
public extension SDAIAggregationType where Element: SDAI.EntityReference {
	public var observer: EntityReferenceObserver? {
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
	
	public mutating func resetObserver() {
		_observer = nil
	}
	
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
//	public typealias SELECT = String
	
	public struct AGGREGATE<Element,S:LazySequenceProtocol>: SDAIAggregationType 
	where S.Element==Element {
		public func makeIterator() -> S.Iterator { return content.makeIterator() }
		public var asArray: Array<Element> { return Array(content) }
		public var _observer: EntityReferenceObserver?
		
		
		private var content: S
		public init(from base: S) {
			self.content = base
		}
		public func QUERY(logical_expression:@escaping (Element) -> LOGICAL ) -> AGGREGATE<Element,LazyFilterSequence<S.Elements>> {
			return AGGREGATE<Element,LazyFilterSequence<S.Elements>>(from: content.filter{ logical_expression($0) == TRUE })
		}
	}
	
	public struct ARRAY<Element>: SDAIAggregationType {
		public func makeIterator() -> Array<Element>.Iterator { return content.makeIterator() }
		public var asArray: Array<Element> { return content }
		public var _observer: EntityReferenceObserver?
		
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
		public func makeIterator() -> Array<Element>.Iterator { return content.makeIterator() }
		public var asArray: Array<Element> { return content }
		public var _observer: EntityReferenceObserver?
		
		private var content: Array<Element> = []
		public init(from swiftArray: Array<Element>) {
			content = swiftArray
		}
		
		public func QUERY(logical_expression: (Element) -> LOGICAL ) -> LIST<Element> {
			return LIST(from: content.filter{ logical_expression($0) == TRUE })
		}
		
	}
	
	
	public struct BAG<Element:Hashable>: SDAIBagType {
		public func makeIterator() -> Array<Element>.Iterator { return content.makeIterator() }
		public var asArray: Array<Element> { return content }
		public var _observer: EntityReferenceObserver?

		private var content: Array<Element> = []
		public init(from swiftArray: Array<Element>) {
			content = swiftArray
		}

		public func QUERY(logical_expression: (Element) -> LOGICAL ) -> BAG<Element> {
			return BAG(from: content.filter{ logical_expression($0) == TRUE })
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
		public var asArray: Array<Element> { return Array(content) }
		public var _observer: EntityReferenceObserver?
		
		private var content: Set<Element> = []
		public init(from swiftSet: Set<Element>) {
			content = swiftSet
		}
		
		public func QUERY(logical_expression: (Element) -> LOGICAL ) -> SET<Element> {
			return SET(from: content.filter{ logical_expression($0) == TRUE })
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

