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
#import "TRMOrderCustomerTypeViewController.h"

#import "TRMOutfitterModel.h"
#import "TRMCoreApi.h"
#import "TRMUtils.h"

@interface TRMDashboardViewController ()
@property (nonatomic, strong) NSMutableArray *dashboardData;
@property (nonatomic, strong) TRMOutfitterModel *outfitter;
@property (nonatomic, assign) BOOL customersUpdated;
@end

@implementation TRMDashboardViewController
@synthesize dashboardData;
@synthesize customersUpdated;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        customersUpdated = NO;
    }
    return self;
}

-(void)udpateImageView {
    UIImage *maskedImage = [TRMUtils maskImage:[UIImage imageNamed:@"profile_image_mask_base"] withMask:[_outfitter outfitterImage]];
    [[self outfitterImageView] setImage:maskedImage];
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
    _outfitter = [[TRMCoreApi sharedInstance] outfitter];
    [_outfitterName setText:[_outfitter fullName]];
    [_outfitterLocation setText:[_outfitter city]];
    [self udpateImageView];
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
    
    //we need to make contacts cell deativated till notifcation registers and lets us know contacts have been updated
    if ([[model title] isEqualToString:@"Contacts"] && !customersUpdated) {
        [[cell cellTitle] setText:@"Loading Contacts..."];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setIsDisabled:YES];
    } else {
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        [cell setIsDisabled:NO];
    }
    
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //dont allow selection for contacts if its not updated
    if ([indexPath row] == 3 && !customersUpdated) {
        return;
    }
    
    if ([indexPath row] == 0) {
        //order selected
        TRMOrderCustomerTypeViewController *orderCustomerTypeViewController = [[TRMOrderCustomerTypeViewController alloc] initWithNibName:@"TRMOrderCustomerTypeViewController" bundle:nil];
        [[orderCustomerTypeViewController navigationItem] setTitle:@"TRUMAKER"];
        [[[orderCustomerTypeViewController navigationItem] backBarButtonItem] setTitle:@"Back"];
        [orderCustomerTypeViewController setEdgesForExtendedLayout:UIRectEdgeNone];
        [[self navigationController] pushViewController:orderCustomerTypeViewController animated:YES];
    }       
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[self navigationItem] setTitle:@"Back"];

    //notification for clients update
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:@"clientsUpdateNotification"
     object:nil
     ];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationItem] setTitle:@"TRUMAKER"];
    [[NSNotificationCenter defaultCenter]
     
     addObserver:self
     selector:@selector(updateClients:)
     name:@"clientsUpdateNotification"
     object:nil ];
}

-(void)updateClients:(NSNotification *)notification {
    customersUpdated = YES;
    [[self tableView] reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
