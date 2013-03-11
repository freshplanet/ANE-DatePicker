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

#import "FlashRuntimeExtensions.h"

@interface AirDatePicker : NSObject <UIPopoverControllerDelegate>

@property (nonatomic, retain) UIDatePicker *datePicker;

+ (AirDatePicker *)sharedInstance;
- (void) showDatePickerPhone:(NSDate*)date;
- (void) showDatePickerPad:(NSDate*)date position:(CGSize)pos;
- (void) removeDatePicker;

// UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController;
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController;

@end

// C interface
DEFINE_ANE_FUNCTION(AirDatePickerDisplayDatePicker);
DEFINE_ANE_FUNCTION(AirDatePickerRemoveDatePicker);

// ANE setup
void AirDatePickerContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet);
void AirDatePickerContextFinalizer(FREContext ctx);
void AirDatePickerInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet);
void AirDatePickerFinalizer(void* extData);