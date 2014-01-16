//
//  TRMShoppingCartCell.h
//  Trumaker
//
//  Created by Kyle Carriedo on 1/15/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRMProductModel.h"

@interface TRMShoppingCartCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *productTitle;
@property (strong, nonatomic) IBOutlet UIImageView *productImage;
@property (strong, nonatomic) IBOutlet UITextField *selectQuanity;
@property (strong, nonatomic) IBOutlet UILabel *selectionCount;
@property (strong, nonatomic) IBOutlet UIView *badgeView;

//private
@property (strong, nonatomic) IBOutlet TRMProductModel *product;
@end
