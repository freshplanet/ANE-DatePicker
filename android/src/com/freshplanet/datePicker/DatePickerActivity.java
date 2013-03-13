package com.freshplanet.datePicker;

import java.util.ArrayList;
import java.util.Calendar;

import android.app.DatePickerDialog;
import android.app.Dialog;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.support.v4.app.FragmentActivity;
import android.util.Log;
import android.widget.DatePicker;

public class DatePickerActivity extends FragmentActivity
{	
	private static final String TAG = "[AirDatePicker] - DatePickerActivity";
	
	private static ArrayList<DatePickerActivity> activities = new ArrayList<DatePickerActivity>();
	
	private DialogFragment datePickerFragment;
	
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		Log.d(TAG, "Entering onCreate");
		
		super.onCreate(savedInstanceState);
		
		activities.add(this);
		
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
			
			final Calendar c = Calendar.getInstance();
			int year = c.get(Calendar.YEAR);
			int month = c.get(Calendar.MONTH);
			int day = c.get(Calendar.DAY_OF_MONTH);
			
			DatePickerDialog picker = new DatePickerDialog( getActivity(), this, year, month, day);
			
			Log.d(TAG, "Exiting onCreateDialog");
			return picker;
		}
		
		public void onDateSet(DatePicker view, int year, int month, int date) 
		{
			Log.d(TAG, "Entering onDateSet");
			
			String formattedDate = year + "-" + month + "-" + date; 
			Extension.context.dispatchStatusEventAsync("EVENT", formattedDate);
			
			Log.d(TAG, "Exiting onDateSet");
		}
		
	}

}
