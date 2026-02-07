//
//  SdaiBooleanSubtype.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - BOOLEAN subtype (8.1.5, 8.3.2)
extension SDAI.TypeHierarchy {
  public protocol BOOLEAN__Subtype: SDAI.TypeHierarchy.BOOLEAN__TypeBehavior, SDAI.DefinedType
  where Supertype: SDAI.TypeHierarchy.BOOLEAN__TypeBehavior
  {}
}

public extension SDAI.TypeHierarchy.BOOLEAN__Subtype
{
	//MARK: InitializableByGenerictype
	init?<G: SDAI.GenericType>(fromGeneric generic: G?) {
		guard let fundamental = FundamentalType.convert(fromGeneric: generic) else { return nil }
		self.init(fundamental: fundamental)
	}

  //MARK: InitializableByVoid
  init() {
    let fundamental = FundamentalType()
    self.init(fundamental: fundamental)
  }

	//MARK: SDAI.SimpleType \SDAI__LOGICAL__type\SDAI__BOOLEAN__type\SDAI__BOOLEAN__subtype
	init(from swiftValue: SwiftType) {
		self.init(fundamental: FundamentalType(from: swiftValue))
	}
}
