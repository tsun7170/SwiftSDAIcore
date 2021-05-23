//
//  File.swift
//  
//
//  Created by Yoshida on 2021/05/23.
//

import Foundation

extension P21Decode.ExchangeStructure {
	
	internal func resolveTopLevelEntities() -> [String : Set<EntityInstanceName>] {
		var result = Set(entityInstanceRegistory.keys)
		
		for eiRecord in entityInstanceRegistory.values {
			switch eiRecord.source {
			case .reference(let reference):
				let constituents = self.constituentEntities(entityReference: reference)
				result.subtract(constituents)
				
			case .simpleRecord(let simple, _):
				let constituents = self.constituentEntities(internalMapping: simple)
				result.subtract(constituents)
				
			case .subsuperRecord(let subsuper, _):
				for simple in subsuper {
					let constituents = self.constituentEntities(internalMapping: simple)
					result.subtract(constituents)
				}
			}
		}

		return classifyEntities(entities: result)
	}
	
	private func classifyEntities(entities: Set<EntityInstanceName>) -> [String : Set<EntityInstanceName>] {
		var result: [String : Set<EntityInstanceName>] = [:]
		
		for entity in entities {
			var type = "unknown"
			if let eirec = self.entityInstanceRegistory[entity] {
				switch eirec.source {
				case .reference(let reference):
					if reference.uri != nil { type = "reference(external)" }
					else if let frag = reference.fragment { type = "reference(\(frag))" }
					else { type = "reference(unknown)" }
				case .simpleRecord(let simple, _):
					switch simple.keyword {
					case .standardKeyword(let keyword):
						type = keyword
					case .userDefinedKeyword(let keyword):
						type = "!"+keyword
					}
				case .subsuperRecord(_ , _):
					type = "complex"
				}
			}	
			
			if var value = result[type] {
				value.insert(entity)
				result[type] = value
			}
			else {
				result[type] = [entity]
			}
		}	
		
		return result
	}
	
	
	private func constituentEntities(entityReference: Resource) -> Set<EntityInstanceName> {
		if entityReference.uri != nil {
			return []
		}
		
		if let urifrag = entityReference.fragment {
			guard let anchorRec = self.anchorSection.externalItems[urifrag] else { return [] }
			return self.constituentEntities(anchorItem: anchorRec.anchorItem)
		}
		
		return []
	}
	
	private func constituentEntities(anchorItem: AnchorItem) -> Set<EntityInstanceName> {
		switch anchorItem {
		case .rhsOccurenceName(let rhsname):
			switch rhsname {
			case .entityInstanceName(let name):
				return [name]
				
			default:
				return []
			}
			
		case .resource(let reference):
			return self.constituentEntities(entityReference: reference)
			
		case .anchorItemList(let list):
			var result: Set<EntityInstanceName> = []
			for item in list {
				result.formUnion(self.constituentEntities(anchorItem: item))	
			}
			return result
			
		default:
			return []	
		}
	}
	
	private func constituentEntities(internalMapping: SimpleRecord) -> Set<EntityInstanceName> {
		var result: Set<EntityInstanceName> = []
		
		for param in internalMapping.parameterList {
			result.formUnion(self.extractEntityNames(param: param))
		}
		
		return result
	}
	
	private func extractEntityNames(param: Parameter) -> Set<EntityInstanceName> {
		switch param {
		case .untypedParameter(let untyped):
			
			switch untyped {
			case .rhsOccurenceName(let rhsname):
				switch rhsname {
				case .entityInstanceName(let name):
					return [name]
				default:
					break
				}
				
			case .list(let list):
				var result: Set<EntityInstanceName> = []
				for item in list {
					result.formUnion(self.extractEntityNames(param: item))
				}
				return result
				
			default:
				break
			}
			
		default:
			break
		}
		return []
	}
	
}
