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
	
	private static ArrayList<DatePickerActivity> activities = new ArrayList<DatePickerActivity>();
	
	private DialogFragment datePickerFragment;
	private static GregorianCalendar currentDateValue;
	
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		Log.d(TAG, "Entering onCreate");
		
		super.onCreate(savedInstanceState);
		
		this.requestWindowFeature(Window.FEATURE_NO_TITLE);
		
		
		activities.add(this);
		
		Bundle extras = this.getIntent().getExtras();
		int year = extras.getInt("year");
		int month = extras.getInt("month");
		int day = extras.getInt("day");
		
		currentDateValue = new GregorianCalendar(year, month, day);

		datePickerFragment = new DatePickerFragment();
		datePickerFragment.show(getSupportFragmentManager(), "datePicker");
		
		Log.d(TAG, "Exiting onCreate");
	}
	
	@Override
	public void onDestroy()
	{
		Log.d(TAG, "Entering onDestroy");
		
		super.onDestroy();
		
		this.datePickerFragment.dismiss();
		currentDateValue = null;
				
		activities.remove(this);
		
		Log.d(TAG, "Exiting onDestroy");
	}
	
	public static void dispose()
	{
		Log.d(TAG, "Entering dispose");
		
		for (DatePickerActivity activity:activities)
		{
			activity.finish();
		}
		
		Log.d(TAG, "Exiting dispose");
	}
	
	public static class DatePickerFragment extends DialogFragment implements DatePickerDialog.OnDateSetListener
	{
		private static final String TAG = "[AirDatePicker] - DatePickerFragment";
		
		public Dialog onCreateDialog(Bundle savedInstanceState)
		{
			Log.d(TAG, "Entering onCreateDialog");
			
			final Calendar c = DatePickerActivity.currentDateValue;
			int year = c.get(Calendar.YEAR);
			int month = c.get(Calendar.MONTH);
			int day = c.get(Calendar.DAY_OF_MONTH);
			
			MyDatePickerDialog picker = new MyDatePickerDialog( getActivity(), this, year, month, day);
			
			Log.d(TAG, "Exiting onCreateDialog");
			return picker;
		}
		
		public void onDateSet(DatePicker view, int year, int month, int date) 
		{
			Log.d(TAG, "Entering onDateSet");
			
			DatePickerActivity.dispose();
			
			Log.d(TAG, "Exiting onDateSet");
		}
		
		private class MyDatePickerDialog extends DatePickerDialog
		{
			private static final String TAG = "[AirDatePicker] - MyDatePickerDialog";
			
			// store the previous date.  
			// @see http://stackoverflow.com/questions/12436073/datepicker-ondatechangedlistener-called-twice
			private String currentDate = "-1";
			
			public MyDatePickerDialog(Context context, OnDateSetListener callBack, int year, int monthOfYear, int dayOfMonth) {
				super(context, callBack, year, monthOfYear, dayOfMonth);
			}
			
			@Override
			protected void onStop()
			{
				Log.d(TAG, "Entering onStop");
				
				currentDate = "-1";
				
				Log.d(TAG, "Exiting onStop");
			}
			
			@Override
			public void onDateChanged(DatePicker view, int year, int month, int day) 
			{
				Log.d(TAG, "Entering onDateChanged");
				
				super.onDateChanged(view, year, month, day);
				
				month = month + 1; // compensate Date representation differences between AS3 and Android
				String formattedDate = year + "-" + month + "-" + day;
				
				if ( currentDate.equals(formattedDate) == false )
				{
					Log.d(TAG, "Date change, CHANGE dispatched");
					currentDate = formattedDate;
					Extension.context.dispatchStatusEventAsync("CHANGE", formattedDate);
				}
				else
				{
					Log.d(TAG, "Date didn't change, will not dispatch CHANGE");
				}
				
				
				Log.d(TAG, "Exiting onDateChanged");
			}
		};
		
	}

}
