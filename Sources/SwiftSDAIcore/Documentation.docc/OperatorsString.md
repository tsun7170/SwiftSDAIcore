# String Operators

string operators as defined in section 12.5 of ISO 10303-21

## Overview

In addition to the relational operators defined in 12.2.1.4 and 12.2.5, two further operations are defined for string types: indexing ([ ]) and concatenation (+) .

## Topics

### String Indexing
as defined in section 12.5.1 of ISO 10303-21

- ``SDAI/StringType/subscript(_:)-(I?)``
- ``SDAI/StringType/subscript(_:)-(Int?)``
- ``SDAI/StringType/subscript(_:)-(ClosedRange<Int>?)``

- ``...(_:_:)-(T1?,_)``
- ``...(_:_:)-(T2?,_)``
- ``...(_:_:)-(_,U3?)``

### String Concatenation Operator 
as defined in section 12.3.2 of ISO 10303-21

- ``+(_:_:)-(T1?,U1?)->SDAI.STRING?``
- ``+(_:_:)-(T2?,U2?)->SDAI.STRING?``
- ``+(_:_:)-(T3?,U3?)->SDAI.STRING?``
- ``+(_:_:)-(T4?,_)->SDAI.STRING?``
- ``+(_:_:)-(_,U5?)->SDAI.STRING?``
