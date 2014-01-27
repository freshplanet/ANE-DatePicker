package com.freshplanet.datePicker.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.freshplanet.datePicker.Extension;

public class ClearMinDateFunction implements FREFunction {

	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		if (Extension.context != null) {
			Extension.context.setMinDate(null);
		}
		return null;
	}

}
