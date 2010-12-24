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
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	/**
	 * Simple function that can be used to track an event. It traces out the details about the event
	 * @param event that we want to know the details
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.0
	 * @productversion Short 1.0
	 */
	public function eventTracer(e:Event):void
	{
		var name:String=e.target.hasOwnProperty('name') ? e.target.name : 'unnamed';
		var className:String=getQualifiedClassName(e.target).split(':').pop();
		if (name == null)
			name=className.toLowerCase();
		trace('(' + className + ') ' + name + '.on' + e.type.charAt(0).toUpperCase() + e.type.substr(1), e);
		//var x:* = describeType(e)//..accessor.@name;
		//trace(x);
	}
}