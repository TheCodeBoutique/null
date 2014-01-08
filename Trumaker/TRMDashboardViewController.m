//
//  TRMDashboardViewController.m
//  Trumaker
//
//  Created by Marin Fischer on 1/7/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//
#import "TRMDashboardModel.h"
#import "TRMDashboardViewController.h"
#import "TRMDashboardTableViewCell.h"

@interface TRMDashboardViewController ()
@property (nonatomic, strong) NSMutableArray *dashboardData;
@end

@implementation TRMDashboardViewController
@synthesize dashboardData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setupTableViewData
{
    dashboardData = [[NSMutableArray alloc] initWithCapacity:5];
    TRMDashboardModel *orderModel = [[TRMDashboardModel alloc] init];
    [orderModel setTitle:NSLocalizedString(@"Order", @"Order")];
    
    TRMDashboardModel *leadsModel = [[TRMDashboardModel alloc] init];
    [leadsModel setTitle:NSLocalizedString(@"Leads", @"Leads")];
    
    TRMDashboardModel *trumakerNewsModel = [[TRMDashboardModel alloc] init];
    [trumakerNewsModel setTitle:NSLocalizedString(@"Trumaker News", @"Trumaker News")];
    
    TRMDashboardModel *contactsModel = [[TRMDashboardModel alloc] init];
    [contactsModel setTitle:NSLocalizedString(@"Contacts", @"Contacts")];
    
    TRMDashboardModel *catalogueModel = [[TRMDashboardModel alloc] init];
    [catalogueModel setTitle:NSLocalizedString(@"Catalogue", @"Catalogue")];
    
    [dashboardData addObject:orderModel];
    [dashboardData addObject:leadsModel];
    [dashboardData addObject:trumakerNewsModel];
    [dashboardData addObject:contactsModel];
    [dashboardData addObject:catalogueModel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableViewData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dashboardData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DashboardTableCell";
    TRMDashboardTableViewCell *cell = (TRMDashboardTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TRMDashboardTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    TRMDashboardModel *model = [dashboardData objectAtIndex:[indexPath row]];
    [[cell cellTitle] setText:[model title]];
     ([indexPath row] == [dashboardData count] - 1) ? [cell setIsLastCell:YES] :[cell setIsLastCell:NO];
    
    
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
