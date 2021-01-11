//
//  File.swift
//  
//
//  Created by Yoshida on 2020/12/19.
//

import Foundation

extension SDAI {
	//MARK: - support functions
	public static func UNWRAP<T>(_ val:T?) -> T { return val! }
	public static func UNWRAP<T>(_ val:T) -> T { return val }
	
	public static func FORCE_OPTIONAL<T>(_ val:T?) -> T? { return val }
	public static func FORCE_OPTIONAL<T>(_ val:T) -> T? { return val }
	
	public static func IS_TRUE<T: SDAILogicalType>(_ logical: T?) -> Bool { logical?.isTRUE ?? false }
	
	//MARK: AGGREGATE(:CONTAINS)
	public static func AGGREGATE<AGG:SDAIAggregationType, ELEM>(_ agg:AGG?, CONTAINS elem:ELEM?) -> SDAI.LOGICAL 
	where ELEM: SDAISelectType,
				AGG.ELEMENT: InitializableBySelecttype
	{
		abstruct()
	}
	
	public static func AGGREGATE<AGG:SDAIAggregationType>(_ agg:AGG?, CONTAINS elem:SDAI.EntityReference?) -> SDAI.LOGICAL 
	where AGG.ELEMENT: InitializableByEntity
	{
		abstruct()
	}
	
	public static func AGGREGATE<AGG:SDAIAggregationType, ELEM>(_ agg:AGG?, CONTAINS elem:ELEM?) -> SDAI.LOGICAL 
	where ELEM: SDAIUnderlyingType,
				AGG.ELEMENT: InitializableByDefinedtype
	{
		abstruct()
	}
	
	public static func AGGREGATE<AGG:SDAIAggregationType, ELEM>(_ agg:AGG?, CONTAINS elem:ELEM?) -> SDAI.LOGICAL 
	where ELEM == AGG.ELEMENT.SwiftType,
				AGG.ELEMENT: InitializableBySwifttype
	{
		abstruct()
	}
	
	public static func AGGREGATE<Element, ELEM>(_ agg:Array<Element>?, CONTAINS elem:ELEM?) -> SDAI.LOGICAL 
	where Element: SDAI__AIE__type,
				ELEM == Element.Element.Wrapped
	{
		abstruct()
	}

}

