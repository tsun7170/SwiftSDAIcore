# Instance Comparison Operators

instance comparison operators as defined in section 12.2.2 of ISO 10303-21

## Overview

The instance comparison operators are:
— instance equal (:=:);
— instance not equal (:<>:).

These operators may be applied to numeric, logical, string, binary, enumeration, aggregate and entity data type operands. The two operands of an instance comparison operator shall be data type compatible. See 12.11.

For two given operands, a and b, (a :<>: b) is equivalent to NOT (a :=: b) for all data types.

The instance comparison operators when applied to numeric, logical, string, binary and enumeration data types are equivalent to the corresponding value comparison operators. That is, (a :=: b) is equivalent to (a = b) and (a :<>: b) is equivalent to (a <> b) for these data types.

## Topics

### Aggregate Instance Comparison
as defined in section 12.2.2.1 of ISO 10303-21

- ``.===.(_:_:)-(TA?,UA?)``
- ``.===.(_:_:)-(TA?,US?)``
- ``.===.(_:_:)-(TS?,UA?)``
- ``.===.(_:_:)-(TL?,UL?)``
- ``.===.(_:_:)-(TL?,UG?)``
- ``.===.(_:_:)-(TG?,UL?)``
- ``.===.(_:_:)-(TL?,US?)``
- ``.===.(_:_:)-(TS?,UL?)``
- ``.===.(_:_:)-(TB?,UB?)``
- ``.===.(_:_:)-(TB?,US?)``
- ``.===.(_:_:)-(TS?,UB?)``
- ``.===.(_:_:)-(TB?,UG?)``
- ``.===.(_:_:)-(TG?,UB?)``

- ``.!==.(_:_:)-(TA?,UA?)``
- ``.!==.(_:_:)-(TA?,US?)``
- ``.!==.(_:_:)-(TS?,UA?)``
- ``.!==.(_:_:)-(TL?,UL?)``
- ``.!==.(_:_:)-(TL?,UG?)``
- ``.!==.(_:_:)-(TG?,UL?)``
- ``.!==.(_:_:)-(TL?,US?)``
- ``.!==.(_:_:)-(TS?,UL?)``
- ``.!==.(_:_:)-(TB?,UB?)``
- ``.!==.(_:_:)-(TB?,US?)``
- ``.!==.(_:_:)-(TS?,UB?)``
- ``.!==.(_:_:)-(TB?,UG?)``
- ``.!==.(_:_:)-(TG?,UB?)``


### Entity Instance Comparison
as defined in section 12.2.2.2 of ISO 10303-21

- ``.===.(_:_:)-(SDAI.EntityReference?,SDAI.EntityReference?)``
- ``.===.(_:_:)-(SDAI.EntityReference?,US?)``
- ``.===.(_:_:)-(TS?,SDAI.EntityReference?)``
- ``.===.(_:_:)-(SDAI.PartialEntity?,SDAI.PartialEntity?)``
- ``.===.(_:_:)-(SDAI.PersistentEntityReference<T>?,SDAI.PersistentEntityReference<U>?)``
- ``.===.(_:_:)-(SDAI.PersistentEntityReference<T>?,SDAI.EntityReference?)``
- ``.===.(_:_:)-(SDAI.EntityReference?,SDAI.PersistentEntityReference<U>?)``
- ``.===.(_:_:)-(SDAI.PersistentEntityReference<T>?,US?)``
- ``.===.(_:_:)-(TS?,SDAI.PersistentEntityReference<U>?)``

- ``.!==.(_:_:)-(SDAI.EntityReference?,SDAI.EntityReference?)``
- ``.!==.(_:_:)-(SDAI.EntityReference?,US?)``
- ``.!==.(_:_:)-(TS?,SDAI.EntityReference?)``
- ``.!==.(_:_:)-(SDAI.PartialEntity?,SDAI.PartialEntity?)``
- ``.!==.(_:_:)-(SDAI.PersistentEntityReference<T>?,SDAI.PersistentEntityReference<U>?)``
- ``.!==.(_:_:)-(SDAI.PersistentEntityReference<T>?,SDAI.EntityReference?)``
- ``.!==.(_:_:)-(SDAI.EntityReference?,SDAI.PersistentEntityReference<U>?)``
- ``.!==.(_:_:)-(SDAI.PersistentEntityReference<T>?,US?)``
- ``.!==.(_:_:)-(TS?,SDAI.PersistentEntityReference<U>?)``


### Simple Type Instance Comparison
as defined in section 12.2.2 of ISO 10303-21

- ``.===.(_:_:)-(TI?,UI?)``
- ``.===.(_:_:)-(TI?,UD?)``
- ``.===.(_:_:)-(TD?,UD?)``
- ``.===.(_:_:)-(TD?,UI?)``
- ``.===.(_:_:)-(TI?,US?)``
- ``.===.(_:_:)-(TD?,US?)``
- ``.===.(_:_:)-(TS?,UI?)``
- ``.===.(_:_:)-(TS?,UD?)``
- ``.===.(_:_:)-(TLo?,ULo?)``
- ``.===.(_:_:)-(TLo?,US?)``
- ``.===.(_:_:)-(TS?,ULo?)``
- ``.===.(_:_:)-(TSt?,USt?)``
- ``.===.(_:_:)-(TSt?,US?)``
- ``.===.(_:_:)-(TS?,USt?)``
- ``.===.(_:_:)-(TBi?,UBi?)``
- ``.===.(_:_:)-(TBi?,US?)``
- ``.===.(_:_:)-(TS?,UBi?)``
- ``.===.(_:_:)-(TE?,UE?)``
- ``.===.(_:_:)-(TE?,US?)``
- ``.===.(_:_:)-(TS?,UE?)``
- ``.===.(_:_:)-(TS?,US?)``
- ``.===.(_:_:)-(SDAI.GENERIC?,SDAI.GENERIC?)``

- ``.!==.(_:_:)-(TI?,UI?)``
- ``.!==.(_:_:)-(TI?,UD?)``
- ``.!==.(_:_:)-(TD?,UD?)``
- ``.!==.(_:_:)-(TD?,UI?)``
- ``.!==.(_:_:)-(TI?,US?)``
- ``.!==.(_:_:)-(TD?,US?)``
- ``.!==.(_:_:)-(TS?,UI?)``
- ``.!==.(_:_:)-(TS?,UD?)``
- ``.!==.(_:_:)-(TLo?,ULo?)``
- ``.!==.(_:_:)-(TLo?,US?)``
- ``.!==.(_:_:)-(TS?,ULo?)``
- ``.!==.(_:_:)-(TSt?,USt?)``
- ``.!==.(_:_:)-(TSt?,US?)``
- ``.!==.(_:_:)-(TS?,USt?)``
- ``.!==.(_:_:)-(TBi?,UBi?)``
- ``.!==.(_:_:)-(TBi?,US?)``
- ``.!==.(_:_:)-(TS?,UBi?)``
- ``.!==.(_:_:)-(TE?,UE?)``
- ``.!==.(_:_:)-(TE?,US?)``
- ``.!==.(_:_:)-(TS?,UE?)``
- ``.!==.(_:_:)-(TS?,US?)``
- ``.!==.(_:_:)-(SDAI.GENERIC?,SDAI.GENERIC?)``
