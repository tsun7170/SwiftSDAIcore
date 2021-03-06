//
//  HeaderSection.swift
//  
//
//  Created by Yoshida on 2021/04/30.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension P21Decode.ExchangeStructure {
	
	/// ISO 10303-21 8 Header section
	public struct HeaderSection {
		
		/// ISO 10303-21 8.1 Header section structure
		public internal(set) var headerEntityList: [SimpleRecord] = []
		
		/// ISO 10303-21 8.2.2 file_description
		public lazy var fileDescription = FILE_DESCRIPTION(headerEntityList[0])
		
		/// ISO 10303-21 8.2.3 file_name
		public lazy var fileName = FILE_NAME(headerEntityList[1])
		
		/// ISO 10303-21 8.2.4 file_schema
		public lazy var fileSchema = FILE_SCHEMA(headerEntityList[2])
	}
	
}


extension P21Decode.ExchangeStructure.HeaderSection {
	public typealias SimpleRecord = P21Decode.ExchangeStructure.SimpleRecord
	
	//MARK: - file_description (8.2.2)
	public struct FILE_DESCRIPTION {
		private let headerEntity: SimpleRecord
		init(_ headerEntity: SimpleRecord) {
			self.headerEntity = headerEntity
		}
		
		public var DESCRIPTION: [String] {
			guard let p1 = headerEntity.parameterList[0].asListOfString else { return ["<not a string>"] }
			return p1
		}
		
		public var IMPLEMENTATION_LEVEL: String {
			guard let p2 = headerEntity.parameterList[1].asString else { return "<not a string>" }
			return p2
		}
	}
	
	//MARK: - file_name (8.2.3)
	public struct FILE_NAME {
		private let headerEntity: SimpleRecord
		init(_ headerEntity: SimpleRecord) {
			self.headerEntity = headerEntity
		}
		
		public var NAME: String {
			guard let p1 = headerEntity.parameterList[0].asString else { return "<not a string>" }
			return p1
		}
		public var TIME_STAMP: TIME_STAMP_TEXT {
			guard let p2 = headerEntity.parameterList[1].asString else { return "<not a string>" }
			return p2
		}
		public var AUTHOR: [String] {
			guard let p3 = headerEntity.parameterList[2].asListOfString else { return ["<not a string>"] }
			return p3
		}
		public var ORGANIZAION: [String] {
			guard let p4 = headerEntity.parameterList[3].asListOfString else { return ["<not a string>"] }
			return p4
		}
		public var PREPROCESSOR_VERSION: String {
			guard let p5 = headerEntity.parameterList[4].asString else { return "<not a string>" }
			return p5
		}
		public var ORIGINATING_SYSTEM: String {
			guard let p6 = headerEntity.parameterList[5].asString else { return "<not a string>" }
			return p6
		}
		public var AUTORIZATION: String {
			guard let p7 = headerEntity.parameterList[6].asString else { return "<not a string>" }
			return p7
		}
		
		public typealias TIME_STAMP_TEXT = String
	}
	
	//MARK: - file_schema (8.2.4)
	public struct FILE_SCHEMA {
		private let headerEntity: SimpleRecord
		 
		init(_ headerEntity: SimpleRecord) {
			self.headerEntity = headerEntity
		}
		
		public var SCHEMA_IDENTIFIERS: [SCHEMA_NAME] {
			guard let p1 = headerEntity.parameterList[0].asListOfString else { return ["<not a string>"] }
			return p1
		}
		
		public typealias SCHEMA_NAME = String
	}

}
