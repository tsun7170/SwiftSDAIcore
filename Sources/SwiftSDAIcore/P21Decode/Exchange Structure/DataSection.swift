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
	
  /// Registers a simple entity instance record in the data section of the exchange structure.
  ///
  /// - Parameters:
  ///   - entityInstanceName: The unique identifier for the entity instance within the exchange structure.
  ///   - simpleRecord: The parsed representation of a simple record (entity instance) as found in the STEP data section.
  ///   - dataSection: The `DataSection` to which this entity instance belongs.
  ///
  /// - Returns: `true` if the entity instance record was successfully registered; otherwise, `false`.
  ///
  /// - Discussion:
  ///   This method constructs an `EntityInstanceRecord` using the provided `simpleRecord` and `dataSection`
  ///   and registers it under the specified `entityInstanceName` within the exchange structure.
  ///   It is typically used during the decoding of the STEP data section, when a simple entity instance
  ///   is encountered and needs to be tracked and resolved in the in-memory model.
  ///
  /// - SeeAlso: 
  ///   - `SimpleRecord`
  ///   - `DataSection`
  ///   - `EntityInstanceRecord`
	public func register(
		entityInstanceName: EntityInstanceName,
		simpleRecord: SimpleRecord,
		dataSection: DataSection
	) -> Bool
	{
		let rec = EntityInstanceRecord(simpleRecord: simpleRecord, dataSection: dataSection)
		return self.register(entityInstanceName: entityInstanceName, record: rec)
	}
	
  /// Registers a complex (subsuper) entity instance record in the data section of the exchange structure.
  ///
  /// - Parameters:
  ///   - entityInstanceName: The unique identifier for the entity instance within the exchange structure.
  ///   - subsuperRecord: The parsed representation of a subsuper record (complex entity instance), typically as a list of simple records, found in the STEP data section.
  ///   - dataSection: The `DataSection` to which this entity instance belongs.
  ///
  /// - Returns: `true` if the entity instance record was successfully registered; otherwise, `false`.
  ///
  /// - Discussion:
  ///   This method constructs an `EntityInstanceRecord` using the provided `subsuperRecord` and `dataSection`
  ///   and registers it under the specified `entityInstanceName` within the exchange structure.
  ///   It is usually called during the decoding of the STEP data section when a complex entity instance (consisting of multiple subtypes)
  ///   is encountered and needs to be tracked and resolved in the in-memory model.
  ///
  /// - SeeAlso:
  ///   - `SubsuperRecord`
  ///   - `DataSection`
  ///   - `EntityInstanceRecord`
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
  ///
  /// Represents a data section within a STEP Physical File exchange structure, as defined by ISO 10303-21 (Section 11.1).
  ///
  /// Each `DataSection` is associated with a specific schema and contains decoded entity instances for that schema.
  /// 
  /// - Important: Data section names must be unique within the exchange structure. The governing schema for the section
  ///   must be present in the header section’s `file_schema`.
  ///
  /// - Properties:
  ///   - `exchangeStructure`: The parent `ExchangeStructure` that owns this data section.
  ///   - `name`: The unique name of this data section.
  ///   - `governingSchema`: The schema name that governs this data section, as found in the file schema.
  ///   - `schema`: The resolved schema type for this data section, if successfully resolved.
  ///   - `model`: The mutable SDAI model assigned to this data section, if any.
  ///
  /// - Initialization:
  ///   - Initializes with a parent `ExchangeStructure`, a name, and a schema name.
  ///   - Ensures name uniqueness and verifies the schema is present in the header section.
  ///   - Provides a convenience initializer for the case where only one schema is specified, using the default name "PRIMARY".
  ///
  /// - Usage:
  ///   - Call `resolveSchema()` to resolve and associate the actual schema type after initialization.
  ///   - Call `assignModel(filename:repository:transaction:)` to create and assign a new read-write SDAI model for decoding operations.
  ///
  /// - SeeAlso: `P21Decode.ExchangeStructure`, `SDAI.SchemaType`, `SDAIPopulationSchema.SdaiModel`
	public final class DataSection: CustomStringConvertible {
		
		public unowned let exchangeStructure: P21Decode.ExchangeStructure
		public let name: String
		public let governingSchema: P21Decode.SchemaName
		public private(set) var schema: SDAI.SchemaType.Type? = nil
		public private(set) var model: SDAIPopulationSchema.SdaiModel? = nil
		
		public var description: String {
			return "p21DataSection(\(name))"
		}
		
    /// Initializes a new `DataSection` associated with a parent exchange structure, a unique section name, and a governing schema name.
    ///
    /// - Parameters:
    ///   - exchange: The parent `ExchangeStructure` that will own this data section.
    ///   - name: The unique name to assign to this data section. Must not duplicate any existing section names within the given exchange structure.
    ///   - schema: The name of the governing schema for this data section, which must exist in the header section's `file_schema`.
    ///
    /// - Returns: An initialized `DataSection` instance if the section name is unique within the exchange structure and the specified schema is present in the header section's `file_schema`; otherwise, returns `nil`.
    ///
    /// - Discussion:
    ///   This initializer checks that no other data section with the same name already exists within the specified exchange structure,
    ///   and verifies that the requested schema name is included in the header section’s `file_schema`. If either condition fails,
    ///   the method sets an appropriate error message on the exchange structure and returns `nil`.
    ///
    /// - SeeAlso:
    ///   - `P21Decode.ExchangeStructure.DataSection`
    ///   - `P21Decode.SchemaName`
    ///   - `P21Decode.ExchangeStructure.headerSection`
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
		
    /// Initializes a `DataSection` using the given exchange structure, assuming a single schema exists in the header section.
    ///
    /// - Parameter exchange: The parent `ExchangeStructure` that will own this data section.
    ///
    /// - Returns: An initialized `DataSection` instance if `file_schema` in the header section contains exactly one schema; otherwise, returns `nil` and sets an error on the exchange structure.
    ///
    /// - Discussion:
    ///   This convenience initializer is intended for STEP files where the header section’s `file_schema`
    ///   specifies only one schema. The resulting data section will have the default name "PRIMARY" and use that schema.
    ///   If the header section contains zero or multiple schemas, initialization fails and an error is reported.
    ///
    /// - SeeAlso:
    ///   - `P21Decode.ExchangeStructure.headerSection`
    ///   - `P21Decode.ExchangeStructure.DataSection`
    ///   - `P21Decode.SchemaName`
		public init?(exchange: P21Decode.ExchangeStructure)
		{
			guard exchange.headerSection.fileSchema.SCHEMA_IDENTIFIERS.count == 1
			else { exchange.error = "header section file_schema entry shall specify only one schema (while \(exchange.headerSection.fileSchema.SCHEMA_IDENTIFIERS.count) schema found) since data section header does not have PARAMETER_LIST"; return nil }
			
			self.exchangeStructure = exchange
			self.name = "PRIMARY"
			self.governingSchema = exchange.headerSection.fileSchema.SCHEMA_IDENTIFIERS[0]
		}
		
    /// Resolves and associates the schema type for the data section based on its governing schema name.
    ///
    /// This method attempts to resolve the schema for the data section using the parent `ExchangeStructure`.
    /// If successful, it sets the `schema` property to the resolved schema type. If the resolution fails, it
    /// logs an error context message with details about the governing schema and data section name.
    ///
    /// - Returns: `true` if the schema was successfully resolved and assigned; otherwise, `false`.
    ///
    /// - Important: The schema must be resolvable based on the `governingSchema` name, which should be present
    ///   in the header section’s file schema list. Failure to resolve the schema indicates a mismatch or missing
    ///   schema definition in the exchange structure.
    ///
    /// - SeeAlso: `P21Decode.ExchangeStructure.resolve(schemaName:)`
    ///
    /// - Usage:
    ///   Call this method after initializing a data section to resolve and associate the actual schema type required
    ///   for further decoding or model assignment operations. If resolution fails, check the exchange structure's
    ///   error context for more information.
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

  /// Represents an entity instance record within a STEP Physical File data section, as described in ISO 10303-21.
  /// 
  /// An `EntityInstanceRecord` encapsulates the parsed representation of an entity instance declaration in a data section.
  /// It can originate from either a simple record, a subsuper record (complex entity instance), or a reference to another instance.
  /// 
  /// - Properties:
  ///   - `source`: The source of the entity instance, classified as a reference, a simple record, or a subsuper record along with its associated data section.
  ///   - `resolved`: The resolved complex entity (if available) within the in-memory SDAI model.
  /// 
  /// - Initialization:
  ///   - Can be initialized with a reference resource, a simple record and its data section, or a subsuper record and its data section.
  /// 
  /// - Usage:
  ///   - Used when decoding and resolving entity instance definitions and references in a STEP exchange data section.
  /// 
  /// - SeeAlso: `P21Decode.ExchangeStructure.DataSection`, `SimpleRecord`, `SubsuperRecord`, `Resource`, `SDAI.ComplexEntity`
	public final class EntityInstanceRecord {
    /// The source of the entity instance, representing its origin within the STEP exchange data section.
    ///
    /// This property indicates how the entity instance was declared or referenced in the data section. It can be:
    /// - `.reference(Resource)`: The entity instance is a reference to a previously declared resource, as found in the syntax `LHS_OCCURENCE_NAME = RESOURCE;`.
    /// - `.simpleRecord(SimpleRecord, DataSection)`: The entity instance is defined as a simple record, i.e., a single entity declaration with its keyword and parameters, and is associated with a specific data section.
    /// - `.subsuperRecord(SubsuperRecord, DataSection)`: The entity instance is a complex (subsuper) record, representing a composite of multiple simple records (subtypes), associated with its containing data section.
    ///
    /// This classification is used to guide the decoding, resolution, and tracking of entity occurrences and references in the in-memory model of the exchange structure.
    ///
    /// - SeeAlso: `EntityInstanceRecord.Source`, `Resource`, `SimpleRecord`, `SubsuperRecord`, `P21Decode.ExchangeStructure.DataSection`
		public var source: Source
    /// The resolved complex entity corresponding to this entity instance record, if available.
    ///
    /// - Discussion:
    ///   This property holds a reference to the fully resolved `SDAI.ComplexEntity` in the in-memory SDAI model,
    ///   after the entity instance represented by this record has been decoded and mapped to a model object.
    ///   If the entity instance has not yet been resolved, or if resolution failed, this property will be `nil`.
    ///   Resolution typically occurs during the decoding process when entity instance definitions and references
    ///   in the data section are mapped to their corresponding runtime model representations.
    ///
    /// - Note:
    ///   The presence of a non-`nil` value in this property indicates that the instance has been successfully
    ///   resolved and is available for further processing, traversal, or querying within the SDAI model population.
    ///
    /// - SeeAlso:
    ///   - `SDAI.ComplexEntity`
		public var resolved: SDAI.ComplexEntity? = nil
		
    /// Initializes a new `EntityInstanceRecord` as a reference source.
    ///
    /// - Parameter reference: The `Resource` instance representing a reference to another entity instance within the exchange structure.
    ///
    /// - Discussion:
    ///   This initializer is used when the entity instance record is a reference to a previously declared resource,
    ///   according to the STEP Physical File syntax (`LHS_OCCURENCE_NAME = RESOURCE;`). The resulting `EntityInstanceRecord`
    ///   will have its `source` property set to `.reference(reference)`, indicating that it does not directly represent
    ///   a simple or complex entity instance, but rather points to another resource for resolution.
    ///
    /// - SeeAlso: 
    ///   - `EntityInstanceRecord.Source.reference`
    ///   - `Resource`
		public init(reference: Resource) {
			self.source = .reference(reference)
		}
		
    /// Initializes a new `EntityInstanceRecord` with a simple record and its associated data section.
    ///
    /// - Parameters:
    ///   - simpleRecord: The parsed representation of a simple entity instance record, typically obtained directly from the data section of a STEP file.
    ///   - dataSection: The `DataSection` instance indicating the context in which this entity instance resides.
    ///
    /// - Discussion:
    ///   This initializer is used when an entity instance in the data section is represented as a simple record (i.e., a single entity with its parameters).
    ///   The resulting `EntityInstanceRecord` will have its `source` set as `.simpleRecord(simpleRecord, dataSection)`, capturing both the parsed record and the containing data section
    ///   for further decoding, resolution, or reference tracking within the exchange structure.
    ///
    /// - SeeAlso:
    ///   - `EntityInstanceRecord.Source.simpleRecord`
    ///   - `SimpleRecord`
    ///   - `P21Decode.ExchangeStructure.DataSection`
		public init(
			simpleRecord: SimpleRecord,
			dataSection: DataSection
		)
		{
			self.source = .simpleRecord(simpleRecord, dataSection)
		}
		
    /// Initializes a new `EntityInstanceRecord` with a subsuper record and its associated data section.
    ///
    /// - Parameters:
    ///   - subsuperRecord: The parsed representation of a subsuper (complex) entity instance record, typically obtained as a list of simple records from the data section of a STEP file.
    ///   - dataSection: The `DataSection` instance indicating the context in which this complex entity instance resides.
    ///
    /// - Discussion:
    ///   This initializer is used when an entity instance in the data section is represented as a subsuper record—that is, a complex entity instance composed of multiple simple records (subtypes).
    ///   The resulting `EntityInstanceRecord` will have its `source` set as `.subsuperRecord(subsuperRecord, dataSection)`, capturing both the parsed composite record and the containing data section
    ///   for further decoding, resolution, or reference tracking within the exchange structure.
    ///
    /// - SeeAlso:
    ///   - `EntityInstanceRecord.Source.subsuperRecord`
    ///   - `SubsuperRecord`
    ///   - `P21Decode.ExchangeStructure.DataSection`
		public init(
			subsuperRecord: SubsuperRecord,
			dataSection: DataSection
		)
		{
			self.source = .subsuperRecord(subsuperRecord, dataSection)
		}
		
		/// entity instance source type classification
    ///
		/// 5.5 WSN of the exchange structure;
		/// ISO 10303-21
    ///
    /// Represents the origin/type of an entity instance within a STEP exchange data section.
    /// 
    /// - Cases:
    ///   - `reference`: Indicates the entity instance is a reference to a previously declared resource, as defined by the syntax `LHS_OCCURENCE_NAME = RESOURCE;`.
    ///   - `simpleRecord`: Represents a simple entity instance declaration, specified by a keyword and an optional parameter list (`KEYWORD([PARAMETER_LIST])`), associated with the data section it appears in.
    ///   - `subsuperRecord`: Represents a complex (subsuper) entity instance composed of a list of simple records (`(SIMPLE_RECORD_LIST)`), associated with the data section it appears in.
    /// 
    /// - Usage:
    ///   Used to classify how an entity instance is represented in the parsed data section, guiding the decoding and resolution of entity occurrences in the in-memory model.
    /// 
    /// - SeeAlso: `Resource`, `SimpleRecord`, `SubsuperRecord`, `P21Decode.ExchangeStructure.DataSection`
		public enum Source {
			case reference(Resource)													// REFERENCE = LHS_OCCURENCE_NAME "=" RESOURCE ";"
			case simpleRecord(SimpleRecord, DataSection)			// KEYWORD "(" [ PARAMETER_LIST ] ")"
			case subsuperRecord(SubsuperRecord, DataSection)	// "(" SIMPLE_RECORD_LIST ")"
		}
	}
	
	
	
}
