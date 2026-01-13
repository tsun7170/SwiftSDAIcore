//
//  P21CharacterStream.swift
//  
//
//  Created by Yoshida on 2021/04/19.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension P21Decode {
  public protocol CharacterStream: IteratorProtocol
  where Self.Element == Character
  {}

  public typealias AnyCharacterStream = AnyIterator<Character>
}

extension String.Iterator : P21Decode.CharacterStream {}

extension AnyIterator: P21Decode.CharacterStream where Element == Character {}



extension P21Decode {
	
	
	/// part21 basic alphabet character stream
	/// 
	/// # Reference
	/// 5.2 Basic alphabet definition;
	/// 5.6 Token separators;
	/// 
	/// ISO 10303-21
	///  
	internal final class P21CharacterStream: IteratorProtocol 
	{
		internal typealias Element = Character
		
		/// ref 5.2 Basic alphabet definition; ISO 10303-21
		internal let basicAlphabet = 
			CharacterSet(charactersIn: Unicode.Scalar(0x0020) ... Unicode.Scalar(0x007E)).union( 
			CharacterSet(charactersIn: Unicode.Scalar(0x0080) ... Unicode.Scalar(0x10FFFF)!) )
		
		private var charStream: AnyIterator<Character>
		private let activityMonitor: ActivityMonitor?
		
		internal private(set) var lineNumber: Int = 1
		
		internal init<CHARSTREAM>(charStream: CHARSTREAM, monitor: ActivityMonitor? = nil) 
		where CHARSTREAM: P21Decode.CharacterStream //IteratorProtocol, CHARSTREAM.Element == Character
		{
			self.charStream = AnyIterator(charStream)
			self.activityMonitor = monitor
		}
		
		internal func next() -> Character? {
			if let c = pushbacked.popLast() { return c }
			
			while true {
				guard let c = charStream.next() else { return nil }
				if c.is(basicAlphabet) { return c }
				if c.is(.newlines) {
					lineNumber += 1
					if let monitor = activityMonitor {
						monitor.scannerDidDetectNewLine(lineNumber: lineNumber)
					}
				}
			}
		}
		
		private var pushbacked: [Character] = []
		
		internal func pushback(_ c:Character) {
			pushbacked.append(c)
		}
	}
}
