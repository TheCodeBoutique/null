//
//  TRMShopingCartViewController.h
//  Trumaker
//
//  Created by Kyle Carriedo on 1/14/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRMProductSelectionViewController.h"
@interface TRMShopingCartViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *selectedProducts;

//for reference
@property (strong, nonatomic) TRMProductSelectionViewController *productSelectionViewController;
@end
