//
//  TRMOrderTypeViewController.m
//  Trumaker
//
//  Created by Kyle Carriedo on 1/11/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMOrderCustomerTypeViewController.h"
#import "TRMCustomerInformationViewController.h"
#import "TRMAppDelegate.h"


@interface TRMOrderCustomerTypeViewController ()

@end

@implementation TRMOrderCustomerTypeViewController

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
    [[[self createCustomerButton] layer] setCornerRadius:10.0f];
    [[[self existingCustomerButton] layer] setCornerRadius:10.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)existingCustomerTapped:(id)sender {
}

- (IBAction)createCustomerTapped:(id)sender {
    [[self navigationController] popViewControllerAnimated:NO];
    TRMAppDelegate *del = [[UIApplication sharedApplication] delegate];    
    TRMCustomerInformationViewController *customerInformationViewController = [[TRMCustomerInformationViewController alloc] initWithNibName:@"TRMCustomerInformationViewController" bundle:nil];
    [del setCenterViewController:customerInformationViewController];
}
@end
