//
//  TRMLoginViewController.h
//  Trumaker
//
//  Created by Marin Fischer on 1/6/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRMIndentTextField.h"

@interface TRMLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet TRMIndentTextField *loginEmailTextField;
@property (weak, nonatomic) IBOutlet TRMIndentTextField *loginPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIScrollView *loginScrollView;
@property (weak, nonatomic) IBOutlet UIView *loginFormBaseView;

- (IBAction)signinButton:(id)sender;
- (IBAction)forgotPasswordButton:(id)sender;



@end
