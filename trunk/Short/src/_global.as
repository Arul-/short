/*
   Copyright (c) 2010 Luracast <arul@luracast.com>
   All rights reserved.

   Permission is hereby granted, free of charge, to any person obtaining a copy
   of this software and associated documentation files (the "Software"), to deal
   in the Software without restriction, including without limitation the rights
   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be included in
   all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
   THE SOFTWARE.
 */
package
{
	/**
	 * A reference to the global object that can hold your variables that are needs to be accessed gloabally
	 * Unlike Timeline-declared or locally declared variables and functions, global variables and functions are visible to every Timeline and scope in the SWF file,
	 * 
	 * <p><b>NOTE</b> When setting the value of a global variable, you must use the fully qualified name of the variable,
	 * e.g. _global.variableName. Failure to do so will result in a compiler error</p>
	 * @includeExample _globalExample1.as
	 * @includeExample _globalExample2.as
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.0
	 * @productversion Short 1.0
	 */
	public const _global:Object={};
}