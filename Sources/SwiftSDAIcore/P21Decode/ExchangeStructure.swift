//
//  File.swift
//  
//
//  Created by Yoshida on 2021/04/30.
//

import Foundation

extension P21Decode {
	
	public class ExchangeStructure {
		public var headerSection = HeaderSection()
		public var anchorSection = AnchorSection()
		public var dataSection: [DataSection] = []
		
		public private(set) var valueInstanceRegistory: [ValueInstanceName:ValueInstanceRecord] = [:]
		public private(set) var entityInstanceRegistory: [EntityInstanceName:EntityInstanceRecord] = [:]
		
		public private(set) var error: String?

		public func register(valueInstanceName: ValueInstanceName, reference: Resource) -> Bool {
			let rec = ValueInstanceRecord(reference: reference)
			if let old = valueInstanceRegistory.updateValue(rec, forKey: valueInstanceName) {
				self.error = "duplicated value instance name(\(valueInstanceName)) detected with resource reference(\(reference)), old reference = (\(old))"
				return false
			}
			return true
		}
		
		public func register(entityInstanceName: EntityInstanceName, reference: Resource) -> Bool {
			let rec = EntityInstanceRecord.reference(reference)
			return self.register(entityInstanceName: entityInstanceName, record: rec)
		}
		
		public func register(entityInstanceName: EntityInstanceName, simpleRecord: SimpleRecord, dataSection: DataSection ) -> Bool {
			let rec = EntityInstanceRecord.simpleRecord(simpleRecord, dataSection)
			return self.register(entityInstanceName: entityInstanceName, record: rec)
		}
		
		public func register(entityInstanceName: EntityInstanceName, subsuperRecord: SubsuperRecord, dataSection: DataSection ) -> Bool {
			let rec = EntityInstanceRecord.subsuperRecord(subsuperRecord, dataSection)
			return self.register(entityInstanceName: entityInstanceName, record: rec)
		}
		
		private func register(entityInstanceName: EntityInstanceName, record: EntityInstanceRecord) -> Bool {
			if let old = entityInstanceRegistory.updateValue(record, forKey: entityInstanceName) {
				self.error = "duplicated entity instance name(\(entityInstanceName)) detected with resource reference(\(record)), old reference = (\(old))"
				return false
			}
			return true
		}
		
	}
}


extension P21Decode.ExchangeStructure {
	public class DataSection {
		public typealias SCHEMA_NAME = P21Decode.ExchangeStructure.HeaderSection.FILE_SCHEMA.SCHEMA_NAME
		
		public let name: String
		public let governingSchema: SCHEMA_NAME
		
		public init?(exchange: P21Decode.ExchangeStructure, name: String, schema: SCHEMA_NAME) {
			guard !exchange.dataSection.contains(where: { $0.name == name }) 
			else { exchange.error = "duplicated data section name(\(name))"; return nil }

			guard exchange.headerSection.fileSchema.SCHEMA_IDENTIFIERS.contains(schema)
			else { exchange.error = "governing schema(\(schema)) not found in header section file_schema"; return nil }			
	
			self.name = name
			self.governingSchema = schema
		}
		
		public init?(exchange: P21Decode.ExchangeStructure) {
			guard exchange.headerSection.fileSchema.SCHEMA_IDENTIFIERS.count == 1
			else { exchange.error = "header section file_schema entry shall specify only one schema (while \(exchange.headerSection.fileSchema.SCHEMA_IDENTIFIERS.count) schema found) since data section header does not have PARAMETER_LIST"; return nil }
			self.name = ""
			self.governingSchema = exchange.headerSection.fileSchema.SCHEMA_IDENTIFIERS[0]
		}
	}
	
	public class ValueInstanceRecord {
		public let reference: Resource
		public var resolved: Parameter? = nil
		
		public init(reference: Resource) {
			self.reference = reference
		}
	}
	
	public enum EntityInstanceRecord {
		case reference(Resource)
		case simpleRecord(SimpleRecord, DataSection)
		case subsuperRecord(SubsuperRecord, DataSection)
		case resolved(SDAI.ComplexEntity)
	}
	
	
}
