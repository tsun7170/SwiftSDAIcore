//
//  SdaiObject.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/23.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation


public protocol SdaiObjectReference: AnyObject{
	associatedtype Object: AnyObject
	var object: Object {get}
	var objectId: ObjectIdentifier {get}
}

//MARK: - SDAI namespace
public enum SDAI {
	public typealias GENERIC_ENTITY = EntityReference

	public static let TRUE:LOGICAL = true
	public static let FALSE:LOGICAL = false
	public static let UNKNOWN:LOGICAL = nil
	
	public static let CONST_E:REAL = REAL(exp(1.0))
	public static let PI:REAL = REAL(Double.pi)
	
	public static let _Infinity:INTEGER? = nil;

	//MARK: - validation related	
	public typealias WhereLabel = SDAIDictionarySchema.ExpressId
	
	public typealias GlobalRuleSignature = (_ allComplexEntities: AnySequence<SDAI.ComplexEntity>) -> [SDAI.WhereLabel:SDAI.LOGICAL]
	
	public struct GlobalRuleValidationResult {
		public var globalRule: SDAIDictionarySchema.GlobalRule
		public var result: SDAI.LOGICAL
		public var record: [SDAI.WhereLabel:SDAI.LOGICAL]
	}
	
	public typealias UniquenessRuleSignature = (_ entity: SDAI.EntityReference) -> AnyHashable?
	
	public struct UniquenessRuleValidationResult {
		public var uniquenessRule: SDAIDictionarySchema.UniquenessRule
		public var result: SDAI.LOGICAL
		public var record: (uniqueCount:Int, instanceCount:Int)
	}
	
	public struct WhereRuleValidationResult: CustomStringConvertible {
		public var description: String {
			var str = "WhereRuleValidationResult( result:\(result)\n"
			for (i,(label,whereResult)) in record
				.sorted(by: { $0.key < $1.key })
				.enumerated() {
					str += "[\(i)]\t\(label): \(whereResult)\n"
				}
			str += ")\n"
			return str
		}
		
		public var result: SDAI.LOGICAL
		public var record: [SDAI.WhereLabel:SDAI.LOGICAL]
	}
	
	//MARK: - SDAI.Object	
	open class Object: Hashable {		
		public init() {}
		
		public static func == (lhs: SDAI.Object, rhs: SDAI.Object) -> Bool {
			return lhs === rhs
		}
		
		public func hash(into hasher: inout Hasher) {
			ObjectIdentifier(self).hash(into: &hasher)
		}
	}
	
	//MARK: - SDAI.ObjectReference
	open class ObjectReference<OBJ: Object>: SdaiObjectReference, Hashable {
		public let object: OBJ
		public var objectId: ObjectIdentifier { ObjectIdentifier(object) }
		
		public init(_ object: OBJ) {
			self.object = object
		}

		public static func == (lhs: ObjectReference<OBJ>, rhs: ObjectReference<OBJ>) -> Bool {
			return lhs.object == rhs.object
		}
		
		public func hash(into hasher: inout Hasher) {
			object.hash(into: &hasher)
		}
		
	}
	
	//MARK: - SDAI.UnownedReference
	open class UnownedReference<OBJ: Object>: SdaiObjectReference, Hashable {
		public unowned let object: OBJ
		public let objectId: ObjectIdentifier
		
		public init(_ object: OBJ) {
			self.object = object
			objectId = ObjectIdentifier(object)
		}
		
		public static func == (lhs: UnownedReference<OBJ>, rhs: UnownedReference<OBJ>) -> Bool {
			return lhs.objectId == rhs.objectId
		}
		
		public func hash(into hasher: inout Hasher) {
			objectId.hash(into: &hasher)
		}
	
	}
	
	//MARK: - SDAI.ValueReference
	public final class ValueReference<T>: Object {
		public var value: T
		
		public init(_ initialValue:T) {
			self.value = initialValue
		}
	}
	
	
	
}

