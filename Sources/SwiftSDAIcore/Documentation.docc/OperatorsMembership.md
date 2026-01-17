# Membership Operator

aggregate membership operator as defined in section 12.2.3 of ISO 10303-21

## Overview

The membership operator in tests an item for membership in some aggregate and evaluates to a logical value. The right-hand operand shall evaluate to a value of an aggregation data type, and the left-hand operand shall be compatible with the base type of this aggregate value.

e IN agg is evaluated as follows:
- a) if either operand is indeterminate (?) the expression evaluates to unknown;
- b) if there exists a member agg[i] such that e :=: agg[i], the expression evaluates to true;
- c) if there exists a member agg[i] which is indeterminate (?) the expression evaluates to unknown;
- d) otherwise the expression evaluates to false.

NOTE The function VALUE_IN (see 15.28) may be used to determine whether or not an element of an aggregation has a specific value.

## Topics

- ``SDAI/AggregationType/CONTAINS(elem:)``

