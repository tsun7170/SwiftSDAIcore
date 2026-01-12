//
//  SdaiBinarySubtype.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - BINARY subtype (8.1.7, 8.3.2)
extension SDAI {
  public protocol BINARY__Subtype: SDAI.BINARY__TypeBehavior, SDAI.DefinedType
  where Supertype: SDAI.BINARY__TypeBehavior
  {}
}

public extension SDAI.BINARY__Subtype
{
	// InitializableByGenerictype
	init?<G: SDAI.GenericType>(fromGeneric generic: G?) {
		guard let fundamental = FundamentalType.convert(fromGeneric: generic) else { return nil }
		self.init(fundamental: fundamental)
	}
	
  // InitializableByVoid
  init() {
    let fundamental = FundamentalType()
    self.init(fundamental: fundamental)
  }

  // SDAI.SimpleType \SDAI__BINARY__type\SDAI__BINARY__subtype
	init(from swiftValue: SwiftType) {
		self.init(fundamental: FundamentalType(from: swiftValue))
	}
	
	// ExpressibleByStringLiteral \SDAI__BINARY__type\SDAI__BINARY__subtype
	init(stringLiteral value: StringLiteralType) {
		self.init(FundamentalType(stringLiteral: value))
	}

	// SDAI__BINARY__type
	var blength: Int { return rep.blength }
	subscript(index: Int?) -> SDAI.BINARY? { return rep[index] }
	subscript(range: ClosedRange<Int>?) -> SDAI.BINARY? { return rep[range] }
}
