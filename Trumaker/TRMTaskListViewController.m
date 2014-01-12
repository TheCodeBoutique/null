//
//  TRMTaskListViewController.m
//  Trumaker
//
//  Created by Kyle Carriedo on 1/11/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMTaskListViewController.h"
#import "TRMUtils.h"
#import "TRMTaskModel.h"
#import "TRMTaskListCell.h"
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
    
    if ([indexPath row] == 3) {
        [cell setIsDisabled:YES];
    }
    
    if ([indexPath row] == [tableDataSource count] - 1) {
        [cell setIsLastCell:YES];
    }
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)cancelOrderTapped:(id)sender {
}
@end
