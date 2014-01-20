//
//  TRMProductSelectionViewController.m
//  Trumaker
//
//  Created by Kyle Carriedo on 1/14/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMProductSelectionViewController.h"
#import "TRMShopingCartViewController.h"
#import "TRMProductSelectionCell.h"
#import "TRMProductSelectionSearchView.h"
#import "TRMCoreApi.h"
#import "UIImageView+WebCache.h"
#import "TRMBadgeView.h"
#import "TRMAppDelegate.h"
#import "TRMProductsDAO.h"
#import "TRMCustomerModel.h"
#import "MBProgressHUD.h"

@interface TRMProductSelectionViewController ()
@property (nonatomic, strong) NSMutableArray *products;
@end

@implementation TRMProductSelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _selectedProducts = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.collectionView registerClass:[TRMProductSelectionCell class] forCellWithReuseIdentifier:@"productSelectionCell"];
    
    //Configure Flow Layout
    [self configureCollectionViewFlowLayout];
    
    //update products with products from the server
    self.products = [[TRMCoreApi sharedInstance] products];

    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(didTapSave:)];
    
    TRMAppDelegate *del = [[UIApplication sharedApplication] delegate];
    [[self navigationItem] setLeftBarButtonItem:[del menuBarButton]];
    
    [[self navigationItem] setRightBarButtonItem:saveButton];
}

-(void)didTapSave:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[[[UIApplication sharedApplication] keyWindow] rootViewController] view] animated:YES];
    [hud setMode:MBProgressHUDModeIndeterminate];
    [hud show:YES];
    [hud setLabelText:NSLocalizedString(@"Processing...", @"Processing...")];
    
    TRMCustomerModel *customer = [[TRMCoreApi sharedInstance] customer];
    int orderItem = [[customer idForOrder] intValue];
    [[[TRMProductsDAO alloc] init] saveSelectedProducts:_selectedProducts withOrderId:orderItem completionHandler:^(TRMProductModel *order, NSError *error) {
        if (!error) {
            
        }
        [hud hide:YES];
    }];
}

-(IBAction)didTapShoppingCart:(id)sender {

    TRMShopingCartViewController *shopingCartViewController = [[TRMShopingCartViewController alloc] initWithNibName:@"TRMShopingCartViewController" bundle:nil];
    [self removeDuplicatesFromArray:_selectedProducts];
    [shopingCartViewController setSelectedProducts:_selectedProducts];
    [shopingCartViewController setEdgesForExtendedLayout:UIRectEdgeNone];
    [shopingCartViewController setProductSelectionViewController:self];

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:shopingCartViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

-(void)configureCollectionViewFlowLayout
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(160, 203)];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [flowLayout setHeaderReferenceSize:CGSizeMake(320, 44.0f)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.collectionView setCollectionViewLayout:flowLayout];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_products count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Setup cell identifier
    static NSString *cellIdentifier = @"productSelectionCell";
    TRMProductSelectionCell *cell = (TRMProductSelectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    TRMProductModel *currentProductToRender = [_products objectAtIndex:indexPath.row];
    [cell setProudct:currentProductToRender];
    [[cell productTitle] setText:[currentProductToRender parseTitle]];
    
    [[cell productImage] setImageWithURL:[NSURL URLWithString:[[currentProductToRender image_ids] objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"placeholder_image"]];
    
    [[cell badgeView] setHidden:![[cell proudct] isSelected]];
    [[cell badgeCount] setText:[NSString stringWithFormat:@"%@",[[cell proudct] selectedCount]]];
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TRMProductSelectionCell *selectedCell = (TRMProductSelectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [[selectedCell proudct] setIsSelected:YES];
    [[selectedCell proudct] incrementSelectedCount];
    
    //added product to selected products array to be used in shopping cart
    [_selectedProducts addObject:[selectedCell proudct]];
    
    [self updateBadge];
    
    //update collection view
    [[self collectionView] reloadData];
}

-(void)updateBadge {
    if ([_selectedProducts count] > 0) {
        [_badgeLabel setHidden:NO];
    } else {
        [_badgeLabel setHidden:YES];
    }
    [_badgeLabel setText:[NSString stringWithFormat:@"%d",[_selectedProducts count]]];
}

#pragma mark Helpers
-(void)removeDuplicatesFromArray:(NSMutableArray *)array {
    NSArray *copy = [_selectedProducts copy];
    NSInteger index = [copy count] - 1;
    for (id object in [copy reverseObjectEnumerator]) {
        if ([_selectedProducts indexOfObject:object inRange:NSMakeRange(0, index)] != NSNotFound) {
            [_selectedProducts removeObjectAtIndex:index];
        }
        index--;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
