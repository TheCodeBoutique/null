//
//  TRMeasurementsViewController.m
//  Trumaker
//
//  Created by  7/18/13.
//  Copyright (c) 2013 The Code Boutique. All rights reserved.
//
#import "TRMeasurementsViewController.h"
#import "TRMMeasurementPhotosViewController.h"
#import "TRMAppDelegate.h"
#import "TRMMeasurementView.h"
#import "TRMCoreApi.h"
#import "TRMFormula.h"
#import "NSDictionary+dictionaryWithObject.h"
#import "NSObject+JTObjectMapping.h"

@interface TRMeasurementsViewController ()<TRMFormulaDelegate>
{
    NSMutableArray *measurementsViews;
    NSArray *measurementTitles;
    NSMutableDictionary *rulesDictionary;
    CGRect screen;
    TRMMeasurementView *measurementView;
    
    int currentPage;
}
@property (nonatomic, strong) TRMFormula *formula;
@end

@implementation TRMeasurementsViewController
@synthesize data;
@synthesize formula;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        measurementTitles = [NSArray arrayWithObjects:@"Neck",
                             @"Chest",
                             @"Waist",
                             @"Seat",
                             @"Shoulders",
                             @"Right Arm",
                             @"Left Arm",
                             @"Right Wrist",
                             @"Left Wrist",
                             @"Shirt Length",
                             @"Bicep", nil];
        
        measurementsViews = [[NSMutableArray alloc] initWithCapacity:[measurementTitles count]];
    }
    return self;
}

-(void)lowerBounds:(float)lower upperBounds:(float)upper forType:(int)type withEstimate:(float)estimate withIncrement:(float)increment
{
    //tell the view controller what meaurement were on
    currentPage = type;
    
    NSLog(@"Lower:%f Upper:%f Config:%d Estimate: %f Increment: %f",lower,upper,type,roundf(estimate), increment);
    
    [self buildMeasurementsViewWithConfiguration:type withMin:lower withMax:upper withMidVale:roundf(estimate) withIncrement:increment];
}

-(void)viewWillAppear:(BOOL)animated
{
    formula = [[TRMFormula alloc] init];
    [formula setDelegate:self];
    [formula neckFormula:data];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    screen = [[UIScreen mainScreen] applicationFrame];    
    [[self scrollView] setScrollEnabled:NO];
    
    //creat scrollview content size
    CGRect frontScreen = [[UIScreen mainScreen] bounds];
    [[self scrollView] setContentSize:CGSizeMake(screen.size.width * [measurementTitles count], CGRectGetHeight(frontScreen))];
}

-(void)buildMeasurementsViewWithConfiguration:(int)configuration withMin:(float)minValue withMax:(float)maxValue withMidVale:(float)midValue withIncrement:(float)increment
{
    measurementView = [[TRMMeasurementView alloc] initWithFrame:CGRectMake(configuration * screen.size.width, 0, [_scrollView frame].size.width, 454) withMode:configuration];
    
        //handles the next title
//    [[self measurementTitle] setText:[measurementTitles objectAtIndex:configuration]];
    
    [measurementView setMinimalAlertWarning:minValue];
    [measurementView setMaxAlertWarning:maxValue];
    [measurementView setMidValue:midValue];
    [measurementView setIncrementVal:increment];
    [measurementView setDelgate:self];
    
    //add to scrollView
    [[self scrollView] addSubview:measurementView];
    
    //only start scrolling view we are not at the first page
    if (currentPage != 0) {
        [self scrollToView];
    }
}

-(void)scrollToView
{
    CGRect scrollViewRect = [[self scrollView] frame];
    [[self scrollView] scrollRectToVisible:
                CGRectMake(currentPage * CGRectGetWidth(scrollViewRect), 0,
                CGRectGetWidth(scrollViewRect),
                CGRectGetHeight(scrollViewRect))
                                  animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;

}

#pragma mark Actions

-(void)remasureAtSection:(NSInteger)section
{
    [[self scrollView] scrollRectToVisible:CGRectMake(CGRectGetWidth([self scrollView].frame) * section + 1, [self scrollView].frame.origin.y, CGRectGetWidth([self scrollView].frame), CGRectGetHeight([self scrollView].frame)) animated:YES];
}

#pragma mark TRMMeasurementViewDelegate
-(void)presentOverlayView:(UIView *)overlayView
{
    [[self view] addSubview:overlayView];
    [UIView animateWithDuration:0.5 animations:^{
        [[overlayView layer] setOpacity:1.0];
        
    }];
}
-(void)hideOverlayView:(UIView *)overlayView :(TRMMeasurementView *)measurementView
{
    [UIView animateWithDuration:0.5 animations:^{
        [[overlayView layer] setOpacity:0.0f];
    } completion:^(BOOL finished) {
        [overlayView removeFromSuperview];
        [measurementView removeCustomOverlayView];               
    }];
}

#pragma mark actions

-(IBAction)nextButtonTapped:(id)sender {
    //add custom init with measurements
    if (currentPage == [measurementTitles count] - 1) {
        //save data were done
        TRMMeasurementPhotosViewController *measurementPhotosViewController = [[TRMMeasurementPhotosViewController alloc] initWithNibName:@"TRMMeasurementPhotosViewController" bundle:nil];
        [measurementPhotosViewController setEdgesForExtendedLayout:UIRectEdgeNone];
        [[measurementPhotosViewController navigationItem] setTitle:@"TRUMAKER"];
        [[self navigationController] pushViewController:measurementPhotosViewController animated:YES];
        
    } else {
        currentPage++;
        //we need to check if the data already is there if not creat a new view else just scroll to that view
        NSLog(@"Setting Formula data %@ currentConfig %d",data, currentPage);
        if (![data neck] && currentPage == 0)
        {
            [formula neckFormula:data];
        }
        else if (![data chest] && currentPage == 1)
        {
            [formula chestFormula:data];
        }
        else if (![data waist] && currentPage == 2)
        {
            [formula waistFormula:data];
        }
        else if (![data seat] && currentPage == 3)
        {
            [formula seatFormula:data];
        }
        else if (![data shoulders] && currentPage == 4)
        {
            [formula shouldersFormula:data];
        }
        else if (![data rightArm] && currentPage == 5)
        {
            [formula rightArmFormula:data];
        }
        else if (![data leftArm] && currentPage == 6)
        {
            [formula leftArmFormula:data];
        }
        else if (![data rightWrist] && currentPage == 7)
        {
            [formula rightWristFormula:data];
        }
        else if (![data leftWrist] && currentPage == 8)
        {
            [formula leftWristFormula:data];
        }
        else if (![data shirtLength] && currentPage == 9)
        {
            [formula shirtFormula:data];
        }
        else if (![data bicep] && currentPage == 10)
        {
            [formula bicepFormula:data];
        }
        else
        {
           [self scrollToView];
        }
    }
}

-(IBAction)previousButtonTapped:(id)sender
{
    if (currentPage == 0)
    {
        currentPage = 0;
        [[self navigationController] popViewControllerAnimated:YES];
    }
    else
    {
        CGRect scrollViewRect = [[self scrollView] frame];
        currentPage--;
        CGRect updatedScrollFrame = CGRectMake(currentPage * CGRectGetWidth(scrollViewRect), 0,
                                               CGRectGetWidth(scrollViewRect),
                                               CGRectGetHeight(scrollViewRect));
        
        [measurementView removeFromSuperview]; //remove view its being redrawn multiple times
        [[self scrollView] scrollRectToVisible:updatedScrollFrame animated:YES];
    }
}
-(void)valueForConfiguration:(int)config value:(float)value withWarning:(BOOL)isRed
{
    NSLog(@"Red UP Top %d configuration %d",isRed, config);
    switch (currentPage) {
        case 0:
            [data setNeck:value];
            [data setNeckIsRed:isRed];
            break;
        case 1:
            [data setChest:value];
            [data setChestIsRed:isRed];
            break;
        case 2:
            [data setWaist:value];
            [data setWaistIsRed:isRed];
            break;
        case 3:
            [data setSeat:value];
            [data setSeatIsRed:isRed];
            break;
        case 4:
            [data setShoulders:value];
            [data setShouldersIsRed:isRed];
            break;
        case 5:
            [data setRightArm:value];
            [data setRightArmIsRed:isRed];
            break;
        case 6:
            [data setLeftArm:value];
            [data setLeftArmIsRed:isRed];
            break;
        case 7:
            [data setRightWrist:value];
            [data setRightWristIsRed:isRed];
            break;
        case 8:
            [data setLeftWrist:value];
            [data setLeftWristIsRed:isRed];
            break;
        case 9:
            [data setShirtLength:value];
            [data setShirtLengthIsRed:isRed];
            break;
        case 10:
            [data setBicep:value];
            [data setBicepIsRed:isRed];
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end