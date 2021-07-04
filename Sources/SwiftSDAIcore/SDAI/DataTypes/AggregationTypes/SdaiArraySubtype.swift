//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation

//MARK: - ARRAY subtype (8.2.1, 8.3.2)
public protocol SDAI__ARRAY__subtype: SDAI__ARRAY__type, SDAIDefinedType
where Supertype: SDAI__ARRAY__type
{}
public extension SDAI__ARRAY__subtype
{
	// InitializableByGenerictype
	init?<G: SDAIGenericType>(fromGeneric generic: G?) {
		guard let fundamental = FundamentalType.convert(fromGeneric: generic) else { return nil }
		self.init(fundamental: fundamental)
	}
	
	// InitializableByGenericArray
	init?<T: SDAI__ARRAY__type>(generic arraytype: T?) {
		self.init(fundamental: FundamentalType(generic: arraytype))
	}

	
	// InitializableBySwifttypeAsArray
	init<I1: SwiftIntConvertible, I2: SwiftIntConvertible>(from swiftValue: SwiftType, bound1: I1, bound2: I2) {
		self.init(fundamental: FundamentalType(from: swiftValue, bound1: bound1, bound2: bound2) )
	} 
	
	// InitializableByArrayLiteral
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E: SDAIGenericType>(bound1: I1, bound2: I2, _ elements: [SDAI.AggregationInitializerElement<E>]) {
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, elements) )
	} 

}


//MARK: - for select type element
public extension SDAI__ARRAY__subtype
where ELEMENT: InitializableBySelecttype
{
	init?<T:SDAI__ARRAY__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAISelectType
	{
		self.init(fundamental: FundamentalType(arraytype) )
	}
}



//MARK: - for entity type element
public extension SDAI__ARRAY__subtype
where ELEMENT: InitializableByEntity
{
	init?<T: SDAI__ARRAY__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAI.EntityReference
	{
		self.init(fundamental: FundamentalType(arraytype) )
	}
}


//MARK: - for defined type element
public extension SDAI__ARRAY__subtype
where ELEMENT: InitializableByDefinedtype
{
	init?<T:SDAI__ARRAY__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAIUnderlyingType
	{
		self.init(fundamental: FundamentalType(arraytype) )
	}
}


