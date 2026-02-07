//
//  SdaiDualModeReference.swift
//  SwiftSDAIcore
//
//  Created by Yoshida on 2025/09/26.
//

import Foundation

extension SDAI {
  /// A protocol representing a reference type that supports dual modes:
  /// persistent and application (temporary) references. 
  ///
  /// Conforming types bridge between persistent stored references (such as database or file-backed)
  /// and in-memory or application-lifetime references. This abstraction allows generic code to 
  /// handle both modes seamlessly.
  ///
  /// - Note: The precise meaning and mechanics of "persistent" and "temporary" modes 
  ///         are dependent on context and the conforming types' implementations.
  /// 
  /// Associated Types:
  /// - `PRef`: The type representing the persistent reference, 
  ///           conforming to `SDAI.PersistentReference`.
  ///
  /// Requirements:
  /// - `pRef`: The persistent reference value of the conforming instance.
  ///
  public protocol DualModeReference: SDAI.GenericType
  {
    associatedtype PRef: SDAI.PersistentReference

    var pRef: PRef { get }
  }

  /// A protocol that represents a persistent, stored reference to an entity or value,
  /// typically one that is saved in a long-lived storage medium such as a database or file.
  /// 
  /// Types conforming to `PersistentReference` are responsible for providing access to a
  /// corresponding application-lifetime reference (`ARef`). This enables bridging between 
  /// persistent representations and in-memory, temporary representations of referenced entities.
  /// 
  /// - Associatedtype:
  ///   - `ARef`: The associated application (temporary) reference type, conforming to `SDAI.GenericType`.
  /// 
  /// - Requirements:
  ///   - `aRef`: The application reference corresponding to this persistent reference. This provides direct access
  ///             to the in-memory representation of the referenced entity or value.
  ///   - `optionalARef`: An optional application reference, which may be `nil` if the referenced entity/value is unavailable
  ///                     or not yet resolved in the application's context.
  /// 
  /// - Usage:
  ///   Use `PersistentReference` to provide a robust, type-safe mechanism for navigating between
  ///   persistent and in-memory representations, particularly in systems that require synchronization,
  ///   serialization, or round-tripping of reference information.
  /// 
  /// - SeeAlso: `SDAI.DualModeReference` for dual-mode abstraction, and `SDAI.GenericType` for generic compatibility.
  ///
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

  /// An enumeration that represents a reference to a complex entity, supporting both persistent and temporary modes.
  ///
  /// `ComplexEntityReference` is used to abstractly reference a complex entity in either a persistent ("stored")
  /// or temporary ("in-memory") context. This is useful when working with entities that may be backed by
  /// persistent storage (such as a file or database) or may exist only within the application's memory for a limited
  /// time (such as during editing or transient calculations).
  ///
  /// - Cases:
  ///   - `persistent(complexID:modelID:)`: Represents a reference to a persistently stored complex entity,
  ///     identified by a unique `complexID` and the owning model's `modelID`.
  ///   - `temporary(SDAI.EntityReference?)`: Represents a reference to a temporary (in-memory or application-scoped)
  ///     entity. The associated value may be `nil` if no temporary reference exists.
  ///
  /// - Conforms To:
  ///   - `Hashable`: Enables comparisons and use in sets or as dictionary keys.
  ///   - `CustomStringConvertible`: Provides a human-readable string description.
  ///   - `Sendable`: Enables use in concurrent contexts.
  ///
  /// - Usage:
  ///   Use `ComplexEntityReference` whenever code needs to generically refer to an entity
  ///   without knowing whether it is persistent or temporary. This abstraction allows APIs to handle both cases
  ///   seamlessly, improving flexibility and type safety.
  ///
  /// - SeeAlso: `SDAI.DualModeReference` for the associated dual-mode reference protocol abstraction.
  /// 
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

