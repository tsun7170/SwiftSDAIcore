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
		public enum Error {
			case decoderError(String)
			case parserError(P21Error)
			case resolveError(String)
		}
		
		
		public private(set) var exchangeStructrure: ExchangeStructure?
		
		public private(set) var error: Error? {
			didSet {
				if let monitor = activityMonitor, oldValue == nil, let error = error {
					monitor.decoderDidSet(error: error)
				}
			}
		}
		

		private let repository: SDAISessionSchema.SdaiRepository
		private let schemaList: SchemaList
		private let activityMonitor: ActivityMonitor?
		private let foreginReferenceResolver: ForeignReferenceResolver
		
		//MARK: constructor
		public init?(output: SDAISessionSchema.SdaiRepository, 
								 schemaList: KeyValuePairs<SchemaName,SDAISchema.Type>,
								 monitor: ActivityMonitor? = nil,
								 foreginReferenceResolver: ForeignReferenceResolver = ForeignReferenceResolver() ) {
			self.repository = output
			self.schemaList = schemaList
			self.activityMonitor = monitor
			self.foreginReferenceResolver = foreginReferenceResolver
		}
		
		//MARK: decoding operation
		public func decode<CHARSTREAM>(input charStream: CHARSTREAM) -> [SDAIPopulationSchema.SdaiModel]?
		where CHARSTREAM: IteratorProtocol, CHARSTREAM.Element == Character
		{
			let parser = ExchangeStructureParser(charStream: charStream, monitor: self.activityMonitor)
			exchangeStructrure = parser.parseExchangeStructure()
			guard let exchangeStructrure = exchangeStructrure else {
				error = .parserError(parser.error ?? P21Error(message: "<unknown parser error>", lineNumber: 0))
				return nil
			}
			
			exchangeStructrure.repository = self.repository
			exchangeStructrure.foreignReferenceResolver = self.foreginReferenceResolver
			
			for (schemaName, schemaType) in self.schemaList {
				guard exchangeStructrure.registrer(schemaName: schemaName, schema: schemaType) else {
					error = .decoderError(exchangeStructrure.error ?? "<unknown schema registration error>")
					return nil
				}
			}
			for schemaDef in Set(exchangeStructrure.shcemaRegistory.values.lazy.map{$0.schemaDefinition}) {
				let fallback = SDAIPopulationSchema.SdaiModel.fallBackModel(for: schemaDef)
				fallback.mode = .readWrite
				fallback.contents.resetCache(relatedTo: nil)
			}
		
			var createdModels: [SDAIPopulationSchema.SdaiModel] = []
			for (i,datasec) in exchangeStructrure.dataSection.enumerated() {
				guard datasec.resolveSchema() else { 
					exchangeStructrure.add(errorContext: "while resolving data section[\(i)]")
					error = .resolveError(exchangeStructrure.error ?? "<unknown schema resolution error>")
					return nil
				}
				guard let model = datasec.assignModel(filename: exchangeStructrure.headerSection.fileName.NAME) else {
					exchangeStructrure.add(errorContext: "while setting up data section[\(i)]")
					error = .resolveError(exchangeStructrure.error ?? "<unknown schema resolution error>")
					return nil
				}
				createdModels.append(model)
			}
			
			if let monitor = activityMonitor { monitor.startedResolvingEntityInstances() }
			for instanceName in exchangeStructrure.entityInstanceRegistory.keys {
				guard let _ = exchangeStructrure.resolve(entityInstanceName: instanceName) else {
					error = .resolveError(exchangeStructrure.error ?? "<unknown entity instance resolution error>")
					return nil
				}
				if let monitor = activityMonitor { monitor.decoderResolved(entiyInstanceName: instanceName) }
			}
			if let monitor = activityMonitor { monitor.completedResolving() }
			
			for model in createdModels {
				model.updateChangeDate()
				model.mode = .readOnly
			}
			for schemaDef in Set(exchangeStructrure.shcemaRegistory.values.lazy.map{$0.schemaDefinition}) {
				let fallback = SDAIPopulationSchema.SdaiModel.fallBackModel(for: schemaDef)
				fallback.mode = .readOnly
			}
			
			return createdModels
		}
		
		
	}
}
