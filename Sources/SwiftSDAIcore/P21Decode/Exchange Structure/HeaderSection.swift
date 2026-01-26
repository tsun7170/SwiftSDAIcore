//
//  HeaderSection.swift
//  
//
//  Created by Yoshida on 2021/04/30.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

extension P21Decode.ExchangeStructure {

	//MARK: - HeaderSection
	
	/// ISO 10303-21 8 Header section
  ///
  /// Represents the ISO 10303-21 Header section, containing metadata and descriptive information for an exchange structure.
  ///
  /// The header section is defined by ISO 10303-21 clause 8 and includes key metadata entities (`file_description`, `file_name`, and `file_schema`). This struct provides accessors for each entity and stores the parsed header entities from a STEP file.
  ///
  /// - Note: The `HeaderSection` is a value type and is safe for concurrent use (`Sendable`).
  ///
  /// - Properties:
  ///   - headerEntityList: The list of `SimpleRecord` entities parsed from the header section.
  ///   - fileDescription: The `file_description` entity, containing general file information.
  ///   - fileName: The `file_name` entity, containing the file name and authoring metadata.
  ///   - fileSchema: The `file_schema` entity, specifying the schema identifiers used in the file.
  ///
  /// - SeeAlso:
  ///   - [ISO 10303-21 Clause 8 Header section](https://www.iso.org/standard/63141.html)
	public struct HeaderSection: Sendable {

		/// ISO 10303-21 8.1 Header section structure
		nonisolated(unsafe)
		public internal(set) var headerEntityList: [SimpleRecord] = []
		
		/// ISO 10303-21 8.2.2 file_description
		public var fileDescription: FILE_DESCRIPTION {
			FILE_DESCRIPTION(headerEntityList[0])
		}

		/// ISO 10303-21 8.2.3 file_name
		public var fileName: FILE_NAME {
			FILE_NAME(headerEntityList[1])
		}

		/// ISO 10303-21 8.2.4 file_schema
		public var fileSchema: FILE_SCHEMA {
			FILE_SCHEMA(headerEntityList[2])
		}
	}
	
}


extension P21Decode.ExchangeStructure.HeaderSection {
	public typealias SimpleRecord = P21Decode.ExchangeStructure.SimpleRecord
	
	//MARK: - file_description (8.2.2)

  /// Represents the `file_description` entity from the ISO 10303-21 header section (clause 8.2.2).
  ///
  /// The `FILE_DESCRIPTION` structure models general information about the file, such as its description and implementation level, as specified in the STEP (ISO 10303-21) format's header section.
  /// This entity typically appears as the first entry in the header and provides high-level context for the exchange structure.
  ///
  /// - Properties:
  ///   - DESCRIPTION: An array of text strings describing the content of the file. This is sourced from the first parameter of the `file_description` entity.
  ///   - IMPLEMENTATION_LEVEL: A string specifying the implementation level (e.g., "2;1"), indicating the version or conformance requirements of the file.
  ///
  /// - SeeAlso:
  ///   - [ISO 10303-21 Clause 8.2.2: file_description](https://www.iso.org/standard/63141.html)
  ///   - `HeaderSection` for access to parsed header metadata.
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

  /// Represents the `file_name` entity from the ISO 10303-21 header section (clause 8.2.3).
  ///
  /// The `FILE_NAME` structure provides access to the name of the file and associated metadata,
  /// such as the author, organization, timestamp, preprocessing version, originating system, and authorization.
  /// This entity typically appears as the second entry in the header section of a STEP (ISO 10303-21) file,
  /// and its fields detail the provenance and context of the data exchange file.
  /// 
  /// - Properties:
  ///   - NAME: The name of the file as declared in the STEP file.
  ///   - shortName: The file's name, stripped of path qualifiers, providing a concise, user-friendly representation.
  ///   - TIME_STAMP: The time and date the file was created, as a string.
  ///   - AUTHOR: An array of author names associated with this file.
  ///   - ORGANIZAION: An array of organization names associated with the file creators.
  ///   - PREPROCESSOR_VERSION: The software version or preprocessor that created the file.
  ///   - ORIGINATING_SYSTEM: The originating system or software that authored the file content.
  ///   - AUTORIZATION: An authorization or access control string, if present.
  ///
  /// - SeeAlso:
  ///   - [ISO 10303-21 Clause 8.2.3: file_name](https://www.iso.org/standard/63141.html)
  ///   - `HeaderSection` for access to parsed header metadata.
	public struct FILE_NAME {
		private let headerEntity: SimpleRecord
		init(_ headerEntity: SimpleRecord) {
			self.headerEntity = headerEntity
		}
		
		public var NAME: String {
			guard let p1 = headerEntity.parameterList[0].asString else { return "<not a string>" }
			return p1
		}
    public var shortName: String {
      guard let p1 = headerEntity.parameterList[0].asString else { return "<n/a>" }

      let index0 = p1.lastIndex(where: { char in
        switch char {
          case
            Character("/"),
            Character("\\"),
            Character(":"): return true
          default: return false
        }
      })

      if let index0 {
        let index1 = p1.index(after:index0)
        if index1 < p1.endIndex {
          return String( p1.suffix(from: index1) )
        }
      }
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
  /// Represents the `file_schema` entity from the ISO 10303-21 header section (clause 8.2.4).
  ///
  /// The `FILE_SCHEMA` structure provides access to the schema identifiers declared in the STEP file header, 
  /// which define the set of data models and definitions that the file content conforms to. 
  /// This entity appears as the third entry in the header section of a STEP (ISO 10303-21) file and is essential 
  /// for interpreting the data according to the correct schema or schemas.
  ///
  /// - Properties:
  ///   - SCHEMA_IDENTIFIERS: An array of schema names (`SCHEMA_NAME`) specified by the file, usually containing a single entry 
  ///     but supporting multiple schema names if present.
  /// 
  /// - SeeAlso:
  ///   - [ISO 10303-21 Clause 8.2.4: file_schema](https://www.iso.org/standard/63141.html)
  ///   - `HeaderSection` for access to parsed header metadata.
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
