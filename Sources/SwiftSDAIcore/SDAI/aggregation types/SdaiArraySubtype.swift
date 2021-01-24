//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation

//MARK: - ARRAY subtype
public protocol SDAI__ARRAY__subtype: SDAI__ARRAY__type, SDAIDefinedType
where Supertype: SDAI__ARRAY__type
{}
public extension SDAI__ARRAY__subtype
{
	// InitializableBySelecttype
	init?<S: SDAISelectType>(possiblyFrom select: S?) {
		guard let fundamental = FundamentalType(possiblyFrom: select) else { return nil }
		self.init(fundamental: fundamental)
	}
	
	// InitializableBySwifttypeAsArray
	init<I1: SwiftIntConvertible, I2: SwiftIntConvertible>(from swiftValue: SwiftType, bound1: I1, bound2: I2) {
		self.init(fundamental: FundamentalType(from: swiftValue, bound1: bound1, bound2: bound2) )
	} 
}


//MARK: - for select type element
public extension SDAI__ARRAY__subtype
where ELEMENT: InitializableBySelecttype
{
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E: SDAISelectType>(bound1: I1, bound2: I2, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, elements) )
	}

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
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E: SDAI.EntityReference>(bound1: I1, bound2: I2, _ elements: [SDAI.AggregationInitializerElement<E>]) {
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, elements) )
	}

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
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E: SDAIUnderlyingType>(bound1: I1, bound2: I2, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, elements) )
	}

	init?<T:SDAI__ARRAY__type>(_ arraytype: T?) 
	where T.ELEMENT: SDAIUnderlyingType
	{
		self.init(fundamental: FundamentalType(arraytype) )
	}
}


//MARK: - for swift type array literal
public extension SDAI__ARRAY__subtype
where ELEMENT: InitializableBySwifttype
{
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E>(bound1: I1, bound2: I2, _ elements: [SDAI.AggregationInitializerElement<E>]) 
	where E == ELEMENT.SwiftType
	{
		self.init(fundamental: FundamentalType(bound1:bound1, bound2:bound2, elements) )
	}
}
