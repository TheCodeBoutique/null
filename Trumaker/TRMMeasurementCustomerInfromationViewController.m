//
//  TRMMeasurementCustomerInfromationViewController.m
//  Trumaker
//
//  Created  on 8/18/13.
//  Copyright (c) 2013 The Code Boutique. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "TRMMeasurementCustomerInfromationViewController.h"
#import "TRMMeasurementPhotosViewController.h"
#import "TRMeasurementsViewController.h"
#import "TRMFormulaData.h"
#import "TRMCoreApi.h"
#import "TRMMeasurement.h"
#import "MBProgressHUD.h"
#import "TRMUtils.h"
#import "TRMAppDelegate.h"

enum SelectionType {
    kLeftWristWatch = 0,
    kRightWristWatch = 1,
    kNoWristWatch = 2,
    kNormalShoulder = 3,
    kSquareShoulder= 4,
    kSlopeShoulder = 5
};


@interface TRMMeasurementCustomerInfromationViewController ()<UIScrollViewDelegate, UITextFieldDelegate>
{
    NSArray *feet;
    NSArray *quarters;
    NSString *feetString;
    NSString *quarterString;
    MBProgressHUD *hud;
}

@property (nonatomic, strong) UITextField *selectedTextField;

@end

@implementation TRMMeasurementCustomerInfromationViewController
@synthesize shoulderAngleControl;
@synthesize shoulderImageView;
@synthesize weightField;
@synthesize formulaData;
@synthesize heightField;
@synthesize heightInchesField;

@synthesize selectedTextField;


#define MAX_FEET_LENGTH 1
#define MAX_INCHES_LENGTH 2
#define MAX_WEIGHT 3
#define CONTENT_SIZE 300
#define VIEW_WIDTH 320
#define VIEW_HEIGHT 480

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (formulaData) {
        [self inchesToFeet:[formulaData height]];
        [[self weightField] setText:[NSString stringWithFormat:@"%d",(int)[formulaData weight]]];
    }
    
    UIView *paddingWeightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    weightField.leftView = paddingWeightView;
    weightField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingForFeetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    heightField.leftView = paddingForFeetView;
    heightField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingForInchesView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    heightInchesField.leftView = paddingForInchesView;
    heightInchesField.leftViewMode = UITextFieldViewModeAlways;
    
    [self addAccessoryViewForTextField:[self weightField]];
    [self addAccessoryViewForTextField:[self heightField]];
    [self addAccessoryViewForTextField:[self heightInchesField]];
    
    //set content size of scroll view so the view is scrollable on the 4s
    [[self measurementScrollView] setContentSize:CGSizeMake(VIEW_WIDTH, VIEW_HEIGHT)];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setSelectedTextField:textField];
    [self addAccessoryViewForTextField:textField];
}

//Make sure the inches are between 0 and 11
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *currentValue = [heightInchesField text];
    NSInteger myInt = [currentValue intValue];
    
        if (myInt > 11) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Inches Field Exceeds Maximum"
                                                            message:@"Inches must be between 0 and 11."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }
}

// Make the height field have a max length of one for feet
- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([[textField placeholder] isEqualToString:@"ft"]) {
        NSUInteger oldLength = [heightField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= MAX_FEET_LENGTH || returnKey;
        
    } else if ([[textField placeholder] isEqualToString:@"in"]) {
        NSUInteger oldLength = [heightInchesField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
        return newLength <= MAX_INCHES_LENGTH || returnKey;
        
    } else if([[textField placeholder] isEqualToString:@"lbs."]) {
        NSUInteger oldLength = [weightField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= MAX_WEIGHT || returnKey;
    }
    return YES;
}

-(void)inchesToFeet:(CGFloat)inches {
    CGFloat totalFeet = inches / 12.0f;
    int convertedFeet = (int)totalFeet;
    CGFloat totalInchesFromFeet = convertedFeet * 12;
    int leftOverInches = inches - totalInchesFromFeet;
    
    //update ivar's
    feetString = [NSString stringWithFormat:@"%d",convertedFeet];
    quarterString = [NSString stringWithFormat:@"%i",leftOverInches];
    
    //update text field
    [[self heightField] setText:[NSString stringWithFormat:@"%d",convertedFeet]];
    [[self heightInchesField] setText:[NSString stringWithFormat:@"%i", leftOverInches]];
}

-(IBAction)nextBarButtonTapped:(id)sender
{
    [self saveData];
    
    TRMAppDelegate *del = (TRMAppDelegate *)[[UIApplication sharedApplication] delegate];
    TRMeasurementsViewController *measurementsViewController = [[TRMeasurementsViewController alloc] initWithNibName:@"TRMeasurementsViewController" bundle:nil];
    [measurementsViewController setEdgesForExtendedLayout:UIRectEdgeNone];
    [[measurementsViewController navigationItem] setTitle:@"Order"];
    [[measurementsViewController navigationItem] setLeftBarButtonItem:[del menuBarButton]];
    [measurementsViewController setData:formulaData];
    [[self navigationController] pushViewController:measurementsViewController animated:YES];    
}

-(void)saveData
{
    //if we dont have any data create new data
    if (!formulaData) {
        formulaData = [[TRMFormulaData alloc] init];
    }
    [formulaData setWeight:[[weightField text] floatValue]];
    [formulaData setHeight:[self convertHeight]];
}

-(float)convertHeight
{
    float totalHeight = [[[self heightField]text] floatValue];
    float myFeet = (int) totalHeight; //returns 5 feet
    int inches = [[[self heightInchesField]text] intValue];
    float myInches = round(myFeet * 12);
    
    NSLog(@"%f",myInches + inches);
    return myInches + inches;
}


- (IBAction)angleControlChanged:(id)sender
{
    UISegmentedControl *segControl = (UISegmentedControl *)sender;
    NSInteger selection = [segControl selectedSegmentIndex];
    if (selection == 0)
    {
        [shoulderImageView setImage:[UIImage imageNamed:@"square_shoulders.png"]];
    }
    else if (selection == 1)
    {
        [shoulderImageView setImage:[UIImage imageNamed:@"normal_shoulders.png"]];
    }
    else
    {
        [shoulderImageView setImage:[UIImage imageNamed:@"slopped_shoulders.png"]];
    }
    
}

- (IBAction)didTapOnScrollView:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)didTapLeftWristWatch:(id)sender
{
    [self updateWristWatchOption:kLeftWristWatch];
}

- (IBAction)didTapRightWristWatch:(id)sender
{
    [self updateWristWatchOption:kRightWristWatch];
}

- (IBAction)didTapNoWristWatch:(id)sender
{
    [self updateWristWatchOption:kNoWristWatch];
}

- (IBAction)didTapOnNormalShoulderButton:(id)sender
{
    [self updateShoulderSlopeOptions:kNormalShoulder];
}

- (IBAction)didTapOnSquareShoulderButton:(id)sender
{
    [self updateShoulderSlopeOptions:kSquareShoulder];
}

- (IBAction)didTapOnSlopeShoulderButton:(id)sender
{
    [self updateShoulderSlopeOptions:kSlopeShoulder];
}

-(void)updateWristWatchOption:(int)selected
{
    if (selected == kLeftWristWatch) {
        [self applySelectedStateToButton:[self leftWristWatchButton]];
        [self applyUnSelectedStateToButton:[self rightWristWatchButton]];
        [self applyUnSelectedStateToButton:[self noWristWatchButton]];
    } else if (selected == kRightWristWatch) {
        [self applySelectedStateToButton:[self rightWristWatchButton]];
        [self applyUnSelectedStateToButton:[self leftWristWatchButton]];
        [self applyUnSelectedStateToButton:[self noWristWatchButton]];
    } else if (selected == kNoWristWatch) {
        [self applySelectedStateToButton:[self noWristWatchButton]];
        [self applyUnSelectedStateToButton:[self leftWristWatchButton]];
        [self applyUnSelectedStateToButton:[self rightWristWatchButton]];
    }
}

-(void)updateShoulderSlopeOptions:(int)selected
{
    if (selected == kNormalShoulder) {
 
        [self applySelectedStateToButton:[self normalShoulderButton]];
        [self applyUnSelectedStateToButton:[self squareShoulderButton]];
        [self applyUnSelectedStateToButton:[self slopeShoulderButton]];
    } else if (selected == kSquareShoulder) {
 
        [self applySelectedStateToButton:[self squareShoulderButton]];
        [self applyUnSelectedStateToButton:[self normalShoulderButton]];
        [self applyUnSelectedStateToButton:[self slopeShoulderButton]];
    } else if (selected == kSlopeShoulder) {
 
        [self applySelectedStateToButton:[self slopeShoulderButton]];
        [self applyUnSelectedStateToButton:[self normalShoulderButton]];
        [self applyUnSelectedStateToButton:[self squareShoulderButton]];
    }
    
 
}
-(void)applySelectedStateToButton:(UIButton *)button
{
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [button setImage:[UIImage imageNamed:@"check_radio_on"] forState:UIControlStateNormal];
}

-(void)applyUnSelectedStateToButton:(UIButton *)button
{
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [button setImage:[UIImage imageNamed:@"check_radio_off"] forState:UIControlStateNormal];
}

- (void)didSelectAngle:(CGFloat)selection
{
    if (selection == 0)
    {
        [[self selectedAngleShoulder] setImage:[UIImage imageNamed:@"normal_shoulders.png"]];
        [[self shoulderTitle] setText:@"Normal"];
    }
    else if (selection == 1)
    {
        [[self selectedAngleShoulder] setImage:[UIImage imageNamed:@"slopped_shoulders.png"]];
        [[self shoulderTitle] setText:@"Slopped"];
    }
    else
    {
        [[self selectedAngleShoulder] setImage:[UIImage imageNamed:@"square_shoulders.png"]];
        [[self shoulderTitle] setText:@"Squared"];
    }
}

-(void)addAccessoryViewForTextField:(UITextField *)textField
{
    UIToolbar *toolbar = [[UIToolbar alloc] init] ;
    [toolbar setBarStyle:UIBarStyleDefault];
    [toolbar sizeToFit];
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyboard)];
    [doneButton setTintColor:[TRMUtils colorWithHexString:@"959fa5"]];
    
    UIBarButtonItem *previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStyleBordered target:self action:@selector(previousTapped:)];
    [previousButton setTintColor:[TRMUtils colorWithHexString:@"959fa5"]];

    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextTapped:)];
    [nextButton setTintColor:[TRMUtils colorWithHexString:@"959fa5"]];

    
    NSArray *itemsArray = [NSArray arrayWithObjects:previousButton, nextButton, flexButton, doneButton, nil];
    [toolbar setItems:itemsArray];
    [textField setInputAccessoryView:toolbar];
}

- (void)previousTapped:(id)sender
{
    int currentTag = [selectedTextField tag];
    if (currentTag == 1)
    {
        [self resignKeyboard];
    }
    UITextField *nextTextField = (UITextField *)[[self view] viewWithTag:currentTag - 1];
    [[self measurementScrollView] scrollRectToVisible:[nextTextField frame] animated:YES];
    [nextTextField becomeFirstResponder];
}

-(void)nextTapped:(id)sender
{
    int currentTag = [selectedTextField tag];
    if (currentTag == 3)
    {
        [self resignKeyboard];
    }
    UITextField *nextTextField = (UITextField *)[[self view] viewWithTag:currentTag + 1];
    [[self measurementScrollView] scrollRectToVisible:[nextTextField frame] animated:YES];
    [nextTextField becomeFirstResponder];
}


-(void)resignKeyboard
{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
