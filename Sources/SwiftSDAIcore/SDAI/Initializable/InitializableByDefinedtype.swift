//
//  InitializableByDefinedtype.swift
//  
//
//  Created by Yoshida on 2020/12/17.
//

import Foundation

//MARK: - from defined type scalar
public protocol InitializableByDefinedtype
{
	init?<T: SDAIUnderlyingType>(possiblyFrom underlyingType: T?)
}
public extension InitializableByDefinedtype
{
	init?<T: SDAIUnderlyingType>(_ underlyingType: T?) {
		self.init(possiblyFrom: underlyingType)
	}	
}


//MARK: - from defined type list literal (with optional bounds)
public protocol InitializableByDefinedtypeListLiteral
{
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E: SDAIUnderlyingType>(bound1: I1, bound2: I2?, _ elements: [SDAI.AggregationInitializerElement<E>]) 
}
public extension InitializableByDefinedtypeListLiteral
{
	init?<E: SDAIUnderlyingType>(_ elements: [SDAI.AggregationInitializerElement<E>]) {
		self.init(bound1: 0, bound2: nil as Int?, elements)
	}
}

//MARK: - from defined type array literal (with required bounds)
public protocol InitializableByDefinedtypeArrayLiteral
{
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E: SDAIUnderlyingType>(bound1: I1, bound2: I2, _ elements: [SDAI.AggregationInitializerElement<E>]) 	
}



//MARK: - from defined type list
public protocol InitializableByDefinedtypeList
{
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__LIST__type>(bound1: I1, bound2: I2?, _ listtype: T?) 
	where T.ELEMENT: SDAIUnderlyingType
}

public extension InitializableByDefinedtypeList
{
	init?<T: SDAI__LIST__type>(_ listtype: T?) 
	where T.ELEMENT: SDAIUnderlyingType
	{
		guard let listtype = listtype else {  return nil }
		self.init(bound1: listtype.loBound, bound2: listtype.hiBound, listtype)
	}
}


//MARK: - from defined type bag
public protocol InitializableByDefinedtypeBag
{
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__BAG__type>(bound1: I1, bound2: I2?, _ bagtype: T?) 
	where T.ELEMENT: SDAIUnderlyingType
}

public extension InitializableByDefinedtypeBag
{
	init?<T: SDAI__BAG__type>(_ bagtype: T?) 
	where T.ELEMENT: SDAIUnderlyingType
	{
		guard let bagtype = bagtype else { return nil }
		self.init(bound1: bagtype.loBound, bound2: bagtype.hiBound, bagtype)
	}
}


//MARK: - from defined type set
public protocol InitializableByDefinedtypeSet
{
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__SET__type>(bound1: I1, bound2: I2?, _ settype: T?) 
	where T.ELEMENT: SDAIUnderlyingType
}
public extension InitializableByDefinedtypeSet
{
	init?<T: SDAI__SET__type>(_ settype: T?) 
	where T.ELEMENT: SDAIUnderlyingType
	{
		guard let settype = settype else { return nil }
		self.init(bound1: settype.loBound, bound2: settype.hiBound, settype)
	}
}

//MARK: - from defined type array optional
public protocol InitializableByDefinedtypeArrayOptional
{
	init?<T: SDAI__ARRAY_OPTIONAL__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAIUnderlyingType
}
public extension InitializableByDefinedtypeArrayOptional
{
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__ARRAY_OPTIONAL__type>(bound1: I1, bound2: I2, _ arraytype: T?) 
	where T.ELEMENT: SDAIUnderlyingType
	{
		guard let arraytype = arraytype, 
					bound1.asSwiftInt == arraytype.loIndex, 
					bound2.asSwiftInt == arraytype.hiIndex 
		else { return nil }
		self.init(arraytype)
	}
}


//MARK: - from defined type array
public protocol InitializableByDefinedtypeArray
{
	init?<T: SDAI__ARRAY__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAIUnderlyingType
}
public extension InitializableByDefinedtypeArray
{
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__ARRAY__type>(bound1: I1, bound2: I2, _ arraytype: T?) 
	where T.ELEMENT: SDAIUnderlyingType
	{
		guard let arraytype = arraytype, 
					bound1.asSwiftInt == arraytype.loIndex, 
					bound2.asSwiftInt == arraytype.hiIndex 
		else { return nil }
		self.init(arraytype)
	}
}
