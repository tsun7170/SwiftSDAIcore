//
//  SdaiSchema.swift
//  
//
//  Created by Yoshida on 2021/05/21.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation


//MARK: - schema
public protocol SDAISchema {
	static var schemaDefinition: SDAIDictionarySchema.SchemaDefinition {get}
}

