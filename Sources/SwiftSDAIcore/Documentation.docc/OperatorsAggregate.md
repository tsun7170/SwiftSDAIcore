# Aggregate Operators

aggregate operators as defined in section 12.6 of ISO 10303-21

## Overview

The aggregate operators are indexing (\[ \]), intersection (\*), union (\+), difference (\-), subset (\<\=), superset (\>\=) and query. These operators are defined in the following subclauses. The relational operators equal (\=), not equal (\<\>), instance equal (\:\=\:), instance not equal (:<>:) and in, defined in 12.2, are also applicable to all aggregate values.

NOTE Several of the aggregate operations require implicit comparisons of the elements contained within aggregate values; instance comparison is used in all such cases.


## Topics

### Intersection Operators 
as defined in section 12.6.2 of ISO 10303-21

- ``*(_:_:)->SDAI.BAG<T1.ELEMENT>?``
- ``*(_:_:)->SDAI.SET<T2.ELEMENT>?``
- ``*(_:_:)->SDAI.SET<T3.ELEMENT>?``
- ``*(_:_:)->SDAI.BAG<T4.ELEMENT>?``
- ``*(_:_:)->SDAI.BAG<U5.ELEMENT>?``
- ``*(_:_:)->SDAI.SET<T6.ELEMENT>?``
- ``*(_:_:)->SDAI.SET<U7.ELEMENT>?``

### Union Operators

### Difference Operators

### Subset Operator

### Superset Operator

