//
//  TRMBuildPreferenceDetailViewController.m
//  Trumaker
//
//  Created by Marin Fischer on 1/15/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMBuildPreferenceDetailViewController.h"
#import "TRMCoreApi.h"
#import "TRMBuildPreferenceItem.h"
#import "TRMBuildPreferenceViewController.h"
#import "UIImageView+WebCache.h"
#import "TRMConfigurationModel.h"

@interface TRMBuildPreferenceDetailViewController ()
@property (nonatomic, strong) NSArray *sortedConfigurationsArray;

@end

@implementation TRMBuildPreferenceDetailViewController
@synthesize sortedConfigurationsArray;

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
  sortedConfigurationsArray = [self sortCustomizationsArray];
}

//filter the entire customizations array based upon the cell you selected
- (NSArray *)sortCustomizationsArray
{
    //get all the customization in an array
    NSMutableArray *allConfigurationsArray = [[TRMCoreApi sharedInstance] configurations];
    
    //create a sortpredicate so the cell title matches the custom_type_name
    NSPredicate *sortPredicate = [NSPredicate predicateWithFormat:@"custom_type_name == [c] %@", _selectedConfigurationName];
    
    //use the predicate to filter the array by custom_type_name
    NSArray *filteredConfigurationsArray = [allConfigurationsArray filteredArrayUsingPredicate:sortPredicate];
    
    //get the custom_type_name filtered array
    return filteredConfigurationsArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//make a cell for each item in the array
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [sortedConfigurationsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
     //set the cell's text to item in the array
    TRMConfigurationModel *buildPreferenceItem = [[self sortedConfigurationsArray] objectAtIndex:indexPath.row];
    
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@", [buildPreferenceItem name]]];
    [[cell imageView] setImageWithURL:[NSURL URLWithString:[buildPreferenceItem outfit_url]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    //set the cell's image to the items image in the array
//    NSString *image = [NSString stringWithFormat:@"%@", buildPreferenceItem.image_url];
//    
//    cell.imageView.image = [UIImage imageNamed:image];
//    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //push self navingationController back to build preference list
    
    //get the title of the current cell
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellTitle = selectedCell.textLabel.text;
    
    //pass the title to the delegate and use index path property
    [[self delgate] didSelectConfiguration:cellTitle];
    
    [[self navigationController] popToRootViewControllerAnimated:YES];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
