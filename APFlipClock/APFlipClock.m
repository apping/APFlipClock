//
//  APFlipClock.h
//  APFlipClockDemo
//
//  Created by Mathias Amnell on 2013-08-15.
//  Copyright (c) 2013 Apping AB. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "APFlipClock.h"
#import "APFlipClockSegment.h"

static CGFloat segmentMargin = 4;
static CGSize segmentSize = { 74, 68 };

@interface APFlipClock ()

@end

@implementation APFlipClock {
    NSTimer *_timer;
    APFlipClockSegment *_daysSegment;
    APFlipClockSegment *_hoursSegment;
    APFlipClockSegment *_minutesSegment;
    APFlipClockSegment *_secondsSegment;
}

- (void)dealloc
{
    [_timer invalidate];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Create the segments
        _daysSegment = [[APFlipClockSegment alloc] initWithDigits:0];
        _hoursSegment = [[APFlipClockSegment alloc] initWithDigits:0];
        _minutesSegment = [[APFlipClockSegment alloc] initWithDigits:0];
        _secondsSegment = [[APFlipClockSegment alloc] initWithDigits:0];
        
        self.backgroundColor = [UIColor clearColor];
        
        // We default to the current time
        [self setClockType:APFlipClockTypeCountdown];
    }
    return self;
}

- (void)setClockType:(APFlipClockType)clockType
{
    _clockType = clockType;
    [_timer invalidate];
        
    switch (_clockType) {
        case APFlipClockTypeClock: {
            [self initClock];
        }
            break;
        case APFlipClockTypeCountdown:
            [self setCountdownDate:nil];
        default:
            break;
    }
}

- (void)setCountdownDate:(NSDate *)date {
    [_timer invalidate];
    _countdownDate = date;
    NSTimeInterval seconds = [_countdownDate timeIntervalSinceNow];

    if (seconds < 0) {
        seconds = 0;
    }
    
    if (seconds > 60 * 60 * 24) {
        _showDays = YES;
    }
    
    NSInteger days = seconds / (60 * 60 * 24);
    NSInteger hour = (seconds - (days * 60 * 60 * 24)) / (60 * 60);
    NSInteger min = (seconds - (days * 60 * 60 * 24) - (hour * 60 * 60)) / 60;
    NSInteger sec = (seconds - (days * 60 * 60 * 24) - (hour * 60 * 60) - min * 60);
    
    [self initializeAppearanceWithDays:days hours:hour minutes:min seconds:sec];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:_showSeconds ? 1 : 60 target:self selector:@selector(flip) userInfo:nil repeats:YES];
    if (!_showSeconds) {
        [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:sec]];
    }
}

- (void)initClock {
    NSDate *now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:now];
    
    [self initializeAppearanceWithDays:0 hours:comps.hour minutes:comps.minute seconds:comps.second];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:_showSeconds ? 1 : 60 target:self selector:@selector(flipClock) userInfo:nil repeats:YES];
    if (!_showSeconds) {
        [_timer setFireDate:[now dateByAddingTimeInterval:60 - comps.second]];
    } else {
        [_timer setFireDate:[now dateByAddingTimeInterval:1.0f - (double)[now timeIntervalSinceReferenceDate] - (int)[now timeIntervalSinceReferenceDate]]];
    }
}

- (void)initializeAppearanceWithDays:(NSInteger)days hours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds {
    self.showDays = NO;
    self.showHours = YES;
    self.showMinutes = YES;
    self.showSeconds = YES;
    
    [_daysSegment flipWithDigits:days animated:NO];
    [_hoursSegment flipWithDigits:hours animated:NO];
    [_minutesSegment flipWithDigits:minutes animated:NO];
    [_secondsSegment flipWithDigits:seconds animated:NO];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSMutableArray *segments = [NSMutableArray arrayWithCapacity:4];
    
    if (_showDays) {
        [segments addObject:_daysSegment];
    }
    
    if (_showHours) {
        [segments addObject:_hoursSegment];
    }
    
    if (_showMinutes) {
        [segments addObject:_minutesSegment];
    }
    
    if (_showSeconds) {
        [segments addObject:_secondsSegment];
    }
    
    CGFloat clockWidth = ([segments count]*segmentSize.width)+((([segments count]-1)*segmentMargin));
    CGFloat xOffset = floor(self.frame.size.width/2-clockWidth/2);
    
    NSInteger index = 0;
    for (APFlipClockSegment *segment in segments) {
        if (index == 0) {
            [segment setFrame:CGRectMake(xOffset+(segmentSize.width*index), 0, segmentSize.width, segmentSize.height)]; // No segment margin
        }
        else {
            [segment setFrame:CGRectMake(xOffset+(segmentSize.width*index)+segmentMargin*index, 0, segmentSize.width, segmentSize.height)]; // Segment margin
        }
        
        index++;
        
    }
}

#pragma mark -
#pragma mark Visibility of sections

- (void)setShowDays:(BOOL)showDays {
    _showDays = showDays;
    
    if (_showDays) {
        [self addSubview:_daysSegment];
    }
    else {
        [_daysSegment removeFromSuperview];
    }
    
    [self setNeedsLayout];
}

- (void)setShowHours:(BOOL)showHours {
    _showHours = showHours;
    
    if (_showHours) {
        [self addSubview:_hoursSegment];
    }
    else {
        [_hoursSegment removeFromSuperview];
    }
    
    [self setNeedsLayout];
}

- (void)setShowMinutes:(BOOL)showMinutes {
    _showMinutes = showMinutes;
    
    if (_showMinutes) {
        [self addSubview:_minutesSegment];
    } else {
        [_minutesSegment removeFromSuperview];
    }
    
    [self setNeedsLayout];
}

- (void)setShowSeconds:(BOOL)showSeconds {
    _showSeconds = showSeconds;
    
    if (_showSeconds) {
        [self addSubview:_secondsSegment];
    } else {
        [_secondsSegment removeFromSuperview];
    }
    
    [self setNeedsLayout];
}

#pragma mark - 
#pragma mark Flipping

- (void)flip {
    NSInteger seconds = (int)[_countdownDate timeIntervalSinceNow];
    if (seconds < 0) {
        [_timer invalidate];
        return;
    }
    
    NSInteger days = seconds / (60 * 60 * 24);
    [_daysSegment flipWithDigits:days];

    NSInteger hour = (seconds - (days * 60 * 60 * 24)) / (60 * 60);
    [_hoursSegment flipWithDigits:hour];
    
    NSInteger min = (seconds - (days * 60 * 60 * 24) - (hour * 60 * 60)) / 60;
    [_minutesSegment flipWithDigits:min];
    
    NSInteger sec = (seconds - (days * 60 * 60 * 24) - (hour * 60 * 60) - min * 60);
    [_secondsSegment flipWithDigits:sec];
}

- (void)flipClock {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:[NSDate date]];
    [_hoursSegment flipWithDigits:comps.hour];
    [_minutesSegment flipWithDigits:comps.minute];
    if (_showSeconds)
        [_secondsSegment flipWithDigits:comps.second];
}

@end
