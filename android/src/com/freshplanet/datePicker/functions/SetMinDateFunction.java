package com.freshplanet.datePicker.functions;

import java.util.Date;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.freshplanet.datePicker.Extension;

public class SetMinDateFunction implements FREFunction {

	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		// TODO Auto-generated method stub
		if ((arg1.length == 1) && Extension.context != null) {
			FREObject as3date = arg1[0];
			if(as3date == null) {
				Extension.context.setMinDate(null);
			} else {
				try {
					long milliseconds = (long) as3date.getProperty("time").getAsDouble();
					Extension.context.setMinDate(new Date(milliseconds));
				} catch (Exception e) {
					Log.e("AirDatePicker", "error in SetMinDateFunction.call", e);
					Extension.context.setMinDate(null);
				}
			}
		}
		return null;
	}

}
