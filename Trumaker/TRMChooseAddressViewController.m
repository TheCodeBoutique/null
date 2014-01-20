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
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)addAddressButton:(id)sender;
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
        NSMutableArray *addresses = [[[TRMCoreApi sharedInstance] customer] addresses];
        [tableViewDataSource addObject:addresses];
        
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
    
    [[cell detailTextLabel] setText:@"12345 State Street"];
    [[cell textLabel] setText:@"Home:"];
    
    //set the cell's text to item in the array
  //  [[cell address] setText:[tableViewDataSource objectAtIndex:indexPath.row]];
    
    [[self tableView] setTableFooterView:_tableFooterView];
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushAddressDetailViewController
{
    //push self navingationController to new view
    TRMAddressDetailViewController *addressDetailViewController = [[TRMAddressDetailViewController alloc] initWithNibName:@"TRMAddressDetailViewController" bundle:nil];
    [addressDetailViewController setEdgesForExtendedLayout:UIRectEdgeNone];
    
    [[self navigationController] pushViewController:addressDetailViewController animated:YES];
}

- (IBAction)addAddressButton:(id)sender
{
    //push self navingationController to new view
    [self pushAddressDetailViewController];
}
@end
