# Arithmetic Operators

arithmetic operators as defined in section 12.1 of ISO 10303-21

## Overview

Arithmetic operators which require one operand are identity (+) and negation (-). The operand shall be of numeric type (number, integer or real). When the operator is +, the result is equal to the operand, when the operator is-, the result is the negation of the operand. When the operand is indeterminate (?) the result is indeterminate (?) irrespective of which operator is used.

The arithmetic operators which require two operands are addition (+), subtraction (-), multiplication (\*), real division (/), exponentiation (\*\*), integer division (div), and modulo (mod). The operands shall be of numeric type (number, integer or real).

The addition, subtraction, multiplication, division and exponentiation operators perform the mathematical operations of the same name. With the exception of division they produce an integer result if both operands are of data type integer, a real result otherwise (subject to neither operand evaluating to indeterminate (?)). Real division (/) produces a real result (subject to neither operand evaluating to indeterminate (?)).

Modulo and integer division produce an integer result (subject to neither operand evaluating to indeterminate (?)). If either operand is of data type real, it is truncated to an integer before the operation; thus, any fractional part is lost. If a and b are integers, it is always true that (a DIV b)*b + c*(a MOD b) = a, where c=1 for b>=0 and c=-1 for b\<0. The absolute value of a MOD b shall be less than the absolute value of b. The sign of a MOD b shall be the same as the sign of b.

If any operand to an arithmetic operator is indeterminate (?), the result of the operation shall be indeterminate (?).

## Topics

### Identity Operators 
- ``+(_:)``

### Negation Operators 
- ``-(_:)``

### Addition Operators 
- ``+(_:_:)-(TI?,UI?)``
- ``+(_:_:)-(TI?,UD?)``
- ``+(_:_:)-(TD?,UD?)``
- ``+(_:_:)-(TD?,UI?)``
- ``+(_:_:)-(TD?,US?)``
- ``+(_:_:)-(TS?,UD?)``
- ``+(_:_:)-(TI?,US?)``
- ``+(_:_:)-(TS?,UI?)``

### Subtraction Operators 
- ``-(_:_:)-(TI?,UI?)``
- ``-(_:_:)-(TI?,UD?)``
- ``-(_:_:)-(TD?,UD?)``
- ``-(_:_:)-(TD?,UI?)``
- ``-(_:_:)-(TD?,US?)``
- ``-(_:_:)-(TS?,UD?)``
- ``-(_:_:)-(TI?,US?)``
- ``-(_:_:)-(TS?,UI?)``

### Multiplication Operators 
- ``*(_:_:)-(TI?,UI?)``
- ``*(_:_:)-(TI?,UD?)``
- ``*(_:_:)-(TD?,UD?)``
- ``*(_:_:)-(TD?,UI?)``
- ``*(_:_:)-(TD?,US?)``
- ``*(_:_:)-(TS?,UD?)``
- ``*(_:_:)-(TI?,US?)``
- ``*(_:_:)-(TS?,UI?)``

### Real Division Operators 
- ``/(_:_:)-(TI?,UI?)``
- ``/(_:_:)-(TI?,UD?)``
- ``/(_:_:)-(TD?,UD?)``
- ``/(_:_:)-(TD?,UI?)``
- ``/(_:_:)-(TD?,US?)``
- ``/(_:_:)-(TS?,UD?)``
- ``/(_:_:)-(TI?,US?)``
- ``/(_:_:)-(TS?,UI?)``

### Exponentiation Operators 
- ``**(_:_:)-(TI?,UI?)``
- ``**(_:_:)-(TI?,UD?)``
- ``**(_:_:)-(TD?,UD?)``
- ``**(_:_:)-(TD?,UI?)``
- ``**(_:_:)-(TD?,US?)``
- ``**(_:_:)-(TS?,UD?)``
- ``**(_:_:)-(TI?,US?)``
- ``**(_:_:)-(TS?,UI?)``

### Integer Division Operators 
- ``./.(_:_:)-(TI?,UI?)``
- ``./.(_:_:)-(TI?,UD?)``
- ``./.(_:_:)-(TD?,UD?)``
- ``./.(_:_:)-(TD?,UI?)``
- ``./.(_:_:)-(TD?,US?)``
- ``./.(_:_:)-(TS?,UD?)``
- ``./.(_:_:)-(TI?,US?)``
- ``./.(_:_:)-(TS?,UI?)``

### Modulo Operators 
- ``%(_:_:)-(TI?,UI?)``
- ``%(_:_:)-(TI?,UD?)``
- ``%(_:_:)-(TD?,UD?)``
- ``%(_:_:)-(TD?,UI?)``
- ``%(_:_:)-(TD?,US?)``
- ``%(_:_:)-(TS?,UD?)``
- ``%(_:_:)-(TI?,US?)``
- ``%(_:_:)-(TS?,UI?)``
