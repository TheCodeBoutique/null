//
//  TRMCustomerInformationViewController.h
//  Trumaker
//
//  Created by Kyle Carriedo on 1/11/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRMIndentTextField.h"
#import "TRMCustomerModel.h"
#import "TRMPhoneContactModel.h"
@interface TRMCustomerInformationViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet TRMIndentTextField *firstName;
@property (weak, nonatomic) IBOutlet TRMIndentTextField *lastName;
@property (weak, nonatomic) IBOutlet TRMIndentTextField *phoneNumber;
@property (weak, nonatomic) IBOutlet TRMIndentTextField *emailField;
@property (strong, nonatomic) TRMPhoneContactModel *phoneContact;
@property (strong, nonatomic) TRMCustomerModel *customer;
@end
