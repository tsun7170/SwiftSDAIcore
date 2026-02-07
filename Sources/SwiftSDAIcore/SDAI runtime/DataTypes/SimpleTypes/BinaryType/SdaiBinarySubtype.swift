//
//  SdaiBinarySubtype.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - BINARY subtype (8.1.7, 8.3.2)
extension SDAI.TypeHierarchy {
  public protocol BINARY__Subtype: SDAI.TypeHierarchy.BINARY__TypeBehavior, SDAI.DefinedType
  where Supertype: SDAI.TypeHierarchy.BINARY__TypeBehavior
  {}
}

public extension SDAI.TypeHierarchy.BINARY__Subtype
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

  //MARK: SDAI.SimpleType \SDAI__BINARY__type\SDAI__BINARY__subtype
	init(from swiftValue: SwiftType) {
		self.init(fundamental: FundamentalType(from: swiftValue))
	}
	
	//MARK: ExpressibleByStringLiteral \SDAI__BINARY__type\SDAI__BINARY__subtype
	init(stringLiteral value: StringLiteralType) {
		self.init(FundamentalType(stringLiteral: value))
	}

	//MARK: SDAI__BINARY__type
  init<I: SDAI.SwiftIntConvertible>(
    width:I?, fixed:Bool, fundamental:FundamentalType)
  {
    let fund = FundamentalType(width: width, fixed: fixed, fundamental: fundamental)
    self.init(fundamental: fund)
  }

  init<I: SDAI.SwiftIntConvertible>(
    width:I?, fixed:Bool, _ value:String)
  {
    let fund = FundamentalType(width: width, fixed: fixed, value)
    self.init(fundamental: fund)
  }

  var width: SDAIDictionarySchema.Bound? { return rep.width }
  var fixedWidth: SDAI.BOOLEAN { return rep.fixedWidth }
	var blength: Int { return rep.blength }
	subscript(index: Int?) -> SDAI.BINARY? { return rep[index] }
	subscript(range: ClosedRange<Int>?) -> SDAI.BINARY? { return rep[range] }
}
