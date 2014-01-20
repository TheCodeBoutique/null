//
//  TRMMeasurementView.m
//  Trumaker
//
//  Created by  7/19/13.
//  Copyright (c) 2013 The Code Boutique. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "TRMMeasurementView.h"
#import "TRMCustomSliderView.h"
#import "TRMAppDelegate.h"
#import "TRMUtils.h"
#import "TRMDrawerView.h"

@interface TRMMeasurementView () <UIScrollViewDelegate>
{

    UILabel *overlayText;
    CAShapeLayer *_border;
    ConfigurationMode currentConfiguration;
}
@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic, strong) UILabel *overlayText;
@property (nonatomic, strong) UILabel *overlaySubText;
@property (nonatomic, strong) UILabel *overlayDescription;
@property (nonatomic, strong) UIScrollView *imageScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UITextView *tipTextView;
@property (nonatomic, strong) TRMDrawerView *slideDrawer;
@property (nonatomic, strong) UIView *instructionsView;
@end

@implementation TRMMeasurementView
@synthesize overlayView;
@synthesize imageScrollView;
@synthesize minimalAlertWarning;
@synthesize maxAlertWarning;
@synthesize minimalWarning;
@synthesize maxWarning;
@synthesize overlayText;
@synthesize overlayDescription;
@synthesize overlaySubText;
@synthesize currentMeasurementLabel;
@synthesize slideDrawer;
@synthesize instructionsView;
- (id)initWithFrame:(CGRect)frame withMode:(ConfigurationMode)configuration
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        currentConfiguration = configuration;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setupSliderWithIncrement:_incrementVal];
    [self addSubview:[self warningMessageView]];
    
    //gesture image view
    [self instructionsView];
    
    [self currentMeasurementLabel];
    
    [self overlayView];
    [self setupWarningView];
    
    [self slideDrawer];
}

-(TRMDrawerView *) slideDrawer {
    if (!slideDrawer) {
        slideDrawer = [[TRMDrawerView alloc] initWithMeasurementType:currentConfiguration];
        [self addSubview:slideDrawer];
        return slideDrawer;
    }
    return slideDrawer;
}

-(void)layoutScrollView
{
    CGRect frame = [self guidesImageView].frame;
    //main scroll view for images
    [[self imageScrollView] setContentSize:CGSizeMake(frame.size.width * 1, frame.size.height)];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = sender.frame.size.width;
    int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [[self pageControl] setCurrentPage:page];
}

-(UIPageControl *)pageControl {
    if (!_pageControl) {
        CGRect frame = [[self imageScrollView] frame];
        frame.origin.y = CGRectGetHeight(frame) - 20.0f;
        frame.size.height = 20.0f;
        _pageControl = [[UIPageControl alloc] initWithFrame:frame];
        [_pageControl setNumberOfPages:4];
        [_pageControl setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.3f]];
        return _pageControl;
    }
    return _pageControl;
}
-(UIView *)overlayView
{
    if (!overlayView) {
        CGRect frame = [self  bounds];
        overlayView = [[UIView alloc] initWithFrame:[[[UIApplication sharedApplication] keyWindow] frame]];
        [overlayView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
        [[overlayView layer] setOpacity:0.0f];
        
        //Number
        overlayText = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMidY(frame) - 80, frame.size.width, 100)];
        [overlayText setTextAlignment:NSTextAlignmentCenter];
        [overlayText setTextColor:[UIColor whiteColor]];
        [overlayText setBackgroundColor:[UIColor clearColor]];
        [overlayText setFont:[UIFont fontWithName:@"HelveticaNeue" size:90]];
        [overlayText setText:[NSString stringWithFormat:@"%f",[self midNumberForMeasurement]]];
        [overlayText sizeToFit];
        
        CGRect textFrame = [overlayText frame];
        [overlayText setFrame:CGRectMake(textFrame.origin.x, textFrame.origin.y, frame.size.width, CGRectGetHeight(textFrame))];        
        
        overlaySubText = [[UILabel alloc] initWithFrame:textFrame];
        [overlaySubText setTextAlignment:NSTextAlignmentCenter];
        [overlaySubText setTextColor:[UIColor whiteColor]];
        [overlaySubText setBackgroundColor:[UIColor clearColor]];
        [overlaySubText setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:35]];
        [overlaySubText setText:NSLocalizedString(@"within range", @"within range")];
        [overlaySubText sizeToFit];
        
        [overlaySubText setFrame:CGRectMake(0, CGRectGetMaxY(textFrame), CGRectGetWidth(overlayText.frame), CGRectGetHeight(overlaySubText.frame))];
        textFrame = [overlaySubText frame];
        
        overlayDescription = [[UILabel alloc] initWithFrame:textFrame];
        [overlayDescription setNumberOfLines:2];
        [overlayDescription setTextAlignment:NSTextAlignmentCenter];
        [overlayDescription setTextColor:[UIColor whiteColor]];
        [overlayDescription setBackgroundColor:[UIColor clearColor]];
        [overlayDescription setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f]];
        [overlayDescription setText:NSLocalizedString(@"measurement is out of range and appears to be wrong", @"measurement is out of range and appears to be wrong")];
        [overlayDescription sizeToFit];
        
        [overlayDescription setFrame:CGRectMake(30, CGRectGetMaxY(textFrame), CGRectGetWidth(overlayText.frame) - 60, CGRectGetHeight(overlayDescription.frame))];
        [overlayDescription setHidden:YES];
        
        
        [overlayView addSubview:overlayText];
        [overlayView addSubview:overlaySubText];
        [overlayView addSubview:overlayDescription];
        return overlayView;
    }
    return overlayView;
}

-(UIView *)instructionsView
{
    if (!instructionsView)
    {
        instructionsView = [[UIView alloc] initWithFrame:CGRectMake(20, 275, 280, 130)];
        [instructionsView setUserInteractionEnabled:NO];
        
        UIImageView *gestureImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slide_gesture"]];
        CGRect imageFrame = [gestureImageView frame];
        imageFrame.origin.x = 100.0f; // we should not hard code
        [gestureImageView setFrame:imageFrame];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, 280, 80)];
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setNumberOfLines:0];
        [title setText:NSLocalizedString(@"Slide your finger left or right to enter measurement", @"Slide your finger left or right to enter measurement")];
        [title setFont:[UIFont systemFontOfSize:20.0f]];
        [title setTextColor:[UIColor blackColor]];
        [title setBackgroundColor:[UIColor clearColor]];
        [instructionsView addSubview:title];
        [instructionsView addSubview:gestureImageView];
        
        [self addSubview:instructionsView];
        return instructionsView;
    }
    return instructionsView;
}

-(UILabel *)currentMeasurementLabel
{
    if (!currentMeasurementLabel) {
        currentMeasurementLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 250, 320, 141)];
        [currentMeasurementLabel setFont:[UIFont boldSystemFontOfSize:90.0f]];
        [currentMeasurementLabel setTextAlignment:NSTextAlignmentCenter];
        [currentMeasurementLabel setTextColor:[TRMUtils colorWithHexString:@"3D503E"]];
        [currentMeasurementLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:currentMeasurementLabel];
        return currentMeasurementLabel;
    }
    return currentMeasurementLabel;
}

-(UIScrollView *)imageScrollView
{
    if (!imageScrollView)
    {
        imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 220)];
        [imageScrollView setPagingEnabled:YES];
        [imageScrollView setDelegate:self];
        [self addSubview:imageScrollView];
        return imageScrollView;
    }
    return imageScrollView;
}

-(UIView *)warningMessageView
{
    if (!_warningMessageView) {
        _warningMessageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 62)];
        [_warningMessageView setBackgroundColor:[TRMUtils colorWithHexString:@"FAFBB3"]];
        UILabel *warningLabel = [[UILabel alloc] initWithFrame:CGRectMake(73, 10, 232, 42)];
        [warningLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0f]];
        [warningLabel setNumberOfLines:2];
        [warningLabel setBackgroundColor:[UIColor clearColor]];
        [warningLabel setText:@"Measurement is not within the preferred size range"];
        [_warningMessageView addSubview:warningLabel];
        
        UIImageView *warningImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 42)];
        [warningImage setImage:[UIImage imageNamed:@"warning_sign.png"]];
        [warningImage setContentMode:UIViewContentModeScaleAspectFit];
        [_warningMessageView addSubview:warningImage];
        return _warningMessageView;        
    }
    return _warningMessageView;
}

-(void)setupWarningView {
    [[self warningMessageView] setFrame:CGRectMake(0, -62, [[self warningMessageView] frame].size.width, [[self warningMessageView] frame].size.height)];
}

-(void)showWarningView {
    [UIView animateWithDuration:0.5 animations:^{
        [[self warningMessageView] setFrame:CGRectMake(0, 0, [[self warningMessageView] frame].size.width, [[self warningMessageView] frame].size.height)];
    }];
}

-(void)hideWarningView {
    [UIView animateWithDuration:0.5 animations:^{
        [[self warningMessageView] setFrame:CGRectMake(0, -62, [[self warningMessageView] frame].size.width, [[self warningMessageView] frame].size.height)];
    }];
}

-(void)setupSliderWithIncrement:(CGFloat)increment
{
    CGRect screen = [self bounds];    
    
    TRMCustomSliderView *slide = [[TRMCustomSliderView alloc] initWithFrame:CGRectMake(0,  screen.size.height/2, screen.size.width, screen.size.height/2) withDefaultMeasurement:[self midNumberForMeasurement]];
    [slide setSliderDelegate:self];
    [slide setBackgroundColor:[UIColor clearColor]];
    [slide setIncrementValue:increment];
    [self addSubview:slide];
    [self bringSubviewToFront:slide];
}

-(CGFloat)midNumberForMeasurement
{
    if (![self midValue]) {
        return 0;
    }
    else
    {
        return [self midValue];
    }
}

#pragma mark Overlay actions
-(void)presentOverlayViewWithValue
{
    if (instructionsView)
    {
        [instructionsView removeFromSuperview];
    }
    [[self currentMeasurementLabel] setHidden:YES];
     [[self delgate] presentOverlayView:[self overlayView]];
}

-(void)hideOverlayView
{
    
    [[self currentMeasurementLabel] setHidden:NO];
    [[self currentMeasurementLabel] setText:[overlayText text]];
    
    if ([[overlayText textColor] isEqual:[UIColor redColor]]) {
        [[self currentMeasurementLabel] setTextColor:[overlayText textColor]];
    } else
    {
        [[self currentMeasurementLabel] setTextColor:[TRMUtils colorWithHexString:@"3D503E"]];
    }
    
    [[self delgate] hideOverlayView:[self overlayView] :self];

}

-(void)removeCustomOverlayView
{
    if (overlayView)
    {
        [overlayView removeFromSuperview];
        overlayView = nil;
    }
}


#pragma mark slider actions
-(void)valueDidChange:(CGFloat)value
{
    if (value < minimalAlertWarning || value > maxAlertWarning)
    {
        [overlayText setTextColor:[UIColor redColor]];
        [overlaySubText setTextColor:[UIColor redColor]];
        [overlaySubText setText:NSLocalizedString(@"alert", @"alert")];
        [overlayDescription setHidden:NO];
        [overlayDescription setText:NSLocalizedString(@"measurement is out of range and appears to be wrong", @"measurement is out of range and appears to be wrong")];
    }
    else
    {
        [overlayText setTextColor:[UIColor whiteColor]];
        [overlaySubText setTextColor:[UIColor whiteColor]];
        [overlaySubText setText:NSLocalizedString(@"within range", @"within range")];
        [overlayDescription setHidden:YES];
        [overlayDescription setText:NSLocalizedString(@"measurement within range but seems abnormal", @"measurement within range but seems abnormal")];
    }

    [overlayText setText:[self formattedNumber:value]];
    
    BOOL isRed = ([[overlayText textColor] isEqual:[UIColor redColor]]) ? YES : NO;
    NSLog(@"isRed %d",isRed);
    NSLog(@"isRed %@",[overlayText textColor]);
    [[self delgate] valueForConfiguration:currentConfiguration value:value withWarning:isRed];
}

#pragma mark Helpers
-(NSString *)formattedNumber:(float)value {
    return [NSString stringWithFormat:@"%.2f",value];
}
@end
