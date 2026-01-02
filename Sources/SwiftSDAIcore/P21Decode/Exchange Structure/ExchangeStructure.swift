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
	public final class ExchangeStructure:
    SDAI.Object, Sendable, CustomStringConvertible
  {
		nonisolated(unsafe)
		public internal(set) var headerSection = HeaderSection()
		nonisolated(unsafe)
		public internal(set) var anchorSection = AnchorSection()
		nonisolated(unsafe)
		public internal(set) var dataSections: [DataSection] = []
		
		public let foreignReferenceResolver: ForeignReferenceResolver
		public let repository: SDAISessionSchema.SdaiRepository

		nonisolated(unsafe)
		public internal(set) var valueInstanceRegistry: [ValueInstanceName:ValueInstanceRecord] = [:]
		nonisolated(unsafe)
		public internal(set) var entityInstanceRegistry: [EntityInstanceName:EntityInstanceRecord] = [:]
		nonisolated(unsafe)
		public private(set) var schemaRegistry: [SchemaName:SDAISchema.Type] = [:]
		
		public var sdaiModels: some Collection<SDAIPopulationSchema.SdaiModel> {
			let models = dataSections.lazy.compactMap{ $0.model }
			return models
		}
		
		private let activityMonitor: ActivityMonitor?

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
		nonisolated(unsafe)
		public var error: String? {
			didSet {
				if let monitor = activityMonitor, oldValue == nil, let error = error {
					monitor.exchangeStructureDidSet(error: error)
				}
			}
		}
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
		
		public func register(schemaName: SchemaName, schema: SDAISchema.Type) -> Bool {
			let canon = canonicalSchemaName(schemaName)
			if let old = schemaRegistry.updateValue(schema, forKey: canon) {
				self.error = "duplicated schema name(\(canon)) detected with definition(\(schema.schemaDefinition.name)), old definition = (\(old.schemaDefinition.name))"
				return false
			}
			return true
		}

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




		public func resolve(
			schemaName: SchemaName
		) -> SDAISchema.Type?
		{
      push(context: .schemaName(schemaName: schemaName))
      defer { popContext() }

			let canon = canonicalSchemaName(schemaName)
			return schemaRegistry[canon]
		}

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


