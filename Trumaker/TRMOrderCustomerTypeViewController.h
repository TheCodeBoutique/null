//
//  TRMOrderTypeViewController.h
//  Trumaker
//
//  Created by Kyle Carriedo on 1/11/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRMOrderCustomerTypeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *createCustomerButton;
@property (strong, nonatomic) IBOutlet UIButton *existingCustomerButton;

- (IBAction)existingCustomerTapped:(id)sender;
- (IBAction)createCustomerTapped:(id)sender;
@end
