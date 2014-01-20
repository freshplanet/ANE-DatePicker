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

package com.freshplanet.datePicker;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import android.content.Intent;
import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.freshplanet.datePicker.functions.AirDatePickerDisplayDatePicker;
import com.freshplanet.datePicker.functions.AirDatePickerRemoveDatePicker;
import com.freshplanet.datePicker.functions.SetMaxDateFunction;
import com.freshplanet.datePicker.functions.SetMinDateFunction;

public class ExtensionContext extends FREContext 
{
	private static final String TAG = "[AirDatePicker] - ExtensionContext";
	
	private Date minDate;
	private Date maxDate;
	
	// Public API
	
	@Override
	public void dispose() { }

	//-----------------------------------------------------//
	// 										 EXTENSION API
	//-----------------------------------------------------//

	@Override
	public Map<String, FREFunction> getFunctions()
	{
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
		
		functionMap.put("AirDatePickerDisplayDatePicker", new AirDatePickerDisplayDatePicker());
		functionMap.put("AirDatePickerRemoveDatePicker", new AirDatePickerRemoveDatePicker());
		functionMap.put("setMinimumDate", new SetMinDateFunction());
		functionMap.put("setMaximumDate", new SetMaxDateFunction());
		
		return functionMap;	
	}

	//-----------------------------------------------------//
	//					                   DATE PICKER API	
	//-----------------------------------------------------//

	public void displayDatePicker(int year, int month, int day) 
	{
		Log.d(TAG, "Entering displayDatePicker");
		
		Intent displayDatePickerIntent = new Intent(getActivity().getApplicationContext(), DatePickerActivity.class );
		displayDatePickerIntent.putExtra("year", year);
		displayDatePickerIntent.putExtra("month", month - 1);  // compensates Date difference between AS3 and Android
		displayDatePickerIntent.putExtra("day", day);
		getActivity().startActivity(displayDatePickerIntent);
		
		Log.d(TAG, "Exiting displayDatePicker");
	}
	
	public void removeDatePicker() 
	{
		Log.d(TAG, "Entering removeDatePicker");
		
		DatePickerActivity.dispose();
		
		Log.d(TAG, "Exiting removeDatePicker");
	}
	

	public void setMinDate(Date date) 
	{
		minDate = date;
	}
	
	public void setMaxDate(Date date) 
	{
		maxDate = date;
	}
	
	
}
