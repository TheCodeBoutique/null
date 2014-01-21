//
//  TRMShipping_BillingViewController.m
//  Trumaker
//
//  Created by Marin Fischer on 1/19/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMShipping_BillingViewController.h"
#import "TRMChooseAddressViewController.h"
#import "TRMCoreApi.h"
#import "TRMCustomerDAO.h"
#import "MBProgressHUD.h"
@interface TRMShipping_BillingViewController ()<TRMChooseAddressDelegate>

@property(nonatomic, strong) NSMutableArray *tableViewDataSource;
@property(nonatomic, strong)TRMAddressModel *primaryBillingAddress;
@property(nonatomic, strong)TRMAddressModel *primaryShippingAddress;
@end

@implementation TRMShipping_BillingViewController
@synthesize tableViewDataSource;
@synthesize primaryBillingAddress;
@synthesize primaryShippingAddress;

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
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(didTapSave:)];
    [[self navigationItem] setRightBarButtonItem:saveButton];
    
    //create the data source
     tableViewDataSource = [[NSMutableArray alloc] init];
    //if the customer has addresses already, show them
    if ([[TRMCoreApi sharedInstance] hasCustomerModel])
    {
        
        tableViewDataSource = [[[TRMCoreApi sharedInstance] customer] primaryAndBillingAddresses];
        [tableViewDataSource enumerateObjectsUsingBlock:^(TRMAddressModel *address, NSUInteger idx, BOOL *stop) {
            if ([address shipping_default]) {
                [self setPrimaryShippingAddress:address];
            }
            if ([address billing_default]) {
                [self setPrimaryBillingAddress:address];
            }
        }];
        
//        primaryBillingAddress =
//        if (primaryBillingAddress) {
//            [tableViewDataSource addObject:primaryBillingAddress];
//        }
//        
//        primaryShippingAddress = [[[TRMCoreApi sharedInstance] customer] primaryShippingAddress];
//        if (primaryShippingAddress) {
//            [tableViewDataSource addObject:primaryShippingAddress];
//        }
    } else {
        //if this is the first time entering addresses then make add address an option
    }
}

-(void)didTapSave:(id)sender {
//    if ([primaryShippingAddress id] && [primaryBillingAddress id]) {
        if ([tableViewDataSource count] > 1) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[[[UIApplication sharedApplication] keyWindow] rootViewController] view] animated:YES];
        [hud setMode:MBProgressHUDModeIndeterminate];
        [hud show:YES];
        [hud setLabelText:NSLocalizedString(@"Saving...", @"Saving...")];
            
        TRMAddressModel *shippingModel = [tableViewDataSource objectAtIndex:0];
        TRMAddressModel *billingModel = [tableViewDataSource objectAtIndex:1];
        [shippingModel setShipping_default:YES];
        [billingModel setBilling_default:YES];
            
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array addObject:billingModel];
        [array addObject:shippingModel];
        
        [TRMCustomerDAO updateAddresses:array forCustomer:[[TRMCoreApi sharedInstance] customer] completionHandler:^(TRMCustomerModel *newCustomer, NSError *error) {
            if (!error) {
                
            }
            [hud hide:YES];
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return ([tableViewDataSource count] > 0) ? [tableViewDataSource count] : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //create a cell if there isnt one, or use a pre-existing one if we already have one
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    int row = [indexPath  row];
    
    if ([tableViewDataSource count] > 0) {
        TRMAddressModel *address = [tableViewDataSource objectAtIndex:row];
        [[cell detailTextLabel] setText:[address address1]];
        [[cell textLabel] setText:(row == 0) ? @"Shipping" : @"Billing"];
    } else {
        [[cell detailTextLabel] setText:@"+ No Addresses"]; //tmp
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //push self navingationController to new view
    TRMChooseAddressViewController *chooseAddressViewController = [[TRMChooseAddressViewController alloc] initWithNibName:@"TRMChooseAddressViewController" bundle:nil];
    BOOL isShipping = ([indexPath row] == 0) ? YES : NO;
    NSString *title = (isShipping) ? @"Shipping Address" : @"Billing Address";
    [chooseAddressViewController setControllerTitle:title];
    [chooseAddressViewController setIsShipping:isShipping];
    [chooseAddressViewController setDelegate:self];
    [chooseAddressViewController setEdgesForExtendedLayout:UIRectEdgeNone];
    [[self navigationController] pushViewController:chooseAddressViewController animated:YES];
}


-(void)didSelectAddress:(TRMAddressModel *)address state:(BOOL)isShipping {
    if (isShipping) {
        [tableViewDataSource replaceObjectAtIndex:0 withObject:address];
    } else {
        [tableViewDataSource replaceObjectAtIndex:1 withObject:address];
    }
    [[self tableView] reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
