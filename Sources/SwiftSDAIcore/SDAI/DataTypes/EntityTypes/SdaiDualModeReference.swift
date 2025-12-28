//
//  SdaiDualModeReference.swift
//  SwiftSDAIcore
//
//  Created by Yoshida on 2025/09/26.
//

import Foundation

public protocol SDAIDualModeReference: SDAIGenericType
{
	associatedtype PRef: SDAIPersistentReference

	var pRef: PRef { get }
}

public protocol SDAIPersistentReference: SDAIGenericType
{
  associatedtype ARef: SDAIGenericType

	var aRef: ARef { get }

	var optionalARef: ARef? { get }

}



extension SDAI {
  public typealias ComplexEntityID = SDAIPopulationSchema.SdaiModel.ComplexEntityID

  public typealias SDAIModelID = SDAIPopulationSchema.SdaiModel.SDAIModelID

  public enum ComplexEntityReference: Hashable, CustomStringConvertible, Sendable
  {
    case persistent(complexID: ComplexEntityID, modelID: SDAIModelID)
    case temporary(SDAI.EntityReference?)

    public var description: String {
      switch self {
        case .persistent(let complexID, let modelID):
          return "#\(complexID)_m\(modelID)"

        case .temporary(let eREF):
          if let eREF {
            return "\(eREF.complexEntity.qualifiedName)(temporary)"
          }
          else {
            return "(nil)"
          }
      }
    }


    public init(_ entityRef: EntityReference?) {
      if let entityRef {
        let complexEntity = entityRef.complexEntity
        let owningModel = complexEntity.owningModel

        if complexEntity.isTemporary {
          self = .temporary(entityRef)
        }
        else {
          let complexID = complexEntity.p21name
          let modelID = owningModel.modelID

          self =
            .persistent(complexID: complexID, modelID: modelID)
        }
      }
      else {
        self = .temporary(nil)
      }
    }
  }//enum
}//extension

//MARK: - SDAIDefinedType extension
public extension SDAIDefinedType
where Self: SDAIDualModeReference,
			FundamentalType: SDAIDualModeReference
{
	var pRef: FundamentalType.PRef {
		return self.asFundamentalType.pRef
	}
}

