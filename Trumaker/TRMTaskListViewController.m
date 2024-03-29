//
//  TRMTaskListViewController.m
//  Trumaker
//
//  Created by Kyle Carriedo on 1/11/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMTaskListViewController.h"
#import "TRMBuildPreferenceViewController.h"
#import "TRMProductSelectionViewController.h"
#import "TRMCustomerInformationViewController.h"
#import "TRMMeasurementCustomerInfromationViewController.h"
#import "TRMShipping_BillingViewController.h"
#import "TRMShirtConfigurationViewController.h"
#import "TRMCheckoutViewController.h"

#import "TRMUtils.h"
#import "TRMTaskModel.h"
#import "TRMTaskListCell.h"
#import "UIAlertView+Blocks.h"
#import "TRMAppDelegate.h"
#import "TRMCoreApi.h"
@interface TRMTaskListViewController ()
@property (nonatomic, strong) NSMutableArray *tableDataSource;

@end

@implementation TRMTaskListViewController
@synthesize tableDataSource;
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
    [TRMUtils drawBorderForView:[self headerView] isBottomBorder:YES];
    [[[self cancelButton] layer] setCornerRadius:3.0f];
    [self setupTableViewData];
}

-(void)setupTableViewData
{
    tableDataSource = [[NSMutableArray alloc] init];
    TRMTaskModel *customerInfo = [[TRMTaskModel  alloc] init];
    [customerInfo setTitle:NSLocalizedString(@"Customer Info", @"Customer Info")];
    
    TRMTaskModel *productSelection = [[TRMTaskModel  alloc] init];
    [productSelection setTitle:NSLocalizedString(@"Production Selection", @"Production Selection")];
    
    TRMTaskModel *measurements = [[TRMTaskModel  alloc] init];
    [measurements setTitle:NSLocalizedString(@"Measurements", @"Measurements")];
    
    TRMTaskModel *preference = [[TRMTaskModel  alloc] init];
    [preference setTitle:NSLocalizedString(@"Preference Build", @"Preference Build")];
    
    TRMTaskModel *firstShirt = [[TRMTaskModel  alloc] init];
    [firstShirt setTitle:NSLocalizedString(@"First Shirt", @"First Shirt")];
    
    TRMTaskModel *creditCard = [[TRMTaskModel  alloc] init];
    [creditCard setTitle:NSLocalizedString(@"Credit Card", @"Credit Card")];
    
    TRMTaskModel *shippingBilling = [[TRMTaskModel  alloc] init];
    [shippingBilling setTitle:NSLocalizedString(@"Shipping & Billing", @"Shipping & Billing")];
    
    TRMTaskModel *checkout = [[TRMTaskModel  alloc] init];
    [checkout setTitle:NSLocalizedString(@"Checkout", @"Checkout")];
    
    [tableDataSource addObject:customerInfo];
    [tableDataSource addObject:productSelection];
    [tableDataSource addObject:measurements];
    [tableDataSource addObject:preference];
    [tableDataSource addObject:firstShirt];
    [tableDataSource addObject:creditCard];
    [tableDataSource addObject:shippingBilling];
    [tableDataSource addObject:checkout];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"taskCell";
    TRMTaskListCell *cell = (TRMTaskListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TRMTaskListCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    TRMTaskModel *model = [tableDataSource objectAtIndex:[indexPath row]];
    [[cell title] setText:[model title]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
//    if ([indexPath row] == 3) {
//        [cell setIsDisabled:YES];
//    }
    
    if ([indexPath row] == [tableDataSource count] - 1) {
        [cell setIsLastCell:YES];
    }
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == 0) {
        TRMCustomerInformationViewController *customerInformationViewController =[[TRMCustomerInformationViewController alloc] initWithNibName:@"TRMCustomerInformationViewController" bundle:nil];
        [customerInformationViewController setCustomer:[[TRMCoreApi sharedInstance] customer]];
        [customerInformationViewController setEdgesForExtendedLayout:UIRectEdgeNone];
        [[customerInformationViewController navigationItem] setHidesBackButton:YES];
        [self pushViewControllerStack:customerInformationViewController withTitle:@"TRUMAKER"];
    }
    
    if ([indexPath row] == 1) {
        TRMProductSelectionViewController *productSelectionViewController =[[TRMProductSelectionViewController alloc] initWithNibName:@"TRMProductSelectionViewController" bundle:nil];
        [productSelectionViewController setEdgesForExtendedLayout:UIRectEdgeNone];
        [[productSelectionViewController navigationItem] setHidesBackButton:YES];
        [self pushViewControllerStack:productSelectionViewController withTitle:@"Orders"];
    }
    
    if ([indexPath row] == 2) {
        TRMMeasurementCustomerInfromationViewController *measurementCustomerInfromationViewController =[[TRMMeasurementCustomerInfromationViewController alloc] initWithNibName:@"TRMMeasurementCustomerInfromationViewController" bundle:nil];
        [measurementCustomerInfromationViewController setEdgesForExtendedLayout:UIRectEdgeNone];
        [self pushViewControllerStack:measurementCustomerInfromationViewController withTitle:@"TRUMAKER"];
    }
    
    if ([indexPath row] == 3) {
        TRMBuildPreferenceViewController *buildPreferenceViewController = [[TRMBuildPreferenceViewController alloc] initWithNibName:@"TRMBuildPreferenceViewController" bundle:nil];
        [buildPreferenceViewController setEdgesForExtendedLayout:UIRectEdgeNone];
        [self pushViewControllerStack:buildPreferenceViewController withTitle:@"TRUMAKER"];
    }
    if ([indexPath row] == 4) {
        TRMShirtConfigurationViewController *shirtConfigurationViewController = [[TRMShirtConfigurationViewController alloc] initWithNibName:@"TRMShirtConfigurationViewController" bundle:nil];
        [shirtConfigurationViewController setEdgesForExtendedLayout:UIRectEdgeNone];
        [self pushViewControllerStack:shirtConfigurationViewController withTitle:@"TRUMAKER"];
    }

    
    if ([indexPath row] == 6) {
        TRMShipping_BillingViewController *shippingBillingViewController = [[TRMShipping_BillingViewController alloc] initWithNibName:@"TRMShipping_BillingViewController" bundle:nil];
        [shippingBillingViewController setEdgesForExtendedLayout:UIRectEdgeNone];
        [self pushViewControllerStack:shippingBillingViewController withTitle:@"TRUMAKER"];
    }
    
    if ([indexPath row] == 7) {
        TRMCheckoutViewController *checkoutViewController = [[TRMCheckoutViewController alloc] initWithNibName:@"TRMCheckoutViewController" bundle:nil];
        [checkoutViewController setEdgesForExtendedLayout:UIRectEdgeNone];
        [self pushViewControllerStack:checkoutViewController withTitle:@"TRUMAKER"];
    }
    
}

-(void)pushViewControllerStack:(UIViewController *)viewController withTitle:(NSString *)title {
    [[viewController navigationItem] setTitle:title];
    UINavigationController *mainNavigationControllter = [[UINavigationController alloc] initWithRootViewController:viewController];
    TRMAppDelegate *del = (TRMAppDelegate *)[[UIApplication sharedApplication] delegate];


    [[del rootViewController] setCenterViewController:mainNavigationControllter withCloseAnimation:YES completion:^(BOOL finished) {
        [del showMenuButton];        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)cancelOrderTapped:(id)sender {
    [[[UIAlertView alloc] initWithTitle:@"Cancel Order"
                                message:@"Are you sure you want to cancel this order?"
                       cancelButtonItem:[RIButtonItem itemWithLabel:@"No" action:^{
    }]
                       otherButtonItems:[RIButtonItem itemWithLabel:@"Yes" action:^{
        TRMAppDelegate *del = (TRMAppDelegate *)[[UIApplication sharedApplication] delegate];
        [del setDashboardViewContorllerToCenterViewController];
        [[del rootViewController] closeDrawerAnimated:YES completion:^(BOOL finished) {
            [[self tableView] scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [[del rootViewController] setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        }];
    }], nil] show];
}
@end
