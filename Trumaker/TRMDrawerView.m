//
//  TRMDrawerView.m
//  Trumaker
//
//  Created by Kyle Carriedo on 1/19/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMDrawerView.h"

@interface TRMDrawerView()<UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
    ConfigurationMode currentMeasurementType;
    CGFloat yMin;
}
@property(strong, nonatomic) UIScrollView *scrollView;
@property(strong, nonatomic) UIPageControl *pageControl;
@property(strong, nonatomic) UIView *handleView;
@property(strong, nonatomic) UILabel *measurementLabel;
@property(strong, nonatomic) NSString *measuremntString;
@property(strong, nonatomic) UIImageView *drawerHandle;
@property(strong, nonatomic) UITextView *tipTextView;
@end

@implementation TRMDrawerView
@synthesize scrollView;
@synthesize pageControl;
@synthesize handleView;
@synthesize measurementLabel;
@synthesize drawerHandle;
@synthesize tipTextView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithMeasurementType:(ConfigurationMode)measurementType
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 255.0f)];
    if (self) {
        currentMeasurementType = measurementType;
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
    }
    return self;
}
//kShirtLengthConfiguration = 9,
//kBicepConfiguration = 10

-(NSString *)titleForMeasurement:(ConfigurationMode)type {
    switch (type) {
        case kNeckConfiguration:
            return @"Neck";
            break;
        case kChestConfiguration:
            return @"Chest";
            break;
        case kWaistConfiguration:
            return @"Waist";
            break;
        case kSeatConfiguration:
            return @"Seat";
            break;
        case kShoulderConfiguration:
            return @"Shoulder";
            break;
        case kRightArmConfiguration:
            return @"Right Arm";
            break;
        case kLeftArmConfiguration:
            return @"Left Arm";
            break;
        case kRightWristConfiguration:
            return @"Right Wrist";
            break;
        case kLeftWristConfiguration:
            return @"Left Wrist";
            break;
        case kShirtLengthConfiguration:
            return @"Shirt Length";
            break;
        case kBicepConfiguration:
            return @"Bicep";
            break;
    }
}

-(void)layoutSubviews
{
    [self scrollView];
    [self handleView];
    [self drawerHandle];
    [self pageControl];
    [self measurementLabel];
    
    //layout view
    [[self tipTextView] setAttributedText:[self defaultAttributes]];
    [[self scrollView] addSubview:tipTextView];    
}

-(NSMutableAttributedString *)defaultAttributes {
    NSString *measurementKey = [[self titleForMeasurement:currentMeasurementType] lowercaseString];
    NSDictionary *selectionDictionary = [self measurementDictionary];
    NSString *stringToRender = [selectionDictionary valueForKey:measurementKey];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:stringToRender attributes:@{NSParagraphStyleAttributeName: [self defaultParagraph],NSFontAttributeName: [UIFont systemFontOfSize:16.0f]}];
    return attrString;
}

-(NSMutableParagraphStyle *)defaultParagraph {
    NSMutableParagraphStyle *par = [[NSMutableParagraphStyle alloc] init];
    par.headIndent = 20.0f;
    par.firstLineHeadIndent = 20.0f;
    par.lineSpacing = 15.5;
    return par;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint translation = [panGestureRecognizer translationInView:self];
    return fabs(translation.y) > fabs(translation.x);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = sender.frame.size.width;
    int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [[self pageControl] setCurrentPage:page];
}

-(UIPageControl *)pageControl {
    if (!pageControl) {
        CGRect frame = [[self scrollView] frame];
        frame.origin.y = CGRectGetHeight(frame) - 20.0f;
        frame.size.height = 20.0f;
        pageControl = [[UIPageControl alloc] initWithFrame:frame];
        [pageControl setNumberOfPages:2];
        [pageControl setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.3f]];
        [self addSubview:pageControl];
        return pageControl;
    }
    return pageControl;
}

-(UIScrollView *)scrollView
{
    if (!scrollView)
    {
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([self frame]), CGRectGetHeight([self frame]) - 40.0f)];
        [scrollView setPagingEnabled:YES];
        [scrollView setBackgroundColor:[UIColor whiteColor]];
        [scrollView setDelegate:self];
        [self addSubview:scrollView];
        return scrollView;
    }
    return scrollView;
}

-(UITextView *)tipTextView {
    if (!tipTextView) {
        tipTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 55.0f, CGRectGetWidth([self frame]), CGRectGetHeight([self frame]))];
        [tipTextView setEditable:NO];
        [tipTextView setScrollEnabled:NO];
        [tipTextView setFont:[UIFont systemFontOfSize:16.0f]];
        return tipTextView;
    }
    return tipTextView;
}

-(UIView *)handleView
{
    if (!handleView) {
        handleView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY([self frame]) - 40.0f, CGRectGetWidth([self frame]), 40.0f)];
        [handleView setBackgroundColor:[UIColor clearColor]];
        [handleView setUserInteractionEnabled:YES];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didStartPan:)];
        [pan setDelegate:self];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapHandle:)];
        [pan setDelegate:self];

        [handleView addGestureRecognizer:pan];
        [handleView addGestureRecognizer:tap];
        [self addSubview:handleView];
        return handleView;
    }
    return handleView;
}

-(UIImageView *)drawerHandle
{
    if (!drawerHandle) {
        drawerHandle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drawer_handle"]];
        CGRect drawerRect = [drawerHandle frame];
        drawerRect.origin.x = 122.0f;
        drawerRect.size.width = 75.0f;
        drawerRect.size.height = 20.0f;
        [drawerHandle setFrame:drawerRect];
        [handleView addSubview:drawerHandle];
        [handleView sendSubviewToBack:drawerHandle];
        return drawerHandle;
    }
    return drawerHandle;
}


-(UILabel *)measurementLabel
{
    if (!measurementLabel) {
        measurementLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 12.0f, CGRectGetWidth([self frame]), 40.0f)];
        [measurementLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [measurementLabel setTextAlignment:NSTextAlignmentCenter];
        [measurementLabel setText:[self titleForMeasurement:currentMeasurementType]];
        [handleView addSubview:measurementLabel];
        return measurementLabel;
    }
    return measurementLabel;
}

-(void)didTapHandle:(UITapGestureRecognizer *)recognizer {
    CGPoint viewCenter = [self center];
    if (viewCenter.y <= -50.0f) {
        //open it
        viewCenter.y = 139.0f;
    } else {
        //close it
        viewCenter.y = -51.0f;
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self setCenter:viewCenter];
    }];
}

-(void)didStartPan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self];
    [recognizer setTranslation:CGPointMake(0, 0) inView:self];
    
    CGPoint center = self.center;
    center.y += translation.y;
    if (center.y <= -50.0f || center.y > 140.0f)
        return;
    self.center = center;
}

-(NSDictionary *)measurementDictionary {
    
    NSDictionary *measurementKeysDictionary = [[NSDictionary alloc]
                                               initWithObjectsAndKeys:
                                               @"\u2022 Measure below the Adam’s apple.\n\u2022 Measure where collar usually rests. \n\u2022 One finger between neck and tape.",@"neck",
                                               @"neck.png",@"neck_image",
                                               
                                               @"\u2022 Measure over biggest part of chest. \n\u2022 Make sure tape is parallel to ground. \n\u2022 Ask him to take two normal breaths.", @"chest",@"chest.png",@"chest_image",
//                                               
                                               @"\u2022 Measure around the belly button. \n\u2022 Make sure tape is parallel to ground. \n\u2022 Ask him to take two normal breaths.",@"waist",
                                               @"waist.png",@"waist_image",
                                               
                                               @"\u2022 Ask to remove all from pants pockets. \n\u2022 Measure largest part of the seat. \n\u2022 Make sure tape is parallel to ground.",@"seat",
                                               @"seat.png",@"seat_image",
                                               
                                               @"\u2022 Ask customer to stand naturally. \n\u2022 Feel to find shoulder bones. \n\u2022 Follow contour of the shoulder.",@"shoulder",
                                               @"shoulders.png",@"shoulder_image",
                                               
                                               @"\u2022 Start at the top vertebrae. \n\u2022 Peg at the shoulder bone. \n\u2022 Measure to the “V” in his hand.",@"left arm",
                                               @"sleeve.png",@"left_arm_image",
                                               
                                               @"\u2022 Start at the top vertebrae. \n\u2022 Peg at the shoulder bone. \n\u2022 Measure to the “V” in his hand.",@"right arm",
                                               @"sleeve.png",@"right_arm_image",
                                               
                                               @"\u2022 Start where neck meets shoulder. \n\u2022 Have customer hold tape at chest. \n\u2022 Get measurement at eye level.",@"shirt length",
                                               @"length.png",@"shirt_length_image",
                                               
                                               @"\u2022 Measure biggest part of wrist. \n\u2022 Don’t measure too tight. \n\u2022 Make sure to ask about a watch.",@"left wrist",
                                               @"wrist.png",@"left_wrist_image",
                                               
                                               @"\u2022 Measure biggest part of wrist. \n\u2022 Don’t measure too tight. \n\u2022 Make sure to ask about a watch.",@"right wrist",
                                               @"wrist.png",@"right_wrist_image",
                                               
                                               @"\u2022 Have customer raise arm slightly. \n\u2022 Work tape gently into armpit. \n\u2022 Make sure customer doesn’t flex.",@"bicep",
                                               @"bicep.png",@"bicep_image",
                                               nil];
    return measurementKeysDictionary;
}
@end