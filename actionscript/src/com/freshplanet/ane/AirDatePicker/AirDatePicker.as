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
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	public class AirDatePicker extends EventDispatcher
	{
		// --------------------------------------------------------------------------------------//
		//																						 //
		// 									   PUBLIC API										 //
		// 																						 //
		// --------------------------------------------------------------------------------------//
		
		public static const EVENT_CHANGE:String = "CHANGE";
		public static const EVENT_UPDATE:String = "UPDATE";
		public static const EVENT_CANCEL:String = "CANCEL";
		
		private var _minimumDate:Date;
		private var _maximumDate:Date;
		
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
		

		/**
		* Display a Date (month, day, year) picker, using a Native implementation.<br><br>
		*
		* For Apple devices we rely on the iOS SDK's UIDatePicker.  For Android, we rely on a DialogFragment
		* containing a custom DatePickerDialog.<br><br> 
		*
		* Android devices should define the DatePickerActivity's theme as @android:style/Theme.Holo.Dialog to 
		* present the Activity as a true Dialog. <br><br>
		*
		* @param date An AS3 Date object used to show a certain date by default in the picker.
		* @param callback A callback function of the folllowing form:
		* <code>function myCallback( selectedDate : String ): void</code>.  The <code>selectedDate</code> parameter
		* will contain the selected date in the following format:  <code>yyyy-mm-dd</code>
		* @param anchor (optional) On the iPad, the UIDatePicker is displayed in a popover that 
		* doesn't cover the whole screen. This parameter is the anchor from which the
		* popover will be presented. For example, it could be the bounds of the button
		* on which the user clicked to display the image picker. Note that you should
		* use absolute stage coordinates. Example: <code>var anchor:Rectangle = 
		* myButton.getBounds(stage);</code>
		*
		* @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/Date.html
		* @see http://developer.apple.com/library/ios/#documentation/uikit/reference/UIDatePicker_Class/Reference/UIDatePicker.html
		* @see http://developer.apple.com/library/ios/#documentation/uikit/reference/UIPopoverController_class/Reference/Reference.html
		* @see http://developer.android.com/reference/android/app/DatePickerDialog.html
		* @see http://developer.android.com/guide/topics/ui/controls/pickers.html
		* @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/Date.html
		*
		**/
		public function displayDatePicker( date : Date, callback : Function, anchor : Rectangle = null ) : void
		{
			if (!isSupported) return;
			
			_callback = callback;
			
			var month : Number = date.month + 1; // as3 date: january[0], ..., december[11] 

			if (anchor != null)
			{
				_context.call("AirDatePickerDisplayDatePicker", date.fullYear.toString(), month.toString(), date.date.toString(), anchor);	
			}
			else
			{
				_context.call("AirDatePickerDisplayDatePicker", date.fullYear.toString(), month.toString(), date.date.toString());		
			}	
		}
		
		public function setMinimumDate( date:Date ) : void 
		{
			if(date) {
				_context.call("setMinimumDate", date.time);
			} else {
				_context.call("clearMinimumDate");
			}
		}
		
		
		public function setMaximumDate( date:Date ) : void 
		{
			if(date) {
				_context.call("setMaximumDate", date.time);
			} else {
				_context.call("clearMaximumDate");
			}
		}
		
		public function clearMaximumDate() : void 
		{
			_context.call("clearMinimumDate");
		}

		/** Dismisses the DatePicker from the screen. */
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
			if (event.code == EVENT_CHANGE)
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
			if(this.hasEventListener(StatusEvent.STATUS)) 
			{
				this.dispatchEvent(event);
			}
		}
	}
}