//
//  ReferenceSection.swift
//  
//
//  Created by Yoshida on 2021/05/16.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - reference section related
extension P21Decode.ExchangeStructure {
	
	/// register a LHS_OCCURRENCE_NAME(VALUE_INSTANCE_NAME) and a value RESOURCE association into the exchange structure
	///
	/// - Parameters:
	///   - valueInstanceName: value instance name
	///   - reference: resource reference
	/// - Returns: true when registration is successful
	///
	/// # Reference
	/// 10.1 Reference section structure;
	/// ISO 10303-21
	public func register(valueInstanceName: ValueInstanceName, reference: Resource) -> Bool {
		let rec = ValueInstanceRecord(name: valueInstanceName, reference: reference)
		if let old = valueInstanceRegistry.updateValue(rec, forKey: valueInstanceName) {
			self.error = "duplicated value instance name(\(valueInstanceName)) detected with resource reference(\(reference)), old reference = (\(old))"
			return false
		}
		return true
	}
	
	/// register a LHS_OCCURRENCE_NAME(ENTITY_INSTANCE_NAME) and a entity RESOURCE association into the exchange structure
	///
	/// - Parameters:
	///   - entityInstanceName: entity instance name
	///   - reference: resource reference
	/// - Returns: true when registration is successful
	///
	/// # Reference
	/// 10.1 Reference section structure;
	/// ISO 10303-21
	public func register(entityInstanceName: EntityInstanceName, reference: Resource) -> Bool {
		let rec = EntityInstanceRecord(reference: reference)
		return self.register(entityInstanceName: entityInstanceName, record: rec)
	}
	
  /// A data structure that holds the association between a value instance name and its corresponding value resource within an exchange structure.
  ///
  /// - Note: This record is typically used for registering and tracking value instance names and their associated resources, enabling efficient reference and lookup within the exchange structure.
  /// - SeeAlso: `register(valueInstanceName:reference:)`
  ///
  /// - Parameters:
  ///   - name: The unique name identifying the value instance.
  ///   - reference: The resource associated with the value instance.
  ///   - resolved: Optionally stores the resolved `Parameter` value for the reference, if available.
	public final class ValueInstanceRecord {
    /// The unique name identifying the value instance within the exchange structure.
    ///
    /// This property serves as the key or identifier for the value instance in the reference section,
    /// allowing for efficient lookup, registration, and association with its corresponding resource.
    /// The `name` is used to distinguish between different value instances and is typically referenced
    /// throughout the exchange structure as specified by ISO 10303-21.
    ///
    /// - SeeAlso: `register(valueInstanceName:reference:)`
		public let name: ValueInstanceName
    /// The resource associated with the instance (either value or entity) within the exchange structure.
    /// 
    /// This property stores the `Resource` object that the instance (such as a value or entity) refers to.
    /// It encapsulates the actual value, entity, or resource being referenced in the context of a STEP exchange structure,
    /// enabling resolution and retrieval of referenced data as specified by ISO 10303-21.
    /// 
    /// - SeeAlso: `register(valueInstanceName:reference:)`, `register(entityInstanceName:reference:)`
		public let reference: Resource
    /// Optionally stores the resolved `Parameter` value for the associated resource reference.
    ///
    /// - Discussion: This property holds the actual resolved value of the referenced parameter,
    ///   if it has been determined. When `resolved` is non-`nil`, it indicates that the reference
    ///   has successfully been resolved to its underlying value or entity, as specified by
    ///   the STEP exchange structure semantics. This facilitates efficient lookup and avoids
    ///   repeated resolution work within the exchange process.
    ///
    /// - Note: The value is `nil` until resolution occurs.
    /// - SeeAlso: `Parameter`
		public var resolved: Parameter? = nil
		
    /// Initializes a new `ValueInstanceRecord` with the specified value instance name and resource reference.
    ///
    /// - Parameters:
    ///   - name: The unique identifier for the value instance. This name is typically used to reference the value instance within the exchange structure.
    ///   - reference: The resource associated with the value instance. This resource encapsulates the value or entity being referenced.
    ///
    /// - Note: Upon initialization, the `resolved` property is set to `nil` by default, indicating that the associated parameter has not yet been resolved.
		public init(name: ValueInstanceName, reference: Resource) {
			self.name = name
			self.reference = reference
		}
	}
}
