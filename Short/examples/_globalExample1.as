/**
 * @exampleText The following example creates a global function, <code>factorial()</code>, that is available to every Timeline and scope in a SWF file:
 */
_global.factorial = function(n:Number) {
	if(n <= 1) {
		return 1;
	} 
	else {
		return n * factorial(n - 1);
	}
}

trace(_global.factorial(1)); // 1
trace(_global.factorial(2)); // 2
trace(_global.factorial(3)); // 6
trace(_global.factorial(4)); // 24
