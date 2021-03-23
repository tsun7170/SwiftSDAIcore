//
//  File.swift
//  
//
//  Created by Yoshida on 2021/01/21.
//

import Foundation

//MARK: Membership operator (12.2.3)

extension SDAI {
	public static func aggregate<AGG:SDAIAggregationType, ELEM:SDAIGenericType>(_ agg:AGG?, contains elem:ELEM?) -> SDAI.LOGICAL where AGG.ELEMENT: SDAIGenericType
	{
		guard let agg = agg, let elem = elem else { return SDAI.UNKNOWN }
		guard let aggelem = AGG.ELEMENT(fromGeneric: elem) else { return SDAI.FALSE }
		return agg.CONTAINS(elem: aggelem)
	}
	
	public static func aggregate<AGG:SDAIAggregationInitializer, ELEM:SDAIGenericType>(_ agg:AGG?, contains elem:ELEM?) -> SDAI.LOGICAL 
	{
		guard let agg = agg, let elem = elem else { return SDAI.UNKNOWN }
		guard let aggelem = AGG.ELEMENT(fromGeneric: elem) else { return SDAI.FALSE }
		return agg.CONTAINS(elem: aggelem)
	}
	

}

