# ``SwiftSDAIcore``

The runtime environment for the exp2swift translated EXPRESS codes.

## Overview

The ``SwiftSDAIcore`` package provides the runtime foundation for Swift-based implementations of the EXPRESS data modeling language (ISO 10303-11) and select functionalities from the Standard Data Access Interface (SDAI, ISO 10303-22). It is the essential support layer for codebases translated from EXPRESS schemas using the exp2swift tool.

Key capabilities include:
* **EXPRESS Type System:** Swift-native representations of all built-in EXPRESS data types (such as LOGICAL, BOOLEAN, INTEGER, REAL, STRING, and aggregates).
* **Language Semantics:** Complete support for core EXPRESS functions, procedures, and operators, ensuring faithful translation and runtime behavior.
* **SDAI Support:** Partial implementation of the SDAI API relevant for working with product data within Swift, including type conformance, entity population, and attribute management mechanisms.
* **STEP Data Import:** Utilities for importing and parsing STEP (ISO 10303-21) exchange files, enabling consumption of standardized product data in Swift environments.
* **Extensible Architecture:** Namespaces and protocols designed for integration with schema-specific, exp2swift-generated code, facilitating type-safe EXPRESS runtime operations in Swift.

This package is focused on importing STEP files and providing an interoperable, Swift-centric EXPRESS runtime environment. Export or authoring support for STEP files is not within the scope of this module.

## Topics

### Name Spaces

- ``SDAI``
- ``SDAIDictionarySchema``
- ``SDAISessionSchema``
- ``SDAIPopulationSchema``
- ``SDAIParameterDataSchema``
- ``P21Decode``

### SDAI Operations

- <doc:SDAI_Operations>

### SDAI Operators

- <doc:OperatorsArithmetic>

- <doc:OperatorsValueComp>
- <doc:OperatorsInstanceComp>
- <doc:OperatorsMembership>
- <doc:OperatorsLike>

- <doc:OperatorsBinary>
- <doc:OperatorsLogical>
- <doc:OperatorsString>
- <doc:OperatorsAggregate>
- <doc:OperatorsComplexConstruction>

