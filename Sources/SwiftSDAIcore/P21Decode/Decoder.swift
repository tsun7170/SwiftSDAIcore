//
//  Decoder.swift
//  
//
//  Created by Yoshida on 2021/05/11.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension P21Decode {
	
  /// `Decoder` is responsible for parsing and decoding STEP (ISO 10303-21) character streams into SDAI models according to known STEP schemas.
  /// 
  /// The decoding process manages the parsing of the character stream, the registration and resolution of STEP schemas, assignment to models,
  /// and instance resolution. Errors encountered during any stage of decoding are consolidated and exposed for clients.
  /// 
  /// - Maintains references to the output repository, known schema types, monitoring hooks, and a foreign reference resolver.
  /// - Supports error reporting for parsing, schema registration, and instance resolution failures.
  /// - Provides a single primary decoding operation which returns an array of successfully decoded models or signals failure via the error property.
  /// 
  /// Thread Safety:
  ///     This class is not thread-safe. Use from a single thread at a time.
  /// 
  /// Usage:
  ///     Construct by passing a repository, schema list, and optional monitor or foreign reference resolver.
  ///     Invoke the `decode(input:transaction:)` method to parse an input character stream and populate the repository.
  /// 
  /// - Note: The decoder holds the most recent parsed `ExchangeStructure` and error for inspection after decoding.
	public final class Decoder {
		
		/// consolidated error info from decoder's subsystems
		public enum Error: Equatable, CustomStringConvertible {
			case decoderError(String)
			case parserError(P21Error)
			case resolveError(String)

      public var description: String {
        switch self {
          case .decoderError(let string):
            return  """
                    decoder error:
                    \(string)
                    """
          case .parserError(let p21Error):
            return  """
                    parser error:
                    \(p21Error)
                    """
          case .resolveError(let string):
            return  """
                    resolve error:
                    \(string)
                    """
        }
      }
		}
		
		
    /// The most recently parsed `ExchangeStructure`, representing the top-level result of the STEP (ISO 10303-21) character stream decoding.
    /// 
    /// This property is updated each time the `decode(input:transaction:)` method is called, and holds
    /// the entire parsed structure of the STEP file, including header, schema registrations, data sections, and
    /// entity instance registry. If decoding fails, this property may be `nil`.
    ///
    /// Clients can inspect this property after decoding to access detailed information about
    /// the exchange structure, including any errors or metadata encountered during parsing.
    ///
    /// - Note: This property is read-only outside the decoder. Its value is cleared or replaced on each decode operation.
		public private(set) var exchangeStructure: ExchangeStructure?
		
    /// The most recent error encountered during decoding, if any.
    ///
    /// This property is set whenever an error occurs during the decoding process, such as a failure in parsing,
    /// schema registration, or instance resolution. It is updated each time decoding is attempted and remains `nil`
    /// if the most recent operation was successful.
    ///
    /// - Note: The error value is also reported to the activity monitor, if one is provided, the first time it is set
    ///         after a successful operation. Clients can inspect this property to determine the cause of decoding failure.
    ///
    /// - SeeAlso: `ExchangeStructure`, `decode(input:transaction:)`
		public private(set) var error: Error? {
			didSet {
				if let monitor = activityMonitor, oldValue == nil, let error = error {
					monitor.decoderDidSet(error: error)
				}
			}
		}
		

    /// The SDAI repository to which the decoded entities are stored.
    ///
    /// This repository serves as the output destination for all entities, models,
    /// and related data structures decoded from the STEP (ISO 10303-21) character stream.
    /// It represents the persistent storage for the resulting SDAI models and ensures
    /// that all decoded data is organized according to the repository's schema and structure.
    ///
    /// - Note: The repository must be provided at initialization and is referenced throughout
    ///         the decoding process for entity creation, model assignment, and data population.
    ///         Its lifetime should encompass all decoding and subsequent data access operations.
    ///
    /// - SeeAlso: `SDAISessionSchema.SdaiRepository`
		public let repository: SDAISessionSchema.SdaiRepository
		private let schemaList: SchemaList
		private let activityMonitor: ActivityMonitor?
		private let foreignReferenceResolver: ForeignReferenceResolver
		
		//MARK: constructor
		/// p21 character stream decoder constructor
		/// 
		/// - Parameters:
    ///   - repository: SDAI repository to which the decoded entities are stored
		///   - schemaList: list of known STEP schema
		///   - monitor: decoder activity monitor pulg-in object
		///   - foreignReferenceResolver: foreign reference resolver pulg-in object
		///
		public init?(
			output repository: SDAISessionSchema.SdaiRepository,
			schemaList: KeyValuePairs<SchemaName,SDAI.SchemaType.Type>,
			monitor: ActivityMonitor? = nil,
			foreignReferenceResolver: ForeignReferenceResolver = ForeignReferenceResolver() )
		{
			self.repository = repository
			self.schemaList = schemaList
			self.activityMonitor = monitor
			self.foreignReferenceResolver = foreignReferenceResolver
		}
		
		//MARK: decoding operation
		/// decode a given character stream according to ISO 10303-21 and known STEP schemas
		/// - Parameter charStream: p21 character stream
    /// 
		/// - Parameter transaction: RW transaction for decoding action
		/// - Returns: array of SDAI models decoded
		/// 
		public func decode<CHARSTREAM>(
			input charStream: CHARSTREAM,
//			repository: SDAISessionSchema.SdaiRepository,
			transaction: SDAISessionSchema.SdaiTransactionRW
		) -> [SDAIPopulationSchema.SdaiModel]?
		where CHARSTREAM: P21Decode.CharacterStream //IteratorProtocol, CHARSTREAM.Element == Character
		{
			guard let session = transaction.owningSession else {
				SDAI.raiseErrorAndContinue(.TR_NAVL(transaction), detail: "transaction in invalid state")
				return nil
			}

			let parser = ExchangeStructureParser(
				charStream: charStream,
				output: self.repository,
				foreignReferenceResolver: self.foreignReferenceResolver,
				monitor: self.activityMonitor)

			exchangeStructure = parser.parseExchangeStructure()
			guard let exchangeStructure = exchangeStructure else {
				error = .parserError(parser.error ?? P21Error(message: "<unknown parser error>", lineNumber: 0))
				return nil
			}

			for (schemaName, schemaType) in self.schemaList {
				guard exchangeStructure.register(schemaName: schemaName, schema: schemaType) else {
					error = .decoderError(exchangeStructure.error ?? "<unknown schema registration error>")
					return nil
				}
			}

			session.prepareFallBackModels(
				for: exchangeStructure.targetSchemas,
				transaction: transaction
			)

			var createdModels: [SDAIPopulationSchema.SdaiModel] = []
			for (i,datasec) in exchangeStructure.dataSections.enumerated() {
				guard datasec.resolveSchema() else { 
					exchangeStructure.add(errorContext: "while resolving data section[\(i)]")
					error = .resolveError(exchangeStructure.error ?? "<unknown schema resolution error>")
					return nil
				}
				guard let rwmodel = datasec
					.assignModel(
						filename: exchangeStructure.headerSection.fileName.shortName,
						repository: repository,
						transaction: transaction
					)
				else {
					exchangeStructure.add(errorContext: "while setting up data section[\(i)]")
					error = .resolveError(exchangeStructure.error ?? "<unknown schema resolution error>")
					return nil
				}

				createdModels.append(rwmodel)
			}
			
			if let monitor = activityMonitor { monitor.startedResolvingEntityInstances() }

			for instanceName in exchangeStructure.entityInstanceRegistry.keys {
				guard let _ = exchangeStructure.resolve(
					entityInstanceName: instanceName)
				else {
					error = .resolveError(exchangeStructure.error ?? "<unknown entity instance resolution error>")
					return nil
				}
				if let monitor = activityMonitor { monitor.decoderResolved(entityInstanceName: instanceName) }
			}

			if let monitor = activityMonitor { monitor.completedResolving() }

			return createdModels
		}
		
		
	}
}
