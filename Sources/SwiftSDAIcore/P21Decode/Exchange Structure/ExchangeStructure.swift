//
//  ExchangeStructure.swift
//  
//
//  Created by Yoshida on 2021/04/30.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension P21Decode {
	
	public final class ExchangeStructure {
		public internal(set) var headerSection = HeaderSection()
		public internal(set) var anchorSection = AnchorSection()
		public internal(set) var dataSection: [DataSection] = []
		
		public internal(set) var foreignReferenceResolver: ForeignReferenceResolver? = nil
		public internal(set) var repository: SDAISessionSchema.SdaiRepository? = nil

		public internal(set) var valueInstanceRegistory: [ValueInstanceName:ValueInstanceRecord] = [:]
		public internal(set) var entityInstanceRegistory: [EntityInstanceName:EntityInstanceRecord] = [:]
		public private(set) var shcemaRegistory: [SchemaName:SDAISchema.Type] = [:]
		
		public private(set) lazy var topLevelEntities = self.resolveTopLevelEntities()
		
		
		private let activityMonitor: ActivityMonitor?
		
		//MARK: - constructor
		public init(monitor: ActivityMonitor? = nil) {
			self.activityMonitor = monitor
		}
		
		
		//MARK: - error handling
		public var error: String? {
			didSet {
				if let monitor = activityMonitor, oldValue == nil, let error = error {
					monitor.exchangeStructureDidSet(error: error)
				}
			}
		}
		public func add(errorContext: String) {
			error = (error ?? "unknown error") + ", " + errorContext
		}


		//MARK: - register related
		internal func register(entityInstanceName: EntityInstanceName, record: EntityInstanceRecord) -> Bool {
			if let old = entityInstanceRegistory.updateValue(record, forKey: entityInstanceName) {
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
		
		public func registrer(schemaName: SchemaName, schema: SDAISchema.Type) -> Bool {
			let canon = canonicalSchemaName(schemaName)
			if let old = shcemaRegistory.updateValue(schema, forKey: canon) {
				self.error = "duplicated schema name(\(canon)) detected with definition(\(schema.schemaDefinition.name)), old definition = (\(old.schemaDefinition.name))"
				return false
			}
			return true
		}
		
		//MARK: - resolve related
		public func resolve(schemaName: SchemaName) -> SDAISchema.Type? {
			let canon = canonicalSchemaName(schemaName)
			return shcemaRegistory[canon]
		}

		public func resolve(constantEntityName: ConstantName) -> SDAI.EntityReference? {
			guard let schema = self.resolve(schemaName: self.headerSection.fileSchema.SCHEMA_IDENTIFIERS[0]) 
			else { self.add(errorContext: "while resolving constant entity name(\(constantEntityName))"); return nil }
			
			guard let const = schema.schemaDefinition.constants[constantEntityName]
			else { self.error = "constant entity name(\(constantEntityName)) not found in schema(\(schema.schemaDefinition.name))"; return nil }
			
			guard let entity = const.entityReference
			else { self.error = "constant value(\(const)) can not be resolved as entity reference"; self.add(errorContext: "while resolving constant entity name(\(constantEntityName))"); return nil }
			
			return entity
		}
		
		
		public func resolve(constantValueName: ConstantName) -> SDAI.GENERIC? {
			guard let schema = self.resolve(schemaName: self.headerSection.fileSchema.SCHEMA_IDENTIFIERS[0]) 
			else { self.add(errorContext: "while resolving constant value name(\(constantValueName))"); return nil }
			
			guard let const = schema.schemaDefinition.constants[constantValueName]
			else { self.error = "constant value name(\(constantValueName)) not found in schema(\(schema.schemaDefinition.name))"; return nil }

			return const
		}
		
		public func resolve(valueInstanceName: ValueInstanceName) -> Parameter? {
			guard let virec = self.valueInstanceRegistory[valueInstanceName]
			else { self.error = "value instance name(\(valueInstanceName)) not found in reference section"; return nil }
			
			if let value = virec.resolved { return value }
			
			guard let resolved = self.resolve(valueReference: virec.reference)
			else { self.add(errorContext: "while resolving value instance name(\(valueInstanceName))"); return nil }
			virec.resolved = resolved
			return resolved
		}
		
		public func resolve(entityInstanceName: EntityInstanceName) -> SDAI.ComplexEntity? {
			guard let eirec = self.entityInstanceRegistory[entityInstanceName]
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
				
				let resolved = SDAI.ComplexEntity(entities: partials, model: datasec.model!, name: entityInstanceName)
				eirec.resolved = resolved
				return resolved
				
			case .subsuperRecord(let subsuper, let datasec):
				guard let partials = self.resolve(externalMapping: subsuper, dataSection: datasec)
				else { self.add(errorContext: "while resolving entity instance subsuper record #\(entityInstanceName)"); return nil }

				let resolved = SDAI.ComplexEntity(entities: partials, model: datasec.model!, name: entityInstanceName)
				eirec.resolved = resolved
				return resolved
			}
		}
		
		public func resolve(valueReference: ExchangeStructure.Resource) -> Parameter? {
			if valueReference.fragment == nil {
				return .untypedParameter(.noValue)
			}
			
			if valueReference.uri != nil {
				guard let resolved = foreignReferenceResolver?.resolve(valueReference: valueReference)
				else { self.error = foreignReferenceResolver?.error ?? "<unknown foreign value reference resolution error>"; self.add(errorContext: "while resolving value reference(\(valueReference))"); return nil }
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
		
		public func resolveValue(anchorItem: AnchorItem) -> Parameter? {
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
				
			case .rhsOccurenceName(let rhsname):
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
		
		public func resolve(entityReference: ExchangeStructure.Resource) -> ParameterRecoveryResult<SDAI.ComplexEntity?> {
			if entityReference.fragment == nil {
				return .success(nil)
			}
			
			if entityReference.uri != nil {
				guard case.success(let resolved) = foreignReferenceResolver?.resolve(entityReference: entityReference)
				else { self.error = foreignReferenceResolver?.error ?? "<unknown foreign entity reference resolution error>"; self.add(errorContext: "while resolving entity reference(\(entityReference))"); return .failure }
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
		
		public func resolveInstance(anchorItem: AnchorItem) -> ParameterRecoveryResult<SDAI.ComplexEntity?> {
			switch anchorItem {
			case .noValue:
				return .success(nil)
				
			case .rhsOccurenceName(let rhsname):
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
		
		public func resolve(externalMapping: SubsuperRecord, dataSection: DataSection) -> [SDAI.PartialEntity]? {
			guard let schemaDef = dataSection.schema?.schemaDefinition
			else { self.error = "could not find schema definition dictionary for data section(\(dataSection))"; return nil }
			
			var partials:[SDAI.PartialEntity] = []
			for (i,simple) in externalMapping.enumerated() {
				switch simple.keyword {
				case .standardKeyword(let keyword):
					guard let entityDef = schemaDef.entities[keyword]
					else { self.error = "entity name(\(keyword)) not found in schema(\(schemaDef.name))"; self.add(errorContext: "while recovering constutient entity[\(i)]"); return nil }
					
					guard let partial = entityDef.partialEntityType.init(parameters: simple.parameterList, exchangeStructure: self)
					else { self.add(errorContext: "while recovering constutient entity[\(i)]"); return nil }
					partials.append(partial)
					
				case .userDefinedKeyword(let keyword):
					guard let partial = foreignReferenceResolver?.recover(userDefinedEntity: simple)
					else { self.error = foreignReferenceResolver?.error ?? "user defined entity(\(keyword)) recovery unknown error"; self.add(errorContext: "while recovering constutient entity[\(i)]"); return nil }
					partials.append(partial)
				}	
			}
			return partials
		}
		
		
		
		public func convertToExternalMapping(from internalMapping:SimpleRecord, dataSection: DataSection) -> SubsuperRecord? {
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
					else { self.error = "supplied number of parameters(\(params.count)) are smaller than required(\(entityDef.totalExplicitAttribureCounts)) for entity(\(keyword))"; self.add(errorContext: "while converting internal mapping to external mapping"); return nil }
					let superParams = Array(params[j ..< j+superPCount])
					j += superPCount
					remain -= superPCount
					
					let superRec = SimpleRecord(standard: supertype.entityDefinition.name, parameters: superParams)
					subsuper.append(superRec)
				}
				return subsuper
				
			case .userDefinedKeyword(let keyword):
				guard let subsuper = foreignReferenceResolver?.convertToExternalMapping(from: internalMapping, dataSection: dataSection)
				else { self.error = foreignReferenceResolver?.error ?? "user defined entity(\(keyword)) external mapping conversion unknown error"; self.add(errorContext: "while converting internal mapping to external mapping"); return nil }
				return subsuper
			}
		}

	}
}


