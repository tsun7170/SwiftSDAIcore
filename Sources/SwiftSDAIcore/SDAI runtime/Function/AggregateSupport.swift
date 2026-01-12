//
//  AggregateSupport.swift
//  
//
//  Created by Yoshida on 2021/01/21.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: Membership operator (12.2.3)

extension SDAI {
	public static func aggregate<AGG:SDAI.AggregationType, ELEM:SDAI.GenericType>(_ agg:AGG?, contains elem:ELEM?) -> SDAI.LOGICAL
	{
		guard let agg = agg, let elem = elem else { return SDAI.UNKNOWN }
		guard let aggelem = AGG.ELEMENT.convert(fromGeneric: elem) else { return SDAI.FALSE }
		return agg.CONTAINS(elem: aggelem)
	}
	
	public static func aggregate<AGG:SDAIAggregationInitializer, ELEM:SDAI.GenericType>(_ agg:AGG?, contains elem:ELEM?) -> SDAI.LOGICAL 
	{
		guard let agg = agg, let elem = elem else { return SDAI.UNKNOWN }
		guard let aggelem = AGG.ELEMENT.convert(fromGeneric: elem) else { return SDAI.FALSE }
		return agg.CONTAINS(elem: aggelem)
	}
	
	public static func validateAggregateElementsWhereRules<AGG:SDAI.AggregationType>(_ agg:AGG?, prefix:SDAI.WhereLabel) -> [SDAI.WhereLabel:SDAI.LOGICAL] {
		var result:[SDAI.WhereLabel:SDAI.LOGICAL] = [:]
		guard let agg = agg else { return result }
		
		if let hibound = agg.hiBound {
			result[prefix + ".hiBound(\(hibound))"] = SDAI.LOGICAL(agg.hiIndex <= hibound)	
		}
		result[prefix + ".loBound(\(agg.loBound))"] = SDAI.LOGICAL(agg.hiIndex >= agg.loBound)
		
		if (AGG.ELEMENT.self as Any) is SDAI.EntityReference { return result }
		
		for idx in stride(from: agg.loIndex, through: agg.hiIndex, by: 1) {
			let elemResult = AGG.ELEMENT.validateWhereRules(
				instance:agg[idx], 
				prefix: prefix + "[\(idx)]\\\(AGG.ELEMENT.typeName)" ) 
			result.merge(elemResult) { $0 && $1 }
		}
		return result
	}
}

