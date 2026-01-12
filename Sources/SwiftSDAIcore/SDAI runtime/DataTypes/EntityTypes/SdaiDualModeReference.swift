//
//  SdaiDualModeReference.swift
//  SwiftSDAIcore
//
//  Created by Yoshida on 2025/09/26.
//

import Foundation

extension SDAI {
  public protocol DualModeReference: SDAI.GenericType
  {
    associatedtype PRef: SDAI.PersistentReference

    var pRef: PRef { get }
  }

  public protocol PersistentReference: SDAI.GenericType
  {
    associatedtype ARef: SDAI.GenericType

    var aRef: ARef { get }

    var optionalARef: ARef? { get }

  }
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

//MARK: - SDAI.DefinedType extension
public extension SDAI.DefinedType
where Self: SDAI.DualModeReference,
			FundamentalType: SDAI.DualModeReference
{
	var pRef: FundamentalType.PRef {
		return self.asFundamentalType.pRef
	}
}

