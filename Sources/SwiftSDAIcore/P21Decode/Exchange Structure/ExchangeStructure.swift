//
//  ExchangeStructure.swift
//  
//
//  Created by Yoshida on 2021/04/30.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension P21Decode {
	
	/// 5.3 Exchange structure;
	/// ISO 10303-21
  ///
  /// A representation of an ISO 10303-21 (STEP) Exchange Structure, encapsulating the logical structure of an exchange file.
  /// 
  /// `ExchangeStructure` serves as the top-level container for the parsed content of STEP Part 21 files. It maintains and organizes
  /// the various sections and registries necessary for interpreting and working with the data, such as the header, anchor, and data sections,
  /// as well as registries for value and entity instances and schemas. The class provides mechanisms for resolving references,
  /// error tracking, schema registration, and entity instantiation.
  /// 
  /// - Sections and Registries:
  ///   - Maintains header, anchor, and data sections corresponding to the main parts of a STEP exchange file.
  ///   - Tracks registries for value instances, entity instances, and schemas to enable efficient lookup and reference resolution.
  ///   - Exposes the parsed models available within the exchange structure.
  /// 
  /// - Reference Resolution and Error Handling:
  ///   - Provides methods for resolving various elements (schemas, constants, values, entities) referenced by name or identifier,
  ///     including detailed resolution context tracking for error diagnostics.
  ///   - Supports both internal (local) and foreign (external) references, coordinating with a foreign reference resolver.
  ///   - Maintains error state and propagates context-specific error information as parsing and resolution progresses.
  /// 
  /// - Registration and Conversion:
  ///   - Ensures uniqueness of registered schema and entity names, tracking duplicates as errors.
  ///   - Converts internal record mappings into their external (schema-aware) representations, supporting the full complexity
  ///     of STEP file data relationships.
  /// 
  /// - Activity Monitoring:
  ///   - Optionally accepts an activity monitor to report on significant events, particularly error occurrences.
  /// 
  /// - Thread Safety and Concurrency:
  ///   - Annotated as `Sendable`, designed for safe use with Swift concurrency constructs.
  /// 
  /// - CustomStringConvertible:
  ///   - Provides a succinct textual summary, reporting the count of entities within the structure.
  /// 
  /// This class forms the backbone for high-level manipulation, interpretation, and conversion of STEP exchange data
  /// within the broader decoding and modeling infrastructure.
	public final class ExchangeStructure:
    SDAI.Object, Sendable, CustomStringConvertible
  {
    /// The `HeaderSection` property represents the header portion of the STEP exchange structure (ISO 10303-21 Part 21).
    /// 
    /// The header section provides essential metadata about the exchange file, including information such as the file description,
    /// originating system, author, schema definitions, and other contextual details that inform how the rest of the file should be interpreted.
    /// 
    /// This property is initialized as an empty or default header section and is populated during parsing of the STEP file.
    /// 
    /// - Note: The header section is a required part of all valid STEP Part 21 files, and its contents are referenced throughout
    ///         the decoding process to resolve schemas, manage context, and ensure conformance to the file structure.
    /// 
    /// - SeeAlso: ISO 10303-21 Section 5.3.2 "Header section"
		nonisolated(unsafe)
		public internal(set) var headerSection = HeaderSection()
    /// The `anchorSection` property represents the anchor portion of the STEP exchange structure (ISO 10303-21 Part 21).
    ///
    /// The anchor section is an optional section in a STEP Part 21 file that contains persistent identifiers
    /// and cross-reference information, such as URI fragments that anchor items can refer to. This section supports
    /// advanced referencing scenarios, including external or anchored value/entity references that allow for richer
    /// data linking and interoperability between STEP files or external resources.
    ///
    /// The property is initialized as an empty or default anchor section and is populated during parsing of the STEP file,
    /// mapping anchor identifiers to their corresponding anchor items and reference data.
    ///
    /// - Note: The anchor section, if present, enables the resolution of complex references such as URI fragments and supports
    ///         advanced features in the exchange structure, aiding in the management of persistent and cross-file relationships.
    ///
    /// - SeeAlso: ISO 10303-21 Section 5.3.3 "Anchor section"
		nonisolated(unsafe)
		public internal(set) var anchorSection = AnchorSection()
    /// The `dataSections` property represents an array of `DataSection` objects, each corresponding to a data section within the STEP exchange structure (ISO 10303-21 Part 21).
    ///
    /// Data sections are the core components of a STEP Part 21 file, containing the main entity instances and model data being exchanged. Each `DataSection` in this array encapsulates a particular section of STEP entity data, along with context such as the associated schema, model, and parsed contents.
    ///
    /// - The array may contain multiple data sections if the STEP file includes multiple such blocks (e.g., for multi-model exchanges or files with partitioned data).
    /// - Each data section is parsed and instantiated separately, and this array provides access to all sections discovered and processed during file decoding.
    ///
    /// The property is initialized as an empty array and populated during parsing of the STEP file. Consumers of this property can iterate over the data sections to access the entity models, perform further analysis, or extract application-specific data from the exchange structure.
    ///
    /// - Note: Data sections are required for any valid STEP Part 21 file containing entity data. Their presence and structure are critical to interpreting the file's contents.
    ///
    /// - SeeAlso: ISO 10303-21 Section 5.3.4 "Data section"
		nonisolated(unsafe)
		public internal(set) var dataSections: [DataSection] = []
		
    /// The `foreignReferenceResolver` property is responsible for resolving references to entities or values that exist outside
    /// the current exchange structure, such as those imported from other STEP files or external sources.
    ///
    /// This resolver is utilized whenever the decoding process encounters a foreign reference—typically indicated by
    /// the presence of a URI in the reference. The `foreignReferenceResolver` provides mechanisms for both value
    /// and entity resolution, conversion of user-defined entities, and recovery of partial entities that are not defined
    /// in the local schema.
    ///
    /// - Usage: The property is supplied during the initialization of the `ExchangeStructure` and is used internally
    ///   during parsing, instantiation, and reference resolution phases.
    ///
    /// - Note: Correct handling of foreign references is essential for interoperability and for parsing STEP
    ///   files that link to external resources or use modular data structures.
    ///
    /// - SeeAlso: `ForeignReferenceResolver`
		public let foreignReferenceResolver: ForeignReferenceResolver
    /// The `repository` property provides the persistent storage and management context for all models, entities, and values decoded from the STEP exchange file.
    ///
    /// This repository acts as a centralized backing store for the decoded data, enabling consistent access to the parsed models and their contents.
    /// It is typically supplied during initialization and is required for all major decoding, modeling, and interpretation operations.
    ///
    /// - Note: The repository is an instance of `SDAISessionSchema.SdaiRepository`, and its lifetime should encompass all use of the exchange structure
    ///   to ensure that decoded data remains accessible and valid throughout the workflow.
    ///
    /// - SeeAlso: `SDAISessionSchema.SdaiRepository`
		public let repository: SDAISessionSchema.SdaiRepository

    /// The `valueInstanceRegistry` property maintains a mapping from `ValueInstanceName` to `ValueInstanceRecord`,
    /// serving as an internal registry for all named value instances parsed from the exchange structure.
    /// 
    /// This registry allows for efficient lookup and resolution of value instances by their unique names during
    /// decoding, parsing, and reference resolution within the STEP Part 21 file. Each entry associates a value
    /// instance name with its corresponding record, which includes both the reference form and, once resolved,
    /// the evaluated parameter value.
    /// 
    /// - Purpose:
    ///   - Enables reference resolution for named values used throughout the file, such as those referenced in
    ///     parameters, anchor items, or as part of entity attributes.
    ///   - Supports recursive and cached resolution: once a value instance is resolved, its parameter can be
    ///     reused for subsequent lookups.
    ///   - Facilitates error tracking when undefined or duplicate value instance names are encountered.
    /// 
    /// - Lifecycle:
    ///   - Populated during parsing of the STEP file as value instances are discovered.
    ///   - Entries may be updated with resolved parameter values during subsequent resolution passes.
    /// 
    /// - Thread Safety:
    ///   - The property is annotated with `nonisolated(unsafe)` and is not thread-safe; it is intended
    ///     for use within controlled decoding and parsing contexts.
    /// 
    /// - SeeAlso: `ValueInstanceName`, `ValueInstanceRecord`
		nonisolated(unsafe)
		public internal(set) var valueInstanceRegistry: [ValueInstanceName:ValueInstanceRecord] = [:]
    /// The `entityInstanceRegistry` property maintains a mapping from `EntityInstanceName` to `EntityInstanceRecord`,
    /// serving as an internal registry for all named entity instances parsed from the exchange structure.
    ///
    /// This registry enables efficient lookup and resolution of entity instances by their unique names during
    /// decoding, parsing, and reference resolution within the STEP Part 21 file. Each entry associates an entity
    /// instance name with its corresponding record, which includes both the reference form and, once resolved,
    /// the instantiated complex entity.
    ///
    /// - Purpose:
    ///   - Enables reference resolution for named entities used throughout the file, including those referenced in
    ///     parameters, anchor items, or as part of entity relationships.
    ///   - Supports recursive and cached resolution: once an entity instance is resolved, its complex entity instance can be
    ///     reused for subsequent lookups.
    ///   - Facilitates error tracking when undefined or duplicate entity instance names are encountered.
    ///
    /// - Lifecycle:
    ///   - Populated during parsing of the STEP file as entity instances are discovered.
    ///   - Entries may be updated with resolved complex entities during subsequent resolution passes.
    ///
    /// - Thread Safety:
    ///   - The property is annotated with `nonisolated(unsafe)` and is not thread-safe; it is intended
    ///     for use within controlled decoding and parsing contexts.
    ///
    /// - SeeAlso: `EntityInstanceName`, `EntityInstanceRecord`
		nonisolated(unsafe)
		public internal(set) var entityInstanceRegistry: [EntityInstanceName:EntityInstanceRecord] = [:]
    /// The `schemaRegistry` property maintains a mapping from canonicalized schema names (`SchemaName`)
    /// to their corresponding schema metatypes (`SDAI.SchemaType.Type`). This internal registry enables
    /// efficient lookup and resolution of schemas referenced within the STEP exchange structure.
    /// 
    /// - Purpose:
    ///   - Facilitates the registration and retrieval of schemas encountered during parsing of the STEP file.
    ///   - Ensures that each schema is stored with a unique, canonicalized name (whitespace removed, uppercase) to
    ///     avoid issues with inconsistent naming conventions or formatting in STEP files.
    ///   - Enables subsequent resolution of schema-related constants, entities, and other elements by providing
    ///     fast access to schema definitions and their associated metadata.
    /// 
    /// - Lifecycle:
    ///   - Populated during parsing and schema registration phases, as schemas are discovered in the input file.
    ///   - Enforces uniqueness by detecting and reporting duplicated schema names, setting an error state if a
    ///     collision occurs.
    /// 
    /// - Thread Safety:
    ///   - This property is annotated with `nonisolated(unsafe)` and is not thread-safe. It should only be accessed
    ///     in controlled parsing and decoding contexts.
    /// 
    /// - SeeAlso: `register(schemaName:schema:)`
		nonisolated(unsafe)
		public private(set) var schemaRegistry: [SchemaName:SDAI.SchemaType.Type] = [:]
		
    /// Provides a lazy collection of all `SdaiModel` instances contained within the exchange structure's data sections.
    ///
    /// Each `DataSection` parsed from the STEP exchange file may contain an associated model.
    /// This property iterates through all data sections, extracting their corresponding models if present,
    /// and presents them as a collection for convenient access.
    ///
    /// - Returns: A collection of `SDAIPopulationSchema.SdaiModel` objects representing the entity models parsed from the file.
    /// - Note: The returned collection is lazy and will only evaluate as its elements are accessed.
    /// - Warning: Data sections without a valid model are skipped and do not appear in this collection.
    ///
    /// Example usage:
    /// ```swift
    /// for model in exchangeStructure.sdaiModels {
    ///     // Work with each parsed model
    /// }
    /// ```
		public var sdaiModels: some Collection<SDAIPopulationSchema.SdaiModel> {
			let models = dataSections.lazy.compactMap{ $0.model }
			return models
		}
		
		private let activityMonitor: ActivityMonitor?

    /// A succinct textual summary of the exchange structure.
    ///
    /// This property returns a string describing the instance, specifically reporting the total number of entity instances
    /// contained within all data sections. It is primarily useful for logging, debugging, or user interface representations,
    /// as it provides an overview of the structure's content at a glance.
    ///
    /// - Returns: A `String` in the format `"ExchangeStructure(#ENT: X)"` where `X` is the total entity count.
    ///
    /// - Note: The count includes all complex entities present in the models of the data sections, and skips sections without valid models.
    public var description: String {
      var count = 0
      for ds in dataSections {
        guard let complexes = ds.model?.contents.allComplexEntities else { continue }
        count += complexes.count
      }
      let str = "ExchangeStructure(#ENT: \(count))"
      return str
    }

		//MARK: - constructor
    /// Initializes a new `ExchangeStructure` instance, providing the core context for interpreting and managing
    /// a parsed ISO 10303-21 (STEP) exchange file.
    ///
    /// This initializer establishes the repositories and reference resolution mechanisms needed to facilitate
    /// schema registration, entity instantiation, and value or entity reference resolution. It also enables
    /// optional monitoring of parsing activity and error reporting.
    ///
    /// - Parameters:
    ///   - repository: The `SDAISessionSchema.SdaiRepository` instance that serves as the storage and management
    ///                 context for all models, entities, and values decoded from the exchange file. This repository
    ///                 provides the persistent backing for STEP data and is required for all major decoding and
    ///                 modeling operations.
    ///   - foreignReferenceResolver: The `ForeignReferenceResolver` responsible for resolving references to entities
    ///                 or values that may exist outside the current exchange structure—such as those imported from
    ///                 other files or external sources. This resolver is invoked whenever a foreign reference is
    ///                 encountered during parsing or resolution.
    ///   - monitor: An optional `ActivityMonitor` instance that receives notifications about significant parsing
    ///                 events, particularly errors. This allows the caller to observe progress and respond to
    ///                 issues dynamically, which can aid in debugging or provide user feedback during long-running
    ///                 decode operations.
    ///
    /// - Note: This constructor is designed for internal use during parsing of STEP Part 21 files and assumes
    ///         that the caller will supply all required dependencies. The resulting `ExchangeStructure` is ready
    ///         for registration of schemas, entities, and values, and for resolution of references during
    ///         subsequent decoding or interpretation stages.
		public init(
			repository: SDAISessionSchema.SdaiRepository,
			foreignReferenceResolver: ForeignReferenceResolver,
			monitor: ActivityMonitor? = nil,
		)
		{
			self.repository = repository
			self.foreignReferenceResolver = foreignReferenceResolver
			self.activityMonitor = monitor
		}
		
		
		//MARK: - error handling
    /// Represents the current error state of the `ExchangeStructure` during parsing, registration, or resolution.
    ///
    /// This property is set when a significant error or diagnostic condition arises in the course of decoding a STEP Part 21 file.
    /// It typically contains a description of the most recent or critical error encountered, such as duplicate entity instance
    /// names, unresolved references, schema registration conflicts, or invalid structure in the input data.
    ///
    /// - Reading this property allows consumers to check whether the exchange structure is in an error state and to obtain
    ///   diagnostic information for debugging or user feedback.
    /// - Writing to this property updates the error state and, if an `ActivityMonitor` is attached, notifies it of the error.
    /// - The error string may be appended with additional context as operations progress, providing a chained history of
    ///   relevant parsing or resolution steps for easier troubleshooting.
    ///
    /// - Note: Once set, this property is only overwritten or appended to by subsequent errors or context.
    ///   Consumers should treat its presence as an indication that processing should be stopped or that results are incomplete.
    ///
    /// - SeeAlso: `add(errorContext:)` for appending additional context to the error message,
    ///            and `ActivityMonitor.exchangeStructureDidSet(error:)` for error notifications.
		nonisolated(unsafe)
		public var error: String? {
			didSet {
				if let monitor = activityMonitor, oldValue == nil, let error = error {
					monitor.exchangeStructureDidSet(error: error)
				}
			}
		}
    /// Appends additional error context to the existing error state.
    ///
    /// This method updates the `error` property by appending the specified `errorContext` string to the current error message.
    /// If no error message currently exists, it initializes the `error` property with a default value ("p21 parser error"),
    /// followed by the appended context. Each appended context is separated by a comma and newline for improved readability.
    ///
    /// - Parameter errorContext: A `String` providing additional information about the parsing or resolution error encountered.
    ///
    /// - Side Effects:
    ///   - Updates the `error` property by appending the provided context to any existing error message.
    ///   - Triggers the activity monitor (if present) when setting a new error state.
    ///
    /// - Note: Used internally for error diagnostics, particularly to track and chain nested error contexts during recursive
    ///   parsing and resolution operations.
		public func add(errorContext: String) {
      error = (error ?? "p21 parser error") + ",\n " + errorContext
		}


		//MARK: - registration related
		internal func register(entityInstanceName: EntityInstanceName, record: EntityInstanceRecord) -> Bool {
			if let old = entityInstanceRegistry.updateValue(record, forKey: entityInstanceName) {
				self.error = "duplicated entity instance name(\(entityInstanceName)) detected with resource reference(\(record)), old reference = (\(old))"
				return false
			}
			return true
		}
		
		private func canonicalSchemaName(_ schemaName: SchemaName) -> SchemaName {
			let wospace = schemaName.filter { !$0.isWhitespace }
			let upper = wospace.uppercased()
			return upper
		}
		
    /// Registers a schema with a given name in the exchange structure's schema registry.
    /// 
    /// This method ensures that each schema registered has a unique canonicalized name. If a schema
    /// with the provided name already exists in the registry, the method sets an error indicating
    /// the duplicate and returns `false`. Otherwise, it adds the schema type to the registry
    /// and returns `true`.
    ///
    /// - Parameters:
    ///   - schemaName: The name of the schema to register. The name is canonicalized by removing
    ///     whitespace and converting to uppercase to ensure a consistent key in the registry.
    ///   - schema: The metatype of the schema to register. This must conform to `SDAI.SchemaType`.
    ///
    /// - Returns: `true` if the schema was successfully registered and did not collide with an
    ///   existing schema name; `false` if a duplicate was detected.
    ///
    /// - Side Effects:
    ///   - Sets the `error` property if a duplicate schema name is detected, including diagnostic
    ///     information about both the new and existing schema definitions.
    ///
    /// - Note: This method is intended for internal use during parsing and registration phases, and is
    ///   not thread-safe. The canonicalization process is intended to avoid common issues with
    ///   schema name variations in input STEP files.
		public func register(schemaName: SchemaName, schema: SDAI.SchemaType.Type) -> Bool {
			let canon = canonicalSchemaName(schemaName)
			if let old = schemaRegistry.updateValue(schema, forKey: canon) {
				self.error = "duplicated schema name(\(canon)) detected with definition(\(schema.schemaDefinition.name)), old definition = (\(old.schemaDefinition.name))"
				return false
			}
			return true
		}

    /// A set containing the schema definitions of all application schemas registered within the exchange structure.
    ///
    /// This property aggregates the schema definitions (`SDAIDictionarySchema.SchemaDefinition`) for all schemas
    /// that have been registered via the `schemaRegistry`. Each entry corresponds to a unique, canonicalized schema
    /// name encountered in the STEP exchange file.
    ///
    /// - Returns: A `Set` of `SDAIDictionarySchema.SchemaDefinition` objects, each representing the metadata and
    ///   structure of a registered application schema.
    /// - Note: This property is useful for analyzing which application schemas are present in the exchange
    ///   structure, facilitating schema-aware parsing, validation, and model extraction.
    /// - Warning: The set contains only those schemas that have been successfully registered—typically those
    ///   referenced by the input file header and discovered during parsing.
		public var targetSchemas: Set<SDAIDictionarySchema.SchemaDefinition> {
			Set( schemaRegistry.values.map{ $0.schemaDefinition } )
		}
		
		//MARK: - resolution related
    enum ResolutionContext: CustomStringConvertible {
      case schemaName(schemaName: SchemaName)
      case constantEntityName(constantEntityName: ConstantName)
      case constantValueName(constantValueName: ConstantName)
      case valueInstanceName(valueInstanceName: ValueInstanceName)
      case entityInstanceName(entityInstanceName: EntityInstanceName)
      case valueReference(valueReference: ExchangeStructure.Resource)
      case anchorItemValue(anchorItem: AnchorItem)
      case entityReference(entityReference: ExchangeStructure.Resource)
      case anchorItemInstance(anchorItem: AnchorItem)
      case externalMapping(externalMapping: SubsuperRecord)

      var description: String {
        switch self {
          case .schemaName(let schemaName):
            return "resolving application schema [\(schemaName)]"

          case .constantEntityName(let constantEntityName):
            return "resolving constant entity [\(constantEntityName)]"

          case .constantValueName(let constantValueName):
            return "resolving constant value [\(constantValueName)]"

          case .valueInstanceName(let valueInstanceName):
            return "resolving value instance [\(valueInstanceName)]"

          case .entityInstanceName(let entityInstanceName):
            return "resolving entity instance [\(entityInstanceName)]"

          case .valueReference(let valueReference):
            return "resolving value reference [\(valueReference)]"

          case .anchorItemValue(let anchorItem):
            return "resolving anchor item value [\(anchorItem)]"

          case .entityReference(let entityReference):
            return "resolving entity reference [\(entityReference)]"

          case .anchorItemInstance(let anchorItem):
            return "resolving anchor item instance [\(anchorItem)]"

          case .externalMapping(let externalMapping):
            var str = "resolving external mapping ["
            for simple in externalMapping {
              str.append("\n\t\(simple)")
            }
            str.append("\n ]")
            return str
        }
      }
    }//enum

    nonisolated(unsafe)
    var resolutionContextStack: [ResolutionContext] = []

    func push(context: ResolutionContext) {
      resolutionContextStack.append(context)
    }

    func popContext() {
      let _ = resolutionContextStack.popLast()
    }

    var resolutionContextDescription: String {
      guard let context = resolutionContextStack.last
      else { return"" }
      return context.description
    }




    /// Resolves and retrieves the schema type associated with a given schema name.
    ///
    /// This method attempts to resolve the provided `schemaName` by canonicalizing it
    /// (removing whitespace and converting to uppercase), then looking up the result
    /// in the `schemaRegistry`. The canonicalization process ensures that common
    /// variations in schema name formatting do not impede proper resolution.
    ///
    /// During resolution, the context is pushed onto the internal resolution context
    /// stack for error tracking and diagnostic purposes, and automatically popped upon
    /// return.
    ///
    /// - Parameter schemaName: The name of the schema to resolve.
    /// - Returns: The corresponding schema metatype if found, or `nil` if resolution failed.
    ///
    /// - Note: If the schema cannot be found, this method does not set the error state, but
    ///   callers may inspect the returned value for `nil` to determine failure.
		public func resolve(
			schemaName: SchemaName
		) -> SDAI.SchemaType.Type?
		{
      push(context: .schemaName(schemaName: schemaName))
      defer { popContext() }

			let canon = canonicalSchemaName(schemaName)
			return schemaRegistry[canon]
		}

    /// Resolves a constant entity reference by its name within the schema context.
    ///
    /// This function attempts to retrieve an entity reference for a constant entity defined in the primary schema
    /// (referenced by the first entry in the `headerSection.fileSchema.SCHEMA_IDENTIFIERS` array).
    /// It canonicalizes the lookup using the schema's constants dictionary.
    ///
    /// During the resolution process, this method pushes a context onto the internal resolution context stack for
    /// improved diagnostics and error reporting and ensures the context is popped when resolution is complete or if an error occurs.
    ///
    /// - Parameter constantEntityName: The name of the constant entity to resolve.
    /// - Returns: An `SDAI.EntityReference` if the constant entity can be found and resolved in the current schema, or `nil` if resolution fails.
    ///
    /// - Side Effects:
    ///   - Sets the `error` property if the schema or constant entity cannot be found, including the diagnostic context.
    ///   - Appends error context strings to the error property for chained errors and easier debugging.
    ///   - Pushes and pops the resolution context for improved error diagnostics.
    ///
    /// - Note: This method is intended for use during parsing and instantiation of exchange structures,
    ///   and is not thread-safe. Typically, only constants in the primary schema (first entry in `headerSection.fileSchema.SCHEMA_IDENTIFIERS`) can be resolved.
		public func resolve(
			constantEntityName: ConstantName
		) -> SDAI.EntityReference?
		{
      push(context: .constantEntityName(constantEntityName: constantEntityName))
      defer { popContext() }

			guard let schema = self.resolve(schemaName: self.headerSection.fileSchema.SCHEMA_IDENTIFIERS[0])
			else { self.add(errorContext: "while resolving constant entity name(\(constantEntityName))"); return nil }
			
			guard let const = schema.schemaDefinition.constants[constantEntityName]?()
			else { self.error = "constant entity name(\(constantEntityName)) not found in schema(\(schema.schemaDefinition.name))"; return nil }
			
			guard let entity = const.entityReference
			else { self.error = "constant value(\(const)) can not be resolved as entity reference"; self.add(errorContext: "while resolving constant entity name(\(constantEntityName))"); return nil }
			
			return entity
		}
		
		
    /// Resolves the value of a constant defined in the schema using its name.
    ///
    /// This function attempts to resolve a constant value by its name (`constantValueName`)
    /// in the context of the file's primary schema (as specified in the header section's
    /// first schema identifier). The method will canonicalize the search via the schema's
    /// definition dictionary of constants. The result may be any STEP constant value,
    /// such as an enumeration, integer, real, or entity reference.
    ///
    /// During the resolution process, this method also pushes a context onto the resolution
    /// context stack for improved diagnostics and error reporting, and ensures to pop the
    /// context once resolution is complete (or if an error occurs).
    ///
    /// - Parameter constantValueName: The name of the constant value to resolve.
    /// - Returns: The resolved value as an `SDAI.GENERIC` if successful, or `nil` if resolution failed.
    ///
    /// - Side Effects:
    ///   - Sets the `error` property if schema or constant resolution fails, with diagnostic context.
    ///   - Appends error context strings to the error property for chained errors and easier debugging.
    ///   - Pushes and pops resolution context for improved error diagnostics.
    ///
    /// - Note: This method is intended for use during parsing and instantiation of exchange
    ///   structures, and is not thread-safe. Typically, only constants in the primary
    ///   schema (first entry in `headerSection.fileSchema.SCHEMA_IDENTIFIERS`) can be resolved.
		public func resolve(
			constantValueName: ConstantName
		) -> SDAI.GENERIC?
		{
      push(context: .constantValueName(constantValueName: constantValueName))
      defer { popContext() }

			guard let schema = self.resolve(schemaName: self.headerSection.fileSchema.SCHEMA_IDENTIFIERS[0])
			else { self.add(errorContext: "while resolving constant value name(\(constantValueName))"); return nil }
			
			guard let const = schema.schemaDefinition.constants[constantValueName]?()
			else { self.error = "constant value name(\(constantValueName)) not found in schema(\(schema.schemaDefinition.name))"; return nil }

			return const
		}
		
    /// Resolves a value instance by its name, returning its evaluated parameter form.
    ///
    /// This method attempts to locate and resolve the value instance associated with the provided `valueInstanceName`
    /// from the registry of value instances. If the instance has already been resolved previously, the cached
    /// resolved parameter is returned directly. Otherwise, the method recursively resolves the underlying value
    /// reference, updates the registry with the resolved parameter, and returns it.
    ///
    /// During the resolution process, the context is pushed onto the internal resolution context stack for
    /// diagnostic tracking, and automatically popped upon return.
    ///
    /// - Parameter valueInstanceName: The unique identifier for the value instance to resolve.
    /// - Returns: The evaluated `Parameter` associated with the specified value instance, or `nil` if the instance
    ///   could not be resolved (e.g., not found in the registry or resolution of the reference fails).
    ///
    /// - Side Effects:
    ///   - Updates the internal error state (`error`) if resolution fails.
    ///   - Tracks the resolution context for error diagnostics.
    ///   - Caches the resolved parameter within the value instance record for future queries.
    ///
    /// - Note: This method is intended for use during parsing and instantiation of exchange structures,
    ///   and is not thread-safe. It may return `nil` in the event of errors or unresolved references.
		public func resolve(
			valueInstanceName: ValueInstanceName
		) -> Parameter?
		{
      push(context: .valueInstanceName(valueInstanceName: valueInstanceName))
      defer { popContext() }

			guard let virec = self.valueInstanceRegistry[valueInstanceName]
			else { self.error = "value instance name(\(valueInstanceName)) not found in reference section"; return nil }
			
			if let value = virec.resolved { return value }
			
			guard let resolved = self.resolve(valueReference: virec.reference)
			else { self.add(errorContext: "while resolving value instance name(\(valueInstanceName))"); return nil }
			virec.resolved = resolved
			return resolved
		}
		
    /// Resolves an entity instance by its unique name, returning the corresponding `ComplexEntity`.
    ///
    /// This method takes an `EntityInstanceName` and attempts to resolve it to a fully constructed
    /// `SDAI.ComplexEntity` object. The resolution process follows the source of the entity instance,
    /// handling references, simple records, and subsuper records as appropriate:
    ///
    /// - If the entity instance is a reference, it resolves the reference recursively, updating the
    ///   registry with the result.
    /// - If the entity instance is a simple record, it first converts the record to an external
    ///   `SubsuperRecord` mapping, then resolves each constituent part into partial entities,
    ///   aggregating them into a new `ComplexEntity`.
    /// - If the entity instance is a subsuper record, it resolves each constituent part into a
    ///   partial entity and aggregates them similarly.
    ///
    /// During the process, error contexts are tracked and added to the error state if resolution
    /// fails at any point.
    ///
    /// - Parameter entityInstanceName: The unique identifier of the entity instance to resolve.
    /// - Returns: The resolved `SDAI.ComplexEntity` if successful, or `nil` if resolution failed.
    ///
    /// - Side Effects:
    ///   - Updates the internal error state (`error`) if the entity instance cannot be found,
    ///     if record conversion fails, or if constituent resolution fails.
    ///   - Tracks the resolution context for improved error diagnostics.
    ///   - Caches the resolved entity within the entity instance record for future queries.
    ///
    /// - Note: This method is intended for use during parsing and instantiation of exchange structures,
    ///   and is not thread-safe. It may return `nil` in the event of errors or unresolved references.
		public func resolve(
			entityInstanceName: EntityInstanceName
		) -> SDAI.ComplexEntity?
		{
      push(context: .entityInstanceName(entityInstanceName: entityInstanceName))
      defer { popContext() }

      guard let eirec = self.entityInstanceRegistry[entityInstanceName]
			else { self.error = "entity instance name #\(entityInstanceName) not found in data section or reference section"; return nil }
			
			if let complex = eirec.resolved { return complex }
			
			switch eirec.source {
			case .reference(let reference):
				guard case .success(let resolved) = self.resolve(entityReference: reference)
				else { self.add(errorContext: "while resolving entity instance reference #\(entityInstanceName)"); return nil }
				eirec.resolved = resolved
				return resolved
				
			case .simpleRecord(let simple, let datasec):
				guard let subsuper = self.convertToExternalMapping(from: simple, dataSection: datasec)
				else { self.add(errorContext: "while resolving entity instance simple record #\(entityInstanceName)"); return nil }
				
				guard let partials = self.resolve(externalMapping: subsuper, dataSection: datasec)
				else { self.add(errorContext: "while resolving entity instance simple record #\(entityInstanceName)"); return nil }
				
				let resolved = SDAI.ComplexEntity(
					entities: partials,
					model: datasec.model!,
					name: entityInstanceName)

				eirec.resolved = resolved
				return resolved
				
			case .subsuperRecord(let subsuper, let datasec):
				guard let partials = self.resolve(externalMapping: subsuper, dataSection: datasec)
				else { self.add(errorContext: "while resolving entity instance subsuper record #\(entityInstanceName)"); return nil }

				let resolved = SDAI.ComplexEntity(
					entities: partials,
					model: datasec.model!,
					name: entityInstanceName)

				eirec.resolved = resolved
				return resolved
			}
		}
		
    /// Resolves a value reference (which may be local, anchored, or foreign) to its evaluated parameter value.
    ///
    /// This method handles the resolution of a value reference by first determining its type:
    /// - If the reference is `nil` (no fragment), it returns an untyped parameter representing "no value".
    /// - If the reference includes a URI, it is treated as a foreign reference and resolved via the `foreignReferenceResolver`.
    /// - If the reference includes a URI fragment, it is assumed to be an anchor reference and is resolved via the anchor section.
    ///
    /// The function manages diagnostic context by pushing and popping a resolution context, and updates the error state if
    /// resolution fails at any stage. Errors encountered during anchor or foreign value resolution are recorded with context.
    ///
    /// - Parameter valueReference: The `ExchangeStructure.Resource` object representing the value reference to resolve.
    /// - Returns: A resolved `Parameter` object, or `nil` if resolution fails.
    ///
    /// - Side Effects:
    ///   - Updates the `error` property with detailed context if resolution cannot be completed.
    ///   - Provides layered diagnostics by adding error contexts for nested resolution failures.
    ///   - Interacts with the anchor section and foreign reference resolver as needed.
    ///
    /// - Note: This method is used internally during parsing and evaluation of exchange structure content.
		public func resolve(
			valueReference: ExchangeStructure.Resource
		) -> Parameter?
		{
      push(context: .valueReference(valueReference: valueReference))
      defer { popContext() }

      if valueReference.fragment == nil {
				return .untypedParameter(.noValue)
			}
			
			if valueReference.uri != nil {
				guard let resolved = foreignReferenceResolver.resolve(valueReference: valueReference)
				else { self.error = foreignReferenceResolver.error ?? "<unknown foreign value reference resolution error>"; self.add(errorContext: "while resolving value reference(\(valueReference))"); return nil }
				return resolved
			}
			
			if let urifrag = valueReference.fragment {
				guard let anchorRec = self.anchorSection.externalItems[urifrag]
				else { self.error = "anchor name(\(urifrag)) not found in anchor section"; self.add(errorContext: "while resolving value reference(\(valueReference))"); return nil }
				
				guard let resolved = self.resolveValue(anchorItem: anchorRec.anchorItem)
				else { self.add(errorContext: "while resolving anchor(\(anchorRec))"); self.add(errorContext: "while resolving value reference(\(valueReference))"); return nil }
				return resolved				
			}
			
			self.error = "<internal error (value reference(\(valueReference)) resolution)>"
			return nil
		}
		
    /// Resolves the value represented by a given anchor item, producing a corresponding `Parameter`.
    ///
    /// This method evaluates the specified `AnchorItem`, converting it into its appropriate `Parameter` representation,
    /// which may be a primitive (such as integer, real, string, enumeration, or binary), a constant value, a value instance,
    /// a value reference, or a list of parameters. The resolution process is recursive for compound structures
    /// (like anchor item lists).
    ///
    /// The resolution process covers the following cases:
    /// - `.noValue`: Returns a parameter representing "no value".
    /// - `.integer`, `.real`, `.string`, `.enumeration`, `.binary`: Returns the corresponding untyped parameter.
    /// - `.rhsOccurrenceName`: Resolves either a constant value or a value instance, depending on the referenced name.
    /// - `.resource`: Resolves the value reference recursively.
    /// - `.anchorItemList`: Recursively resolves each item in the list and returns a list parameter.
    ///
    /// Throughout resolution, the method maintains a context stack for diagnostic tracking, pushing and popping context
    /// for each invocation. In the event of failures—such as missing constants or value instances, or improper anchor items—
    /// the method sets the internal error state and propagates context-specific error information.
    ///
    /// - Parameter anchorItem: The `AnchorItem` instance to resolve.
    /// - Returns: A `Parameter` representing the resolved value, or `nil` if resolution failed.
    ///
    /// - Side Effects:
    ///   - May set the `error` property with detailed diagnostic information if resolution fails.
    ///   - Manages the internal resolution context stack for error reporting.
    ///
    /// - Note: This method is used during parsing, instantiation, and evaluation of STEP exchange structures.
		public func resolveValue(
			anchorItem: AnchorItem
		) -> Parameter?
		{
      push(context: .anchorItemValue(anchorItem: anchorItem))
      defer { popContext() }

      switch anchorItem {
			case .noValue:
				return .untypedParameter(.noValue)
				
			case .integer(let value):
				return .untypedParameter(.integer(value))
				
			case .real(let value):
				return .untypedParameter(.real(value))
				
			case .string(let value):
				return .untypedParameter(.string(value))
				
			case .enumeration(let value):
				return .untypedParameter(.enumeration(value))
				
			case .binary(let value):
				return .untypedParameter(.binary(value))
				
			case .rhsOccurrenceName(let rhsname):
				switch rhsname {
				case .constantValueName(let name):
					guard let generic = self.resolve(constantValueName: name)
					else { return nil }
					return .sdaiGeneric(generic)
					
				case .valueInstanceName(let name):
					guard let resolved = self.resolve(valueInstanceName: name)
					else { return nil }
					return resolved
					
				default:
					self.error = "anchor item(\(anchorItem)) does not yield value"
					return nil
				}
				
			case .resource(let reference):
				guard let resolved = self.resolve(valueReference: reference)
				else { return nil }
				return resolved
				
			case .anchorItemList(let list):
				var paramList:[Parameter] = []
				for (i,item) in list.enumerated() {
					guard let param = self.resolveValue(anchorItem: item)
					else { self.add(errorContext: "while resolving anchor item list[\(i)]"); return nil }
					paramList.append(param)
				}
				return .untypedParameter(.list(paramList))
			}
		}
		
    /// Resolves an entity reference (which may be local, anchored, or foreign) to its corresponding `SDAI.ComplexEntity`.
    ///
    /// This method handles resolution of a given `ExchangeStructure.Resource`, supporting the following cases:
    /// - If the resource has no fragment, it is treated as a null or undefined reference and returns `.success(nil)`.
    /// - If the resource includes a URI, it is considered a foreign reference and is resolved using the `foreignReferenceResolver`.
    ///   Any errors encountered in this process are propagated from the resolver, and the context is tracked for diagnostics.
    /// - If the resource includes a URI fragment (anchor), it attempts to resolve the referenced anchor item from the anchor section,
    ///   then recursively resolves that anchor item as an entity instance. Errors in locating the anchor or resolving its value are recorded
    ///   and added to the error context stack.
    /// - If the resource does not match any of these patterns, an internal error is recorded and `.failure` is returned.
    ///
    /// The method maintains a resolution context stack for diagnostic error reporting, automatically managing context push/pop.
    ///
    /// - Parameter entityReference: The `ExchangeStructure.Resource` representing the entity reference to resolve.
    /// - Returns: A `ParameterRecoveryResult<SDAI.ComplexEntity?>` containing the resolved entity if successful, or `.failure` if resolution fails.
    ///
    /// - Side Effects:
    ///   - Updates the `error` property with detailed diagnostic information if resolution fails.
    ///   - Tracks diagnostic context for improved error reporting.
    ///
    /// - Note: Used internally during parsing, instantiation, and evaluation of STEP exchange structures. Not thread-safe.
		public func resolve(
			entityReference: ExchangeStructure.Resource
		) -> ParameterRecoveryResult<SDAI.ComplexEntity?>
		{
      push(context: .entityReference(entityReference: entityReference))
      defer { popContext() }

      if entityReference.fragment == nil {
				return .success(nil)
			}
			
			if entityReference.uri != nil {
				guard case.success(let resolved) = foreignReferenceResolver.resolve(entityReference: entityReference)
				else { self.error = foreignReferenceResolver.error ?? "<unknown foreign entity reference resolution error>"; self.add(errorContext: "while resolving entity reference(\(entityReference))"); return .failure }
				return .success(resolved)				
			}
			
			if let urifrag = entityReference.fragment {
				guard let anchorRec = self.anchorSection.externalItems[urifrag]
				else { self.error = "anchor name(\(urifrag)) not found in anchor section"; self.add(errorContext: "while resolving entity reference(\(entityReference))"); return .failure }

				guard case .success(let resolved) = self.resolveInstance(anchorItem: anchorRec.anchorItem)
				else { self.add(errorContext: "while resolving anchor(\(anchorRec))"); self.add(errorContext: "while resolving entity reference(\(entityReference))"); return .failure }
				return .success(resolved)
			}
			
			self.error = "<internal error (entity reference(\(entityReference)) resolution)>"
			return .failure			
		}
		
    /// Resolves an entity instance from the given anchor item, returning a complex entity if successful.
    ///
    /// This method interprets the provided `AnchorItem` to recover an entity instance reference in the exchange structure.
    /// The anchor item may directly or indirectly reference a constant entity, a named entity instance, or a resource, with
    /// type and structure-specific logic for each:
    /// 
    /// - `.noValue`: Returns `.success(nil)` to indicate that no entity instance is referenced.
    /// - `.rhsOccurrenceName(.constantEntityName)`: Resolves a schema constant entity by name and returns its `ComplexEntity`.
    /// - `.rhsOccurrenceName(.entityInstanceName)`: Resolves a local entity instance by its unique name.
    /// - `.resource`: Recursively resolves the referenced entity, supporting foreign and anchored references.
    /// - Any other anchor item form (such as primitive types or value instances): Fails, reporting an error.
    ///
    /// The resolution process pushes a diagnostic context for improved error reporting, and always pops it on return. Any errors
    /// encountered will be recorded in the exchange structure's `error` property, with context-specific details for troubleshooting.
    ///
    /// - Parameter anchorItem: The `AnchorItem` to resolve as an entity instance.
    /// - Returns: A `ParameterRecoveryResult<SDAI.ComplexEntity?>` representing either the successfully resolved entity instance,
    ///   or `.failure` if no valid entity instance could be recovered.
    ///
    /// - Side Effects:
    ///   - Updates the `error` property with detailed diagnostics if resolution fails.
    ///   - Pushes and pops context on the internal resolution stack for error tracking.
    ///
    /// - Note: This method is typically used for resolving entity instance references from anchor records and other indirect STEP references.
		public func resolveInstance(
			anchorItem: AnchorItem
		) -> ParameterRecoveryResult<SDAI.ComplexEntity?>
		{
      push(context: .anchorItemInstance(anchorItem: anchorItem))
      defer { popContext() }

      switch anchorItem {
			case .noValue:
				return .success(nil)
				
			case .rhsOccurrenceName(let rhsname):
				switch rhsname {
				case .constantEntityName(let name):
					guard let resolved = self.resolve(constantEntityName: name)
					else { return .failure }
					return .success(resolved.complexEntity)
					
				case .entityInstanceName(let name):
					guard let resolved = self.resolve(entityInstanceName: name)
					else { return .failure }
					return .success(resolved)
					
				default:
					self.error = "anchor item(\(anchorItem)) does not yield entity instance"
					return .failure
				}
				
			case .resource(let reference):
				guard case .success(let resolved) = self.resolve(entityReference: reference)
				else { return .failure }
				return .success(resolved)
				
			default:
				self.error = "invalid anchor item(\(anchorItem)) for entity instance reference"
				return .failure
			}
		}
		
    /// Resolves a list of constituent entity records (an external mapping) into partial entity instances.
    ///
    /// This method attempts to instantiate each `SimpleRecord` within the supplied `SubsuperRecord` (the external mapping) as a
    /// partial entity, using the schema definition available from the given `DataSection`. Standard keywords are resolved
    /// via the schema's entity definitions, and user-defined keywords are delegated to the `foreignReferenceResolver`
    /// for resolution. Each constituent is converted to its corresponding `SDAI.PartialEntity`, aggregating the results
    /// into a flat list.
    ///
    /// If any constituent fails to resolve (e.g., the entity name is not found in the schema, a partial entity cannot be
    /// instantiated, or a user-defined entity cannot be recovered), the method sets the `error` property with context
    /// information and returns `nil`. Throughout the process, the method maintains a contextual stack for improved
    /// error diagnostics, automatically pushing and popping resolution context as the function is entered and exited.
    ///
    /// - Parameters:
    ///   - externalMapping: The `SubsuperRecord` representing the external mapping of constituent entities.
    ///   - dataSection: The `DataSection` providing context and schema information for entity resolution.
    /// - Returns: An array of successfully resolved `SDAI.PartialEntity` instances, or `nil` if resolution failed.
    ///
    /// - Side Effects:
    ///   - Updates the `error` property with diagnostic information if resolution of any constituent fails.
    ///   - Pushes and pops context on the internal resolution stack to support improved error tracking.
    ///
    /// - Note: This method is used during entity instance instantiation and interpretation of mapped STEP data structures.
		public func resolve(
			externalMapping: SubsuperRecord,
			dataSection: DataSection
		) -> [SDAI.PartialEntity]?
		{
      push(context: .externalMapping(externalMapping: externalMapping))
      defer { popContext() }

      guard let schemaDef = dataSection.schema?.schemaDefinition
			else { self.error = "could not find schema definition dictionary for data section(\(dataSection))"; return nil }
			
			var partials:[SDAI.PartialEntity] = []
			for (i,simple) in externalMapping.enumerated() {
				switch simple.keyword {
				case .standardKeyword(let keyword):
					guard let entityDef = schemaDef.entities[keyword]
					else { self.error = "entity name(\(keyword)) not found in schema(\(schemaDef.name))"; self.add(errorContext: "while recovering constituent entity[\(i)]"); return nil }

					guard let partial = entityDef.partialEntityType.init(parameters: simple.parameterList, exchangeStructure: self)
					else { self.add(errorContext: "while recovering constituent entity[\(i)]"); return nil }
					partials.append(partial)
					
				case .userDefinedKeyword(let keyword):
						guard let partial = foreignReferenceResolver.recover(userDefinedEntity: simple)
						else { self.error = foreignReferenceResolver.error ?? "user defined entity(\(keyword)) recovery unknown error"; self.add(errorContext: "while recovering constituent entity[\(i)]"); return nil }
					partials.append(partial)
				}	
			}
			return partials
		}
		
		
		
    /// Converts an internal representation of an entity instance (`SimpleRecord`) into its external mapping (`SubsuperRecord`),
    /// following the inheritance structure described in the schema.
    ///
    /// This method interprets the supplied `internalMapping`, which is typically a flat record of parameters mapped to a single
    /// entity type (possibly with supertype attributes inlined). For standard entity keywords, it consults the schema definition
    /// to expand this into a list of constituent `SimpleRecord`s, each corresponding to a supertype or the entity itself, correctly
    /// partitioning the parameters according to the explicit attribute counts of each supertype in the inheritance chain.
    ///
    /// For user-defined keywords, the conversion is delegated to the `foreignReferenceResolver`, which is responsible for
    /// recognizing and interpreting non-standard or externally defined entities.
    ///
    /// Throughout the process, this method validates that the parameter list matches the expected structure implied by the
    /// schema's inheritance hierarchy. If the parameters are insufficient or an entity definition cannot be found, an error
    /// is recorded and `nil` is returned.
    ///
    /// - Parameters:
    ///   - internalMapping: The `SimpleRecord` representing an entity instance in its internal (flat) form.
    ///   - dataSection: The `DataSection` providing the schema context for mapping.
    ///
    /// - Returns: A `SubsuperRecord` (list of `SimpleRecord`s) representing the decomposed external mapping, or `nil` if conversion fails.
    ///
    /// - Side Effects:
    ///   - Sets the `error` property if schema definitions, entities, or parameter counts are invalid.
    ///   - Delegates user-defined entity handling to the `foreignReferenceResolver`, propagating any errors as necessary.
    ///
    /// - Note: This method is primarily used during resolution of entity instances to correctly understand and instantiate
    ///   complex entities with inheritance, as described by the originating STEP schema.
		public func convertToExternalMapping(
			from internalMapping:SimpleRecord,
			dataSection: DataSection
		) -> SubsuperRecord?
		{
			guard let schemaDef = dataSection.schema?.schemaDefinition
			else { self.error = "could not find schema definition dictionary for data section(\(dataSection))"; return nil }

			switch internalMapping.keyword {
			case .standardKeyword(let keyword):
				guard let entityDef = schemaDef.entities[keyword]
				else { self.error = "entity name(\(keyword)) not found in schema(\(schemaDef.name))"; self.add(errorContext: "while converting internal mapping to external mapping"); return nil }
				
				var subsuper: SubsuperRecord = []
				let params = internalMapping.parameterList
				var remain = params.count
				var j = 0;
				for supertype in entityDef.supertypes {
					let superPCount = supertype.entityDefinition.partialEntityExplicitAttributeCount
					guard remain - superPCount >= 0
					else { self.error = "supplied number of parameters(\(params.count)) are smaller than required(\(entityDef.totalExplicitAttributeCounts)) for entity(\(keyword))"; self.add(errorContext: "while converting internal mapping to external mapping"); return nil }
					let superParams = Array(params[j ..< j+superPCount])
					j += superPCount
					remain -= superPCount
					
					let superRec = SimpleRecord(standard: supertype.entityDefinition.name, parameters: superParams)
					subsuper.append(superRec)
				}
				return subsuper
				
			case .userDefinedKeyword(let keyword):
					guard let subsuper = foreignReferenceResolver.convertToExternalMapping(from: internalMapping, dataSection: dataSection)
					else { self.error = foreignReferenceResolver.error ?? "user defined entity(\(keyword)) external mapping conversion unknown error"; self.add(errorContext: "while converting internal mapping to external mapping"); return nil }
				return subsuper
			}
		}

	}
}


