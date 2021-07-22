//
//  ActivityMonitor.swift
//  
//
//  Created by Yoshida on 2021/05/22.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension P21Decode {
	open class ActivityMonitor {
		public init() {}
		
		// monitor action
		open func abortDecoder() -> Bool { return false }

		// error detections
		open func tokenStreamDidSet(error p21Error: P21Error) {
		}
		
		open func parserDidSet(error p21Error: P21Error) {
		}
		
		open func exchangeStructureDidSet(error exError: String) {
		}
		
		open func decoderDidSet(error decoderError: Decoder.Error) {
		}
		
		// progress monitor
		open func scannerDidDetectNewLine(lineNumber: Int) {
		}
		
		open func decoderResolved(entiyInstanceName: ExchangeStructure.EntityInstanceName) {
		}
		
		// phase change monitor
		open func startedParsingHeaderSection() {
		}
		
		open func startedParsingAnchorSection() {
		}
		
		open func startedParsingReferenceSection() {
		}
		
		open func startedParsingDataSection() {
		}
		
		open func completedParsing() {
		}
		
		open func startedResolvingEntityInstances() {
		}
		
		open func completedResolving() {
		}
	}
}
