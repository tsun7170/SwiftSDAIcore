//
//  File.swift
//  
//
//  Created by Yoshida on 2021/04/19.
//

import Foundation

extension P21Decode {
	
	internal class P21CharacterStream: IteratorProtocol 
	{
		internal typealias Element = Character
		
		internal let basicAlphabet = 
			CharacterSet(charactersIn: Unicode.Scalar(0x0020) ... Unicode.Scalar(0x007E)).union( 
			CharacterSet(charactersIn: Unicode.Scalar(0x0080) ... Unicode.Scalar(0x10FFFF)!) )
		
		private var charStream: AnyIterator<Character>
		
		internal private(set) var lineNumber: Int = 1
		
		internal init<CHARSTREAM>(charStream: CHARSTREAM) 
		where CHARSTREAM: IteratorProtocol, CHARSTREAM.Element == Character
		{
			self.charStream = AnyIterator(charStream)
		}
		
		internal func next() -> Character? {
			if let c = pushbacked.popLast() { return c }
			
			while true {
				guard let c = charStream.next() else { return nil }
				if c.is(basicAlphabet) { return c }
				if c.is(.newlines) {
					lineNumber += 1
				}
			}
		}
		
		private var pushbacked: [Character] = []
		
		internal func pushback(_ c:Character) {
			pushbacked.append(c)
		}
	}
}
