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
  ///
  /// Represents the Anchor section in an ISO 10303-21 (STEP) file exchange structure.
  /// 
  /// The Anchor section is used to define external references within the STEP file,
  /// associating unique fragment identifiers with anchor records that may include
  /// named items and optional tags. This enables external linking and referencing 
  /// between different resources, enhancing data reusability and interoperability.
  ///
  /// - Note: Conforms to `Sendable` for safe use with Swift concurrency.
  /// - SeeAlso: ISO 10303-21, section 9 (Anchor section).
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
	
	
  /// Represents a record in the Anchor section of an ISO 10303-21 (STEP) file,
  /// associating a unique fragment identifier (anchor name) with an anchor item
  /// and an optional tag. Anchor records define external references, enabling
  /// external linking and referencing between resources for enhanced
  /// interoperability and data integration.
  ///
  /// - Parameters:
  ///   - anchorName: The unique URI fragment identifier for this anchor record.
  ///   - anchorItem: The associated item (named entity or reference) this anchor points to.
  ///   - anchorTag: An optional tag providing additional metadata or context for the anchor.
  ///
  /// - Note: Instances of `AnchorRecord` are owned by the `AnchorSection` and are immutable after initialization.
  /// - SeeAlso: ISO 10303-21, section 9 (Anchor section).
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
