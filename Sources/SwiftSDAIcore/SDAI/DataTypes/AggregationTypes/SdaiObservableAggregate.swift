//
//  SdaiObservableAggregate.swift
//  
//
//  Created by Yoshida on 2021/06/15.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - observable element
public protocol SDAIObservableAggregateElement
{
	var entityReferences: AnySequence<SDAI.EntityReference> { get }
	mutating func configure(with observer: SDAI.EntityReferenceObserver)
	mutating func teardownObserver()
}

public extension SDAIDefinedType
where Self: SDAIObservableAggregateElement,
			Supertype: SDAIObservableAggregateElement
{
	var entityReferences: AnySequence<SDAI.EntityReference> { return rep.entityReferences }
	mutating func configure(with observer: SDAI.EntityReferenceObserver) { rep.configure(with: observer) }
	mutating func teardownObserver() { rep.teardownObserver() }
}

//MARK: - observable aggregate
public protocol SDAIObservableAggregate: SDAIAggregationType, SDAIObservableAggregateElement 
where ELEMENT: SDAIObservableAggregateElement
{
//	var observer: SDAI.EntityReferenceObserver? {get set}
//	func teardown()
}

//public extension SDAIDefinedType
//where Self: SDAIObservableAggregate,
//			Supertype: SDAIObservableAggregate
//{
//	var observer: SDAI.EntityReferenceObserver? {
//		get { 
//			return rep.observer
//		}
//		set {
//			rep.observer = newValue
//		}
//	}
//	
//	func teardown() {
//		rep.teardown()
//	}	
//}

//MARK: - entity reference observer
extension SDAI {
	public struct EntityReferenceObserver {
		let referencer: SDAI.PartialEntity
		let observerCode: ObserverCode.Type
		
		public init(referencer: SDAI.PartialEntity, observerCode:ObserverCode.Type) {
			self.referencer = referencer
			self.observerCode = observerCode
		}
		
		public func observe<RemovingEntities: Sequence, AddingEntities: Sequence>(
			removing: RemovingEntities, adding: AddingEntities )
		where RemovingEntities.Element: SDAI.EntityReference, 
					AddingEntities.Element: SDAI.EntityReference
		{
			observerCode.observe(referencer: referencer, removing: removing, adding: adding)
		}
		
//		public func observe(newReferencerOwner: SDAI.ComplexEntity) {
//			observerCode.observe(newReferencerOwner: newReferencerOwner)
//		}
//		
//		public func observe(leavingReferencerOwner: SDAI.ComplexEntity) {
//			observerCode.observe(leavingReferencerOwner: leavingReferencerOwner)
//		}

		
		open class ObserverCode {
			public init(referencerType: SDAI.PartialEntity.Type) {
				self.referencerType = referencerType
			}
			
			public let referencerType: SDAI.PartialEntity.Type
			
			open class func observe<RemovingEntities: Sequence, AddingEntities: Sequence>(
				referencer: SDAI.PartialEntity, 
				removing: RemovingEntities, adding: AddingEntities )
			where RemovingEntities.Element: SDAI.EntityReference, 
						AddingEntities.Element: SDAI.EntityReference
			{}
			
			final public class func observe<OAE: SDAIObservableAggregateElement>(
				referencer: SDAI.PartialEntity, 
				removingOne: OAE?, addingOne: OAE? ) 
			where OAE: Equatable
			{
				guard removingOne != addingOne else { return }
				self.observe(
					referencer: referencer, 
					removing: SDAI.UNWRAP(seq: removingOne?.entityReferences), 
					adding: SDAI.UNWRAP(seq: addingOne?.entityReferences))
			}
			
			open class func observe(newReferencerOwner: SDAI.ComplexEntity) {}
			
			open class func observe(leavingReferencerOwner: SDAI.ComplexEntity) {}
			
		}
	}
	
}
