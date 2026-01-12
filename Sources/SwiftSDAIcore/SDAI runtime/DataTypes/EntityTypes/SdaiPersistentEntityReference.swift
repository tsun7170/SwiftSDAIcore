//
//  SdaiPersistentEntityReference.swift
//  SwiftSDAIcore
//
//  Created by Yoshida on 2025/10/01.
//

import Foundation

extension SDAI {
	//MARK: - persistent entity reference
	@dynamicMemberLookup
	public final class PersistentEntityReference<EREF>:
    GenericPersistentEntityReference, @unchecked Sendable,
		SDAI.PersistentReference,
		InitializableByComplexEntity,
		SDAI.EntityReferenceYielding
  where EREF: SDAI.EntityReference & SDAI.InitializableByP21Parameter
	{
		//MARK: SDAI.PersistentReference
		public typealias ARef = EREF

		public var aRef: EREF { self.instance }

		public var optionalARef: EREF? { self.optionalInstance }


    //MARK: CustomStringConvertible
    public override var description: String {
        return "\(EREF.entityDefinition.name).PRef=> \(self.complexReference)"
      }


    //MARK: Initializers
    
    /// initialize persistent entity reference from a optional entity reference
    /// - Parameter entityRef: optional entity reference
		public init(_ entityRef: EREF?) {
      let complexRef = ComplexEntityReference(entityRef)
      super.init(complexRef)
		}

    public override init(_ complexReference: ComplexEntityReference) {
      super.init(complexReference)
    }

    public convenience init?(
      _ complex: SDAI.ComplexEntity?)
    {
      guard let eref = complex?.entityReference(EREF.self)
      else { return nil }
      self.init(eref)
    }

    public convenience init?<OTHER>(
      _ pref: PersistentEntityReference<OTHER>?)
    where OTHER: SDAI.EntityReference
    {
      guard let pref else { return nil }
      self.init(pref.complexReference)
    }


    //MARK: InitializableByComplexEntity
    public convenience init?(
      possiblyFrom complex: SDAI.ComplexEntity?)
    {
      self.init(complex)
    }

    public convenience init?(possiblyFrom entityRef: SDAI.EntityReference?)
    {
      self.init(entityRef?.complexEntity)
    }

    public convenience init?<OTHER>(
      possiblyFrom pref: PersistentEntityReference<OTHER>?)
    where OTHER: SDAI.EntityReference
    {
      self.init(pref)
    }



    //MARK: dereferencing operations
		public var eval: EREF? { self.optionalInstance }

		public var optionalInstance: EREF? {
			switch self.complexReference {
				case .persistent(let complexID, let modelID):
					guard
            let complex = self.resolveComplexEntity(
              complexID: complexID, modelID: modelID)
					else { return nil }

					let eref = complex.entityReference(EREF.self)
					return eref

				case .temporary(let eREF):
					return eREF as? EREF
			}
		}

		public var instance: EREF {
			switch self.complexReference {
        case .persistent(let complexID, let modelID):
					guard
            let complex = self.resolveComplexEntity(
              complexID: complexID, modelID: modelID)
					else {
						SDAI.raiseErrorAndTrap(.SY_ERR, detail:"can not locate complex entity:#\(complexID) of model:\(modelID) under session:\(String(describing: SDAISessionSchema.activeSession))")
					}

					guard let eref = complex.entityReference(EREF.self)
					else {
						SDAI.raiseErrorAndTrap(.EI_NEXS, detail: "entity reference:\(EREF.self) not found in complex:\(complexID)")
					}
					return eref

				case .temporary(let eREF):
					guard let eref = eREF as? EREF
					else {
						SDAI.raiseErrorAndTrap(.EI_NEXS, detail: "nil entity reference:\(EREF.self)")
					}
					return eref
			}
		}


		//MARK: dynamic member lookup
		public subscript<T>(dynamicMember keyPath: KeyPath<EREF, T>) -> T? {
			guard let entity = self.eval else { return nil }
			let result = entity[keyPath: keyPath]
      return result
		}

		public subscript<T>(dynamicMember keyPath: KeyPath<EREF, T?>) -> T? {
			guard let entity = self.eval else { return nil }
			let result = entity[keyPath: keyPath]
      return result
		}

		public subscript<U>(dynamicMember keyPath: WritableKeyPath<EREF, U>) -> U? {
			get {
				guard let entity = self.eval else { return nil }
				let result = entity[keyPath: keyPath]
        return result
			}
			set {
				guard var entity = self.eval,
							let newValue = newValue
				else { return }
				entity[keyPath: keyPath] = newValue
			}
		}

		public subscript<U>(dynamicMember keyPath: WritableKeyPath<EREF, U?>) -> U? {
			get {
				guard let entity = self.eval else { return nil }
				let result = entity[keyPath: keyPath]
        return result
			}
			set {
				guard var entity = self.eval
				else { return }
				entity[keyPath: keyPath] = newValue
			}
		}



		//MARK: group reference
		public func GROUP_REF<SUPER:EntityReference & SDAI.DualModeReference>(
			_ super_ref: SUPER.Type
		) -> SUPER.PRef?
		{
			guard let complex = self.complexEntity else { return nil }
      let result = complex.entityReference(super_ref)?.pRef
      return result
		}


		//MARK: InitializableByGenericType
		public required convenience init?<G: SDAI.GenericType>(
      fromGeneric generic: G?)
    {
			if let pref = generic as? Self {
        self.init(possiblyFrom: pref)
			}
      else if let eref = generic as? EREF {
        self.init(eref)
      }
      else if let entity = generic as? SDAI.EntityReference {
        let complex = entity.complexEntity
        let eref = complex.entityReference(EREF.self)
        self.init(eref)
			}
      else {
        return nil
      }
		}


		//MARK: InitializableByP21Parameter
		public required convenience init?(
			p21untypedParam: P21Decode.ExchangeStructure.UntypedParameter,
			from exchangeStructure: P21Decode.ExchangeStructure)
		{
			guard let eref = EREF.init(
				p21untypedParam: p21untypedParam,
				from: exchangeStructure)
			else { return nil }

			self.init(eref)
		}

		public required convenience init?(
			p21omittedParamfrom exchangeStructure: P21Decode.ExchangeStructure)
		{
			guard let eref = EREF.init(p21omittedParamfrom: exchangeStructure)
			else { return nil }

			self.init(eref)
		}



//MARK: SDAI.GenericType

    public convenience required init(
      fundamental eref: FundamentalType)
		{
      let eref = EREF(fundamental: eref)
			self.init(eref)
		}

    public class override var ERefType: EntityReference.Type { EREF.self }

//MARK: SDAI.EntityReferenceYielding
		public var entityReferences: AnySequence<SDAI.EntityReference> {
			self.eval?.entityReferences ?? AnySequence()
		}

    public var persistentEntityReferences: AnySequence<SDAI.GenericPersistentEntityReference> {
      AnySequence(CollectionOfOne(self))
    }

		public func isHolding(entityReference: SDAI.EntityReference) -> Bool {
			self.eval?.isHolding(entityReference: entityReference) ?? false
		}
	}//class
}//SDAI

extension SDAI.PersistentEntityReference
where EREF: SDAI.SimpleEntityType
{
	public convenience init?(_ partial: EREF.SimplePartialEntity?)
	{
		guard
			let partial = partial,
			let eref = EREF.init(partial) else { return nil }
		self.init(eref)
	}

}

extension SDAI.PersistentEntityReference: SDAI.InitializableByVoid
where EREF: SDAI.InitializableByVoid
{
  public convenience init() {
    let eref = EREF()
    self.init(eref)
  }
}

