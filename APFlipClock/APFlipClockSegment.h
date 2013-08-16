//
//  APFlipClockSegment.h
//  APFlipClockDemo
//
//  Created by Mathias Amnell on 2013-08-15.
//  Copyright (c) 2013 Apping AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APFlipClockSegment : UIView

@property (nonatomic, strong) UIFont *segmentFont;
@property (nonatomic, strong) UIColor *segmentTextColor;
@property (nonatomic, strong) UIColor *segmentBackgroundColor;
@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic) NSInteger digits;

- (id)initWithDigits:(NSInteger)digits;
- (void)flipWithDigits:(NSInteger)digits;
- (void)flipWithDigits:(NSInteger)digits animated:(BOOL)animate;

@end
