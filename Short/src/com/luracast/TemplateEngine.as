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
package com.luracast
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	/**
	 *
	 * @author Arul
	 *
	 */
	public class TemplateEngine extends EventDispatcher
	{
		/**
		 *
		 */
		public static const STRING_MARKER:String="'";
		/**
		 *
		 */
		public static const TEMPLATE_BEGIN:String="{";
		/**
		 *
		 */
		public static const TEMPLATE_END:String="}";

		/**
		 *
		 */
		public var functions:Object;

		/**
		 *
		 */
		public var hash:Object;

		/**
		 *
		 * @param target
		 *
		 */
		public function TemplateEngine(target:IEventDispatcher=null)
		{
			super(target);
			functions={};
			hash={};
		}

		/**
		 *
		 * @param template
		 * @return
		 *
		 */
		public function process(template:String):String
		{
			var out:String="";
			var l:Number=template.length;
			var iB:Number=-1, iE:Number=-1, lE:Number=-1;
			while (iB < l)
			{
				iB=template.indexOf(TEMPLATE_BEGIN, iB + TEMPLATE_BEGIN.length);
				if (iB == -1)
				{
					break;
				}
				iE=template.indexOf(TEMPLATE_END, iB + TEMPLATE_END.length);
				var e:String=eval(template.substring(iB + TEMPLATE_BEGIN.length, iE));
				out+=template.substring(lE, iB) + e;
				lE=iE + TEMPLATE_END.length;
			}
			out+=template.substring(lE, l);
			return out;
		}

		/**
		 *
		 * @param exp
		 * @return
		 *
		 */
		private function _internalEval(exp:String):String
		{
			var arr:Array=exp.split('[');
			if (arr.length == 2)
			{
				return this.hash[arr[0]].charAt(parseInt(arr[1]));
			}
			return this.hash[exp];
		}

		/**
		 *
		 * @param exp
		 * @return
		 *
		 */
		public function booleanEval(exp:String):Boolean
		{
			var arr:Array=exp.split('==');
			if (arr.length == 2)
			{
				return this.stringEval(arr[0], true) == this.stringEval(arr[1], true);
			}
			var r:*=this._internalEval(exp);
			return r == true || r == 'Yes' || r == 'true' || r == 'TRUE';
		}

		/**
		 *
		 * @param exp
		 * @param unconditional
		 * @return
		 *
		 */
		public function stringEval(exp:String, unconditional:Boolean=false):String
		{
			var out:String="";
			var arr:Array=exp.split(STRING_MARKER);
			var l:Number=arr.length;

			//support numeric literals with out single quote
			if (l == 1 && !isNaN(arr[0]))
			{
				return arr[0];
			}
			for (var i:int=0; i < l; i+=2)
			{
				var str:String=arr[i];
				if (str != "")
				{
					var r:String=this._internalEval(str);
					if (r == null)
					{
						return "";
					}
					else
					{
						if (i > 0)
						{
							out+=arr[i - 1];
						}
						out+=r;
					}
				}
				else if (unconditional)
				{
					if (i > 0)
					{
						out+=arr[i - 1];
					}
				}
			}
			return out;
		}

		/**
		 *
		 * @param exp
		 * @return
		 *
		 */
		public function eval(exp:String):String
		{
			var j:int=exp.indexOf('(');
			if (j > 0)
			{
				//evaluate function expressions
				var e:String=exp.substring(0, j);
				var j2:int=exp.lastIndexOf(')');
				if (j2 == -1)
				{
					return '';
				}
				var f:Function=this.functions[e];
				if (f is Function)
				{
					var arr:Array=exp.substring(j + 1, j2).split(',');
					for (var i:int=0; i < arr.length; i++)
					{
						arr[i]=this.stringEval(arr[i], true);
					}
					return f.apply(this, arr);
				}
				else
				{
					return '';
				}
			}
			//eval if then else shortcut                
			i=exp.indexOf('?');
			if (i > 0)
			{
				//evaluate exp?value1:value2
				e=exp.substring(0, i);
				var r:Boolean=booleanEval(e);
				var i2:int=exp.indexOf(':');
				var i3:int=exp.indexOf(STRING_MARKER);
				if (i3 > 0 && i3 < i2)
				{
					i3=exp.indexOf(STRING_MARKER, i3 + 1);
					i2=exp.indexOf(':', i3 + 1);
				}
				if (r)
				{
					return stringEval(exp.substring(i + 1, i2), true);
				}
				else
				{
					return stringEval(exp.substring(i2 + 1), true);
				}
			}
			return stringEval(exp);
		}
	}
}