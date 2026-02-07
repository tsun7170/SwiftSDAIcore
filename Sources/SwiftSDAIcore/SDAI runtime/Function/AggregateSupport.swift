//
//  AggregateSupport.swift
//  
//
//  Created by Yoshida on 2021/01/21.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation


extension SDAI {
  //MARK: Membership operator (12.2.3)

  public static func aggregate<AGG:SDAI.AggregationType, ELEM:SDAI.GenericType>(
    _ agg:AGG?,
    contains elem:ELEM?) -> SDAI.LOGICAL
	{
		guard let agg = agg, let elem = elem else { return SDAI.UNKNOWN }
		guard let aggelem = AGG.ELEMENT.convert(fromGeneric: elem) else { return SDAI.FALSE }
		return agg.CONTAINS(elem: aggelem)
	}
	
	public static func aggregate<AGG:SDAI.AggregationInitializer, ELEM:SDAI.GenericType>(
    _ agg:AGG?,
    contains elem:ELEM?) -> SDAI.LOGICAL
	{
		guard let agg = agg, let elem = elem else { return SDAI.UNKNOWN }
		guard let aggelem = AGG.ELEMENT.convert(fromGeneric: elem) else { return SDAI.FALSE }
		return agg.CONTAINS(elem: aggelem)
	}

  //MARK: validation related
	public static func validateAggregateElementsWhereRules<AGG:SDAI.AggregationType>(
    _ agg:AGG?,
    prefix:SDAIPopulationSchema.WhereLabel
  ) -> SDAIPopulationSchema.WhereRuleValidationRecords
  {
		var result:SDAIPopulationSchema.WhereRuleValidationRecords = [:]
		guard let agg = agg,
          let session = SDAISessionSchema.activeSession
    else { return result }

		if let hibound = agg.hiBound {
			result[prefix + ".hiBound(\(hibound))"] = SDAI.LOGICAL(agg.hiIndex <= hibound)	
		}
		result[prefix + ".loBound(\(agg.loBound))"] = SDAI.LOGICAL(agg.hiIndex >= agg.loBound)

		for idx in stride(from: agg.loIndex, through: agg.hiIndex, by: 1) {
      let elem = agg[idx]
      if let entityRef = elem as? SDAI.EntityReference {
        guard session.validateTemporaryEntities,
              entityRef.isTemporary
        else { continue }
      }
      else if let pref = elem as? SDAI.GenericPersistentEntityReference {
        guard session.validateTemporaryEntities,
              pref.isTemporary
        else { continue }
      }

			let elemResult = AGG.ELEMENT.validateWhereRules(
				instance:elem,
				prefix: prefix + "[\(idx)]\\\(AGG.ELEMENT.typeName)" )

			result.merge(elemResult) { $0 && $1 }
		}
		return result
	}



}

