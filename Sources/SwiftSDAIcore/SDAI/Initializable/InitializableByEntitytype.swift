//
//  InitializableByEntitytype.swift
//  
//
//  Created by Yoshida on 2020/12/17.
//

import Foundation

//MARK: - from entity type scalar
public protocol InitializableByEntity
{
	init?(possiblyFrom complex: SDAI.ComplexEntity?)
}

public extension InitializableByEntity
{
	init?(possiblyFrom entityRef: SDAI.EntityReference?) {
		self.init(possiblyFrom: entityRef?.complexEntity)
	}

	static func convert(sibling: SDAI.EntityReference?) -> Self? {
		if let sibling = sibling as? Self {
			return sibling
		}
		else {
			return self.init(possiblyFrom: sibling)
		}
	}
}

public extension InitializableByEntity
where Self: SDAI.EntityReference
{
	init?(possiblyFrom complex: SDAI.ComplexEntity?) {
		self.init(complex: complex)
	}

}




//MARK: - from entity type list
public protocol InitializableByEntityList
{
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__LIST__type>(bound1: I1, bound2: I2?, _ listtype: T?) 
	where T.ELEMENT: SDAI.EntityReference
}
public extension InitializableByEntityList
{
	init?<T: SDAI__LIST__type>(_ listtype: T?) 
	where T.ELEMENT: SDAI.EntityReference
	{
		guard let listtype = listtype else { return nil }
		self.init(bound1: listtype.loBound, bound2: listtype.hiBound, listtype)
	}
}

//MARK: - from entity type bag
public protocol InitializableByEntityBag
{
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__BAG__type>(bound1: I1, bound2: I2?, _ bagtype: T?) 
	where T.ELEMENT: SDAI.EntityReference
}
public extension InitializableByEntityBag
{
	init?<T: SDAI__BAG__type>(_ bagtype: T?) 
	where T.ELEMENT: SDAI.EntityReference
	{
		guard let bagtype = bagtype else { return nil }
		self.init(bound1: bagtype.loBound, bound2: bagtype.hiBound, bagtype)
	}
}

//MARK: - from entity type set
public protocol InitializableByEntitySet
{
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__SET__type>(bound1: I1, bound2: I2?, _ settype: T?) 
	where T.ELEMENT: SDAI.EntityReference
}
public extension InitializableByEntitySet
{
	init?<T: SDAI__SET__type>(_ settype: T?) 
	where T.ELEMENT: SDAI.EntityReference//, T.Element == T.ELEMENT
	{
		guard let settype = settype else { return nil }
		self.init(bound1: settype.loBound, bound2: settype.hiBound, settype)
	}
}


//MARK: - from entity type array optional
public protocol InitializableByEntityArrayOptional
{
	init?<T: SDAI__ARRAY_OPTIONAL__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAI.EntityReference
}
public extension InitializableByEntityArrayOptional
{
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__ARRAY_OPTIONAL__type>(bound1: I1, bound2: I2, _ arraytype: T?) 
	where T.ELEMENT: SDAI.EntityReference
	{
		guard let arraytype = arraytype, 
					bound1.asSwiftInt == arraytype.loIndex, 
					bound2.asSwiftInt == arraytype.hiIndex 
		else { return nil }
		self.init(arraytype)
	}
}


//MARK: - from entity type array
public protocol InitializableByEntityArray
{
	init?<T: SDAI__ARRAY__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAI.EntityReference
}
public extension InitializableByEntityArray
{
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__ARRAY__type>(bound1: I1, bound2: I2, _ arraytype: T?) 
	where T.ELEMENT: SDAI.EntityReference
	{
		guard let arraytype = arraytype, 
					bound1.asSwiftInt == arraytype.loIndex, 
					bound2.asSwiftInt == arraytype.hiIndex 
		else { return nil }
		self.init(arraytype)
	}
}
