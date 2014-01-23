//
//  TRMDashboardViewController.h
//  Trumaker
//
//  Created by Marin Fischer on 1/7/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRMProfileImageView.h"
@interface TRMDashboardViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) UIImagePickerController *picker;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *heroImage;
@property (weak, nonatomic) IBOutlet UILabel *outfitterName;
@property (weak, nonatomic) IBOutlet UILabel *outfitterLocation;
@property (strong, nonatomic) IBOutlet TRMProfileImageView *outfitterImageView;
@end
