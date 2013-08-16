//
//  APFlipClock.h
//  APFlipClockDemo
//
//  Created by Mathias Amnell on 2013-08-15.
//  Copyright (c) 2013 Apping AB. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, APFlipClockType) {
    
    APFlipClockTypeClock,
    APFlipClockTypeCountdown
};

@interface APFlipClock : UIView

@property (nonatomic, strong) NSDate *countdownDate;
@property (nonatomic) APFlipClockType clockType;

@property (nonatomic) BOOL showLabels;

@property (nonatomic) BOOL showDays;
@property (nonatomic) BOOL showHours;
@property (nonatomic) BOOL showMinutes;
@property (nonatomic) BOOL showSeconds;


//- (id)initWithCountdownToTime:(NSDate *)time showsSeconds:(BOOL)showsSeconds showsLabels:(BOOL)showsLabels;
//- (id)initClockWithLabels:(BOOL)showsLabels showsSeconds:(BOOL)showsSeconds;

@end
