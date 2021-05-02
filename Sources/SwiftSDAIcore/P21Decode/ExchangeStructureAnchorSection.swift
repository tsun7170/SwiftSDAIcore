//
//  File.swift
//  
//
//  Created by Yoshida on 2021/05/01.
//

import Foundation

extension P21Decode.ExchangeStructure {
	
	public struct AnchorSection {
		public private(set) var externalItems: [URIFragmentIdentifier:AnchorRecord] = [:]
		
		public mutating func register(name: URIFragmentIdentifier, item: AnchorItem, tag: AnchorTag?) {
			let record = AnchorRecord(item: item, tag: tag)
			externalItems[name] = record
		}
	}
	
}

extension P21Decode.ExchangeStructure.AnchorSection {
	public typealias AnchorItem = P21Decode.ExchangeStructure.AnchorItem
	public typealias AnchorTag = P21Decode.ExchangeStructure.AnchorTag
	
	
	public class AnchorRecord {
		public var anchorItem: AnchorItem	
		public var anchorTag: AnchorTag?
		
		public init(item: AnchorItem, tag: AnchorTag?) {
			self.anchorItem = item
			self.anchorTag = tag
		}
	}
	
	
	
}
