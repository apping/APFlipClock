//
//  APViewController.m
//  APFlipClockDemo
//
//  Created by Mathias Amnell on 2013-08-15.
//  Copyright (c) 2013 Apping AB. All rights reserved.
//

#import "APViewController.h"

#import "APFlipClock.h"

@interface APViewController ()
- (IBAction)toggleDays:(id)sender;
- (IBAction)toggleHours:(id)sender;
- (IBAction)toggleMinutes:(id)sender;
- (IBAction)toggleSeconds:(id)sender;
- (IBAction)countdownButtonAction:(id)sender;
- (IBAction)clockButtonAction:(id)sender;

@property (nonatomic, strong) IBOutlet APFlipClock *flipClock;

@end

@implementation APViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

//    _flipClock = [[APFlipClock alloc] initWithCountdownToTime:[NSDate dateWithTimeIntervalSinceNow:60*2] showsSeconds:YES showsLabels:NO];
    
//    [self.view addSubview:_flipClock];
}

- (void)viewDidLayoutSubviews
{
//    _flipClock.center = self.view.center;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleDays:(id)sender {
    [_flipClock setShowDays:!_flipClock.showDays];
}

- (IBAction)toggleHours:(id)sender {
    [_flipClock setShowHours:!_flipClock.showHours];
}

- (IBAction)toggleMinutes:(id)sender {
    [_flipClock setShowMinutes:!_flipClock.showMinutes];
}

- (IBAction)toggleSeconds:(id)sender {
    [_flipClock setShowSeconds:!_flipClock.showSeconds];
}

- (IBAction)countdownButtonAction:(id)sender {
    [_flipClock setClockType:APFlipClockTypeCountdown];
    [_flipClock setCountdownDate:[NSDate dateWithTimeIntervalSinceNow:60*60*25]];
    [_flipClock setShowDays:YES];
}

- (IBAction)clockButtonAction:(id)sender {
    [_flipClock setClockType:APFlipClockTypeClock];
    [_flipClock setShowDays:NO];
}

@end
