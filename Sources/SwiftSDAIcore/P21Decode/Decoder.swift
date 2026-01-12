//
//  Decoder.swift
//  
//
//  Created by Yoshida on 2021/05/11.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension P21Decode {
	
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
		
		
		public private(set) var exchangeStructure: ExchangeStructure?
		
		public private(set) var error: Error? {
			didSet {
				if let monitor = activityMonitor, oldValue == nil, let error = error {
					monitor.decoderDidSet(error: error)
				}
			}
		}
		

		public let repository: SDAISessionSchema.SdaiRepository
		private let schemaList: SchemaList
		private let activityMonitor: ActivityMonitor?
		private let foreignReferenceResolver: ForeignReferenceResolver
		
		//MARK: constructor
		/// p21 character stream decoder constructor
		/// 
		/// - Parameters:
		///   - output: SDAI repository to which the decoded entities are stored
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
		/// - Parameter repository: repository to which decoded models are stored
		/// - Parameter transaction: RW transaction for decoding action
		/// - Returns: array of SDAI models decoded
		/// 
		public func decode<CHARSTREAM>(
			input charStream: CHARSTREAM,
//			repository: SDAISessionSchema.SdaiRepository,
			transaction: SDAISessionSchema.SdaiTransactionRW
		) -> [SDAIPopulationSchema.SdaiModel]?
		where CHARSTREAM: CharacterStream //IteratorProtocol, CHARSTREAM.Element == Character
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
