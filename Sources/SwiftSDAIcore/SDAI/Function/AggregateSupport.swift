//
//  File.swift
//  
//
//  Created by Yoshida on 2021/01/21.
//

import Foundation

extension SDAI {
	//MARK: AGGREGATE(:CONTAINS)
//	public static func AGGREGATE<AGG:SDAIAggregationType, ELEM>(_ agg:AGG?, CONTAINS elem:ELEM?) -> SDAI.LOGICAL 
//	where ELEM: SDAISelectType,
//				AGG.ELEMENT: InitializableBySelecttype
//	{
//		abstruct()
//	}
//	
//	public static func AGGREGATE<AGG:SDAIAggregationType>(_ agg:AGG?, CONTAINS elem:SDAI.EntityReference?) -> SDAI.LOGICAL 
//	where AGG.ELEMENT: InitializableByEntity
//	{
//		abstruct()
//	}
//	
//	public static func AGGREGATE<AGG:SDAIAggregationType, ELEM>(_ agg:AGG?, CONTAINS elem:ELEM?) -> SDAI.LOGICAL 
//	where ELEM: SDAIUnderlyingType,
//				AGG.ELEMENT: InitializableByDefinedtype
//	{
//		abstruct()
//	}
//	
//	public static func AGGREGATE<AGG:SDAIAggregationType, ELEM>(_ agg:AGG?, CONTAINS elem:ELEM?) -> SDAI.LOGICAL 
//	where ELEM == AGG.ELEMENT.SwiftType,
//				AGG.ELEMENT: InitializableBySwifttype
//	{
//		abstruct()
//	}
	public static func aggregate<AGG:SDAIAggregationType, ELEM:SDAIGenericType>(_ agg:AGG?, contains elem:ELEM?) -> SDAI.LOGICAL 
	{
		abstruct()
	}
	

//	public static func AGGREGATE<AGG:SDAIAggregationInitializer, ELEM>(_ agg:AGG?, CONTAINS elem:ELEM?) -> SDAI.LOGICAL 
//	where ELEM: SDAISelectType,
//				AGG.ELEMENT: InitializableBySelecttype
//	{
//		abstruct()
//	}
//	
//	public static func AGGREGATE<AGG:SDAIAggregationInitializer>(_ agg:AGG?, CONTAINS elem:SDAI.EntityReference?) -> SDAI.LOGICAL 
//	where AGG.ELEMENT: InitializableByEntity
//	{
//		abstruct()
//	}
//	
//	public static func AGGREGATE<AGG:SDAIAggregationInitializer, ELEM>(_ agg:AGG?, CONTAINS elem:ELEM?) -> SDAI.LOGICAL 
//	where ELEM: SDAIUnderlyingType,
//				AGG.ELEMENT: InitializableByDefinedtype
//	{
//		abstruct()
//	}
//	
//	public static func AGGREGATE<AGG:SDAIAggregationInitializer, ELEM>(_ agg:AGG?, CONTAINS elem:ELEM?) -> SDAI.LOGICAL 
//	where ELEM == AGG.ELEMENT.SwiftType,
//				AGG.ELEMENT: InitializableBySwifttype
//	{
//		abstruct()
//	}
//	
//	public static func AGGREGATE<AGG:SDAIAggregationInitializer, ELEM>(_ agg:AGG?, CONTAINS elem:ELEM?) -> SDAI.LOGICAL 
//	where AGG.ELEMENT == ELEM.SwiftType,
//				ELEM: InitializableBySwifttype
//	{
//		abstruct()
//	}
	public static func aggregate<AGG:SDAIAggregationInitializer, ELEM:SDAIGenericType>(_ agg:AGG?, contains elem:ELEM?) -> SDAI.LOGICAL 
	{
		abstruct()
	}
	
	

	

//	public static func AGGREGATE<Element, ELEM>(_ agg:Array<Element>?, CONTAINS elem:ELEM?) -> SDAI.LOGICAL 
//	where Element: SDAI__AIE__type,
//				ELEM == Element.Element.Wrapped
//	{
//		abstruct()
//	}

}

