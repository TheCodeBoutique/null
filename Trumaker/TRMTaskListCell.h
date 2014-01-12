//
//  TRMTaskListCell.h
//  Trumaker
//
//  Created by Kyle Carriedo on 1/11/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRMTaskListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIImageView *taskImage;
@property (strong, nonatomic) IBOutlet UIImageView *bridgeImage;
@property (nonatomic, assign) BOOL isDisabled;
@property (nonatomic, assign) BOOL isLastCell;
@end
