//
//  SdaiLogicalSubtype.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - LOGICAL subtype (8.1.4, 8.3.2)
extension SDAI {
  public protocol LOGICAL__Subtype: SDAI.LOGICAL__TypeBehavior, SDAI.DefinedType
  where Supertype: SDAI.LOGICAL__TypeBehavior
  {}
}

public extension SDAI.LOGICAL__Subtype
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

	// SDAI.SimpleType \SDAI__LOGICAL__type\SDAI__LOGICAL__subtype
	init(from swiftValue: SwiftType) {
		self.init(fundamental: FundamentalType(from: swiftValue))
	}
}
