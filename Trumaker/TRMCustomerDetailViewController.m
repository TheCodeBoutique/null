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
#import "TRMUtils.h"

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
    [self setupBorders];
    
    if (customer) {
        //we have trumaker custoner
        [_customerName setText:[customer fullName]];
        [_customerEmail setText:[customer email]];
        [_customerCity setText:[[customer primaryAddress] city]];
        [_customerType setText:@"Trumaker"];        
        NSString *confirmFit = ([[customer confirmed_fit] intValue] > 0) ? @"Yes" : @"No";
        [_confirmFit setText:confirmFit];
        [_totalFinishedOrders setText:[NSString stringWithFormat:@"%@",[customer finished_orders_count]]];
        [_customerCredit setText:[NSString stringWithFormat:@"$ %0f",[customer store_credit]]];
    } else {        
        //we have local phone contacts
        [_customerName setText:[_phoneContact fullName]];
        [_customerType setText:@"Local"];
        [_confirmFit setText:@"No"];
        [_customerCredit setText:@"$ 0"];
    }
}

-(void)setupBorders {
    [[_imageViewWrapper layer] setBorderWidth:[TRMUtils halfPixel]];
    [[_imageViewWrapper layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    [TRMUtils drawBorderForView:_customerWrapper isBottomBorder:YES];
    
    [TRMUtils drawBorderForView:_createOrderButton isBottomBorder:YES];
    [TRMUtils drawBorderForView:_appointmentsButton isBottomBorder:YES];
    [TRMUtils drawBorderForView:_orderHistoryButton isBottomBorder:YES];
    
    [TRMUtils drawBorderForView:_callCustomerButton isBottomBorder:YES];
    [TRMUtils drawBorderForView:_messageButton isBottomBorder:YES];
    [TRMUtils drawBorderForView:_emailButton isBottomBorder:YES];
    
    [TRMUtils drawLeftBorder:_appointmentsButton];
    [TRMUtils drawLeftBorder:_messageButton];
    [TRMUtils drawLeftBorder:_orderHistoryButton];
    [TRMUtils drawLeftBorder:_emailButton];
    
    
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
