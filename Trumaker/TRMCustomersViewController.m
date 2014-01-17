//
//  TRMCustomersViewController.m
//  Trumaker
//
//  Created by Kyle Carriedo on 1/16/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.

#import "TRMCustomersViewController.h"
#import "TRMCustomerModel.h"
#import "TRMPhoneContactModel.h"
#import "TRMCoreApi.h"

@interface TRMCustomersViewController ()
@property (strong, nonatomic) NSMutableArray *localContactsDataSource;
@end
@implementation TRMCustomersViewController
@synthesize customersDataSource;
@synthesize localContactsDataSource;
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
    customersDataSource = [[TRMCoreApi sharedInstance] outfitterCustomers];
    localContactsDataSource = [[TRMCoreApi sharedInstance] localContacts];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [customersDataSource count];
    } else {
        return [localContactsDataSource count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Trumaker Customers";
    } else {
        return @"Contacts";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {
        TRMCustomerModel *customer = [customersDataSource objectAtIndex:indexPath.row];
        [[cell textLabel] setText:[customer fullName]];
    } else {        
        TRMPhoneContactModel *customer = [localContactsDataSource objectAtIndex:indexPath.row];
        [[cell textLabel] setText:[customer fullName]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
