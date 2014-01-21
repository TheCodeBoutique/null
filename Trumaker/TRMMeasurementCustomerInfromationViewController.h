//
//  TRMMeasurementCustomerInfromationViewController.h
//  Trumaker
//
//  Created on 8/18/13.
//  Copyright (c) 2013 The Code Boutique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRMFormulaData.h"

@interface TRMMeasurementCustomerInfromationViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) TRMFormulaData *formulaData;
@property (weak, nonatomic) IBOutlet UIScrollView *measurementScrollView;
@property (weak, nonatomic) IBOutlet UITextField *heightField;
@property (weak, nonatomic) IBOutlet UITextField *heightInchesField;

@property (weak, nonatomic) IBOutlet UITextField *weightField;
@property (weak, nonatomic) IBOutlet UIImageView *shoulderImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectedAngleShoulder;
@property (weak, nonatomic) IBOutlet UISegmentedControl *shoulderAngleControl;
@property (weak, nonatomic) IBOutlet UILabel *shoulderTitle;

@property (weak, nonatomic) IBOutlet UIButton *leftWristWatchButton;
@property (weak, nonatomic) IBOutlet UIButton *rightWristWatchButton;
@property (weak, nonatomic) IBOutlet UIButton *noWristWatchButton;
@property (weak, nonatomic) IBOutlet UIButton *normalShoulderButton;
@property (weak, nonatomic) IBOutlet UIButton *squareShoulderButton;
@property (weak, nonatomic) IBOutlet UIButton *slopeShoulderButton;

//Boolean for checking if we are updating exsisting customer
@property (assign, nonatomic) BOOL isUpdating;
@property (nonatomic, assign) BOOL preExistingInformation;

- (IBAction)didTapOnScrollView:(id)sender;

- (IBAction)didTapLeftWristWatch:(id)sender;
- (IBAction)didTapRightWristWatch:(id)sender;
- (IBAction)didTapNoWristWatch:(id)sender;

- (IBAction)didTapOnNormalShoulderButton:(id)sender;
- (IBAction)didTapOnSquareShoulderButton:(id)sender;
- (IBAction)didTapOnSlopeShoulderButton:(id)sender;
@end
