# Like Operator

string pattern matching operator as defined in section 12.2.5 of ISO 10303-21

## Overview

The like operator compares two string values using the pattern matching algorithm described below and evaluates to a logical value. The left operand is the target string. The right operand is the pattern string.

The pattern matching algorithm is defined as follows. Each character of the pattern string is compared to the corresponding character(s) of the target string. If any pair of corresponding characters does not match, the match fails and the expression evaluates to false.

Certain special characters in the pattern string may match more than one character in the target string. These characters are defined in Table 11. All corresponding characters must be identical or match as defined in Table 11 for the expression to evaluate to true. If either operand is indeterminate (?) the expression evaluates to unknown.

When any of the special pattern matching characters is itself to be matched, the pattern shall contain a pattern escape sequence. A pattern escape sequence shall consist of the escape character (\) followed by the special character to be matched.

## Topics

- ``SDAI/StringType/ISLIKE(PATTERN:)-(T?)``
- ``SDAI/StringType/ISLIKE(PATTERN:)-(String?)``

