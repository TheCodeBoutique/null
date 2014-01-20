//
//  TRMCustomSliderView.m
//  Trumaker
//
//  Created on 8/14/13.
//  Copyright (c) 2013 The Code Boutique. All rights reserved.
//

#define kMinimumPanDistance 5.0f
#define kRefreshTimeInSeconds 1

#import "TRMCustomSliderView.h"
@interface TRMCustomSliderView ()
{
    CGFloat counter;
    CGFloat mainMeasurement;
    
    UIPanGestureRecognizer *recognizer;
    CGPoint lastRecognizedInterval;
}
@end

@implementation TRMCustomSliderView

- (id)initWithFrame:(CGRect)frame withDefaultMeasurement:(CGFloat)measurement
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognized:)];
        [self addGestureRecognizer:pan];
        mainMeasurement = measurement;
        
    }
    return self;
}

- (void)panRecognized:(UIPanGestureRecognizer *)rec
{
    CGPoint thisInterval = [rec translationInView:self];
    CGPoint vel = [rec velocityInView:self];
    CGFloat minVal = 0.0f;
    CGFloat maxVal = 80.0f;
    if ([rec state] == UIGestureRecognizerStateBegan )
    {
        [self presentOverlayViewWithValue];
    }
    
    if ([rec state] == UIGestureRecognizerStateEnded) {
        [self hideOverlayView];
    }
    
    if (abs(lastRecognizedInterval.x - thisInterval.x) > kMinimumPanDistance ||
        abs(lastRecognizedInterval.y - thisInterval.y) > kMinimumPanDistance)
    {
        lastRecognizedInterval = thisInterval;
    if (vel.x > 0) {
        if (mainMeasurement <= maxVal) {
            mainMeasurement += _incrementValue;
        }
    } else {
        if (mainMeasurement >= minVal) {
            mainMeasurement -= _incrementValue;
        }
        }
    }
    [self valueDidChange:mainMeasurement];
}


-(void)presentOverlayViewWithValue
{
    
    [[self sliderDelegate] presentOverlayViewWithValue];
}

-(void)hideOverlayView
{
    [[self sliderDelegate] hideOverlayView];
}

-(void)valueDidChange:(CGFloat)value
{
    [[self sliderDelegate] valueDidChange:value];    
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:self];
    
    // Check for horizontal gesture
    if (fabsf(translation.x) > fabsf(translation.y))
    {
        return YES;
    }
    
    return NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
