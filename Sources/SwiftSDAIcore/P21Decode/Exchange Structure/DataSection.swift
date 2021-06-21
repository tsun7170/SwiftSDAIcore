//
//  File.swift
//  
//
//  Created by Yoshida on 2021/05/16.
//

import Foundation

//MARK: - data section related
extension P21Decode.ExchangeStructure {
	
	public func register(entityInstanceName: EntityInstanceName, simpleRecord: SimpleRecord, dataSection: DataSection ) -> Bool {
		let rec = EntityInstanceRecord(simpleRecord: simpleRecord, dataSection: dataSection)
		return self.register(entityInstanceName: entityInstanceName, record: rec)
	}
	
	public func register(entityInstanceName: EntityInstanceName, subsuperRecord: SubsuperRecord, dataSection: DataSection ) -> Bool {
		let rec = EntityInstanceRecord(subsuperRecord: subsuperRecord, dataSection: dataSection)
		return self.register(entityInstanceName: entityInstanceName, record: rec)
	}
		
	public final class DataSection: CustomStringConvertible {
		
		public unowned let exchangeStructure: P21Decode.ExchangeStructure
		public let name: String
		public let governingSchema: P21Decode.SchemaName
		public private(set) var schema: SDAISchema.Type? = nil
		public private(set) var model: SDAIPopulationSchema.SdaiModel? = nil
		
		public var description: String {
			return "p21DataSection(\(name))"
		}
		
		public init?(exchange: P21Decode.ExchangeStructure, name: String, schema: P21Decode.SchemaName) {
			guard !exchange.dataSection.contains(where: { $0.name == name }) 
			else { exchange.error = "duplicated data section name(\(name))"; return nil }

			guard exchange.headerSection.fileSchema.SCHEMA_IDENTIFIERS.contains(schema)
			else { exchange.error = "governing schema(\(schema)) not found in header section file_schema"; return nil }			
	
			self.exchangeStructure = exchange
			self.name = name
			self.governingSchema = schema
		}
		
		public init?(exchange: P21Decode.ExchangeStructure) {
			guard exchange.headerSection.fileSchema.SCHEMA_IDENTIFIERS.count == 1
			else { exchange.error = "header section file_schema entry shall specify only one schema (while \(exchange.headerSection.fileSchema.SCHEMA_IDENTIFIERS.count) schema found) since data section header does not have PARAMETER_LIST"; return nil }
			
			self.exchangeStructure = exchange
			self.name = "PRIMARY"
			self.governingSchema = exchange.headerSection.fileSchema.SCHEMA_IDENTIFIERS[0]
		}
		
		public func resolveSchema() -> Bool {
			guard let resolved = exchangeStructure.resolve(schemaName: governingSchema)
			else { exchangeStructure.add(errorContext: "while resolving governing schema for data section(\(self.name))"); return false }
			self.schema = resolved
			return true
		}
		
		public func assignModel(filename: String) -> Bool {
			let modelname = self.name != "" ? filename + "." + self.name : filename
			
			guard let repository = exchangeStructure.repository, let schemaDef = schema?.schemaDefinition 
			else { exchangeStructure.error = "internal error on assigning model to data section"; return false }
			
			self.model = SDAIPopulationSchema.SdaiModel(repository: repository, modelName: modelname, schema: schemaDef)
			return true
		}
	}
	
	public final class EntityInstanceRecord {
		public var source: Source
		public var resolved: SDAI.ComplexEntity? = nil
//		public var historical: [Source] = []
		
		public init(reference: Resource) {
			self.source = .reference(reference)
		}
		
		public init(simpleRecord: SimpleRecord, dataSection: DataSection) {
			self.source = .simpleRecord(simpleRecord, dataSection)
		}
		
		public init(subsuperRecord: SubsuperRecord, dataSection: DataSection) {
			self.source = .subsuperRecord(subsuperRecord, dataSection)
		}
		
		public enum Source {
			case reference(Resource)
			case simpleRecord(SimpleRecord, DataSection)
			case subsuperRecord(SubsuperRecord, DataSection)
		}
	}
	
	
	
}
