//
//  TRMMeasurementView.h
//  Trumaker
//
//  Created by  7/19/13.
//  Copyright (c) 2013 The Code Boutique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRMCustomSliderView.h"

typedef enum {
    kNeckConfiguration = 0,
    kChestConfiguration = 1,
    kWaistConfiguration = 2,
    kSeatConfiguration = 3,
    kShoulderConfiguration = 4,
    kRightArmConfiguration = 5,
    kLeftArmConfiguration = 6,
    kRightWristConfiguration = 7,
    kLeftWristConfiguration = 8,
    kShirtLengthConfiguration = 9,
    kBicepConfiguration = 10
    } ConfigurationMode;

@protocol TRMMeasurementViewDelegate;

@interface TRMMeasurementView : UIView <TRMCustomSliderViewDelegate, UIScrollViewDelegate>
@property (strong,nonatomic) UIImageView *guidesImageView;
@property (strong,nonatomic) UILabel *measurementTitle;
@property (strong,nonatomic) UILabel *currentMeasurementLabel;

@property (strong,nonatomic) UIView  *warningMessageView;
@property (strong,nonatomic) UIView  *dashedView;
@property (nonatomic, weak) id <TRMMeasurementViewDelegate> delgate;

@property (nonatomic, assign) CGFloat midValue;
@property (nonatomic, assign) CGFloat incrementVal;

//yellow
@property (nonatomic, assign) CGFloat minimalWarning;
@property (nonatomic, assign) CGFloat maxWarning;

//red
@property (nonatomic, assign) CGFloat minimalAlertWarning;
@property (nonatomic, assign) CGFloat maxAlertWarning;


- (id)initWithFrame:(CGRect)frame withMode:(ConfigurationMode)configuration;
-(void)removeCustomOverlayView;
@end

@protocol TRMMeasurementViewDelegate <NSObject>
-(void)nextButtonTapped:(id)sender;
-(void)previousButtonTapped:(id)sender;
-(void)presentOverlayView:(UIView *)customOverlayView;
-(void)hideOverlayView:(UIView *)customOverlayView :(TRMMeasurementView *)measurementView;
-(void)valueForConfiguration:(int)config value:(float)value withWarning:(BOOL)isRed;
@end

