import XCTest
@testable import SwiftSDAIcore

final class SwiftSDAIcoreTests: XCTestCase {
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct
//        // results.
//        XCTAssertEqual(1,1, "Hello, World!")
//    }

//    static var allTests = [
//        ("testExample", testExample),
//    ]
	
	
	func testStringType1() {
		let A = SDAI.STRING("")
		XCTAssertEqual(A, "")
	}
	
	struct StringSubType: SDAI__STRING__subtype {
		
		public typealias Supertype = SDAI.STRING
		public typealias FundamentalType = Supertype.FundamentalType
		public typealias Value = Supertype.Value
		public typealias SwiftType = Supertype.SwiftType
		public static var typeName: String = "StringSubType"
		public static var bareTypeName: String = "StringSubType"
		public var rep: Supertype

		public init(fundamental: FundamentalType) {
			rep = Supertype(fundamental: fundamental)
		}

		public init?<G: SDAIGenericType>(fromGeneric generic: G?) {
			guard let repval = generic?.stringValue else { return nil }
			rep = repval
		}
	}
	
	func testStringSubtype1() {
		let A = StringSubType("")
		XCTAssertEqual(A, "")
	}
	
	
	class ENTITY1 : SDAI.EntityReference {
		public class override var entityDefinition: SDAIDictionarySchema.EntityDefinition { _entityDefinition }
		private static let _entityDefinition: SDAIDictionarySchema.EntityDefinition = createEntityDefinition()
		private static func createEntityDefinition() -> SDAIDictionarySchema.EntityDefinition {
			let entityDef = SDAIDictionarySchema.EntityDefinition(name: "ENTITY1", type: self, explicitAttributeCount: 0)
			return entityDef
		}
	}
	
	class ENTITY2 : SDAI.EntityReference {
		public class override var entityDefinition: SDAIDictionarySchema.EntityDefinition { _entityDefinition }
		private static let _entityDefinition: SDAIDictionarySchema.EntityDefinition = createEntityDefinition()
		private static func createEntityDefinition() -> SDAIDictionarySchema.EntityDefinition {
			let entityDef = SDAIDictionarySchema.EntityDefinition(name: "ENTITY2", type: self, explicitAttributeCount: 0)
			return entityDef
		}
	}

	func testEntityReferenceType1() {
		let entity1type: SDAI.EntityReference.Type = ENTITY1.self
		let entity2type: SDAI.EntityReference.Type = ENTITY2.self
		
		let entity1def = entity1type.entityDefinition
		let entity2def = entity2type.entityDefinition
		
		XCTAssertNotEqual(entity1def, entity2def)		
		XCTAssertEqual(entity1def, entity1def)
		
		let set: Set = [entity1def,entity2def] 
		let setResult = set.contains(entity1def)
		XCTAssertTrue(setResult)
		
		let dict = [entity1def:"ENTITY1", entity2def:"ENTITY2"]
		let dictResult = dict[entity1def]
		XCTAssertNotNil(dictResult)
	}
	
}
