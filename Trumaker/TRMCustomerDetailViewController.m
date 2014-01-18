//
//  TRMCustomerDetailViewController.m
//  Trumaker
//
//  Created by Kyle Carriedo on 1/17/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMCustomerDetailViewController.h"
#import "TRMCustomerInformationViewController.h"
#import "TRMAppDelegate.h"

@interface TRMCustomerDetailViewController ()

@end
@implementation TRMCustomerDetailViewController
@synthesize customer;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)createOrderTapped:(id)sender {
    TRMCustomerInformationViewController *customerInformationViewController = [[TRMCustomerInformationViewController alloc] initWithNibName:@"TRMCustomerInformationViewController" bundle:nil];
    [[customerInformationViewController navigationItem] setTitle:@"TRUMAKER"];
    [customerInformationViewController setCustomer:customer];
    [customerInformationViewController setEdgesForExtendedLayout:UIRectEdgeNone];
    
    TRMAppDelegate *del = [[UIApplication sharedApplication] delegate];
    [del setCenterViewController:customerInformationViewController];
    [[del rootViewController] closeDrawerAnimated:YES completion:^(BOOL finished) {
        
    }];
}
@end
