# SDAI Operations

SDAI operations as defined in section 10 of ISO 10303-22

## Overview

SDAI (Standard Data Access Interface) operations represent the standardized set of methods and procedures available in an SDAI implementation to interact with data defined by EXPRESS schemas, as specified in section 10 of ISO 10303-22. These operations enable management of sessions, repositories, schema instances, models, entity instances, and their associated aggregations.

This document organizes and references SDAI operations according to their functional areas, providing a cross-reference between Swift API signatures and the corresponding EXPRESS/SDAI operation definitions. Use this as a guide to implement, locate, or understand the supported operations within the library, and to facilitate compliance with the SDAI standard.

## Topics

### Environment operations (10.3)

- ``SDAI/openSession(knownServers:errorEventCallback:maxConcurrency:maxCacheUpdateAttempts:maxUsedinNesting:runUsedinCacheWarming:maxValidationTaskSegmentation:minValidationTaskChunkSize:validateTemporaryEntities:)``

### Session operations (10.4)

- ``SDAISessionSchema/SdaiSession/recordError(error:description:functionID:)``
- ``SDAISessionSchema/SdaiSession/startEventRecording()``
- ``SDAISessionSchema/SdaiSession/stopEventRecording()``
- ``SDAISessionSchema/SdaiSession/closeSession()``
- ``SDAISessionSchema/SdaiSession/open(repository:)``
- ``SDAISessionSchema/SdaiSession/performTransactionRW(output:action:)``
- ``SDAISessionSchema/SdaiSession/performTransactionRO(output:action:)``
- ``SDAISessionSchema/SdaiSession/performTransactionVA(output:action:)``

- ``SDAISessionSchema/SdaiTransaction/commit()``
- ``SDAISessionSchema/SdaiTransaction/abort()``

### Repository operations (10.5)

- ``SDAISessionSchema/SdaiTransactionRW/createSdaiModel(repository:modelName:schema:)``
- ``SDAISessionSchema/SdaiTransactionRW/createSchemaInstance(repository:name:schema:)``

- ``SDAISessionSchema/SdaiTransaction/close(repository:disposition:)``


### Schema instance operations (10.6)

- ``SDAISessionSchema/SdaiTransactionRW/promoteSchemaInstanceToReadWrite(instance:)``
- ``SDAISessionSchema/SdaiTransactionRW/deleteSchemaInstance(instance:)``
- ``SDAISessionSchema/SdaiTransactionRW/renameSchemaInstance(instance:name:)``
- ``SDAISessionSchema/SdaiTransactionRW/addSdaiModel(instance:model:)``
- ``SDAISessionSchema/SdaiTransactionRW/removeSdaiModel(instance:model:)``

- ``SDAISessionSchema/SdaiTransactionVA/promoteSchemaInstanceToReadWrite(instance:)``

- ``SDAISessionSchema/SdaiTransaction/validateGlobalRule(instance:rule:option:)``
- ``SDAISessionSchema/SdaiTransaction/validateUniquenessRule(instance:rule:)``
- ``SDAISessionSchema/SdaiTransaction/validateInstanceReferenceDomain(instance:object:recording:)``

- ``SDAISessionSchema/SdaiTransactionRW/validateSchemaInstance(instance:option:monitor:)``
- ``SDAISessionSchema/SdaiTransactionRW/validateSchemaInstanceAsync(instance:option:monitor:)``

- ``SDAISessionSchema/SdaiTransactionVA/validateSchemaInstance(instance:option:monitor:)``
- ``SDAISessionSchema/SdaiTransactionVA/validateSchemaInstanceAsync(instance:option:monitor:)``

- ``SDAISessionSchema/SdaiTransaction/isValidationCurrent(instance:)``



### SDAI-model operations (10.7)

- ``SDAISessionSchema/SdaiTransactionRW/deleteSdaiModel(model:)``
- ``SDAISessionSchema/SdaiTransactionRW/renameSdaiModel(model:modelName:)``

- ``SDAISessionSchema/SdaiTransaction/startReadOnlyAccess(model:)``

- ``SDAISessionSchema/SdaiTransactionRW/promoteSdaiModelToReadWrite(model:)``

- ``SDAISessionSchema/SdaiTransaction/endReadOnlyAccess(model:)``

- ``SDAISessionSchema/SdaiTransactionRW/startReadWriteAccess(model:)``
- ``SDAISessionSchema/SdaiTransactionRW/endReadWriteAccess(model:disposition:)``

- ``SDAIPopulationSchema/SdaiModel/getEntityDefinition(entityName:)``

### Scope operations (10.8)

### Type operations (10.9)

- ``SDAIDictionarySchema/EntityDefinition/isSubtype(of:)``

### Entity instance operations (10.10)

- ``SDAIDictionarySchema/AttributeType/genericValue(for:)``
- ``SDAIDictionarySchema/AttributeType/testAttribute(for:)``
- ``SDAI/EntityReference/owningModel``
- ``SDAI/EntityReference/definition``
- ``SDAI/EntityReference/isInstance(of:)``
- ``SDAI/EntityReference/isKind(of:)``
- ``SDAI/EntityReference/findEntityInstanceUsers(domain:)``
- ``SDAI/EntityReference/findEntityInstanceUsedin(role:domain:)-(KeyPath<ENT,R>,_)``
- ``SDAI/EntityReference/findEntityInstanceUsedin(role:domain:)-(KeyPath<ENT,R?>,_)``
- ``SDAI/EntityReference/findInstanceRoles(domain:)``
- ``SDAI/EntityReference/findInstanceDataTypes()``

### Application instance operations (10.11)

- ``SDAI/EntityReference/persistentLabel``
- ``SDAISessionSchema/SdaiTransaction/getSessionIdentifier(label:repository:)``
- ``SDAI/EntityReference/description``
- ``SDAISessionSchema/SdaiTransaction/validateWhereRules(object:recording:)``


### Entity instance aggregate operations (10.12)

- ``SDAI/AggregationType/size``
- ``SDAI/AggregationType/CONTAINS(elem:)``
- ``SDAI/AggregateIndexingGettable/subscript(_:)-(Int?)``
- ``SDAI/AggregationType/loBound``
- ``SDAI/AggregationType/hiBound``

### Application instance aggregate operations (10.13)

- ``SDAI/AggregateIndexingSettable/subscript(_:)-(Int?)``

### Application instance unordered collection operations (10.14)

- ``SDAI/BagType/add(member:)``
- ``SDAI/BAG/init()``
- ``SDAI/SET/init()``

### Entity instance ordered collection operations (10.15)

- ``SDAI/AggregateIndexingGettable/subscript(_:)-(Int?)``

### Application instance ordered collection operations (10.16)

- ``SDAI/AggregateIndexingSettable/subscript(_:)-(Int?)``

### Entity instance array operations (10.17)

- ``SDAI/AggregationType/loIndex``
- ``SDAI/AggregationType/hiIndex``

### Application instance array operations (10.18)

### Application instance list operations (10.19)

- ``SDAI/ListType/insert(element:at:)``
- ``SDAI/LIST/init()``
- ``SDAI/ListType/remove(at:)``

