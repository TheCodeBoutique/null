//
//  TRMDashboardTableViewCell.h
//  Trumaker
//
//  Created by Marin Fischer on 1/7/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRMDashboardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;
@property (nonatomic, assign) BOOL isLastCell;
@end
