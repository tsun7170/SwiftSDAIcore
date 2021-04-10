//
//  File.swift
//  
//
//  Created by Yoshida on 2021/03/28.
//

import Foundation


extension SDAIPopulationSchema {
	
	//MARK: (8.4.1)
	public class SchemaInstance: SDAI.Object {
		public var name: STRING { abstruct() }
		public var associatedModels: SET<SdaiModel> = []
		public var nativeSchema: SDAIDictionarySchema.SchemaDefinition { abstruct() }
		public var repository: SDAISessionSchema.SdaiRepository { abstruct() }
		public var changeDate: SDAISessionSchema.TimeStamp?
		public var validationDate: SDAISessionSchema.TimeStamp { abstruct() }
		public var validationResult: LOGICAL { abstruct() }
		public var validationLevel: INTEGER = 1
		
		//MARK: swift binding support
		public var allComplexEntities: AnySequence<SDAI.ComplexEntity> { abstruct() }
	}
}
