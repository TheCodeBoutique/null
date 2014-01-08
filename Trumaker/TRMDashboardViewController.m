//
//  TRMDashboardViewController.m
//  Trumaker
//
//  Created by Marin Fischer on 1/7/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMDashboardViewController.h"
#import "TRMDashboardModel.h"
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
        [self setupTableViewData];
    }
    return self;
}

-(void)setupTableViewData {
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
    // Do any additional setup after loading the view from its nib.
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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    TRMDashboardModel *model = [dashboardData objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[model title]];
    
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
