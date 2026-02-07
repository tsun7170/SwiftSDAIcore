//
//  SdaiRealSubtype.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation


//MARK: - REAL subtype (8.1.2, 8.3.2)
extension SDAI.TypeHierarchy {
  public protocol REAL__Subtype: SDAI.TypeHierarchy.REAL__TypeBehavior, SDAI.DefinedType
  where Supertype: SDAI.TypeHierarchy.REAL__TypeBehavior
  {}
}

public extension SDAI.TypeHierarchy.REAL__Subtype
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

	//MARK: SDAI.SimpleType \SDAI__NUMBER__type\SDAI__REAL__type\SDAI__REAL__subtype
	init(from swiftValue: SwiftType) {
		self.init(fundamental: FundamentalType(from: swiftValue))
	}
	
	//MARK: SDAI__REAL__type
	static var precision: SDAIDictionarySchema.Bound { Supertype.precision }
}

