//
//  SdaiObject.swift
//  SwiftSDAIcorePackage
//
//  Created by Yoshida on 2020/05/23.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import Synchronization

extension SDAI {
  
  public protocol ObjectReferenceType: AnyObject, Sendable {
    associatedtype Object: AnyObject & Sendable
    var object: Object {get}
    var objectId: ObjectIdentifier {get}
  }
}

extension SDAI {

	//MARK: - SDAI.Object

	public protocol Object: AnyObject, Hashable {}


	//MARK: - SDAI.ObjectReference
  /*
	open class ObjectReference<OBJ: Object>: SDAI.ObjectReferenceType, Hashable {
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
*/

	//MARK: - SDAI.UnownedReference
  /// A reference type that holds an unowned reference to an object conforming to `SDAI.Object`.
  ///
  /// `UnownedReference` is used to reference an object without increasing its retain count,
  /// preventing strong reference cycles while still allowing identity-based operations and hashing.
  /// The reference does not guarantee the object remains alive; accessing `object` after the underlying
  /// object has been deallocated will result in a runtime error.
  ///
  /// - Parameters:
  ///   - OBJ: The type of the referenced object, which must conform to `SDAI.Object`.
  ///
  /// - Important: Use `UnownedReference` only when you can guarantee that the referenced object will
  ///   outlive the reference, as accessing a deallocated object will cause a crash.
  ///
  /// - Conforms To:
  ///   - `SDAI.ObjectReferenceType`
  ///   - `Hashable`
  ///   - `@unchecked Sendable` (when `OBJ: Sendable`)
  ///
  /// - Properties:
  ///   - `object`: The unowned referenced object.
  ///   - `objectId`: The stable identifier for the referenced object.
  ///
  /// - SeeAlso: `SDAI.ObjectReferenceType`
	open class UnownedReference<OBJ: Object>: SDAI.ObjectReferenceType, Hashable {
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
  /*
	public final class ValueReference<T>: Object {
		public var value: T
		
		public init(_ initialValue:T) {
			self.value = initialValue
		}
	}
   */

	//MARK: - SDAI.MutexReference
  /*
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
*/

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
/*
extension SDAI.ObjectReference: @unchecked Sendable
where OBJ: Sendable
{}
*/

extension SDAI.UnownedReference: @unchecked Sendable
where OBJ: Sendable
{}

