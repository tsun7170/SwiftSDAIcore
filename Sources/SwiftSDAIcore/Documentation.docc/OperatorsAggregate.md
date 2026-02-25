# Aggregate Operators

aggregate operators as defined in section 12.6 of ISO 10303-21

## Overview

The aggregate operators are indexing (\[ \]), intersection (\*), union (\+), difference (\-), subset (\<\=), superset (\>\=) and query. These operators are defined in the following subclauses. The relational operators equal (\=), not equal (\<\>), instance equal (\:\=\:), instance not equal (:<>:) and in, defined in 12.2, are also applicable to all aggregate values.

NOTE Several of the aggregate operations require implicit comparisons of the elements contained within aggregate values; instance comparison is used in all such cases.


## Topics
### Aggregate Indexing
as defined in section 12.6.1 of ISO 10303-21

- ``SDAI/AggregateIndexingSettable/subscript(_:)-(Int?)``
- ``SDAI/AggregateIndexingSettable/subscript(_:)-(I?)``

### Intersection Operators 
as defined in section 12.6.2 of ISO 10303-21

- ``*(_:_:)-(T1?,U1?)->SDAI.BAG<T1.ELEMENT>?``
- ``*(_:_:)->SDAI.SET<T2.ELEMENT>?``
- ``*(_:_:)-(T3?,U3?)->SDAI.SET<T3.ELEMENT>?``
- ``*(_:_:)->SDAI.BAG<T4.ELEMENT>?``
- ``*(_:_:)->SDAI.BAG<U5.ELEMENT>?``
- ``*(_:_:)->SDAI.SET<T6.ELEMENT>?``
- ``*(_:_:)->SDAI.SET<U7.ELEMENT>?``
- ``*(_:_:)->SDAI.BAG<T8.ELEMENT>?``
- ``*(_:_:)->SDAI.BAG<U9.ELEMENT>?``
- ``*(_:_:)->SDAI.SET<T10.ELEMENT>?``
- ``*(_:_:)->SDAI.SET<U11.ELEMENT>?``

### Union Operators
as defined in section 12.6.3 of ISO 10303-21

- ``+(_:_:)->SDAI.BAG<T1.ELEMENT>?``
- ``+(_:_:)->SDAI.BAG<T2.ELEMENT>?``

- ``+(_:_:)->SDAI.BAG<T3.ELEMENT>?``
- ``+(_:_:)->SDAI.BAG<T4.ELEMENT>?``
- ``+(_:_:)->SDAI.BAG<T5.ELEMENT>?``
- ``+(_:_:)->SDAI.BAG<T6.ELEMENT>?``
- ``+(_:_:)->SDAI.BAG<T7.ELEMENT>?``
- ``+(_:_:)->SDAI.BAG<T8.ELEMENT>?``

- ``+(_:_:)->SDAI.BAG<U11.ELEMENT>?``
- ``+(_:_:)->SDAI.BAG<U12.ELEMENT>?``
- ``+(_:_:)->SDAI.BAG<U13.ELEMENT>?``
- ``+(_:_:)->SDAI.BAG<U14.ELEMENT>?``
- ``+(_:_:)->SDAI.BAG<U15.ELEMENT>?``
- ``+(_:_:)->SDAI.BAG<U16.ELEMENT>?``

- ``+(_:_:)->SDAI.SET<T19.ELEMENT>?``
- ``+(_:_:)->SDAI.SET<T20.ELEMENT>?``

- ``+(_:_:)->SDAI.SET<T21.ELEMENT>?``
- ``+(_:_:)->SDAI.SET<T22.ELEMENT>?``
- ``+(_:_:)->SDAI.SET<T23.ELEMENT>?``
- ``+(_:_:)->SDAI.SET<T24.ELEMENT>?``
- ``+(_:_:)->SDAI.SET<T25.ELEMENT>?``
- ``+(_:_:)->SDAI.SET<T26.ELEMENT>?``

- ``+(_:_:)->SDAI.SET<U29.ELEMENT>?``
- ``+(_:_:)->SDAI.SET<U30.ELEMENT>?``
- ``+(_:_:)->SDAI.SET<U31.ELEMENT>?``
- ``+(_:_:)->SDAI.SET<U32.ELEMENT>?``
- ``+(_:_:)->SDAI.SET<U33.ELEMENT>?``
- ``+(_:_:)->SDAI.SET<U34.ELEMENT>?``

- ``+(_:_:)->SDAI.LIST<T37.ELEMENT>?``

- ``+(_:_:)->SDAI.LIST<T38.ELEMENT>?``
- ``+(_:_:)->SDAI.LIST<T39.ELEMENT>?``
- ``+(_:_:)->SDAI.LIST<T40.ELEMENT>?``
- ``+(_:_:)->SDAI.LIST<T41.ELEMENT>?``
- ``+(_:_:)->SDAI.LIST<T42.ELEMENT>?``
- ``+(_:_:)->SDAI.LIST<T43.ELEMENT>?``
- ``+(_:_:)->SDAI.LIST<T44.ELEMENT>?``

- ``+(_:_:)->SDAI.LIST<U46.ELEMENT>?``
- ``+(_:_:)->SDAI.LIST<U47.ELEMENT>?``
- ``+(_:_:)->SDAI.LIST<U48.ELEMENT>?``
- ``+(_:_:)->SDAI.LIST<U49.ELEMENT>?``
- ``+(_:_:)->SDAI.LIST<U50.ELEMENT>?``
- ``+(_:_:)->SDAI.LIST<U51.ELEMENT>?``

- ``+(_:_:)->SDAI.BAG<T54.ELEMENT>?``

- ``+(_:_:)->SDAI.BAG<U55.ELEMENT>?``

- ``+(_:_:)->SDAI.SET<T56.ELEMENT>?``

- ``+(_:_:)->SDAI.SET<U57.ELEMENT>?``

- ``+(_:_:)->SDAI.LIST<T58.ELEMENT>?``

- ``+(_:_:)->SDAI.LIST<U59.ELEMENT>?``


### Difference Operators
as defined in section 12.6.4 of ISO 10303-21

- ``-(_:_:)->SDAI.BAG<T1.ELEMENT>?``

- ``-(_:_:)->SDAI.BAG<T2.ELEMENT>?``
- ``-(_:_:)->SDAI.BAG<T3.ELEMENT>?``
- ``-(_:_:)->SDAI.BAG<T4.ELEMENT>?``
- ``-(_:_:)->SDAI.BAG<T5.ELEMENT>?``
- ``-(_:_:)->SDAI.BAG<T6.ELEMENT>?``
- ``-(_:_:)->SDAI.BAG<T7.ELEMENT>?``

- ``-(_:_:)->SDAI.SET<T10.ELEMENT>?``

- ``-(_:_:)->SDAI.SET<T11.ELEMENT>?``
- ``-(_:_:)->SDAI.SET<T12.ELEMENT>?``
- ``-(_:_:)->SDAI.SET<T13.ELEMENT>?``
- ``-(_:_:)->SDAI.SET<T14.ELEMENT>?``
- ``-(_:_:)->SDAI.SET<T15.ELEMENT>?``
- ``-(_:_:)->SDAI.SET<T16.ELEMENT>?``

- ``-(_:_:)->SDAI.BAG<T19.ELEMENT>?``
- ``-(_:_:)->SDAI.SET<T20.ELEMENT>?``

### Subset Operator
as defined in section 12.6.5 of ISO 10303-21

- ``<=(_:_:)-(TB?,UB?)``
- ``<=(_:_:)-(TB?,US?)``
- ``<=(_:_:)-(TS?,UB?)``

### Superset Operator
as defined in section 12.6.6 of ISO 10303-21

- ``>=(_:_:)-(TB?,UB?)``
- ``>=(_:_:)-(TB?,US?)``
- ``>=(_:_:)-(TS?,UB?)``

### Query Expression
as defined in section 12.6.7 of ISO 10303-21

- ``SDAI/AggregationType/QUERY(logical_expression:)``
