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
    
    [self dashedView];
    
    [self currentMeasurementLabel];
    [self measurementTitle];    
    [self layoutScrollView];
    
    [self overlayView];
    [self setupWarningView];
}

-(void)layoutScrollView
{
    CGRect frame = [self guidesImageView].frame;
    BOOL showAnimatedGifs = [[NSUserDefaults standardUserDefaults] boolForKey:@"show_gifs"];

    for (int i = 0; i < 1; i++)
    {        
        UIImageView *imageView = [self guidesImageView];
        [imageView setFrame:CGRectMake(i * frame.size.width,
                                                    0,
                                                    frame.size.width,
                                                    frame.size.height)];
        //if setting is on show gifs
        if (showAnimatedGifs) {
            [self renderAnimatedGifsForImageView:imageView];
            [[self imageScrollView] addSubview:imageView];
        } else {
            [self showStaticViews];
        }
    }
    [[self imageScrollView] setContentSize:CGSizeMake(frame.size.width * 1, frame.size.height)];
}

-(void)showStaticViews {
    //create scrollview
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[self imageScrollView] frame]];
    [scrollView setDelegate:self];
    [scrollView setPagingEnabled:YES];
    
    //create fist view
    UITextView *textView = [self tipsForMeasurement:[self helpfulTipText]];
    [scrollView addSubview:textView];
    
    [self buildImageForScrollView:scrollView];
    [[self imageScrollView] addSubview:scrollView];
    
    CGRect scrollViewFrame = [scrollView frame];
    [scrollView setContentSize:CGSizeMake(CGRectGetWidth(scrollViewFrame) * 4, CGRectGetHeight(scrollViewFrame))];
    
    //add page control
    [[self imageScrollView] addSubview:[self pageControl]];
    [[self imageScrollView] bringSubviewToFront:[self pageControl]];
}

-(void)buildImageForScrollView:(UIScrollView *)scrollView {
    //we need to start at one cause we already have text view as the first view
//    for (int i = 1; i < 2; i++) {
        CGRect imageScrollViewFrame = [[self imageScrollView] frame];
        CGFloat width  = CGRectGetWidth(imageScrollViewFrame);
        CGFloat hieght = CGRectGetHeight(imageScrollViewFrame);
        
        CGRect frame = CGRectMake(1 * width, 0, width, hieght);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        [imageView setImage:[self imageAtIndex]];
        [scrollView addSubview:imageView];
//    }
}

-(UIImage *)imageAtIndex {
    NSDictionary *textDict = [self measurementDictionary];
    NSString *imageTitle = [NSString stringWithFormat:@"image_%d",currentConfiguration];
    return [UIImage imageNamed:[textDict valueForKey:imageTitle]];
}

-(NSString *)helpfulTipText {
    NSString *tipText;
    NSDictionary *textDict = [self measurementDictionary];
    NSLog(@"currentConfiguration %d",currentConfiguration);
    
    switch (currentConfiguration) {
        case kNeckConfiguration:
            tipText = [textDict valueForKey:@"neck"];
            break;
        case kChestConfiguration:
            tipText = [textDict valueForKey:@"chest"];
            break;
        case kWaistConfiguration:
            tipText = [textDict valueForKey:@"waist"];
            break;
        case kSeatConfiguration:
            tipText = [textDict valueForKey:@"seat"];
            break;
        case kShoulderConfiguration:
            tipText = [textDict valueForKey:@"shoulders"];
            break;
        case kRightArmConfiguration:
            tipText = [textDict valueForKey:@"right_Sleeve"];
            break;
        case kLeftArmConfiguration:
            tipText = [textDict valueForKey:@"left_Sleeve"];
            break;
        case kRightWristConfiguration:
            tipText = [textDict valueForKey:@"right_wrist"];
            break;
        case kLeftWristConfiguration:
            tipText = [textDict valueForKey:@"left_wrist"];
            break;
        case kShirtLengthConfiguration:
            tipText = [textDict valueForKey:@"length"];
            break;
        case kBicepConfiguration:
            tipText = [textDict valueForKey:@"bicep"];
            break;
    }
    return tipText;
}

-(NSDictionary *)measurementDictionary {

    NSDictionary *measurementKeysDictionary = [[NSDictionary alloc]
                                               initWithObjectsAndKeys:
                                               @"\n 1) Measure below the Adam’s apple. \n\n 2) Measure where collar usually rests. \n\n 3) One finger between neck and tape.",@"neck",
                                               @"neck.png",@"image_0",
                                               @"\n 1) Measure over biggest part of chest. \n\n 2) Make sure tape is parallel to ground. \n\n 3) Ask him to take two normal breaths.",@"chest",
                                               @"chest.png",@"image_1",
                                               @"\n 1) Measure around the belly button. \n\n 2) Make sure tape is parallel to ground. \n\n 3) Ask him to take two normal breaths.",@"waist",
                                               @"waist.png",@"image_2",
                                               @"\n 1) Ask to remove all from pants pockets. \n\n 2) Measure largest part of the seat. \n\n 3) Make sure tape is parallel to ground.",@"seat",
                                               @"seat.png",@"image_3",
                                               @"\n 1) Ask customer to stand naturally. \n\n 2) Feel to find shoulder bones. \n\n 3) Follow contour of the shoulder.",@"shoulders",
                                               @"shoulders.png",@"image_4",
                                               @"\n 1) Start at the top vertebrae. \n\n 2) Peg at the shoulder bone. \n\n 3) Measure to the “V” in his hand.",@"left_Sleeve",
                                               @"sleeve.png",@"image_5",
                                               @"\n 1) Start at the top vertebrae. \n\n 2) Peg at the shoulder bone. \n\n 3) Measure to the “V” in his hand.",@"right_Sleeve",
                                               @"sleeve.png",@"image_6",
                                               @"\n 1) Start where neck meets shoulder. \n\n 2) Have customer hold tape at chest. \n\n 3) Step back, get measurement at eye level.",@"length",
                                               @"length.png",@"image_7",
                                               @"\n 1) Measure biggest part of wrist. \n\n 2) Don’t measure too tight. \n\n 3) Make sure to ask about a watch.",@"left_wrist",
                                               @"wrist.png",@"image_8",
                                               @"\n 1) Measure biggest part of wrist. \n\n 2) Don’t measure too tight. \n\n 3) Make sure to ask about a watch.",@"right_wrist",
                                               @"wrist.png",@"image_9",
                                               @"\n 1) Have customer raise arm slightly. \n\n 2) Work tape gently into armpit. \n\n 3) Make sure customer doesn’t flex.",@"bicep",
                                               @"bicep.png",@"image_10",
                                               nil];
    return measurementKeysDictionary;
}

-(UITextView *)tipsForMeasurement:(NSString *)tipsText {
    UITextView *tv = [self tipTextView];
    [tv setText:tipsText];
    return tv;
}


-(void)renderAnimatedGifsForImageView:(UIImageView *)imageView
{
    NSString *animatedImage;
    NSLog(@"currentConfiguration %d",currentConfiguration);
    switch (currentConfiguration) {
        case kNeckConfiguration:
            animatedImage = @"neck_animated";
            break;
        case kChestConfiguration:
            animatedImage = @"chest_animated";
            break;
        case kWaistConfiguration:
            animatedImage = @"waist_animated";
            break;
        case kSeatConfiguration:
            animatedImage = @"seat_animated";
            break;
        case kShoulderConfiguration:
            animatedImage = @"shoulders_animated";
            break;
        case kRightArmConfiguration:
            animatedImage = @"sleeve_animated";
            break;
        case kLeftArmConfiguration:
            animatedImage = @"sleeve_animated";
            break;
        case kRightWristConfiguration:
            animatedImage = @"wrist_animated";
            break;
        case kLeftWristConfiguration:
            animatedImage = @"wrist_animated";
            break;
        case kShirtLengthConfiguration:
            animatedImage = @"length_animated";
            break;
        case kBicepConfiguration:
            animatedImage = @"bicep_animated";
            break;
    }
    
//    NSURL *url = [[NSBundle mainBundle] URLForResource:animatedImage withExtension:@"gif"];
////    imageView.image = [UIImage animatedImageWithAnimatedGIFURL:url];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = sender.frame.size.width;
    int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [[self pageControl] setCurrentPage:page];
}


#pragma mark Views
-(UITextView *)tipTextView {
    if (!_tipTextView) {
        _tipTextView = [[UITextView alloc] initWithFrame:[[self imageScrollView] frame]];
        [_tipTextView setEditable:NO];
        [_tipTextView setScrollEnabled:NO];
        [_tipTextView setFont:[UIFont systemFontOfSize:18.0f]];
        [_tipTextView setBackgroundColor:[TRMUtils colorWithHexString:@"E2EBE4"]];
        return _tipTextView;
    }
    return _tipTextView;
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

-(UIView *) dashedView
{
    if (!_dashedView)
    {
        _dashedView = [[UIView alloc] initWithFrame:CGRectMake(20, 275, 280, 80)];
        [_dashedView setUserInteractionEnabled:NO];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(40, 25, 200, 60)];
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setNumberOfLines:2];
        [title setText:NSLocalizedString(@"Slide your finger left or right to enter measurement", @"Slide your finger left or right to enter measurement")];
        [title setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:17.0f]];
        [title setTextColor:[UIColor blackColor]];
        [title setBackgroundColor:[UIColor clearColor]];
        [_dashedView addSubview:title];
        [self addSubview:_dashedView];
        return _dashedView;
    }
    return _dashedView;
}

-(UILabel *)currentMeasurementLabel
{
    if (!currentMeasurementLabel) {
        currentMeasurementLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 250, 320, 141)];
        [currentMeasurementLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:90.0f]];
        [currentMeasurementLabel setTextAlignment:NSTextAlignmentCenter];
        [currentMeasurementLabel setTextColor:[TRMUtils colorWithHexString:@"3D503E"]];
        [currentMeasurementLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:currentMeasurementLabel];
        return currentMeasurementLabel;
    }
    return currentMeasurementLabel;
}

-(UILabel *)measurementTitle
{
    if (!_measurementTitle) {
        _measurementTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 219, 320, 30)];
        [_measurementTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f]];
        [_measurementTitle setTextColor:[UIColor whiteColor]];
        [_measurementTitle setBackgroundColor:[TRMUtils colorWithHexString:@"3D503E"]];
        [_measurementTitle setTextAlignment:NSTextAlignmentCenter];
        [_measurementTitle setText:@"Neck"];
        [self addSubview:_measurementTitle];
        return _measurementTitle;
    }
    return _measurementTitle;
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
-(UIImageView *)guidesImageView
{
    _guidesImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 220)];
    [_guidesImageView setContentMode:UIViewContentModeScaleAspectFit];
    return _guidesImageView;
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
    if (_dashedView)
    {
        [_dashedView removeFromSuperview];
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
