//
//  SdaiStringSubtype.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - STRING subtype (8.1.6, 8.3.2)
extension SDAI.TypeHierarchy {
  public protocol STRING__Subtype: SDAI.TypeHierarchy.STRING__TypeBehavior, SDAI.DefinedType
  where Supertype: SDAI.TypeHierarchy.STRING__TypeBehavior
  {}
}

public extension SDAI.TypeHierarchy.STRING__Subtype
{
	//MARK: InitializableByGenerictype
//	init?<G: SDAI.GenericType>(fromGeneric generic: G?) {
//		guard let fundamental = FundamentalType.convert(fromGeneric: generic) else { return nil }
//		self.init(fundamental: fundamental)
//	}

  //MARK: InitializableByVoid
  init() {
    let fundamental = FundamentalType()
    self.init(fundamental: fundamental)
  }


	//MARK: SDAI__STRING__type \SDAI__STRING__subtype
  init<I: SDAI.SwiftIntConvertible>(
    width:I?, fixed:Bool, fundamental:FundamentalType)
  {
    let fund = FundamentalType(width: width, fixed: fixed, fundamental: fundamental)
    self.init(fundamental: fund)
  }

  init<I: SDAI.SwiftIntConvertible>(
    width:I?, fixed:Bool, _ string: String)
  {
    let fundamental = FundamentalType(width: width, fixed: fixed, string)
    self.init(fundamental: fundamental)
  }
  var width: SDAIDictionarySchema.Bound? { return rep.width }
  var fixedWidth: SDAI.BOOLEAN { return rep.fixedWidth }
	var length: Int { return rep.length }
	subscript(index: Int?) -> SDAI.STRING? { return rep[index] }
	subscript(range: ClosedRange<Int>?) -> SDAI.STRING? { return rep[range] }
	func ISLIKE(PATTERN substring: String? ) -> SDAI.LOGICAL { rep.ISLIKE(PATTERN: substring) }
}
