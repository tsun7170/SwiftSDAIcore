//
//  File.swift
//  
//
//  Created by Yoshida on 2021/04/22.
//

import Foundation

extension P21Decode {
	
	internal enum TerminalToken: Equatable {
		case USER_DEFINED_KEYWORD(String)
		case STANDARD_KEYWORD(String)
		case INTEGER(Int)
		case REAL(Double)
		case STRING(String)
		case ENTITY_INSTANCE_NAME(Int)
		case VALUE_INSTANCE_NAME(Int)
		case CONSTANT_ENTITY_NAME(String)
		case CONSTANT_VALUE_NAME(String)
		case TAG_NAME(String)
		case RESOURCE(String)
		case ENUMERATION(String)
		case BINARY(String)
		case spDOLLER_SIGN
		case spASTERISK
		case spSEMICOLON
		case spCOLON
		case spLEFT_PARENTHESIS
		case spRIGHT_PARENTHESIS
		case spCOMMA
		case spLEFT_BRACE
		case spRIGHT_BRACE
		case spEQUAL
		
		var isKEYWORD: Bool {
			switch self {
			case .USER_DEFINED_KEYWORD(_):
				return true
			case .STANDARD_KEYWORD(_):
				return true
			default:
				return false
			}
		}
		
		var isLHS_OCCURRENCE_NAME: Bool {
			switch self {
			case .ENTITY_INSTANCE_NAME(_):
				return true
			case .VALUE_INSTANCE_NAME(_):
				return true
			default:
				return false
			}	
		}
		
		var isRHS_OCCURRENCE_NAME: Bool {
			switch self {
			case .ENTITY_INSTANCE_NAME(_):
				return true
			case .VALUE_INSTANCE_NAME(_):
				return true
			case .CONSTANT_ENTITY_NAME(_):
				return true
			case .CONSTANT_VALUE_NAME(_):
				return true
			default:
				return false
			}	
		}		
	}
	
	internal final class TokenStream: IteratorProtocol
	{
		internal typealias Element = TerminalToken
		
		private static let SPACE = CharacterSet(charactersIn: " ")
		private static let DIGIT = CharacterSet(charactersIn: "0123456789")
		private static let LOWER = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz")
		private static let UPPER = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ_")
		private static let SPECIAL = CharacterSet(charactersIn: "!\"*$%&.#+,-()?/:;<=>@[]{|}^`~")
		private static let REVERSE_SOLIDUS = CharacterSet(charactersIn: "\\")
		private static let APOSTROPHE = CharacterSet(charactersIn: "'")
		private static let SIGN = CharacterSet(charactersIn: "+-")
		private static let HEX = CharacterSet(charactersIn: "0123456789ABCDEF")
		private static let csBinaryHead = CharacterSet(charactersIn: "0123")
		private static let csTokenSeparatorStart = SPACE.union(REVERSE_SOLIDUS).union(CharacterSet(charactersIn: "/"))
		private static let csPrintControlDirectiveCode = CharacterSet(charactersIn: "NF")
		
		
		private var p21stream: P21CharacterStream
		private let activityMonitor: ActivityMonitor?
		internal var lineNumber: Int { p21stream.lineNumber }
		
		internal private(set) var error: P21Error? {
			didSet {
				if let monitor = activityMonitor, oldValue == nil, let error = error {
					monitor.tokenStreamDidSet(error: error)
				}
			}
		}
		private func setError(_ message: String) {
			error = P21Error(message: message, lineNumber: self.lineNumber)
		}
		
		internal init(p21stream:P21CharacterStream, monitor: ActivityMonitor? = nil) {
			self.p21stream = p21stream
			self.activityMonitor = monitor
		}
		
		internal func confirm(specialToken: String) -> Bool {
			for (i,sp) in specialToken.enumerated() {
				guard let c = p21stream.next() else { setError("unexpected end of input stream after '\(specialToken.prefix(upTo: specialToken.index(specialToken.startIndex, offsetBy: i)))' while scanning special token(\(specialToken))"); return false }
				guard c == sp else { setError("unexpected character(\(c)) other than '\(sp)' is detected while scanning special token(\(specialToken))"); return false }
			}
			return true
		}
		
		internal func next() -> TerminalToken? {
			while true {
				if let monitor = activityMonitor, monitor.abortDecoder() {
					setError("operation terminated by user action")
					return nil
				}
				
				guard let c = p21stream.next() else { return nil }
				
				if c == "!" {
					return scanUserDefinedKeyword(c)
				}
				else if c.is(Self.UPPER.union(Self.LOWER)) {
					return scanStandardKeyword_or_tagName(c)
				}
				else if c.is(Self.SIGN.union(Self.DIGIT)) {
					return scanInteger_or_real(c)
				}
				else if c == "'" {
					return scanString(c)
				}
				else if c == "#" {
					return scanInstanceName_or_constantName(c)
				}
				else if c == "@" {
					return scanInstanceName_or_constantName(c)
				}
				else if c == "<" {
					return scanResource(c)
				}
				else if c == "." {
					return scanEnumeration(c)
				}
				else if c == "\"" {
					return scanBinary(c)
				}
				else if c == "$" {
					return .spDOLLER_SIGN
				}
				else if c == "*" {
					return .spASTERISK
				}
				else if c == ";" {
					return .spSEMICOLON
				}
				else if c == ":" {
					return .spCOLON
				}
				else if c == "(" {
					return .spLEFT_PARENTHESIS
				}
				else if c == ")" {
					return .spRIGHT_PARENTHESIS
				}
				else if c == "," {
					return .spCOMMA
				}
				else if c == "{" {
					return .spLEFT_BRACE
				}
				else if c == "}" {
					return .spRIGHT_BRACE
				}
				else if c == "=" {
					return .spEQUAL
				}
				else if c.is(Self.csTokenSeparatorStart) {
					if !self.scanTokenSeparators(c) {
						return nil
					}
				}
				else {
					setError("unexpected character(\(c)) as a head of token")
					return nil
				}
			}
		}
		
		private func scanUserDefinedKeyword(_ firstChar:Character ) -> TerminalToken? {
			guard let c = p21stream.next() else { setError("unexpected end of input stream after '\(firstChar)' while scanning user defined keyword"); return nil }
			guard c.is(Self.UPPER) else { setError("non-capital-letter(\(c)) is detected as the head of user defined keyword"); return nil }
			var keyword = String(c)
			
			while let c = p21stream.next() {
				if !c.is(Self.UPPER.union(Self.DIGIT)) {
					p21stream.pushback(c)
					return .USER_DEFINED_KEYWORD(keyword)
				}
				
				keyword.append(c)
			}
			
			return .USER_DEFINED_KEYWORD(keyword)
		}
		
		private func scanStandardKeyword_or_tagName(_ firstChar:Character ) -> TerminalToken? {
			var isTag = firstChar.is(Self.LOWER)
			var keyword = String(firstChar)
			
			while let c = p21stream.next() {
				if !c.is(Self.UPPER.union(Self.LOWER).union(Self.DIGIT)) {
					p21stream.pushback(c)
					if isTag { return .TAG_NAME(keyword)}
					return .STANDARD_KEYWORD(keyword)
				}
				
				if c.is(Self.LOWER) { isTag = true }
				keyword.append(c)
			}
		
			if isTag { return .TAG_NAME(keyword)}
			return .STANDARD_KEYWORD(keyword)
		}
		
		private func scanInteger_or_real(_ firstChar:Character ) -> TerminalToken? {
			var isValid = firstChar.is(Self.DIGIT)
			var number = String(firstChar)
			
			while let c = p21stream.next() {
				if c.is(Self.DIGIT) {
					isValid = true
					number.append(c)
				}
				else if isValid && c == "." {
					number.append(c)
					return scanReal(following:number)
				}
				else {
					p21stream.pushback(c)
					break
				}
			}
			
			guard isValid, let value = Int(number) else { setError("input stream(\(number)) could not be interpreted as INTEGER"); return nil }
			return .INTEGER(value)
		}
		
		private func scanReal(following number:String ) -> TerminalToken? {
			var number = number
			
			while let c = p21stream.next() {
				if c.is(Self.DIGIT) {
					number.append(c)
				}
				else if c == "E" {
					number.append(c)
					return scanRealExponent(following: number)
				}
				else {
					p21stream.pushback(c)
					break
				}
			}
			
			guard let value = Double(number) else { setError("input steam(\(number)) could not be interpreted as REAL"); return nil }
			return .REAL(value)
		}
		
		private func scanRealExponent(following number:String ) -> TerminalToken? {
			var number = number
			
			guard let c = p21stream.next() else { setError("unexpected end of input stream after '\(number)' while scanning REAL exponent part"); return nil }
			if c.is(Self.SIGN) {
				number.append(c)
			}
			else {
				p21stream.pushback(c)
			}
			
			while let c = p21stream.next() {
				if c.is(Self.DIGIT) {
					number.append(c)
				}
				else {
					p21stream.pushback(c)
					break
				}
			}
			
			guard let value = Double(number) else { setError("input steam(\(number)) could not be interpreted as REAL with exponent part"); return nil }
			return .REAL(value)
		}

		private func scanString(_ firstChar:Character ) -> TerminalToken? {
			var str = ""
			
			while let c = p21stream.next() {
				if c == "'" {
					guard let next = p21stream.next() else { return .STRING(str) }
					if next == "'" {
						str.append(next)
					}
					else {
						p21stream.pushback(next)
						return .STRING(str)
					}
				}
				
				else if c == "\\" {
					guard let controlDir = scanStringControlDirective() else { return nil }
					str.append(controlDir)
				}
				
				else {
					str.append(c)
				}
			}
			setError("unexpected end of input stream after '\(str)' while scanning STRING")
			return nil			
		}

		private func scanStringControlDirective() -> String? {
			guard let c = p21stream.next() else { setError("unexpected end of input stream after '\\' while scanning STRING control directive"); return nil }
			if c == "\\" {
				return "\\"
			}
			
			else if c == "X" {
				guard let c = p21stream.next() else { setError("unexpected end of input stream after '\\X' while scanning STRING control directive"); return nil }
				if c == "\\" {
					guard let hex1 = p21stream.next() else { setError("unexpected end of input stream after '\\X\\' while scanning STRING control directive"); return nil }
					guard hex1.is(Self.HEX) else { setError("non-hex-character(\(hex1)) is detected after '\\X\\' while scanning STRING control directive"); return nil }
					guard let hex2 = p21stream.next() else { setError("unexpected end of input stream after '\\X\\\(hex1)' while scanning STRING control directive"); return nil}
					guard hex2.is(Self.HEX) else { setError("non-hex-character(\(hex2)) is detected after '\\X\\\(hex1)' while scanning STRING control directive"); return nil }
					
					guard let hexval = Int(String([hex1,hex2]), radix: 16) else { setError("input steam(\\X\\\(hex1)\(hex2)) could not be interpreted as 8-bit number as STRING control directive"); return nil }
					guard let unicode = Unicode.Scalar(hexval) else { setError("STRING control directive(\\X\\\(hex1)\(hex2)) could not be interpreted as valid unicode scalar"); return nil }
					return String(Character(unicode))
				}
				else if c == "2" {
					return scanStringControlDirectiveExtended(chunk: 2)
				}
				else if c == "4" {
					return scanStringControlDirectiveExtended(chunk: 4)
				}
				else {
					setError("unexpected character(\(c)) other than '2' or '4' is detected after '\\X' while scanning STRING control directive")
					return nil
				}
			} 
			
			else {
				var str = "\\\(c)"
				while let c = p21stream.next() {
					str.append(c)
					if c == "\\" { return str }
				}
				setError("unexpected end of input stream after '\(str)' while scanning STRING control directive encoding ISO 8859")
				return nil
			}
		}
		
		private func scanStringControlDirectiveExtended(chunk: Int) -> String? {
			var str = ""
			var hexseq: [Character] = []
			for _ in 1 ... chunk {
				guard let hex = p21stream.next() else { setError("unexpected end of input stream after '\\X\(chunk)\\\(String(hexseq))' while scanning STRING control directive"); return nil }
				guard hex.is(Self.HEX) else { setError("non-hex-character(\(hex)) is detected after '\\X\(chunk)\\\(String(hexseq))' while scanning STRING control directive"); return nil }
				hexseq.append(hex)
			}
			guard let hexval = Int(String(hexseq), radix: 16) else { setError("input steam(\(String(hexseq))) could not be interpreted as hex number in STRING control directive '\\X\(chunk)\\'"); return nil }
			guard let unicode = Unicode.Scalar(hexval) else { setError("STRING control directive(\\X\(chunk)\\\(String(hexseq))) could not be interpreted as valid unicode scalar"); return nil }
			str.append(Character(unicode))
			
			while let c = p21stream.next() {
				if c == "\\" {
					var terminator = "\\"
					for _ in 1 ... 3 {
						guard let c = p21stream.next() else { setError("unexpected end of input stream after '\(terminator)' while scanning STRING control directive terminator"); return nil }
						terminator.append(c)
					}
					guard terminator == "\\X0\\" else { setError("unexpected character stream(\(terminator)) is detected as a STRING control directive terminator"); return nil }
					return str
				}
				
				guard c.is(Self.HEX) else { setError("non-hex-character(\(c)) is detected while scanning STRING control directive '\\X\(chunk)\\...'"); return nil }
				var hexseq = [c]
				for _ in 2 ... chunk {
					guard let hex = p21stream.next() else { setError("unexpected end of input stream after '\\X\(chunk)\\...\(String(hexseq))' while scanning STRING control directive"); return nil }
					guard hex.is(Self.HEX) else { setError("non-hex-character(\(hex)) is detected after '\\X\(chunk)\\...\(String(hexseq))' while scanning STRING control directive"); return nil }
					hexseq.append(hex)
				}
				guard let hexval = Int(String(hexseq), radix: 16) else { setError("input steam(\(String(hexseq))) could not be interpreted as hex number in STRING control directive '\\X\(chunk)\\...'"); return nil }
				guard let unicode = Unicode.Scalar(hexval) else { setError("STRING control directive(\\X\(chunk)\\...\(String(hexseq))) could not be interpreted as valid unicode scalar"); return nil }
				str.append(Character(unicode))
			}
			setError("unexpected end of input stream while scanning STRING control directive '\\X\(chunk)\\'")
			return nil
		}
		
		private func scanInstanceName_or_constantName(_ firstChar: Character ) -> TerminalToken? {
			guard let c = p21stream.next() else { setError("unexpected end of input stream after '\(firstChar)' while scanning INSTANCE NAME|CONSTANT NAME"); return nil }
			if c.is(Self.DIGIT) { return scanInstanceName(first: firstChar, second: c) }
			if c.is(Self.UPPER) { return scanConstantName(first: firstChar, second: c) }
			setError("unexpected character(\(c)) other than DIGIT or UPPER is detected after '\(firstChar)' while scanning INSTANCE NAME|CONSTANT NAME")
			return nil
			
		}

		private func scanInstanceName(first:Character, second:Character) -> TerminalToken? {
			var number = String(second)
			
			while let c = p21stream.next() {
				if c.is(Self.DIGIT) {
					number.append(c)
				}
				else {
					p21stream.pushback(c)
					break
				}
			}
			
			guard let value = Int(number) else { setError("input stream(\(first)\(number)) could not be interpreted as valid instance name (i.e., integer)"); return nil }
			
			switch first {
			case "#":
				return .ENTITY_INSTANCE_NAME(value)
			case "@":
				return .VALUE_INSTANCE_NAME(value)
			default:
				setError("internal error: instance name(\(value)) prefixed with invalid char(\(first))")
				return nil
			}
		}		

		private func scanConstantName(first:Character, second:Character) -> TerminalToken? {
			var name = String(second)
			
			while let c = p21stream.next() {
				if c.is(Self.UPPER.union(Self.DIGIT)) {
					name.append(c)
				}
				else {
					p21stream.pushback(c)
					break
				}
			}
			
			switch first {
			case "#":
				return .CONSTANT_ENTITY_NAME(name)
			case "@":
				return .CONSTANT_VALUE_NAME(name)
			default:
				setError("internal error: constant name(\(name)) prefixed with invalid char(\(first))")
				return nil
			}
		}		
		
		private func scanResource(_ firstChar:Character ) -> TerminalToken? {
			var uri = ""
			
			while let c = p21stream.next() {
				if c == ">" {
					return .RESOURCE(uri)
				}
				uri.append(c)
			}
			setError("unexpected end of input stream after '<\(uri)' while scanning RESOURCE"); 
			return nil
		}
		
		private func scanEnumeration(_ firstChar:Character ) -> TerminalToken? {
			guard let c = p21stream.next(), c.is(Self.UPPER) else { setError("non-UPPER character is detected after '\(firstChar)' while scanning ENUMERATION value"); return nil }
			var enumval = String(c)
			
			while let c = p21stream.next() {
				if c == "." {
					return .ENUMERATION(enumval)
				}
				
				else if c.is(Self.UPPER.union(Self.DIGIT)) {
					enumval.append(c)	
				}
				
				else {
					setError("non-UPPER character is detected after '\(firstChar)\(enumval)' while scanning ENUMERATION value")
					return nil
				}
			}			
			setError("unexpected end of input stream after '\(firstChar)\(enumval)' while scanning ENUMERATION value"); 
			return nil
		}
		
		private func scanBinary(_ firstChar:Character ) -> TerminalToken? {
			guard let nchar = p21stream.next() else { setError("unexpected end of input stream after '\(firstChar)' while scanning BINARY"); return nil }
			guard nchar.is(Self.csBinaryHead) else { setError("character(\(nchar)) other than '0'|'1'|'2'|'3' is detected after '\(firstChar)' while scanning BINARY"); return nil }
			guard let ncount = Int(String(nchar)) else { setError("character(\(nchar)) could not be interpreted as an integer while scanning BINARY"); return nil }
			
			guard let c = p21stream.next() else { setError("unexpected end of input stream after '\(firstChar)\(nchar)' while scanning BINARY"); return nil }
			if c == "\"" {
				if ncount == 0 {
					return .BINARY("")
				}
				else {
					setError("unexpected n-value(\(ncount)) other than 0 for empty BINARY encoding")
					return nil
				}
			}
			guard c.is(Self.HEX) else { setError("non-hex character(\(c)) is detected after '\(firstChar)\(nchar)' while scanning BINARY"); return nil }
			guard let hexval = Int(String(c), radix: 16) else { setError("character(\(c)) after '\(firstChar)\(nchar)' could not be interpreted as hex number while scanning BINARY"); return nil }
			var binary = String(hexval, radix: 2)
			binary.removeFirst(ncount)
			
			while let c = p21stream.next() {
				if c == "\"" {
					return .BINARY(binary)
				}
				
				else if c.is(Self.HEX) {
					guard let hexval = Int(String(c), radix: 16) else { setError("character(\(c)) after '\(binary)' could not be interpreted as hex number while scanning BINARY"); return nil }
					binary.append(String(hexval,radix: 2))
				}
				
				else {
					setError("non-hex character(\(c)) is detected after '\(binary)' while scanning BINARY")
					return nil
				}
			}
			setError("unexpected end of input stream after '\(binary)' while scanning BINARY")
			return nil		
		}
		
		private func scanTokenSeparators(_ firstChar:Character ) -> Bool {
			var c = firstChar
			
			while true {
				switch c {
				case " ":
					break
				case "/":
					if !scanComment(c) { return false }
				case "\\":
					if !scanPrintControlDirective(c) { return false }
				default:
					return false
				}
				
				guard let next = p21stream.next() else { return true }
				if !next.is(Self.csTokenSeparatorStart){
					p21stream.pushback(next)
					return true
				}
				c = next
			}			
		}
		
		private func scanComment(_ firstChar:Character ) -> Bool {
			guard let aster = p21stream.next() else { setError("unexpected end of input stream after '/' while scanning comment"); return false }
			guard aster == "*" else { setError("unexpected character(\(aster)) other than '*' is detected while scanning comment"); return false }
			
			while let c = p21stream.next() {
				if c == "*" {
					while true {
						guard let solidus = p21stream.next() else { setError("unexpected end of input stream after '*' while scanning comment"); return false }
						if solidus == "/" { return true }
						if solidus != "*" { break }
					}
				}
			}
			return false
		}
		
		private func scanPrintControlDirective(_ firstChar:Character ) -> Bool {
			guard let code = p21stream.next() else { setError("unexpected end of input stream after '\\' while scanning print control directive"); return false }
			guard let revSolidus = p21stream.next() else { setError("unexpected end of input stream after '\\\(code)' while scanning print control directive"); return false }
			guard code.is(Self.csPrintControlDirectiveCode), revSolidus == "\\" else { setError("unexpected input stream(\\\(code)\(revSolidus)) is detected as print control directive (\\N\\ | \\F\\)"); return false }
			return true
		}
		
		
		
	}
}
