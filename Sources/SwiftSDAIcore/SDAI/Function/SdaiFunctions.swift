//
//  SdaiFunctions.swift
//  
//
//  Created by Yoshida on 2020/09/10.
//  Copyright © 2020 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation

//MARK: - ISO 10303-11 (15) Built-in functions

extension SDAI {
	//MARK: ABS function
	/// ISO 10303-11 (15.1) Abs - arithmetic function
	/// 
	/// The ABS function returns the absolute value of a number. 
	/// - Parameter V: V is a number.
	/// - Returns: The absolute value of V. The returned data type is identical to the data type of V.
	public static func ABS<Number: SDAINumberType>(_ V: Number?) -> Number? {
		guard let v = V?.asSwiftType else { return nil }
		return Number( from: abs(v) )  
	}
	/// ISO 10303-11 (15.1) Abs - arithmetic function
	/// 
	/// The ABS function returns the absolute value of a number.
	/// (select type valiant) 
	/// - Parameter V: V is a select type yielding a number value.
	/// - Returns: The absolute value of V. The returned data type is NUMBER.
	public static func ABS<Number: SDAISelectType>(_ V: Number?) -> SDAI.NUMBER? {
		return ABS(V?.numberValue)
	}
	
	//MARK: ACOS function
	/// ISO 10303-11 (15.2) ACos - arithmetic function
	/// 
	/// The ACOS function returns the angle given a cosine value. 
	/// - Parameter V: V is a number which is the cosine of an angle.
	/// - Returns: The angle in radians (0 ≤ result ≤ π) whose cosine is V.
	/// - Conditions: −1.0 ≤ V ≤ 1.0
	public static func ACOS<Number: SwiftDoubleConvertible>(_ V: Number?) -> REAL? {
		guard let r = V?.asSwiftDouble else { return nil }
		return REAL( acos(r) )
	}
	
	//MARK: ASIN function
	/// ISO 10303-11 (15.3) Asin - arithmetic function
	///
	/// The ASIN function returns the angle given a sine value. 
	/// - Parameter V: V is a number which is the sine of an angle.
	/// - Returns: The angle in radians (-π/2 ≤ result ≤ π/2) whose sine is V.
	/// - Conditions : −1.0 ≤ V ≤ 1.0 
	public static func ASIN<Number: SwiftDoubleConvertible>(_ V: Number?) -> REAL? {
		guard let r = V?.asSwiftDouble else { return nil }
		return REAL( asin(r) )
	}
	
	//MARK: ATAN function
	/// ISO 10303-11 (15.4) ATan - arithmetic function
	/// 
	/// The ATAN function returns the angle given a tangent value of V , where V is given by the expression V = V 1/V 2.
	/// - Parameters:
	///   - V1: V1 is a number.
	///   - V2: V2 is a number.
	/// - Returns: The angle in radians (-π/2 ≤ result ≤ π/2) whose tangent is V. If V2 is zero, the result is π/2 or -π/2 depending on the sign of V1.
	/// - Conditions : Both V1 and V2 shall not be zero. 
	public static func ATAN<Number1: SwiftDoubleConvertible, Number2: SwiftDoubleConvertible>
	(V1: Number1?, V2: Number2?) -> REAL? {
		guard let r1 = V1?.asSwiftDouble, let r2 = V2?.asSwiftDouble else { return nil }
		return REAL( atan2(r1, r2) )
	}
	
	//MARK: BLENGTH function
	/// ISO 10303-11 (15.5) BLength - binary function
	/// 
	/// The BLENGTH function returns the number of bits in a binary. 
	/// - Parameter V: V is a binary value.
	/// - Returns: The returned value is the actual number of bits in the binary value passed.
	public static func BLENGTH<Binary: SDAIBinaryType>(_ V:Binary?) -> INTEGER? {
		return INTEGER( V?.blength )
	}
	/// ISO 10303-11 (15.5) BLength - binary function
	/// (select type variant) 
	/// 
	/// The BLENGTH function returns the number of bits in a binary. 
	/// - Parameter V: V is a select type yielding binary value.
	/// - Returns: The returned value is the actual number of bits in the binary value passed.
	public static func BLENGTH<Binary: SDAISelectType>(_ V:Binary?) -> INTEGER? {
		return BLENGTH(V?.binaryValue)
	}
	
	//MARK: COS function
	/// ISO 10303-11 (15.6) Cos - arithmetic function
	/// 
	/// The COS function returns the cosine of an angle. 
	/// - Parameter V: V is a number which is an angle in radians.
	/// - Returns: The cosine of V (-1.0 ≤ result ≤ 1.0).
	public static func COS<Number: SwiftDoubleConvertible>(_ V: Number?) -> REAL? {
		guard let r = V?.asSwiftDouble else { return nil }
		return REAL( cos(r) )
	}
	
	//MARK: EXISTS function
	/// ISO 10303-11 (15.7) Exists - general function
	/// 
	/// The EXISTS function returns true if a value exists for the input parameter, or false if no value exists for it. The exists function is useful for checking if values have been given to optional attributes, or if variables have been initialized. 
	/// - Parameter V: V is an expression which results in any type.
	/// - Returns: TRUE or FALSE depending on whether V has an actual or indeterminate (?) value.
	public static func EXISTS<Generic: SDAIGenericType>(_ V: Generic?) -> BOOLEAN {
		return BOOLEAN( V != nil )
	}
	
	//MARK: EXP function
	/// ISO 10303-11 (15.8) Exp - arithmetic function
	/// 
	/// The EXP function returns e (the base of the natural logarithm system) raised to the power V. 
	/// - Parameter V: V is a number.
	/// - Returns: The value e^V .
	public static func EXP<Number: SwiftDoubleConvertible>(_ V: Number?) -> REAL? {
		guard let r = V?.asSwiftDouble else { return nil }
		return REAL( exp(r) )
	}

	
	//MARK: FORMAT function
	/// ISO 10303-11 (15.9) Format - general function
	/// 
	/// The FORMAT returns a formatted string representation of a number. 
	/// - Parameters:
	///   - N: N is a number (integer or real).
	///   - F: F is a string containing formatting commands. (CURRENTLY NOT RESPECTED)
	/// - Returns: A string representation of N formatted according to F. Rounding is applied to the string representation if necessary.
	public static func FORMAT<Number: SDAINumberType, Str: SwiftStringConvertible>(N: Number?, F: Str?) -> STRING? {
		guard let v = N?.asSwiftType else { return nil }
		//TODO: - to respect format command
		return STRING( String(describing: v) )			
	}
	/// ISO 10303-11 (15.9) Format - general function
	/// (select type variant) 
	/// 
	/// The FORMAT returns a formatted string representation of a number. 
	/// - Parameters:
	///   - N: N is a select type yielding number (integer or real).
	///   - F: F is a string containing formatting commands.
	/// - Returns: A string representation of N formatted according to F. Rounding is applied to the string representation if necessary.
	public static func FORMAT<Number: SDAISelectType, Str: SwiftStringConvertible>(N: Number?, F: Str?) -> STRING? {
		if let intval = N?.integerValue { return FORMAT(N: intval, F: F) }
		return FORMAT(N: N?.numberValue, F: F)
	}

	
	//MARK: HIBOUND function
	/// ISO 10303-11 (15.10) HiBound - arithmetic function
	/// 
	/// The HIBOUND function returns the declared upper index of an array or the declared upper bound of a bag, list or set. 
	/// - Parameter V: V is an aggregate value.
	/// - Returns: 
	/// 	- a) When V is an ARRAY the returned value is the declared upper index. 
	/// 	- b) When V is a BAG, LIST or SET the returned value is the declared upper bound; if there are no bounds declared or the upper bound is declared to be indeterminate (?) indeterminate (?) is returned.
	public static func HIBOUND<Aggregate: SDAIAggregationBehavior>(_ V: Aggregate?) -> INTEGER? {
		return INTEGER(V?.aggregationHiBound)
	}
	
	//MARK: HIINDEX function
	/// ISO 10303-11 (15.11) HiIndex - arithmetic function
	/// 
	/// The HIINDEX function returns the upper index of an array or the number of elements in a bag, list or set. 
	/// - Parameter V: V is an aggregate value.
	/// - Returns: 
	/// 	- a) When V is an ARRAY, the returned value is the declared upper index.
	/// 	-	b) When V is a BAG, LIST or SET, the returned value is the actual number of elements in the aggregate value.
	public static func HIINDEX<Aggregate: SDAIAggregationBehavior>(_ V: Aggregate?) -> INTEGER? {
		return INTEGER(V?.aggregationHiIndex)
	}
	
	//MARK: LENGTH function
	/// ISO 10303-11 (15.12) Length - string function
	/// 
	/// The LENGTH function returns the number of characters in a string. 
	/// - Parameter V: V is a string value.
	/// - Returns: The returned value is the number of characters in the string and shall be greater than or equal to zero.
	public static func LENGTH<Str: SwiftStringConvertible>(_ V: Str?) -> INTEGER? {
		return INTEGER(V?.possiblyAsSwiftString?.count)
	}
	
	//MARK: LOBOUND function
	/// ISO 10303-11 (15.13) LoBound - arithmetic function
	/// 
	/// The LOBOUND function returns the declared lower index of an ARRAY, or the declared lower bound of a BAG, LIST or SET. 
	/// - Parameter V: V is an aggregate value.
	/// - Returns: 
	/// 	- a) When V is an ARRAY the returned value is the declared lower index. 
	/// 	- b) When V is a BAG, LIST or SET the returned value is the declared lower bound; if no lower bound is declared, zero (0) is returned.
	public static func LOBOUND<Aggregate: SDAIAggregationBehavior>(_ V: Aggregate?) -> INTEGER? {
		return INTEGER(V?.aggregationLoBound)
	}
	
	//MARK: LOG function
	/// ISO 10303-11 (15.14) Log - arithmetic function
	/// 
	/// The LOG function returns the natural logarithm of a number. 
	/// - Parameter V: V is a number.
	/// - Returns: A real number which is the natural logarithm of V.
	/// - Conditions : V > 0.0  
	public static func LOG<Number: SwiftDoubleConvertible>(_ V: Number?) -> REAL? {
		guard let r = V?.asSwiftDouble else { return nil }
		return REAL( log(r) )
	}
	
	//MARK: LOG2 function
	/// ISO 10303-11 915.15) Log2 - arithmetic function
	/// 
	/// The LOG2 function returns the base two logarithm of a number. 
	/// - Parameter V: V is a number.
	/// - Returns: A real number which is the base two logarithm of V.
	/// - Conditions : V > 0.0 
	public static func LOG2<Number: SwiftDoubleConvertible>(_ V: Number?) -> REAL? {
		guard let r = V?.asSwiftDouble else { return nil }
		return REAL( log(r)/log(2) )
	}
	
	//MARK: LOG10 function
	/// ISO 10303-11 (15.16) Log10 - arithmetic function
	/// 
	/// The LOG10 function returns the base ten logarithm of a number. 
	/// - Parameter V: V is a number.
	/// - Returns: A real number which is the base ten logarithm of V.
	/// - Conditions : V > 0.0 
	public static func LOG10<Number: SwiftDoubleConvertible>(_ V: Number?) -> REAL? {
		guard let r = V?.asSwiftDouble else { return nil }
		return REAL( log10(r) )
	}

	//MARK: LOINDEX function
	/// ISO 10303-11 (15.17) LoIndex - arithmetic function
	/// 
	/// The LOINDEX function returns the lower index of an aggregate value. 
	/// - Parameter V: V is an aggregate value.
	/// - Returns: 
	/// 	- a) When V is an ARRAY the returned value is the declared lower index.
	/// 	- b) When V is a BAG, LIST or SET, the returned value is 1 (one).
	public static func LOINDEX<Aggregate: SDAIAggregationBehavior>(_ V: Aggregate?) -> INTEGER? {
		return INTEGER(V?.aggregationLoIndex)
	}

	//MARK: NVL function (underlying type variant)
	/// ISO 10303-11 (15.18) NVL - null value function
	/// (underlying type variant) 
	/// 
	/// The NVL function returns either the input value or an alternate value in the case where the input has a indeterminate (?) value.  
	/// - Parameters:
	///   - V: V is an underlying type expression which is of any type.
	///   - SUBSTITUTE: SUBSTITUTE is an expression which shall not evaluate to indeterminate (?).
	/// - Returns: When V is not indeterminate (?), that value is returned. Otherwise, SUBSTITUTE is returned.

	public static func NVL<GEN1: SDAIUnderlyingType>
	(V: GEN1?, SUBSTITUTE: GEN1.FundamentalType?) -> GEN1
	{
		return V ?? GEN1.convert(from: UNWRAP(SUBSTITUTE))
	}


	//MARK: NVL (simple type variant)
	/// ISO 10303-11 (15.18) NVL - null value function
	/// (simple type variant) 
	/// 
	/// The NVL function returns either the input value or an alternate value in the case where the input has a indeterminate (?) value.  
	/// - Parameters:
	///   - V: V is an simple type expression which is of any type.
	///   - SUBSTITUTE: SUBSTITUTE is an expression which shall not evaluate to indeterminate (?).
	/// - Returns: When V is not indeterminate (?), that value is returned. Otherwise, SUBSTITUTE is returned.

	public static func NVL<GEN1: SDAISimpleType>
	(V: GEN1?, SUBSTITUTE: GEN1.SwiftType?) -> GEN1 {
		return V ?? GEN1(from: UNWRAP(SUBSTITUTE))
	}


	//MARK: NVL (entity reference type variant)
	/// ISO 10303-11 (15.18) NVL - null value function
	/// (entity reference type variant)
	/// 
	/// The NVL function returns either the input value or an alternate value in the case where the input has a indeterminate (?) value.  
	/// - Parameters:
	///   - V: V is an entity reference type expression which is of any type.
	///   - SUBSTITUTE: SUBSTITUTE is an entity reference expression which shall not evaluate to indeterminate (?).
	/// - Returns: When V is not indeterminate (?), that value is returned. Otherwise, SUBSTITUTE is returned.

	public static func NVL<GEN1: SDAI.EntityReference>
	(V: GEN1?, SUBSTITUTE: SDAI.EntityReference?) -> GEN1 {
		return V ?? UNWRAP(GEN1.cast(from:SUBSTITUTE))
	}

	/// ISO 10303-11 (15.18) NVL - null value function
	/// (entity reference type variant)
	/// 
	/// The NVL function returns either the input value or an alternate value in the case where the input has a indeterminate (?) value.  
	/// - Parameters:
	///   - V: V is an entity reference type expression which is of any type.
	///   - SUBSTITUTE: SUBSTITUTE is a complex entity expression which shall not evaluate to indeterminate (?).
	/// - Returns: When V is not indeterminate (?), that value is returned. Otherwise, SUBSTITUTE is returned.

	public static func NVL<GEN1: SDAI.EntityReference>
	(V: GEN1?, SUBSTITUTE: SDAI.ComplexEntity?) -> GEN1 {
		return V ?? UNWRAP(GEN1(complex: SUBSTITUTE))
	}

	//MARK: NVL (select type variant)
	/// ISO 10303-11 (15.18) NVL - null value function
	/// (select type variant)
	/// 
	/// The NVL function returns either the input value or an alternate value in the case where the input has a indeterminate (?) value.  
	/// - Parameters:
	///   - V: V is an select type expression which is of any type.
	///   - SUBSTITUTE: SUBSTITUTE is a complex entity expression which shall not evaluate to indeterminate (?).
	/// - Returns: When V is not indeterminate (?), that value is returned. Otherwise, SUBSTITUTE is returned.

	public static func NVL<GEN1: SDAISelectType>
	(V: GEN1?, SUBSTITUTE: SDAI.ComplexEntity?) -> GEN1 {
		return V ?? UNWRAP(GEN1(possiblyFrom: SUBSTITUTE))
	}

	/// ISO 10303-11 (15.18) NVL - null value function
	/// (select type variant)
	/// 
	/// The NVL function returns either the input value or an alternate value in the case where the input has a indeterminate (?) value.  
	/// - Parameters:
	///   - V: V is an select type expression which is of any type.
	///   - SUBSTITUTE: SUBSTITUTE is an entity reference expression which shall not evaluate to indeterminate (?).
	/// - Returns: When V is not indeterminate (?), that value is returned. Otherwise, SUBSTITUTE is returned.

	public static func NVL<GEN1: SDAISelectType, GEN2: SDAI.EntityReference>
	(V: GEN1?, SUBSTITUTE: GEN2?) -> GEN1 {
		return V ?? UNWRAP(GEN1(possiblyFrom: SUBSTITUTE))
	}

	/// ISO 10303-11 (15.18) NVL - null value function
	/// (select type variant)
	/// 
	/// The NVL function returns either the input value or an alternate value in the case where the input has a indeterminate (?) value.  
	/// - Parameters:
	///   - V: V is an select type expression which is of any type.
	///   - SUBSTITUTE: SUBSTITUTE is an underlying type expression which shall not evaluate to indeterminate (?).
	/// - Returns: When V is not indeterminate (?), that value is returned. Otherwise, SUBSTITUTE is returned.

	public static func NVL<GEN1: SDAISelectType, GEN2: SDAIUnderlyingType>
	(V: GEN1?, SUBSTITUTE: GEN2?) -> GEN1 {
		return V ?? UNWRAP(GEN1(possiblyFrom: SUBSTITUTE))
	}

	/// ISO 10303-11 (15.18) NVL - null value function
	/// (select type variant)
	/// 
	/// The NVL function returns either the input value or an alternate value in the case where the input has a indeterminate (?) value.  
	/// - Parameters:
	///   - V: V is an select type expression which is of any type.
	///   - SUBSTITUTE: SUBSTITUTE is a select type expression which shall not evaluate to indeterminate (?).
	/// - Returns: When V is not indeterminate (?), that value is returned. Otherwise, SUBSTITUTE is returned.

	public static func NVL<GEN1: SDAISelectType, GEN2: SDAISelectType>
	(V: GEN1?, SUBSTITUTE: GEN2?) -> GEN1 {
		return V ?? UNWRAP(GEN1.convert(sibling: SUBSTITUTE))
	}



	//MARK: ODD function
	/// ISO 10303-11 (15.19) Odd - arithmetic function
	/// 
	/// The ODD function returns true or false depending on whether a number is odd or even. 
	/// - Parameter V: V is an integer number.
	/// - Returns: When V MOD 2 = 1 true is returned; otherwise false is returned.
	/// - Conditions : Zero is not odd. 
	public static func ODD<Integer: SwiftIntConvertible>(_ V: Integer?) -> LOGICAL {
		guard let i = V?.asSwiftInt else { return UNKNOWN }
		return LOGICAL( i % 2 == 1 )
	}

	//MARK: ROLESOF function
	/// ISO 10303-11 (15.20) RolesOf - general function
	/// 
	/// The ROLESOF function returns a set of strings containing the fully qualified names of the roles played by the specified entity instance. 
	/// A fully qualified name is defined to be the name of the attribute qualified by the name of the schema and entity in which this attribute is declared (that is, ’SCHEMA.ENTITY.ATTRIBUTE’).  
	/// - Parameter V: V is any instance of an entity data type.
	/// - Returns: A set of string values (in upper case) containing the fully qualified names of the attributes of the entity instances which use the instance V. 
	/// If V is indeterminate (?) then an empty set is returned.
	public static func ROLESOF(_ V: EntityReference?) -> SET<STRING> {
		guard let complex = V?.complexEntity else { return SET<STRING>() }
		return SET<STRING>(from: complex.roles)
	}
	/// ISO 10303-11 (15.20) RolesOf - general function
	/// (select type variant) 
	/// 
	/// The ROLESOF function returns a set of strings containing the fully qualified names of the roles played by the specified entity instance. 
	/// A fully qualified name is defined to be the name of the attribute qualified by the name of the schema and entity in which this attribute is declared (that is, ’SCHEMA.ENTITY.ATTRIBUTE’).  
	/// - Parameter V: V is a select type value yielding any instance of an entity data type.
	/// - Returns: A set of string values (in upper case) containing the fully qualified names of the attributes of the entity instances which use the instance V. 
	/// If V is indeterminate (?) then an empty set is returned.
	public static func ROLESOF<SEL:SDAISelectType>(_ V: SEL?) -> SET<STRING> {
		return ROLESOF(V?.entityReference)
	}

	//MARK: SIN function
	/// ISO 10303-11 (15.21) Sin - arithmetic function
	/// 
	/// The SIN function returns the sine of an angle. 
	/// - Parameter V: V is a number representing an angle expressed in radians.
	/// - Returns: The sine of V (-1.0 ≤ result ≤ 1.0).
	public static func SIN<Number: SwiftDoubleConvertible>(_ V: Number?) -> REAL? {
		guard let r = V?.asSwiftDouble else { return nil }
		return REAL( sin(r) )
	}

	//MARK: SIZEOF funciton
	/// ISO 10303-11 (15.22) SizeOf - aggregate function
	/// 
	/// The SIZEOF function returns the number of elements in an aggregate value. 
	/// - Parameter V: V is an aggregate value.
	/// - Returns: 
	/// 	-	a) When V is an ARRAY the returned value is its declared number of elements in the aggregation data type.
	/// 	-	b) When V is a BAG, LIST or SET, the returned value is the actual number of elements in the aggregate value.
	public static func SIZEOF<Aggregate: SDAIAggregationBehavior>(_ V: Aggregate?) -> INTEGER? {
		return INTEGER(V?.aggregationSize)
	}
	/// ISO 10303-11 (15.22) SizeOf - aggregate function
	/// (aggregation initializer variant) 
	/// 
	/// The SIZEOF function returns the number of elements in an aggregate value. 
	/// - Parameter V: V is an aggregate value.
	/// - Returns: 
	/// 	-	a) When V is an ARRAY the returned value is its declared number of elements in the aggregation data type.
	/// 	-	b) When V is a BAG, LIST or SET, the returned value is the actual number of elements in the aggregate value.
	public static func SIZEOF<AI: SDAIAggregationInitializer>(_ V: AI?) -> INTEGER?
	{
		return INTEGER(  V?.reduce(0, {$0 + $1.count})  )
	}

	
	//MARK: SQRT function
	/// ISO 10303-11 (15.23) Sqrt - arithmetic function
	/// 
	/// The SQRT function returns the non-negative square root of a number.  
	/// - Parameter V: V is any non-negative number.
	/// - Returns: The non-negative square root of V.
	/// - Conditions : V ≥ 0.0 
	public static func SQRT<Number: SwiftDoubleConvertible>(_ V: Number?) -> REAL? {
		guard let r = V?.asSwiftDouble else { return nil }
		return REAL( sqrt(r) )
	}
	
	//MARK: TAN function
	/// ISO 10303-11 (15.24) Tan - arithmetic function
	/// 
	/// The TAN function returns the tangent of of an angle. 
	/// - Parameter V: V is a number representing an angle expressed in radians.
	/// - Returns: The tangent of the angle. If the angle is nπ/2, where n is an odd integer, indeterminate (?) is returned.
	public static func TAN<Number: SwiftDoubleConvertible>(_ V: Number?) -> REAL? {
		guard let r = V?.asSwiftDouble else { return nil }
		return REAL( tan(r) )
	}
	
	//MARK: TYPEOF function
	/// ISO 10303-11 (15.25) TypeOf - general function
	/// 
	/// The TYPEOF function returns a set of string that contains the names of all the data types that the parameter is a member of. 
	/// Except for the simple data types (BINARY, BOOLEAN, INTEGER, LOGICAL, NUMBER, REAL, and STRING) and the aggregation data types (ARRAY, BAG, LIST, and SET), these names are qualified by the name of the schema that contains the definition of the type.
	/// # NOTE 1 
	/// The primary purpose of this function is to check whether a given value (variable or attribute value) can be used for a certain purpose, for example, to ensure assignment compatibility between two values. 
	/// It may also be used if different subtypes or specializations of a given type have to be treated differently in some context.
	/// # NOTE 2 
	/// When the actual parameter to TypeOf was a formal parameter to some function being evaluated, the “type to which V belongs (by declaration)” is the type declared for the original actual parameter, or the result data type for the actual parameter expression as specified in clause 12, and not the type declared for any formal parameter for which it has been substituted.
	/// # NOTE 4 
	/// This function ends its work when it reaches an aggregation data type. It does not provide the information concerning the base type of the aggregate value. 
	/// If needed, this information can be collected by applying typeof to legal elements of the aggregate value.
	/// 
 	/// - Parameter V: V is a value of any type.
	/// 
	/// - Returns: The contents of the returned set of string values are the names (in upper case) of all types that the value V is a member of. Such names are qualified by the name of the schema that contains the definition of the type (’SCHEMA.TYPE’) if it is neither a simple data type nor an aggregation data type.
	/// 	- If V evaluates to indeterminate (?), typeof returns an empty set.
  ///
	public static func TYPEOF<Generic: SDAIGenericType>(_ V: Generic?) -> SET<STRING> {
		guard let v = V else { return SET<STRING>() }
    let typeMembers = v.typeMembers
		return SET<STRING>(from: typeMembers )
	}
	/// swift language binding - TypeOf function combined with the subsequent query expression checking for one type matching
	/// - Parameters:
	///   - V: V is a value of any type.
	///   - target: type meta-object to which the type matching is checked.
	/// - Returns: TRUE if V is of type target.
	public static func TYPEOF<Generic: SDAIGenericType, T: SDAIGenericType>(_ V: Generic? , IS target: T.Type) -> LOGICAL {
		guard let v = V else { return UNKNOWN }
		let typemembers = v.typeMembers
		let typename = SDAI.STRING(target.typeName)
		return LOGICAL( typemembers.contains(typename) )
	}
	
	
	//MARK: USEDIN function
	/// ISO 10303-11 (15.26) UsedIn - general function
	/// (variant without role specification) 
	/// - Parameter T: T is any instance of any entity data type.
	/// - Returns: Every entity instance that uses the specified instance in the specified role is returned in a bag.
	/// An empty bag is returned if the instance T plays no roles.
	/// As ROLE is not specified, every usage of T is reported. 
	/// All relationships directed toward T are examined. 
	/// Note that if T is not used, an empty bag is returned.
	/// If T is indeterminate (?), an empty bag is returned.
	///
	public static func USEDIN<GEN>(T: GEN?) -> BAG<EntityReference>
	where GEN: SDAIGenericType
	{
		guard let T = T?.entityReference else { return BAG<EntityReference>() }
		return BAG( from: T.complexEntity.usedIn() )
	}

	/// ISO 10303-11 (15.26) UsedIn - general function
	/// (variant with role specification returning non-optional value) 
	/// - Parameter T: T is any instance of any entity data type.
	/// - Parameter ROLE: ROLE is a KeyPath expression that contains a fully qualified attribute (role) name. 
	/// - Returns: Every entity instance that uses the specified instance in the specified role is returned in a bag.
	/// An empty bag is returned if the instance T plays no roles or if the role ROLE is not found.
	/// All relationships directed toward T are examined. 
	/// When the relationship originates from an attribute with the name ROLE, the entity instance containing that attribute is added to the result bag. 
	/// Note that if T is not used, an empty bag is returned.
	/// If T is indeterminate (?), an empty bag is returned.
	///
	public static func USEDIN<GEN, ENT, R>(
		T: GEN?,
		ROLE: KeyPath<ENT,R>
	) -> BAG<ENT.PRef>
	where GEN: SDAIGenericType,
				ENT: EntityReference & SDAIDualModeReference,
				R:   SDAIGenericType
	{
		guard let T = T?.entityReference else { return BAG<ENT.PRef>() }
		return BAG(from: T.complexEntity.usedIn(as: ROLE))
	}

	/// ISO 10303-11 (15.26) UsedIn - general function
	/// (variant with role specification returning optional value) 
	/// - Parameter T: T is any instance of any entity data type.
	/// - Parameter ROLE: ROLE is a KeyPath expression that contains a fully qualified attribute (role) name. 
	/// - Returns: Every entity instance that uses the specified instance in the specified role is returned in a bag.
	/// An empty bag is returned if the instance T plays no roles or if the role ROLE is not found.
	/// All relationships directed toward T are examined. 
	/// When the relationship originates from an attribute with the name ROLE, the entity instance containing that attribute is added to the result bag. 
	/// Note that if T is not used, an empty bag is returned.
	/// If T is indeterminate (?), an empty bag is returned.
	///
	public static func USEDIN<GEN, ENT, R>(
		T: GEN?,
		ROLE: KeyPath<ENT,R?>
	) -> BAG<ENT.PRef>
	where GEN: SDAIGenericType,
				ENT: EntityReference & SDAIDualModeReference,
				R:   SDAIGenericType
	{
		guard let T = T?.entityReference else { return BAG<ENT.PRef>() }
		return BAG(from: T.complexEntity.usedIn(as: ROLE))
	}

	/// ISO 10303-11 (15.26) UsedIn - general function
	/// (variant with role specification in STRING) 
	/// - Parameter T: T is any instance of any entity data type.
	/// - Parameter R: R is a STRING that contains a fully qualified attribute (role) name as defined in 15.20. 
	/// - Returns: Every entity instance that uses the specified instance in the specified role is returned in a bag.
	/// An empty bag is returned if the instance T plays no roles or if the role R is not found.
	/// All relationships directed toward T are examined. 
	/// When the relationship originates from an attribute with the name R, the entity instance containing that attribute is added to the result bag. 
	/// Note that if T is not used, an empty bag is returned.
	/// If either T or R are indeterminate (?), an empty bag is returned.
	///
	public static func USEDIN<GEN:SDAIGenericType>(
		T:GEN?,
		R:STRING?
	) -> BAG<EntityReference>
	{
		guard let T = T?.entityReference, let R = R else { return BAG<EntityReference>() }
		return BAG(from: T.complexEntity.usedIn(as: R.asSwiftType))
	}
	
	//MARK: VALUE function
	/// ISO 10303-11 (15.27) Value - arithmetic function
	/// 
	/// The VALUE function returns the numeric representation of a string. 
	/// - Parameter V: V is a string containing either a real or integer literal (see 7.5).
	/// - Returns: A number corresponding to the string representation. If it is not possible to interpret the string as either a real or integer literal, indeterminate (?) is returned.
	public static func VALUE<Str: SwiftStringConvertible>(_ V: Str?) -> NUMBER? {
		guard let str = V?.possiblyAsSwiftString, let double = Double(str) else { return nil }
		return NUMBER(double)
	}
	
	/// ISO 10303-11 (15.28) Value in - membership function
	/// (optional element aggregation variant)
	/// 
	/// The VALUE_IN function returns a logical value depending on whether or not a particular value is a member of an aggregation. 
	/// - Parameters:
	///   - C: C is an aggregation of any type.
	///   - V: V is an expression that is assignment compatible with the base type of C.
	/// - Returns: 
	/// 	- a) If either V or C is indeterminate (?), unknown is returned.
	/// 	- b) If any element of C has a value equal to the value of V, true is returned.
	/// 	- c) If any element of C is indeterminate (?), unknown is returned.
	/// 	- d) Otherwise false is returned.
	public static func VALUE_IN<Aggregate: SDAIAggregationType, GEN1: SDAIGenericType>(C: Aggregate?, V: GEN1?) -> LOGICAL 
	where Aggregate.Element == Aggregate.ELEMENT? 
	{
		guard let C = C, let V = V else { return UNKNOWN }
		var isin = false
		for element in C {
			if let element = element {
				if element.value.isValueEqual(to: V.value) { isin = true }
			}
			else {
				assert(element == nil)
				return UNKNOWN
			}
		}
		return LOGICAL(isin)
	}
	/// ISO 10303-11 (15.28) Value in - membership function
	/// (non-optional element aggregation variant)
	/// 
	/// The VALUE_IN function returns a logical value depending on whether or not a particular value is a member of an aggregation. 
	/// - Parameters:
	///   - C: C is an aggregation of any type.
	///   - V: V is an expression that is assignment compatible with the base type of C.
	/// - Returns: 
	/// 	- a) If either V or C is indeterminate (?), unknown is returned.
	/// 	- b) If any element of C has a value equal to the value of V, true is returned.
	/// 	- c) If any element of C is indeterminate (?), unknown is returned.
	/// 	- d) Otherwise false is returned.
	public static func VALUE_IN<Aggregate: SDAIAggregationType, GEN1: SDAIGenericType>(C: Aggregate?, V: GEN1?) -> LOGICAL 
	where Aggregate.Element == Aggregate.ELEMENT {
		guard let C = C, let V = V else { return LOGICAL(nil) }
		for element in C {
			if element.value.isValueEqual(to: V.value) { return LOGICAL(true) }
		}
		return LOGICAL(false)
	}
	
	/// ISO 10303-11 (15.29) Value unique - uniqueness function
	/// (optional element aggregation variant)
  /// 
	/// The VALUE_UNIQUE function returns a logical value depending on whether or not the elements of an aggregation are value unique.
	/// - Parameter V: V is an aggregation of any type.
	/// - Returns: 
	/// 	- a) If V is indeterminate (?), unknown is returned.
	/// 	- b) If any any two elements of V are value equal, false is returned.
	/// 	- c) If any element of V is indeterminate (?), unknown is returned.
	/// 	- d) Otherwise true is returned.
	public static func VALUE_UNIQUE<Aggregate: SDAIAggregationType>(_ V: Aggregate?) -> LOGICAL 
	where Aggregate.Element == Aggregate.ELEMENT? 
	{
		guard let V = V, !V.contains(nil) else { return LOGICAL(nil) }
		let unique = Set( V.map{ $0!.value } )
		return LOGICAL(unique.count == V.size)
	}
	/// ISO 10303-11 (15.29) Value unique - uniqueness function
	/// (non-optional element aggregation variant)
	/// 
	/// The VALUE_UNIQUE function returns a logical value depending on whether or not the elements of an aggregation are value unique. 
	/// - Parameter V: V is an aggregation of any type.
	/// - Returns: 
	/// 	- a) If V is indeterminate (?), unknown is returned.
	/// 	- b) If any any two elements of V are value equal, false is returned.
	/// 	- c) If any element of V is indeterminate (?), unknown is returned.
	/// 	- d) Otherwise true is returned.
		public static func VALUE_UNIQUE<Aggregate: SDAIAggregationType>(_ V: Aggregate?) -> LOGICAL 
	where Aggregate.Element == Aggregate.ELEMENT 
	{
		guard let V = V else { return LOGICAL(nil) }
		let unique = Set( V.map{ $0.value } )
		return LOGICAL(unique.count == V.size)
	}
}
