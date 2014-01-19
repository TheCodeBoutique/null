
//
//  TRMOrderTypeViewController.m
//  Trumaker
//
//  Created by Kyle Carriedo on 1/11/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMOrderCustomerTypeViewController.h"
#import "TRMCustomerInformationViewController.h"
#import "TRMCustomersViewController.h"
#import "TRMAppDelegate.h"
#import "TRMCoreApi.h"

@interface TRMOrderCustomerTypeViewController ()
@property (nonatomic, assign) BOOL customersLoaded;
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


- (void)viewWillDisappear:(BOOL)animated
{
    //notification for clients update
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:@"clientsUpdateNotification"
     object:nil
     ];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]
     
     addObserver:self
     selector:@selector(updateClients:)
     name:@"clientsUpdateNotification"
     object:nil ];
}

-(void)updateClients:(NSNotification *)notification {
    _customersLoaded = [[TRMCoreApi sharedInstance] existingCustomersLoaded];
    [self updateButtonState];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[[self createCustomerButton] layer] setCornerRadius:10.0f];
    [[[self existingCustomerButton] layer] setCornerRadius:10.0f];
    
    [self updateButtonState];
}

-(void)updateButtonState {
    _customersLoaded = [[TRMCoreApi sharedInstance] existingCustomersLoaded];
    
    if (_customersLoaded) {
        [[_existingCustomerButton titleLabel] setText:@"Existing Customer"];
        [_existingCustomerButton setEnabled:YES];
    } else {
        [[_existingCustomerButton titleLabel] setText:@"Loading Contacts..."];
        [_existingCustomerButton setEnabled:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)existingCustomerTapped:(id)sender
{
    TRMCustomersViewController *existingCustomersViewController = [[TRMCustomersViewController alloc] initWithNibName:@"TRMCustomersViewController" bundle:nil];
    
    [[self navigationController] pushViewController:existingCustomersViewController animated:YES];
}

- (IBAction)createCustomerTapped:(id)sender
{
    [[self navigationController] popViewControllerAnimated:NO];
    TRMAppDelegate *del = [[UIApplication sharedApplication] delegate];    
    TRMCustomerInformationViewController *customerInformationViewController = [[TRMCustomerInformationViewController alloc] initWithNibName:@"TRMCustomerInformationViewController" bundle:nil];
    [del setCenterViewController:customerInformationViewController];
}
@end
