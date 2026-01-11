//
//  SdaiOperators.swift
//  
//
//  Created by Yoshida on 2020/11/04.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

infix operator **     : BitwiseShiftPrecedence    // exponentiation
infix operator ./.    : MultiplicationPrecedence  // integer division (DIV)
infix operator .==.   : ComparisonPrecedence      // value equal
infix operator .!=.   : ComparisonPrecedence      // XOR, value not equal
infix operator .===.  : ComparisonPrecedence      // instance equal
infix operator .!==.  : ComparisonPrecedence      // instance not equal
infix operator .||.   : AdditionPrecedence        // complex entity instance construction



