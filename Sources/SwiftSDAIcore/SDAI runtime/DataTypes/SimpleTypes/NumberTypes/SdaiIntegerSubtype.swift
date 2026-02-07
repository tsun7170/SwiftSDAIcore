//
//  SdaiIntegerSubtype.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - INTEGER subtype (8.1.3, 8.3.2)
extension SDAI.TypeHierarchy {
  public protocol INTEGER__Subtype: SDAI.TypeHierarchy.INTEGER__TypeBehavior, SDAI.DefinedType
  where Supertype: SDAI.TypeHierarchy.INTEGER__TypeBehavior
  {}
}

public extension SDAI.TypeHierarchy.INTEGER__Subtype
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

	//MARK: SDAI.SimpleType \SDAI__NUMBER__type\SDAI__REAL__type\SDAI__INTEGER__type
	init(from swiftValue: SwiftType) {
		self.init(fundamental: FundamentalType(from: swiftValue))
	}
}	
	
