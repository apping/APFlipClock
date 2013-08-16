//
//  APFlipClockSegment.m
//  APFlipClockDemo
//
//  Created by Mathias Amnell on 2013-08-15.
//  Copyright (c) 2013 Apping AB. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "APFlipClockSegment.h"

@interface APFlipClockSegment ()
- (void)setupDefaults;

- (UIImageView *)segmentWithNumber:(NSInteger)number;

@end

@implementation APFlipClockSegment {
    UIView *_segment;
    UIView *_divider;
    UIImageView *_shine;
}

- (void)setupDefaults {
    _segmentFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:self.frame.size.height - 12];
    _segmentBackgroundColor = [UIColor colorWithRed:39/255.0f green:49/255.0f blue:61/255.0f alpha:1];
    _segmentTextColor = [UIColor colorWithRed:236/255.0f green:238/255.0f blue:241/255.0f alpha:1];
    _cornerRadius = 3;
}

- (id)initWithDigits:(NSInteger)digits {
    self = [super initWithFrame:CGRectMake(0, 0, 74, 68)];
    if (self) {
        [self setupDefaults];
        
        _digits = digits;
        _segment = [self segmentWithNumber:_digits];
        [self addSubview:_segment];
        
        _divider = [[UIView alloc] init];
        [_divider setFrame:CGRectMake(0, self.frame.size.height / 2, self.frame.size.width, 1)];
        [_divider setBackgroundColor:[UIColor clearColor]];
        _divider.layer.zPosition = 2000;
        [self addSubview:_divider];
    }
    return self;
}

- (UIImage *)imageRepresentationOfTopHalf {
    CGContextRef ctx;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(_segment.frame.size.width, _segment.frame.size.height / 2), NO, [UIScreen mainScreen].scale);
    ctx = UIGraphicsGetCurrentContext();
    [_segment.layer renderInContext:ctx];
    UIImage *oldSegmentTop = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return oldSegmentTop;
}

- (UIImage *)imageRepresentationOfBottomHalf {
    CGContextRef ctx;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(_segment.frame.size.width, _segment.frame.size.height / 2), NO, [UIScreen mainScreen].scale);
    ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0, -_segment.frame.size.height / 2);
    [_segment.layer renderInContext:ctx];
    UIImage *oldSegmentBottom = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return oldSegmentBottom;
}

- (void)setDigits:(NSInteger)digits
{
    if (_digits != digits) {
        _digits = digits;
        [self flipWithDigits:digits animated:NO];
    }
}

- (void)flipWithDigits:(NSInteger)digits {
    [self flipWithDigits:digits animated:YES];
}

- (void)flipWithDigits:(NSInteger)digits animated:(BOOL)animate {
    if (_digits == digits) {
        return;
    }
    
    _digits = digits;
    CGContextRef ctx;
    
    UIImage *oldSegmentTop = [self imageRepresentationOfTopHalf];
    UIImage *oldSegmentBottom = [self imageRepresentationOfBottomHalf];
    
    [_segment removeFromSuperview];
    
    // Old top
    UIImageView *oldTop = [[UIImageView alloc] initWithImage:oldSegmentTop];
    [oldTop setFrame:CGRectMake(0, 0, oldTop.frame.size.width, oldTop.frame.size.height)];
    oldTop.layer.doubleSided = NO;
    oldTop.layer.anchorPoint = CGPointMake(.5, 1.);
    oldTop.layer.position = CGPointMake(oldTop.frame.size.width / 2, oldTop.frame.size.height);
    
    CATransform3D oldTop3DTransform = CATransform3DIdentity;
    oldTop3DTransform.m34 = 1.0 / -1000.;
    oldTop.layer.transform = oldTop3DTransform;
    
    // Old bottom
    UIImageView *oldBottom = [[UIImageView alloc] initWithImage:oldSegmentBottom];
    [oldBottom setFrame:CGRectMake(0, oldTop.frame.size.height, oldBottom.frame.size.width, oldBottom.frame.size.height)];
    oldBottom.layer.zPosition = -1000;
    
    UIImageView *newSegment = [self segmentWithNumber:_digits];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(newSegment.frame.size.width, newSegment.frame.size.height / 2), NO, [UIScreen mainScreen].scale);
    ctx = UIGraphicsGetCurrentContext();
    [newSegment.layer renderInContext:ctx];
    UIImage *newSegmentTop = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(newSegment.frame.size.width, newSegment.frame.size.height / 2), NO, [UIScreen mainScreen].scale);
    ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0, -newSegment.frame.size.height / 2);
    [newSegment.layer renderInContext:ctx];
    UIImage *newSegmentBottom = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *newTop = [[UIImageView alloc] initWithImage:newSegmentTop];
    [newTop setFrame:CGRectMake(0, 0, newTop.frame.size.width, newTop.frame.size.height)];
    newTop.layer.zPosition = -1000;
    
    UIImageView *newBottom = [[UIImageView alloc] initWithImage:newSegmentBottom];
    [newBottom setFrame:CGRectMake(0, newTop.frame.size.height, newBottom.frame.size.width, newBottom.frame.size.height)];
    newBottom.layer.doubleSided = NO;
    newBottom.layer.anchorPoint = CGPointMake(.5, 0);
    newBottom.layer.position = CGPointMake(newTop.frame.size.width / 2, newTop.frame.size.height);
    
    CATransform3D newBottom3DTransform = CATransform3DMakeRotation(M_PI, -1, 0, 0);
    newBottom3DTransform.m34 = 1.0 / -1000.;
    newBottom.layer.transform = newBottom3DTransform;
    
    [self insertSubview:oldBottom belowSubview:_divider];
    [self insertSubview:newTop belowSubview:_divider];
    [self insertSubview:oldTop belowSubview:_divider];
    [self insertSubview:newBottom belowSubview:_divider];
    
    if (animate) {
        [UIView animateWithDuration:0.45 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            oldTop.layer.transform = CATransform3DRotate(oldTop.layer.transform, M_PI, -1, 0, 0);
            newBottom.layer.transform = CATransform3DRotate(newBottom.layer.transform, M_PI, -1, 0, 0);
        } completion:^(BOOL finished) {
            [oldBottom removeFromSuperview];
            [newTop removeFromSuperview];
            [oldTop removeFromSuperview];
            [newBottom removeFromSuperview];
            [_segment removeFromSuperview];
            _segment = newSegment;
            [self addSubview:_segment];
        }];
    } else {
        oldTop.layer.transform = CATransform3DRotate(oldTop.layer.transform, M_PI, -1, 0, 0);
        newBottom.layer.transform = CATransform3DRotate(newBottom.layer.transform, M_PI, -1, 0, 0);
        
        [oldBottom removeFromSuperview];
        [newTop removeFromSuperview];
        [oldTop removeFromSuperview];
        [newBottom removeFromSuperview];
        [_segment removeFromSuperview];
        _segment = newSegment;
        [self addSubview:_segment];
    }
}

- (UIView *)segmentWithNumber:(NSInteger)number {
    UIView *newSegment = [[UIView alloc] initWithFrame:self.bounds];
    [newSegment setBackgroundColor:[UIColor grayColor]];
    [newSegment.layer setCornerRadius:_cornerRadius];
    
    [newSegment setBackgroundColor:_segmentBackgroundColor];
    
    UILabel *l = [[UILabel alloc] initWithFrame:self.bounds];
    [l.layer setCornerRadius:_cornerRadius];
    [l setBackgroundColor:[UIColor clearColor]];
    [l setTextAlignment:NSTextAlignmentCenter];
    [l setText:[NSString stringWithFormat:@"%02i",number]];

    [l setFont:_segmentFont];
    [l setTextColor:_segmentTextColor];
    
    UIColor *highColor = [UIColor colorWithWhite:0. alpha:.2];
    UIColor *lowColor = [UIColor colorWithWhite:0. alpha:.0];

    CAGradientLayer * gradient = [CAGradientLayer layer];
    [gradient setFrame:CGRectMake(0, 0, CGRectGetWidth(l.frame), CGRectGetHeight(l.frame)/2)];
    [gradient setColors:@[(id)lowColor.CGColor, (id)highColor.CGColor]];
    [gradient setLocations:@[@0, @0.50]];
    [l.layer addSublayer:gradient];
    
    [newSegment addSubview:l];
    newSegment.layer.doubleSided = NO;
    return newSegment;
}

@end
