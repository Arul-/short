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
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.describeType;
	import flash.utils.flash_proxy;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * Root of all event simplification. Short is a wrapper for other objects to
	 * simplify event handling, add helper methods, and add virtual properties
	 * @includeExample ShortExample1.as
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.0
	 * @productversion Short 1.0
	 */
	public dynamic class Short extends Proxy
	{

		private static const CONTENT_LOADER_INFO:Object={open: true, ioError: true, securityError: true, progress: true, complete: true, init: true};

		private static var _targets:VirtualProperty=new VirtualProperty;

		private static var _instances:Dictionary=new Dictionary(true);

		private var _scope:EventDispatcher;

		/**
		 * create new instance of Short for the given target
		 * @param target object which is capable of dispacthing events
		 */

		public function Short(target:EventDispatcher=null)
		{
			to=target;
		}

		/**
		 * lists the events supported by the given target object
		 * @warning use it only during development stage to copy paste events quickly.
		 * it is not optimized for production use.
		 * @param target
		 * @param onlyError filter and show only error events.
		 * ie., events with the name that contains 'Error' string
		 * @param r for internal use
		 * @param recurse for internal use
		 * @return list of events supported by the target object
		 * @private
		 */
		public static function listAllEventsFor(target:Object, onlyError:Boolean=false, r:Array=null, recurse:Boolean=true):Array
		{
			if (r == null)
				r=[];
			if (!target is Class && !target is EventDispatcher)
				return r;
			var xml:XML=describeType(target);
			for each (var x:XML in xml..metadata.(@name == 'Event'))
			{
				var s:String=String(x.arg.(@key == 'name').@value);
				if (s == '')
				{
					s=String(x.arg.(@key == '').@value);
				}
				if (!onlyError || (onlyError && s.indexOf('Error') > -1))
				{
					s='on' + s.charAt(0).toUpperCase() + s.substring(1);
					r.push(s)
				}
			}
			if (recurse)
			{
				for each (x in xml.extendsClass.@type)
				{
					if (x == 'flash.events::EventDispatcher')
						break;
					listAllEventsFor(getDefinitionByName(x), onlyError, r, false);
				}
				if (target is Loader)
					listAllEventsFor(LoaderInfo, onlyError, r, false);
				r.sort();
			}
			return r;
		}

		/**
		 * Listens to all events of the target object and traces the event details when the event occurs. 
		 * We can filter away events that we dont want to listen to using the regular expression parameters
		 * @param excludeMatching when specified it is used to exclude any matching event name from listening to for example /frame/i
		 * will ignore all events that contain 'frame' in their name (onEnterFrame, onExitFrame etc,.)
		 * @param includeMatching used to inlcude only the matching event names when specified. for example /mouse/i
		 * will only listen to mouse events (onMouseDown, onMouseUp etc,.)
		 */
		public function traceAllEvents(excludeMatching:RegExp=null, includeMatching:RegExp=null):void
		{
			var arr:Array=listAllEventsFor(_scope);
			for (var i:int=0; i < arr.length; i++)
			{
				var s:String=arr[i];
				if (excludeMatching != null && excludeMatching.test(s))
				{
					//trace('excluding', s)
					continue;
				}
				if (includeMatching != null && !includeMatching.test(s))
				{
					//trace('including', s)
					continue;
				}
				this[s]=function(e:Event):void
				{
					var name:String = e.target.hasOwnProperty('name') ? e.target.name : 'unnamed';
					trace('(' + getQualifiedClassName(e.target).split(':').pop() + ') ' + name + '.on' + e.type.charAt(0).toUpperCase() + e.type.substr(1), e);
					//var x:* = describeType(e)//..accessor.@name;
					//trace(x);
				}
			}
		}

		/**
		 * lists the events supported by the current target object
		 * @return list of events supported by the target object
		 *
		 */
		public function listAllEvents():Array
		{
			return listAllEventsFor(_scope);
		}

		/**
		 * lists the error events supported by the current target
		 * @return error events suported by the target
		 *
		 */
		public function listErrorEvents():Array
		{
			return listAllEventsFor(_scope, true);
		}

		/**
		 * list of active listeners on the current target
		 * @return event listener names as an array
		 *
		 */
		public function get listeners():Array
		{
			return _targets.listProperty(_scope, 'on');
		}

		/**
		 * helper method to remove all events added through the
		 * 'onEventName' syntax
		 * @return true if successful
		 *
		 */
		public function removeListeners():Boolean
		{
			var l:Array=listeners;
			if (l)
			{
				for each (var s:String in l)
				{
					delete this[s];
				}
			}
			return false;
		}

		/**
		 * sets and replaces the current target
		 * @param scope the target object to simplify
		 *
		 */
		public function set to(scope:EventDispatcher):void
		{
			_scope=scope;
			if (scope != null && this != _)
			{
				_instances[_scope]=this;
			}
		}

		public function get to():EventDispatcher
		{
			return _scope;
		}

		/*
		   public static function isSimpleType(o:*):Boolean
		   {
		   if (o is String || o is int || o is uint || o is Number)
		   return true;
		   return false;
		   }
		 */

		/**
		 * convenience property to refer to the last Loader that is being loaded
		 * @return Short version of the loader object or null if there is none
		 *
		 */
		public function get loadingChild():Short
		{
			if (_scope == null)
				throw new Error('Short needs a target, define one using _.to=target; syntax');
			return _targets.getProperty(_scope, 'loadingChild') as Short;
		}

		/**
		 * convenience method to load an image/swf into the current target
		 * it throws an error if the current target is not a valid display
		 * object container
		 * @param url url for the image/swf
		 * @param method A <code>GET</code> or <code>POST</code> method for sending variables. If there are no variables, omit this parameter.
		 * @param params Variables to be passed to the server wrapped as an object
		 * @return Short version of the loader object
		 *
		 */
		public function loadChild(url:String, method:String="GET", params:Object=null):Short
		{
			if (_scope == null)
				throw new Error('Short needs a target, define one using _.to=target; syntax');
			if (!_scope is DisplayObjectContainer)
				throw new Error('Current _.to target does not support loadChild method, use a DisplayObjectContainer instead');
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
			var loader:Loader=new Loader();
			loader.load(r);
			(_scope as DisplayObjectContainer).addChild(loader);
			var ret:Short=new Short(loader);
			_targets.addProperty(_scope, 'loadingChild', ret);
			return ret
		}

		/**
		 * optimized way of creating Short instance for the given object.
		 * It reuses the existing instance for the specic target when it
		 * can find one
		 * @param target object to be simplified
		 * @return Short version of the target object
		 *
		 */
		public static function getShort(target:EventDispatcher):Short
		{
			return _instances[target] != null ? _instances[target] : _instances[target]=new Short(target);
		}

		/**
		 *  @private
		 */
		private static function getListenerFunction(obj:EventDispatcher, eventName:String, func:Function, listenOnce:Boolean=false):Function
		{
			var target:EventDispatcher=obj;
			return function(e:Event):void
			{
				//trace('target', target, getShort(target));
				func.apply(getShort(target), func.length ? [e] : null);
				if (listenOnce)
					removeListener(target, eventName);
			}
		}

		/**
		 *  @private
		 */
		private static function addListener(obj:EventDispatcher, name:String, func:Function):void
		{
			if (func == null)
			{
				delete getShort(obj)[name];
				return;
			}
			var s:String=name;
			var listenOnce:Boolean=false;
			if (s.indexOf('once') == 0)
			{
				s=s.charAt(4).toLowerCase() + s.substring(5);
				listenOnce=true
			}
			else
			{
				s=s.charAt(2).toLowerCase() + s.substring(3);
			}
			if (_targets.hasProperty(obj, name))
			{
				delete getShort(obj)[name];
			}
			var listener:Function=getListenerFunction(obj, s, func, listenOnce)
			_targets.addProperty(obj, name, listener)
			if (obj is Loader && CONTENT_LOADER_INFO[name])
			{
				obj=Loader(obj).contentLoaderInfo;
			}
			obj.addEventListener(s, listener);
		}

		/**
		 *  @private
		 */
		private static function removeListener(obj:EventDispatcher, name:String):void
		{
			if (_targets.hasProperty(obj, name))
			{
				var s:String=name.indexOf('once') == 0 ? name.charAt(4).toLowerCase() + name.substring(5) : name.charAt(2).toLowerCase() + name.substring(3);
				try
				{
					if (obj is Loader && CONTENT_LOADER_INFO[name])
					{
						Loader(obj).contentLoaderInfo.removeEventListener(s, _targets.getProperty(obj, name) as Function);
					}
					else
					{
						obj.removeEventListener(s, _targets.getProperty(obj, name) as Function);
					}
				}
				catch (e:Error)
				{
					//trace(e.getStackTrace());
				}
				_targets.deleteProperty(obj, name);
			}

		}

		/**
		 *  @private
		 */
		flash_proxy override function setProperty(name:*, value:*):void
		{
			var s:String=String(name)
			if (_scope.hasOwnProperty(s))
			{
				_scope[s]=value;
				return;
			}
			if (s.indexOf('on') == 0)
			{
				addListener(_scope, s, value);
				return
			}
			_targets.addProperty(_scope, s, value);
		}

		/**
		 *  @private
		 */
		flash_proxy override function getProperty(name:*):*
		{
			if (_scope == null)
				throw new Error('Short needs a target, define one using _.to=target; syntax');
			if (_scope.hasOwnProperty(name))
			{
				return _scope[name] is EventDispatcher ? getShort(_scope[name]) : _scope[name];
			}
			if (_targets.hasProperty(_scope, name))
			{
				var r:Object=_targets.getProperty(_scope, name);
				return r is EventDispatcher ? getShort(r as EventDispatcher) : r;
			}
		}

		/**
		 *  @private
		 */
		flash_proxy override function deleteProperty(name:*):Boolean
		{
			var s:String=String(name);
			if (_scope.hasOwnProperty(s))
			{
				return delete _scope[s];
			}
			if (s.indexOf('on') == 0)
			{
				removeListener(_scope, s);
				return true;
			}
			if (_targets.hasProperty(_scope, s))
			{
				return _targets.deleteProperty(_scope, s);
			}
			return false;
		}

		/**
		 *  @private
		 */
		flash_proxy override function callProperty(name:*, ... args):*
		{
			var s:String=String(name);
			if (_scope.hasOwnProperty(s))
			{
				return _scope[s].apply(_scope, args);
			}
			if (_targets.hasProperty(_scope, s) && _targets.getProperty(_scope, s) is Function)
			{
				return _targets.getProperty(_scope, s).apply(getShort(_scope), args);
			}
		}

		/**
		 *  @private
		 */
		flash_proxy override function getDescendants(name:*):*
		{
			//TODO Auto-generated method stub
			//return super.getDescendants(name);
		}

		/**
		 *  @private
		 */
		flash_proxy override function hasProperty(name:*):Boolean
		{
			if (_scope.hasOwnProperty(name))
				return true;
			if (_targets.hasProperty(_scope, String(name)))
				return true;
			return false
		}

		/**
		 *  @private
		 */
		flash_proxy override function isAttribute(name:*):Boolean
		{
			//TODO Auto-generated method stub
			return false;
		}

		/**
		 *  @private
		 */
		flash_proxy override function nextName(index:int):String
		{
			//TODO Auto-generated method stub
			return '';
		}

		/**
		 *  @private
		 */
		flash_proxy override function nextNameIndex(index:int):int
		{
			//TODO Auto-generated method stub
			return 0;
		}

		/**
		 *  @private
		 */
		flash_proxy override function nextValue(index:int):*
		{
			//TODO Auto-generated method stub
			return 1;
		}

		/**
		 *  @private
		 */
		public function toString():String
		{
			return '[short ' + getQualifiedClassName(_scope).split('::').pop() + ']';
		}


	}
}