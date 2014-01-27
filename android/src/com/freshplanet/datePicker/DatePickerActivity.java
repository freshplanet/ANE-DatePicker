package com.freshplanet.datePicker;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;

import android.app.DatePickerDialog;
import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.support.v4.app.FragmentActivity;
import android.util.Log;
import android.view.Window;
import android.widget.DatePicker;

public class DatePickerActivity extends FragmentActivity
{	
	private static final String TAG = "[AirDatePicker] - DatePickerActivity";
	
	public static final String YEAR = "year";
	public static final String MONTH = "month";
	public static final String DAY = "day";
	
	public static final String MIN_DATE = "minDate";
	public static final String MAX_DATE = "maxDate";

	/** Every Activity invoked by the Native Extension.  Allows us to kill everything. */	
	private static ArrayList<DatePickerActivity> activities = new ArrayList<DatePickerActivity>();


	/** Our picker. */	
	private DialogFragment datePickerFragment;
	
    //-----------------------------------------------------//
	//					                     ACTIVITY API				   
	//-----------------------------------------------------//

	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		Log.d(TAG, "Entering onCreate");
		
		super.onCreate(savedInstanceState);
		
		this.requestWindowFeature(Window.FEATURE_NO_TITLE);
		
		activities.add(this);
		
		Bundle extras = this.getIntent().getExtras();
		Bundle args = new Bundle();

		args.putInt(YEAR,  extras.getInt(YEAR));
		args.putInt(MONTH, extras.getInt(MONTH));
		args.putInt(DAY, extras.getInt(DAY));
		
		if(extras.containsKey(MIN_DATE)) {
			args.putLong(MIN_DATE, extras.getLong(MIN_DATE));
		}
		
		if(extras.containsKey(MAX_DATE)) {
			args.putLong(MAX_DATE, extras.getLong(MAX_DATE));
		}

		datePickerFragment = new DatePickerFragment();
		datePickerFragment.setArguments(args);
		datePickerFragment.show(getSupportFragmentManager(), "datePicker");
		
		Log.d(TAG, "Exiting onCreate");
	}
	
	@Override
	public void onDestroy()
	{
		Log.d(TAG, "Entering onDestroy");
		
		super.onDestroy();
		
		this.datePickerFragment.dismiss();
				
		activities.remove(this);
		
		Log.d(TAG, "Exiting onDestroy");
	}
	
    //-----------------------------------------------------//
	//					                     DISPOSE LOGIC				   
	//-----------------------------------------------------//

	public static void dispose()
	{
		Log.d(TAG, "Entering dispose");
		
		for (DatePickerActivity activity:activities)
		{
			activity.finish();
		}
		
		Log.d(TAG, "Exiting dispose");
	}

    //-----------------------------------------------------//
	//					                 DIALOG FRAGMENT			   
	//-----------------------------------------------------//
	
	public static class DatePickerFragment extends DialogFragment implements DatePickerDialog.OnDateSetListener
	{
		private static final String TAG = "[AirDatePicker] - DatePickerFragment";

		//-----------------------------------------------------//
		//					                    DIALOG CREATION			   
		//-----------------------------------------------------//
		
		public Dialog onCreateDialog(Bundle savedInstanceState)
		{
			Log.d(TAG, "Entering onCreateDialog");
			Bundle args = this.getArguments();
			int year = args.getInt(YEAR);
			int month = args.getInt(MONTH);
			int day = args.getInt(DAY);
			
			AirDatePickerDialog picker = new AirDatePickerDialog( getActivity(), this, year, month, day);
			
			if(args.containsKey(MIN_DATE)) {
				picker.getDatePicker().setMinDate(args.getLong(MIN_DATE));
			}
			
			if(args.containsKey(MAX_DATE)) {
				picker.getDatePicker().setMaxDate(args.getLong(MAX_DATE));
			}
			
 			if (android.os.Build.VERSION.SDK_INT >= 11)
 			{
				picker.getDatePicker().setCalendarViewShown(false);
			}
			Log.d(TAG, "Exiting onCreateDialog");
			return picker;
		}

		//-----------------------------------------------------//
		//	   DatePickerDialog.OnDateSetListener IMPLEMENTATION			   
		//-----------------------------------------------------//
		
		public void onDateSet(DatePicker view, int year, int month, int date) 
		{
			Log.d(TAG, "Entering onDateSet");
			
			
			month = month + 1; // compensate Date representation differences between AS3 and Android
			String formattedDate = year + "-" + month + "-" + date;
			Extension.context.dispatchStatusEventAsync("CHANGE", formattedDate);
			
			DatePickerActivity.dispose();
			
			Log.d(TAG, "Exiting onDateSet");
		}

		//-----------------------------------------------------//
		//		                     CUSTOM DATE PICKER DIALOG
		//-----------------------------------------------------//
		
		/** 
		*  AirDatePickerDialog overrides onDateChanged() and reports every 
		*  date change back to the ActionScript side of the Native Extension 
		*/
		private class AirDatePickerDialog extends DatePickerDialog
		{
			private static final String TAG = "[AirDatePicker] - MyDatePickerDialog";
			
			// There is a bug in the Android API where the dateChange listener is triggered twice.
			// This is a workaround for this problem.  (store the previous date.)
			//   
			// @see http://stackoverflow.com/questions/12436073/datepicker-ondatechangedlistener-called-twice
			private String currentDate = "-1";
			
			public AirDatePickerDialog(Context context, OnDateSetListener callBack, int year, int monthOfYear, int dayOfMonth) {
				super(context, callBack, year, monthOfYear, dayOfMonth);
			}
			
			@Override
			protected void onStop()
			{
				Log.d(TAG, "Entering onStop");
				
				// removes the current stored date
				currentDate = "-1";
				
				DatePickerActivity.dispose();
				
				Log.d(TAG, "Exiting onStop");
			}
			
			@Override
			public void onDateChanged(DatePicker view, int year, int month, int day) 
			{
				Log.d(TAG, "Entering onDateChanged");
				
				// Send the new Date back to the AS3 side of the Native Extension
				month = month + 1; // compensate Date representation differences between AS3 and Android
				String formattedDate = year + "-" + month + "-" + day;
				if ( currentDate.equals(formattedDate) == false ) {
					currentDate = formattedDate;
					Extension.context.dispatchStatusEventAsync("UPDATE", formattedDate);
				}
				
				Log.d(TAG, "Exiting onDateChanged");
			}
		};
		
	}

}
