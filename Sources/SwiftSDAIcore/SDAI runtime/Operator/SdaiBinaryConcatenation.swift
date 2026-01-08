//
//  SdaiBinaryConcatenation.swift
//  
//
//  Created by Yoshida on 2021/01/23.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - Binary concatenation operator (12.3.2)

public func + <T: SDAI__BINARY__type, U: SDAI__BINARY__type>(lhs: T?, rhs: U?) -> SDAI.BINARY? { 
	guard let lhs = lhs, let rhs = rhs else { return nil }
	return SDAI.BINARY( from: lhs.asSwiftType + rhs.asSwiftType )
}

