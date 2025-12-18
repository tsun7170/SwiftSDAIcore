//
//  ActivityMonitor.swift
//  
//
//  Created by Yoshida on 2021/05/22.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension P21Decode {
	
	/// plugin object to monitor the decoder actions
	open class ActivityMonitor: @unchecked Sendable {
		public init() {}
		
		//MARK: monitor action
		/// to abort the decoder. decoder calls this method periodically.
		/// - Returns: true if you need to abort the decoder
		open func abortDecoder() -> Bool { return false }

		//MARK: error detections
		/// to notify the scanner detected a token stream error
		/// - Parameter p21Error: p21 stream error info
		open func tokenStreamDidSet(error p21Error: P21Error) {}
		
		/// to notify the parser detected an error
		/// - Parameter p21Error: p21 stream error info
		open func parserDidSet(error p21Error: P21Error) {}		
		
		/// to notify the exchange structure detected an error
		/// - Parameter exError: error info
		open func exchangeStructureDidSet(error exError: String) {}
		
		/// to notify the decoder (and its subsystems) detected an error
		/// - Parameter decoderError: error info
		open func decoderDidSet(error decoderError: Decoder.Error) {}
		
		//MARK: progress monitor
		/// to notify the scanner detected a new line
		/// - Parameter lineNumber: new line number
		open func scannerDidDetectNewLine(lineNumber: Int) {}
		
		/// to notify the decoder resolved an entity instance name
		/// - Parameter entityInstanceName: entity instance name
		open func decoderResolved(entityInstanceName: ExchangeStructure.EntityInstanceName) {}
		
		//MARK: phase change monitor
		/// to notify the decoder started parsing the header section
		open func startedParsingHeaderSection() {}		
		
		/// to notify the decoder started parsing the anchor section
		open func startedParsingAnchorSection() {}		
		
		/// to notify the decoder started parsing the reference section
		open func startedParsingReferenceSection() {}		
		
		/// to notify the decoder started parsing the data section
		open func startedParsingDataSection() {}		
		
		/// to notify the decoder completed parsing the input character stream
		open func completedParsing() {}		
		
		/// to notify the decoder started resolving entity instances
		open func startedResolvingEntityInstances() {}		
		
		/// to notify the decoder completed resolving entity instances
		open func completedResolving() {}
	}
}
