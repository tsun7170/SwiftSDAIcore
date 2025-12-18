//
//  AnchorSection.swift
//  
//
//  Created by Yoshida on 2021/05/01.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension P21Decode.ExchangeStructure {
	
	/// ISO 10303-21 9 Anchor section
	public struct AnchorSection: Sendable {
		nonisolated(unsafe)
		public private(set) var externalItems: [URIFragmentIdentifier:AnchorRecord] = [:]
		
		public mutating func register(name: URIFragmentIdentifier, item: AnchorItem, tag: AnchorTag?) {
			let record = AnchorRecord(name: name, item: item, tag: tag)
			externalItems[name] = record
		}
	}
	
}

extension P21Decode.ExchangeStructure.AnchorSection {
	public typealias AnchorItem = P21Decode.ExchangeStructure.AnchorItem
	public typealias AnchorTag = P21Decode.ExchangeStructure.AnchorTag
	public typealias URIFragmentIdentifier = P21Decode.ExchangeStructure.URIFragmentIdentifier
	
	
	public final class AnchorRecord {
		public let anchorName: URIFragmentIdentifier
		public let anchorItem: AnchorItem	
		public let anchorTag: AnchorTag?
		
		public init(name: URIFragmentIdentifier, item: AnchorItem, tag: AnchorTag?) {
			self.anchorName = name
			self.anchorItem = item
			self.anchorTag = tag
		}
	}
	
	
	
}
