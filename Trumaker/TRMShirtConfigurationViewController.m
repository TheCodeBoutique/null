//
//  TRMShirtConfigurationViewController.m
//  Trumaker
//
//  Created by Marin Fischer on 1/19/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMShirtConfigurationViewController.h"
#import "TRMCoreApi.h"
#import "TRMBuildPreferenceViewController.h"
#import "TRMShirtConfigurationCell.h"

@interface TRMShirtConfigurationViewController ()

@end

@implementation TRMShirtConfigurationViewController
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
    //create the data source from the selected shirts*****************
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//make a cell for each shirt in the array
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return the selected shirts array count
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //create a cell if there isnt one, or use a pre-existing one if we already have one
    static NSString *CellIdentifier = @"shirtConfigurationCell";
    TRMShirtConfigurationCell *cell = (TRMShirtConfigurationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"TRMShirtConfigurationCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:0];
    }
    
    //set the cell's text to item in the array
//    [[cell shirtName] setText:[selectedShirtsArray objectAtIndex:indexPath.row]];
//    [[cell shirtImage] setImage:[_selectedImages objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //push self navingationController to new view
    TRMBuildPreferenceViewController *buildPreferenceViewController = [[TRMBuildPreferenceViewController alloc] initWithNibName:@"TRMBuildPreferenceViewController" bundle:nil];
    [buildPreferenceViewController setEdgesForExtendedLayout:UIRectEdgeNone];
    
    [[self navigationController] pushViewController:buildPreferenceViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
