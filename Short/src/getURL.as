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
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;

	/**
	 * Loads a document from a specific URL into a window or passes variables to another application at a defined URL. Shorthand for navigateToURL.
	 * @param url The URL from which to obtain the document.
	 * @param window Specifies the window or HTML frame into which the document should load. You can enter the name of a specific window or
	 * select from the following reserved target names:
	 * <ul>
	 * <li><code>_self</code> specifies the current frame in the current window.</li>
	 * <li><code>_blank</code> specifies a new window.</li>
	 * <li><code>_parent</code> specifies the parent of the current frame.</li>
	 * <li><code>_top</code> specifies the top-level frame in the current window.</li>
	 * </ul>
	 * @param method A <code>GET</code> or <code>POST</code> method for sending variables. If there are no variables, omit this parameter.
	 * The <code>GET</code> method appends the variables to the end of the URL, and is used for small numbers of variables.
	 * The <code>POST</code> method sends the variables in a separate HTTP header and is used for sending long strings of variables.
	 * @param params Variables to be passed to the server wrapped as an object
	 *
	 * @includeExample getURLExample1.as
	 * @includeExample getURLExample2.as
	 * @includeExample getURLExample3.as
	 * @includeExample getURLExample4.as
	 * @includeExample getURLExample5.as
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.0
	 * @productversion Short 1.0
	 */
	public function getURL(url:String, window:String="_blank", method:String="GET", params:Object=null):void
	{
		var r:URLRequest=new URLRequest(url);
		r.method=method;
		if (params != null)
			if (params is URLVariables)
			{
				r.data=params
			}
			else
			{
				r.data=new URLVariables;
				for (var name:String in params)
				{
					r.data[name]=params[name];
				}
			}
		navigateToURL(r, window);
	}
}