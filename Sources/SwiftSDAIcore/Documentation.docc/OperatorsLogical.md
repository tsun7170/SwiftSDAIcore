# Logical Operators

arithmetic operators as defined in section 12.4 of ISO 10303-21

## Overview

The logical operators consist of not, and, or and xor. Each produces a logical result. The and, or and xor operators require two logical operands, and the not operator requires one logical operand. If either of the operands evaluates to indeterminate (?), that operand is dealt with as if it were the logical value unknown.

## Topics

### NOT Operators 
as defined in section 12.4.1 of ISO 10303-21

- ``!(_:)-(T1?)``
- ``!(_:)-(T2)``
- ``!(_:)-(T3?)``


### AND Operators 
as defined in section 12.4.2 of ISO 10303-21

- ``&&(_:_:)-(T1?,_)``
- ``&&(_:_:)-(T2,_)``
- ``&&(_:_:)-(T3?,_)``
- ``&&(_:_:)-(T4,_)``
- ``&&(_:_:)-(T5?,_)``
- ``&&(_:_:)-(T6?,_)``
- ``&&(_:_:)-(T7?,_)``

### OR Operators 
as defined in section 12.4.3 of ISO 10303-21

- ``||(_:_:)-(T1?,_)``
- ``||(_:_:)-(T2,_)``
- ``||(_:_:)-(T3?,_)``
- ``||(_:_:)-(T4,_)``
- ``||(_:_:)-(T5?,_)``
- ``||(_:_:)-(T6?,_)``
- ``||(_:_:)-(T7?,_)``

### XOR Operators 
as defined in section 12.4.4 of ISO 10303-21


- ``.!=.(_:_:)-(TLo?,ULo?)``
- ``.!=.(_:_:)-(TLo?,US?)``
- ``.!=.(_:_:)-(TS?,ULo?)``

