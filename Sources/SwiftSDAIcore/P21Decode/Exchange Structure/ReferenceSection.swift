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
	
	/// register a LHS_OCCURENCE_NAME(VALUE_INSTANCE_NAME) and a value RESOURCE association into the exchange strucute
	/// 
	/// - Parameters:
	///   - valueInstanceName: value instance name
	///   - reference: resource reference
	/// - Returns: true when registoration is successful
	///
	/// # Reference
	/// 10.1 Reference section struture;
	/// ISO 10303-21
	public func register(valueInstanceName: ValueInstanceName, reference: Resource) -> Bool {
		let rec = ValueInstanceRecord(name: valueInstanceName, reference: reference)
		if let old = valueInstanceRegistory.updateValue(rec, forKey: valueInstanceName) {
			self.error = "duplicated value instance name(\(valueInstanceName)) detected with resource reference(\(reference)), old reference = (\(old))"
			return false
		}
		return true
	}
	
	/// register a LHS_OCCURENCE_NAME(ENTITY_INSTANCE_NAME) and a entity RESOURCE association into the exchange strucute
	/// 
	/// - Parameters:
	///   - entityInstanceName: entity instance name
	///   - reference: resource reference
	/// - Returns: true when registoration is successful
	///
	/// # Reference
	/// 10.1 Reference section struture;
	/// ISO 10303-21
	public func register(entityInstanceName: EntityInstanceName, reference: Resource) -> Bool {
		let rec = EntityInstanceRecord(reference: reference)
		return self.register(entityInstanceName: entityInstanceName, record: rec)
	}
	
	/// data structure holding a value instance name and value resource association
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
