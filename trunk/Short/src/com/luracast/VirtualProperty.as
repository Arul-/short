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
package com.luracast {
    import flash.utils.Dictionary;

    /**
     * VirtualProperty is used by Short internally to keep track of the event handlers
     * and other virtual properties and methods added to target objects
     * @langversion 3.0
     * @playerversion Flash 9
     * @playerversion AIR 1.0
     * @productversion Short 1.0
     */
    public class VirtualProperty {

        /**
         * dictionary used to hold mapped relationships
         */
        protected var store:Dictionary = new Dictionary(true);

        /**
         * adds virtual property to the given object
         * @param object target object
         * @param property name of the property
		 * @param value value to set for the property
         */
        public function addProperty(object:Object, property:String, value:Object):void {
            var d:Dictionary;
            if (store[object] != undefined) {
                d = store[object];
            } else {
                d = store[object] = new Dictionary(true);
            }
            d[property] = value;
            d[value] = property;
        }

        /**
         * get the virtual property that was previously added by
         * <code>addProperty()</code>
         * @param object target object
         * @param property name of the property
         * @return value of the property
         */
        public function getProperty(object:Object, property:String):Object {
            return store[object] != undefined ? store[object][property] : null;
        }

        /**
         * check if the given virtual property is present on
         * the given object
         * @param object target object
         * @param property name of the property
         * @return true or false
         */
        public function hasProperty(object:Object, property:String):Boolean {
            return store[object] != undefined && store[object][property] != undefined;
        }

        /**
         * list all the virtual properties for the given object
         * @param object target object
         * @param filter use a prefix like <code>on</code> to filter only events etc,.
         * @return array of the property names
         */
        public function listProperty(object:Object, filter:String = ''):Array {
            var r:Array = [];
            for each (var v:Object in store[object]) {
                if (v is String && (filter == '' || v.indexOf(filter) == 0)) {
                    r.push(v);
                }
            }
            return r;
        }

        /**
         * delete the specified virtual property on the given object
         * it will also remove references to the object when you delete
         * the last virtual property
         * @param object target object
         * @param property name of the property
         * @return true if the deletion is successful
         */
        public function deleteProperty(object:Object, property:String):Boolean {
            if (hasProperty(object, property)) {
                var value:Object = store[object][property];
                delete store[object][property];
                delete store[object][value];
                var lastProperty:Boolean = true;
                for each (var v:Object in store[object]) {
                    lastProperty = false;
                    break;
                }
                if (lastProperty)
                    delete store[object];
                return true
            }
            return false;
        }
    }
}