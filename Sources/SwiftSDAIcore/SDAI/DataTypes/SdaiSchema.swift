//
//  File.swift
//  
//
//  Created by Yoshida on 2021/05/21.
//

import Foundation


//MARK: - schema
public protocol SDAISchema {
	static var schemaDefinition: SDAIDictionarySchema.SchemaDefinition {get}
}

