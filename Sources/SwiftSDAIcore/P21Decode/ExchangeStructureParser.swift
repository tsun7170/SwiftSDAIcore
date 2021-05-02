//
//  File.swift
//  
//
//  Created by Yoshida on 2021/04/26.
//

import Foundation

extension P21Decode {
	
	public class ExchangeStructureParser {
		
		private let tokenStream: TokenStream
		private let exchangeStructure = ExchangeStructure()
		
		public init<CHARSTREAM>(charStream: CHARSTREAM) 
		where CHARSTREAM: IteratorProtocol, CHARSTREAM.Element == Character
		{
			let p21charStream = P21CharacterStream(charStream: charStream)
			self.tokenStream = TokenStream(p21stream: p21charStream)
		}
		
		//MARK: - error handling
		public private(set) var error: P21Error?

		private func setError(message: String) {
			error = P21Error(message: message, lineNumber: tokenStream.lineNumber)
		}
		
		private func add(errorContext context: String) {
			guard let origin = error else { return }
			error = P21Error(message: "\(origin.message), \(context)", lineNumber: origin.lineNumber)
		}
		
		private func setErrorFromTokenStream(context: String) {
			if let origin = tokenStream.error {
				error = origin
			}
			else {
				setError(message: "unknown token stream error")
			}
			add(errorContext: context)
		}
		
		private func setErrorEndOfTokenStream(lastToken: TerminalToken?, context: String) {
			setError(message: "unexpected end of token stream\( lastToken != nil ? " after \(lastToken!)" : ""), \(context)")
		}
		
		private func setError(unexpectedToken: TerminalToken, context: String) {
			setError(message: "unexpected token(\(unexpectedToken)) is detected, \(context)")
		}
		
		private func setError(from exchange: ExchangeStructure, context: String) {
			setError(message: exchange.error ?? "unknown exchange structure error")
			add(errorContext: context)
		}
		
		//MARK: - token check
		private func confirm(nextToken expected: TerminalToken, context: String, lastToken: TerminalToken?) -> Bool {
			guard let next = tokenStream.next() else {
				setErrorEndOfTokenStream(lastToken: lastToken, context: context)
				return false
			}
			guard next == expected else {
				setError(unexpectedToken: next, context: context)
				return false
			}
			return true
		}
		
		//MARK:- Exchange Structure
		public func parseExchangeStructure() -> ExchangeStructure? {
			guard tokenStream.confirm(specialToken: "ISO-10303-21;") else {
				setErrorFromTokenStream(context: "while parsing the head of exchange structure")
				return nil
			}
			
			if !parseHeaderSection() { add(errorContext: "while parsing exchange structure"); return nil }
			
			var lastToken: TerminalToken?
			var expectingAnchor = true
			var expectingReference = true
			while let token = tokenStream.next() {
				switch token {
				case .STANDARD_KEYWORD("ANCHOR") where expectingAnchor:
					expectingAnchor = false
					if !parseAnchorSection(beginWith: token) { add(errorContext: "while parsing end of exchange structure"); return nil }
					
				case .STANDARD_KEYWORD("REFERENCE") where expectingReference:
					expectingAnchor = false
					expectingReference = false
					if !parseReferenceSection(beginWith: token) { add(errorContext: "while parsing end of exchange structure"); return nil }

				case .STANDARD_KEYWORD("DATA"):
					expectingAnchor = false
					expectingReference = false
					if !parseDataSection(beginWith: token) { add(errorContext: "while parsing end of exchange structure"); return nil }

				case .STANDARD_KEYWORD("END"):
					if !tokenStream.confirm(specialToken: "-ISO-10303-21;") { setErrorFromTokenStream(context: "while parsing end of exchange structure"); return nil }
					return exchangeStructure
					
				default:
					setError(unexpectedToken: token, context: "while parsing exchange structure")
					return nil
				}
				lastToken = token
			}
			
			setErrorEndOfTokenStream(lastToken: lastToken, context: "while parsing exchange structure")
			return nil
		}
		
		
		//MARK:- Header Section
		private func parseHeaderSection() -> Bool {
			if !tokenStream.confirm(specialToken: "HEADER;") { setErrorFromTokenStream(context: "while parsing the head of header section"); return false }
			
			for (i,expected) in ["FILE_DESCRIPTION", "FILE_NAME", "FILE_SCHEMA"].enumerated(){
				guard let entity = parseHeaderEntity(keyword: tokenStream.next()) 
				else { add(errorContext: "while parsing header entity #\(i)"); return false }
				
				guard let name = entity.keyword.asStandardKeyword, name == expected 
				else { setError(message: "unexpected entity(\(entity.keyword)) other than '\(expected)', while parsing header entity #\(i)"); return false }
				
				exchangeStructure.headerSection.headerEntityList.append(entity)
			}

			var lastToken: TerminalToken? = nil
			while let keyword = tokenStream.next() {
				if case .STANDARD_KEYWORD(let symbol) = keyword, symbol == "ENDSEC" {
					if !confirm(nextToken: .spSEMICOLON, context: "while parsing end of header section", lastToken: lastToken) { return false }
					return true
				}

				guard let entity = parseHeaderEntity(keyword: keyword) else { add(errorContext: "while parsing header entity list"); return false }
				exchangeStructure.headerSection.headerEntityList.append(entity)

				lastToken = keyword
			}
			
			setErrorEndOfTokenStream(lastToken: lastToken, context: "while parsing header entity list")
			return false
		}
		
		private func parseHeaderEntity(keyword: TerminalToken?) -> ExchangeStructure.SimpleRecord? {
			guard let keyword = keyword else { setErrorEndOfTokenStream(lastToken: nil, context: "while expecting header entity keyword"); return nil }
			guard let rec = parseSimpleRecord(keyword: keyword) else { add(errorContext: "while parsing header entity"); return nil }
			
			if !confirm(nextToken: .spSEMICOLON, context: "while parsing end of header entity", lastToken: keyword) { return nil }
			return rec
		}
		
		//MARK:- Anchor Section
		private func parseAnchorSection(beginWith keyword: TerminalToken) -> Bool {
			if !confirm(nextToken: .spSEMICOLON, context: "while parsing head of anchor section", lastToken: keyword) { return false }
			
			var lastToken: TerminalToken? = nil
			while let token = tokenStream.next() {
				switch token {
				case .STANDARD_KEYWORD("ENDSEC"):
					if !confirm(nextToken: .spSEMICOLON, context: "while parsing end of anchor section", lastToken: lastToken) { return false }
					return true
					
				case .RESOURCE(_):
					if !parseAnchor(name: token) { add(errorContext: "while parsing anchor list"); return false }
					
				default:
					setError(unexpectedToken: token, context: "while parsing anchor list")
					return false
				}
				lastToken = token
			}			
			setErrorEndOfTokenStream(lastToken: lastToken, context: "while parsing anchor list")
			return false
		}
		
		private func parseAnchor(name: TerminalToken) -> Bool {
			if !confirm(nextToken: .spEQUAL, context: "while parsing anchor", lastToken: name) { return false }
			guard let item = parseAnchorItem(beginWith: tokenStream.next()) else { add(errorContext: "while parsing anchor"); return false }

			var tag: ExchangeStructure.AnchorTag? = nil			
			var expectingAnchorTag = true
			while let token = tokenStream.next() {
				switch token {
				case .spLEFT_BRACE where expectingAnchorTag:
					expectingAnchorTag = false
					guard let anchorTag = parseAnchorTag(beginWith: token) else { add(errorContext: "while parsing tail of anchor"); return false }
					tag = anchorTag
					
				case .spSEMICOLON:
					guard case .RESOURCE(let anchorName) = name else { setError(unexpectedToken: name, context: "while parsing anchor name"); return false }
					exchangeStructure.anchorSection.register(name: anchorName, item: item, tag: tag)
					return true
					
				default:
					setError(unexpectedToken: token, context: "while parsing tail of anchor")
					return false
				}
			}
			setErrorEndOfTokenStream(lastToken: name, context: "while parsing tail of anchor")
			return false
		}
		
		private func parseAnchorItem(beginWith token: TerminalToken?) -> ExchangeStructure.AnchorItem? {
			guard let token = token else { setErrorEndOfTokenStream(lastToken: nil, context: "while parsing anchor item"); return nil }
			switch token {
			case .spDOLLER_SIGN:
				return .nullValue
				
			case .INTEGER(let val):
				return .integer(val)
				
			case .REAL(let val):
				return .real(val)
				
			case .STRING(let val):
				return .string(val)
				
			case .ENUMERATION(let val):
				return .enumeration(val)
				
			case .BINARY(let val):
				return .binary(val)
				
			case .RESOURCE(let ident):
				return .resource(ident)
				
			case .spLEFT_PARENTHESIS:
				guard let list = parseAnchorItemList(endingWith: .spRIGHT_PARENTHESIS) else { add(errorContext: "while parsing anchor item"); return nil }
				return .anchorItemList(list)
				
			case .ENTITY_INSTANCE_NAME(let name):
				return .rhsOccurenceName(.entityInstanceName(name))
				
			case .VALUE_INSTANCE_NAME(let name):
				return .rhsOccurenceName(.valueInstanceName(name))
				
			case .CONSTANT_ENTITY_NAME(let name):
				return .rhsOccurenceName(.constantEntityName(name))
				
			case .CONSTANT_VALUE_NAME(let name):
				return .rhsOccurenceName(.constantValueName(name))
				
			default:
				setError(unexpectedToken: token, context: "while parsing anchor item")
				return nil
			}
		}
		
		private func parseAnchorItemList(endingWith endToken: TerminalToken ) -> [ExchangeStructure.AnchorItem]? {
			var list:[ExchangeStructure.AnchorItem] = []
			var expectingComma = false
			var lastToken: TerminalToken? = nil
			while let token = tokenStream.next() {
				switch token {
				case endToken:
					return list
					
				case .spCOMMA where expectingComma:
					expectingComma = false
					
				default:
					guard let item =  parseAnchorItem(beginWith: token) else { add(errorContext: "while parsing anchor item list"); return nil }
					expectingComma = true
					list.append(item)				
				}				
				lastToken = token
			}	
			setErrorEndOfTokenStream(lastToken: lastToken, context: "while parsing anchor item list")
			return nil
		}
		
		private func parseAnchorTag(beginWith leftBrace: TerminalToken) -> ExchangeStructure.AnchorTag? {
			guard let tagName = tokenStream.next() else { setErrorEndOfTokenStream(lastToken: nil, context: "while parsing anchor tag"); return nil }
			if !confirm(nextToken: .spCOLON, context: "while parsing anchor tag", lastToken: tagName) { return nil }
			
			guard let anchorItem = parseAnchorItem(beginWith: tokenStream.next()) else { add(errorContext: "while parsing anchor tag"); return nil }
			if !confirm(nextToken: .spSEMICOLON, context: "while parsing end of anchor tag", lastToken: tagName) { return nil }
			
			switch tagName {
			case .TAG_NAME(let name):
				return ExchangeStructure.AnchorTag(tagName: name, anchorItem: anchorItem)
				
			case .STANDARD_KEYWORD(let name):
				return ExchangeStructure.AnchorTag(tagName: name, anchorItem: anchorItem)
				
			default:
				setError(unexpectedToken: tagName, context: "while parsing anchor tag name")
				return nil
			}
		}
		
		
		//MARK:- Reference Section
		private func parseReferenceSection(beginWith keyword: TerminalToken) -> Bool {
			if !confirm(nextToken: .spSEMICOLON, context: "while parsing head of reference section", lastToken: keyword) { return false }
			
			var lastToken: TerminalToken? = nil
			while let token = tokenStream.next() {
				switch token {
				case .STANDARD_KEYWORD("ENDSEC"):
					if !confirm(nextToken: .spSEMICOLON, context: "while parsing end of reference section", lastToken: lastToken) { return false }
					return true
					
				default:
					if token.isLHS_OCCURRENCE_NAME {
						if !parseReference(beginWith: token) { add(errorContext: "while parsing reference list"); return false }
					}
					else {
						setError(unexpectedToken: token, context: "while parsing reference list")
						return false
					}
				}
				lastToken = token
			}			
			setErrorEndOfTokenStream(lastToken: lastToken, context: "while parsing reference list")
			return false
		}
		
		private func parseReference(beginWith name: TerminalToken) -> Bool {
			if !confirm(nextToken: .spEQUAL, context: "while parsing reference", lastToken: name) { return false }
			
			guard let resource = tokenStream.next() else { setErrorEndOfTokenStream(lastToken: name, context: "while parsing reference"); return false }
			guard case .RESOURCE(let resourceValue) = resource else { setError(unexpectedToken: resource, context: "while parsing reference RHS resource"); return false }
			if !confirm(nextToken: .spSEMICOLON, context: "while parsing end of reference", lastToken: resource) { return false }

			switch name {
			case .ENTITY_INSTANCE_NAME(let entityName):
				guard exchangeStructure.register(entityInstanceName: entityName, reference: resourceValue) else {
					setError(from: exchangeStructure, context: "while parsing reference")
					return false
				}
			case .VALUE_INSTANCE_NAME(let valueName):
				guard exchangeStructure.register(valueInstanceName: valueName, reference: resourceValue) else {
					setError(from: exchangeStructure, context: "while parsing reference")
					return false
				}
			default:
				setError(unexpectedToken: name, context: "while parsing reference LHS")
				return false
			}
			return true
		}
		
		
		
		
		
		//MARK:- Data Section
		private func parseDataSection(beginWith keyword: TerminalToken) -> Bool {
			var lastToken: TerminalToken? = keyword
			
			guard let dataSection = parseDataSectionHeader() else { add(errorContext: "while parsing data section"); return false }
			exchangeStructure.dataSection.append(dataSection)
			
			while let name = tokenStream.next() {
				switch name {
				case .STANDARD_KEYWORD("ENDSEC"):
					if !confirm(nextToken: .spSEMICOLON, context: "while parsing end of data section", lastToken: name) { return false }
					return true
					
				case .ENTITY_INSTANCE_NAME(let entityName):
					if !confirm(nextToken: .spEQUAL, context: "while parsing entity instance", lastToken: name) { return false }
					
					guard let token = tokenStream.next() else { setErrorEndOfTokenStream(lastToken: name, context: "while parsing entity instance RHS"); return false }
					switch token {
					case .spLEFT_PARENTHESIS:
						guard let subsuper = parseSubsuperRecord(beginWith: token) else { add(errorContext: "while parsing entity instance RHS"); return false }
						guard exchangeStructure.register(entityInstanceName: entityName, subsuperRecord: subsuper, dataSection: dataSection) else { setError(from: exchangeStructure, context: "while parsing data section complex entity instance"); return false }
					default:
						if token.isKEYWORD {
							guard let simple = parseSimpleRecord(keyword: token) else { add(errorContext: "while parsing entity instance RHS"); return false }
							guard exchangeStructure.register(entityInstanceName: entityName, simpleRecord: simple, dataSection: dataSection) else { setError(from: exchangeStructure, context: "while parsing data section simple entity instance"); return false }
						}
						else {
							setError(unexpectedToken: token, context: "while parsing entity instance LHS")
							return false
						}
					}
					if !confirm(nextToken: .spSEMICOLON, context: "while parsing end of entity instance", lastToken: name) { return false }

				default:
					setError(unexpectedToken: name, context: "while parsing entity instance")
					return false
				}
				lastToken = name
			}			
			setErrorEndOfTokenStream(lastToken: lastToken, context: "while parsing entity instance")
			return false
		}
	
		private func parseDataSectionHeader() -> ExchangeStructure.DataSection? {
			var expectingParameterList = true
			var dataSectionParameters: [ExchangeStructure.Parameter]? = nil

			var lastToken: TerminalToken? = nil
			while let token = tokenStream.next() {
				switch token {
				case .spLEFT_PARENTHESIS where expectingParameterList:
					expectingParameterList = false
					guard let params = parseParameterList(endingWith: .spRIGHT_PARENTHESIS) else { add(errorContext: "while parsing data section header parameters"); return nil }
					dataSectionParameters = params
					
				case .spSEMICOLON:
					if let dataSectionParameters = dataSectionParameters {
						guard let name = dataSectionParameters[0].asString else { setError(message: "unexpected parameter(\(dataSectionParameters[0])) other than string as data section header parameter #1"); return nil }
						guard let list = dataSectionParameters[1].asListOfString else { setError(message: "unexpected parameter(\(dataSectionParameters[1])) other than list of string as data section header parameter #2"); return nil }
						guard let ds = ExchangeStructure.DataSection(exchange: exchangeStructure, name: name, schema: list[0]) else { setError(from: exchangeStructure, context: "while parsing data section header parameters"); return nil }
						return ds
					}
					else {
						guard let ds = ExchangeStructure.DataSection(exchange: exchangeStructure) else { setError(from: exchangeStructure, context: "while parsing data section header parameters"); return nil }
						return ds
					}
					
				default:
					setError(unexpectedToken: token, context: "while parsing data section header")
					return nil
				}
				lastToken = token
			}
			setErrorEndOfTokenStream(lastToken: lastToken, context: "while parsing data section header")
			return nil
		}
		
		private func parseSimpleRecord(keyword: TerminalToken?) -> ExchangeStructure.SimpleRecord? {
			guard let keyword = keyword else { setErrorEndOfTokenStream(lastToken: nil, context: "while parsing simple record"); return nil }
			
			if !confirm(nextToken: .spLEFT_PARENTHESIS, context: "while parsing simple record", lastToken: keyword) { return nil }
			guard let params = parseParameterList(endingWith: .spRIGHT_PARENTHESIS) else { add(errorContext: "while parsing simple record"); return nil }
			switch keyword {
			case .USER_DEFINED_KEYWORD(let symbol):
				return ExchangeStructure.SimpleRecord(userDefined: symbol, parameters: params)
				
			case .STANDARD_KEYWORD(let symbol):
				return ExchangeStructure.SimpleRecord(standard: symbol, parameters: params)
				
			default:
				setError(unexpectedToken: keyword, context: "while parsing simple record keyword")
				return nil
			}
		}
		
		private func parseSubsuperRecord(beginWith paren: TerminalToken) -> ExchangeStructure.SubsuperRecord? {
			guard let pe1 = parseSimpleRecord(keyword: tokenStream.next()) else { add(errorContext: "while parsing head of subsuper record"); return nil }
			var subsuper: ExchangeStructure.SubsuperRecord = [pe1]
			
			var lastToken: TerminalToken? = nil
			while let token = tokenStream.next() {
				switch token {
				case .spRIGHT_PARENTHESIS:
					return subsuper
					
				default:
					if token.isKEYWORD {
						guard let pe = parseSimpleRecord(keyword: token) else { add(errorContext: "while parsing subsuper record"); return nil }
						subsuper.append(pe)
					}
					else { setError(unexpectedToken: token, context: "while parsing subsuper record"); return nil }
				}
				lastToken = token
			}
			setErrorEndOfTokenStream(lastToken: lastToken, context: "while parsing subsuper record")
			return nil
		}
		
		
		//MARK:- non-terminal tokens
		private func parseParameterList(endingWith endToken: TerminalToken) -> [ExchangeStructure.Parameter]? {
			var list: [ExchangeStructure.Parameter] = []
			var expectingComma = false
			var lastToken: TerminalToken? = nil
			while let token = tokenStream.next() {
				switch token {
				case endToken:
					return list
					
				case .spCOMMA where expectingComma:
					expectingComma = false
					
				default:
					guard let parameter = parseParameter(beginWith: token) else { add(errorContext: "while parsing parameter list"); return nil }
					expectingComma = true
					list.append(parameter)
				}
				lastToken = token
			}	
			setErrorEndOfTokenStream(lastToken: lastToken, context: "while parsing parameter list")
			return nil
		}
		
		private func parseParameter(beginWith firstToken: TerminalToken?) -> ExchangeStructure.Parameter? {
			guard let firstToken = firstToken else { setErrorEndOfTokenStream(lastToken: nil, context: "while parsing parameter"); return nil }
			
			if case .STANDARD_KEYWORD(let keyword) = firstToken {
				if !confirm(nextToken: .spLEFT_PARENTHESIS, context: "while parsing typed parameter", lastToken: firstToken) { return nil }
				guard let parameter = parseParameter(beginWith: tokenStream.next()) else { add(errorContext: "while parsing typed parameter"); return nil }
				if !confirm(nextToken: .spRIGHT_PARENTHESIS, context: "while parsing typed parameter", lastToken: firstToken) { return nil }
				return .typedParameter(ExchangeStructure.TypedParameter(keyword: keyword, parameter: parameter))
			}
			else if firstToken == .spASTERISK {
				return .omittedParameter
			}
			else {
				switch firstToken {
				case .spDOLLER_SIGN:
					return .untypedParameter(.nullValue)
					
				case .INTEGER(let val):
					return .untypedParameter(.integer(val))
					
				case.REAL(let val):
					return .untypedParameter(.real(val))
					
				case .STRING(let val):
					return .untypedParameter(.string(val))
					
				case .ENUMERATION(let val):
					return .untypedParameter(.enumeration(val))
					
				case .BINARY(let val):
					return .untypedParameter(.binary(val))
					
				case .spLEFT_PARENTHESIS:
					guard let list = parseParameterList(endingWith: .spRIGHT_PARENTHESIS) else { add(errorContext: "while parsing parameter as a list"); return nil }
					return .untypedParameter(.list(list))
					
				case .ENTITY_INSTANCE_NAME(let name):
					return .untypedParameter(.rhsOccurenceName(.entityInstanceName(name)))
					
				case .VALUE_INSTANCE_NAME(let name):
					return .untypedParameter(.rhsOccurenceName(.valueInstanceName(name)))
					
				case .CONSTANT_ENTITY_NAME(let name):
					return .untypedParameter(.rhsOccurenceName(.constantEntityName(name)))
					
				case .CONSTANT_VALUE_NAME(let name):
					return .untypedParameter(.rhsOccurenceName(.constantValueName(name)))
					
				default:
					break
				}
			}
			setError(unexpectedToken: firstToken, context: "while parsing parameter")
			return nil
		}
		
	}
}

