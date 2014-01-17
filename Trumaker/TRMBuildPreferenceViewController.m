//
//  TRMBuildPreferenceViewController.m
//  Trumaker
//
//  Created by Kyle Carriedo on 1/15/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMBuildPreferenceViewController.h"
#import "TRMCoreApi.h"
#import "TRMConfigurationModel.h"
#import "UIImageView+WebCache.h"
#import "TRMBuildPreferenceDetailViewController.h"

@interface TRMBuildPreferenceViewController () <TRMBuildPreferenceDetailDelegate>
@property(nonatomic, strong) NSMutableArray *buildConfigurationsTypeArray;
@property (nonatomic, strong) NSIndexPath *currentSelectedIndex;
@end

@implementation TRMBuildPreferenceViewController
@synthesize buildConfigurationsTypeArray;

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
    
     buildConfigurationsTypeArray = [[NSMutableArray alloc] initWithObjects:@"Fit", @"Collar", @"Cuffs", @"Pocket", @"Placket", @"Pleat", @"Length", @"Monogram", nil];
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//make a cell for each item in the array
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [buildConfigurationsTypeArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //create a cell if there isnt one, or use a pre-existing one if we already have one
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //set the cell's text to item in the array
    [[cell textLabel] setText:[buildConfigurationsTypeArray objectAtIndex:indexPath.row]];
    
        return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //push self navingationController to new view
    TRMBuildPreferenceDetailViewController *buildPreferenceDetailViewController = [[TRMBuildPreferenceDetailViewController alloc] init];
    [buildPreferenceDetailViewController setDelgate:self];
    
    //get the title of the current cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellTitle = cell.textLabel.text;
    
    //pass the title to the detailTableView to use in sort predicate
    [buildPreferenceDetailViewController setSelectedConfigurationName:cellTitle];
    
    _currentSelectedIndex = indexPath;
    
    //push the detailView onto the screen
    [[self navigationController] pushViewController:buildPreferenceDetailViewController animated:YES];
}

-(void)didSelectConfiguration:(NSString *)selectedConfiguration
{
    //update the cell with the new info (update the array)

    [buildConfigurationsTypeArray replaceObjectAtIndex:_currentSelectedIndex.row withObject:selectedConfiguration];
    
    [[self tableView] reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
