//
//  TRMProductSelectionViewController.h
//  Trumaker
//
//  Created by Kyle Carriedo on 1/14/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRMProductSelectionViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIButton *shoppingCartButton;
@property (strong, nonatomic) IBOutlet UILabel *badgeLabel;
@property (nonatomic, strong) NSMutableArray *selectedProducts;

-(IBAction)didTapShoppingCart:(id)sender;
-(void)updateBadge;
@end
