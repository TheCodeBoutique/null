//
//  TRMShipping_BillingViewController.m
//  Trumaker
//
//  Created by Marin Fischer on 1/19/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMShipping_BillingViewController.h"
#import "TRMCoreApi.h"
#import "TRMChooseAddressViewController.h"

@interface TRMShipping_BillingViewController ()

@property(nonatomic, strong) NSMutableArray *tableViewDataSource;

@end

@implementation TRMShipping_BillingViewController
@synthesize tableViewDataSource;

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
    
    //create the data source
     tableViewDataSource = [[NSMutableArray alloc] init];
    //if the customer has addresses already, show them
    if ([[TRMCoreApi sharedInstance] hasCustomerModel])
    {
        TRMAddressModel *primaryBillingAddress = [[[TRMCoreApi sharedInstance] customer] primaryBillingAddress];
        [tableViewDataSource addObject:primaryBillingAddress];
        TRMAddressModel *primaryShippingAddress = [[[TRMCoreApi sharedInstance] customer] primaryShippingAddress];
        [tableViewDataSource addObject:primaryShippingAddress];
    } else {
        //if this is the first time entering addresses then make add address an option
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
    return 2;
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

    [[cell detailTextLabel] setText:@"123 state street"];
    [[cell textLabel] setText:@"Shipping:"];
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //push self navingationController to new view
    TRMChooseAddressViewController *chooseAddressViewController = [[TRMChooseAddressViewController alloc] initWithNibName:@"TRMChooseAddressViewController" bundle:nil];
    [chooseAddressViewController setEdgesForExtendedLayout:UIRectEdgeNone];
    
    [[self navigationController] pushViewController:chooseAddressViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
