Air Native Extension for Date Picker (iOS + Android)
======================================

This is an [Air native extension](http://www.adobe.com/devnet/air/native-extensions-for-air.html) for using native date pickers on iOS and Android. It has been developed by [FreshPlanet](http://freshplanet.com).


Installation
---------

The ANE binary (AirAlert.ane) is located in the *bin* folder. You should add it to your application project's Build Path and make sure to package it with your app (more information [here](http://help.adobe.com/en_US/air/build/WS597e5dadb9cc1e0253f7d2fc1311b491071-8000.html)).


Usage
-----

If you are going to be targeting Android, add the DatePickerActivity to your AIR application configuration file:

```xml
<!-- AirDatePicker -->
<activity android:name="com.freshplanet.datePicker.DatePickerActivity" android:theme="@android:style/Theme.Holo.Dialog"/>
```

```actionscript
// Required params
var currentDate : Date = new Date();
var callback : Function = function( selectedDate:String ) : void {
	trace("selected date = ", selectedDate.toString());
}
// Native extension call
AirDatePicker.instance.displayDatePicker(currentDate, callback);
```    
For iPad you can define custom positioning of the picker.

For more information, please look at the Actionscript documentation in [AirDatePicker.as](https://github.com/freshplanet/ANE-DatePicker/blob/master/actionscript/src/com/freshplanet/ane/AirDatePicker/AirDatePicker.as).


Build script
---------

Should you need to edit the extension source code and/or recompile it, you will find an ant build script (build.xml) in the *build* folder:

    cd /path/to/the/ane/build
    mv example.build.config build.config
    #edit the build.config file to provide your machine-specific paths
    ant


Authors
------

This ANE has been written by [Daniel Rodriguez](http://www.linkedin.com/in/danielrodriguezc/). It belongs to [FreshPlanet Inc.](http://freshplanet.com) and is distributed under the [Apache Licence, version 2.0](http://www.apache.org/licenses/LICENSE-2.0).



Join the FreshPlanet team - GAME DEVELOPMENT in NYC
------

We are expanding our mobile engineering teams.

FreshPlanet is a NYC based mobile game development firm and we are looking for senior engineers to lead the development initiatives for one or more of our games/apps. We work in small teams (6-9) who have total product control.  These teams consist of mobile engineers, UI/UX designers and product experts.


Please contact Tom Cassidy (tcassidy@freshplanet.com) or apply at http://freshplanet.com/jobs/
