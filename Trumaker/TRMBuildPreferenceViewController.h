//
//  TRMBuildPreferenceViewController.h
//  Trumaker
//
//  Created by Kyle Carriedo on 1/15/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRMBuildPreferenceViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *selectedConfigurationTitle; //use to pass cell title between viewcontrollers
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end
