# SwiftSDAIcore
The runtime environment for the exp2swift translated EXPRESS codes.

by Tsutomu Yoshida, Minokamo Japan.

This package implements the runtime foundation functionalities required for the exp2swift translated ISO 10303 STEP schema files into the Swift programing language.
Specifically,
* all built-in data types, functions and procedures defined in ISO 10303-11 EXPRESS language.
* part of SDAI schemas defined in ISO 10303-22, of which make sense in the Swift environment for importing ISO 10303-21 exchange structure (P21-export of the STEP entities is out of scope).
* basic functionalities to import ISO 10303-21 exchange structure files.


### SDAI Implementation Level

per §13 ISO 10303-22:1998

**Levels of Transaction (13.1.1):  Level 3 (Transactions)**  
support of the persistent label operations and of the session transaction operations not the SDAI-model save and undo operations.

**Levels of Expression Evaluation for Validation and Derived Attributes (13.1.2): Level 4 (Complete Evaluation)**  
support for SDAI Query   
support for Find Entity Instance Users  
support for an application schema defined function 
support for the EXPRESS USEDIN built-in function
support for the EXPRESS ROLESOF built-in function 

support for the complete set of validation operations  
  Validate Where Rule  
  Validate Schema Instance   
  Validate Global Rule  
  Validate Aggregate Size   
  Validate Real Precision  
  Validate String Width    
  Validate Binary Width  

access to the SDAI dictionary entity instances   
get attribute of derived attributes  
get attribute of inverse attributes defined in application schemas   
get attribute operation on all attributes
get complex Entity Definition 

**Levels of Session Event Recording Support (13.1.3): Level 2 (Recording Supported)**   
support for the session event recording function. Every operation that generates an error creates an instance of error_event and that instance is appended to the sdai_session.errors list.

**Levels of Scope Support (13.1.4): Level 1 (No SCOPE)**  
no support for the scope operations, since the released ISO 10303-21 standard does not contain SCOPE construct.

**Levels of Domain Equivalence Support (13.1.5): Level 1 (No Domain Equivalence)**
no support for the declaration of domain equivalent entity types and their use by application instances based upon different schema definitions.



## swift STEP code suite
* [SwiftSDAIcore](https://github.com/tsun7170/SwiftSDAIcore)
* [SwiftSDAIap242](https://github.com/tsun7170/SwiftSDAIap242)
* [SwiftAP242PDMkit](https://github.com/tsun7170/SwiftAP242PDMkit)
* [simpleP21ReadSample](https://github.com/tsun7170/simpleP21ReadSample)
* [multipleP21ReadsSample](https://github.com/tsun7170/multipleP21ReadsSample)
* [STEPswiftcode/exp2swift](https://github.com/tsun7170/STEPswiftcode)


## Development environment
* Xcode version 26.2
* macOS Tahoe 26.2
