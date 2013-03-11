//////////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Freshplanet (http://freshplanet.com | opensource@freshplanet.com)
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//    http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//  
//////////////////////////////////////////////////////////////////////////////////////

package com.freshplanet.ane.AirDatePicker
{
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;

	import flash.geom.Point;
	
	public class AirDatePicker extends EventDispatcher
	{
		// --------------------------------------------------------------------------------------//
		//																						 //
		// 									   PUBLIC API										 //
		// 																						 //
		// --------------------------------------------------------------------------------------//
		
		/** AirDatePicker is supported on iOS and Android devices. */
		public static function get isSupported() : Boolean
		{
			return Capabilities.manufacturer.indexOf("iOS") != -1 || Capabilities.manufacturer.indexOf("Android") != -1;
		}
		
		public function AirDatePicker()
		{
			if (!_instance)
			{
				_context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
				if (!_context)
				{
					throw Error("ERROR - Extension context is null. Please check if extension.xml is setup correctly.");
					return;
				}
				_context.addEventListener(StatusEvent.STATUS, onStatus);
				
				_instance = this;
			}
			else
			{
				throw Error("This is a singleton, use getInstance(), do not call the constructor directly.");
			}
		}
		
		public static function getInstance() : AirDatePicker
		{
			return _instance ? _instance : new AirDatePicker();
		}
		
		public function displayDatePicker( date : Date, position : Point, callback : Function ) : void
		{
			if (!isSupported) return;
			
			_callback = callback;
			
			_context.call("AirDatePickerDisplayDatePicker", date.fullYear, date.month, date.day, position.x, position.y);
		}

		public function removeDatePicker( ) : void
		{
			if (!isSupported) return;
			
			_context.call("AirDatePickerRemoveDatePicker");
		}
		
		
		// --------------------------------------------------------------------------------------//
		//																						 //
		// 									 	PRIVATE API										 //
		// 																						 //
		// --------------------------------------------------------------------------------------//
		
		private static const EXTENSION_ID : String = "com.freshplanet.AirDatePicker";
		
		private static var _instance : AirDatePicker;
		
		private var _context : ExtensionContext;
		
		private var _callback : Function = null;
		
		private function onStatus( event : StatusEvent ) : void
		{
			if (event.code == "CHANGE")
			{
				if (_callback !== null)
				{
					var newDate : String = event.level as String;
					trace("[AirDatePicker] new date from Native Extension : ",newDate);	
					_callback(newDate);
				}
				else
				{
					trace("Error: There is no callback, cannot return the picked date");
				}
			}
		}
	}
}