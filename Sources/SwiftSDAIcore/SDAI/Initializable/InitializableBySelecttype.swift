//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/18.
//

import Foundation

//MARK: - from select type scalar
public protocol InitializableBySelecttype
{
	init?<S: SDAISelectType>(possiblyFrom select: S?)
}
public extension InitializableBySelecttype
{
	init?<S: SDAISelectType>(_ select: S?) {
		self.init(possiblyFrom: select)
	}
}
public extension InitializableBySelecttype
where Self: InitializableByGenerictype
{
	init?<S: SDAISelectType>(possiblyFrom select: S?) {
		self.init(fromGeneric: select)
	}
}

//MARK: - from select type as list (with optional bounds)
public protocol InitializableBySelecttypeAsList
{
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, S: SDAISelectType>(bound1: I1, bound2: I2?, _ select: S?)	
}

//MARK: - from select type as array (with required bounds)
public protocol InitializableBySelecttypeAsArray
{
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, S: SDAISelectType>(bound1: I1, bound2: I2, _ select: S?)	
}




////MARK: - from select type list literal (with optional bounds)
//public protocol InitializableBySelecttypeListLiteral
//{
//	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E: SDAISelectType>(bound1: I1, bound2: I2?, _ elements: [SDAI.AggregationInitializerElement<E>]) 
//}
//public extension InitializableBySelecttypeListLiteral
//{
//	init?<E: SDAISelectType>(_ elements: [SDAI.AggregationInitializerElement<E>]) {
//		self.init(bound1: 0, bound2: nil as Int?, elements)
//	}
//}
//
////MARK: - from select type list literal (with required bounds)
//public protocol InitializableBySelecttypeArrayLiteral
//{
//	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E: SDAISelectType>(bound1: I1, bound2: I2, _ elements: [SDAI.AggregationInitializerElement<E>]) 
//}




//MARK: - from select type list
public protocol InitializableBySelecttypeList
{
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__LIST__type>(bound1: I1, bound2: I2?, _ listtype: T?) 
	where T.ELEMENT: SDAISelectType
}
public extension InitializableBySelecttypeList
{
	init?<T: SDAI__LIST__type>(_ listtype: T?) 
	where T.ELEMENT: SDAISelectType
	{
		guard let listtype = listtype else { return nil }
		self.init(bound1: listtype.loBound, bound2: listtype.hiBound, listtype)
	}
}



//MARK: - from select type bag
public protocol InitializableBySelecttypeBag
{
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__BAG__type>(bound1: I1, bound2: I2?, _ bagtype: T?) 
	where T.ELEMENT: SDAISelectType
}
public extension InitializableBySelecttypeBag
{
	init?<T: SDAI__BAG__type>(_ bagtype: T?) 
	where T.ELEMENT: SDAISelectType
	{
		guard let bagtype = bagtype else { return nil }
		self.init(bound1: bagtype.loBound, bound2: bagtype.hiBound, bagtype)
	}
}



//MARK: - from select type set
public protocol InitializableBySelecttypeSet
{	
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__SET__type>(bound1: I1, bound2: I2?, _ settype: T?) 
	where T.ELEMENT: SDAISelectType
}
public extension InitializableBySelecttypeSet
{
	init?<T: SDAI__SET__type>(_ settype: T?) 
	where T.ELEMENT: SDAISelectType
	{
		guard let settype = settype else { return nil }
		self.init(bound1: settype.loBound, bound2: settype.hiBound, settype)
	}
}

//MARK: - from select type array optional
public protocol InitializableBySelecttypeArrayOptional
{
	init?<T: SDAI__ARRAY_OPTIONAL__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAISelectType
}
public extension InitializableBySelecttypeArrayOptional
{
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__ARRAY_OPTIONAL__type>(bound1: I1, bound2: I2, _ arraytype: T?) 
	where T.ELEMENT: SDAISelectType
	{
		guard let arraytype = arraytype, 
					bound1.possiblyAsSwiftInt == arraytype.loIndex, 
					bound2.possiblyAsSwiftInt == arraytype.hiIndex 
		else { return nil }
		self.init(arraytype)
	}
}


//MARK: - from select type array
public protocol InitializableBySelecttypeArray
{
	init?<T: SDAI__ARRAY__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAISelectType
}
public extension InitializableBySelecttypeArray
{
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__ARRAY__type>(bound1: I1, bound2: I2, _ arraytype: T?) 
	where T.ELEMENT: SDAISelectType
	{
		guard let arraytype = arraytype, 
					bound1.possiblyAsSwiftInt == arraytype.loIndex, 
					bound2.possiblyAsSwiftInt == arraytype.hiIndex 
		else { return nil }
		self.init(arraytype)
	}
}
