# Complex Entity Instance Construction Operator

complex entity instance construction operator as defined in section 12.10 of ISO 10303-21

## Overview

The complex entity instance construction operator (||) constructs an instance of a complex entity by combining the partial complex entity values. The partial complex entity values may be combined in any order. A complex entity instance construction operator expression evaluates to either a partial complex entity value or a complex entity instance. A partial complex entity data type may only occur once within one level of an entity instance construction operator expression. A partial complex entity value may occur at different levels if these are nested, that is, if a partial complex entity value is being used to construct a complex entity instance which plays the role of an attribute within partial complex entity value being combined to form the complex entity instance. If either of the operands evaluates to indeterminate (?), the expression evaluates to indeterminate (?). See annex B for further information on complex entity instances.

If an entity instance or a part of an entity instance (via a group reference) is used as the operand of a complex entity constructor then a shallow copy (see 9.2.6) of that instance or its attributes are used.

## Topics

### partialEntity .||. xxx
- ``.||.(_:_:)-(SDAI.PartialEntity,SDAI.PartialEntity)``
- ``.||.(_:_:)-(SDAI.PartialEntity,SDAI.EntityReference?)``
- ``.||.(_:_:)-(SDAI.PartialEntity,SDAI.ComplexEntity)``
- ``.||.(_:_:)-(SDAI.PartialEntity,SDAI.PersistentEntityReference<R>?)``

### entityRef .||. xxx
- ``.||.(_:_:)-(SDAI.EntityReference?,SDAI.PartialEntity)``
- ``.||.(_:_:)-(SDAI.EntityReference?,SDAI.EntityReference?)``
- ``.||.(_:_:)-(SDAI.EntityReference?,SDAI.ComplexEntity)``
- ``.||.(_:_:)-(SDAI.EntityReference?,SDAI.PersistentEntityReference<R>?)``

### complexEntity .||. xxx
- ``.||.(_:_:)-(SDAI.ComplexEntity,SDAI.PartialEntity)``
- ``.||.(_:_:)-(SDAI.ComplexEntity,SDAI.EntityReference?)``
- ``.||.(_:_:)-(SDAI.ComplexEntity,SDAI.ComplexEntity)``
- ``.||.(_:_:)-(SDAI.ComplexEntity,SDAI.PersistentEntityReference<R>?)``

### persistentReference .||. xxx
- ``.||.(_:_:)-(SDAI.PersistentEntityReference<L>?,SDAI.PartialEntity)``
- ``.||.(_:_:)-(SDAI.PersistentEntityReference<L>?,SDAI.EntityReference?)``
- ``.||.(_:_:)-(SDAI.PersistentEntityReference<L>?,SDAI.ComplexEntity)``
- ``.||.(_:_:)-(_,SDAI.PersistentEntityReference<R>)``
