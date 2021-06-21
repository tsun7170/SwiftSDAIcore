//
//  File.swift
//  
//
//  Created by Yoshida on 2021/05/16.
//

import Foundation

//MARK: - reference section related
extension P21Decode.ExchangeStructure {
	
	public func register(valueInstanceName: ValueInstanceName, reference: Resource) -> Bool {
		let rec = ValueInstanceRecord(name: valueInstanceName, reference: reference)
		if let old = valueInstanceRegistory.updateValue(rec, forKey: valueInstanceName) {
			self.error = "duplicated value instance name(\(valueInstanceName)) detected with resource reference(\(reference)), old reference = (\(old))"
			return false
		}
		return true
	}
	
	public func register(entityInstanceName: EntityInstanceName, reference: Resource) -> Bool {
		let rec = EntityInstanceRecord(reference: reference)
		return self.register(entityInstanceName: entityInstanceName, record: rec)
	}
		
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
