//
//  TRMChooseAddressViewController.m
//  Trumaker
//
//  Created by Marin Fischer on 1/19/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMChooseAddressViewController.h"
#import "TRMCoreApi.h"
#import "TRMAddressDetailViewController.h"

@interface TRMChooseAddressViewController ()
@property (nonatomic, strong) NSMutableArray *tableViewDataSource;
@property (nonatomic, strong) TRMAddressModel *selectedAddress;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableFooterView;

@end

@implementation TRMChooseAddressViewController
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
        tableViewDataSource = [[[TRMCoreApi sharedInstance] customer] addresses];
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
    return [tableViewDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    int row = [indexPath row];
    if ([tableViewDataSource count] > 0) {
        TRMAddressModel *address = [tableViewDataSource objectAtIndex:row];
        [[cell detailTextLabel] setText:[address address1]];
        [[cell textLabel] setText:[address cityState]];
    }
    [[self tableView] setTableFooterView:_tableFooterView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedAddress = [tableViewDataSource objectAtIndex:[indexPath row]];
    //show action sheet
    [[[UIActionSheet alloc] initWithTitle:@"Address Options"
                         cancelButtonItem: [RIButtonItem itemWithLabel:@"Cancel" action:^{
                        [self dismissViewControllerAnimated:YES completion:nil];
        
    }]
                    destructiveButtonItem:[RIButtonItem itemWithLabel:@"Delete Address" action:^{
                        [self dismissViewControllerAnimated:YES completion:nil];
        
    }]
                         otherButtonItems:[RIButtonItem itemWithLabel:@"Use Address" action:^{
                        [self dismissViewControllerAnimated:YES completion:nil];
        
    }],
                        [RIButtonItem itemWithLabel:@"Edit Address" action:^{
        
                        [self dismissViewControllerAnimated:YES completion:nil];
                        [self pushAddressDetailViewController];

    }], nil] showInView:self.view];

}

- (void)pushAddressDetailViewController
{
    //push self navingationController to new view
    TRMAddressDetailViewController *addressDetailViewController = [[TRMAddressDetailViewController alloc] initWithNibName:@"TRMAddressDetailViewController" bundle:nil];
    [addressDetailViewController setEdgesForExtendedLayout:UIRectEdgeNone];
    if (_selectedAddress) {
        [addressDetailViewController setAddress:_selectedAddress];
    } else {
        [addressDetailViewController setAddress:nil];
    }
    
    [[self navigationController] pushViewController:addressDetailViewController animated:YES];
}

- (IBAction)addAddressButton:(id)sender
{
    //push self navingationController to new view
    [self pushAddressDetailViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
