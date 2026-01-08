//
//  SdaiObject.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/23.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import Synchronization

public protocol SdaiObjectReference: AnyObject, Sendable {
	associatedtype Object: AnyObject & Sendable
	var object: Object {get}
	var objectId: ObjectIdentifier {get}
}


extension SDAI {

	//MARK: - SDAI.Object
	public protocol Object: AnyObject, Hashable {}


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

	//MARK: - SDAI.MutexReference
	public final class MutexReference<T: Sendable>: Object {
		private let mutex: Mutex<T>

		public init(_ initialValue:T) {
			self.mutex = Mutex(initialValue)
		}

		public borrowing func withLock<Result, E>(
			_ body: (inout sending T) throws(E) -> sending Result
		) throws(E) -> sending Result
		where E : Error, Result : ~Copyable
		{
			return try self.mutex.withLock(body)
		}

		public borrowing func withLockIfAvailable<Result, E>(
			_ body: (inout sending T) throws(E) -> sending Result
		) throws(E) -> sending Result?
		where E : Error, Result : ~Copyable
		{
			return try self.mutex.withLockIfAvailable(body)
		}
	}

	
}

//MARK: SDAI.Object implementation
extension SDAI.Object {
	public static func == (lhs: Self, rhs: some SDAI.Object) -> Bool {
		return lhs === rhs
	}

	public func hash(into hasher: inout Hasher) {
		ObjectIdentifier(self).hash(into: &hasher)
	}
}


//MARK: Sendable conformances

extension SDAI.ObjectReference: @unchecked Sendable
where OBJ: Sendable
{}

extension SDAI.UnownedReference: @unchecked Sendable
where OBJ: Sendable
{}

