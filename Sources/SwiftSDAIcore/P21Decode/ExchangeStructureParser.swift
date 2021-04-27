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
		
		public init<CHARSTREAM>(charStream: CHARSTREAM) 
		where CHARSTREAM: IteratorProtocol, CHARSTREAM.Element == Character
		{
			let p21charStream = P21CharacterStream(charStream: charStream)
			self.tokenStream = TokenStream(p21stream: p21charStream)
		}
		
		public func parseExchangeStructure() {
			guard tokenStream.confirm(specialToken: "ISO-10303-21;") else {
				print(tokenStream.error ?? "no error")
				return
			}
			
			var lastToken: TerminalToken?
			while let token = tokenStream.next() {
				lastToken = token
			}
			
			print(tokenStream.error ?? "no error")
			print("last token:",lastToken)

			
		}
	}
	
}

