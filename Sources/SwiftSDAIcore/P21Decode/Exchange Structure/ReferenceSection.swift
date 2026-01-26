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
		public let name: ValueInstanceName
		public let reference: Resource
		public var resolved: Parameter? = nil
		
		public init(name: ValueInstanceName, reference: Resource) {
			self.name = name
			self.reference = reference
		}
	}
}
