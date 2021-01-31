//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation


//MARK: - SET subtype
public protocol SDAI__SET__subtype: SDAI__SET__type, SDAIDefinedType
where Supertype: SDAI__SET__type 
{}
public extension SDAI__SET__subtype
{
//	// InitializableBySelecttype
//	init?<S: SDAISelectType>(possiblyFrom select: S?) {
//		guard let fundamental = FundamentalType(possiblyFrom: select) else { return nil }
//		self.init(fundamental: fundamental)
//	}
	// InitializableByGenerictype
	init?<G: SDAIGenericType>(fromGeneric generic: G?) {
		guard let fundamental = Fundamental(fromGeneric: generic) else { return nil }
		self.init(fundamental: fundamental)
	}
	
	// InitializableByEmptyListLiteral
	init<I1: SwiftIntConvertible, I2: SwiftIntConvertible>(bound1: I1, bound2: I2?, _ emptyLiteral: SDAI.EmptyAggregateLiteral = SDAI.EMPLY_AGGREGATE) {
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, emptyLiteral) )
	} 
	
	// InitializableBySwifttypeAsList
	init<I1: SwiftIntConvertible, I2: SwiftIntConvertible>(from swiftValue: SwiftType, bound1: I1, bound2: I2?) {
		self.init(fundamental: FundamentalType(from: swiftValue, bound1: bound1, bound2: bound2) )
	} 

	// InitializableBySelecttypeAsList
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, S: SDAISelectType>(bound1: I1, bound2: I2?, _ select: S?) {
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, select) )
	}

	// InitializableByListLiteral
	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible>(bound1: I1, bound2: I2?, _ elements: [SDAI.AggregationInitializerElement<ELEMENT>]) {
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, elements) )
	} 
}



//MARK: - for select type element
public extension SDAI__SET__subtype
where ELEMENT: InitializableBySelecttype
{
//	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E: SDAISelectType>(bound1: I1, bound2: I2?, _ elements: [SDAI.AggregationInitializerElement<E>]) 
//	{
//		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, elements) )
//	}

	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T:SDAI__SET__type>(bound1: I1, bound2: I2?, _ settype: T?) 
	where T.ELEMENT: SDAISelectType
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, settype) )
	}
}


//MARK: - for entity type element
public extension SDAI__SET__subtype
where ELEMENT: InitializableByEntity
{
//	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E: SDAI.EntityReference>(bound1: I1, bound2: I2?, _ elements: [SDAI.AggregationInitializerElement<E>]) {
//		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, elements) )
//	}

	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T: SDAI__SET__type>(bound1: I1, bound2: I2?, _ settype: T?) 
	where T.ELEMENT: SDAI.EntityReference
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, settype) )
	}	
}


//MARK: - for defined type element
public extension SDAI__SET__subtype
where ELEMENT: InitializableByDefinedtype
{
//	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E:SDAIUnderlyingType>(bound1: I1, bound2: I2?, _ elements: [SDAI.AggregationInitializerElement<E>]) 
//	{
//		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, elements) )
//	}

	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, T:SDAI__SET__type>(bound1: I1, bound2: I2?, _ settype: T?) 
	where T.ELEMENT: SDAIUnderlyingType
	{
		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, settype) )
	}
}


////MARK: - for swift type array literal
//public extension SDAI__SET__subtype
//where ELEMENT: InitializableBySwifttype
//{
//	init?<I1: SwiftIntConvertible, I2: SwiftIntConvertible, E>(bound1: I1, bound2: I2?, _ elements: [SDAI.AggregationInitializerElement<E>]) 
//	where E == ELEMENT.SwiftType
//	{
//		self.init(fundamental: FundamentalType(bound1: bound1, bound2: bound2, elements) )
//	}
//}
//

