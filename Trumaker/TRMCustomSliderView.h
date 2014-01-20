//
//  TRMCustomSliderView.h
//  Trumaker
//
//  Created on 8/14/13.
//  Copyright (c) 2013 The Code Boutique. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TRMCustomSliderViewDelegate <NSObject>
-(void)valueDidChange:(CGFloat)value;
-(void)presentOverlayViewWithValue;
-(void)hideOverlayView;
@end

@interface TRMCustomSliderView : UIView <UIGestureRecognizerDelegate>
@property (nonatomic, weak) id <TRMCustomSliderViewDelegate> sliderDelegate;
@property (nonatomic, assign) CGFloat incrementValue;

- (id)initWithFrame:(CGRect)frame withDefaultMeasurement:(CGFloat)measurement;
@end
