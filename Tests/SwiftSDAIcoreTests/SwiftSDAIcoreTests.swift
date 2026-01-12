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
	
	
	
	
	
	struct StringSubType: SDAI.STRING__Subtype, CustomStringConvertible {
		public var typeMembers: Set<SDAI.STRING> {
			var members = Set<SDAI.STRING>()
			members.insert(SDAI.STRING(Self.typeName))
			return members
		}
		
		public var isCacheable: Bool { false }
		
		public typealias Supertype = SDAI.STRING
		public typealias FundamentalType = Supertype.FundamentalType
		public typealias Value = Supertype.Value
		public typealias SwiftType = Supertype.SwiftType
		public static let typeName: String = "StringSubType"
		public static let bareTypeName: String = "StringSubType"
		public var rep: Supertype

		public init(fundamental: FundamentalType) {
			rep = Supertype(fundamental: fundamental)
		}

		public init?<G: SDAI.GenericType>(fromGeneric generic: G?) {
			guard let repval = generic?.stringValue else { return nil }
			rep = repval
		}
		
		public var description: String { "test desctiption" }
	}
	
	func testStringSubtype1() {
		let A = StringSubType("")
		print("\nA = \(A)\n")
		XCTAssertEqual(A, "")
	}
	
	
	
	
	
	
	class ENTITY1 : SDAI.EntityReference, @unchecked Sendable {
		public class override var entityDefinition: SDAIDictionarySchema.EntityDefinition { _entityDefinition }

		private static let _entityDefinition: SDAIDictionarySchema.EntityDefinition = createEntityDefinition()

		private static func createEntityDefinition() -> SDAIDictionarySchema.EntityDefinition {
			let entityDef = SDAIDictionarySchema.EntityDefinition.Prototype(name: "ENTITY1", type: self, explicitAttributeCount: 0)
			return entityDef.freeze()
		}
	}
	
	class ENTITY2 : SDAI.EntityReference, @unchecked Sendable {
		public class override var entityDefinition: SDAIDictionarySchema.EntityDefinition { _entityDefinition }
		private static let _entityDefinition: SDAIDictionarySchema.EntityDefinition = createEntityDefinition()
		private static func createEntityDefinition() -> SDAIDictionarySchema.EntityDefinition {
			let entityDef = SDAIDictionarySchema.EntityDefinition.Prototype(name: "ENTITY2", type: self, explicitAttributeCount: 0)
			return entityDef.freeze()
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
		
	func testOperator1() {
		let R1 = SDAI.FORCE_OPTIONAL(SDAI.REAL(1))
		let I1 = SDAI.FORCE_OPTIONAL(SDAI.INTEGER(0))
		let R2 = SDAI.REAL(I1)
		XCTAssertNotNil(R2)
		let L1 = R1 > I1
		XCTAssertTrue(SDAI.IS_TRUE(L1))
		
		let L2 = R1 >= I1
		XCTAssertTrue(SDAI.IS_TRUE(L2))
	}
	
	func testConversion1() {
		let N1 = SDAI.NUMBER(1)
		let I1 = SDAI.INTEGER( N1 )
		XCTAssertNotNil(I1)
	}
	
	
	func testP21stream() {
		let testDataFolder = ProcessInfo.processInfo.environment["TEST_DATA_FOLDER"]!
		let url = URL(fileURLWithPath: testDataFolder + "NIST_CTC_STEP_PMI/nist_ctc_02_asme1_ap242-e2.stp")
		let stepsource = try! String(contentsOf: url, encoding: .utf8)
		let charstream = stepsource.makeIterator()

		let p21stream = P21Decode.P21CharacterStream(charStream: charstream)

		var output: String = ""
		while p21stream.lineNumber < 10 {
			print(p21stream.next() ?? "<nil>", terminator:"", to: &output)
		}
		
		XCTAssertTrue(p21stream.lineNumber > 0)
	}


	func testParser() {
		let testDataFolder = ProcessInfo.processInfo.environment["TEST_DATA_FOLDER"]!
		let url = URL(fileURLWithPath: testDataFolder + "NIST_CTC_STEP_PMI/nist_ctc_02_asme1_ap242-e2.stp")
		let stepsource = try! String(contentsOf: url, encoding: .utf8) 
		let charstream = stepsource.makeIterator()

		let repository = SDAISessionSchema.SdaiRepository(name: "example", description: "example repository")

		let parser = P21Decode.ExchangeStructureParser(
			charStream: charstream,
			output: repository,
			foreignReferenceResolver: P21Decode.ForeignReferenceResolver() )

		let result = parser.parseExchangeStructure()

		if result == nil {
			print("parser error = ",parser.error ?? "unknown error")
		}
		else {
			print("normal end of execution")
		}
		
		XCTAssertNotNil(result)
	}
	
	func testCachable() {
		let A = StringSubType("")
		let B = SDAI.INTEGER(1)
		
		let A1 = SDAI.FORCE_OPTIONAL(A)
		let B1 = SDAI.FORCE_OPTIONAL(B)
		
		let A2 = nil as StringSubType?
		let B2 = nil as SDAI.INTEGER?
		
		let params1 = SDAI.ParameterList(B)
		XCTAssertTrue(params1.isCacheable)

		let params2 = SDAI.ParameterList(B1)
		XCTAssertTrue(params2.isCacheable)

		let params3 = SDAI.ParameterList(B2)
		XCTAssertTrue(params3.isCacheable)

		let params4 = SDAI.ParameterList(A)
		XCTAssertTrue(!params4.isCacheable)

		let params5 = SDAI.ParameterList(A1)
		XCTAssertTrue(!params5.isCacheable)

		let params6 = SDAI.ParameterList(A2)
		XCTAssertTrue(params6.isCacheable)

		let params7 = SDAI.ParameterList(A,B,A1,B1,A2,B2)
		XCTAssertTrue(!params7.isCacheable)

		let params8 = SDAI.ParameterList(B,B1,A2,B2)
		XCTAssertTrue(params8.isCacheable)

	}
	
	
}
