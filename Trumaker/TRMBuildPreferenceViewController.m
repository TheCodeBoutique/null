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
#import "TRMBuildPreferenceDetailCell.h"
#import "TRMUtils.h"

@interface TRMBuildPreferenceViewController () <TRMBuildPreferenceDetailDelegate>
@property(nonatomic, strong) NSMutableArray *buildConfigurationsTypeArray;
@property(nonatomic, strong) NSMutableArray *selectedImages;
@property (nonatomic, strong) NSIndexPath *currentSelectedIndex;
@property (nonatomic, strong) NSMutableArray *selectionList;
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
    
    NSMutableArray *allConfigurationsArray = [[TRMCoreApi sharedInstance] configurations];
    
    NSMutableArray *allCustomTypes = [[NSMutableArray alloc] init];
    [allConfigurationsArray enumerateObjectsUsingBlock:^(TRMConfigurationModel *configurationModel, NSUInteger idx, BOOL *stop) {
        NSString *type = [configurationModel custom_type_name];
        [allCustomTypes addObject:type];
    }];
    
    //remove all duplicates
    [TRMUtils removeDuplicatesFromArray:allCustomTypes];
    
    //copy default
    _selectionList = [allCustomTypes mutableCopy];
    
    //set data source
     buildConfigurationsTypeArray = allCustomTypes;
    
    //selected images
    _selectedImages = [[NSMutableArray alloc] init];
    for (int i = 0; i < [buildConfigurationsTypeArray count]; i++) {
        
        [_selectedImages addObject:[UIImage imageNamed:@"placeholder"]];
    }
    
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
    static NSString *CellIdentifier = @"buildDetailCell";
    TRMBuildPreferenceDetailCell *cell = (TRMBuildPreferenceDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TRMBuildPreferenceDetailCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //set the cell's text to item in the array
    [[cell configurationTitle] setText:[buildConfigurationsTypeArray objectAtIndex:indexPath.row]];
    [[cell produtImage] setImage:[_selectedImages objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //push self navingationController to new view
    TRMBuildPreferenceDetailViewController *buildPreferenceDetailViewController = [[TRMBuildPreferenceDetailViewController alloc] initWithNibName:@"TRMBuildPreferenceDetailViewController" bundle:nil];
    [buildPreferenceDetailViewController setEdgesForExtendedLayout:UIRectEdgeNone];
    
    [buildPreferenceDetailViewController setDelgate:self];
    
    
    //pass the title to the detailTableView to use in sort predicate
    [buildPreferenceDetailViewController setSelectedConfigurationName:[_selectionList objectAtIndex:indexPath.row]];
    
    _currentSelectedIndex = indexPath;
    
    //push the detailView onto the screen
    [[self navigationController] pushViewController:buildPreferenceDetailViewController animated:YES];
}

-(void)didSelectConfiguration:(NSString *)selectedConfiguration withImage:(UIImage *)selectedImage
{
    //update the cell with the new info (update the array)

    [buildConfigurationsTypeArray replaceObjectAtIndex:_currentSelectedIndex.row withObject:selectedConfiguration];
    [_selectedImages replaceObjectAtIndex:_currentSelectedIndex.row withObject:selectedImage];
    
    [[self tableView] reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
