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

#import "AirDatePicker.h"

FREContext AirDatePickerCtx = nil;

@interface AirDatePicker ()

-(void)dateChanged:(id)sender;

@end

@implementation AirDatePicker

@synthesize datePicker = _datePicker;

#pragma mark - Singleton

static AirDatePicker *sharedInstance = nil;

+ (AirDatePicker *)sharedInstance
{
    if (!sharedInstance)
    {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copy
{
    return self;
}

#pragma mark - UIDatePicker
-(void) start:(NSDate *)date
{
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 250, 325, 250)];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.hidden = NO;
    self.datePicker.date = [NSDate date];
    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];

    UIView *rootView = [[[[UIApplication sharedApplication] keyWindow] rootViewController] view];
    [rootView addSubview:self.datePicker];
    [self.datePicker release];    
}

#pragma mark - UIAlertViewDelegate

- (void)dateChanged:(id) sender
{
    // Use date picker to write out the date in a friendly format
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    NSString *formatedDate = [df stringFromDate:self.datePicker.date];
    FREDispatchStatusEventAsync(AirDatePickerCtx, (const uint8_t *)"CHANGE", (const uint8_t *)[formatedDate UTF8String]);
}

@end


#pragma mark - C interface

DEFINE_ANE_FUNCTION(AirDatePickerDisplayDatePicker)
{
    uint32_t stringLength;
    
    NSString *year = nil;
    NSString *month = nil;
    NSString *day = nil;
    
    // Retrieve title
    const uint8_t *yearString;
    if (FREGetObjectAsUTF8(argv[0], &stringLength, &yearString) == FRE_OK)
    {
        year = [NSString stringWithUTF8String:(char *)yearString];
    }
    
    // Retrieve message
    const uint8_t *monthString;
    if (FREGetObjectAsUTF8(argv[1], &stringLength, &monthString) == FRE_OK)
    {
        month = [NSString stringWithUTF8String:(char *)monthString];
    }
    
    // Retrieve button 1
    const uint8_t *dayString;
    if (FREGetObjectAsUTF8(argv[2], &stringLength, &dayString) == FRE_OK)
    {
        day = [NSString stringWithUTF8String:(char *)dayString];
    }
    
    // Setup and show the Date Picker
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyy-MM-dd"];
    NSDate *date = [df dateFromString:[NSString stringWithFormat:@"%@/%@/%@",year,month,day]];
    [[AirDatePicker sharedInstance] start:date];    
    
    return nil;
}


#pragma mark - ANE setup

void AirDatePickerContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    // Register the links btwn AS3 and ObjC. (dont forget to modify the nbFuntionsToLink integer if you are adding/removing functions)
    NSInteger nbFuntionsToLink = 1;
    *numFunctionsToTest = nbFuntionsToLink;
    
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * nbFuntionsToLink);
    
    func[0].name = (const uint8_t*) "AirDatePickerDisplayDatePicker";
    func[0].functionData = NULL;
    func[0].function = &AirDatePickerDisplayDatePicker;
    
    *functionsToSet = func;
    
    AirDatePickerCtx = ctx;
}

void AirDatePickerContextFinalizer(FREContext ctx) { }

void AirDatePickerInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
	*extDataToSet = NULL;
	*ctxInitializerToSet = &AirDatePickerContextInitializer;
	*ctxFinalizerToSet = &AirDatePickerContextFinalizer;
}

void AirDatePickerFinalizer(void* extData) { }