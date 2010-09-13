/**
 * @exampleText The following example shows how the failure to use the fully qualified variable name when setting the value of a global variable leads to unexpected results:
 */
_global.myVar = "globalVariable";
trace(_global.myVar); // globalVariable
trace(myVar); //compiler error

var myVar = "localVariable";
trace(_global.myVar); // globalVariable
trace(myVar); // localVariable