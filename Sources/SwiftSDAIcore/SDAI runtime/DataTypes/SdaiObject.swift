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
  
  /// A protocol representing a type that references an object conforming to `AnyObject` and `Sendable`.
  ///
  /// `ObjectReferenceType` establishes a common interface for types that hold references to objects,
  /// providing access to both the underlying object and its unique identifier. Conforming types are
  /// expected to manage the reference semantics (strong, weak, unowned) as appropriate to their use case.
  ///
  /// - Associatedtype:
  ///   - `Object`: The type of the referenced object, which must conform to `AnyObject` and `Sendable`.
  ///
  /// - Properties:
  ///   - `object`: The referenced object instance.
  ///   - `objectId`: A stable identifier for the referenced object, typically using `ObjectIdentifier`.
  ///
  /// - Conforms To:
  ///   - `AnyObject`
  ///   - `Sendable`
  ///
  /// - Note: The reference model (ownership or non-ownership) is determined by the concrete conforming type.
  ///   For example, an `UnownedReference` holds an unowned reference, while a (potential) `ObjectReference`
  ///   could hold a strong reference.
  ///
  /// - SeeAlso: `SDAI.UnownedReference`
  public protocol ObjectReferenceType: AnyObject, Sendable {
    associatedtype Object: AnyObject & Sendable
    var object: Object {get}
    var objectId: ObjectIdentifier {get}
  }
}

extension SDAI {

	//MARK: - SDAI.Object

  /// A protocol representing an SDAI object.
  ///
  /// `Object` serves as the base protocol for types considered as objects within the SDAI (Standard Data Access Interface) framework.
  /// Conforming types must be class-bound (`AnyObject`) and hashable by identity.
  ///
  /// - Conforms To:
  ///   - `AnyObject` — indicating reference semantics and class types only.
  ///   - `Hashable` — conforming types can be used as hashable keys, typically relying on identity (using `ObjectIdentifier`).
  ///
  /// - Note:
  ///   Equality (`==`) and hash value are based on object identity rather than value-based comparison, ensuring two references to the same underlying instance are considered equal.
	public protocol Object: AnyObject, Hashable {}



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

extension SDAI.UnownedReference: @unchecked Sendable
where OBJ: Sendable
{}

