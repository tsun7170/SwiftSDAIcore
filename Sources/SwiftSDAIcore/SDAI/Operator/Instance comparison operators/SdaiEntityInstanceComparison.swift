//
//  File.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//

import Foundation

//MARK: - Entity instance comparison (12.2.2.2)

//MARK: entity ref vs. entity ref
public func .===. (lhs: SDAI.EntityReference?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL { 
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	let result = lhs.complexEntity === rhs.complexEntity
	return SDAI.LOGICAL( result )
}
public func .!==. (lhs: SDAI.EntityReference?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL { !(lhs .===. rhs) }


//MARK: entity ref vs. select
public func .===. <U: SDAISelectType>(lhs: SDAI.EntityReference?, rhs: U?) -> SDAI.LOGICAL { 
	return lhs .===. rhs?.entityReference
}
public func .!==. <U: SDAISelectType>(lhs: SDAI.EntityReference?, rhs: U?) -> SDAI.LOGICAL { !(lhs .===. rhs) }


//MARK: select vs. entity ref
public func .===. <T: SDAISelectType>(lhs: T?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL { rhs .===. lhs }
public func .!==. <T: SDAISelectType>(lhs: T?, rhs: SDAI.EntityReference?) -> SDAI.LOGICAL { !(lhs .===. rhs) }



//MARK: partial vs. partial
public func .===. (lhs: SDAI.PartialEntity?, rhs: SDAI.PartialEntity?) -> SDAI.LOGICAL { 
	guard let lhs = lhs, let rhs = rhs else { return SDAI.UNKNOWN }
	return SDAI.LOGICAL( lhs === rhs ) 	
}
public func .!==. (lhs: SDAI.PartialEntity?, rhs: SDAI.PartialEntity?) -> SDAI.LOGICAL { !(lhs .===. rhs) }

