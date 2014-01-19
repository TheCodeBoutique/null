//
//  TRMCustomerDetailViewController.h
//  Trumaker
//
//  Created by Kyle Carriedo on 1/17/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRMCustomerModel.h"
#import "TRMPhoneContactModel.h"

@interface TRMCustomerDetailViewController : UIViewController
@property (nonatomic, strong) TRMCustomerModel *customer;
@property (nonatomic, strong) TRMPhoneContactModel *phoneContact;

@property (strong, nonatomic) IBOutlet UIView *imageViewWrapper;
@property (strong, nonatomic) IBOutlet UIView *customerWrapper;

@property (strong, nonatomic) IBOutlet UILabel *customerName;
@property (strong, nonatomic) IBOutlet UILabel *customerEmail;
@property (strong, nonatomic) IBOutlet UILabel *customerCity;
@property (strong, nonatomic) IBOutlet UILabel *totalFinishedOrders;
@property (strong, nonatomic) IBOutlet UILabel *customerCredit;
@property (strong, nonatomic) IBOutlet UILabel *confirmFit;
@property (strong, nonatomic) IBOutlet UILabel *customerType;

@property (strong, nonatomic) IBOutlet UIButton *createOrderButton;
@property (strong, nonatomic) IBOutlet UIButton *appointmentsButton;
@property (strong, nonatomic) IBOutlet UIButton *orderHistoryButton;
@property (strong, nonatomic) IBOutlet UIButton *callCustomerButton;
@property (strong, nonatomic) IBOutlet UIButton *messageButton;
@property (strong, nonatomic) IBOutlet UIButton *emailButton;
@end
