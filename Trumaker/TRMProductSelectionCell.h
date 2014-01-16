//
//  TRMProductSelectionCell.h
//  Trumaker
//
//  Created by Kyle Carriedo on 1/14/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRMProductModel.h"

@interface TRMProductSelectionCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *productImage;
@property (strong, nonatomic) IBOutlet UILabel *productTitle;
@property (strong, nonatomic) IBOutlet UIView *badgeView;
@property (strong, nonatomic) IBOutlet UILabel *badgeCount;

//helper when the user selects the cell we have reference to the model
@property (strong , nonatomic) TRMProductModel *proudct;
@end
