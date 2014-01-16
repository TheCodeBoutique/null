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

@interface TRMProductSelectionViewController ()<UISearchBarDelegate>
@property (nonatomic, strong) NSMutableArray *products;
@property (nonatomic, strong) NSMutableArray *selectedProducts;
@property (nonatomic, strong) UISearchBar *searchBar;

//we need to keep a copy of products around for search
@property (nonatomic, strong)  NSMutableArray *cpyOfProducts;
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
    
    //Setup search bar for product selection
    [[self collectionView] registerClass:[TRMProductSelectionSearchView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"searchCell"];
    
    //Configure Flow Layout
    [self configureCollectionViewFlowLayout];
    
    //update products with products from the server
    self.products = [[TRMCoreApi sharedInstance] products];
    
    //keep a local copy around for search
     _cpyOfProducts = [_products mutableCopy];
    
    //add shopping cart button
    UIButton *cartButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    [[cartButton layer] setBorderWidth:1.5];
    [cartButton addTarget:self action:@selector(didTapShoppingCart:) forControlEvents:UIControlEventTouchUpInside];
    [cartButton setImage:[UIImage imageNamed:@"cart"] forState:UIControlStateNormal];
    
    TRMBadgeView *badgeView = [[TRMBadgeView alloc] initWithFrame:CGRectMake(0, 0, 20.0f, 20.0f)];
    [[badgeView badgeCount] setText:@"4"];
    [cartButton addSubview:badgeView];
    
    UIBarButtonItem *shoppingCartButton = [[UIBarButtonItem alloc] initWithCustomView:cartButton];

    [[self navigationItem] setRightBarButtonItem:shoppingCartButton];
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    TRMProductSelectionSearchView *headerView = [[self collectionView] dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"searchCell" forIndexPath:indexPath];
    
    [[headerView searchBar] setDelegate:self];
    return headerView;
}

-(void)didTapShoppingCart:(id)sender {

    TRMShopingCartViewController *shopingCartViewController = [[TRMShopingCartViewController alloc] initWithNibName:@"TRMShopingCartViewController" bundle:nil];
    [self removeDuplicatesFromArray:_selectedProducts];
    [shopingCartViewController setSelectedProducts:_selectedProducts];
    [shopingCartViewController setEdgesForExtendedLayout:UIRectEdgeNone];
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
    
    //update collection view
    [[self collectionView] reloadData];
}

#pragma mark Filter Products
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsSearchResultsButton:YES];
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar {
    NSArray *array = _products;
    NSPredicate *configPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@",[searchBar text]];
    NSArray *results = [array filteredArrayUsingPredicate:configPredicate];
    if ([results count] > 0) {
        _products = [[NSMutableArray alloc] initWithArray:results];
        [[self collectionView] reloadData];
    }
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
