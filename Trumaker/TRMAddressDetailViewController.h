//
//  TRMAddressDetailViewController.h
//  Trumaker
//
//  Created by Marin Fischer on 1/19/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRMIndentTextField.h"

@interface TRMAddressDetailViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet TRMIndentTextField *streetTextField;
@property (weak, nonatomic) IBOutlet TRMIndentTextField *streetContTextField;
@property (weak, nonatomic) IBOutlet TRMIndentTextField *cityTextField;
@property (weak, nonatomic) IBOutlet TRMIndentTextField *stateTextField;
@property (weak, nonatomic) IBOutlet TRMIndentTextField *zipTextField;

- (IBAction)useAsShippingButton:(id)sender;
- (IBAction)useAsBilling:(id)sender;
- (IBAction)useAsBoth:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *shippingImageView;
@property (weak, nonatomic) IBOutlet UIImageView *billingImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bothImageView;
@end
