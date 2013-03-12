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

@property (nonatomic,retain) UIPopoverController *popover;

-(void)dateChanged:(id)sender;

@end

@implementation AirDatePicker

@synthesize popover = _popover;
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

-(void) showDatePickerPhone:(NSDate *)date
{
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 250, 325, 250)];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.hidden = NO;
    self.datePicker.date = date;
    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];

    UIView *rootView = [[[[UIApplication sharedApplication] keyWindow] rootViewController] view];
    [rootView addSubview:self.datePicker];   
}

- (void) showDatePickerPad:(NSDate*)date position:(CGSize)pos
{
    UIView *rootView = [[[[UIApplication sharedApplication] keyWindow] rootViewController] view];
    
    UIViewController* popoverContent = [[UIViewController alloc] init];
    
    UIView *popoverView = [[UIView alloc] init];
    popoverView.backgroundColor = [UIColor blackColor];
    
    self.datePicker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 320, 216)];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.hidden = NO;
    self.datePicker.date = date;
    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    [popoverView addSubview:self.datePicker];
    popoverContent.view = popoverView;
    self.popover = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    
    [self.popover setPopoverContentSize:CGSizeMake(320, 264) animated:NO];
    [self.popover presentPopoverFromRect:CGRectMake(pos.width, pos.height, 320, 216) inView:rootView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (void) removeDatePicker
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        [self.popover dismissPopoverAnimated:YES];
    }
    else
    {
        [self.datePicker removeFromSuperview];
    }
}

#pragma mark - UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return NO;
}

#pragma mark - UIAlertViewDelegate

- (void)dateChanged:(id) sender
{
    // Use date picker to write out the date in a %Y-%m-%d format
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyy-MM-dd"];
    NSString *formatedDate = [df stringFromDate:self.datePicker.date];
    
    // send data to actionscript
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
    
    // Retrieve year
    const uint8_t *yearString;
    if (FREGetObjectAsUTF8(argv[0], &stringLength, &yearString) == FRE_OK)
    {
        year = [NSString stringWithUTF8String:(char *)yearString];
    }
    
    // Retrieve month
    const uint8_t *monthString;
    if (FREGetObjectAsUTF8(argv[1], &stringLength, &monthString) == FRE_OK)
    {
        month = [NSString stringWithUTF8String:(char *)monthString];
    }
    
    // Retrieve day
    const uint8_t *dayString;
    if (FREGetObjectAsUTF8(argv[2], &stringLength, &dayString) == FRE_OK)
    {
        day = [NSString stringWithUTF8String:(char *)dayString];
    }
    
    NSLog(@"day, month, year = %@ %@ %@",day,month,year);
    
    // According to the tr35-10 standard, date format should be MMMM/dd/yyyy.
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    NSDate *date = [df dateFromString:[NSString stringWithFormat:@"%@/%@/%@",month,day,year]];
    
    // show the date picker (use the correct form factor)
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        // get the position where we want the DatePicker to be rendered.
        int32_t xValue;
        int32_t yValue;
        FREGetObjectAsInt32(argv[3], &xValue);
        FREGetObjectAsInt32(argv[4], &yValue);
        
        [[AirDatePicker sharedInstance] showDatePickerPad:date position:CGSizeMake(xValue, yValue)];
    }
    else
    {
        [[AirDatePicker sharedInstance] showDatePickerPhone:date];
    }
    
    return nil;
}

DEFINE_ANE_FUNCTION(AirDatePickerRemoveDatePicker)
{
    [[AirDatePicker sharedInstance] removeDatePicker];
    
    return nil;
}


#pragma mark - ANE setup

void AirDatePickerContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    // Register the links btwn AS3 and ObjC. (dont forget to modify the nbFuntionsToLink integer if you are adding/removing functions)
    NSInteger nbFuntionsToLink = 2;
    *numFunctionsToTest = nbFuntionsToLink;
    
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * nbFuntionsToLink);
    
    func[0].name = (const uint8_t*) "AirDatePickerDisplayDatePicker";
    func[0].functionData = NULL;
    func[0].function = &AirDatePickerDisplayDatePicker;

    func[1].name = (const uint8_t*) "AirDatePickerRemoveDatePicker";
    func[1].functionData = NULL;
    func[1].function = &AirDatePickerRemoveDatePicker;
    
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