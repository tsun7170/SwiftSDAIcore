//
//  DataSection.swift
//  
//
//  Created by Yoshida on 2021/05/16.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - data section related
extension P21Decode.ExchangeStructure {
	
	public func register(
		entityInstanceName: EntityInstanceName,
		simpleRecord: SimpleRecord,
		dataSection: DataSection
	) -> Bool
	{
		let rec = EntityInstanceRecord(simpleRecord: simpleRecord, dataSection: dataSection)
		return self.register(entityInstanceName: entityInstanceName, record: rec)
	}
	
	public func register(
		entityInstanceName: EntityInstanceName,
		subsuperRecord: SubsuperRecord,
		dataSection: DataSection
	) -> Bool
	{
		let rec = EntityInstanceRecord(subsuperRecord: subsuperRecord, dataSection: dataSection)
		return self.register(entityInstanceName: entityInstanceName, record: rec)
	}

	//MARK: - DataSection

	/// 11.1 Data section structure;
	/// ISO 10303-21 
	public final class DataSection: CustomStringConvertible {
		
		public unowned let exchangeStructure: P21Decode.ExchangeStructure
		public let name: String
		public let governingSchema: P21Decode.SchemaName
		public private(set) var schema: SDAI.SchemaType.Type? = nil
		public private(set) var model: SDAIPopulationSchema.SdaiModel? = nil
		
		public var description: String {
			return "p21DataSection(\(name))"
		}
		
		public init?(
			exchange: P21Decode.ExchangeStructure,
			name: String, schema: P21Decode.SchemaName
		)
		{
			guard !exchange.dataSections.contains(where: { $0.name == name })
			else { exchange.error = "duplicated data section name(\(name))"; return nil }

			guard exchange.headerSection.fileSchema.SCHEMA_IDENTIFIERS.contains(schema)
			else { exchange.error = "governing schema(\(schema)) not found in header section file_schema"; return nil }			
	
			self.exchangeStructure = exchange
			self.name = name
			self.governingSchema = schema
		}
		
		public init?(exchange: P21Decode.ExchangeStructure)
		{
			guard exchange.headerSection.fileSchema.SCHEMA_IDENTIFIERS.count == 1
			else { exchange.error = "header section file_schema entry shall specify only one schema (while \(exchange.headerSection.fileSchema.SCHEMA_IDENTIFIERS.count) schema found) since data section header does not have PARAMETER_LIST"; return nil }
			
			self.exchangeStructure = exchange
			self.name = "PRIMARY"
			self.governingSchema = exchange.headerSection.fileSchema.SCHEMA_IDENTIFIERS[0]
		}
		
		public func resolveSchema() -> Bool {
			guard let resolved = exchangeStructure.resolve(schemaName: governingSchema)
			else { exchangeStructure.add(errorContext: "while resolving governing schema[\(governingSchema)] for data section(\(self.name))"); return false }
			self.schema = resolved
			return true
		}
		
		/// assign a new RW SDAI-model for decoding operation
		/// - Parameters:
		///   - filename: data source file name
		///   - repository: repository to which decoded SDAI-model is saved
		///   - transaction: RW transaction
		/// - Returns: created RW model
		///
		public func assignModel(
			filename: String,
			repository: SDAISessionSchema.SdaiRepository,
			transaction: SDAISessionSchema.SdaiTransactionRW
		) -> SDAIPopulationSchema.SdaiModel?
		{
			let modelname = self.name != "" ? filename + "." + self.name : filename
			
			let repository = exchangeStructure.repository
			guard let schemaDef = schema?.schemaDefinition
			else {
				exchangeStructure.error = "internal error on assigning model to data section"
				return nil
			}

			guard let model = transaction
				.createSdaiModel(
					repository: repository,
					modelName: modelname,
					schema: schemaDef
				)
			else {
				exchangeStructure.error = "could not create a new SDAI-model into repository[\(repository.name)]"
				return nil
			}

			guard let promotedModel = transaction.startReadWriteAccess(model: model)
			else {
				exchangeStructure.error = "could not promote the created SDAI-model to read-write mode."
				return nil
			}

			self.model = promotedModel

			return self.model
		}
	}

	//MARK: - EntityInstanceRecord

	public final class EntityInstanceRecord {
		public var source: Source
		public var resolved: SDAI.ComplexEntity? = nil
		
		public init(reference: Resource) {
			self.source = .reference(reference)
		}
		
		public init(
			simpleRecord: SimpleRecord,
			dataSection: DataSection
		)
		{
			self.source = .simpleRecord(simpleRecord, dataSection)
		}
		
		public init(
			subsuperRecord: SubsuperRecord,
			dataSection: DataSection
		)
		{
			self.source = .subsuperRecord(subsuperRecord, dataSection)
		}
		
		/// entity instance source type classification
		/// 5.5 WSN of the exchange structure;
		/// ISO 10303-21 
		public enum Source {
			case reference(Resource)													// REFERENCE = LHS_OCCURENCE_NAME "=" RESOURCE ";"
			case simpleRecord(SimpleRecord, DataSection)			// KEYWORD "(" [ PARAMETER_LIST ] ")"
			case subsuperRecord(SubsuperRecord, DataSection)	// "(" SIMPLE_RECORD_LIST ")"
		}
	}
	
	
	
}
