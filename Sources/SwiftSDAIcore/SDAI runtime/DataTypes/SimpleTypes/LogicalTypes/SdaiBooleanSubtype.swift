//
//  SdaiBooleanSubtype.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - BOOLEAN subtype (8.1.5, 8.3.2)
extension SDAI {
  public protocol BOOLEAN__Subtype: SDAI.BOOLEAN__TypeBehavior, SDAI.DefinedType
  where Supertype: SDAI.BOOLEAN__TypeBehavior
  {}
}

public extension SDAI.BOOLEAN__Subtype
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

	// SDAI.SimpleType \SDAI__LOGICAL__type\SDAI__BOOLEAN__type\SDAI__BOOLEAN__subtype
	init(from swiftValue: SwiftType) {
		self.init(fundamental: FundamentalType(from: swiftValue))
	}
}
