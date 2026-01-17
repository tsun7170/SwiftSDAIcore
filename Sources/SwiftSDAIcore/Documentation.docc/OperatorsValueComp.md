# Value Comparison Operators

value comparison operators as defined in section 12.2.1 of ISO 10303-21

## Overview

The value-comparison operators are:
- equal (.==.);
- not equal (.!=.);
- greater than (>);
- less than (<);
- greater than or equal (>=);
- less than or equal (<=).

These operators may be applied to numeric, logical, string, and binary operands. These operators may also be applied to enumeration items declared in enumerations that are not extensible and that are not based on extensible enumerations. In addition,.==. and .!=. may be applied to values of aggregate and entity data types (NOT IMPLEMENTED: and enumeration items declared in extensible enumerations or enumerations based on extensible enumerations). See 12.11.

For two given values, a and b, a .!=. b is equivalent to NOT (a .==. b) for all data types. If a and b are neither aggregation nor entity data types, in addition:
- a) one of the following is true: a < b, a .==. b or a > b
- b) a <= b is equivalent to (a < b) OR (a .==. b)
- c) a >= b is equivalent to (a > b) OR (a .==. b)

## Topics

### Generic Value Comparison
as defined in section 12.2.1 of ISO 10303-21

- ``.==.(_:_:)-(SDAI.GENERIC?,SDAI.GENERIC?)``
- ``.!=.(_:_:)-(SDAI.GENERIC?,SDAI.GENERIC?)``
- ``>(_:_:)-(SDAI.GENERIC?,SDAI.GENERIC?)``
- ``<(_:_:)-(SDAI.GENERIC?,SDAI.GENERIC?)``
- ``>=(_:_:)-(SDAI.GENERIC?,SDAI.GENERIC?)``
- ``<=(_:_:)-(SDAI.GENERIC?,SDAI.GENERIC?)``


### Numeric Value Comparison
as defined in section 12.2.1.1 of ISO 10303-21

- ``.==.(_:_:)-(TI?,UI?)``
- ``.==.(_:_:)-(TI?,UD?)``
- ``.==.(_:_:)-(TD?,UD?)``
- ``.==.(_:_:)-(TD?,UI?)``
- ``.==.(_:_:)-(TI?,US?)``
- ``.==.(_:_:)-(TD?,US?)``
- ``.==.(_:_:)-(TS?,US?)``
- ``.==.(_:_:)-(TS?,UI?)``
- ``.==.(_:_:)-(TS?,UD?)``

- ``.!=.(_:_:)-(TI?,UI?)``
- ``.!=.(_:_:)-(TI?,UD?)``
- ``.!=.(_:_:)-(TD?,UD?)``
- ``.!=.(_:_:)-(TD?,UI?)``
- ``.!=.(_:_:)-(TI?,US?)``
- ``.!=.(_:_:)-(TD?,US?)``
- ``.!=.(_:_:)-(TS?,US?)``
- ``.!=.(_:_:)-(TS?,UI?)``
- ``.!=.(_:_:)-(TS?,UD?)``

- ``>(_:_:)-(TI?,UI?)``
- ``>(_:_:)-(TI?,UD?)``
- ``>(_:_:)-(TD?,UD?)``
- ``>(_:_:)-(TD?,UI?)``
- ``>(_:_:)-(TI?,US?)``
- ``>(_:_:)-(TD?,US?)``
- ``>(_:_:)-(TS?,US?)``
- ``>(_:_:)-(TS?,UI?)``
- ``>(_:_:)-(TS?,UD?)``

- ``<(_:_:)-(TI?,UI?)``
- ``<(_:_:)-(TI?,UD?)``
- ``<(_:_:)-(TD?,UD?)``
- ``<(_:_:)-(TD?,UI?)``
- ``<(_:_:)-(TI?,US?)``
- ``<(_:_:)-(TD?,US?)``
- ``<(_:_:)-(TS?,US?)``
- ``<(_:_:)-(TS?,UI?)``
- ``<(_:_:)-(TS?,UD?)``

- ``>=(_:_:)-(TI?,UI?)``
- ``>=(_:_:)-(TI?,UD?)``
- ``>=(_:_:)-(TD?,UD?)``
- ``>=(_:_:)-(TD?,UI?)``
- ``>=(_:_:)-(TI?,US?)``
- ``>=(_:_:)-(TD?,US?)``
- ``>=(_:_:)-(TS?,US?)``
- ``>=(_:_:)-(TS?,UI?)``
- ``>=(_:_:)-(TS?,UD?)``

- ``<=(_:_:)-(TI?,UI?)``
- ``<=(_:_:)-(TI?,UD?)``
- ``<=(_:_:)-(TD?,UD?)``
- ``<=(_:_:)-(TD?,UI?)``
- ``<=(_:_:)-(TI?,US?)``
- ``<=(_:_:)-(TD?,US?)``
- ``<=(_:_:)-(TS?,US?)``
- ``<=(_:_:)-(TS?,UI?)``
- ``<=(_:_:)-(TS?,UD?)``



### Binary Value Comparison
as defined in section 12.2.1.2 of ISO 10303-21

- ``.==.(_:_:)-(TBi?,UBi?)``
- ``.==.(_:_:)-(TBi?,US?)``
- ``.==.(_:_:)-(TS?,UBi?)``

- ``.!=.(_:_:)-(TBi?,UBi?)``
- ``.!=.(_:_:)-(TBi?,US?)``
- ``.!=.(_:_:)-(TS?,UBi?)``

- ``>(_:_:)-(TBi?,UBi?)``
- ``>(_:_:)-(TBi?,US?)``
- ``>(_:_:)-(TS?,UBi?)``

- ``<(_:_:)-(TBi?,UBi?)``
- ``<(_:_:)-(TBi?,US?)``
- ``<(_:_:)-(TS?,UBi?)``

- ``>=(_:_:)-(TBi?,UBi?)``
- ``>=(_:_:)-(TBi?,US?)``
- ``>=(_:_:)-(TS?,UBi?)``

- ``<=(_:_:)-(TBi?,UBi?)``
- ``<=(_:_:)-(TBi?,US?)``
- ``<=(_:_:)-(TS?,UBi?)``


### Logical Value Comparison
as defined in section 12.2.1.3 of ISO 10303-21

- ``.==.(_:_:)-(TLo?,ULo?)``
- ``.==.(_:_:)-(TLo?,US?)``
- ``.==.(_:_:)-(TS?,ULo?)``

- ``.!=.(_:_:)-(TLo?,ULo?)``
- ``.!=.(_:_:)-(TLo?,US?)``
- ``.!=.(_:_:)-(TS?,ULo?)``

- ``>(_:_:)-(TLo?,ULo?)``
- ``>(_:_:)-(TLo?,US?)``
- ``>(_:_:)-(TS?,ULo?)``

- ``<(_:_:)-(TLo?,ULo?)``
- ``<(_:_:)-(TLo?,US?)``
- ``<(_:_:)-(TS?,ULo?)``

- ``>=(_:_:)-(TLo?,ULo?)``
- ``>=(_:_:)-(TLo?,US?)``
- ``>=(_:_:)-(TS?,ULo?)``

- ``<=(_:_:)-(TLo?,ULo?)``
- ``<=(_:_:)-(TLo?,US?)``
- ``<=(_:_:)-(TS?,ULo?)``


### String Value Comparison
as defined in section 12.2.1.4 of ISO 10303-21

- ``.==.(_:_:)-(TSt?,USt?)``
- ``.==.(_:_:)-(TSt?,US?)``
- ``.==.(_:_:)-(TS?,USt?)``

- ``.!=.(_:_:)-(TSt?,USt?)``
- ``.!=.(_:_:)-(TSt?,US?)``
- ``.!=.(_:_:)-(TS?,USt?)``

- ``>(_:_:)-(TSt?,USt?)``
- ``>(_:_:)-(TSt?,US?)``
- ``>(_:_:)-(TS?,USt?)``

- ``<(_:_:)-(TSt?,USt?)``
- ``<(_:_:)-(TSt?,US?)``
- ``<(_:_:)-(TS?,USt?)``

- ``>=(_:_:)-(TSt?,USt?)``
- ``>=(_:_:)-(TSt?,US?)``
- ``>=(_:_:)-(TS?,USt?)``

- ``<=(_:_:)-(TSt?,USt?)``
- ``<=(_:_:)-(TSt?,US?)``
- ``<=(_:_:)-(TS?,USt?)``


### Enumeration Item Value Comparison
as defined in section 12.2.1.5 of ISO 10303-21

- ``.==.(_:_:)-(TE?,UE?)``
- ``.==.(_:_:)-(TE?,US?)``
- ``.==.(_:_:)-(TS?,UE?)``

- ``.!=.(_:_:)-(TE?,UE?)``
- ``.!=.(_:_:)-(TE?,US?)``
- ``.!=.(_:_:)-(TS?,UE?)``

- ``>(_:_:)-(TE?,UE?)``
- ``>(_:_:)-(TE?,US?)``
- ``>(_:_:)-(TS?,UE?)``

- ``<(_:_:)-(TE?,UE?)``
- ``<(_:_:)-(TE?,US?)``
- ``<(_:_:)-(TS?,UE?)``

- ``>=(_:_:)-(TE?,UE?)``
- ``>=(_:_:)-(TE?,US?)``
- ``>=(_:_:)-(TS?,UE?)``

- ``<=(_:_:)-(TE?,UE?)``
- ``<=(_:_:)-(TE?,US?)``
- ``<=(_:_:)-(TS?,UE?)``


### Aggregate Value Comparison
as defined in section 12.2.1.6 of ISO 10303-21

- ``.==.(_:_:)-(TA?,UA?)``
- ``.==.(_:_:)-(TA?,US?)``
- ``.==.(_:_:)-(TS?,UA?)``
- ``.==.(_:_:)-(TL?,UL?)``
- ``.==.(_:_:)-(TL?,UG?)``
- ``.==.(_:_:)-(TG?,UL?)``
- ``.==.(_:_:)-(TL?,US?)``
- ``.==.(_:_:)-(TS?,UL?)``
- ``.==.(_:_:)-(TB?,UB?)``
- ``.==.(_:_:)-(TB?,US?)``
- ``.==.(_:_:)-(TS?,UB?)``
- ``.==.(_:_:)-(TB?,UG?)``
- ``.==.(_:_:)-(TG?,UB?)``

- ``.!=.(_:_:)-(TA?,UA?)``
- ``.!=.(_:_:)-(TA?,US?)``
- ``.!=.(_:_:)-(TS?,UA?)``
- ``.!=.(_:_:)-(TL?,UL?)``
- ``.!=.(_:_:)-(TL?,UG?)``
- ``.!=.(_:_:)-(TG?,UL?)``
- ``.!=.(_:_:)-(TL?,US?)``
- ``.!=.(_:_:)-(TS?,UL?)``
- ``.!=.(_:_:)-(TB?,UB?)``
- ``.!=.(_:_:)-(TB?,US?)``
- ``.!=.(_:_:)-(TS?,UB?)``
- ``.!=.(_:_:)-(TB?,UG?)``
- ``.!=.(_:_:)-(TG?,UB?)``

### Entity Value Comparison
as defined in section 12.2.1.7 of ISO 10303-21

- ``.==.(_:_:)-(SDAI.EntityReference?,SDAI.EntityReference?)``
- ``.==.(_:_:)-(SDAI.EntityReference?,US?)``
- ``.==.(_:_:)-(TS?,SDAI.EntityReference?)``
- ``.==.(_:_:)-(SDAI.PersistentEntityReference<T>?,SDAI.PersistentEntityReference<U>?)``
- ``.==.(_:_:)-(SDAI.PersistentEntityReference<T>?,SDAI.EntityReference?)``
- ``.==.(_:_:)-(SDAI.EntityReference?,SDAI.PersistentEntityReference<U>?)``
- ``.==.(_:_:)-(SDAI.PersistentEntityReference<T>?,US?)``
- ``.==.(_:_:)-(TS?,SDAI.PersistentEntityReference<U>?)``

- ``.!=.(_:_:)-(SDAI.EntityReference?,SDAI.EntityReference?)``
- ``.!=.(_:_:)-(SDAI.EntityReference?,US?)``
- ``.!=.(_:_:)-(TS?,SDAI.EntityReference?)``
- ``.!=.(_:_:)-(SDAI.PersistentEntityReference<T>?,SDAI.PersistentEntityReference<U>?)``
- ``.!=.(_:_:)-(SDAI.PersistentEntityReference<T>?,SDAI.EntityReference?)``
- ``.!=.(_:_:)-(SDAI.EntityReference?,SDAI.PersistentEntityReference<U>?)``
- ``.!=.(_:_:)-(SDAI.PersistentEntityReference<T>?,US?)``
- ``.!=.(_:_:)-(TS?,SDAI.PersistentEntityReference<U>?)``



